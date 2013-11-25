Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab3KYVwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:52:23 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:45813 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab3KYVwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:52:20 -0500
Date: Mon, 25 Nov 2013 13:52:16 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        snitzer@redhat.com
Subject: [GIT PULL] Immutable biovecs
Message-ID: <20131125215216.GB21515@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - here's immutable biovecs, rebased and ready for 3.14. Changes since the
last version of the series:

 * bio_clone_bioset() retains the old behaviour, as previously discussed -
   bio_clone_fast() is being used by bcache, dm and the new bio_split().

   There aren't that many users of the old bio_clone() and we should eventually
   convert all the users that don't actually need it (for a couple of reasons),
   but that can be left to future cleanups.

 * refactoring patches to use submit_bio_wait() and bio_for_each_segment()

Regarding the bio chaining stuff, I'm not terribly happy with all the
bio_endio_nodec() calls but I want to keep that stuff simple for now - Mike
Snitzer had a good suggestion for that though. But I am seeing more and more
ways we can use that functionality to clean other stuff up - also, we should be
able to drop bi_cnt eventually, bi_remaining seems like it can be used to
replace the various bio_get() uses.

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git for-jens

for you to fetch changes up to 4b1faf931650d4a35b2a570318862821d6a962e3:

  block: Kill bio_pair_split() (2013-11-23 22:33:57 -0800)

----------------------------------------------------------------
Kent Overstreet (25):
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

 Documentation/block/biodoc.txt              |   7 +-
 Documentation/block/biovecs.txt             | 111 ++++++
 arch/m68k/emu/nfblock.c                     |  13 +-
 arch/powerpc/sysdev/axonram.c               |  21 +-
 block/blk-core.c                            |  40 +--
 block/blk-flush.c                           |  21 +-
 block/blk-integrity.c                       |  40 ++-
 block/blk-lib.c                             |  12 +-
 block/blk-map.c                             |   6 +-
 block/blk-merge.c                           |  66 ++--
 block/blk-mq.c                              |   2 +-
 block/blk-throttle.c                        |  14 +-
 block/elevator.c                            |   2 +-
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
 drivers/md/md.c                             |  24 +-
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
 fs/bio-integrity.c                          | 179 +++-------
 fs/bio.c                                    | 502 +++++++++++++---------------
 fs/btrfs/check-integrity.c                  |  40 +--
 fs/btrfs/check-integrity.h                  |   2 +
 fs/btrfs/compression.c                      |  27 +-
 fs/btrfs/disk-io.c                          |  11 +-
 fs/btrfs/extent_io.c                        |  61 ++--
 fs/btrfs/file-item.c                        |  19 +-
 fs/btrfs/inode.c                            |  37 +-
 fs/btrfs/raid56.c                           |  22 +-
 fs/btrfs/scrub.c                            |  45 +--
 fs/btrfs/volumes.c                          |  12 +-
 fs/buffer.c                                 |  12 +-
 fs/direct-io.c                              |   4 +-
 fs/ext4/page-io.c                           |   8 +-
 fs/f2fs/data.c                              |  15 +-
 fs/f2fs/segment.c                           |  14 +-
 fs/gfs2/lops.c                              |   2 +-
 fs/gfs2/ops_fstype.c                        |   2 +-
 fs/hfsplus/wrapper.c                        |  19 +-
 fs/jfs/jfs_logmgr.c                         |  12 +-
 fs/jfs/jfs_metapage.c                       |   9 +-
 fs/logfs/dev_bdev.c                         |  53 ++-
 fs/mpage.c                                  |  19 +-
 fs/nfs/blocklayout/blocklayout.c            |  43 +--
 fs/nilfs2/segbuf.c                          |   3 +-
 fs/ocfs2/cluster/heartbeat.c                |   2 +-
 fs/xfs/xfs_aops.c                           |   2 +-
 fs/xfs/xfs_buf.c                            |   4 +-
 include/linux/bio.h                         | 283 ++++++++++------
 include/linux/blk_types.h                   |  24 +-
 include/linux/blkdev.h                      |   9 +-
 include/linux/ceph/messenger.h              |   4 +-
 include/linux/dm-io.h                       |   4 +-
 include/trace/events/bcache.h               |  26 +-
 include/trace/events/block.h                |  26 +-
 include/trace/events/f2fs.h                 |   4 +-
 kernel/power/block_io.c                     |   2 +-
 kernel/trace/blktrace.c                     |  15 +-
 mm/bounce.c                                 |  44 ++-
 mm/page_io.c                                |  10 +-
 net/ceph/messenger.c                        |  43 +--
 132 files changed, 2063 insertions(+), 2656 deletions(-)
 create mode 100644 Documentation/block/biovecs.txt
