Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab3CUQgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 12:36:07 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:63247 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3CUQgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:36:03 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        akpm@linux-foundation.org
Cc: Kent Overstreet <koverstreet@google.com>, bcrl@kvack.org, zab@redhat.com,
        tytso@mit.edu, viro@zeniv.linux.org.uk, axboe@kernel.dk
Subject: [PATCH 00/33] AIO cleanups/performance improvements
Date: Thu, 21 Mar 2013 09:35:21 -0700
Message-Id: <1363883754-27966-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a respin of the AIO patches that have been in Andrew's tree,
with all the various fixes squashed.

Two differences from the code that was in Andrew's tree:

 * The "block: Prep work for batch completion" patch is new -
   previously, the batch completion stuff added a separate
   bi_batch_end_io, this now adds the struct batch_complete * argument
   to bi_end_io.

 * When I went to squash the "aio: fix ringbuffer calculation so we
   don't wrap" patch
http://atlas.evilpiepirate.org/git/linux-bcache.git/commit/?h=aio-upstream-v0&id=790a3cec8322c4e07704e9356495acdf6ee6aff4
   I realized it unintentionally changed behaviour from upstream - so I
   redid it correctly, and added some comments.

Here's the output of git diff between the two branches (excluding the
"prep work for batch completion" patch)

diff --git a/fs/aio.c b/fs/aio.c
index 33e9db3..d2c1a82 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -75,20 +75,22 @@ struct kioctx {
 
 	struct __percpu kioctx_cpu *cpu;
 
-	/* Size of ringbuffer, in units of struct io_event */
-	unsigned		nr_events;
-
-	/*
-	 * Maximum number of outstanding requests:
-	 * sys_io_setup currently limits this to an unsigned int
-	 */
-	unsigned		max_reqs;
-
 	/*
 	 * For percpu reqs_available, number of slots we move to/from global
 	 * counter at a time:
 	 */
 	unsigned		req_batch;
+	/*
+	 * This is what userspace passed to io_setup(), it's not used for
+	 * anything but counting against the global max_reqs quota.
+	 *
+	 * The real limit is nr_events - 1, which will be larger (see
+	 * aio_setup_ring())
+	 */
+	unsigned		max_reqs;
+
+	/* Size of ringbuffer, in units of struct io_event */
+	unsigned		nr_events;
 
 	unsigned long		mmap_base;
 	unsigned long		mmap_size;
@@ -121,21 +123,20 @@ struct kioctx {
 		wait_queue_head_t wait;
 
 		/*
-		 * Copy of the real tail, that aio_complete uses - to reduce
-		 * cacheline bouncing. The real tail will tend to be much more
-		 * contended - since typically events are delivered one at a
-		 * time, and then aio_read_events() slurps them up a bunch at a
-		 * time - so it's helpful if aio_read_events() isn't also
-		 * contending for the tail. So, aio_complete() updates
-		 * shadow_tail whenever it updates tail.
-		 *
-		 * Also needed because tail is used as a hacky lock and isn't
-		 * always the real tail.
+		 * Copy of the real tail - to reduce cacheline bouncing. Updated
+		 * by aio_complete() whenever it updates the real tail.
 		 */
 		unsigned	shadow_tail;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
+		/*
+		 * This is the canonical copy of the tail pointer, updated by
+		 * aio_complete(). But aio_complete() also uses it as a lock, so
+		 * other code can't use it; aio_complete() keeps shadow_tail in
+		 * sync with the real value of the tail pointer for other code
+		 * to use.
+		 */
 		unsigned	tail;
 	} ____cacheline_aligned_in_smp;
 
@@ -347,20 +348,20 @@ static void free_ioctx(struct kioctx *ctx)
 	head = ring->head;
 	kunmap_atomic(ring);
 
-	while (atomic_read(&ctx->reqs_available) < ctx->max_reqs) {
+	while (atomic_read(&ctx->reqs_available) < ctx->nr_events - 1) {
 		wait_event(ctx->wait,
 			   (head != ctx->shadow_tail) ||
-			   (atomic_read(&ctx->reqs_available) >= ctx->max_reqs));
+			   (atomic_read(&ctx->reqs_available) >= ctx->nr_events - 1));
 
-		avail = (head <= ctx->shadow_tail ?
-			 ctx->shadow_tail : ctx->nr_events) - head;
+		avail = (head <= ctx->shadow_tail
+			 ? ctx->shadow_tail : ctx->nr_events) - head;
 
 		atomic_add(avail, &ctx->reqs_available);
 		head += avail;
 		head %= ctx->nr_events;
 	}
 
-	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->max_reqs);
+	WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr_events - 1);
 
 	aio_free_ring(ctx);
 
