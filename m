Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbaHDKbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 06:31:31 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57182 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaHDKb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 06:31:28 -0400
Date: Mon, 4 Aug 2014 12:31:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] scheduler changes for v3.17
Message-ID: <20140804103121.GA23817@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched-core-for-linus

   # HEAD: cd3bd4e628a6d57d66afe77835fe8d93ae3e41f8 sched/fair: Fix 'make xmldocs' warning caused by missing description


    * Move the nohz kick code out of the scheduler tick to a
      dedicated IPI, from Frederic Weisbecker.

      This necessiated quite some background infrastructure rework,
      including:
    
         * Clean up some irq-work internals
         * Implement remote irq-work
         * Implement nohz kick on top of remote irq-work
         * Move full dynticks timer enqueue notification to new kick
         * Move multi-task notification to new kick
         * Remove unecessary barriers on multi-task notification

    * Remove proliferation of wait_on_bit() action functions and allow 
      wait_on_bit_action() functions to support a timeout. (Neil Brown)

    * Another round of sched/numa improvements, cleanups and
      fixes. (Rik van Riel)

    * Implement fast idling of CPUs when the system is partially 
      loaded, for better scalability. (Tim Chen)

    * Restructure and fix the CPU hotplug handling code that may 
      leave cfs_rq and rt_rq's throttled when tasks are migrated away
      from a dead cpu. (Kirill Tkhai)

    * Robustify the sched topology setup code. (Peterz Zijlstra)

    * Improve sched_feat() handling wrt. static_keys (Jason Baron)

    * Misc fixes.

 Thanks,

	Ingo

------------------>
Ben Segall (1):
      sched: Fix potential near-infinite distribute_cfs_runtime() loop

Daniel Bristot de Oliveira (1):
      sched: Fix sched_setparam() policy == -1 logic

Frederic Weisbecker (6):
      irq_work: Split raised and lazy lists
      irq_work: Implement remote queueing
      nohz: Support nohz full remote kick
      nohz: Switch to nohz full remote kick on timer enqueue
      nohz: Use nohz own full kick on 2nd task enqueue
      nohz: Use IPI implicit full barrier against rq->nr_running r/w

Hillf Danton (1):
      sched: Fix CACHE_HOT_BUDY condition

Jason Baron (2):
      sched: Remove extra static_key*() function indirection
      sched: Fix static_key race with sched_feat()

Kirill Tkhai (4):
      sched/fair: Disable runtime_enabled on dying rq
      sched/rt: Enqueue just unthrottled rt_rq back on the stack in __disable_runtime()
      sched: Rework check_for_tasks()
      sched: Transform resched_task() into resched_curr()

Masanari Iida (1):
      sched/fair: Fix 'make xmldocs' warning caused by missing description

Mike Galbraith (1):
      sched: Fix clock_gettime(CLOCK_[PROCESS/THREAD]_CPUTIME_ID) monotonicity

NeilBrown (2):
      sched: Remove proliferation of wait_on_bit() action functions
      sched: Allow wait_on_bit_action() functions to support a timeout

Oleg Nesterov (1):
      sched/deadline: Kill task_struct->pi_top_task

Peter Zijlstra (3):
      irq_work: Remove BUG_ON in irq_work_run()
      sched/numa: Revert "Use effective_load() to balance NUMA loads"
      sched: Robustify topology setup

Rik van Riel (9):
      sched/numa: Ensure task_numa_migrate() checks the preferred node
      sched/numa: Always try to migrate to preferred node at task_numa_placement() time
      sched/numa: Use group's max nid as task's preferred nid
      sched/numa: Move power adjustment into load_too_imbalanced()
      sched/numa: Use effective_load() to balance NUMA loads
      sched/numa: Simplify task_numa_compare()
      sched/numa: Examine a task move when examining a task swap
      sched/numa: Rework best node setting in task_numa_migrate()
      sched/numa: Change scan period code to match intent

Steven Rostedt (1):
      sched: Use macro for magic number of -1 for setparam

Tim Chen (1):
      sched/fair: Implement fast idling of CPUs when the system is partially loaded

Viresh Kumar (2):
      sched/core: Fix formatting issues in sched_can_stop_tick()
      sched/idle: Drop !! while calculating 'broadcast'

xiaofeng.yan (1):
      sched/rt: Fix replenish_dl_entity() comments to match the current upstream code


 Documentation/filesystems/caching/operations.txt |   2 +-
 Documentation/trace/ftrace.txt                   |   2 +-
 drivers/md/dm-bufio.c                            |  41 ++--
 drivers/md/dm-snap.c                             |  10 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c      |  12 +-
 fs/btrfs/extent_io.c                             |  10 +-
 fs/buffer.c                                      |  11 +-
 fs/cifs/connect.c                                |  10 +-
 fs/cifs/file.c                                   |   9 +-
 fs/cifs/inode.c                                  |   6 +-
 fs/cifs/misc.c                                   |   2 +-
 fs/fs-writeback.c                                |   3 +-
 fs/fscache/cookie.c                              |   7 +-
 fs/fscache/internal.h                            |   2 -
 fs/fscache/main.c                                |  18 --
 fs/fscache/page.c                                |   4 +-
 fs/gfs2/glock.c                                  |  25 +--
 fs/gfs2/lock_dlm.c                               |   8 +-
 fs/gfs2/ops_fstype.c                             |  11 +-
 fs/gfs2/recovery.c                               |   8 +-
 fs/gfs2/super.c                                  |   8 +-
 fs/inode.c                                       |   7 -
 fs/jbd2/transaction.c                            |  10 +-
 fs/nfs/file.c                                    |   4 +-
 fs/nfs/filelayout/filelayoutdev.c                |   4 +-
 fs/nfs/inode.c                                   |   6 +-
 fs/nfs/internal.h                                |   2 +-
 fs/nfs/nfs4state.c                               |   4 +-
 fs/nfs/pagelist.c                                |  14 +-
 fs/nfs/pnfs.c                                    |   2 +-
 fs/nfs/write.c                                   |   4 +-
 include/linux/irq_work.h                         |   5 +
 include/linux/sched.h                            |   8 +-
 include/linux/sunrpc/sched.h                     |   2 +-
 include/linux/tick.h                             |   9 +-
 include/linux/wait.h                             | 125 +++++++++++-
 include/linux/writeback.h                        |   3 +-
 kernel/cpu.c                                     |  33 +--
 kernel/fork.c                                    |   1 -
 kernel/irq_work.c                                | 110 +++++-----
 kernel/ptrace.c                                  |   8 +-
 kernel/sched/core.c                              | 119 +++++++----
 kernel/sched/deadline.c                          |  18 +-
 kernel/sched/fair.c                              | 244 ++++++++++++++---------
 kernel/sched/idle.c                              |   4 +-
 kernel/sched/idle_task.c                         |   2 +-
 kernel/sched/rt.c                                |  30 +--
 kernel/sched/sched.h                             |  38 ++--
 kernel/sched/wait.c                              |  30 ++-
 kernel/smp.c                                     |   9 +
 kernel/time/tick-sched.c                         |  10 +-
 mm/filemap.c                                     |  20 +-
 mm/ksm.c                                         |   8 +-
 net/bluetooth/hci_core.c                         |   8 +-
 net/sunrpc/sched.c                               |   4 +-
 security/keys/gc.c                               |  11 +-
 security/keys/request_key.c                      |  23 +--
 57 files changed, 588 insertions(+), 560 deletions(-)

diff --git a/Documentation/filesystems/caching/operations.txt b/Documentation/filesystems/caching/operations.txt
index bee2a5f..a1c052c 100644
--- a/Documentation/filesystems/caching/operations.txt
+++ b/Documentation/filesystems/caching/operations.txt
@@ -90,7 +90,7 @@ operations:
      to be cleared before proceeding:
 
 		wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
-			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+			    TASK_UNINTERRUPTIBLE);
 
 
  (2) The operation may be fast asynchronous (FSCACHE_OP_FAST), in which case it
diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index 2479b2a..4da4261 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -1515,7 +1515,7 @@ Doing the same with chrt -r 5 and function-trace set.
   <idle>-0       3d.h4    1us+:      0:120:R   + [003]  2448: 94:R sleep
   <idle>-0       3d.h4    2us : ttwu_do_activate.constprop.87 <-try_to_wake_up
   <idle>-0       3d.h3    3us : check_preempt_curr <-ttwu_do_wakeup
-  <idle>-0       3d.h3    3us : resched_task <-check_preempt_curr
+  <idle>-0       3d.h3    3us : resched_curr <-check_preempt_curr
   <idle>-0       3dNh3    4us : task_woken_rt <-ttwu_do_wakeup
   <idle>-0       3dNh3    4us : _raw_spin_unlock <-try_to_wake_up
   <idle>-0       3dNh3    4us : sub_preempt_count <-_raw_spin_unlock
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 4e84095..96c92b7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -615,16 +615,6 @@ static void write_endio(struct bio *bio, int error)
 }
 
 /*
- * This function is called when wait_on_bit is actually waiting.
- */
-static int do_io_schedule(void *word)
-{
-	io_schedule();
-
-	return 0;
-}
-
-/*
  * Initiate a write on a dirty buffer, but don't wait for it.
  *
  * - If the buffer is not dirty, exit.
@@ -640,8 +630,7 @@ static void __write_dirty_buffer(struct dm_buffer *b,
 		return;
 
 	clear_bit(B_DIRTY, &b->state);
-	wait_on_bit_lock(&b->state, B_WRITING,
-			 do_io_schedule, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_lock_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
 
 	if (!write_list)
 		submit_io(b, WRITE, b->block, write_endio);
@@ -675,9 +664,9 @@ static void __make_buffer_clean(struct dm_buffer *b)
 	if (!b->state)	/* fast case */
 		return;
 
-	wait_on_bit(&b->state, B_READING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
 	__write_dirty_buffer(b, NULL);
-	wait_on_bit(&b->state, B_WRITING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&b->state, B_WRITING, TASK_UNINTERRUPTIBLE);
 }
 
 /*
@@ -1030,7 +1019,7 @@ static void *new_read(struct dm_bufio_client *c, sector_t block,
 	if (need_submit)
 		submit_io(b, READ, b->block, read_endio);
 
-	wait_on_bit(&b->state, B_READING, do_io_schedule, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&b->state, B_READING, TASK_UNINTERRUPTIBLE);
 
 	if (b->read_error) {
 		int error = b->read_error;
@@ -1209,15 +1198,13 @@ again:
 				dropped_lock = 1;
 				b->hold_count++;
 				dm_bufio_unlock(c);
-				wait_on_bit(&b->state, B_WRITING,
-					    do_io_schedule,
-					    TASK_UNINTERRUPTIBLE);
+				wait_on_bit_io(&b->state, B_WRITING,
+					       TASK_UNINTERRUPTIBLE);
 				dm_bufio_lock(c);
 				b->hold_count--;
 			} else
-				wait_on_bit(&b->state, B_WRITING,
-					    do_io_schedule,
-					    TASK_UNINTERRUPTIBLE);
+				wait_on_bit_io(&b->state, B_WRITING,
+					       TASK_UNINTERRUPTIBLE);
 		}
 
 		if (!test_bit(B_DIRTY, &b->state) &&
@@ -1321,15 +1308,15 @@ retry:
 
 	__write_dirty_buffer(b, NULL);
 	if (b->hold_count == 1) {
-		wait_on_bit(&b->state, B_WRITING,
-			    do_io_schedule, TASK_UNINTERRUPTIBLE);
+		wait_on_bit_io(&b->state, B_WRITING,
+			       TASK_UNINTERRUPTIBLE);
 		set_bit(B_DIRTY, &b->state);
 		__unlink_buffer(b);
 		__link_buffer(b, new_block, LIST_DIRTY);
 	} else {
 		sector_t old_block;
-		wait_on_bit_lock(&b->state, B_WRITING,
-				 do_io_schedule, TASK_UNINTERRUPTIBLE);
+		wait_on_bit_lock_io(&b->state, B_WRITING,
+				    TASK_UNINTERRUPTIBLE);
 		/*
 		 * Relink buffer to "new_block" so that write_callback
 		 * sees "new_block" as a block number.
@@ -1341,8 +1328,8 @@ retry:
 		__unlink_buffer(b);
 		__link_buffer(b, new_block, b->list_mode);
 		submit_io(b, WRITE, new_block, write_endio);
-		wait_on_bit(&b->state, B_WRITING,
-			    do_io_schedule, TASK_UNINTERRUPTIBLE);
+		wait_on_bit_io(&b->state, B_WRITING,
+			       TASK_UNINTERRUPTIBLE);
 		__unlink_buffer(b);
 		__link_buffer(b, old_block, b->list_mode);
 	}
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5bd2290..864b03f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1032,21 +1032,13 @@ static void start_merge(struct dm_snapshot *s)
 		snapshot_merge_next_chunks(s);
 }
 
-static int wait_schedule(void *ptr)
-{
-	schedule();
-
-	return 0;
-}
-
 /*
  * Stop the merging process and wait until it finishes.
  */
 static void stop_merge(struct dm_snapshot *s)
 {
 	set_bit(SHUTDOWN_MERGE, &s->state_bits);
-	wait_on_bit(&s->state_bits, RUNNING_MERGE, wait_schedule,
-		    TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&s->state_bits, RUNNING_MERGE, TASK_UNINTERRUPTIBLE);
 	clear_bit(SHUTDOWN_MERGE, &s->state_bits);
 }
 
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index e355806..f296394 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -253,13 +253,6 @@ static int dvb_usbv2_adapter_stream_exit(struct dvb_usb_adapter *adap)
 	return usb_urb_exitv2(&adap->stream);
 }
 
-static int wait_schedule(void *ptr)
-{
-	schedule();
-
-	return 0;
-}
-
 static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 {
 	struct dvb_usb_adapter *adap = dvbdmxfeed->demux->priv;
@@ -273,8 +266,7 @@ static int dvb_usb_start_feed(struct dvb_demux_feed *dvbdmxfeed)
 			dvbdmxfeed->pid, dvbdmxfeed->index);
 
 	/* wait init is done */
