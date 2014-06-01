Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaFAVmz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 17:42:55 -0400
Received: from mail.phunq.net ([184.71.0.62]:47828 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810AbaFAVmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 17:42:51 -0400
Message-ID: <538B9E58.4000108@phunq.net>
Date: Sun, 01 Jun 2014 14:42:48 -0700
From: Daniel Phillips <daniel@phunq.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [RFC][PATCH 2/2] tux3: Use writeback hook to remove duplicated core
 code
References: <538B9DEE.20800@phunq.net>
In-Reply-To: <538B9DEE.20800@phunq.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of re-implementing part of fs/fs-writeback.c, use a proposed
net ->writeback super operation to drive delta writeback. For each
inode that is cleaned, call inode_writeback_done(inode). For each
inode that will be kept dirty in cache, call inode_writeback_touch
so that the inode appears young to fs-writeback and does not trigger
repeated ->writeback flushes.

Signed-off-by: Daniel Phillips <daniel@tux3.org>
---
 fs/tux3/Makefile              |   2 +-
 fs/tux3/commit.c              |   1 -
 fs/tux3/commit_flusher.c      | 180 ++++++++++--------
 fs/tux3/commit_flusher.h      |  16 --
 fs/tux3/commit_flusher_hack.c | 423 ------------------------------------------
 fs/tux3/inode.c               |   2 -
 fs/tux3/super.c               |  17 +-
 fs/tux3/tux3.h                |  11 +-
 fs/tux3/writeback.c           |  75 ++------
 11 files changed, 128 insertions(+), 599 deletions(-)
 delete mode 100644 fs/tux3/commit_flusher.h
 delete mode 100644 fs/tux3/commit_flusher_hack.c

diff --git a/fs/tux3/Makefile b/fs/tux3/Makefile
index 9623a54..30faba5 100644
--- a/fs/tux3/Makefile
+++ b/fs/tux3/Makefile
@@ -13,7 +13,7 @@ tux3-objs += balloc.o btree.o buffer.o commit.o dir.o dleaf.o \
 EXTRA_CFLAGS += -Werror -std=gnu99 -Wno-declaration-after-statement
 #EXTRA_CFLAGS += -DTUX3_FLUSHER=TUX3_FLUSHER_SYNC
 #EXTRA_CFLAGS += -DTUX3_FLUSHER=TUX3_FLUSHER_ASYNC_OWN
-EXTRA_CFLAGS += -DTUX3_FLUSHER=TUX3_FLUSHER_ASYNC_HACK
+EXTRA_CFLAGS += -DTUX3_FLUSHER=TUX3_FLUSHER_ASYNC

 obj-$(CONFIG_TUX3_MMAP) += mmap_builtin_hack.o
 endif
diff --git a/fs/tux3/commit.c b/fs/tux3/commit.c
index dd76d49..84e686e 100644
--- a/fs/tux3/commit.c
+++ b/fs/tux3/commit.c
@@ -638,7 +638,6 @@ static void delta_transition(struct sb *sb)
      ((int)(a) - (int)(b) >= 0))

 #include "commit_flusher.c"
-#include "commit_flusher_hack.c"

 int force_unify(struct sb *sb)
 {
diff --git a/fs/tux3/commit_flusher.c b/fs/tux3/commit_flusher.c
index 8e7057d..2d938c5 100644
--- a/fs/tux3/commit_flusher.c
+++ b/fs/tux3/commit_flusher.c
@@ -4,7 +4,7 @@
  * Copyright (c) 2008-2014 OGAWA Hirofumi
  */

-#if TUX3_FLUSHER != TUX3_FLUSHER_ASYNC_HACK
+#if TUX3_FLUSHER == TUX3_FLUSHER_SYNC
 #include "tux3.h"

 static void __tux3_init_flusher(struct sb *sb)
@@ -15,72 +15,6 @@ static void __tux3_init_flusher(struct sb *sb)
 #endif
 }

