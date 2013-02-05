Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab3BEMCz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 07:02:55 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:39467 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3BEMCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 07:02:50 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-api@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [PATCH 1/3] signal: add a helper for dequeuing signals from a specified queue (v2)
Date: Tue,  5 Feb 2013 13:00:14 +0100
Message-Id: <1360065614-1496-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358849741-9611-2-git-send-email-avagin@openvz.org>
References: <1358849741-9611-2-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: export the symbol do_dequeue_signal

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/linux/sched.h | 13 ++++++++++++-
 kernel/signal.c       | 12 +++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 206bb08..45871f1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2221,7 +2221,18 @@ extern void flush_signals(struct task_struct *);
 extern void __flush_signals(struct task_struct *);
 extern void ignore_signals(struct task_struct *);
 extern void flush_signal_handlers(struct task_struct *, int force_default);
-extern int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info);
+
+#define SIGQUEUE_SHARED		1
+#define SIGQUEUE_PRIVATE	2
+extern int do_dequeue_signal(struct task_struct *tsk,
+				sigset_t *mask, siginfo_t *info, int qmask);
+
+static inline int dequeue_signal(struct task_struct *tsk,
+					sigset_t *mask, siginfo_t *info)
+{
+	return do_dequeue_signal(tsk, mask, info,
+					SIGQUEUE_SHARED | SIGQUEUE_PRIVATE);
+}
 
 static inline int dequeue_signal_lock(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
 {
diff --git a/kernel/signal.c b/kernel/signal.c
index ac5f5e7..9d1cfc6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -600,15 +600,17 @@ static int __dequeue_signal(struct sigpending *pending, sigset_t *mask,
  *
  * All callers have to hold the siglock.
  */
-int dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
+int do_dequeue_signal(struct task_struct *tsk, sigset_t *mask,
+					siginfo_t *info, int qmask)
 {
-	int signr;
+	int signr = 0;
 
 	/* We only dequeue private signals from ourselves, we don't let
 	 * signalfd steal them
 	 */
-	signr = __dequeue_signal(&tsk->pending, mask, info);
-	if (!signr) {
+	if (qmask & SIGQUEUE_PRIVATE)
+		signr = __dequeue_signal(&tsk->pending, mask, info);
+	if (!signr && (qmask & SIGQUEUE_SHARED)) {
 		signr = __dequeue_signal(&tsk->signal->shared_pending,
 					 mask, info);
 		/*
@@ -2479,7 +2481,7 @@ out:
 }
 
 EXPORT_SYMBOL(recalc_sigpending);
-EXPORT_SYMBOL_GPL(dequeue_signal);
+EXPORT_SYMBOL_GPL(do_dequeue_signal);
 EXPORT_SYMBOL(flush_signals);
 EXPORT_SYMBOL(force_sig);
 EXPORT_SYMBOL(send_sig);
-- 
1.7.11.7