-	wait_on_bit(&adap->state_bits, ADAP_INIT, wait_schedule,
-			TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&adap->state_bits, ADAP_INIT, TASK_UNINTERRUPTIBLE);
 
 	if (adap->active_fe == -1)
 		return -EINVAL;
@@ -568,7 +560,7 @@ static int dvb_usb_fe_sleep(struct dvb_frontend *fe)
 
 	if (!adap->suspend_resume_active) {
 		set_bit(ADAP_SLEEP, &adap->state_bits);
-		wait_on_bit(&adap->state_bits, ADAP_STREAMING, wait_schedule,
+		wait_on_bit(&adap->state_bits, ADAP_STREAMING,
 				TASK_UNINTERRUPTIBLE);
 	}
 
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index a389820..3e11aab 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3437,16 +3437,10 @@ done_unlocked:
 	return 0;
 }
 
-static int eb_wait(void *word)
-{
-	io_schedule();
-	return 0;
-}
-
 void wait_on_extent_buffer_writeback(struct extent_buffer *eb)
 {
-	wait_on_bit(&eb->bflags, EXTENT_BUFFER_WRITEBACK, eb_wait,
-		    TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&eb->bflags, EXTENT_BUFFER_WRITEBACK,
+		       TASK_UNINTERRUPTIBLE);
 }
 
 static noinline_for_stack int
diff --git a/fs/buffer.c b/fs/buffer.c
index eba6e4f..8f05111 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -61,16 +61,9 @@ inline void touch_buffer(struct buffer_head *bh)
 }
 EXPORT_SYMBOL(touch_buffer);
 
-static int sleep_on_buffer(void *word)
-{
-	io_schedule();
-	return 0;
-}
-
 void __lock_buffer(struct buffer_head *bh)
 {
-	wait_on_bit_lock(&bh->b_state, BH_Lock, sleep_on_buffer,
-							TASK_UNINTERRUPTIBLE);
+	wait_on_bit_lock_io(&bh->b_state, BH_Lock, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__lock_buffer);
 
@@ -123,7 +116,7 @@ EXPORT_SYMBOL(buffer_check_dirty_writeback);
  */
 void __wait_on_buffer(struct buffer_head * bh)
 {
-	wait_on_bit(&bh->b_state, BH_Lock, sleep_on_buffer, TASK_UNINTERRUPTIBLE);
+	wait_on_bit_io(&bh->b_state, BH_Lock, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__wait_on_buffer);
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 20d75b8..b98366f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3934,13 +3934,6 @@ cifs_sb_master_tcon(struct cifs_sb_info *cifs_sb)
 	return tlink_tcon(cifs_sb_master_tlink(cifs_sb));
 }
 
-static int
-cifs_sb_tcon_pending_wait(void *unused)
-{
-	schedule();
-	return signal_pending(current) ? -ERESTARTSYS : 0;
-}
-
 /* find and return a tlink with given uid */
 static struct tcon_link *
 tlink_rb_search(struct rb_root *root, kuid_t uid)
@@ -4039,11 +4032,10 @@ cifs_sb_tlink(struct cifs_sb_info *cifs_sb)
 	} else {
 wait_for_construction:
 		ret = wait_on_bit(&tlink->tl_flags, TCON_LINK_PENDING,
-				  cifs_sb_tcon_pending_wait,
 				  TASK_INTERRUPTIBLE);
 		if (ret) {
 			cifs_put_tlink(tlink);
-			return ERR_PTR(ret);
+			return ERR_PTR(-ERESTARTSYS);
 		}
 
 		/* if it's good, return it */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e90a1e9..b88b1ad 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3618,13 +3618,6 @@ static int cifs_launder_page(struct page *page)
 	return rc;
 }
 
-static int
-cifs_pending_writers_wait(void *unused)
-{
-	schedule();
-	return 0;
-}
-
 void cifs_oplock_break(struct work_struct *work)
 {
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
@@ -3636,7 +3629,7 @@ void cifs_oplock_break(struct work_struct *work)
 	int rc = 0;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
-			cifs_pending_writers_wait, TASK_UNINTERRUPTIBLE);
+			TASK_UNINTERRUPTIBLE);
 
 	server->ops->downgrade_oplock(server, cinode,
 		test_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cinode->flags));
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a174605..41de393 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1780,7 +1780,7 @@ cifs_invalidate_mapping(struct inode *inode)
  * @word: long word containing the bit lock
  */
 static int
-cifs_wait_bit_killable(void *word)
+cifs_wait_bit_killable(struct wait_bit_key *key)
 {
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
@@ -1794,8 +1794,8 @@ cifs_revalidate_mapping(struct inode *inode)
 	int rc;
 	unsigned long *flags = &CIFS_I(inode)->flags;
 
-	rc = wait_on_bit_lock(flags, CIFS_INO_LOCK, cifs_wait_bit_killable,
-				TASK_KILLABLE);
+	rc = wait_on_bit_lock_action(flags, CIFS_INO_LOCK, cifs_wait_bit_killable,
+				     TASK_KILLABLE);
 	if (rc)
 		return rc;
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 3b0c62e..6bf55d0 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -582,7 +582,7 @@ int cifs_get_writer(struct cifsInodeInfo *cinode)
 
 start:
 	rc = wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK,
-				   cifs_oplock_break_wait, TASK_KILLABLE);
+			 TASK_KILLABLE);
 	if (rc)
 		return rc;
 
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index be568b7..ef9bef1 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -342,7 +342,8 @@ static void __inode_wait_for_writeback(struct inode *inode)
 	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
 	while (inode->i_state & I_SYNC) {
 		spin_unlock(&inode->i_lock);
-		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
+		__wait_on_bit(wqh, &wq, bit_wait,
+			      TASK_UNINTERRUPTIBLE);
 		spin_lock(&inode->i_lock);
 	}
 }
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index aec01be..89acec7 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -160,7 +160,7 @@ void __fscache_enable_cookie(struct fscache_cookie *cookie,
 	_enter("%p", cookie);
 
 	wait_on_bit_lock(&cookie->flags, FSCACHE_COOKIE_ENABLEMENT_LOCK,
-			 fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+			 TASK_UNINTERRUPTIBLE);
 
 	if (test_bit(FSCACHE_COOKIE_ENABLED, &cookie->flags))
 		goto out_unlock;
@@ -255,7 +255,7 @@ static int fscache_acquire_non_index_cookie(struct fscache_cookie *cookie)
 	if (!fscache_defer_lookup) {
 		_debug("non-deferred lookup %p", &cookie->flags);
 		wait_on_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP,
-			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+			    TASK_UNINTERRUPTIBLE);
 		_debug("complete");
 		if (test_bit(FSCACHE_COOKIE_UNAVAILABLE, &cookie->flags))
 			goto unavailable;
@@ -463,7 +463,6 @@ void __fscache_wait_on_invalidate(struct fscache_cookie *cookie)
 	_enter("%p", cookie);
 
 	wait_on_bit(&cookie->flags, FSCACHE_COOKIE_INVALIDATING,
-		    fscache_wait_bit_interruptible,
 		    TASK_UNINTERRUPTIBLE);
 
 	_leave("");
@@ -525,7 +524,7 @@ void __fscache_disable_cookie(struct fscache_cookie *cookie, bool invalidate)
 	}
 
 	wait_on_bit_lock(&cookie->flags, FSCACHE_COOKIE_ENABLEMENT_LOCK,
-			 fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+			 TASK_UNINTERRUPTIBLE);
 	if (!test_and_clear_bit(FSCACHE_COOKIE_ENABLED, &cookie->flags))
 		goto out_unlock_enable;
 
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index bc6c08f..7872a62 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -97,8 +97,6 @@ static inline bool fscache_object_congested(void)
 	return workqueue_congested(WORK_CPU_UNBOUND, fscache_object_wq);
 }
 
-extern int fscache_wait_bit(void *);
-extern int fscache_wait_bit_interruptible(void *);
 extern int fscache_wait_atomic_t(atomic_t *);
 
 /*
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 63f868e..a31b83c 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -197,24 +197,6 @@ static void __exit fscache_exit(void)
 module_exit(fscache_exit);
 
 /*
- * wait_on_bit() sleep function for uninterruptible waiting
- */
-int fscache_wait_bit(void *flags)
-{
-	schedule();
-	return 0;
-}
-
-/*
- * wait_on_bit() sleep function for interruptible waiting
- */
-int fscache_wait_bit_interruptible(void *flags)
-{
-	schedule();
-	return signal_pending(current);
-}
-
-/*
  * wait_on_atomic_t() sleep function for uninterruptible waiting
  */
 int fscache_wait_atomic_t(atomic_t *p)
diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index ed70714..85332b9 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -298,7 +298,6 @@ int fscache_wait_for_deferred_lookup(struct fscache_cookie *cookie)
 
 	jif = jiffies;
 	if (wait_on_bit(&cookie->flags, FSCACHE_COOKIE_LOOKING_UP,
-			fscache_wait_bit_interruptible,
 			TASK_INTERRUPTIBLE) != 0) {
 		fscache_stat(&fscache_n_retrievals_intr);
 		_leave(" = -ERESTARTSYS");
@@ -342,7 +341,6 @@ int fscache_wait_for_operation_activation(struct fscache_object *object,
 	if (stat_op_waits)
 		fscache_stat(stat_op_waits);
 	if (wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
-			fscache_wait_bit_interruptible,
 			TASK_INTERRUPTIBLE) != 0) {
 		ret = fscache_cancel_op(op, do_cancel);
 		if (ret == 0)
@@ -351,7 +349,7 @@ int fscache_wait_for_operation_activation(struct fscache_object *object,
 		/* it's been removed from the pending queue by another party,
 		 * so we should get to run shortly */
 		wait_on_bit(&op->flags, FSCACHE_OP_WAITING,
-			    fscache_wait_bit, TASK_UNINTERRUPTIBLE);
+			    TASK_UNINTERRUPTIBLE);
 	}
 	_debug("<<< GO");
 
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ee4e04f..7f513b1 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -856,27 +856,6 @@ void gfs2_holder_uninit(struct gfs2_holder *gh)
 }
 
 /**
- * gfs2_glock_holder_wait
- * @word: unused
- *
- * This function and gfs2_glock_demote_wait both show up in the WCHAN
- * field. Thus I've separated these otherwise identical functions in
- * order to be more informative to the user.
- */
-
-static int gfs2_glock_holder_wait(void *word)
-{
-        schedule();
-        return 0;
-}
-
-static int gfs2_glock_demote_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
-/**
  * gfs2_glock_wait - wait on a glock acquisition
  * @gh: the glock holder
  *
@@ -888,7 +867,7 @@ int gfs2_glock_wait(struct gfs2_holder *gh)
 	unsigned long time1 = jiffies;
 
 	might_sleep();
-	wait_on_bit(&gh->gh_iflags, HIF_WAIT, gfs2_glock_holder_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&gh->gh_iflags, HIF_WAIT, TASK_UNINTERRUPTIBLE);
 	if (time_after(jiffies, time1 + HZ)) /* have we waited > a second? */
 		/* Lengthen the minimum hold time. */
 		gh->gh_gl->gl_hold_time = min(gh->gh_gl->gl_hold_time +
@@ -1128,7 +1107,7 @@ void gfs2_glock_dq_wait(struct gfs2_holder *gh)
 	struct gfs2_glock *gl = gh->gh_gl;
 	gfs2_glock_dq(gh);
 	might_sleep();
-	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, gfs2_glock_demote_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&gl->gl_flags, GLF_DEMOTE, TASK_UNINTERRUPTIBLE);
 }
 
 /**
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 4fafea1..641383a 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -936,12 +936,6 @@ fail:
 	return error;
 }
 
-static int dlm_recovery_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 static int control_first_done(struct gfs2_sbd *sdp)
 {
 	struct lm_lockstruct *ls = &sdp->sd_lockstruct;
@@ -976,7 +970,7 @@ restart:
 		fs_info(sdp, "control_first_done wait gen %u\n", start_gen);
 
 		wait_on_bit(&ls->ls_recover_flags, DFL_DLM_RECOVERY,
-			    dlm_recovery_wait, TASK_UNINTERRUPTIBLE);
+			    TASK_UNINTERRUPTIBLE);
 		goto restart;
 	}
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index bc564c0..d3eae24 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1024,20 +1024,13 @@ void gfs2_lm_unmount(struct gfs2_sbd *sdp)
 		lm->lm_unmount(sdp);
 }
 
-static int gfs2_journalid_wait(void *word)
-{
-	if (signal_pending(current))
-		return -EINTR;
-	schedule();
-	return 0;
-}
-
 static int wait_on_journal(struct gfs2_sbd *sdp)
 {
 	if (sdp->sd_lockstruct.ls_ops->lm_mount == NULL)
 		return 0;
 
-	return wait_on_bit(&sdp->sd_flags, SDF_NOJOURNALID, gfs2_journalid_wait, TASK_INTERRUPTIBLE);
+	return wait_on_bit(&sdp->sd_flags, SDF_NOJOURNALID, TASK_INTERRUPTIBLE)
+		? -EINTR : 0;
 }
 
 void gfs2_online_uevent(struct gfs2_sbd *sdp)
diff --git a/fs/gfs2/recovery.c b/fs/gfs2/recovery.c
index 94555d4..573bd3b 100644
--- a/fs/gfs2/recovery.c
+++ b/fs/gfs2/recovery.c
@@ -591,12 +591,6 @@ done:
 	wake_up_bit(&jd->jd_flags, JDF_RECOVERY);
 }
 
-static int gfs2_recovery_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 int gfs2_recover_journal(struct gfs2_jdesc *jd, bool wait)
 {
 	int rv;
@@ -609,7 +603,7 @@ int gfs2_recover_journal(struct gfs2_jdesc *jd, bool wait)
 	BUG_ON(!rv);
 
 	if (wait)
-		wait_on_bit(&jd->jd_flags, JDF_RECOVERY, gfs2_recovery_wait,
+		wait_on_bit(&jd->jd_flags, JDF_RECOVERY,
 			    TASK_UNINTERRUPTIBLE);
 
 	return wait ? jd->jd_recover_error : 0;
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 1319b5c..2607ff1 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -864,12 +864,6 @@ static int gfs2_make_fs_ro(struct gfs2_sbd *sdp)
 	return error;
 }
 
-static int gfs2_umount_recovery_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 /**
  * gfs2_put_super - Unmount the filesystem
  * @sb: The VFS superblock
@@ -894,7 +888,7 @@ restart:
 			continue;
 		spin_unlock(&sdp->sd_jindex_spin);
 		wait_on_bit(&jd->jd_flags, JDF_RECOVERY,
-			    gfs2_umount_recovery_wait, TASK_UNINTERRUPTIBLE);
+			    TASK_UNINTERRUPTIBLE);
 		goto restart;
 	}
 	spin_unlock(&sdp->sd_jindex_spin);
diff --git a/fs/inode.c b/fs/inode.c
index 6eecb7f..5938f39 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1695,13 +1695,6 @@ int inode_needs_sync(struct inode *inode)
 }
 EXPORT_SYMBOL(inode_needs_sync);
 
-int inode_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-EXPORT_SYMBOL(inode_wait);
-
 /*
  * If we try to find an inode in the inode hash while it is being
  * deleted, we have to wait until the filesystem completes its
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 6f0f590..5f09370 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -763,12 +763,6 @@ static void warn_dirty_buffer(struct buffer_head *bh)
 	       bdevname(bh->b_bdev, b), (unsigned long long)bh->b_blocknr);
 }
 
-static int sleep_on_shadow_bh(void *word)
-{
-	io_schedule();
-	return 0;
-}
-
 /*
  * If the buffer is already part of the current transaction, then there
  * is nothing we need to do.  If it is already part of a prior
@@ -906,8 +900,8 @@ repeat:
 		if (buffer_shadow(bh)) {
 			JBUFFER_TRACE(jh, "on shadow: sleep");
 			jbd_unlock_bh_state(bh);
-			wait_on_bit(&bh->b_state, BH_Shadow,
-				    sleep_on_shadow_bh, TASK_UNINTERRUPTIBLE);
+			wait_on_bit_io(&bh->b_state, BH_Shadow,
+				       TASK_UNINTERRUPTIBLE);
 			goto repeat;
 		}
 
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 4042ff5..524dd80 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -361,8 +361,8 @@ start:
 	 * Prevent starvation issues if someone is doing a consistency
 	 * sync-to-disk
 	 */
