Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaAJDVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 22:21:07 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:39426 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaAJDVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 22:21:05 -0500
From: "Nicholas A. Bellinger" <nab@daterainc.com>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 1/3] percpu_ida: Add tag alloc interface for interruptible sleep
Date: Fri, 10 Jan 2014 03:00:45 +0000
Message-Id: <1389322847-6570-2-git-send-email-nab@daterainc.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1389322847-6570-1-git-send-email-nab@daterainc.com>
References: <1389322847-6570-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

This patch adds an tag allocation interface that allows for
interruptible sleep with GFP_KERNEL, instead of always assuming
uninterruptible sleep preventing a signal from being delivered
to a scheduled process context in the tag stealing slow path.

This includes a wrapper for backwards compatiblity with
existing percpu_ida_alloc() consumers.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/percpu_ida.h |   11 ++++++++++-
 lib/percpu_ida.c           |   13 +++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 1900bd0..bcf31a5 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -3,7 +3,9 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include <linux/gfp.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/spinlock_types.h>
 #include <linux/wait.h>
 #include <linux/cpumask.h>
@@ -61,9 +63,16 @@ struct percpu_ida {
 /* Max size of percpu freelist, */
 #define IDA_DEFAULT_PCPU_SIZE	((IDA_DEFAULT_PCPU_BATCH_MOVE * 3) / 2)
 
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
+int percpu_ida_alloc_state(struct percpu_ida *pool, int state);
 void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
 
+static inline int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
+{
+	return percpu_ida_alloc_state(pool, (gfp & __GFP_WAIT)
+				      ? TASK_UNINTERRUPTIBLE
+				      : TASK_RUNNING);
+}
+
 void percpu_ida_destroy(struct percpu_ida *pool);
 int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
 	unsigned long max_size, unsigned long batch_size);
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 9d054bf..58b2268 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -147,7 +147,7 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
  *
  * Will not fail if passed __GFP_WAIT.
  */
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
+int percpu_ida_alloc_state(struct percpu_ida *pool, int state)
 {
 	DEFINE_WAIT(wait);
 	struct percpu_ida_cpu *tags;
@@ -174,7 +174,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 		 *
 		 * global lock held and irqs disabled, don't need percpu lock
 		 */
-		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
+		prepare_to_wait(&pool->wait, &wait, state);
 
 		if (!tags->nr_free)
 			alloc_global_tags(pool, tags);
@@ -191,9 +191,14 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 		spin_unlock(&pool->lock);
 		local_irq_restore(flags);
 
-		if (tag >= 0 || !(gfp & __GFP_WAIT))
+		if (tag >= 0 || state == TASK_RUNNING)
 			break;
 
+		if (signal_pending_state(state, current)) {
+			tag = -ERESTARTSYS;
+			break;
+		}
+
 		schedule();
 
 		local_irq_save(flags);
@@ -203,7 +208,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
 	finish_wait(&pool->wait, &wait);
 	return tag;
 }
-EXPORT_SYMBOL_GPL(percpu_ida_alloc);
+EXPORT_SYMBOL_GPL(percpu_ida_alloc_state);
 
 /**
  * percpu_ida_free - free a tag
-- 
1.7.10.4

