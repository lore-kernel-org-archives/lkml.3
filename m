Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933563Ab3FRQjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:39:44 -0400
Received: from forward19.mail.yandex.net ([95.108.253.144]:57667 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426Ab3FRQjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:39:39 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1371572327.18733.37.camel@gandalf.local.home>
References: <1451381371569817@web21d.yandex.ru>
	 <1371571012.18733.33.camel@gandalf.local.home>
	 <670131371571433@web19e.yandex.ru> <1371572327.18733.37.camel@gandalf.local.home>
Subject: [PATCHv3 2/2]sched,misc: Use schedule_(raw_)spin_unlock and schedule_(raw_)spin_unlock_irq
MIME-Version: 1.0
Message-Id: <69311371573575@web1g.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Tue, 18 Jun 2013 20:39:35 +0400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use schedule_spin_unlock(lock) instead of:

      spin_unlock(lock);
      schedule();

and schedule_spin_unlock_irq(lock) instead of:

      spin_unlock_irq(lock);
      schedule();

   (the same for raw_spinlock_t),

where it is possible (All directories except arch/.)

These primitives do the same as replaced unlock/schedule,
but also they help to prevent excess preempt_schedule() call
which can happen on preemptible kernel (from *_unlock*() code).

Signed-off-by: Kirill Tkhai <tkhai@yandex.ru>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 drivers/base/devtmpfs.c                         |    3 +--
 drivers/base/power/runtime.c                    |   12 +++---------
 drivers/block/drbd/drbd_req.c                   |    3 +--
 drivers/char/ipmi/ipmi_watchdog.c               |    3 +--
 drivers/md/bitmap.c                             |    3 +--
 drivers/md/raid5.c                              |    3 +--
 drivers/media/rc/ir-raw.c                       |    3 +--
 drivers/mtd/nand/nand_base.c                    |    3 +--
 drivers/mtd/onenand/onenand_base.c              |    3 +--
 drivers/mtd/ubi/wl.c                            |    3 +--
 drivers/net/wireless/libertas/main.c            |    3 +--
 drivers/pci/access.c                            |    3 +--
 drivers/scsi/libsas/sas_scsi_host.c             |    3 +--
 drivers/staging/lustre/lnet/selftest/rpc.c      |    4 +---
 drivers/staging/lustre/lustre/libcfs/workitem.c |    3 +--
 fs/afs/callback.c                               |    3 +--
 fs/afs/vnode.c                                  |    3 +--
 fs/block_dev.c                                  |    3 +--
 fs/btrfs/extent-tree.c                          |    4 +---
 fs/btrfs/extent_io.c                            |    3 +--
 fs/dlm/user.c                                   |    3 +--
 fs/eventfd.c                                    |    6 ++----
 fs/exec.c                                       |    3 +--
 fs/fuse/dev.c                                   |    3 +--
 fs/gfs2/quota.c                                 |    3 +--
 fs/inode.c                                      |    3 +--
 fs/jbd/commit.c                                 |    6 ++----
 fs/jbd/journal.c                                |    3 +--
 fs/jbd/transaction.c                            |    9 +++------
 fs/jbd2/journal.c                               |    3 +--
 fs/jffs2/nodemgmt.c                             |    4 +---
 fs/jffs2/os-linux.h                             |    3 +--
 fs/jfs/jfs_logmgr.c                             |    3 +--
 fs/mbcache.c                                    |    6 ++----
 fs/nilfs2/segment.c                             |    3 +--
 fs/ocfs2/dlm/dlmthread.c                        |    3 +--
 fs/signalfd.c                                   |    3 +--
 fs/xfs/xfs_log_priv.h                           |    3 +--
 fs/xfs/xfs_trans_ail.c                          |    6 ++----
 kernel/posix-cpu-timers.c                       |    3 +--
 kernel/workqueue.c                              |    3 +--
 sound/core/control.c                            |    3 +--
 sound/core/rawmidi.c                            |    3 +--
 sound/core/seq/seq_fifo.c                       |    3 +--
 sound/core/seq/seq_memory.c                     |    3 +--
 sound/core/timer.c                              |    3 +--
 46 files changed, 54 insertions(+), 114 deletions(-)
diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index 7413d06..e7fe22b 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -402,8 +402,7 @@ static int devtmpfsd(void *p)
 			spin_lock(&req_lock);
 		}
 		__set_current_state(TASK_INTERRUPTIBLE);