-	ret = wait_on_bit(&NFS_I(mapping->host)->flags, NFS_INO_FLUSHING,
-			nfs_wait_bit_killable, TASK_KILLABLE);
+	ret = wait_on_bit_action(&NFS_I(mapping->host)->flags, NFS_INO_FLUSHING,
+				 nfs_wait_bit_killable, TASK_KILLABLE);
 	if (ret)
 		return ret;
 
diff --git a/fs/nfs/filelayout/filelayoutdev.c b/fs/nfs/filelayout/filelayoutdev.c
index 44bf014..e2a0361 100644
--- a/fs/nfs/filelayout/filelayoutdev.c
+++ b/fs/nfs/filelayout/filelayoutdev.c
@@ -783,8 +783,8 @@ nfs4_fl_select_ds_fh(struct pnfs_layout_segment *lseg, u32 j)
 static void nfs4_wait_ds_connect(struct nfs4_pnfs_ds *ds)
 {
 	might_sleep();
-	wait_on_bit(&ds->ds_state, NFS4DS_CONNECTING,
-			nfs_wait_bit_killable, TASK_KILLABLE);
+	wait_on_bit_action(&ds->ds_state, NFS4DS_CONNECTING,
+			   nfs_wait_bit_killable, TASK_KILLABLE);
 }
 
 static void nfs4_clear_ds_conn_bit(struct nfs4_pnfs_ds *ds)
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 9927913..abd37a3 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -75,7 +75,7 @@ nfs_fattr_to_ino_t(struct nfs_fattr *fattr)
  * nfs_wait_bit_killable - helper for functions that are sleeping on bit locks
  * @word: long word containing the bit lock
  */
-int nfs_wait_bit_killable(void *word)
+int nfs_wait_bit_killable(struct wait_bit_key *key)
 {
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
@@ -1074,8 +1074,8 @@ int nfs_revalidate_mapping(struct inode *inode, struct address_space *mapping)
 	 * the bit lock here if it looks like we're going to be doing that.
 	 */
 	for (;;) {
-		ret = wait_on_bit(bitlock, NFS_INO_INVALIDATING,
-				  nfs_wait_bit_killable, TASK_KILLABLE);
+		ret = wait_on_bit_action(bitlock, NFS_INO_INVALIDATING,
+					 nfs_wait_bit_killable, TASK_KILLABLE);
 		if (ret)
 			goto out;
 		spin_lock(&inode->i_lock);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index f415cbf..617f366 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -348,7 +348,7 @@ extern int nfs_drop_inode(struct inode *);
 extern void nfs_clear_inode(struct inode *);
 extern void nfs_evict_inode(struct inode *);
 void nfs_zap_acl_cache(struct inode *inode);
-extern int nfs_wait_bit_killable(void *word);
+extern int nfs_wait_bit_killable(struct wait_bit_key *key);
 
 /* super.c */
 extern const struct super_operations nfs_sops;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 848f685..42f1211 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1251,8 +1251,8 @@ int nfs4_wait_clnt_recover(struct nfs_client *clp)
 	might_sleep();
 
 	atomic_inc(&clp->cl_count);
-	res = wait_on_bit(&clp->cl_state, NFS4CLNT_MANAGER_RUNNING,
-			nfs_wait_bit_killable, TASK_KILLABLE);
+	res = wait_on_bit_action(&clp->cl_state, NFS4CLNT_MANAGER_RUNNING,
+				 nfs_wait_bit_killable, TASK_KILLABLE);
 	if (res)
 		goto out;
 	if (clp->cl_cons_state < 0)
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index 17fab89..0be5050 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -115,7 +115,7 @@ __nfs_iocounter_wait(struct nfs_io_counter *c)
 		set_bit(NFS_IO_INPROGRESS, &c->flags);
 		if (atomic_read(&c->io_count) == 0)
 			break;
-		ret = nfs_wait_bit_killable(&c->flags);
+		ret = nfs_wait_bit_killable(&q.key);
 	} while (atomic_read(&c->io_count) != 0);
 	finish_wait(wq, &q.wait);
 	return ret;
@@ -136,12 +136,6 @@ nfs_iocounter_wait(struct nfs_io_counter *c)
 	return __nfs_iocounter_wait(c);
 }
 
-static int nfs_wait_bit_uninterruptible(void *word)
-{
-	io_schedule();
-	return 0;
-}
-
 /*
  * nfs_page_group_lock - lock the head of the page group
  * @req - request in group that is to be locked
@@ -156,7 +150,6 @@ nfs_page_group_lock(struct nfs_page *req)
 	WARN_ON_ONCE(head != head->wb_head);
 
 	wait_on_bit_lock(&head->wb_flags, PG_HEADLOCK,
-			nfs_wait_bit_uninterruptible,
 			TASK_UNINTERRUPTIBLE);
 }
 
@@ -435,9 +428,8 @@ void nfs_release_request(struct nfs_page *req)
 int
 nfs_wait_on_request(struct nfs_page *req)
 {
-	return wait_on_bit(&req->wb_flags, PG_BUSY,
-			nfs_wait_bit_uninterruptible,
-			TASK_UNINTERRUPTIBLE);
+	return wait_on_bit_io(&req->wb_flags, PG_BUSY,
+			      TASK_UNINTERRUPTIBLE);
 }
 
 /*
diff --git a/fs/nfs/pnfs.c b/fs/nfs/pnfs.c
index 6fdcd23..a8914b3 100644
--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1885,7 +1885,7 @@ pnfs_layoutcommit_inode(struct inode *inode, bool sync)
 	if (test_and_set_bit(NFS_INO_LAYOUTCOMMITTING, &nfsi->flags)) {
 		if (!sync)
 			goto out;
-		status = wait_on_bit_lock(&nfsi->flags,
+		status = wait_on_bit_lock_action(&nfsi->flags,
 				NFS_INO_LAYOUTCOMMITTING,
 				nfs_wait_bit_killable,
 				TASK_KILLABLE);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 5e2f1030..962c9ee 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -623,7 +623,7 @@ int nfs_writepages(struct address_space *mapping, struct writeback_control *wbc)
 	int err;
 
 	/* Stop dirtying of new pages while we sync */