-#if TUX3_FLUSHER == TUX3_FLUSHER_ASYNC_OWN
-static int flush_delta_work(void *data)
-{
-    struct sb *sb = data;
-    int err;
-
-    set_freezable();
-
-    /*
-     * Our parent may run at a different priority, just set us to normal
-     */
-    set_user_nice(current, 0);
-
-    while (!kthread_freezable_should_stop(NULL)) {
-        if (test_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state)) {
-            clear_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state);
-
-            err = flush_delta(sb);
-            /* FIXME: error handling */
-        }
-
-        set_current_state(TASK_INTERRUPTIBLE);
-        if (!test_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state) &&
-            !kthread_should_stop())
-            schedule();
-        __set_current_state(TASK_RUNNING);
-    }
-
-    return 0;
-}
-
-int tux3_init_flusher(struct sb *sb)
-{
-    struct task_struct *task;
-    char b[BDEVNAME_SIZE];
-
-    __tux3_init_flusher(sb);
-
-    bdevname(vfs_sb(sb)->s_bdev, b);
-
-    /* FIXME: we should use normal bdi-writeback by changing core */
-    task = kthread_run(flush_delta_work, sb, "tux3/%s", b);
-    if (IS_ERR(task))
-        return PTR_ERR(task);
-
-    sb->flush_task = task;
-
-    return 0;
-}
-
-void tux3_exit_flusher(struct sb *sb)
-{
-    if (sb->flush_task) {
-        kthread_stop(sb->flush_task);
-        sb->flush_task = NULL;
-    }
-}
-
-static void schedule_flush_delta(struct sb *sb)
-{
-    /* Start the flusher for pending delta */
-    wake_up_process(sb->flush_task);
-}
-
-#else /* TUX3_FLUSHER != TUX3_FLUSHER_ASYNC_OWN */
-
 int tux3_init_flusher(struct sb *sb)
 {
     __tux3_init_flusher(sb);
@@ -109,7 +43,6 @@ static int flush_pending_delta(struct sb *sb)
 out:
     return err;
 }
-#endif /* TUX3_FLUSHER != TUX3_FLUSHER_ASYNC_OWN */

 /* Try delta transition */
 static void try_delta_transition(struct sb *sb)
@@ -155,10 +88,8 @@ static int try_flush_pending_until_delta(struct sb *sb, unsigned delta)
     trace("delta %u, committed %u, backend_state %lx",
           delta, sb->committed_delta, sb->backend_state);

-#if TUX3_FLUSHER == TUX3_FLUSHER_SYNC
     if (!delta_after_eq(sb->committed_delta, delta))
         flush_pending_delta(sb);
-#endif

     return delta_after_eq(sb->committed_delta, delta);
 }
@@ -175,9 +106,7 @@ static int sync_current_delta(struct sb *sb, enum unify_flags unify_flag)
     unsigned delta;
     int err = 0;

-#if TUX3_FLUSHER == TUX3_FLUSHER_SYNC
     down_write(&sb->delta_lock);
-#endif
     /* Get delta that have to write */
     delta_ref = delta_get(sb);
 #ifdef UNIFY_DEBUG
@@ -197,10 +126,111 @@ static int sync_current_delta(struct sb *sb, enum unify_flags unify_flag)
     /* Wait until committing the current delta */
     err = wait_for_commit(sb, delta);
     assert(err || delta_after_eq(sb->committed_delta, delta));
-#if TUX3_FLUSHER == TUX3_FLUSHER_SYNC
     up_write(&sb->delta_lock);
+    return err;
+}
+
+#else /* TUX3_FLUSHER == TUX3_FLUSHER_ASYNC */
+
+static void try_delta_transition(struct sb *sb)
+{
+#if 0
+    trace("stage %u, backend_state %lx",
+          sb->staging_delta, sb->backend_state);
+    sync_inodes_sb(vfs_sb(sb));
 #endif
+}

-    return err;
+/* Do the delta transition until specified delta */
+static int try_delta_transition_until_delta(struct sb *sb, unsigned delta)
+{
+    trace("delta %u, stage %u, backend_state %lx",
+          delta, sb->staging_delta, sb->backend_state);
+
+    /* Already delta transition was started for delta */
+    if (delta_after_eq(sb->staging_delta, delta))
+        return 1;
+
+    if (!test_and_set_bit(TUX3_COMMIT_RUNNING_BIT, &sb->backend_state)) {
+        /* Recheck after grabed TUX3_COMMIT_RUNNING_BIT */
+        if (delta_after_eq(sb->staging_delta, delta)) {
+            clear_bit(TUX3_COMMIT_RUNNING_BIT, &sb->backend_state);
+            return 1;
+        }
+
+        delta_transition(sb);
+    }
+
+    return delta_after_eq(sb->staging_delta, delta);
 }