-		spin_unlock(&req_lock);
-		schedule();
+		schedule_spin_unlock(&req_lock);
 	}
 	return 0;
 out:
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 268a350..9d230a4 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -465,9 +465,7 @@ static int rpm_suspend(struct device *dev, int rpmflags)
 			if (dev->power.runtime_status != RPM_SUSPENDING)
 				break;
 
-			spin_unlock_irq(&dev->power.lock);
-
-			schedule();
+			schedule_spin_unlock_irq(&dev->power.lock);
 
 			spin_lock_irq(&dev->power.lock);
 		}
@@ -646,9 +644,7 @@ static int rpm_resume(struct device *dev, int rpmflags)
 			    && dev->power.runtime_status != RPM_SUSPENDING)
 				break;
 
-			spin_unlock_irq(&dev->power.lock);
-
-			schedule();
+			schedule_spin_unlock_irq(&dev->power.lock);
 
 			spin_lock_irq(&dev->power.lock);
 		}
@@ -1078,9 +1074,7 @@ static void __pm_runtime_barrier(struct device *dev)
 			    && dev->power.runtime_status != RPM_RESUMING
 			    && !dev->power.idle_notification)
 				break;
-			spin_unlock_irq(&dev->power.lock);
-
-			schedule();
+			schedule_spin_unlock_irq(&dev->power.lock);
 
 			spin_lock_irq(&dev->power.lock);
 		}
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index c24379f..e08329a 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -850,8 +850,7 @@ static void complete_conflicting_writes(struct drbd_request *req)
 			break;
 		/* Indicate to wake up device->misc_wait on progress.  */
 		i->waiting = true;
-		spin_unlock_irq(&mdev->tconn->req_lock);
-		schedule();
+		schedule_spin_unlock_irq(&mdev->tconn->req_lock);
 		spin_lock_irq(&mdev->tconn->req_lock);
 	}
 	finish_wait(&mdev->misc_wait, &wait);
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 37b8be7..f825b3e 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -834,8 +834,7 @@ static ssize_t ipmi_read(struct file *file,
 		add_wait_queue(&read_q, &wait);
 		while (!data_to_read) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock(&ipmi_read_lock);
-			schedule();
+			schedule_spin_unlock(&ipmi_read_lock);
 			spin_lock(&ipmi_read_lock);
 		}
 		remove_wait_queue(&read_q, &wait);
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index a7fd821..af80b15 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1297,8 +1297,7 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 			 */
 			prepare_to_wait(&bitmap->overflow_wait, &__wait,
 					TASK_UNINTERRUPTIBLE);
-			spin_unlock_irq(&bitmap->counts.lock);
-			schedule();
+			schedule_spin_unlock_irq(&bitmap->counts.lock);
 			finish_wait(&bitmap->overflow_wait, &__wait);
 			continue;
 		}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7674226..780b865 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4397,8 +4397,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 				if (mddev->reshape_backwards
 				    ? logical_sector < conf->reshape_safe
 				    : logical_sector >= conf->reshape_safe) {
-					spin_unlock_irq(&conf->device_lock);
-					schedule();
+					schedule_spin_unlock_irq(&conf->device_lock);
 					goto retry;
 				}
 			}
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 5c42750..30f733d 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -49,8 +49,7 @@ static int ir_raw_event_thread(void *data)
 			if (kthread_should_stop())
 				set_current_state(TASK_RUNNING);
 
