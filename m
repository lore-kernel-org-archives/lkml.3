Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab3BBGu6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 01:50:58 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:22734 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3BBGuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 01:50:54 -0500
Message-ID: <510CB744.7000300@huawei.com>
Date: Sat, 2 Feb 2013 14:50:44 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
References: <510CB733.2080904@huawei.com>
In-Reply-To: <510CB733.2080904@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an eventfd is closed, a wakeup with POLLHUP will be issued,
but cgroup wants to issue wakeup explicitly, so when a cgroup is
removed userspace can be notified.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/eventfd.c            | 11 +++++++++++
 include/linux/eventfd.h |  5 +++++
 2 files changed, 16 insertions(+)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index 35470d9..acf15e3 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -67,6 +67,17 @@ __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n)
 }
 EXPORT_SYMBOL_GPL(eventfd_signal);
 
+/**
+ * eventfd_signal_hangup - Notify that this eventfd is hung up.
+ * @ctx: [in] Pointer to the eventfd context.
+ *
+ * Issue a POLLHUP wakeup.
+ */
+void eventfd_signal_hangup(struct eventfd_ctx *ctx)
+{
+	wake_up_poll(&ctx->wqh, POLLHUP);
+}
+
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
 {
 	kfree(ctx);
diff --git a/include/linux/eventfd.h b/include/linux/eventfd.h
index 3c3ef19..68af706 100644
--- a/include/linux/eventfd.h
+++ b/include/linux/eventfd.h
@@ -35,6 +35,7 @@ struct file *eventfd_fget(int fd);
 struct eventfd_ctx *eventfd_ctx_fdget(int fd);
 struct eventfd_ctx *eventfd_ctx_fileget(struct file *file);
 __u64 eventfd_signal(struct eventfd_ctx *ctx, __u64 n);
+void eventfd_signal_hangup(struct eventfd_ctx *ctx);
 ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt);
 int eventfd_ctx_remove_wait_queue(struct eventfd_ctx *ctx, wait_queue_t *wait,
 				  __u64 *cnt);
@@ -60,6 +61,10 @@ static inline int eventfd_signal(struct eventfd_ctx *ctx, int n)
 	return -ENOSYS;
 }
 
+static inline void eventfd_signal_hangup(struct eventfd_ctx *ctx)
+{
+}
+
 static inline void eventfd_ctx_put(struct eventfd_ctx *ctx)
 {
 
-- 
1.8.0.2
