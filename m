Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3BBGvn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 01:51:43 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:55809 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab3BBGvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 01:51:40 -0500
Message-ID: <510CB772.80908@huawei.com>
Date: Sat, 2 Feb 2013 14:51:30 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH 3/4] eventfd: make operations on eventfd return -EIDRM if
 it's hung up
References: <510CB733.2080904@huawei.com>
In-Reply-To: <510CB733.2080904@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently when a cgroup is removed, it calls eventfd_signal() for
each registered cgroup event, so userspace can be notified and blocked
reads can be unblocked.

The problem is, if we have multiple threads blocked on the same eventfd,
only one of them will be unlocked.

This patch makes sure all operations on the same eventfd can be unbocked.

There's another problem, a new cgroup event can be registered while we
are removing the cgroup, and then reading the eventfd will be blocked
until the thread is killed. This patch also fixes this issue.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 fs/eventfd.c    | 23 +++++++++++++++++++++--
 kernel/cgroup.c |  1 -
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index acf15e3..48de15a 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -35,6 +35,7 @@ struct eventfd_ctx {
 	 */
 	__u64 count;
 	unsigned int flags;
+	bool hung_up;
 };
 
 /**
@@ -71,11 +72,19 @@ EXPORT_SYMBOL_GPL(eventfd_signal);
  * eventfd_signal_hangup - Notify that this eventfd is hung up.
  * @ctx: [in] Pointer to the eventfd context.
  *
- * Issue a POLLHUP wakeup.
+ * Issue a POLLHUP wakeup. All current blocked reads, writes and polls on
+ * this eventfd will return with -EIDRM. Future operations on it will also
+ * return with -EDIRM.
  */
 void eventfd_signal_hangup(struct eventfd_ctx *ctx)
 {
-	wake_up_poll(&ctx->wqh, POLLHUP);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->wqh.lock, flags);
+	ctx->hung_up = true;
+	if (waitqueue_active(&ctx->wqh))
+		wake_up_locked_poll(&ctx->wqh, POLLHUP);
+	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 }
 
 static void eventfd_free_ctx(struct eventfd_ctx *ctx)
@@ -140,6 +149,8 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
 		events |= POLLERR;
 	if (ULLONG_MAX - 1 > ctx->count)
 		events |= POLLOUT;
+	if (ctx->hung_up)
+		events |= POLLHUP;
 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
@@ -208,6 +219,10 @@ ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt)
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
+			if (ctx->hung_up) {
+				res = -EIDRM;
+				break;
+			}
 			if (ctx->count > 0) {
 				res = 0;
 				break;
@@ -272,6 +287,10 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 		__add_wait_queue(&ctx->wqh, &wait);
 		for (res = 0;;) {
 			set_current_state(TASK_INTERRUPTIBLE);
+			if (ctx->hung_up) {
+				res = -EIDRM;
+				break;
+			}
 			if (ULLONG_MAX - ctx->count > ucnt) {
 				res = sizeof(ucnt);
 				break;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index a3d361b..fcb1ab6 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4373,7 +4373,6 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 		ctx = eventfd_ctx_get(event->eventfd);
 		spin_unlock(&cgrp->event_list_lock);
 
-		eventfd_signal(ctx, 1);
 		eventfd_signal_hangup(ctx);
 		eventfd_ctx_put(ctx);
 
-- 
1.8.0.2