-			spin_unlock_irq(&raw->lock);
-			schedule();
+			schedule_spin_unlock_irq(&raw->lock);
 			continue;
 		}
 
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index 1cbacff..34138a73 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -756,8 +756,7 @@ retry:
 	}
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	add_wait_queue(wq, &wait);
-	spin_unlock(lock);
-	schedule();
+	schedule_spin_unlock(lock);
 	remove_wait_queue(wq, &wait);
 	goto retry;
 }
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index b3f41f2..9e7dad1 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -987,8 +987,7 @@ static int onenand_get_device(struct mtd_info *mtd, int new_state)
 		}
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		add_wait_queue(&this->wq, &wait);
-		spin_unlock(&this->chip_lock);
-		schedule();
+		schedule_spin_unlock(&this->chip_lock);
 		remove_wait_queue(&this->wq, &wait);
 	}
 
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 5df49d3..0e2191e 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1808,8 +1808,7 @@ int ubi_thread(void *u)
 		if (list_empty(&ubi->works) || ubi->ro_mode ||
 		    !ubi->thread_enabled || ubi_dbg_is_bgt_disabled(ubi)) {
 			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock(&ubi->wl_lock);
-			schedule();
+			schedule_spin_unlock(&ubi->wl_lock);
 			continue;
 		}
 		spin_unlock(&ubi->wl_lock);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 0c02f04..898f126 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -501,8 +501,7 @@ static int lbs_thread(void *data)
 				"psmode %d, psstate %d\n",
 				priv->connect_status,
 				priv->psmode, priv->psstate);
-			spin_unlock_irq(&priv->driver_lock);
-			schedule();
+			schedule_spin_unlock_irq(&priv->driver_lock);
 		} else
 			spin_unlock_irq(&priv->driver_lock);
 
diff --git a/drivers/pci/access.c b/drivers/pci/access.c
index 1cc2366..47aeacd 100644
--- a/drivers/pci/access.c
+++ b/drivers/pci/access.c
@@ -136,8 +136,7 @@ static noinline void pci_wait_cfg(struct pci_dev *dev)
 	__add_wait_queue(&pci_cfg_wait, &wait);
 	do {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		raw_spin_unlock_irq(&pci_lock);
-		schedule();
+		schedule_raw_spin_unlock_irq(&pci_lock);
 		raw_spin_lock_irq(&pci_lock);
 	} while (dev->block_cfg_access);
 	__remove_wait_queue(&pci_cfg_wait, &wait);
diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index da3aee1..eaddf84 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -474,8 +474,7 @@ static void sas_wait_eh(struct domain_device *dev)
 
 	while (test_bit(SAS_DEV_EH_PENDING, &dev->state)) {
 		prepare_to_wait(&ha->eh_wait_q, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&ha->lock);
-		schedule();
+		schedule_spin_unlock_irq(&ha->lock);
 		spin_lock_irq(&ha->lock);
 	}
 	finish_wait(&ha->eh_wait_q, &wait);
diff --git a/drivers/staging/lustre/lnet/selftest/rpc.c b/drivers/staging/lustre/lnet/selftest/rpc.c
index bc1f38b..a95fa07 100644
--- a/drivers/staging/lustre/lnet/selftest/rpc.c
+++ b/drivers/staging/lustre/lnet/selftest/rpc.c
@@ -1121,9 +1121,7 @@ srpc_del_client_rpc_timer (srpc_client_rpc_t *rpc)
 
 	/* timer detonated, wait for it to explode */
 	while (rpc->crpc_timeout != 0) {
-		spin_unlock(&rpc->crpc_lock);
-
-		schedule();
+		schedule_spin_unlock(&rpc->crpc_lock);
 
 		spin_lock(&rpc->crpc_lock);
 	}
