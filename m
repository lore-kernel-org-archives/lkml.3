Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985Ab3JOUUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:20:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:42351 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759728Ab3JOUUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:20:13 -0400
Date: Tue, 15 Oct 2013 13:20:09 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, Neil Brown <neilb@suse.de>,
        Christoph Hellwig <hch@infradead.org>
Subject: [GIT PULL] Immutable biovecs
Message-ID: <20131015202009.GN28572@kmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens - here's the immutable biovec patch series, it should all be ready
to go. Mike Snitzer's tested the dm stuff, I've tested it with bio
integrity, the aoe driver, bcache and md.

This paves the way for the dio rewrite, multipage bvecs, killing
merge_bvec_fn, and more:

The following changes since commit 342799dee522b11ec205dba7a5c7fe64f2a0fec0:

  bcache: Fix flushes in writeback mode (2013-10-10 21:13:20 -0700)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git for-jens

for you to fetch changes up to e5cb0350156d84c2c976bbc2435e66b2bbbf1edb:

  block: Don't save/copy bvec array anymore, share when cloning (2013-10-11 15:45:50 -0700)

----------------------------------------------------------------
Kent Overstreet (23):
      block: Use rw_copy_check_uvector()
      block: Consolidate duplicated bio_trim() implementations
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
      rbd: Refactor bio cloning, don't clone biovecs
      dm: Refactor for new bio cloning/splitting
      block: Remove bi_idx hacks
      block: Generic bio chaining
      block: Rename bio_split() -> bio_pair_split()
      block: Introduce new bio_split()
      block: Kill bio_pair_split()
      block: Don't save/copy bvec array anymore, share when cloning

 Documentation/block/biodoc.txt              |   7 +-
 arch/m68k/emu/nfblock.c                     |  13 +-
 arch/powerpc/sysdev/axonram.c               |  21 +-
 block/blk-core.c                            |  36 +--
 block/blk-flush.c                           |   2 +-
 block/blk-integrity.c                       |  40 +--
 block/blk-lib.c                             |  12 +-
 block/blk-map.c                             |   6 +-
 block/blk-merge.c                           |  66 +++--
 block/blk-throttle.c                        |  14 +-
 block/elevator.c                            |   2 +-
 block/scsi_ioctl.c                          |  39 +--
 drivers/block/aoe/aoe.h                     |  10 +-
 drivers/block/aoe/aoecmd.c                  | 153 ++++------
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
 drivers/block/nvme-core.c                   | 142 ++-------
 drivers/block/pktcdvd.c                     | 182 ++++++------
 drivers/block/ps3disk.c                     |   7 +-
 drivers/block/ps3vram.c                     |  10 +-
 drivers/block/rbd.c                         |  89 +-----
 drivers/block/rsxx/dev.c                    |   6 +-
 drivers/block/rsxx/dma.c                    |  15 +-
 drivers/block/umem.c                        |  53 ++--
 drivers/block/virtio_blk.c                  |   4 +-
 drivers/block/xen-blkback/blkback.c         |   2 +-
 drivers/block/xen-blkfront.c                |  55 +---
 drivers/md/bcache/alloc.c                   |   4 +-
 drivers/md/bcache/bcache.h                  |   2 -
 drivers/md/bcache/btree.c                   |  23 +-
 drivers/md/bcache/debug.c                   |  29 +-
 drivers/md/bcache/io.c                      | 196 ++-----------
 drivers/md/bcache/journal.c                 |  12 +-
 drivers/md/bcache/movinggc.c                |   4 +-
 drivers/md/bcache/request.c                 | 110 +++----
 drivers/md/bcache/request.h                 |   1 -
 drivers/md/bcache/super.c                   |  20 +-
 drivers/md/bcache/util.c                    |   4 +-
 drivers/md/bcache/writeback.c               |   6 +-
 drivers/md/bcache/writeback.h               |   2 +-
 drivers/md/dm-bio-record.h                  |  37 +--
 drivers/md/dm-bufio.c                       |   2 +-
 drivers/md/dm-cache-policy-mq.c             |   4 +-
 drivers/md/dm-cache-target.c                |  26 +-
 drivers/md/dm-crypt.c                       |  64 ++--
 drivers/md/dm-delay.c                       |   7 +-
 drivers/md/dm-flakey.c                      |   7 +-
 drivers/md/dm-io.c                          |  37 +--
 drivers/md/dm-linear.c                      |   3 +-
 drivers/md/dm-raid1.c                       |  20 +-
 drivers/md/dm-region-hash.c                 |   3 +-
 drivers/md/dm-snap.c                        |  18 +-
 drivers/md/dm-stripe.c                      |  13 +-
 drivers/md/dm-switch.c                      |   4 +-
 drivers/md/dm-thin.c                        |  30 +-
 drivers/md/dm-verity.c                      |  60 ++--
 drivers/md/dm.c                             | 185 ++----------
 drivers/md/faulty.c                         |  19 +-
 drivers/md/linear.c                         |  96 +++---
 drivers/md/md.c                             |  50 +---
 drivers/md/md.h                             |   1 -
 drivers/md/multipath.c                      |  13 +-
 drivers/md/raid0.c                          |  79 ++---
 drivers/md/raid1.c                          |  67 +++--
 drivers/md/raid10.c                         | 202 ++++++-------
 drivers/md/raid5.c                          |  84 +++---
 drivers/message/fusion/mptsas.c             |   8 +-
 drivers/s390/block/dcssblk.c                |  19 +-
 drivers/s390/block/xpram.c                  |  19 +-
 drivers/scsi/libsas/sas_expander.c          |   8 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c    |  41 +--
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |  39 +--
 drivers/scsi/osd/osd_initiator.c            |   2 +-
 drivers/scsi/sd.c                           |   2 +-
 drivers/scsi/sd_dif.c                       |  30 +-
 drivers/staging/lustre/lustre/llite/lloop.c |  26 +-
 drivers/staging/zram/zram_drv.c             |  33 ++-
 drivers/target/target_core_iblock.c         |   2 +-
 fs/bio-integrity.c                          | 191 +++---------
 fs/bio.c                                    | 434 +++++++++++++---------------
 fs/btrfs/check-integrity.c                  |   8 +-
 fs/btrfs/compression.c                      |  17 +-
 fs/btrfs/extent_io.c                        |  16 +-
 fs/btrfs/file-item.c                        |  19 +-
 fs/btrfs/inode.c                            |  22 +-
 fs/btrfs/raid56.c                           |  22 +-
 fs/btrfs/scrub.c                            |  12 +-
 fs/btrfs/volumes.c                          |  12 +-
 fs/buffer.c                                 |  12 +-
 fs/direct-io.c                              |   4 +-
 fs/ext4/page-io.c                           |   4 +-
 fs/f2fs/data.c                              |   2 +-
 fs/f2fs/segment.c                           |   2 +-
 fs/gfs2/lops.c                              |   2 +-
 fs/gfs2/ops_fstype.c                        |   2 +-
 fs/hfsplus/wrapper.c                        |   2 +-
 fs/jfs/jfs_logmgr.c                         |  12 +-
 fs/jfs/jfs_metapage.c                       |   9 +-
 fs/logfs/dev_bdev.c                         |  20 +-
 fs/mpage.c                                  |   2 +-
 fs/nfs/blocklayout/blocklayout.c            |   9 +-
 fs/nilfs2/segbuf.c                          |   3 +-
 fs/ocfs2/cluster/heartbeat.c                |   2 +-
 fs/xfs/xfs_aops.c                           |   2 +-
 fs/xfs/xfs_buf.c                            |   4 +-
 include/linux/bio.h                         | 280 +++++++++++-------
 include/linux/blk_types.h                   |  23 +-
 include/linux/blkdev.h                      |   9 +-
 include/linux/ceph/messenger.h              |   4 +-
 include/linux/dm-io.h                       |   4 +-
 include/trace/events/bcache.h               |  26 +-
 include/trace/events/block.h                |  26 +-
 include/trace/events/f2fs.h                 |   4 +-
 kernel/power/block_io.c                     |   2 +-
 kernel/trace/blktrace.c                     |  15 +-
 mm/bounce.c                                 |  45 ++-
 mm/page_io.c                                |  10 +-
 net/ceph/messenger.c                        |  43 ++-
 128 files changed, 1791 insertions(+), 2464 deletions(-)

