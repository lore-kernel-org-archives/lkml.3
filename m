Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaASKiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 05:38:13 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:51130 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaASKhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 05:37:34 -0500
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] percpu_ida: Make percpu_ida_alloc accept task state bitmask
Date: Sun, 19 Jan 2014 10:16:52 +0000
Message-Id: <1390126616-29560-2-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
References: <1390126616-29560-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

This patch changes percpu_ida_alloc() to accept task state bitmask
for prepare_to_wait() to support interruptible sleep for callers
that require it.

Previously, this code was assuming uninterruptible sleep for all cases
thus preventing signals from being delivered to a scheduled process
context in the tag stealing slow path.

It now accepts TASK_INTERRUPTIBLE or TASK_UNINTERRUPTIBLE when the
caller is able to sleep waiting for a new tag, or TASK_RUNNING when
the caller cannot sleep, and is forced to return a negative tag.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: <stable@vger.kernel.org> #3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/percpu_ida.h |    3 ++-
 lib/percpu_ida.c           |   17 +++++++++++------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 1900bd0..f5cfdd6 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -4,6 +4,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/init.h>
+#include <linux/sched.h>
 #include <linux/spinlock_types.h>
 #include <linux/wait.h>
 #include <linux/cpumask.h>
@@ -61,7 +62,7 @@ struct percpu_ida {
 /* Max size of percpu freelist, */
 #define IDA_DEFAULT_PCPU_SIZE	((IDA_DEFAULT_PCPU_BATCH_MOVE * 3) / 2)
 
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp);
+int percpu_ida_alloc(struct percpu_ida *pool, int state);
 void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
 
 void percpu_ida_destroy(struct percpu_ida *pool);
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 9d054bf..4579749 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -132,22 +132,22 @@ static inline unsigned alloc_local_tag(struct percpu_ida_cpu *tags)
 /**
  * percpu_ida_alloc - allocate a tag
  * @pool: pool to allocate from
- * @gfp: gfp flags
+ * @state: task state for prepare_to_wait
  *
  * Returns a tag - an integer in the range [0..nr_tags) (passed to
  * tag_pool_init()), or otherwise -ENOSPC on allocation failure.
  *
  * Safe to be called from interrupt context (assuming it isn't passed
- * __GFP_WAIT, of course).
+ * TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE, of course).
  *
  * @gfp indicates whether or not to wait until a free id is available (it's not
  * used for internal memory allocations); thus if passed __GFP_WAIT we may sleep
  * however long it takes until another thread frees an id (same semantics as a
  * mempool).
  *
- * Will not fail if passed __GFP_WAIT.
+ * Will not fail if passed TASK_INTERRUPTIBLE | TASK_UNINTERRUPTIBLE.
  */
-int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
+int percpu_ida_alloc(struct percpu_ida *pool, int state)
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
-- 
1.7.10.4