diff --git a/drivers/staging/lustre/lustre/libcfs/workitem.c b/drivers/staging/lustre/lustre/libcfs/workitem.c
index b533666..0acd07e 100644
--- a/drivers/staging/lustre/lustre/libcfs/workitem.c
+++ b/drivers/staging/lustre/lustre/libcfs/workitem.c
@@ -379,8 +379,7 @@ cfs_wi_sched_create(char *name, struct cfs_cpt_table *cptab,
 		task_t	*task;
 		spin_lock(&cfs_wi_data.wi_glock);
 		while (sched->ws_starting > 0) {
-			spin_unlock(&cfs_wi_data.wi_glock);
-			schedule();
+			schedule_spin_unlock(&cfs_wi_data.wi_glock);
 			spin_lock(&cfs_wi_data.wi_glock);
 		}
 
diff --git a/fs/afs/callback.c b/fs/afs/callback.c
index 7ef637d..6308422 100644
--- a/fs/afs/callback.c
+++ b/fs/afs/callback.c
@@ -311,8 +311,7 @@ void afs_give_up_callback(struct afs_vnode *vnode)
 			if (!vnode->cb_promised ||
 			    afs_breakring_space(server) != 0)
 				break;
-			spin_unlock(&server->cb_lock);
-			schedule();
+			schedule_spin_unlock(&server->cb_lock);
 			spin_lock(&server->cb_lock);
 		}
 		remove_wait_queue(&server->cb_break_waitq, &myself);
diff --git a/fs/afs/vnode.c b/fs/afs/vnode.c
index 25cf4c3..adc2651 100644
--- a/fs/afs/vnode.c
+++ b/fs/afs/vnode.c
@@ -324,9 +324,8 @@ int afs_vnode_fetch_status(struct afs_vnode *vnode,
 				goto get_anyway;
 			}
 
-			spin_unlock(&vnode->lock);
+			schedule_spin_unlock(&vnode->lock);
 
-			schedule();
 			set_current_state(TASK_UNINTERRUPTIBLE);
 
 			spin_lock(&vnode->lock);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9c8ebe4..9d049fd 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -691,8 +691,7 @@ retry:
 		DEFINE_WAIT(wait);
 
 		prepare_to_wait(wq, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock(&bdev_lock);
-		schedule();
+		schedule_spin_unlock(&bdev_lock);
 		finish_wait(wq, &wait);
 		spin_lock(&bdev_lock);
 		goto retry;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index df472ab..cb6a1d6 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -550,9 +550,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
 		ctl = cache->caching_ctl;
 		atomic_inc(&ctl->count);
 		prepare_to_wait(&ctl->wait, &wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock(&cache->lock);
-
-		schedule();
+		schedule_spin_unlock(&cache->lock);
 
 		finish_wait(&ctl->wait, &wait);
 		put_caching_control(ctl);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 6bca947..b629b8a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -660,8 +660,7 @@ static void wait_on_state(struct extent_io_tree *tree,
 {
 	DEFINE_WAIT(wait);
 	prepare_to_wait(&state->wq, &wait, TASK_UNINTERRUPTIBLE);
-	spin_unlock(&tree->lock);
-	schedule();
+	schedule_spin_unlock(&tree->lock);
 	spin_lock(&tree->lock);
 	finish_wait(&state->wq, &wait);
 }
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 911649a..a3da6c2 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -825,8 +825,7 @@ static ssize_t device_read(struct file *file, char __user *buf, size_t count,
 	repeat:
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (list_empty(&proc->asts) && !signal_pending(current)) {
-			spin_unlock(&proc->asts_spin);
-			schedule();
+			schedule_spin_unlock(&proc->asts_spin);
 			spin_lock(&proc->asts_spin);
 			goto repeat;
 		}
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 35470d9..028848e 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -205,8 +205,7 @@ ssize_t eventfd_ctx_read(struct eventfd_ctx *ctx, int no_wait, __u64 *cnt)
 				res = -ERESTARTSYS;
 				break;
 			}
-			spin_unlock_irq(&ctx->wqh.lock);
-			schedule();
+			schedule_spin_unlock_irq(&ctx->wqh.lock);
 			spin_lock_irq(&ctx->wqh.lock);
 		}
 		__remove_wait_queue(&ctx->wqh, &wait);
@@ -269,8 +268,7 @@ static ssize_t eventfd_write(struct file *file, const char __user *buf, size_t c
 				res = -ERESTARTSYS;
 				break;
 			}
-			spin_unlock_irq(&ctx->wqh.lock);
-			schedule();
+			schedule_spin_unlock_irq(&ctx->wqh.lock);
 			spin_lock_irq(&ctx->wqh.lock);
 		}
 		__remove_wait_queue(&ctx->wqh, &wait);
diff --git a/fs/exec.c b/fs/exec.c
index 13f9bb0..7d93c1c 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -889,8 +889,7 @@ static int de_thread(struct task_struct *tsk)
 
 	while (sig->notify_count) {
 		__set_current_state(TASK_KILLABLE);
-		spin_unlock_irq(lock);
-		schedule();
+		schedule_spin_unlock_irq(lock);
 		if (unlikely(__fatal_signal_pending(tsk)))
 			goto killed;
 		spin_lock_irq(lock);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1d55f94..4e1c39e 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1027,8 +1027,7 @@ __acquires(fc->lock)
 		if (signal_pending(current))
 			break;
 
-		spin_unlock(&fc->lock);
-		schedule();
+		schedule_spin_unlock(&fc->lock);
 		spin_lock(&fc->lock);
 	}
 	set_current_state(TASK_RUNNING);
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index db44135..41d4d8a 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1296,8 +1296,7 @@ void gfs2_quota_cleanup(struct gfs2_sbd *sdp)
 		    (atomic_read(&qd->qd_count) &&
 		     !test_bit(QDF_CHANGE, &qd->qd_flags))) {
 			list_move(&qd->qd_list, head);
-			spin_unlock(&qd_lru_lock);
-			schedule();
+			schedule_spin_unlock(&qd_lru_lock);
 			spin_lock(&qd_lru_lock);
 			continue;
 		}