-	err = wait_on_bit_lock(bitlock, NFS_INO_FLUSHING,
+	err = wait_on_bit_lock_action(bitlock, NFS_INO_FLUSHING,
 			nfs_wait_bit_killable, TASK_KILLABLE);
 	if (err)
 		goto out_err;
@@ -1703,7 +1703,7 @@ int nfs_commit_inode(struct inode *inode, int how)
 			return error;
 		if (!may_wait)
 			goto out_mark_dirty;
-		error = wait_on_bit(&NFS_I(inode)->flags,
+		error = wait_on_bit_action(&NFS_I(inode)->flags,
 				NFS_INO_COMMIT,
 				nfs_wait_bit_killable,
 				TASK_KILLABLE);
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 19ae05d..bf9422c 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -33,6 +33,11 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 #define DEFINE_IRQ_WORK(name, _f) struct irq_work name = { .func = (_f), }
 
 bool irq_work_queue(struct irq_work *work);
+
+#ifdef CONFIG_SMP
+bool irq_work_queue_on(struct irq_work *work, int cpu);
+#endif
+
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0376b05..02757d1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1440,8 +1440,6 @@ struct task_struct {
 	struct rb_node *pi_waiters_leftmost;
 	/* Deadlock detection and priority inheritance handling */
 	struct rt_mutex_waiter *pi_blocked_on;
-	/* Top pi_waiters task */
-	struct task_struct *pi_top_task;
 #endif
 
 #ifdef CONFIG_DEBUG_MUTEXES
@@ -2788,7 +2786,7 @@ static inline bool __must_check current_set_polling_and_test(void)
 
 	/*
 	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
+	 * paired by resched_curr()
 	 */
 	smp_mb__after_atomic();
 
@@ -2806,7 +2804,7 @@ static inline bool __must_check current_clr_polling_and_test(void)
 
 	/*
 	 * Polling state must be visible before we test NEED_RESCHED,
-	 * paired by resched_task()
+	 * paired by resched_curr()
 	 */
 	smp_mb__after_atomic();
 
@@ -2838,7 +2836,7 @@ static inline void current_clr_polling(void)
 	 * TIF_NEED_RESCHED and the IPI handler, scheduler_ipi(), will also
 	 * fold.
 	 */
-	smp_mb(); /* paired with resched_task() */
+	smp_mb(); /* paired with resched_curr() */
 
 	preempt_fold_need_resched();
 }
diff --git a/include/linux/sunrpc/sched.h b/include/linux/sunrpc/sched.h
index ad7dbe2..1a89599 100644
--- a/include/linux/sunrpc/sched.h
+++ b/include/linux/sunrpc/sched.h
@@ -236,7 +236,7 @@ void *		rpc_malloc(struct rpc_task *, size_t);
 void		rpc_free(void *);
 int		rpciod_up(void);
 void		rpciod_down(void);
-int		__rpc_wait_for_completion_task(struct rpc_task *task, int (*)(void *));
+int		__rpc_wait_for_completion_task(struct rpc_task *task, wait_bit_action_f *);
 #ifdef RPC_DEBUG
 struct net;
 void		rpc_show_tasks(struct net *);
diff --git a/include/linux/tick.h b/include/linux/tick.h
index b84773c..8a4987f 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -181,7 +181,13 @@ static inline bool tick_nohz_full_cpu(int cpu)
 
 extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
-extern void tick_nohz_full_kick(void);
+extern void tick_nohz_full_kick_cpu(int cpu);
+
+static inline void tick_nohz_full_kick(void)
+{
+	tick_nohz_full_kick_cpu(smp_processor_id());
+}
+
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
@@ -189,6 +195,7 @@ static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
+static inline void tick_nohz_full_kick_cpu(int cpu) { }
 static inline void tick_nohz_full_kick(void) { }
 static inline void tick_nohz_full_kick_all(void) { }
 static inline void __tick_nohz_task_switch(struct task_struct *tsk) { }
diff --git a/include/linux/wait.h b/include/linux/wait.h
index bd68819..6fb1ba5 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -25,6 +25,7 @@ struct wait_bit_key {
 	void			*flags;
 	int			bit_nr;
 #define WAIT_ATOMIC_T_BIT_NR	-1
+	unsigned long		private;
 };
 
 struct wait_bit_queue {
@@ -141,18 +142,19 @@ __remove_wait_queue(wait_queue_head_t *head, wait_queue_t *old)
 	list_del(&old->task_list);
 }
 
+typedef int wait_bit_action_f(struct wait_bit_key *);
 void __wake_up(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked_key(wait_queue_head_t *q, unsigned int mode, void *key);
 void __wake_up_sync_key(wait_queue_head_t *q, unsigned int mode, int nr, void *key);
 void __wake_up_locked(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr);
 void __wake_up_bit(wait_queue_head_t *, void *, int);
-int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
-int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, int (*)(void *), unsigned);
+int __wait_on_bit(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
+int __wait_on_bit_lock(wait_queue_head_t *, struct wait_bit_queue *, wait_bit_action_f *, unsigned);
 void wake_up_bit(void *, int);
 void wake_up_atomic_t(atomic_t *);
-int out_of_line_wait_on_bit(void *, int, int (*)(void *), unsigned);
-int out_of_line_wait_on_bit_lock(void *, int, int (*)(void *), unsigned);
+int out_of_line_wait_on_bit(void *, int, wait_bit_action_f *, unsigned);
+int out_of_line_wait_on_bit_lock(void *, int, wait_bit_action_f *, unsigned);
 int out_of_line_wait_on_atomic_t(atomic_t *, int (*)(atomic_t *), unsigned);
 wait_queue_head_t *bit_waitqueue(void *, int);
 
@@ -854,11 +856,14 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
 		(wait)->flags = 0;					\
 	} while (0)
 
+
+extern int bit_wait(struct wait_bit_key *);
+extern int bit_wait_io(struct wait_bit_key *);
+
 /**
  * wait_on_bit - wait for a bit to be cleared
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
- * @action: the function used to sleep, which may take special actions
  * @mode: the task state to sleep in
  *
  * There is a standard hashed waitqueue table for generic use. This
@@ -867,9 +872,62 @@ int wake_bit_function(wait_queue_t *wait, unsigned mode, int sync, void *key);
  * call wait_on_bit() in threads waiting for the bit to clear.
  * One uses wait_on_bit() where one is waiting for the bit to clear,
  * but has no intention of setting it.
+ * Returned value will be zero if the bit was cleared, or non-zero
+ * if the process received a signal and the mode permitted wakeup
+ * on that signal.
+ */
+static inline int
+wait_on_bit(void *word, int bit, unsigned mode)
+{
+	if (!test_bit(bit, word))
+		return 0;
+	return out_of_line_wait_on_bit(word, bit,
+				       bit_wait,
+				       mode);
+}
+
+/**
+ * wait_on_bit_io - wait for a bit to be cleared
+ * @word: the word being waited on, a kernel virtual address
+ * @bit: the bit of the word being waited on
+ * @mode: the task state to sleep in
+ *
+ * Use the standard hashed waitqueue table to wait for a bit
+ * to be cleared.  This is similar to wait_on_bit(), but calls
+ * io_schedule() instead of schedule() for the actual waiting.
+ *
+ * Returned value will be zero if the bit was cleared, or non-zero
+ * if the process received a signal and the mode permitted wakeup
+ * on that signal.
+ */
+static inline int
+wait_on_bit_io(void *word, int bit, unsigned mode)
+{
+	if (!test_bit(bit, word))
+		return 0;
+	return out_of_line_wait_on_bit(word, bit,
+				       bit_wait_io,
+				       mode);
+}
+
+/**
+ * wait_on_bit_action - wait for a bit to be cleared
+ * @word: the word being waited on, a kernel virtual address
+ * @bit: the bit of the word being waited on
+ * @action: the function used to sleep, which may take special actions
+ * @mode: the task state to sleep in
+ *
+ * Use the standard hashed waitqueue table to wait for a bit
+ * to be cleared, and allow the waiting action to be specified.
+ * This is like wait_on_bit() but allows fine control of how the waiting
+ * is done.
+ *
+ * Returned value will be zero if the bit was cleared, or non-zero
+ * if the process received a signal and the mode permitted wakeup
+ * on that signal.
  */
 static inline int
-wait_on_bit(void *word, int bit, int (*action)(void *), unsigned mode)
+wait_on_bit_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
 	if (!test_bit(bit, word))
 		return 0;
@@ -880,7 +938,6 @@ wait_on_bit(void *word, int bit, int (*action)(void *), unsigned mode)
  * wait_on_bit_lock - wait for a bit to be cleared, when wanting to set it
  * @word: the word being waited on, a kernel virtual address
  * @bit: the bit of the word being waited on
- * @action: the function used to sleep, which may take special actions
  * @mode: the task state to sleep in
  *
  * There is a standard hashed waitqueue table for generic use. This
@@ -891,9 +948,61 @@ wait_on_bit(void *word, int bit, int (*action)(void *), unsigned mode)
  * wait_on_bit() in threads waiting to be able to set the bit.
  * One uses wait_on_bit_lock() where one is waiting for the bit to
  * clear with the intention of setting it, and when done, clearing it.
+ *
+ * Returns zero if the bit was (eventually) found to be clear and was
+ * set.  Returns non-zero if a signal was delivered to the process and
+ * the @mode allows that signal to wake the process.
+ */
+static inline int
+wait_on_bit_lock(void *word, int bit, unsigned mode)
+{
+	if (!test_and_set_bit(bit, word))
+		return 0;
+	return out_of_line_wait_on_bit_lock(word, bit, bit_wait, mode);
+}
+
+/**
+ * wait_on_bit_lock_io - wait for a bit to be cleared, when wanting to set it
+ * @word: the word being waited on, a kernel virtual address
+ * @bit: the bit of the word being waited on
+ * @mode: the task state to sleep in
+ *
+ * Use the standard hashed waitqueue table to wait for a bit
+ * to be cleared and then to atomically set it.  This is similar
+ * to wait_on_bit(), but calls io_schedule() instead of schedule()
+ * for the actual waiting.
+ *
+ * Returns zero if the bit was (eventually) found to be clear and was
+ * set.  Returns non-zero if a signal was delivered to the process and
+ * the @mode allows that signal to wake the process.
+ */
+static inline int
+wait_on_bit_lock_io(void *word, int bit, unsigned mode)
+{
+	if (!test_and_set_bit(bit, word))
+		return 0;
+	return out_of_line_wait_on_bit_lock(word, bit, bit_wait_io, mode);
+}
+
+/**
+ * wait_on_bit_lock_action - wait for a bit to be cleared, when wanting to set it
+ * @word: the word being waited on, a kernel virtual address
+ * @bit: the bit of the word being waited on
+ * @action: the function used to sleep, which may take special actions
+ * @mode: the task state to sleep in
+ *
+ * Use the standard hashed waitqueue table to wait for a bit
+ * to be cleared and then to set it, and allow the waiting action
+ * to be specified.
+ * This is like wait_on_bit() but allows fine control of how the waiting
+ * is done.
+ *
+ * Returns zero if the bit was (eventually) found to be clear and was
+ * set.  Returns non-zero if a signal was delivered to the process and
+ * the @mode allows that signal to wake the process.
  */
 static inline int
-wait_on_bit_lock(void *word, int bit, int (*action)(void *), unsigned mode)
+wait_on_bit_lock_action(void *word, int bit, wait_bit_action_f *action, unsigned mode)
 {
 	if (!test_and_set_bit(bit, word))
 		return 0;
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 5777c13..a219be9 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -90,7 +90,6 @@ struct writeback_control {
  * fs/fs-writeback.c
  */	
 struct bdi_writeback;
-int inode_wait(void *);
 void writeback_inodes_sb(struct super_block *, enum wb_reason reason);
 void writeback_inodes_sb_nr(struct super_block *, unsigned long nr,
 							enum wb_reason reason);
@@ -105,7 +104,7 @@ void inode_wait_for_writeback(struct inode *inode);
 static inline void wait_on_inode(struct inode *inode)
 {
 	might_sleep();
-	wait_on_bit(&inode->i_state, __I_NEW, inode_wait, TASK_UNINTERRUPTIBLE);
+	wait_on_bit(&inode->i_state, __I_NEW, TASK_UNINTERRUPTIBLE);
 }
 
 /*
diff --git a/kernel/cpu.c b/kernel/cpu.c
index a343bde..81e2a38 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -274,21 +274,28 @@ void clear_tasks_mm_cpumask(int cpu)
 	rcu_read_unlock();
 }
 
-static inline void check_for_tasks(int cpu)
+static inline void check_for_tasks(int dead_cpu)
 {
-	struct task_struct *p;
-	cputime_t utime, stime;
+	struct task_struct *g, *p;
 
-	write_lock_irq(&tasklist_lock);
-	for_each_process(p) {
-		task_cputime(p, &utime, &stime);
-		if (task_cpu(p) == cpu && p->state == TASK_RUNNING &&
-		    (utime || stime))
-			pr_warn("Task %s (pid = %d) is on cpu %d (state = %ld, flags = %x)\n",
-				p->comm, task_pid_nr(p), cpu,
-				p->state, p->flags);
-	}
-	write_unlock_irq(&tasklist_lock);
+	read_lock_irq(&tasklist_lock);
+	do_each_thread(g, p) {
+		if (!p->on_rq)
+			continue;
+		/*
+		 * We do the check with unlocked task_rq(p)->lock.
+		 * Order the reading to do not warn about a task,
+		 * which was running on this cpu in the past, and
+		 * it's just been woken on another cpu.
+		 */
+		rmb();
+		if (task_cpu(p) != dead_cpu)
+			continue;
+
+		pr_warn("Task %s (pid=%d) is on cpu %d (state=%ld, flags=%x)\n",
+			p->comm, task_pid_nr(p), dead_cpu, p->state, p->flags);
+	} while_each_thread(g, p);
+	read_unlock_irq(&tasklist_lock);
 }
 
 struct take_cpu_down_param {
diff --git a/kernel/fork.c b/kernel/fork.c
index 6a13c46..962885e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1095,7 +1095,6 @@ static void rt_mutex_init_task(struct task_struct *p)
 	p->pi_waiters = RB_ROOT;
 	p->pi_waiters_leftmost = NULL;
 	p->pi_blocked_on = NULL;
-	p->pi_top_task = NULL;
 #endif
 }
 
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index a82170e..e6bcbe7 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -16,11 +16,12 @@
 #include <linux/tick.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/smp.h>
 #include <asm/processor.h>
 
 
-static DEFINE_PER_CPU(struct llist_head, irq_work_list);
-static DEFINE_PER_CPU(int, irq_work_raised);
+static DEFINE_PER_CPU(struct llist_head, raised_list);
+static DEFINE_PER_CPU(struct llist_head, lazy_list);
 
 /*
  * Claim the entry so that no one else will poke at it.
@@ -55,12 +56,34 @@ void __weak arch_irq_work_raise(void)
 	 */
 }
 
+#ifdef CONFIG_SMP
 /*
- * Enqueue the irq_work @entry unless it's already pending
+ * Enqueue the irq_work @work on @cpu unless it's already pending
  * somewhere.
  *
  * Can be re-enqueued while the callback is still in progress.
  */
+bool irq_work_queue_on(struct irq_work *work, int cpu)
+{
+	/* All work should have been flushed before going offline */
+	WARN_ON_ONCE(cpu_is_offline(cpu));
+
+	/* Arch remote IPI send/receive backend aren't NMI safe */
+	WARN_ON_ONCE(in_nmi());
+
+	/* Only queue if not already pending */
+	if (!irq_work_claim(work))
+		return false;
+
+	if (llist_add(&work->llnode, &per_cpu(raised_list, cpu)))
+		arch_send_call_function_single_ipi(cpu);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(irq_work_queue_on);
+#endif
+
+/* Enqueue the irq work @work on the current CPU */
 bool irq_work_queue(struct irq_work *work)
 {
 	/* Only queue if not already pending */
@@ -70,15 +93,13 @@ bool irq_work_queue(struct irq_work *work)
 	/* Queue the entry and raise the IPI if needed. */
 	preempt_disable();
 
-	llist_add(&work->llnode, &__get_cpu_var(irq_work_list));
-
-	/*
-	 * If the work is not "lazy" or the tick is stopped, raise the irq
-	 * work interrupt (if supported by the arch), otherwise, just wait
-	 * for the next tick.
-	 */
-	if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
-		if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
+	/* If the work is "lazy", handle it from next tick if any */
+	if (work->flags & IRQ_WORK_LAZY) {
+		if (llist_add(&work->llnode, &__get_cpu_var(lazy_list)) &&
+		    tick_nohz_tick_stopped())
+			arch_irq_work_raise();
+	} else {
+		if (llist_add(&work->llnode, &__get_cpu_var(raised_list)))
 			arch_irq_work_raise();
 	}
 
@@ -90,10 +111,11 @@ EXPORT_SYMBOL_GPL(irq_work_queue);
 
 bool irq_work_needs_cpu(void)
 {
-	struct llist_head *this_list;
+	struct llist_head *raised, *lazy;
 
-	this_list = &__get_cpu_var(irq_work_list);
-	if (llist_empty(this_list))
+	raised = &__get_cpu_var(raised_list);
+	lazy = &__get_cpu_var(lazy_list);
+	if (llist_empty(raised) && llist_empty(lazy))
 		return false;
 
 	/* All work should have been flushed before going offline */
@@ -102,28 +124,18 @@ bool irq_work_needs_cpu(void)
 	return true;
 }
 
-static void __irq_work_run(void)
+static void irq_work_run_list(struct llist_head *list)
 {
 	unsigned long flags;
 	struct irq_work *work;
-	struct llist_head *this_list;
 	struct llist_node *llnode;
 
+	BUG_ON(!irqs_disabled());
 
-	/*
-	 * Reset the "raised" state right before we check the list because
-	 * an NMI may enqueue after we find the list empty from the runner.
-	 */
-	__this_cpu_write(irq_work_raised, 0);
-	barrier();
-
-	this_list = &__get_cpu_var(irq_work_list);
-	if (llist_empty(this_list))
+	if (llist_empty(list))
 		return;
 
-	BUG_ON(!irqs_disabled());
-
-	llnode = llist_del_all(this_list);
+	llnode = llist_del_all(list);
 	while (llnode != NULL) {
 		work = llist_entry(llnode, struct irq_work, llnode);
 
@@ -149,13 +161,13 @@ static void __irq_work_run(void)
 }
 
 /*
- * Run the irq_work entries on this cpu. Requires to be ran from hardirq
- * context with local IRQs disabled.
+ * hotplug calls this through:
+ *  hotplug_cfd() -> flush_smp_call_function_queue()
  */
 void irq_work_run(void)
 {
-	BUG_ON(!in_irq());
-	__irq_work_run();
+	irq_work_run_list(&__get_cpu_var(raised_list));
+	irq_work_run_list(&__get_cpu_var(lazy_list));
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
@@ -171,35 +183,3 @@ void irq_work_sync(struct irq_work *work)
 		cpu_relax();
 }
 EXPORT_SYMBOL_GPL(irq_work_sync);
-
-#ifdef CONFIG_HOTPLUG_CPU
-static int irq_work_cpu_notify(struct notifier_block *self,
-			       unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-
-	switch (action) {
-	case CPU_DYING:
-		/* Called from stop_machine */
-		if (WARN_ON_ONCE(cpu != smp_processor_id()))
-			break;
-		__irq_work_run();
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block cpu_notify;
-
-static __init int irq_work_init_cpu_notifier(void)
-{
-	cpu_notify.notifier_call = irq_work_cpu_notify;
-	cpu_notify.priority = 0;
-	register_cpu_notifier(&cpu_notify);
-	return 0;
-}
-device_initcall(irq_work_init_cpu_notifier);
-
-#endif /* CONFIG_HOTPLUG_CPU */
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index adf9862..54e7522 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -28,12 +28,6 @@
 #include <linux/compat.h>
 
 
-static int ptrace_trapping_sleep_fn(void *flags)
-{
-	schedule();
-	return 0;
-}
-
 /*
  * ptrace a task: make the debugger its new parent and
  * move it to the ptrace list.
@@ -371,7 +365,7 @@ unlock_creds:
 out:
 	if (!retval) {
 		wait_on_bit(&task->jobctl, JOBCTL_TRAPPING_BIT,
-			    ptrace_trapping_sleep_fn, TASK_UNINTERRUPTIBLE);
+			    TASK_UNINTERRUPTIBLE);
 		proc_ptrace_connector(task, PTRACE_ATTACH);
 	}
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b..2676866 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -139,6 +139,8 @@ void update_rq_clock(struct rq *rq)
 		return;
 
 	delta = sched_clock_cpu(cpu_of(rq)) - rq->clock;
+	if (delta < 0)
+		return;
 	rq->clock += delta;
 	update_rq_clock_task(rq, delta);
 }
@@ -243,6 +245,7 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	char buf[64];
 	char *cmp;
 	int i;
+	struct inode *inode;
 
 	if (cnt > 63)
 		cnt = 63;
@@ -253,7 +256,11 @@ sched_feat_write(struct file *filp, const char __user *ubuf,
 	buf[cnt] = 0;
 	cmp = strstrip(buf);
 
+	/* Ensure the static_key remains in a consistent state */
+	inode = file_inode(filp);
+	mutex_lock(&inode->i_mutex);
 	i = sched_feat_set(cmp);
+	mutex_unlock(&inode->i_mutex);
 	if (i == __SCHED_FEAT_NR)
 		return -EINVAL;
 
@@ -587,30 +594,31 @@ static bool set_nr_if_polling(struct task_struct *p)
 #endif
 
 /*
- * resched_task - mark a task 'to be rescheduled now'.
+ * resched_curr - mark rq's current task 'to be rescheduled now'.
  *
  * On UP this means the setting of the need_resched flag, on SMP it
  * might also involve a cross-CPU call to trigger the scheduler on
  * the target CPU.
  */
-void resched_task(struct task_struct *p)
+void resched_curr(struct rq *rq)
 {
+	struct task_struct *curr = rq->curr;
 	int cpu;
 
-	lockdep_assert_held(&task_rq(p)->lock);
+	lockdep_assert_held(&rq->lock);
 
-	if (test_tsk_need_resched(p))
+	if (test_tsk_need_resched(curr))
 		return;
 
-	cpu = task_cpu(p);
+	cpu = cpu_of(rq);
 
 	if (cpu == smp_processor_id()) {
-		set_tsk_need_resched(p);
+		set_tsk_need_resched(curr);
 		set_preempt_need_resched();
 		return;
 	}
 
-	if (set_nr_and_not_polling(p))
+	if (set_nr_and_not_polling(curr))
 		smp_send_reschedule(cpu);
 	else
 		trace_sched_wake_idle_without_ipi(cpu);
@@ -623,7 +631,7 @@ void resched_cpu(int cpu)
 
 	if (!raw_spin_trylock_irqsave(&rq->lock, flags))
 		return;
-	resched_task(cpu_curr(cpu));
+	resched_curr(rq);
 	raw_spin_unlock_irqrestore(&rq->lock, flags);
 }
 
@@ -684,10 +692,16 @@ static void wake_up_idle_cpu(int cpu)
 
 static bool wake_up_full_nohz_cpu(int cpu)
 {
+	/*
+	 * We just need the target to call irq_exit() and re-evaluate
+	 * the next tick. The nohz full kick at least implies that.
+	 * If needed we can still optimize that later with an
+	 * empty IRQ.
+	 */
 	if (tick_nohz_full_cpu(cpu)) {
 		if (cpu != smp_processor_id() ||
 		    tick_nohz_tick_stopped())
-			smp_send_reschedule(cpu);
+			tick_nohz_full_kick_cpu(cpu);
 		return true;
 	}
 
@@ -730,18 +744,15 @@ static inline bool got_nohz_idle_kick(void)
 #ifdef CONFIG_NO_HZ_FULL
 bool sched_can_stop_tick(void)
 {
-       struct rq *rq;
-
-       rq = this_rq();
-
-       /* Make sure rq->nr_running update is visible after the IPI */
-       smp_rmb();
-
-       /* More than one running task need preemption */
-       if (rq->nr_running > 1)
-               return false;
+	/*
+	 * More than one running task need preemption.
+	 * nr_running update is assumed to be visible
+	 * after IPI is sent from wakers.
+	 */
+	if (this_rq()->nr_running > 1)
+		return false;
 
-       return true;
+	return true;
 }
 #endif /* CONFIG_NO_HZ_FULL */
 
@@ -1022,7 +1033,7 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
 			if (class == rq->curr->sched_class)
 				break;
 			if (class == p->sched_class) {
-				resched_task(rq->curr);
+				resched_curr(rq);
 				break;
 			}
 		}
@@ -1568,9 +1579,7 @@ void scheduler_ipi(void)
 	 */
 	preempt_fold_need_resched();
 
-	if (llist_empty(&this_rq()->wake_list)
-			&& !tick_nohz_full_cpu(smp_processor_id())
-			&& !got_nohz_idle_kick())
+	if (llist_empty(&this_rq()->wake_list) && !got_nohz_idle_kick())
 		return;
 
 	/*
@@ -1587,7 +1596,6 @@ void scheduler_ipi(void)
 	 * somewhat pessimize the simple resched case.
 	 */
 	irq_enter();
-	tick_nohz_full_check();
 	sched_ttwu_pending();
 
 	/*
@@ -2431,7 +2439,12 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 {
 	u64 ns = 0;
 
-	if (task_current(rq, p)) {
+	/*
+	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
+	 * project cycles that may never be accounted to this
+	 * thread, breaking clock_gettime().
+	 */
+	if (task_current(rq, p) && p->on_rq) {
 		update_rq_clock(rq);
 		ns = rq_clock_task(rq) - p->se.exec_start;
 		if ((s64)ns < 0)
@@ -2474,8 +2487,10 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 	 * If we race with it leaving cpu, we'll take a lock. So we're correct.
 	 * If we race with it entering cpu, unaccounted time is 0. This is
 	 * indistinguishable from the read occurring a few cycles earlier.
+	 * If we see ->on_cpu without ->on_rq, the task is leaving, and has
+	 * been accounted, so we're correct here as well.
 	 */
-	if (!p->on_cpu)
+	if (!p->on_cpu || !p->on_rq)
 		return p->se.sum_exec_runtime;
 #endif
 
@@ -2971,7 +2986,6 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	}
 
 	trace_sched_pi_setprio(p, prio);
-	p->pi_top_task = rt_mutex_get_top_task(p);
 	oldprio = p->prio;
 	prev_class = p->sched_class;
 	on_rq = p->on_rq;
@@ -2991,8 +3005,9 @@ void rt_mutex_setprio(struct task_struct *p, int prio)
 	 *          running task
 	 */
 	if (dl_prio(prio)) {
-		if (!dl_prio(p->normal_prio) || (p->pi_top_task &&
-			dl_entity_preempt(&p->pi_top_task->dl, &p->dl))) {
+		struct task_struct *pi_task = rt_mutex_get_top_task(p);
+		if (!dl_prio(p->normal_prio) ||
+		    (pi_task && dl_entity_preempt(&pi_task->dl, &p->dl))) {
 			p->dl.dl_boosted = 1;
 			p->dl.dl_throttled = 0;
 			enqueue_flag = ENQUEUE_REPLENISH;
@@ -3064,7 +3079,7 @@ void set_user_nice(struct task_struct *p, long nice)
 		 * lowered its priority, then reschedule its CPU:
 		 */
 		if (delta < 0 || (delta > 0 && task_running(rq, p)))
-			resched_task(rq->curr);
+			resched_curr(rq);
 	}
 out_unlock:
 	task_rq_unlock(rq, p, &flags);
@@ -3203,12 +3218,18 @@ __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 	dl_se->dl_yielded = 0;
 }
 
+/*
+ * sched_setparam() passes in -1 for its policy, to let the functions
+ * it calls know not to change it.
+ */
+#define SETPARAM_POLICY	-1
+
 static void __setscheduler_params(struct task_struct *p,
 		const struct sched_attr *attr)
 {
 	int policy = attr->sched_policy;
 
-	if (policy == -1) /* setparam */
+	if (policy == SETPARAM_POLICY)
 		policy = p->policy;
 
 	p->policy = policy;
@@ -3557,10 +3578,8 @@ static int _sched_setscheduler(struct task_struct *p, int policy,
 		.sched_nice	= PRIO_TO_NICE(p->static_prio),
 	};
 
-	/*
-	 * Fixup the legacy SCHED_RESET_ON_FORK hack
-	 */
-	if (policy & SCHED_RESET_ON_FORK) {
+	/* Fixup the legacy SCHED_RESET_ON_FORK hack. */
+	if ((policy != SETPARAM_POLICY) && (policy & SCHED_RESET_ON_FORK)) {
 		attr.sched_flags |= SCHED_FLAG_RESET_ON_FORK;
 		policy &= ~SCHED_RESET_ON_FORK;
 		attr.sched_policy = policy;
@@ -3730,7 +3749,7 @@ SYSCALL_DEFINE3(sched_setscheduler, pid_t, pid, int, policy,
  */
 SYSCALL_DEFINE2(sched_setparam, pid_t, pid, struct sched_param __user *, param)
 {
-	return do_sched_setscheduler(pid, -1, param);
+	return do_sched_setscheduler(pid, SETPARAM_POLICY, param);
 }
 
 /**
@@ -4285,7 +4304,7 @@ again:
 		 * fairness.
 		 */
 		if (preempt && rq != p_rq)
-			resched_task(p_rq->curr);
+			resched_curr(p_rq);
 	}
 
 out_unlock:
@@ -6465,6 +6484,20 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
 		sd->child = child;
+
+		if (!cpumask_subset(sched_domain_span(child),
+				    sched_domain_span(sd))) {
+			pr_err("BUG: arch topology borken\n");
+#ifdef CONFIG_SCHED_DEBUG
+			pr_err("     the %s domain not a subset of the %s domain\n",
+					child->name, sd->name);
+#endif
+			/* Fixup, ensure @sd has at least @child cpus. */
+			cpumask_or(sched_domain_span(sd),
+				   sched_domain_span(sd),
+				   sched_domain_span(child));
+		}
+
 	}
 	set_domain_attribute(sd, attr);
 
@@ -7092,7 +7125,7 @@ static void normalize_task(struct rq *rq, struct task_struct *p)
 	__setscheduler(rq, p, &attr);
 	if (on_rq) {
 		enqueue_task(rq, p, 0);
-		resched_task(rq->curr);
+		resched_curr(rq);
 	}
 
 	check_class_changed(rq, p, prev_class, old_prio);
@@ -7803,6 +7836,11 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	if (period > max_cfs_quota_period)
 		return -EINVAL;
 
+	/*
+	 * Prevent race between setting of cfs_rq->runtime_enabled and
+	 * unthrottle_offline_cfs_rqs().
+	 */
+	get_online_cpus();
 	mutex_lock(&cfs_constraints_mutex);
 	ret = __cfs_schedulable(tg, period, quota);
 	if (ret)
@@ -7828,7 +7866,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 	}
 	raw_spin_unlock_irq(&cfs_b->lock);
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		struct cfs_rq *cfs_rq = tg->cfs_rq[i];
 		struct rq *rq = cfs_rq->rq;
 
@@ -7844,6 +7882,7 @@ static int tg_set_cfs_bandwidth(struct task_group *tg, u64 period, u64 quota)
 		cfs_bandwidth_usage_dec();
 out_unlock:
 	mutex_unlock(&cfs_constraints_mutex);
+	put_online_cpus();
 
 	return ret;
 }
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index fc4f98b1..255ce13 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -306,7 +306,7 @@ static inline void setup_new_dl_entity(struct sched_dl_entity *dl_se,
  * the overrunning entity can't interfere with other entity in the system and
  * can't make them miss their deadlines. Reasons why this kind of overruns
  * could happen are, typically, a entity voluntarily trying to overcome its
- * runtime, or it just underestimated it during sched_setscheduler_ex().
+ * runtime, or it just underestimated it during sched_setattr().
  */
 static void replenish_dl_entity(struct sched_dl_entity *dl_se,
 				struct sched_dl_entity *pi_se)
@@ -535,7 +535,7 @@ again:
 		if (task_has_dl_policy(rq->curr))
 			check_preempt_curr_dl(rq, p, 0);
 		else
-			resched_task(rq->curr);
+			resched_curr(rq);
 #ifdef CONFIG_SMP
 		/*
 		 * Queueing this task back might have overloaded rq,
@@ -634,7 +634,7 @@ static void update_curr_dl(struct rq *rq)
 			enqueue_task_dl(rq, curr, ENQUEUE_REPLENISH);
 
 		if (!is_leftmost(curr, &rq->dl))
-			resched_task(curr);
+			resched_curr(rq);
 	}
 
 	/*
@@ -964,7 +964,7 @@ static void check_preempt_equal_dl(struct rq *rq, struct task_struct *p)
 	    cpudl_find(&rq->rd->cpudl, p, NULL) != -1)
 		return;
 
-	resched_task(rq->curr);
+	resched_curr(rq);
 }
 
 static int pull_dl_task(struct rq *this_rq);
@@ -979,7 +979,7 @@ static void check_preempt_curr_dl(struct rq *rq, struct task_struct *p,
 				  int flags)
 {
 	if (dl_entity_preempt(&p->dl, &rq->curr->dl)) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return;
 	}
 
@@ -1333,7 +1333,7 @@ retry:
 	if (dl_task(rq->curr) &&
 	    dl_time_before(next_task->dl.deadline, rq->curr->dl.deadline) &&
 	    rq->curr->nr_cpus_allowed > 1) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return 0;
 	}
 
@@ -1373,7 +1373,7 @@ retry:
 	set_task_cpu(next_task, later_rq->cpu);
 	activate_task(later_rq, next_task, 0);
 
-	resched_task(later_rq->curr);
+	resched_curr(later_rq);
 
 	double_unlock_balance(rq, later_rq);
 
@@ -1632,14 +1632,14 @@ static void prio_changed_dl(struct rq *rq, struct task_struct *p,
 		 */
 		if (dl_time_before(rq->dl.earliest_dl.curr, p->dl.deadline) &&
 		    rq->curr == p)
-			resched_task(p);
+			resched_curr(rq);
 #else
 		/*
 		 * Again, we don't know if p has a earlier
 		 * or later deadline, so let's blindly set a
 		 * (maybe not needed) rescheduling point.
 		 */
-		resched_task(p);
+		resched_curr(rq);
 #endif /* CONFIG_SMP */
 	} else
 		switched_to_dl(rq, p);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fea7d33..bfa3c86 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1062,7 +1062,6 @@ static void update_numa_stats(struct numa_stats *ns, int nid)
 	if (!cpus)
 		return;
 
-	ns->load = (ns->load * SCHED_CAPACITY_SCALE) / ns->compute_capacity;
 	ns->task_capacity =
 		DIV_ROUND_CLOSEST(ns->compute_capacity, SCHED_CAPACITY_SCALE);
 	ns->has_free_capacity = (ns->nr_running < ns->task_capacity);
@@ -1096,18 +1095,30 @@ static void task_numa_assign(struct task_numa_env *env,
 	env->best_cpu = env->dst_cpu;
 }
 
-static bool load_too_imbalanced(long orig_src_load, long orig_dst_load,
-				long src_load, long dst_load,
+static bool load_too_imbalanced(long src_load, long dst_load,
 				struct task_numa_env *env)
 {
 	long imb, old_imb;
+	long orig_src_load, orig_dst_load;
+	long src_capacity, dst_capacity;
+
+	/*
+	 * The load is corrected for the CPU capacity available on each node.
+	 *
+	 * src_load        dst_load
+	 * ------------ vs ---------
+	 * src_capacity    dst_capacity
+	 */
+	src_capacity = env->src_stats.compute_capacity;
+	dst_capacity = env->dst_stats.compute_capacity;
 
 	/* We care about the slope of the imbalance, not the direction. */
 	if (dst_load < src_load)
 		swap(dst_load, src_load);
 
 	/* Is the difference below the threshold? */
-	imb = dst_load * 100 - src_load * env->imbalance_pct;
+	imb = dst_load * src_capacity * 100 -
+	      src_load * dst_capacity * env->imbalance_pct;
 	if (imb <= 0)
 		return false;
 
@@ -1115,10 +1126,14 @@ static bool load_too_imbalanced(long orig_src_load, long orig_dst_load,
 	 * The imbalance is above the allowed threshold.
 	 * Compare it with the old imbalance.
 	 */
+	orig_src_load = env->src_stats.load;
+	orig_dst_load = env->dst_stats.load;
+
 	if (orig_dst_load < orig_src_load)
 		swap(orig_dst_load, orig_src_load);
 
-	old_imb = orig_dst_load * 100 - orig_src_load * env->imbalance_pct;
+	old_imb = orig_dst_load * src_capacity * 100 -
+		  orig_src_load * dst_capacity * env->imbalance_pct;
 
 	/* Would this change make things worse? */
 	return (imb > old_imb);
@@ -1136,10 +1151,10 @@ static void task_numa_compare(struct task_numa_env *env,
 	struct rq *src_rq = cpu_rq(env->src_cpu);
 	struct rq *dst_rq = cpu_rq(env->dst_cpu);
 	struct task_struct *cur;
-	long orig_src_load, src_load;
-	long orig_dst_load, dst_load;
+	long src_load, dst_load;
 	long load;
-	long imp = (groupimp > 0) ? groupimp : taskimp;
+	long imp = env->p->numa_group ? groupimp : taskimp;
+	long moveimp = imp;
 
 	rcu_read_lock();
 	cur = ACCESS_ONCE(dst_rq->curr);
@@ -1177,11 +1192,6 @@ static void task_numa_compare(struct task_numa_env *env,
 			 * itself (not part of a group), use the task weight
 			 * instead.
 			 */
-			if (env->p->numa_group)
-				imp = groupimp;
-			else
-				imp = taskimp;
-
 			if (cur->numa_group)
 				imp += group_weight(cur, env->src_nid) -
 				       group_weight(cur, env->dst_nid);
@@ -1191,7 +1201,7 @@ static void task_numa_compare(struct task_numa_env *env,
 		}
 	}
 
-	if (imp < env->best_imp)
+	if (imp <= env->best_imp && moveimp <= env->best_imp)
 		goto unlock;
 
 	if (!cur) {
@@ -1204,20 +1214,34 @@ static void task_numa_compare(struct task_numa_env *env,
 	}
 
 	/* Balance doesn't matter much if we're running a task per cpu */
-	if (src_rq->nr_running == 1 && dst_rq->nr_running == 1)
+	if (imp > env->best_imp && src_rq->nr_running == 1 &&
+			dst_rq->nr_running == 1)
 		goto assign;
 
 	/*
 	 * In the overloaded case, try and keep the load balanced.
 	 */
 balance:
-	orig_dst_load = env->dst_stats.load;
-	orig_src_load = env->src_stats.load;
-
-	/* XXX missing capacity terms */
 	load = task_h_load(env->p);
-	dst_load = orig_dst_load + load;
-	src_load = orig_src_load - load;
+	dst_load = env->dst_stats.load + load;
+	src_load = env->src_stats.load - load;
+
+	if (moveimp > imp && moveimp > env->best_imp) {
+		/*
+		 * If the improvement from just moving env->p direction is
+		 * better than swapping tasks around, check if a move is
+		 * possible. Store a slightly smaller score than moveimp,
+		 * so an actually idle CPU will win.
+		 */
+		if (!load_too_imbalanced(src_load, dst_load, env)) {
+			imp = moveimp - 1;
+			cur = NULL;
+			goto assign;
+		}
+	}
+
+	if (imp <= env->best_imp)
+		goto unlock;
 
 	if (cur) {
 		load = task_h_load(cur);
@@ -1225,8 +1249,7 @@ balance:
 		src_load += load;
 	}
 
-	if (load_too_imbalanced(orig_src_load, orig_dst_load,
-				src_load, dst_load, env))
+	if (load_too_imbalanced(src_load, dst_load, env))
 		goto unlock;
 
 assign:
@@ -1302,9 +1325,8 @@ static int task_numa_migrate(struct task_struct *p)
 	groupimp = group_weight(p, env.dst_nid) - groupweight;
 	update_numa_stats(&env.dst_stats, env.dst_nid);
 
-	/* If the preferred nid has free capacity, try to use it. */
-	if (env.dst_stats.has_free_capacity)
-		task_numa_find_cpu(&env, taskimp, groupimp);
+	/* Try to find a spot on the preferred nid. */
+	task_numa_find_cpu(&env, taskimp, groupimp);
 
 	/* No space available on the preferred nid. Look elsewhere. */
 	if (env.best_cpu == -1) {
@@ -1324,10 +1346,6 @@ static int task_numa_migrate(struct task_struct *p)
 		}
 	}
 
-	/* No better CPU than the current one was found. */
-	if (env.best_cpu == -1)
-		return -EAGAIN;
-
 	/*
 	 * If the task is part of a workload that spans multiple NUMA nodes,
 	 * and is migrating into one of the workload's active nodes, remember
@@ -1336,8 +1354,19 @@ static int task_numa_migrate(struct task_struct *p)
 	 * A task that migrated to a second choice node will be better off
 	 * trying for a better one later. Do not set the preferred node here.
 	 */
-	if (p->numa_group && node_isset(env.dst_nid, p->numa_group->active_nodes))
-		sched_setnuma(p, env.dst_nid);
+	if (p->numa_group) {
+		if (env.best_cpu == -1)
+			nid = env.src_nid;
+		else
+			nid = env.dst_nid;
+
+		if (node_isset(nid, p->numa_group->active_nodes))
+			sched_setnuma(p, env.dst_nid);
+	}
+
+	/* No better CPU than the current one was found. */
+	if (env.best_cpu == -1)
+		return -EAGAIN;
 
 	/*
 	 * Reset the scan period if the task is being rescheduled on an
@@ -1415,12 +1444,12 @@ static void update_numa_active_node_mask(struct numa_group *numa_group)
 /*
  * When adapting the scan rate, the period is divided into NUMA_PERIOD_SLOTS
  * increments. The more local the fault statistics are, the higher the scan
- * period will be for the next scan window. If local/remote ratio is below
- * NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS) the
- * scan period will decrease
+ * period will be for the next scan window. If local/(local+remote) ratio is
+ * below NUMA_PERIOD_THRESHOLD (where range of ratio is 1..NUMA_PERIOD_SLOTS)
+ * the scan period will decrease. Aim for 70% local accesses.
  */
 #define NUMA_PERIOD_SLOTS 10
-#define NUMA_PERIOD_THRESHOLD 3
+#define NUMA_PERIOD_THRESHOLD 7
 
 /*
  * Increase the scan period (slow down scanning) if the majority of
@@ -1595,30 +1624,17 @@ static void task_numa_placement(struct task_struct *p)
 
 	if (p->numa_group) {
 		update_numa_active_node_mask(p->numa_group);
-		/*
-		 * If the preferred task and group nids are different,
-		 * iterate over the nodes again to find the best place.
-		 */
-		if (max_nid != max_group_nid) {
-			unsigned long weight, max_weight = 0;
-
-			for_each_online_node(nid) {
-				weight = task_weight(p, nid) + group_weight(p, nid);
-				if (weight > max_weight) {
-					max_weight = weight;
-					max_nid = nid;
-				}
-			}
-		}
-
 		spin_unlock_irq(group_lock);
+		max_nid = max_group_nid;
 	}
 
-	/* Preferred node as the node with the most faults */
-	if (max_faults && max_nid != p->numa_preferred_nid) {
-		/* Update the preferred nid and migrate task if possible */
-		sched_setnuma(p, max_nid);
-		numa_migrate_preferred(p);
+	if (max_faults) {
+		/* Set the new preferred node */
+		if (max_nid != p->numa_preferred_nid)
+			sched_setnuma(p, max_nid);
+
+		if (task_node(p) != p->numa_preferred_nid)
+			numa_migrate_preferred(p);
 	}
 }
 
@@ -2899,7 +2915,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 	ideal_runtime = sched_slice(cfs_rq, curr);
 	delta_exec = curr->sum_exec_runtime - curr->prev_sum_exec_runtime;
 	if (delta_exec > ideal_runtime) {
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 		/*
 		 * The current task ran long enough, ensure it doesn't get
 		 * re-elected due to buddy favours.
@@ -2923,7 +2939,7 @@ check_preempt_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr)
 		return;
 
 	if (delta > ideal_runtime)
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 }
 
 static void
@@ -3063,7 +3079,7 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
 	 * validating it and just reschedule.
 	 */
 	if (queued) {
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 		return;
 	}
 	/*
@@ -3254,7 +3270,7 @@ static void __account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 	 * hierarchy can be throttled
 	 */
 	if (!assign_cfs_rq_runtime(cfs_rq) && likely(cfs_rq->curr))
-		resched_task(rq_of(cfs_rq)->curr);
+		resched_curr(rq_of(cfs_rq));
 }
 
 static __always_inline
@@ -3360,7 +3376,11 @@ static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
 	cfs_rq->throttled = 1;
 	cfs_rq->throttled_clock = rq_clock(rq);
 	raw_spin_lock(&cfs_b->lock);
-	list_add_tail_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
+	/*
+	 * Add to the _head_ of the list, so that an already-started
+	 * distribute_cfs_runtime will not see us
+	 */
+	list_add_rcu(&cfs_rq->throttled_list, &cfs_b->throttled_cfs_rq);
 	if (!cfs_b->timer_active)
 		__start_cfs_bandwidth(cfs_b, false);
 	raw_spin_unlock(&cfs_b->lock);
@@ -3410,14 +3430,15 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 
 	/* determine whether we need to wake up potentially idle cpu */
 	if (rq->curr == rq->idle && rq->cfs.nr_running)
-		resched_task(rq->curr);
+		resched_curr(rq);
 }
 
 static u64 distribute_cfs_runtime(struct cfs_bandwidth *cfs_b,
 		u64 remaining, u64 expires)
 {
 	struct cfs_rq *cfs_rq;
-	u64 runtime = remaining;
+	u64 runtime;
+	u64 starting_runtime = remaining;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(cfs_rq, &cfs_b->throttled_cfs_rq,
@@ -3448,7 +3469,7 @@ next:
 	}
 	rcu_read_unlock();
 
-	return remaining;
+	return starting_runtime - remaining;
 }
 
 /*
@@ -3494,22 +3515,17 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 	/* account preceding periods in which throttling occurred */
 	cfs_b->nr_throttled += overrun;
 
-	/*
-	 * There are throttled entities so we must first use the new bandwidth
-	 * to unthrottle them before making it generally available.  This
-	 * ensures that all existing debts will be paid before a new cfs_rq is
-	 * allowed to run.
-	 */
-	runtime = cfs_b->runtime;
 	runtime_expires = cfs_b->runtime_expires;
-	cfs_b->runtime = 0;
 
 	/*
-	 * This check is repeated as we are holding onto the new bandwidth
-	 * while we unthrottle.  This can potentially race with an unthrottled
-	 * group trying to acquire new bandwidth from the global pool.
+	 * This check is repeated as we are holding onto the new bandwidth while
+	 * we unthrottle. This can potentially race with an unthrottled group
+	 * trying to acquire new bandwidth from the global pool. This can result
+	 * in us over-using our runtime if it is all used during this loop, but
+	 * only by limited amounts in that extreme case.
 	 */
-	while (throttled && runtime > 0) {
+	while (throttled && cfs_b->runtime > 0) {
+		runtime = cfs_b->runtime;
 		raw_spin_unlock(&cfs_b->lock);
 		/* we can't nest cfs_b->lock while distributing bandwidth */
 		runtime = distribute_cfs_runtime(cfs_b, runtime,
@@ -3517,10 +3533,10 @@ static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun)
 		raw_spin_lock(&cfs_b->lock);
 
 		throttled = !list_empty(&cfs_b->throttled_cfs_rq);
+
+		cfs_b->runtime -= min(runtime, cfs_b->runtime);
 	}
 
-	/* return (any) remaining runtime */
-	cfs_b->runtime = runtime;
 	/*
 	 * While we are ensured activity in the period following an
 	 * unthrottle, this also covers the case in which the new bandwidth is
@@ -3631,10 +3647,9 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 		return;
 	}
 
-	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice) {
+	if (cfs_b->quota != RUNTIME_INF && cfs_b->runtime > slice)
 		runtime = cfs_b->runtime;
-		cfs_b->runtime = 0;
-	}
+
 	expires = cfs_b->runtime_expires;
 	raw_spin_unlock(&cfs_b->lock);
 
@@ -3645,7 +3660,7 @@ static void do_sched_cfs_slack_timer(struct cfs_bandwidth *cfs_b)
 
 	raw_spin_lock(&cfs_b->lock);
 	if (expires == cfs_b->runtime_expires)
-		cfs_b->runtime = runtime;
+		cfs_b->runtime -= min(runtime, cfs_b->runtime);
 	raw_spin_unlock(&cfs_b->lock);
 }
 
@@ -3775,6 +3790,19 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
+static void __maybe_unused update_runtime_enabled(struct rq *rq)
+{
+	struct cfs_rq *cfs_rq;
+
+	for_each_leaf_cfs_rq(rq, cfs_rq) {
+		struct cfs_bandwidth *cfs_b = &cfs_rq->tg->cfs_bandwidth;
+
+		raw_spin_lock(&cfs_b->lock);
+		cfs_rq->runtime_enabled = cfs_b->quota != RUNTIME_INF;
+		raw_spin_unlock(&cfs_b->lock);
+	}
+}
+
 static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
@@ -3788,6 +3816,12 @@ static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 		 * there's some valid quota amount
 		 */
 		cfs_rq->runtime_remaining = 1;
+		/*
+		 * Offline rq is schedulable till cpu is completely disabled
+		 * in take_cpu_down(), so we prevent new cfs throttling here.
+		 */
+		cfs_rq->runtime_enabled = 0;
+
 		if (cfs_rq_throttled(cfs_rq))
 			unthrottle_cfs_rq(cfs_rq);
 	}
@@ -3831,6 +3865,7 @@ static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
 	return NULL;
 }
 static inline void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b) {}
+static inline void update_runtime_enabled(struct rq *rq) {}
 static inline void unthrottle_offline_cfs_rqs(struct rq *rq) {}
 
 #endif /* CONFIG_CFS_BANDWIDTH */
@@ -3854,7 +3889,7 @@ static void hrtick_start_fair(struct rq *rq, struct task_struct *p)
 
 		if (delta < 0) {
 			if (rq->curr == p)
-				resched_task(p);
+				resched_curr(rq);
 			return;
 		}
 
@@ -4723,7 +4758,7 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int wake_
 	return;
 
 preempt:
-	resched_task(curr);
+	resched_curr(rq);
 	/*
 	 * Only set the backward buddy when the current task is still
 	 * on the rq. This can happen when a wakeup gets interleaved
@@ -5094,8 +5129,7 @@ static void move_task(struct task_struct *p, struct lb_env *env)
 /*
  * Is this task likely cache-hot:
  */
-static int
-task_hot(struct task_struct *p, u64 now)
+static int task_hot(struct task_struct *p, struct lb_env *env)
 {
 	s64 delta;
 
@@ -5108,7 +5142,7 @@ task_hot(struct task_struct *p, u64 now)
 	/*
 	 * Buddy candidates are cache hot:
 	 */
-	if (sched_feat(CACHE_HOT_BUDDY) && this_rq()->nr_running &&
+	if (sched_feat(CACHE_HOT_BUDDY) && env->dst_rq->nr_running &&
 			(&p->se == cfs_rq_of(&p->se)->next ||
 			 &p->se == cfs_rq_of(&p->se)->last))
 		return 1;
@@ -5118,7 +5152,7 @@ task_hot(struct task_struct *p, u64 now)
 	if (sysctl_sched_migration_cost == 0)
 		return 0;
 
-	delta = now - p->se.exec_start;
+	delta = rq_clock_task(env->src_rq) - p->se.exec_start;
 
 	return delta < (s64)sysctl_sched_migration_cost;
 }
@@ -5272,7 +5306,7 @@ int can_migrate_task(struct task_struct *p, struct lb_env *env)
 	 * 2) task is cache cold, or
 	 * 3) too many balance attempts have failed.
 	 */
-	tsk_cache_hot = task_hot(p, rq_clock_task(env->src_rq));
+	tsk_cache_hot = task_hot(p, env);
 	if (!tsk_cache_hot)
 		tsk_cache_hot = migrate_degrades_locality(p, env);
 
@@ -5864,10 +5898,12 @@ static inline int sg_capacity_factor(struct lb_env *env, struct sched_group *gro
  * @load_idx: Load index of sched_domain of this_cpu for load calc.
  * @local_group: Does group contain this_cpu.
  * @sgs: variable to hold the statistics for this group.
+ * @overload: Indicate more than one runnable task for any CPU.
  */
 static inline void update_sg_lb_stats(struct lb_env *env,
 			struct sched_group *group, int load_idx,
-			int local_group, struct sg_lb_stats *sgs)
+			int local_group, struct sg_lb_stats *sgs,
+			bool *overload)
 {
 	unsigned long load;
 	int i;
@@ -5885,6 +5921,10 @@ static inline void update_sg_lb_stats(struct lb_env *env,
 
 		sgs->group_load += load;
 		sgs->sum_nr_running += rq->nr_running;
+
+		if (rq->nr_running > 1)
+			*overload = true;
+
 #ifdef CONFIG_NUMA_BALANCING
 		sgs->nr_numa_running += rq->nr_numa_running;
 		sgs->nr_preferred_running += rq->nr_preferred_running;
@@ -5995,6 +6035,7 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	struct sched_group *sg = env->sd->groups;
 	struct sg_lb_stats tmp_sgs;
 	int load_idx, prefer_sibling = 0;
+	bool overload = false;
 
 	if (child && child->flags & SD_PREFER_SIBLING)
 		prefer_sibling = 1;
@@ -6015,7 +6056,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 				update_group_capacity(env->sd, env->dst_cpu);
 		}
 
-		update_sg_lb_stats(env, sg, load_idx, local_group, sgs);
+		update_sg_lb_stats(env, sg, load_idx, local_group, sgs,
+						&overload);
 
 		if (local_group)
 			goto next_group;
@@ -6049,6 +6091,13 @@ next_group:
 
 	if (env->sd->flags & SD_NUMA)
 		env->fbq_type = fbq_classify_group(&sds->busiest_stat);
+
+	if (!env->sd->parent) {
+		/* update overload indicator if we are at root domain */
+		if (env->dst_rq->rd->overload != overload)
+			env->dst_rq->rd->overload = overload;
+	}
+
 }
 
 /**
@@ -6767,7 +6816,8 @@ static int idle_balance(struct rq *this_rq)
 	 */
 	this_rq->idle_stamp = rq_clock(this_rq);
 
-	if (this_rq->avg_idle < sysctl_sched_migration_cost) {
+	if (this_rq->avg_idle < sysctl_sched_migration_cost ||
+	    !this_rq->rd->overload) {
 		rcu_read_lock();
 		sd = rcu_dereference_check_sched_domain(this_rq->sd);
 		if (sd)
@@ -7325,6 +7375,8 @@ void trigger_load_balance(struct rq *rq)
 static void rq_online_fair(struct rq *rq)
 {
 	update_sysctl();
+
+	update_runtime_enabled(rq);
 }
 
 static void rq_offline_fair(struct rq *rq)
@@ -7398,7 +7450,7 @@ static void task_fork_fair(struct task_struct *p)
 		 * 'current' within the tree based on its new key value.
 		 */
 		swap(curr->vruntime, se->vruntime);
-		resched_task(rq->curr);
+		resched_curr(rq);
 	}
 
 	se->vruntime -= cfs_rq->min_vruntime;
@@ -7423,7 +7475,7 @@ prio_changed_fair(struct rq *rq, struct task_struct *p, int oldprio)
 	 */
 	if (rq->curr == p) {
 		if (p->prio > oldprio)
-			resched_task(rq->curr);
+			resched_curr(rq);
 	} else
 		check_preempt_curr(rq, p, 0);
 }
@@ -7486,7 +7538,7 @@ static void switched_to_fair(struct rq *rq, struct task_struct *p)
 	 * if we can still preempt the current task.
 	 */
 	if (rq->curr == p)
-		resched_task(rq->curr);
+		resched_curr(rq);
 	else
 		check_preempt_curr(rq, p, 0);
 }
diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
index cf009fb..9f1608f 100644
--- a/kernel/sched/idle.c
+++ b/kernel/sched/idle.c
@@ -79,7 +79,7 @@ static void cpuidle_idle_call(void)
 	struct cpuidle_device *dev = __this_cpu_read(cpuidle_devices);
 	struct cpuidle_driver *drv = cpuidle_get_cpu_driver(dev);
 	int next_state, entered_state;
-	bool broadcast;
+	unsigned int broadcast;
 
 	/*
 	 * Check if the idle task must be rescheduled. If it is the
@@ -135,7 +135,7 @@ use_default:
 		goto exit_idle;
 	}
 
-	broadcast = !!(drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP);
+	broadcast = drv->states[next_state].flags & CPUIDLE_FLAG_TIMER_STOP;
 
 	/*
 	 * Tell the time framework to switch to a broadcast timer
diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
index 879f2b7..67ad4e7 100644
--- a/kernel/sched/idle_task.c
+++ b/kernel/sched/idle_task.c
@@ -20,7 +20,7 @@ select_task_rq_idle(struct task_struct *p, int cpu, int sd_flag, int flags)
  */
 static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int flags)
 {
-	resched_task(rq->idle);
+	resched_curr(rq);
 }
 
 static struct task_struct *
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index a490831..5f6edca 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -463,9 +463,10 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
 	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
+	struct rq *rq = rq_of_rt_rq(rt_rq);
 	struct sched_rt_entity *rt_se;
 
-	int cpu = cpu_of(rq_of_rt_rq(rt_rq));
+	int cpu = cpu_of(rq);
 
 	rt_se = rt_rq->tg->rt_se[cpu];
 
@@ -476,7 +477,7 @@ static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 			enqueue_rt_entity(rt_se, false);
 
 		if (rt_rq->highest_prio.curr < curr->prio)
-			resched_task(curr);
+			resched_curr(rq);
 	}
 }
 
@@ -566,7 +567,7 @@ static inline void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 		return;
 
 	enqueue_top_rt_rq(rt_rq);
-	resched_task(rq->curr);
+	resched_curr(rq);
 }
 
 static inline void sched_rt_rq_dequeue(struct rt_rq *rt_rq)
@@ -740,6 +741,9 @@ balanced:
 		rt_rq->rt_throttled = 0;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		raw_spin_unlock(&rt_b->rt_runtime_lock);
+
+		/* Make rt_rq available for pick_next_task() */
+		sched_rt_rq_enqueue(rt_rq);
 	}
 }
 
