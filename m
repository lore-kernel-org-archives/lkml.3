Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656AbaA1Wnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:43:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326AbaA1Wnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:43:37 -0500
Date: Tue, 28 Jan 2014 15:43:36 -0700
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Core block IO changes for 3.14
Message-ID: <20140128224336.GF25989@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the pull request for the core block IO changes for 3.14. The
major piece in here is the immutable bio_ve series from Kent, the rest
is fairly minor. It was supposed to go in last round, but various issues
pushed it to this release instead. The pull request contains:


- Various smaller blk-mq fixes from different folks. Nothing major here,
  just minor fixes and cleanups.

- Fix for a memory leak in the error path in the block ioctl code from
  Christian Engelmayer.

- Header export fix from CaiZhiyong.

- Finally the immutable biovec changes from Kent Overstreet. This
  enables some nice future work on making arbitrarily sized bios
  possible, and splitting more efficient. Related fixes to immutable
  bio_vecs:

        - dm-cache immutable fixup from Mike Snitzer.
        - btrfs immutable fixup from Muthu Kumar.

- bio-integrity fix from Nic Bellinger, which is also going to stable.


Please pull! There will be a bit of merge work for you, but it should be
fairly straight forward. It's mostly related to changin:

bio->bi_sector  -> bio->bi_iter.bi_sector
bio->bi_size    -> bio->bi_iter.bi_size


git://git.kernel.dk/linux-block.git for-3.14/core


----------------------------------------------------------------
Andrew Morton (1):
      block/blk-mq-cpu.c: use hotcpu_notifier()

CaiZhiyong (1):
      block: remove unrelated header files and export symbol

Christian Engelmayer (1):
      block: Fix memory leak in rw_copy_check_uvector() handling

Christoph Hellwig (1):
      blk-mq: use __smp_call_function_single directly

Dave Hansen (1):
      blk-mq: uses page->list incorrectly

Jens Axboe (2):
      Merge tag 'v3.13-rc6' into for-3.14/core
      Revert "block: Warn and free bio if bi_end_io is not set"

Jose Alonso (1):
      blk-mq: for_each_* macro correctness

Kent Overstreet (28):
      block: submit_bio_wait() conversions
      block: Convert various code to bio_for_each_segment()
      bcache: Kill unaligned bvec hack
      block: Abstract out bvec iterator
      dm: Use bvec_iter for dm_bio_record()
      block: Convert bio_iovec() to bvec_iter
      block: Convert bio_for_each_segment() to bvec_iter
      block: Immutable bio vecs
      block: Convert bio_copy_data() to bvec_iter
      bio-integrity: Convert to bvec_iter
      block: Kill bio_segments()/bi_vcnt usage
      block: Convert drivers to immutable biovecs
      aoe: Convert to immutable biovecs
      ceph: Convert to immutable biovecs
      block: Kill bio_iovec_idx(), __bio_iovec()
      block: Refactor bio_clone_bioset() for immutable biovecs
      block: Add bio_clone_fast()
      rbd: Refactor bio cloning
      dm: Refactor for new bio cloning/splitting
      block: Don't save/copy bvec array anymore
      block: Remove bi_idx hacks
      block: Generic bio chaining
      block: Rename bio_split() -> bio_pair_split()
      block: Introduce new bio_split()
      block: Kill bio_pair_split()
      block: Silence spurious compiler warnings
      block: Really silence spurious compiler warnings
      block: fixup for generic bio chaining

Mike Snitzer (1):
      dm cache: increment bi_remaining when bi_end_io is restored

Ming Lei (4):
      block: blk-mq: support draining mq queue
      block: blk-mq: make blk_sync_queue support mq
      block: blk-mq: don't export blk_mq_free_queue()
      blk-mq: fix initializing request's start time

Muthu Kumar (1):
      btrfs: fix missing increment of bi_remaining

Muthukumar Ratty (1):
      block: Warn and free bio if bi_end_io is not set