diff --git a/fs/inode.c b/fs/inode.c
index 00b804e..af2a0c6 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1687,8 +1687,7 @@ static void __wait_on_freeing_inode(struct inode *inode)
 	wq = bit_waitqueue(&inode->i_state, __I_NEW);
 	prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
 	spin_unlock(&inode->i_lock);
-	spin_unlock(&inode_hash_lock);
-	schedule();
+	schedule_spin_unlock(&inode_hash_lock);
 	finish_wait(wq, &wait.wait);
 	spin_lock(&inode_hash_lock);
 }
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 11bb11f..b050ee3 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -105,8 +105,7 @@ static void release_data_buffer(struct buffer_head *bh)
 static int inverted_lock(journal_t *journal, struct buffer_head *bh)
 {
 	if (!jbd_trylock_bh_state(bh)) {
-		spin_unlock(&journal->j_list_lock);
-		schedule();
+		schedule_spin_unlock(&journal->j_list_lock);
 		return 0;
 	}
 	return 1;
@@ -358,8 +357,7 @@ void journal_commit_transaction(journal_t *journal)
 					TASK_UNINTERRUPTIBLE);
 		if (commit_transaction->t_updates) {
 			spin_unlock(&commit_transaction->t_handle_lock);
-			spin_unlock(&journal->j_state_lock);
-			schedule();
+			schedule_spin_unlock(&journal->j_state_lock);
 			spin_lock(&journal->j_state_lock);
 			spin_lock(&commit_transaction->t_handle_lock);
 		}
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 6510d63..185e9b5 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -189,8 +189,7 @@ loop:
 		if (journal->j_flags & JFS_UNMOUNT)
 			should_sleep = 0;
 		if (should_sleep) {
-			spin_unlock(&journal->j_state_lock);
-			schedule();
+			schedule_spin_unlock(&journal->j_state_lock);
 			spin_lock(&journal->j_state_lock);
 		}
 		finish_wait(&journal->j_wait_commit, &wait);
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index be0c39b..ff3717d 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -152,8 +152,7 @@ repeat_locked:
 
 		prepare_to_wait(&journal->j_wait_transaction_locked,
 					&wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock(&journal->j_state_lock);
-		schedule();
+		schedule_spin_unlock(&journal->j_state_lock);
 		finish_wait(&journal->j_wait_transaction_locked, &wait);
 		goto repeat;
 	}