@@ -948,7 +952,7 @@ static void update_curr_rt(struct rq *rq)
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
 			rt_rq->rt_time += delta_exec;
 			if (sched_rt_runtime_exceeded(rt_rq))
-				resched_task(curr);
+				resched_curr(rq);
 			raw_spin_unlock(&rt_rq->rt_runtime_lock);
 		}
 	}
@@ -1363,7 +1367,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 	 * to try and push current away:
 	 */
 	requeue_task_rt(rq, p, 1);
-	resched_task(rq->curr);
+	resched_curr(rq);
 }
 
 #endif /* CONFIG_SMP */
@@ -1374,7 +1378,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int flags)
 {
 	if (p->prio < rq->curr->prio) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return;
 	}
 
@@ -1690,7 +1694,7 @@ retry:
 	 * just reschedule current.
 	 */
 	if (unlikely(next_task->prio < rq->curr->prio)) {
-		resched_task(rq->curr);
+		resched_curr(rq);
 		return 0;
 	}
 
@@ -1737,7 +1741,7 @@ retry:
 	activate_task(lowest_rq, next_task, 0);
 	ret = 1;
 
-	resched_task(lowest_rq->curr);
+	resched_curr(lowest_rq);
 
 	double_unlock_balance(rq, lowest_rq);
 