-#endif /* TUX3_FLUSHER == TUX3_FLUSHER_ASYNC_HACK */
+
+/* Advance delta transition until specified delta */
+static int wait_for_transition(struct sb *sb, unsigned delta)
+{
+    return wait_event_killable(sb->delta_event_wq,
+        try_delta_transition_until_delta(sb, delta));
+}
+
+long tux3_writeback(struct super_block *super, struct writeback_control *wbc, long *nr_pages)
+{
+    struct sb *sb = tux_sb(super);
+    struct delta_ref *delta_ref;
+    unsigned delta;
+    int err;
+
+    /* If we didn't finish replay yet, don't flush. */
+    if (!(super->s_flags & MS_ACTIVE))
+        return 0;
+
+    /* Get delta that have to write */
+    delta_ref = delta_get(sb);
+#ifdef UNIFY_DEBUG
+    /* NO_UNIFY and FORCE_UNIFY are not supported for now */
+    delta_ref->unify_flag = ALLOW_UNIFY;
+#endif
+    delta = delta_ref->delta;
+    delta_put(sb, delta_ref);
+
+    /* Make sure the delta transition was done for current delta */
+    err = wait_for_transition(sb, delta);
+    if (err)
+        return err;
+    assert(delta_after_eq(sb->staging_delta, delta));
+
+    /* Wait for last referencer of delta was gone */
+    wait_event(sb->delta_event_wq,
+           test_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state));
+
+    if (test_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state)) {
+        clear_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state);
+
+        err = flush_delta(sb);
+        /* FIXME: error handling */
+#if 0
+        /* wb_update_bandwidth() is not exported to module */
+        wb_update_bandwidth(wb, wb_start);
+#endif
+    }
+
+    *nr_pages = 0;
+    return 1;
+}
+
+static int sync_current_delta(struct sb *sb, enum unify_flags unify_flag)
+{
+    /* FORCE_UNIFY is not supported */
+    WARN_ON(unify_flag == FORCE_UNIFY);
+    /* This is called only for fsync, so we can take ->s_umount here */
+    down_read(&vfs_sb(sb)->s_umount);
+    sync_inodes_sb(vfs_sb(sb));
+    up_read(&vfs_sb(sb)->s_umount);
+    return 0;    /* FIXME: error code */
+}
+
+static void schedule_flush_delta(struct sb *sb)
+{
+    /* Wake up waiters for pending delta staging */
+    wake_up_all(&sb->delta_event_wq);
+}
+
+#endif /* TUX3_FLUSHER == TUX3_FLUSHER_ASYNC */
diff --git a/fs/tux3/commit_flusher.h b/fs/tux3/commit_flusher.h
deleted file mode 100644
index 2c0a144..0000000
--- a/fs/tux3/commit_flusher.h
+++ /dev/null
@@ -1,16 +0,0 @@
-#ifndef TUX3_COMMIT_FLUSHER_H
-#define TUX3_COMMIT_FLUSHER_H
-
-/* FIXME: Remove this file after implement of flusher interface */
-
-#if TUX3_FLUSHER == TUX3_FLUSHER_ASYNC_HACK
-/* Hack for BDI_CAP_NO_WRITEBACK */
-void tux3_set_mapping_bdi(struct inode *inode);
-#else
-static inline void tux3_set_mapping_bdi(struct inode *inode) { }
-#endif
-
-int tux3_init_flusher(struct sb *sb);
-void tux3_exit_flusher(struct sb *sb);
-
-#endif /* !TUX3_COMMIT_FLUSHER_H */
diff --git a/fs/tux3/commit_flusher_hack.c b/fs/tux3/commit_flusher_hack.c
deleted file mode 100644
index 08696ed..0000000
--- a/fs/tux3/commit_flusher_hack.c
+++ /dev/null
@@ -1,423 +0,0 @@
-/*
- * FIXME: this is hack to override writeback without patch kernel.
- * We should add proper interfaces to do this, instead. Then, remove
- * this stuff.
- */
-
-#if TUX3_FLUSHER == TUX3_FLUSHER_ASYNC_HACK
-#include "tux3.h"
-#include <linux/kthread.h>
-#include <linux/freezer.h>
-
-void tux3_set_mapping_bdi(struct inode *inode)
-{
-    /*
-     * Hack: set backing_dev_info to use our bdi.
-     */
-    inode->i_mapping->backing_dev_info = inode->i_sb->s_bdi;
-}
-
-/*
- * FIXME: dirty hack for now. We should add callback in writeback task
- * instead of custom bdi.
- */
-struct wb_writeback_work {
-    long nr_pages;
-    struct super_block *sb;
-    unsigned long *older_than_this;
-    enum writeback_sync_modes sync_mode;
-    unsigned int tagged_writepages:1;
-    unsigned int for_kupdate:1;
-    unsigned int range_cyclic:1;
-    unsigned int for_background:1;
-    unsigned int for_sync:1;    /* sync(2) WB_SYNC_ALL writeback */
-    enum wb_reason reason;        /* why was writeback initiated? */
-
-    struct list_head list;        /* pending work list */
-    struct completion *done;    /* set if the caller waits */
-};
-
-/* Do the delta transition until specified delta */
-static int try_delta_transition_until_delta(struct sb *sb, unsigned delta)
-{
-    trace("delta %u, stage %u, backend_state %lx",
-          delta, sb->staging_delta, sb->backend_state);
-
-    /* Already delta transition was started for delta */
-    if (delta_after_eq(sb->staging_delta, delta))
-        return 1;
-
-    if (!test_and_set_bit(TUX3_COMMIT_RUNNING_BIT, &sb->backend_state)) {
-        /* Recheck after grabed TUX3_COMMIT_RUNNING_BIT */
-        if (delta_after_eq(sb->staging_delta, delta)) {
-            clear_bit(TUX3_COMMIT_RUNNING_BIT, &sb->backend_state);
-            return 1;
-        }
-
-        delta_transition(sb);
-    }
-
-    return delta_after_eq(sb->staging_delta, delta);
-}
-
-/* Advance delta transition until specified delta */
-static int wait_for_transition(struct sb *sb, unsigned delta)
-{
-    return wait_event_killable(sb->delta_event_wq,
-                   try_delta_transition_until_delta(sb, delta));
-}
-
-static long tux3_wb_writeback(struct bdi_writeback *wb,
-                  struct wb_writeback_work *work)
-{
-    struct sb *sb = container_of(wb->bdi, struct sb, bdi);
-    struct delta_ref *delta_ref;
-    unsigned delta;
-    int err;
-
-    /* If we didn't finish replay yet, don't flush. */
-    if (!(vfs_sb(sb)->s_flags & MS_ACTIVE))
-        return 0;
-
-    /* Get delta that have to write */
-    delta_ref = delta_get(sb);
-#ifdef UNIFY_DEBUG
-    /* NO_UNIFY and FORCE_UNIFY are not supported for now */
-    delta_ref->unify_flag = ALLOW_UNIFY;
-#endif
-    delta = delta_ref->delta;
-    delta_put(sb, delta_ref);
-
-    /* Make sure the delta transition was done for current delta */
-    err = wait_for_transition(sb, delta);
-    if (err)
-        return err;
-    assert(delta_after_eq(sb->staging_delta, delta));
-
-    /* Wait for last referencer of delta was gone */
-    wait_event(sb->delta_event_wq,
-           test_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state));
-
-    if (test_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state)) {
-        clear_bit(TUX3_COMMIT_PENDING_BIT, &sb->backend_state);
-
-        err = flush_delta(sb);
-        /* FIXME: error handling */
-#if 0
-        /* wb_update_bandwidth() is not exported to module */
-        wb_update_bandwidth(wb, wb_start);
-#endif
-    }
-
-    return 1; /* FIXME: return code */
-}
-
-static bool inode_dirtied_after(struct inode *inode, unsigned long t)
-{
-    bool ret = time_after(inode->dirtied_when, t);
-#ifndef CONFIG_64BIT
-    /*
-     * For inodes being constantly redirtied, dirtied_when can get stuck.
-     * It _appears_ to be in the future, but is actually in distant past.
-     * This test is necessary to prevent such wrapped-around relative times
-     * from permanently stopping the whole bdi writeback.
-     */
-    ret = ret && time_before_eq(inode->dirtied_when, jiffies);
-#endif
-    return ret;
-}
-
-static int tux3_has_old_data(struct bdi_writeback *wb)
-{
-    static unsigned int tux3_dirty_expire_interval = 30 * 100;
-
-    int has_old = 0;
-
-    /*
-     * We don't flush for each inodes. So, we flush all for each
-     * tux3_dirty_expire_interval.
-     *
-     * FIXME: we should pickup only older inodes?
-     */
-    spin_lock(&wb->list_lock);
-    if (wb_has_dirty_io(wb)) {
-        unsigned long older_than_this = jiffies -
-            msecs_to_jiffies(tux3_dirty_expire_interval * 10);
-        struct inode *inode =
-            list_entry(wb->b_dirty.prev, struct inode, i_wb_list);
-
-        if (!inode_dirtied_after(inode, older_than_this))
-            has_old = 1;
-    }
-    spin_unlock(&wb->list_lock);
-
-    return has_old;
-}
-
-static long tux3_wb_check_old_data_flush(struct bdi_writeback *wb)
-{
-    /* Hack: dirty_expire_interval is not exported to module */
-    unsigned long expired;
-
-    /*
-     * When set to zero, disable periodic writeback
-     */
-    if (!dirty_writeback_interval)
-        return 0;
-
-    expired = wb->last_old_flush +
-            msecs_to_jiffies(dirty_writeback_interval * 10);
-    if (time_before(jiffies, expired))
-        return 0;
-
-    wb->last_old_flush = jiffies;
-
-    if (!tux3_has_old_data(wb)) {
-        /*
-         * If now after interval, we return 1 at least, to
-         * avoid to run tux3_wb_check_background_flush().
-         */
-        return 1;
-    }
-
-    struct wb_writeback_work work = {
-        .nr_pages    = 0,
-        .sync_mode    = WB_SYNC_NONE,
-        .for_kupdate    = 1,
-        .range_cyclic    = 1,
-        .reason        = WB_REASON_PERIODIC,
-    };
-
-    return tux3_wb_writeback(wb, &work);
-}
-
-static inline int tux3_over_bground_thresh(struct backing_dev_info *bdi,
-                       long wrote)
-{
-    /*
-     * FIXME: Memory pressure functions are not exported to module.
-     *
-     * So, if we didn't wrote any data on this wakeup, we assume
-     * this wakeup call is from memory pressure.
-     */
-    return !wrote;
-}
-
-static long tux3_wb_check_background_flush(struct bdi_writeback *wb, long wrote)
-{
-    if (tux3_over_bground_thresh(wb->bdi, wrote)) {
-
-        struct wb_writeback_work work = {
-            .nr_pages    = LONG_MAX,
-            .sync_mode    = WB_SYNC_NONE,
-            .for_background    = 1,
-            .range_cyclic    = 1,
-            .reason        = WB_REASON_BACKGROUND,
-        };
-
-        return tux3_wb_writeback(wb, &work);
-    }
-
-    return 0;
-}
-
-static struct wb_writeback_work *
-get_next_work_item(struct backing_dev_info *bdi)
-{
-    struct wb_writeback_work *work = NULL;
-
-    spin_lock_bh(&bdi->wb_lock);
-    if (!list_empty(&bdi->work_list)) {
-        work = list_entry(bdi->work_list.next,
-                  struct wb_writeback_work, list);
-        list_del_init(&work->list);
-    }
-    spin_unlock_bh(&bdi->wb_lock);
-    return work;
-}
-
-static long tux3_do_writeback(struct bdi_writeback *wb)
-{
-    struct backing_dev_info *bdi = wb->bdi;
-    struct wb_writeback_work *work = NULL;
-    long wrote = 0;
-
-    set_bit(BDI_writeback_running, &wb->bdi->state);
-    while ((work = get_next_work_item(bdi)) != NULL) {
-        trace("nr_pages %ld, sb %p, sync_mode %d, "
-              "tagged_writepages %d, for_kupdate %d, range_cyclic %d, "
-              "for_background %d, reason %d, done %p",
-              work->nr_pages, work->sb, work->sync_mode,
-              work->tagged_writepages, work->for_kupdate,
-              work->range_cyclic, work->for_background,
-              work->reason, work->done);
-
-        wrote += tux3_wb_writeback(wb, work);
-
-        /*
-         * Notify the caller of completion if this is a synchronous
-         * work item, otherwise just free it.
-         */
-        if (work->done)
-            complete(work->done);
-        else
-            kfree(work);
-    }
-    trace("flush done");
-
-    /*
-     * Check for periodic writeback, kupdated() style
-     */
-    wrote += tux3_wb_check_old_data_flush(wb);
-    wrote += tux3_wb_check_background_flush(wb, wrote);
-    clear_bit(BDI_writeback_running, &wb->bdi->state);
-
-    return wrote;
-}
-
-/* Dirty hack to get bdi_wq address from module */
-static struct workqueue_struct *kernel_bdi_wq;
-
-/*
- * Handle writeback of dirty data for the device backed by this bdi. Also
- * reschedules periodically and does kupdated style flushing.
- */
-static void tux3_writeback_workfn(struct work_struct *work)
-{
-    struct bdi_writeback *wb = container_of(to_delayed_work(work),
-                        struct bdi_writeback, dwork);
-    struct backing_dev_info *bdi = wb->bdi;
-    long pages_written;
-
-#if 0
-    /* set_worker_desc() is not exported to module */
-    set_worker_desc("flush-tux3-%s", dev_name(bdi->dev));
-#endif
-    current->flags |= PF_SWAPWRITE;
-
-#if 0
-    /* current_is_workqueue_rescuer() is not exported to module */
-    if (likely(!current_is_workqueue_rescuer() ||
-           list_empty(&bdi->bdi_list)))
-#endif
-    {
-        /*
-         * The normal path.  Keep writing back @bdi until its
-         * work_list is empty.  Note that this path is also taken
-         * if @bdi is shutting down even when we're running off the
-         * rescuer as work_list needs to be drained.
-         */
-        do {
-            pages_written = tux3_do_writeback(wb);
-//            trace_writeback_pages_written(pages_written);
-        } while (!list_empty(&bdi->work_list));
-    }
-#if 0
-    else {
-        /*
-         * bdi_wq can't get enough workers and we're running off
-         * the emergency worker.  Don't hog it.  Hopefully, 1024 is
-         * enough for efficient IO.
-         */
-        pages_written = writeback_inodes_wb(&bdi->wb, 1024,
-                            WB_REASON_FORKER_THREAD);
-        trace_writeback_pages_written(pages_written);
-    }
-#endif
-    if (!list_empty(&bdi->work_list) ||
-        (wb_has_dirty_io(wb) && dirty_writeback_interval))
-        queue_delayed_work(kernel_bdi_wq, &wb->dwork,
-            msecs_to_jiffies(dirty_writeback_interval * 10));
-
-    current->flags &= ~PF_SWAPWRITE;
-}
-
-#include <linux/kallsyms.h>
-static int tux3_setup_writeback(struct sb *sb, struct backing_dev_info *bdi)
-{
-    /* Dirty hack to get bdi_wq address from module */
-    if (kernel_bdi_wq == NULL) {
-        unsigned long wq_addr;
-
-        wq_addr = kallsyms_lookup_name("bdi_wq");
-        if (!wq_addr) {
-            tux3_err(sb, "couldn't find bdi_wq address\n");
-            return -EINVAL;
-        }
-        kernel_bdi_wq = *(struct workqueue_struct **)wq_addr;
-        tux3_msg(sb, "use bdi_wq %p", kernel_bdi_wq);
-    }
-
-    /* Overwrite callback by ourself handler */
-    INIT_DELAYED_WORK(&bdi->wb.dwork, tux3_writeback_workfn);
-
-    return 0;
-}
-
-static int tux3_congested_fn(void *congested_data, int bdi_bits)
-{
-    return bdi_congested(congested_data, bdi_bits);
-}
-
-/*
- * We need to disable writeback to control dirty flags of inode.
- * Otherwise, writeback will clear dirty, and inode can be reclaimed
- * without our control.
- */
-int tux3_init_flusher(struct sb *sb)
-{
-    struct backing_dev_info *bdi = &sb->bdi;
-    int err;
-
-    bdi->ra_pages        = vfs_sb(sb)->s_bdi->ra_pages;
-    bdi->congested_fn    = tux3_congested_fn;
-    bdi->congested_data    = vfs_sb(sb)->s_bdi;
-
-    err = bdi_setup_and_register(bdi, "tux3", BDI_CAP_MAP_COPY);
-    if (err)
-        return err;
-
-    err = tux3_setup_writeback(sb, bdi);
-    if (err) {
-        bdi_destroy(bdi);
-        return err;
-    }
-
-    vfs_sb(sb)->s_bdi = bdi;
-
-    return 0;
-}
-
-void tux3_exit_flusher(struct sb *sb)
-{
-    struct backing_dev_info *bdi = vfs_sb(sb)->s_bdi;
-    if (bdi == &sb->bdi)
-        bdi_destroy(bdi);
-}
-
-static void schedule_flush_delta(struct sb *sb)
-{
-    /* Wake up waiters for pending delta staging */
-    wake_up_all(&sb->delta_event_wq);
-}
-
-static void try_delta_transition(struct sb *sb)
-{
-#if 0
-    trace("stage %u, backend_state %lx",
-          sb->staging_delta, sb->backend_state);
-    sync_inodes_sb(vfs_sb(sb));
-#endif
-}
-
-static int sync_current_delta(struct sb *sb, enum unify_flags unify_flag)
-{
-    /* FORCE_UNIFY is not supported */
-    WARN_ON(unify_flag == FORCE_UNIFY);
-    /* This is called only for fsync, so we can take ->s_umount here */
-    down_read(&vfs_sb(sb)->s_umount);
-    sync_inodes_sb(vfs_sb(sb));
-    up_read(&vfs_sb(sb)->s_umount);
-    return 0;    /* FIXME: error code */
-}
-#endif /* TUX3_FLUSHER != TUX3_FLUSHER_ASYNC_HACK */
diff --git a/fs/tux3/inode.c b/fs/tux3/inode.c
index 1bfb28f..5c9b1f4 100644
--- a/fs/tux3/inode.c
+++ b/fs/tux3/inode.c
@@ -932,8 +932,6 @@ static void tux_setup_inode(struct inode *inode)

     assert(tux_inode(inode)->inum != TUX_INVALID_INO);

