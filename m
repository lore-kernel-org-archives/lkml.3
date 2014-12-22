Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaLVLtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 06:49:24 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54434 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbaLVLtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 06:49:23 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Ming Lin <mlin@minggr.net>, Dongsu Park <dongsu.park@profitbricks.com>
Subject: [RFC PATCH 00/17] simplify block layer based on immutable biovecs
Date: Mon, 22 Dec 2014 12:48:27 +0100
Message-Id: <cover.1419241597.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the first attempt of simplifying block layer based on immutable
biovecs. Immutable biovecs, implemented by Kent Overstreet, have been
available in mainline since v3.14. Its original goal was actually making
generic_make_request() accept arbitrarily sized bios, and pushing the
splitting down to the drivers or wherever it's required. See also
discussions in the past, [1] [2] [3].

This will bring not only performance improvements, but also a great amount
of reduction in code complexity all over the block layer. Performance gain
is possible due to the fact that bio_add_page() does not have to check
unnecesary conditions such as queue limits or if biovecs are mergeable.
Those will be delegated to the driver level. Kent already said that he
actually benchmarked the impact of this with fio on a micron p320h, which
showed definitely a positive impact.

Moreover, this patchset also allows a lot of code to be deleted, mainly
because of removal of merge_bvec_fn() callbacks. We have been aware that
it has been always a delicate issue for stacking block drivers (e.g. md
and bcache) to handle merging bio consistently. This simplication will
help every individual block driver avoid having such an issue.

- Patch 01/17 allows generic_make_request handle arbitrarily sized bios,
  by making make_request functions call blk_queue_split().
- Patch 02/17 simplifies __bio_add_page() to avoid calling
  ->merge_bvec_fn().
- Patch 03/17 modifies ways of issueing discard, write_same, and zeroout.
- Patch 04/17 gets rid of workarounds of bcache.
- Patches 05-06/17 remove unnecessary codes in btrfs, making use of
  immutable biovecs.
- Patches 07-10/17 do refactoring to make the block layer use the new
  iov_iter interface.
- Patch 11/17 allows queue_bounce to handle bios with > BIO_MAX_PAGES
- Patch 12-13/17 do refactoring and cleanup in MD-RAID.
- Patch 14 removes ->merge_bvec_fn() completely, which affects a lot of
  block drivers, such as Ceph RBD, DRBD, device mapper, MD, etc.
- Patch 15-16 do refactoring and cleanup in filesystems, according to
  new APIs like immutable biovecs.
- Patch 17 updates document about biovecs.

Patches are against 3.19-rc1. These are also available in my git repo at:

  https://github.com/dongsupark/linux.git block-generic-req

This patchset is a prerequisite of other consecutive patchsets, e.g.
multipage biovecs, rewriting plugging, or rewriting direct-IO, which are
excluded this time. That means, this patchset should not bring any
regression to end-users. I already tested it with xfstests multiple times.
On the other hand, the multipage biovecs part is currently in heavy
development, with help of Kent and Ming Lin. Those experimental patches
are also available on other branches on my git tree. Once they are done,
I'm also going to post them to get reviews.

Comments are welcome.
Dongsu

[1] https://lkml.org/lkml/2014/11/23/263
[2] https://lkml.org/lkml/2013/11/25/732
[3] https://lkml.org/lkml/2014/2/26/618

Dongsu Park (1):
  Documentation: update notes in biovecs about arbitrarily sized bios