@@ -423,8 +424,6 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 		return ERR_PTR(-ENOMEM);
 
 	ctx->max_reqs = nr_events;
-	atomic_set(&ctx->reqs_available, nr_events);
-	ctx->req_batch = nr_events / (num_possible_cpus() * 4);
 
 	percpu_ref_init(&ctx->users);
 	rcu_read_lock();
@@ -444,6 +443,10 @@ static struct kioctx *ioctx_alloc(unsigned nr_events)
 	if (aio_setup_ring(ctx) < 0)
 		goto out_freepcpu;
 
+	atomic_set(&ctx->reqs_available, ctx->nr_events - 1);
+	ctx->req_batch = (ctx->nr_events - 1) / (num_possible_cpus() * 4);
+	BUG_ON(!ctx->req_batch);
+
 	/* limit the number of system wide aios */
 	spin_lock(&aio_nr_lock);
 	if (aio_nr + nr_events > aio_max_nr ||

Benjamin LaHaise (1):
  aio: fix kioctx not being freed after cancellation at exit time

Kent Overstreet (27):
  aio: kill return value of aio_complete()
  aio: add kiocb_cancel()
  aio: move private stuff out of aio.h
  aio: dprintk() -> pr_debug()
  aio: do fget() after aio_get_req()
  aio: make aio_put_req() lockless
  aio: refcounting cleanup
  wait: add wait_event_hrtimeout()
  aio: make aio_read_evt() more efficient, convert to hrtimers
  aio: use flush_dcache_page()
  aio: use cancellation list lazily
  aio: change reqs_active to include unreaped completions
  aio: kill batch allocation
  aio: kill struct aio_ring_info
  aio: give shared kioctx fields their own cachelines
  aio: reqs_active -> reqs_available
  aio: percpu reqs_available
  generic dynamic per cpu refcounting
  aio: percpu ioctx refcount
  aio: use xchg() instead of completion_lock
  aio: don't include aio.h in sched.h
  aio: kill ki_key
  aio: kill ki_retry
  block: Prep work for batch completion
  block, aio: batch completion for bios/kiocbs
  virtio-blk: convert to batch completion
  mtip32xx: convert to batch completion

Zach Brown (5):
  mm: remove old aio use_mm() comment
  aio: remove dead code from aio.h
  gadget: remove only user of aio retry
  aio: remove retry-based AIO
  char: add aio_{read,write} to /dev/{null,zero}

 arch/s390/hypfs/inode.c                      |    1 +
 block/blk-core.c                             |   34 +-
 block/blk-flush.c                            |    5 +-
 block/blk-lib.c                              |    3 +-
 block/blk.h                                  |    3 +-
 block/scsi_ioctl.c                           |    1 +
 drivers/block/drbd/drbd_bitmap.c             |    2 +-
 drivers/block/drbd/drbd_worker.c             |    6 +-
 drivers/block/drbd/drbd_wrappers.h           |    9 +-
 drivers/block/floppy.c                       |    3 +-
 drivers/block/mtip32xx/mtip32xx.c            |   86 +-
 drivers/block/mtip32xx/mtip32xx.h            |    8 +-
 drivers/block/pktcdvd.c                      |    9 +-
 drivers/block/swim3.c                        |    2 +-
 drivers/block/virtio_blk.c                   |   31 +-
 drivers/block/xen-blkback/blkback.c          |    3 +-
 drivers/char/mem.c                           |   36 +
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    1 +
 drivers/infiniband/hw/qib/qib_file_ops.c     |    2 +-
 drivers/md/dm-bufio.c                        |    9 +-
 drivers/md/dm-crypt.c                        |    3 +-
 drivers/md/dm-io.c                           |    2 +-
 drivers/md/dm-snap.c                         |    3 +-
 drivers/md/dm-thin.c                         |    3 +-
 drivers/md/dm-verity.c                       |    3 +-
 drivers/md/dm.c                              |    8 +-
 drivers/md/faulty.c                          |    3 +-
 drivers/md/md.c                              |    9 +-
 drivers/md/multipath.c                       |    3 +-
 drivers/md/raid1.c                           |   15 +-
 drivers/md/raid10.c                          |   21 +-
 drivers/md/raid5.c                           |   15 +-
 drivers/scsi/sg.c                            |    1 +
 drivers/staging/android/logger.c             |    1 +
 drivers/target/target_core_iblock.c          |    6 +-
 drivers/target/target_core_pscsi.c           |    3 +-
 drivers/usb/gadget/inode.c                   |   42 +-
 fs/9p/vfs_addr.c                             |    1 +
 fs/afs/write.c                               |    1 +
 fs/aio.c                                     | 1811 +++++++++++---------------
 fs/bio-integrity.c                           |    3 +-
 fs/bio.c                                     |   62 +-
 fs/block_dev.c                               |    1 +
 fs/btrfs/check-integrity.c                   |   14 +-
 fs/btrfs/compression.c                       |    6 +-
 fs/btrfs/disk-io.c                           |    6 +-
 fs/btrfs/extent_io.c                         |   12 +-
 fs/btrfs/file.c                              |    1 +
 fs/btrfs/inode.c                             |   14 +-
 fs/btrfs/scrub.c                             |   18 +-
 fs/btrfs/volumes.c                           |    4 +-
 fs/buffer.c                                  |    3 +-
 fs/ceph/file.c                               |    1 +
 fs/compat.c                                  |    1 +
 fs/direct-io.c                               |   21 +-
 fs/ecryptfs/file.c                           |    1 +
 fs/ext2/inode.c                              |    1 +
 fs/ext3/inode.c                              |    1 +
 fs/ext4/file.c                               |    1 +
 fs/ext4/indirect.c                           |    1 +
 fs/ext4/inode.c                              |    1 +
 fs/ext4/page-io.c                            |    4 +-
 fs/f2fs/data.c                               |    3 +-
 fs/f2fs/segment.c                            |    3 +-
 fs/fat/inode.c                               |    1 +
 fs/fuse/cuse.c                               |    1 +
 fs/fuse/dev.c                                |    1 +
 fs/fuse/file.c                               |    1 +
 fs/gfs2/aops.c                               |    1 +
 fs/gfs2/file.c                               |    1 +
 fs/gfs2/lops.c                               |    3 +-
 fs/gfs2/ops_fstype.c                         |    3 +-
 fs/hfs/inode.c                               |    1 +
 fs/hfsplus/inode.c                           |    1 +
 fs/hfsplus/wrapper.c                         |    3 +-
 fs/jfs/inode.c                               |    1 +
 fs/jfs/jfs_logmgr.c                          |    4 +-
 fs/jfs/jfs_metapage.c                        |    6 +-
 fs/logfs/dev_bdev.c                          |    8 +-
 fs/mpage.c                                   |    2 +-
 fs/nfs/blocklayout/blocklayout.c             |   17 +-
 fs/nilfs2/inode.c                            |    2 +-
 fs/nilfs2/segbuf.c                           |    3 +-
 fs/ntfs/file.c                               |    1 +
 fs/ntfs/inode.c                              |    1 +
 fs/ocfs2/aops.h                              |    2 +
 fs/ocfs2/cluster/heartbeat.c                 |    4 +-
 fs/ocfs2/dlmglue.c                           |    2 +-
 fs/ocfs2/inode.h                             |    2 +
 fs/pipe.c                                    |    1 +
 fs/read_write.c                              |   35 +-
 fs/reiserfs/inode.c                          |    1 +
 fs/ubifs/file.c                              |    1 +
 fs/udf/inode.c                               |    1 +
 fs/xfs/xfs_aops.c                            |    4 +-
 fs/xfs/xfs_buf.c                             |    3 +-
 fs/xfs/xfs_file.c                            |    1 +
 include/linux/aio.h                          |  199 +--
 include/linux/batch_complete.h               |   23 +
 include/linux/bio.h                          |   38 +-
 include/linux/blk_types.h                    |    4 +-
 include/linux/blkdev.h                       |   12 +-
 include/linux/cgroup.h                       |    1 +
 include/linux/errno.h                        |    1 -
 include/linux/fs.h                           |    2 +-
 include/linux/percpu-refcount.h              |  114 ++
 include/linux/pid_namespace.h                |    1 +
 include/linux/sched.h                        |    2 -
 include/linux/swap.h                         |    3 +-
 include/linux/wait.h                         |   86 ++
 include/linux/writeback.h                    |    1 +
 kernel/fork.c                                |    1 +
 kernel/printk.c                              |    1 +
 kernel/ptrace.c                              |    1 +
 lib/Makefile                                 |    2 +-
 lib/percpu-refcount.c                        |  243 ++++
 mm/bounce.c                                  |   12 +-
 mm/mmu_context.c                             |    3 -
 mm/page_io.c                                 |    6 +-
 mm/shmem.c                                   |    1 +
 mm/swap.c                                    |    1 +
 security/keys/internal.h                     |    2 +
 security/keys/keyctl.c                       |    1 +
 sound/core/pcm_native.c                      |    2 +-
 124 files changed, 1785 insertions(+), 1488 deletions(-)
 create mode 100644 include/linux/batch_complete.h
 create mode 100644 include/linux/percpu-refcount.h
 create mode 100644 lib/percpu-refcount.c

-- 
1.8.1.3