-    tux3_set_mapping_bdi(inode);
-
 //    inode->i_generation = 0;
 //    inode->i_flags = 0;

diff --git a/fs/tux3/super.c b/fs/tux3/super.c
index 931c86d..68642d4 100644
--- a/fs/tux3/super.c
+++ b/fs/tux3/super.c
@@ -126,9 +126,6 @@ static void __tux3_put_super(struct sb *sbi)
     iput(sbi->volmap);
     sbi->volmap = NULL;

-    /* Cleanup flusher after inode was evicted */
-    tux3_exit_flusher(sbi);
-
     tux3_free_idefer_map(sbi->idefer_map);
     sbi->idefer_map = NULL;
     /* FIXME: add more sanity check */
@@ -178,13 +175,6 @@ struct replay *tux3_init_fs(struct sb *sbi)
     char *name;
     int err;

-    /* Initialize flusher before setup inode */
-    err = tux3_init_flusher(sbi);
-    if (err) {
-        tux3_err(sbi, "failed to initialize flusher");
-        goto error;
-    }
-
     err = -ENOMEM;

     /* Prepare non on-disk inodes */
@@ -375,7 +365,7 @@ static void tux3_destroy_inode(struct inode *inode)
     call_rcu(&inode->i_rcu, tux3_i_callback);
 }