Kent Overstreet (16):
  block: make generic_make_request handle arbitrarily sized bios
  block: simplify bio_add_page()
  block: simplify issueing discard, write_same, zeroout
  bcache: clean up hacks around bio_split_pool
  btrfs: remove bio splitting and merge_bvec_fn() calls
  btrfs: make use of immutable biovecs
  block: replace sg_iovec with iov_iter
  block: refactor __bio_copy_iov()
  block: refactor iov_count_pages() from bio_{copy,map}_user_iov()
  block: refactor bio_get_user_pages() from __bio_map_user_iov()
  block: allow __blk_queue_bounce() to handle bios larger than
    BIO_MAX_PAGES
  md/raid10: make sync_request_write() call bio_copy_data()
  md/raid5: get rid of bio_fits_rdev()
  block: kill merge_bvec_fn() completely
  fs: use helper bio_add_page() instead of open coding on bi_io_vec
  fs: convert buffer head etc. to use immutable biovecs API.

 Documentation/block/biovecs.txt             |  17 +-
 block/bio.c                                 | 430 ++++++++++++----------------
 block/blk-core.c                            |  19 +-
 block/blk-lib.c                             | 173 ++---------
 block/blk-map.c                             |  27 +-
 block/blk-merge.c                           | 140 ++++++++-
 block/blk-mq.c                              |   2 +
 block/blk-settings.c                        |  22 --
 block/bounce.c                              |  60 +++-
 block/scsi_ioctl.c                          |  19 +-
 drivers/block/drbd/drbd_int.h               |   1 -
 drivers/block/drbd/drbd_main.c              |   1 -
 drivers/block/drbd/drbd_req.c               |  37 +--
 drivers/block/pktcdvd.c                     |  27 +-
 drivers/block/ps3vram.c                     |   2 +
 drivers/block/rbd.c                         |  47 ---
 drivers/block/rsxx/dev.c                    |   2 +
 drivers/block/umem.c                        |   2 +
 drivers/block/zram/zram_drv.c               |   2 +
 drivers/md/bcache/bcache.h                  |  18 --
 drivers/md/bcache/io.c                      | 100 +------
 drivers/md/bcache/journal.c                 |   4 +-
 drivers/md/bcache/request.c                 |  16 +-
 drivers/md/bcache/super.c                   |  32 +--
 drivers/md/bcache/util.h                    |   5 +-
 drivers/md/bcache/writeback.c               |   4 +-
 drivers/md/dm-cache-target.c                |  21 --
 drivers/md/dm-crypt.c                       |  16 --
 drivers/md/dm-era-target.c                  |  15 -
 drivers/md/dm-flakey.c                      |  16 --
 drivers/md/dm-linear.c                      |  16 --
 drivers/md/dm-snap.c                        |  15 -
 drivers/md/dm-stripe.c                      |  21 --
 drivers/md/dm-table.c                       |   8 -
 drivers/md/dm-thin.c                        |  31 --
 drivers/md/dm-verity.c                      |  16 --
 drivers/md/dm.c                             | 122 +-------
 drivers/md/dm.h                             |   2 -
 drivers/md/linear.c                         |  46 ---
 drivers/md/md.c                             |   4 +-
 drivers/md/md.h                             |   8 -
 drivers/md/multipath.c                      |  21 --
 drivers/md/raid0.c                          |  57 ----
 drivers/md/raid0.h                          |   2 -
 drivers/md/raid1.c                          |  59 +---
 drivers/md/raid10.c                         | 142 +--------
 drivers/md/raid5.c                          |  51 +---
 drivers/s390/block/dcssblk.c                |   2 +
 drivers/s390/block/xpram.c                  |   2 +
 drivers/scsi/sg.c                           |  15 +-
 drivers/staging/lustre/lustre/llite/lloop.c |   2 +
 fs/btrfs/check-integrity.c                  |  22 +-
 fs/btrfs/extent_io.c                        |  12 +-
 fs/btrfs/file-item.c                        |  61 ++--
 fs/btrfs/inode.c                            |  22 +-
 fs/btrfs/volumes.c                          |  73 -----
 fs/buffer.c                                 |  11 +-
 fs/jfs/jfs_logmgr.c                         |  14 +-
 include/linux/bio.h                         |  10 +-
 include/linux/blkdev.h                      |  17 +-
 include/linux/device-mapper.h               |   4 -
 include/linux/uio.h                         |   2 +
 kernel/power/block_io.c                     |  23 +-
 lib/iovec.c                                 |  30 ++
 mm/page_io.c                                |   8 +-
 65 files changed, 628 insertions(+), 1600 deletions(-)

-- 
2.1.0

