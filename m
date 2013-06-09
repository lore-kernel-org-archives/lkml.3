Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704Ab3FICTk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jun 2013 22:19:40 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:55318 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3FICTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jun 2013 22:19:38 -0400
From: Kent Overstreet <koverstreet@google.com>
To: axboe@kernel.dk, tytso@mit.edu, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Immutable biovecs, dio rewrite
Date: Sat,  8 Jun 2013 19:18:42 -0700
Message-Id: <1370744348-15407-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Immutable biovecs: Drivers no longer modify the biovec array directly
(bv_len/bv_offset in particular) - we add a real iterator to struct bio
that lets drivers partially complete a bio while only modifying the
iterator. The iterator has the existing bi_sector, bi_size, bi_idx
memembers, and also bi_bvec_done.

This gets us a couple things:
 * Changing all the drivers to go through the iterator means that we can
   submit a partially completed bio to generic_make_request() - this
   previously worked on some drivers, but worked on others.

   This makes it much easier for upper layers to process bios
   incrementally - not just stacking drivers, my dio rewrite relies
   heavily on this strategy.

 * Previously, any code that might need to retry a bio somehow if it
   errored (mainly stacking drivers) had to clone not just the bio, but
   the entire biovec. The biovec can be up to BIO_MAX_PAGES, which works
   out to 4k...

 * When cloning a bio, now we don't have to clone the biovec unless we
   want to modify it. Bio splitting also becomes just a special case of
   cloning a bio.

We also get to delete a lot of code. And this patch series barely
scratches the surface - I've got more patches that delete another 1.5k
lines of code, without trying all that hard.

I'd like to get as much of this into 3.11 as possible - I don't know if
the dio rewrite is a realistic possibility (it currently breaks btrfs -
we need to add a different hook for them) and it does need a lot of
review and testing from the various driver maintainers. The dio rewrite
does pass xfstests for me, though.

Patch series is on top of v3.10-rc4, and it's available in my git tree:

git://evilpiepirate.org/~kent/linux-bcache.git block
http://evilpiepirate.org/git/linux-bcache.git block

 Documentation/block/biodoc.txt           |    7 +-
 arch/m68k/emu/nfblock.c                  |   13 +-
 arch/powerpc/sysdev/axonram.c            |   21 +-
 block/blk-core.c                         |   74 +-
 block/blk-flush.c                        |    2 +-
 block/blk-integrity.c                    |   40 +-
 block/blk-lib.c                          |  179 +---
 block/blk-map.c                          |    6 +-
 block/blk-merge.c                        |  193 ++++-
 block/blk-throttle.c                     |   13 +-
 block/blk.h                              |    3 +
 block/elevator.c                         |    2 +-
 drivers/block/aoe/aoe.h                  |   10 +-
 drivers/block/aoe/aoecmd.c               |  145 ++--
 drivers/block/brd.c                      |   16 +-
 drivers/block/drbd/drbd_actlog.c         |    2 +-
 drivers/block/drbd/drbd_bitmap.c         |    2 +-
 drivers/block/drbd/drbd_main.c           |   27 +-
 drivers/block/drbd/drbd_receiver.c       |   19 +-
 drivers/block/drbd/drbd_req.c            |    6 +-
 drivers/block/drbd/drbd_req.h            |    2 +-
 drivers/block/drbd/drbd_worker.c         |    8 +-
 drivers/block/floppy.c                   |   16 +-
 drivers/block/loop.c                     |   27 +-
 drivers/block/mtip32xx/mtip32xx.c        |   22 +-
 drivers/block/nbd.c                      |   14 +-
 drivers/block/nvme-core.c                |  144 +---
 drivers/block/pktcdvd.c                  |  178 ++--
 drivers/block/ps3disk.c                  |    7 +-
 drivers/block/ps3vram.c                  |   10 +-
 drivers/block/rbd.c                      |   89 +-
 drivers/block/rsxx/dev.c                 |    4 +-
 drivers/block/rsxx/dma.c                 |   15 +-
 drivers/block/umem.c                     |   53 +-
 drivers/block/virtio_blk.c               |    4 +-
 drivers/block/xen-blkback/blkback.c      |    2 +-
 drivers/block/xen-blkfront.c             |   14 +-
 drivers/md/bcache/alloc.c                |    4 +-
 drivers/md/bcache/bcache.h               |   20 -
 drivers/md/bcache/btree.c                |   32 +-
 drivers/md/bcache/debug.c                |   33 +-
 drivers/md/bcache/io.c                   |  260 +-----
 drivers/md/bcache/journal.c              |   16 +-
 drivers/md/bcache/movinggc.c             |   11 +-
 drivers/md/bcache/request.c              |  203 ++---
 drivers/md/bcache/request.h              |    1 -
 drivers/md/bcache/super.c                |   60 +-
 drivers/md/bcache/util.c                 |   21 +-
 drivers/md/bcache/util.h                 |    8 +-
 drivers/md/bcache/writeback.c            |   17 +-
 drivers/md/dm-bio-record.h               |   37 +-
 drivers/md/dm-bufio.c                    |    2 +-
 drivers/md/dm-cache-policy-mq.c          |    4 +-
 drivers/md/dm-cache-target.c             |   16 +-
 drivers/md/dm-crypt.c                    |   68 +-
 drivers/md/dm-delay.c                    |    7 +-
 drivers/md/dm-flakey.c                   |    7 +-
 drivers/md/dm-io.c                       |   38 +-
 drivers/md/dm-linear.c                   |    3 +-
 drivers/md/dm-raid1.c                    |   20 +-
 drivers/md/dm-region-hash.c              |    3 +-
 drivers/md/dm-snap.c                     |   13 +-
 drivers/md/dm-stripe.c                   |   13 +-
 drivers/md/dm-thin.c                     |   23 +-
 drivers/md/dm-verity.c                   |   61 +-
 drivers/md/dm.c                          |  181 +---
 drivers/md/faulty.c                      |   19 +-
 drivers/md/linear.c                      |   96 +--
 drivers/md/md.c                          |   35 +-
 drivers/md/multipath.c                   |   13 +-
 drivers/md/raid0.c                       |   79 +-
 drivers/md/raid1.c                       |   63 +-
 drivers/md/raid10.c                      |  198 +++--
 drivers/md/raid5.c                       |   84 +-
 drivers/message/fusion/mptsas.c          |    8 +-
 drivers/s390/block/dcssblk.c             |   19 +-
 drivers/s390/block/xpram.c               |   19 +-
 drivers/scsi/libsas/sas_expander.c       |    8 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |   41 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c |   39 +-
 drivers/scsi/osd/osd_initiator.c         |    2 +-
 drivers/scsi/sd.c                        |    2 +-
 drivers/scsi/sd_dif.c                    |   30 +-
 drivers/staging/zram/zram_drv.c          |   31 +-
 drivers/target/target_core_iblock.c      |    2 +-
 fs/bio-integrity.c                       |  189 +----
 fs/bio.c                                 |  527 ++++++------
 fs/btrfs/check-integrity.c               |   10 +-
 fs/btrfs/compression.c                   |   17 +-
 fs/btrfs/extent_io.c                     |   16 +-
 fs/btrfs/file-item.c                     |   13 +-
 fs/btrfs/inode.c                         |   17 +-
 fs/btrfs/raid56.c                        |   22 +-
 fs/btrfs/scrub.c                         |   12 +-
 fs/btrfs/volumes.c                       |   12 +-
 fs/buffer.c                              |   12 +-
 fs/direct-io.c                           | 1318 ++++++++----------------------
 fs/ext4/page-io.c                        |    4 +-
 fs/f2fs/data.c                           |    2 +-
 fs/f2fs/segment.c                        |    3 +-
 fs/gfs2/lops.c                           |    2 +-
 fs/gfs2/ops_fstype.c                     |    2 +-
 fs/hfsplus/wrapper.c                     |    2 +-
 fs/jfs/jfs_logmgr.c                      |   10 +-
 fs/jfs/jfs_metapage.c                    |    9 +-
 fs/logfs/dev_bdev.c                      |   20 +-
 fs/mpage.c                               |    2 +-
 fs/nfs/blocklayout/blocklayout.c         |    9 +-
 fs/nilfs2/segbuf.c                       |    3 +-
 fs/ocfs2/cluster/heartbeat.c             |    2 +-
 fs/xfs/xfs_aops.c                        |    2 +-
 fs/xfs/xfs_buf.c                         |    4 +-
 include/linux/bio.h                      |  226 +++--
 include/linux/blk_types.h                |   28 +-
 include/linux/blkdev.h                   |   13 +-
 include/linux/dm-io.h                    |    4 +-
 include/trace/events/bcache.h            |   20 +-
 include/trace/events/block.h             |   26 +-
 include/trace/events/f2fs.h              |    4 +-
 kernel/power/block_io.c                  |    2 +-
 kernel/trace/blktrace.c                  |   15 +-
 mm/bounce.c                              |   45 +-
 mm/page_io.c                             |   10 +-
 123 files changed, 2236 insertions(+), 3757 deletions(-)