@@ -1936,7 +1940,7 @@ static void switched_from_rt(struct rq *rq, struct task_struct *p)
 		return;
 
 	if (pull_rt_task(rq))
-		resched_task(rq->curr);
+		resched_curr(rq);
 }
 
 void __init init_sched_rt_class(void)
@@ -1974,7 +1978,7 @@ static void switched_to_rt(struct rq *rq, struct task_struct *p)
 			check_resched = 0;
 #endif /* CONFIG_SMP */
 		if (check_resched && p->prio < rq->curr->prio)
-			resched_task(rq->curr);
+			resched_curr(rq);
 	}
 }
 
@@ -2003,11 +2007,11 @@ prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 		 * Only reschedule if p is still on the same runqueue.
 		 */
 		if (p->prio > rq->rt.highest_prio.curr && rq->curr == p)
-			resched_task(p);
+			resched_curr(rq);
 #else
 		/* For UP simply resched on drop of prio */
 		if (oldprio < p->prio)
-			resched_task(p);
+			resched_curr(rq);
 #endif /* CONFIG_SMP */
 	} else {
 		/*
@@ -2016,7 +2020,7 @@ prio_changed_rt(struct rq *rq, struct task_struct *p, int oldprio)
 		 * then reschedule.
 		 */
 		if (p->prio < rq->curr->prio)
-			resched_task(rq->curr);
+			resched_curr(rq);
 	}
 }
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31cc02e..579712f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -477,6 +477,9 @@ struct root_domain {
 	cpumask_var_t span;
 	cpumask_var_t online;
 
+	/* Indicate more than one runnable task for any CPU */
+	bool overload;
+
 	/*
 	 * The bit corresponding to a CPU gets set here if such CPU has more
 	 * than one runnable -deadline task (as it is below for RT tasks).
@@ -884,20 +887,10 @@ enum {
 #undef SCHED_FEAT
 
 #if defined(CONFIG_SCHED_DEBUG) && defined(HAVE_JUMP_LABEL)
-static __always_inline bool static_branch__true(struct static_key *key)
-{
-	return static_key_true(key); /* Not out of line branch. */
-}
-
-static __always_inline bool static_branch__false(struct static_key *key)
-{
-	return static_key_false(key); /* Out of line branch. */
-}
-
 #define SCHED_FEAT(name, enabled)					\
 static __always_inline bool static_branch_##name(struct static_key *key) \
 {									\
-	return static_branch__##enabled(key);				\
+	return static_key_##enabled(key);				\
 }
 
 #include "features.h"