@@ -179,8 +178,7 @@ repeat_locked:
 		prepare_to_wait(&journal->j_wait_transaction_locked, &wait,
 				TASK_UNINTERRUPTIBLE);
 		__log_start_commit(journal, transaction->t_tid);
-		spin_unlock(&journal->j_state_lock);
-		schedule();
+		schedule_spin_unlock(&journal->j_state_lock);
 		finish_wait(&journal->j_wait_transaction_locked, &wait);
 		goto repeat;
 	}
@@ -470,8 +468,7 @@ wait:
 		prepare_to_wait(&journal->j_wait_updates, &wait,
 				TASK_UNINTERRUPTIBLE);
 		spin_unlock(&transaction->t_handle_lock);
-		spin_unlock(&journal->j_state_lock);
-		schedule();
+		schedule_spin_unlock(&journal->j_state_lock);
 		finish_wait(&journal->j_wait_updates, &wait);
 		spin_lock(&journal->j_state_lock);
 	}
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 4c8b8d4..0d3301c 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -2533,8 +2533,7 @@ restart:
 		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
 		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
 		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
-		spin_unlock(&journal->j_list_lock);
-		schedule();
+		schedule_spin_unlock(&journal->j_list_lock);
 		finish_wait(wq, &wait.wait);
 		goto restart;
 	}
diff --git a/fs/jffs2/nodemgmt.c b/fs/jffs2/nodemgmt.c
index 0331072..84eb517 100644
--- a/fs/jffs2/nodemgmt.c
+++ b/fs/jffs2/nodemgmt.c
@@ -176,9 +176,7 @@ int jffs2_reserve_space(struct jffs2_sb_info *c, uint32_t minsize,
 					add_wait_queue(&c->erase_wait, &wait);
 					jffs2_dbg(1, "%s waiting for erase to complete\n",
 						  __func__);
-					spin_unlock(&c->erase_completion_lock);
-
-					schedule();
+					schedule_spin_unlock(&c->erase_completion_lock);
 				} else
 					spin_unlock(&c->erase_completion_lock);
 			} else if (ret)
diff --git a/fs/jffs2/os-linux.h b/fs/jffs2/os-linux.h
index d200a9b..f94e9f2 100644
--- a/fs/jffs2/os-linux.h
+++ b/fs/jffs2/os-linux.h
@@ -42,8 +42,7 @@ struct kvec;
 		DECLARE_WAITQUEUE(__wait, current);		\
 		add_wait_queue((wq), &__wait);			\
 		set_current_state(TASK_UNINTERRUPTIBLE);	\
-		spin_unlock(s);					\
-		schedule();					\
+		schedule_spin_unlock(s);			\
 		remove_wait_queue((wq), &__wait);		\
 	} while(0)
 
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 360d27c..fee71b6 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2357,8 +2357,7 @@ int jfsIOWait(void *arg)
 			try_to_freeze();
 		} else {
 			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_irq(&log_redrive_lock);
-			schedule();
+			schedule_spin_unlock_irq(&log_redrive_lock);
 			__set_current_state(TASK_RUNNING);
 		}
 	} while (!kthread_should_stop());
diff --git a/fs/mbcache.c b/fs/mbcache.c
index e519e45..48ffe37 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -481,8 +481,7 @@ mb_cache_entry_get(struct mb_cache *cache, struct block_device *bdev,
 				ce->e_queued++;
 				prepare_to_wait(&mb_cache_queue, &wait,
 						TASK_UNINTERRUPTIBLE);
-				spin_unlock(&mb_cache_spinlock);
-				schedule();
+				schedule_spin_unlock(&mb_cache_spinlock);
 				spin_lock(&mb_cache_spinlock);
 				ce->e_queued--;
 			}