-#if TUX3_FLUSHER != TUX3_FLUSHER_ASYNC_HACK
+#if TUX3_FLUSHER != TUX3_FLUSHER_ASYNC
 static int tux3_sync_fs(struct super_block *sb, int wait)
 {
     /* FIXME: We should support "wait" parameter. */
@@ -423,12 +413,13 @@ static const struct super_operations tux3_super_ops = {
     .evict_inode    = tux3_evict_inode,
     /* FIXME: we have to handle write_inode of sync (e.g. cache pressure) */
 //    .write_inode    = tux3_write_inode,
-#if TUX3_FLUSHER != TUX3_FLUSHER_ASYNC_HACK
-    /* If TUX3_FLUSHER_ASYNC_HACK, normal kernel flush request does all */
+#if TUX3_FLUSHER != TUX3_FLUSHER_ASYNC
+    /* If TUX3_FLUSHER_ASYNC, normal kernel flush request does all */
     .sync_fs    = tux3_sync_fs,
 #endif
     .put_super    = tux3_put_super,
     .statfs        = tux3_statfs,
+    .writeback = tux3_writeback,
 };

 static int tux3_fill_super(struct super_block *sb, void *data, int silent)
diff --git a/fs/tux3/tux3.h b/fs/tux3/tux3.h
index 002d6d4..3ca6756 100644
--- a/fs/tux3/tux3.h
+++ b/fs/tux3/tux3.h
@@ -222,7 +222,7 @@ struct stash { struct flink_head head; u64 *pos, *top; };
 /* Flush asynchronously by own timing */
 #define TUX3_FLUSHER_ASYNC_OWN        2
 /* Flush asynchronously by kernel normal timing (by hackish way) */
-#define TUX3_FLUSHER_ASYNC_HACK        3
+#define TUX3_FLUSHER_ASYNC        3

 /* Refcount for delta */
 struct delta_ref {
@@ -271,9 +271,6 @@ struct sb {
 #if TUX3_FLUSHER == TUX3_FLUSHER_ASYNC_OWN
     struct task_struct *flush_task;        /* work to flush delta */
 #endif
-#if TUX3_FLUSHER == TUX3_FLUSHER_ASYNC_HACK
-    struct backing_dev_info bdi;
-#endif

     struct btree itree;    /* Inode btree */
     struct btree otree;    /* Orphan btree */
@@ -793,9 +790,6 @@ int change_end(struct sb *sb);
 void change_begin_if_needed(struct sb *sb, int need_sep);
 void change_end_if_needed(struct sb *sb);

-/* commit_flusher.c */
-#include "commit_flusher.h"
-
 /* dir.c */
 void tux_set_entry(struct buffer_head *buffer, struct tux3_dirent *entry,
            inum_t inum, umode_t mode);
@@ -978,6 +972,9 @@ static inline void tux3_mark_inode_dirty_sync(struct inode *inode)
     __tux3_mark_inode_dirty(inode, I_DIRTY_SYNC);
 }

+struct super_block;
+struct writeback_control;
+long tux3_writeback(struct super_block *super, struct writeback_control *wbc, long *nr_pages);
 void tux3_dirty_inode(struct inode *inode, int flags);
 void tux3_mark_inode_to_delete(struct inode *inode);
 void tux3_iattrdirty(struct inode *inode);
diff --git a/fs/tux3/writeback.c b/fs/tux3/writeback.c
index 9ecafc0..b4b4798 100644
--- a/fs/tux3/writeback.c
+++ b/fs/tux3/writeback.c
@@ -124,57 +124,6 @@ static inline unsigned tux3_dirty_flags(struct inode *inode, unsigned delta)
     return ret;
 }

-/*
- * We don't use i_wb_list though, bdi flusher checks this via
- * wb_has_dirty_io(). So if inode become clean, we remove inode from
- * it.
- */
-static inline void tux3_inode_wb_lock(struct inode *inode)
-{
-#ifdef __KERNEL__
-    struct backing_dev_info *bdi = inode->i_sb->s_bdi;
-    spin_lock(&bdi->wb.list_lock);
-#endif
-}
-
-static inline void tux3_inode_wb_unlock(struct inode *inode)
-{
-#ifdef __KERNEL__
-    struct backing_dev_info *bdi = inode->i_sb->s_bdi;
-    spin_unlock(&bdi->wb.list_lock);
-#endif
-}
-
-static inline void tux3_inode_wb_list_del(struct inode *inode)
-{
-#ifdef __KERNEL__
-    list_del_init(&inode->i_wb_list);
-#endif
-}
-
-/*
- * __mark_inode_dirty() doesn't know about delta boundary (we don't
- * clear I_DIRTY before flush, in order to prevent the inode to be
- * freed). So, if inode was re-dirtied for frontend delta while
- * flushing old delta, ->dirtied_when may not be updated by
- * __mark_inode_dirty() forever.
- *
- * Although we don't use ->dirtied_when, bdi flusher uses
- * ->dirtied_when to decide flush timing, so we have to update
- * ->dirtied_when ourself.
- */
-static void tux3_inode_wb_update_dirtied_when(struct inode *inode)
-{
-#ifdef __KERNEL__
-    /* Take lock only if we have to update. */
-    struct backing_dev_info *bdi = inode->i_sb->s_bdi;
-    tux3_inode_wb_lock(inode);
-    inode->dirtied_when = jiffies;
-    list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
-    tux3_inode_wb_unlock(inode);
-#endif
-}
-
 /* This is hook of __mark_inode_dirty() and called I_DIRTY_PAGES too */
 void tux3_dirty_inode(struct inode *inode, int flags)
 {
@@ -220,11 +169,19 @@ void tux3_dirty_inode(struct inode *inode, int flags)
     spin_unlock(&tuxnode->lock);

     /*
-     * Update ->i_wb_list and ->dirtied_when if need. See comment
-     * of tux3_inode_wb_update_dirtied_when().
+     * Update ->i_wb_list and ->dirtied_when if needed.
+     * __mark_inode_dirty() doesn't know about delta boundary (we don't
+     * clear I_DIRTY before flush, in order to prevent the inode to be
+     * freed). So, if inode was re-dirtied for frontend delta while
+     * flushing old delta, ->dirtied_when may not be updated by
+     * __mark_inode_dirty() forever.
+     *
+     * Although we don't use ->dirtied_when, bdi flusher uses
+     * ->dirtied_when to decide flush timing, so we have to update
+     * ->dirtied_when ourself.
      */
     if (re_dirtied)
-        tux3_inode_wb_update_dirtied_when(inode);
+        inode_writeback_touch(inode);
 }

 /*
@@ -289,23 +246,20 @@ static void tux3_clear_dirty_inode_nolock(struct inode *inode, unsigned delta,
     }

     /* Update state if inode isn't dirty anymore */
-    if (!(tuxnode->flags & ~NON_DIRTY_FLAGS)) {
+    if (!(tuxnode->flags & ~NON_DIRTY_FLAGS))
         inode->i_state &= ~I_DIRTY;
-        tux3_inode_wb_list_del(inode);
-    }
 }

 /* Clear dirty flags for delta */
 static void __tux3_clear_dirty_inode(struct inode *inode, unsigned delta)
 {
     struct tux3_inode *tuxnode = tux_inode(inode);
-    tux3_inode_wb_lock(inode);
     spin_lock(&inode->i_lock);
     spin_lock(&tuxnode->lock);
     tux3_clear_dirty_inode_nolock(inode, delta, 0);
     spin_unlock(&tuxnode->lock);
     spin_unlock(&inode->i_lock);
-    tux3_inode_wb_unlock(inode);
+    inode_writeback_done(inode);
 }

 /*
@@ -315,14 +269,13 @@ static void __tux3_clear_dirty_inode(struct inode *inode, unsigned delta)
 void tux3_clear_dirty_inode(struct inode *inode)
 {
     struct tux3_inode *tuxnode = tux_inode(inode);
-    tux3_inode_wb_lock(inode);
     spin_lock(&inode->i_lock);
     spin_lock(&tuxnode->lock);
     tux3_iattr_clear_dirty(tuxnode);
     tux3_clear_dirty_inode_nolock(inode, tux3_inode_delta(inode), 1);
     spin_unlock(&tuxnode->lock);
     spin_unlock(&inode->i_lock);
-    tux3_inode_wb_unlock(inode);
+    inode_writeback_done(inode);
 }

 void __tux3_mark_inode_dirty(struct inode *inode, int flags)