@@ -1196,7 +1189,7 @@ extern void init_sched_rt_class(void);
 extern void init_sched_fair_class(void);
 extern void init_sched_dl_class(void);
 
-extern void resched_task(struct task_struct *p);
+extern void resched_curr(struct rq *rq);
 extern void resched_cpu(int cpu);
 
 extern struct rt_bandwidth def_rt_bandwidth;
@@ -1218,15 +1211,26 @@ static inline void add_nr_running(struct rq *rq, unsigned count)
 
 	rq->nr_running = prev_nr + count;
 
-#ifdef CONFIG_NO_HZ_FULL
 	if (prev_nr < 2 && rq->nr_running >= 2) {
+#ifdef CONFIG_SMP
+		if (!rq->rd->overload)
+			rq->rd->overload = true;
+#endif
+
+#ifdef CONFIG_NO_HZ_FULL
 		if (tick_nohz_full_cpu(rq->cpu)) {
-			/* Order rq->nr_running write against the IPI */
-			smp_wmb();
-			smp_send_reschedule(rq->cpu);
+			/*
+			 * Tick is needed if more than one task runs on a CPU.
+			 * Send the target an IPI to kick it out of nohz mode.
+			 *
+			 * We assume that IPI implies full memory barrier and the
+			 * new value of rq->nr_running is visible on reception
+			 * from the target.
+			 */
+			tick_nohz_full_kick_cpu(rq->cpu);
 		}
-       }
 #endif