@@ -525,8 +524,7 @@ __mb_cache_entry_find(struct list_head *l, struct list_head *head,
 				ce->e_queued++;
 				prepare_to_wait(&mb_cache_queue, &wait,
 						TASK_UNINTERRUPTIBLE);
-				spin_unlock(&mb_cache_spinlock);
-				schedule();
+				schedule_spin_unlock(&mb_cache_spinlock);
 				spin_lock(&mb_cache_spinlock);
 				ce->e_queued--;
 			}
diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
index bd88a74..6e6e519 100644
--- a/fs/nilfs2/segment.c
+++ b/fs/nilfs2/segment.c
@@ -2493,8 +2493,7 @@ static int nilfs_segctor_thread(void *arg)
 					sci->sc_timer.expires);
 
 		if (should_sleep) {
-			spin_unlock(&sci->sc_state_lock);
-			schedule();
+			schedule_spin_unlock(&sci->sc_state_lock);
 			spin_lock(&sci->sc_state_lock);
 		}
 		finish_wait(&sci->sc_wait_daemon, &wait);
diff --git a/fs/ocfs2/dlm/dlmthread.c b/fs/ocfs2/dlm/dlmthread.c
index e73c833..1c6db06 100644
--- a/fs/ocfs2/dlm/dlmthread.c
+++ b/fs/ocfs2/dlm/dlmthread.c
@@ -68,8 +68,7 @@ void __dlm_wait_on_lockres_flags(struct dlm_lock_resource *res, int flags)
 repeat:
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	if (res->state & flags) {
-		spin_unlock(&res->spinlock);
-		schedule();
+		schedule_spin_unlock(&res->spinlock);
 		spin_lock(&res->spinlock);
 		goto repeat;
 	}
diff --git a/fs/signalfd.c b/fs/signalfd.c
index 424b7b6..a4331a9 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -183,8 +183,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, siginfo_t *info,
 			ret = -ERESTARTSYS;
 			break;
 		}
-		spin_unlock_irq(&current->sighand->siglock);
-		schedule();
+		schedule_spin_unlock_irq(&current->sighand->siglock);
 		spin_lock_irq(&current->sighand->siglock);
 	}
 	spin_unlock_irq(&current->sighand->siglock);
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b9ea262..278dd61 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -682,8 +682,7 @@ static inline void xlog_wait(wait_queue_head_t *wq, spinlock_t *lock)
 
 	add_wait_queue_exclusive(wq, &wait);
 	__set_current_state(TASK_UNINTERRUPTIBLE);
-	spin_unlock(lock);
-	schedule();
+	schedule_spin_unlock(lock);
 	remove_wait_queue(wq, &wait);
 }
 #endif	/* __KERNEL__ */
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 0eda725..6f36414 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -533,8 +533,7 @@ xfsaild(
 		smp_rmb();
 		if (!xfs_ail_min(ailp) &&
 		    ailp->xa_target == ailp->xa_target_prev) {
-			spin_unlock(&ailp->xa_lock);
-			schedule();
+			schedule_spin_unlock(&ailp->xa_lock);
 			tout = 0;
 			continue;
 		}
@@ -618,8 +617,7 @@ xfs_ail_push_all_sync(
 		prepare_to_wait(&ailp->xa_empty, &wait, TASK_UNINTERRUPTIBLE);
 		ailp->xa_target = lip->li_lsn;
 		wake_up_process(ailp->xa_task);
-		spin_unlock(&ailp->xa_lock);
-		schedule();
+		schedule_spin_unlock(&ailp->xa_lock);
 		spin_lock(&ailp->xa_lock);
 	}
 	spin_unlock(&ailp->xa_lock);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c7f31aa..6e2c7a2 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1358,8 +1358,7 @@ static int do_cpu_nanosleep(const clockid_t which_clock, int flags,
 			 * Block until cpu_timer_fire (or a signal) wakes us.
 			 */
 			__set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_irq(&timer.it_lock);
-			schedule();
+			schedule_spin_unlock_irq(&timer.it_lock);
 			spin_lock_irq(&timer.it_lock);
 		}
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f02c4a4..0da9b8e 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2321,8 +2321,7 @@ sleep:
 	 */
 	worker_enter_idle(worker);
 	__set_current_state(TASK_INTERRUPTIBLE);
-	spin_unlock_irq(&pool->lock);
-	schedule();
+	schedule_spin_unlock_irq(&pool->lock);
 	goto woke_up;
 }
 