Nicholas Bellinger (1):
      bio-integrity: Fix bio_integrity_verify segment start bug

 Documentation/block/biodoc.txt              |   7 +-
 Documentation/block/biovecs.txt             | 111 ++++++
 arch/m68k/emu/nfblock.c                     |  13 +-
 arch/powerpc/sysdev/axonram.c               |  21 +-
 block/blk-core.c                            |  61 ++--
 block/blk-exec.c                            |   4 +
 block/blk-flush.c                           |   2 +-
 block/blk-integrity.c                       |  40 ++-
 block/blk-lib.c                             |  12 +-
 block/blk-map.c                             |   6 +-
 block/blk-merge.c                           |  66 ++--
 block/blk-mq-cpu.c                          |  37 +-
 block/blk-mq.c                              | 123 +++----
 block/blk-mq.h                              |   3 +-
 block/blk-sysfs.c                           |   1 +
 block/blk-throttle.c                        |  14 +-
 block/cmdline-parser.c                      |  18 +-
 block/elevator.c                            |   2 +-
 block/scsi_ioctl.c                          |   6 +-
 drivers/block/aoe/aoe.h                     |  10 +-
 drivers/block/aoe/aoecmd.c                  | 153 ++++-----
 drivers/block/brd.c                         |  16 +-
 drivers/block/drbd/drbd_actlog.c            |   2 +-
 drivers/block/drbd/drbd_bitmap.c            |   2 +-
 drivers/block/drbd/drbd_main.c              |  27 +-
 drivers/block/drbd/drbd_receiver.c          |  19 +-
 drivers/block/drbd/drbd_req.c               |   6 +-
 drivers/block/drbd/drbd_req.h               |   2 +-
 drivers/block/drbd/drbd_worker.c            |   8 +-
 drivers/block/floppy.c                      |  16 +-
 drivers/block/loop.c                        |  27 +-
 drivers/block/mtip32xx/mtip32xx.c           |  20 +-
 drivers/block/nbd.c                         |  14 +-
 drivers/block/nvme-core.c                   | 142 ++------
 drivers/block/pktcdvd.c                     | 182 +++++-----
 drivers/block/ps3disk.c                     |  17 +-
 drivers/block/ps3vram.c                     |  12 +-
 drivers/block/rbd.c                         |  91 +----
 drivers/block/rsxx/dev.c                    |   6 +-
 drivers/block/rsxx/dma.c                    |  15 +-
 drivers/block/umem.c                        |  53 ++-
 drivers/block/xen-blkback/blkback.c         |   2 +-
 drivers/block/xen-blkfront.c                |   2 +-
 drivers/md/bcache/bcache.h                  |   2 -
 drivers/md/bcache/btree.c                   |   8 +-
 drivers/md/bcache/debug.c                   |  21 +-
 drivers/md/bcache/io.c                      | 196 ++---------
 drivers/md/bcache/journal.c                 |  12 +-
 drivers/md/bcache/movinggc.c                |   4 +-
 drivers/md/bcache/request.c                 | 131 +++-----
 drivers/md/bcache/super.c                   |  20 +-
 drivers/md/bcache/util.c                    |   4 +-
 drivers/md/bcache/writeback.c               |   6 +-
 drivers/md/bcache/writeback.h               |   2 +-
 drivers/md/dm-bio-record.h                  |  37 +-
 drivers/md/dm-bufio.c                       |   2 +-
 drivers/md/dm-cache-policy-mq.c             |   4 +-
 drivers/md/dm-cache-target.c                |  28 +-
 drivers/md/dm-crypt.c                       |  64 ++--
 drivers/md/dm-delay.c                       |   7 +-
 drivers/md/dm-flakey.c                      |   7 +-
 drivers/md/dm-io.c                          |  37 +-
 drivers/md/dm-linear.c                      |   3 +-
 drivers/md/dm-raid1.c                       |  20 +-
 drivers/md/dm-region-hash.c                 |   3 +-
 drivers/md/dm-snap.c                        |  19 +-
 drivers/md/dm-stripe.c                      |  13 +-
 drivers/md/dm-switch.c                      |   4 +-
 drivers/md/dm-thin.c                        |  30 +-
 drivers/md/dm-verity.c                      |  62 ++--
 drivers/md/dm.c                             | 189 ++---------
 drivers/md/faulty.c                         |  19 +-
 drivers/md/linear.c                         |  96 +++---
 drivers/md/md.c                             |  12 +-
 drivers/md/multipath.c                      |  13 +-
 drivers/md/raid0.c                          |  79 ++---
 drivers/md/raid1.c                          |  75 +++--
 drivers/md/raid10.c                         | 194 +++++------
 drivers/md/raid5.c                          |  84 ++---
 drivers/message/fusion/mptsas.c             |   8 +-
 drivers/s390/block/dasd_diag.c              |  10 +-
 drivers/s390/block/dasd_eckd.c              |  48 +--
 drivers/s390/block/dasd_fba.c               |  26 +-
 drivers/s390/block/dcssblk.c                |  21 +-
 drivers/s390/block/scm_blk.c                |   8 +-
 drivers/s390/block/scm_blk_cluster.c        |   4 +-
 drivers/s390/block/xpram.c                  |  19 +-
 drivers/scsi/libsas/sas_expander.c          |   8 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |  41 +--
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  39 +--
 drivers/scsi/osd/osd_initiator.c            |   2 +-
 drivers/scsi/sd.c                           |   2 +-
 drivers/scsi/sd_dif.c                       |  30 +-
 drivers/staging/lustre/lustre/llite/lloop.c |  26 +-
 drivers/staging/zram/zram_drv.c             |  33 +-
 drivers/target/target_core_iblock.c         |   2 +-
 fs/bio-integrity.c                          | 170 ++--------
 fs/bio.c                                    | 502 +++++++++++++---------------
 fs/btrfs/check-integrity.c                  |   8 +-
 fs/btrfs/compression.c                      |  27 +-
 fs/btrfs/disk-io.c                          |  13 +-
 fs/btrfs/extent_io.c                        |  49 ++-
 fs/btrfs/file-item.c                        |  19 +-
 fs/btrfs/inode.c                            |  37 +-
 fs/btrfs/raid56.c                           |  22 +-
 fs/btrfs/scrub.c                            |  12 +-
 fs/btrfs/volumes.c                          |  19 +-
 fs/buffer.c                                 |  12 +-
 fs/direct-io.c                              |   4 +-
 fs/ext4/page-io.c                           |   8 +-
 fs/f2fs/data.c                              |  15 +-
 fs/f2fs/segment.c                           |  14 +-
 fs/gfs2/lops.c                              |   2 +-
 fs/gfs2/ops_fstype.c                        |   2 +-
 fs/hfsplus/wrapper.c                        |   2 +-
 fs/jfs/jfs_logmgr.c                         |  12 +-
 fs/jfs/jfs_metapage.c                       |   9 +-
 fs/logfs/dev_bdev.c                         |  38 +--
 fs/mpage.c                                  |  19 +-
 fs/nfs/blocklayout/blocklayout.c            |  43 +--
 fs/nilfs2/segbuf.c                          |   3 +-
 fs/ocfs2/cluster/heartbeat.c                |   2 +-
 fs/xfs/xfs_aops.c                           |   2 +-
 fs/xfs/xfs_buf.c                            |   4 +-
 include/linux/bio.h                         | 283 ++++++++++------
 include/linux/blk-mq.h                      |  13 +-
 include/linux/blk_types.h                   |  24 +-
 include/linux/blkdev.h                      |   9 +-
 include/linux/ceph/messenger.h              |   4 +-
 include/linux/cmdline-parser.h              |   8 +-
 include/linux/dm-io.h                       |   4 +-
 include/trace/events/bcache.h               |  26 +-
 include/trace/events/block.h                |  26 +-
 include/trace/events/f2fs.h                 |   4 +-
 kernel/power/block_io.c                     |   2 +-
 kernel/trace/blktrace.c                     |  15 +-
 mm/bounce.c                                 |  44 ++-
 mm/page_io.c                                |  10 +-
 net/ceph/messenger.c                        |  43 +--
 139 files changed, 2136 insertions(+), 2673 deletions(-)
 create mode 100644 Documentation/block/biovecs.txt

-- 
Jens Axboe