+	}
 }
 
 static inline void sub_nr_running(struct rq *rq, unsigned count)
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 0ffa20a..15cab1a 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -319,14 +319,14 @@ EXPORT_SYMBOL(wake_bit_function);
  */
 int __sched
 __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
-			int (*action)(void *), unsigned mode)
+	      wait_bit_action_f *action, unsigned mode)
 {
 	int ret = 0;
 
 	do {
 		prepare_to_wait(wq, &q->wait, mode);
 		if (test_bit(q->key.bit_nr, q->key.flags))
-			ret = (*action)(q->key.flags);
+			ret = (*action)(&q->key);
 	} while (test_bit(q->key.bit_nr, q->key.flags) && !ret);
 	finish_wait(wq, &q->wait);
 	return ret;
@@ -334,7 +334,7 @@ __wait_on_bit(wait_queue_head_t *wq, struct wait_bit_queue *q,
 EXPORT_SYMBOL(__wait_on_bit);
 
 int __sched out_of_line_wait_on_bit(void *word, int bit,
-					int (*action)(void *), unsigned mode)
+				    wait_bit_action_f *action, unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
 	DEFINE_WAIT_BIT(wait, word, bit);
@@ -345,7 +345,7 @@ EXPORT_SYMBOL(out_of_line_wait_on_bit);
 
 int __sched
 __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
-			int (*action)(void *), unsigned mode)
+			wait_bit_action_f *action, unsigned mode)
 {
 	do {
 		int ret;
@@ -353,7 +353,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 		prepare_to_wait_exclusive(wq, &q->wait, mode);
 		if (!test_bit(q->key.bit_nr, q->key.flags))
 			continue;
-		ret = action(q->key.flags);
+		ret = action(&q->key);
 		if (!ret)
 			continue;
 		abort_exclusive_wait(wq, &q->wait, mode, &q->key);
@@ -365,7 +365,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq, struct wait_bit_queue *q,
 EXPORT_SYMBOL(__wait_on_bit_lock);
 
 int __sched out_of_line_wait_on_bit_lock(void *word, int bit,
-					int (*action)(void *), unsigned mode)
+					 wait_bit_action_f *action, unsigned mode)
 {
 	wait_queue_head_t *wq = bit_waitqueue(word, bit);
 	DEFINE_WAIT_BIT(wait, word, bit);
@@ -502,3 +502,21 @@ void wake_up_atomic_t(atomic_t *p)
 	__wake_up_bit(atomic_t_waitqueue(p), p, WAIT_ATOMIC_T_BIT_NR);
 }
 EXPORT_SYMBOL(wake_up_atomic_t);
+
+__sched int bit_wait(struct wait_bit_key *word)
+{
+	if (signal_pending_state(current->state, current))
+		return 1;
+	schedule();
+	return 0;
+}
+EXPORT_SYMBOL(bit_wait);
+
+__sched int bit_wait_io(struct wait_bit_key *word)
+{
+	if (signal_pending_state(current->state, current))
+		return 1;
+	io_schedule();
+	return 0;
+}
+EXPORT_SYMBOL(bit_wait_io);
diff --git a/kernel/smp.c b/kernel/smp.c
index 80c33f8..487653b 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -3,6 +3,7 @@
  *
  * (C) Jens Axboe <jens.axboe@oracle.com> 2008
  */
+#include <linux/irq_work.h>
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
 #include <linux/kernel.h>
@@ -251,6 +252,14 @@ static void flush_smp_call_function_queue(bool warn_cpu_offline)
 		csd->func(csd->info);
 		csd_unlock(csd);
 	}
+
+	/*
+	 * Handle irq works queued remotely by irq_work_queue_on().
+	 * Smp functions above are typically synchronous so they
+	 * better run first since some other CPUs may be busy waiting
+	 * for them.
+	 */
+	irq_work_run();
 }
 
 /*
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6558b7a..3d63944 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -224,13 +224,15 @@ static DEFINE_PER_CPU(struct irq_work, nohz_full_kick_work) = {
 };
 
 /*
- * Kick the current CPU if it's full dynticks in order to force it to
+ * Kick the CPU if it's full dynticks in order to force it to
  * re-evaluate its dependency on the tick and restart it if necessary.
  */
-void tick_nohz_full_kick(void)
+void tick_nohz_full_kick_cpu(int cpu)
 {
-	if (tick_nohz_full_cpu(smp_processor_id()))
-		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
+	if (!tick_nohz_full_cpu(cpu))
+		return;
+
+	irq_work_queue_on(&per_cpu(nohz_full_kick_work, cpu), cpu);
 }
 
 static void nohz_full_kick_ipi(void *info)
diff --git a/mm/filemap.c b/mm/filemap.c
index dafb06f..d175917 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -241,18 +241,6 @@ void delete_from_page_cache(struct page *page)
 }
 EXPORT_SYMBOL(delete_from_page_cache);
 
-static int sleep_on_page(void *word)
-{
-	io_schedule();
-	return 0;
-}
-
-static int sleep_on_page_killable(void *word)
-{
-	sleep_on_page(word);
-	return fatal_signal_pending(current) ? -EINTR : 0;
-}
-
 static int filemap_check_errors(struct address_space *mapping)
 {
 	int ret = 0;
@@ -692,7 +680,7 @@ void wait_on_page_bit(struct page *page, int bit_nr)
 	DEFINE_WAIT_BIT(wait, &page->flags, bit_nr);
 
 	if (test_bit(bit_nr, &page->flags))
-		__wait_on_bit(page_waitqueue(page), &wait, sleep_on_page,
+		__wait_on_bit(page_waitqueue(page), &wait, bit_wait_io,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(wait_on_page_bit);
@@ -705,7 +693,7 @@ int wait_on_page_bit_killable(struct page *page, int bit_nr)
 		return 0;
 
 	return __wait_on_bit(page_waitqueue(page), &wait,
-			     sleep_on_page_killable, TASK_KILLABLE);
+			     bit_wait_io, TASK_KILLABLE);
 }
 
 /**
@@ -806,7 +794,7 @@ void __lock_page(struct page *page)
 {
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
-	__wait_on_bit_lock(page_waitqueue(page), &wait, sleep_on_page,
+	__wait_on_bit_lock(page_waitqueue(page), &wait, bit_wait_io,
 							TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(__lock_page);
@@ -816,7 +804,7 @@ int __lock_page_killable(struct page *page)
 	DEFINE_WAIT_BIT(wait, &page->flags, PG_locked);
 
 	return __wait_on_bit_lock(page_waitqueue(page), &wait,
-					sleep_on_page_killable, TASK_KILLABLE);
+					bit_wait_io, TASK_KILLABLE);
 }
 EXPORT_SYMBOL_GPL(__lock_page_killable);
 
diff --git a/mm/ksm.c b/mm/ksm.c
index 346ddc9..fb75902 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1978,18 +1978,12 @@ void ksm_migrate_page(struct page *newpage, struct page *oldpage)
 #endif /* CONFIG_MIGRATION */
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
-static int just_wait(void *word)
-{
-	schedule();
-	return 0;
-}
-
 static void wait_while_offlining(void)
 {
 	while (ksm_run & KSM_RUN_OFFLINE) {
 		mutex_unlock(&ksm_thread_mutex);
 		wait_on_bit(&ksm_run, ilog2(KSM_RUN_OFFLINE),
-				just_wait, TASK_UNINTERRUPTIBLE);
+			    TASK_UNINTERRUPTIBLE);
 		mutex_lock(&ksm_thread_mutex);
 	}
 }
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 0a43cce..e090bff 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2186,12 +2186,6 @@ static void hci_inq_req(struct hci_request *req, unsigned long opt)
 	hci_req_add(req, HCI_OP_INQUIRY, sizeof(cp), &cp);
 }
 
-static int wait_inquiry(void *word)
-{
-	schedule();
-	return signal_pending(current);
-}
-
 int hci_inquiry(void __user *arg)
 {
 	__u8 __user *ptr = arg;
@@ -2242,7 +2236,7 @@ int hci_inquiry(void __user *arg)
 		/* Wait until Inquiry procedure finishes (HCI_INQUIRY flag is
 		 * cleared). If it is interrupted by a signal, return -EINTR.
 		 */
-		if (wait_on_bit(&hdev->flags, HCI_INQUIRY, wait_inquiry,
+		if (wait_on_bit(&hdev->flags, HCI_INQUIRY,
 				TASK_INTERRUPTIBLE))
 			return -EINTR;
 	}
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index c0365c1..9358c79 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -250,7 +250,7 @@ void rpc_destroy_wait_queue(struct rpc_wait_queue *queue)
 }
 EXPORT_SYMBOL_GPL(rpc_destroy_wait_queue);
 
-static int rpc_wait_bit_killable(void *word)
+static int rpc_wait_bit_killable(struct wait_bit_key *key)
 {
 	if (fatal_signal_pending(current))
 		return -ERESTARTSYS;
@@ -309,7 +309,7 @@ static int rpc_complete_task(struct rpc_task *task)
  * to enforce taking of the wq->lock and hence avoid races with
  * rpc_complete_task().
  */
-int __rpc_wait_for_completion_task(struct rpc_task *task, int (*action)(void *))
+int __rpc_wait_for_completion_task(struct rpc_task *task, wait_bit_action_f *action)
 {
 	if (action == NULL)
 		action = rpc_wait_bit_killable;
diff --git a/security/keys/gc.c b/security/keys/gc.c
index d3222b6..9609a7f 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -92,15 +92,6 @@ static void key_gc_timer_func(unsigned long data)
 }
 
 /*
- * wait_on_bit() sleep function for uninterruptible waiting
- */
-static int key_gc_wait_bit(void *flags)
-{
-	schedule();
-	return 0;
-}
-
-/*
  * Reap keys of dead type.
  *
  * We use three flags to make sure we see three complete cycles of the garbage
@@ -123,7 +114,7 @@ void key_gc_keytype(struct key_type *ktype)
 	schedule_work(&key_gc_work);
 
 	kdebug("sleep");
-	wait_on_bit(&key_gc_flags, KEY_GC_REAPING_KEYTYPE, key_gc_wait_bit,
+	wait_on_bit(&key_gc_flags, KEY_GC_REAPING_KEYTYPE,
 		    TASK_UNINTERRUPTIBLE);
 
 	key_gc_dead_keytype = NULL;
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 3814119..26a94f1 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -21,24 +21,6 @@
 
 #define key_negative_timeout	60	/* default timeout on a negative key's existence */
 
-/*
- * wait_on_bit() sleep function for uninterruptible waiting
- */
-static int key_wait_bit(void *flags)
-{
-	schedule();
-	return 0;
-}
-
-/*
- * wait_on_bit() sleep function for interruptible waiting
- */
-static int key_wait_bit_intr(void *flags)
-{
-	schedule();
-	return signal_pending(current) ? -ERESTARTSYS : 0;
-}
-
 /**
  * complete_request_key - Complete the construction of a key.
  * @cons: The key construction record.
@@ -592,10 +574,9 @@ int wait_for_key_construction(struct key *key, bool intr)
 	int ret;
 
 	ret = wait_on_bit(&key->flags, KEY_FLAG_USER_CONSTRUCT,
-			  intr ? key_wait_bit_intr : key_wait_bit,
 			  intr ? TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
-	if (ret < 0)
-		return ret;
+	if (ret)
+		return -ERESTARTSYS;
 	if (test_bit(KEY_FLAG_NEGATIVE, &key->flags)) {
 		smp_rmb();
 		return key->type_data.reject_error;
