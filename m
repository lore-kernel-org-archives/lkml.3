Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3AVKT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:19:56 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23479 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750723Ab3AVKTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:19:54 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 2/3] signalfd: add ability to choose a private or shared queue
Date: Tue, 22 Jan 2013 14:15:40 +0400
Message-Id: <1358849741-9611-3-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358849741-9611-1-git-send-email-avagin@openvz.org>
References: <1358849741-9611-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is added two flags SFD_SHARED_QUEUE and SFD_PER_THREAD_QUEUE
SFD_SHARED_QUEUE - read signals from a shared (process wide) queue
SFD_PER_THREAD_QUEUE - read signals from a per-thread queue

Without these flags or with both flags signals are read from both queues.

This functionality is required for dumping pending signals.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 fs/signalfd.c                 | 30 ++++++++++++++++++++++--------
 include/uapi/linux/signalfd.h |  4 ++++
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index c723b5d..8019ec9 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -61,13 +61,17 @@ static unsigned int signalfd_poll(struct file *file, poll_table *wait)
 {
 	struct signalfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
+	unsigned int flags = file->f_flags;
 
 	poll_wait(file, &current->sighand->signalfd_wqh, wait);
 
 	spin_lock_irq(&current->sighand->siglock);
-	if (next_signal(&current->pending, &ctx->sigmask) ||
-	    next_signal(&current->signal->shared_pending,
-			&ctx->sigmask))
+	if ((flags & SFD_PER_THREAD_QUEUE) &&
+	     next_signal(&current->pending, &ctx->sigmask))
+		events |= POLLIN;
+
+	if ((flags & SFD_SHARED_QUEUE) &&
+	     next_signal(&current->signal->shared_pending, &ctx->sigmask))
 		events |= POLLIN;
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -189,13 +193,13 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 }
 
 static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
-				int nonblock)
+				int nonblock, int qmask)
 {
 	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
 
 	spin_lock_irq(&current->sighand->siglock);
-	ret = dequeue_signal(current, &ctx->sigmask, info);
+	ret = do_dequeue_signal(current, &ctx->sigmask, info, qmask);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -209,7 +213,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(current, &ctx->sigmask, info);
+		ret = do_dequeue_signal(current, &ctx->sigmask, info, qmask);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
@@ -240,16 +244,23 @@ static ssize_t signalfd_read(struct file *file, char __user *buf, size_t count,
 	struct signalfd_siginfo __user *siginfo;
 	int nonblock = file->f_flags & O_NONBLOCK;
 	bool raw = file->f_flags & SFD_RAW;
+	int qmask = 0;
 	ssize_t ret, total = 0;
 	siginfo_t info;
 
+	if (file->f_flags & SFD_PER_THREAD_QUEUE)
+		qmask |= SIGQUEUE_PRIVATE;
+	if (file->f_flags & SFD_SHARED_QUEUE)
+		qmask |= SIGQUEUE_SHARED;
+
 	count /= sizeof(struct signalfd_siginfo);
 	if (!count)
 		return -EINVAL;
 
 	siginfo = (struct signalfd_siginfo __user *) buf;
 	do {
-		ret = signalfd_dequeue(ctx, &info, nonblock);
+		ret = signalfd_dequeue(ctx, &info, nonblock, qmask);
+
 		if (unlikely(ret <= 0))
 			break;
 
@@ -292,6 +303,8 @@ static const struct file_operations signalfd_fops = {
 	.llseek		= noop_llseek,
 };
 
+#define SFD_QUEUES (SFD_SHARED_QUEUE | SFD_PER_THREAD_QUEUE)
+
 SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 		size_t, sizemask, int, flags)
 {
@@ -302,7 +315,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 	BUILD_BUG_ON(SFD_CLOEXEC != O_CLOEXEC);
 	BUILD_BUG_ON(SFD_NONBLOCK != O_NONBLOCK);
 
-	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW))
+	if (flags & ~(SFD_CLOEXEC | SFD_NONBLOCK | SFD_RAW | SFD_QUEUES))
 		return -EINVAL;
 
 	if (sizemask != sizeof(sigset_t) ||
@@ -338,6 +351,7 @@ SYSCALL_DEFINE4(signalfd4, int, ufd, sigset_t __user *, user_mask,
 			goto out;
 		}
 
+		file->f_flags |= (flags & SFD_QUEUES) ? : SFD_QUEUES;
 		file->f_flags |= flags & SFD_RAW;
 
 		fd_install(ufd, file);
diff --git a/include/uapi/linux/signalfd.h b/include/uapi/linux/signalfd.h
index bc31849..481b658 100644
--- a/include/uapi/linux/signalfd.h
+++ b/include/uapi/linux/signalfd.h
@@ -16,6 +16,10 @@
 #define SFD_CLOEXEC O_CLOEXEC
 #define SFD_NONBLOCK O_NONBLOCK
 #define SFD_RAW O_DIRECT
+/* Read signals from a shared (process wide) queue */
+#define SFD_SHARED_QUEUE O_DIRECTORY
+/* Read signals from a per-thread queue */
+#define SFD_PER_THREAD_QUEUE O_EXCL
 
 struct signalfd_siginfo {
 	__u32 ssi_signo;
-- 
1.7.11.7

