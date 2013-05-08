Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab3EHOvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:51:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:47861
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755957Ab3EHOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:50:59 -0400
Date: Wed, 8 May 2013 16:50:23 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Block IO core changes for 3.10
Message-ID: <20130508145023.GN7800@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Below are the block layer core changes for 3.10. The pull request
contains:

- Major bit is Kents prep work for immutable bio vecs.

- Stable candidate fix for a scheduling-while-atomic in the queue bypass
  operation.

- Fix for the hang on exceeded rq->datalen 32-bit unsigned when merging
  discard bios.

- Tejuns changes to convert the writeback thread pool to the generic
  workqueue mechanism.

- Runtime PM framework, SCSI patches exists on top of these in James'
  tree.

- A few random fixes.

Please pull! Should satisfy your merge cravings too.


  git://git.kernel.dk/linux-block.git for-3.10/core

----------------------------------------------------------------
Dmitry Monakhov (1):
      relay: move remove_buf_file inside relay_close_buf

Gu Zheng (1):
      fs/block_dev.c: fix iov_shorten() criteria in blkdev_aio_read()

James Bottomley (1):
      block: fix max discard sectors limit

Jens Axboe (2):
      Merge branch 'for-jens' of http://evilpiepirate.org/git/linux-bcache into for-3.10/core
      Merge branch 'writeback-workqueue' of git://git.kernel.org/.../tj/wq into for-3.10/core

Jun'ichi Nomura (1):
      blkcg: fix "scheduling while atomic" in blk_queue_bypass_start

Kent Overstreet (28):
      block: Reorder struct bio_set
      block: Avoid deadlocks with bio allocation by stacking drivers
      block: Fix a buffer overrun in bio_integrity_split()
      block: Convert integrity to bvec_alloc_bs()
      block: Add bio_advance()
      block: Refactor blk_update_request()
      md: Convert md_trim_bio() to use bio_advance()
      block: Add bio_end_sector()
      block: Use bio_sectors() more consistently
      block: Change bio_split() to respect the current value of bi_idx
      block: Remove bi_idx references
      block: Remove some unnecessary bi_vcnt usage
      block: Add submit_bio_wait(), remove from md
      raid10: Use bio_reset()
      raid1: use bio_reset()
      raid5: use bio_reset()
      raid1: Refactor narrow_write_error() to not use bi_idx
      block: Add bio_copy_data()
      pktcdvd: use bio_copy_data()
      pktcdvd: Use bio_reset() in disabled code to kill bi_idx usage
      raid1: use bio_copy_data()
      bounce: Refactor __blk_queue_bounce to not use bi_io_vec
      block: Add bio_for_each_segment_all()
      block: Convert some code to bio_for_each_segment_all()
      block: Add bio_alloc_pages()
      block: Add an explicit bio flag for bios that own their bvec
      bio-integrity: Add explicit field for owner of bip_buf
      aoe: Fix unitialized var usage

Lin Ming (3):
      block: add a flag to identify PM request
      block: add runtime pm helpers
      block: implement runtime pm strategy

Namjae Jeon (1):
      Documentation: cfq-iosched: update documentation help for cfq tunables

Philippe De Muyter (1):
      partitions/efi.c: replace useless kzalloc's by kmalloc's

Tejun Heo (3):
      writeback: remove unused bdi_pending_list
      writeback: replace custom worker pool implementation with unbound workqueue
      writeback: expose the bdi_wq workqueue

 Documentation/block/cfq-iosched.txt      |  47 +++-
 block/blk-cgroup.c                       |   4 +-
 block/blk-core.c                         | 265 ++++++++++++++++------
 block/cfq-iosched.c                      |   7 +-
 block/deadline-iosched.c                 |   2 +-
 block/elevator.c                         |  26 +++
 block/partitions/efi.c                   |   4 +-
 drivers/block/aoe/aoecmd.c               |   2 +-
 drivers/block/brd.c                      |   3 +-
 drivers/block/floppy.c                   |   1 -
 drivers/block/pktcdvd.c                  | 102 ++-------
 drivers/block/rbd.c                      |   2 +-
 drivers/md/dm-crypt.c                    |   3 +-
 drivers/md/dm-raid1.c                    |   2 +-
 drivers/md/dm-stripe.c                   |   2 +-
 drivers/md/dm-verity.c                   |   4 +-
 drivers/md/faulty.c                      |   6 +-
 drivers/md/linear.c                      |   3 +-
 drivers/md/md.c                          |  17 +-
 drivers/md/raid0.c                       |   9 +-
 drivers/md/raid1.c                       | 133 ++++-------
 drivers/md/raid10.c                      |  78 ++-----
 drivers/md/raid5.c                       |  49 ++---
 drivers/message/fusion/mptsas.c          |   6 +-
 drivers/s390/block/dcssblk.c             |   3 +-
 drivers/scsi/libsas/sas_expander.c       |   6 +-
 drivers/scsi/mpt2sas/mpt2sas_transport.c |  10 +-
 fs/bio-integrity.c                       | 144 +++++-------
 fs/bio.c                                 | 366 +++++++++++++++++++++++++++----
 fs/block_dev.c                           |   2 +-
 fs/btrfs/extent_io.c                     |   3 +-
 fs/btrfs/volumes.c                       |   2 +-
 fs/buffer.c                              |   1 -
 fs/direct-io.c                           |   8 +-
 fs/exofs/ore.c                           |   2 +-
 fs/exofs/ore_raid.c                      |   2 +-
 fs/fs-writeback.c                        | 102 +++------
 fs/gfs2/lops.c                           |   2 +-
 fs/jfs/jfs_logmgr.c                      |   2 -
 fs/logfs/dev_bdev.c                      |   5 -
 include/linux/backing-dev.h              |  16 +-
 include/linux/bio.h                      | 115 ++++++----
 include/linux/blk_types.h                |   5 +
 include/linux/blkdev.h                   |  29 ++-
 include/trace/events/block.h             |  12 +-
 include/trace/events/writeback.h         |   5 -
 kernel/relay.c                           |   2 +-
 mm/backing-dev.c                         | 259 +++-------------------
 mm/bounce.c                              |  75 ++-----
 mm/page_io.c                             |   1 -
 50 files changed, 1000 insertions(+), 956 deletions(-)

-- 
Jens Axboe