diff --git a/sound/core/control.c b/sound/core/control.c
index d8aa206..fba94a5 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1437,8 +1437,7 @@ static ssize_t snd_ctl_read(struct file *file, char __user *buffer,
 			init_waitqueue_entry(&wait, current);
 			add_wait_queue(&ctl->change_sleep, &wait);
 			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_irq(&ctl->read_lock);
-			schedule();
+			schedule_spin_unlock_irq(&ctl->read_lock);
 			remove_wait_queue(&ctl->change_sleep, &wait);
 			if (ctl->card->shutdown)
 				return -ENODEV;
diff --git a/sound/core/rawmidi.c b/sound/core/rawmidi.c
index 7b596b5..6bd5d45 100644
--- a/sound/core/rawmidi.c
+++ b/sound/core/rawmidi.c
@@ -996,8 +996,7 @@ static ssize_t snd_rawmidi_read(struct file *file, char __user *buf, size_t coun
 			init_waitqueue_entry(&wait, current);
 			add_wait_queue(&runtime->sleep, &wait);
 			set_current_state(TASK_INTERRUPTIBLE);
-			spin_unlock_irq(&runtime->lock);
-			schedule();
+			schedule_spin_unlock_irq(&runtime->lock);
 			remove_wait_queue(&runtime->sleep, &wait);
 			if (rfile->rmidi->card->shutdown)
 				return -ENODEV;
diff --git a/sound/core/seq/seq_fifo.c b/sound/core/seq/seq_fifo.c
index 0d75afa..520e2f4 100644
--- a/sound/core/seq/seq_fifo.c
+++ b/sound/core/seq/seq_fifo.c
@@ -191,8 +191,7 @@ int snd_seq_fifo_cell_out(struct snd_seq_fifo *f,
 		}
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&f->input_sleep, &wait);
-		spin_unlock_irq(&f->lock);
-		schedule();
+		schedule_spin_unlock_irq(&f->lock);
 		spin_lock_irq(&f->lock);
 		remove_wait_queue(&f->input_sleep, &wait);
 		if (signal_pending(current)) {
diff --git a/sound/core/seq/seq_memory.c b/sound/core/seq/seq_memory.c
index f478f77..3741f6e 100644
--- a/sound/core/seq/seq_memory.c
+++ b/sound/core/seq/seq_memory.c
@@ -244,8 +244,7 @@ static int snd_seq_cell_alloc(struct snd_seq_pool *pool,
 
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&pool->output_sleep, &wait);
-		spin_unlock_irq(&pool->lock);
-		schedule();
+		schedule_spin_unlock_irq(&pool->lock);
 		spin_lock_irq(&pool->lock);
 		remove_wait_queue(&pool->output_sleep, &wait);
 		/* interrupted? */
diff --git a/sound/core/timer.c b/sound/core/timer.c
index 6ddcf06..99cbc7e 100644
--- a/sound/core/timer.c
+++ b/sound/core/timer.c
@@ -1863,8 +1863,7 @@ static ssize_t snd_timer_user_read(struct file *file, char __user *buffer,
 			init_waitqueue_entry(&wait, current);
 			add_wait_queue(&tu->qchange_sleep, &wait);
 
-			spin_unlock_irq(&tu->qlock);
-			schedule();
+			schedule_spin_unlock_irq(&tu->qlock);
 			spin_lock_irq(&tu->qlock);
 
 			remove_wait_queue(&tu->qchange_sleep, &wait);
