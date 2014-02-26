Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaBZXkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:40:07 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:32866 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaBZXkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:40:04 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Make generic_make_request() handle arbitrary size bios
Date: Wed, 26 Feb 2014 15:39:48 -0800
Message-Id: <1393457997-17618-1-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens, the following patches are for 3.15. This builds off of immutable biovecs,
and this series in turn enables the DIO rewrite I've been working on off and on
for ages and ages, and it also will let us delete merge_bvec_fn piecemeal
(altogether merge_bvec_fn is 1500 lines of code we'll be able to delete).

This will also get us performance gains (that I've measured myself, benchmarking
on a p320h) once we push the work of splitting too-big bios all the way down to
the drivers, and I expect bigger gains for stacking block drivers due to just
processing larger bios.

I've got a patch I'll send separately for the mtip32xx driver to make it take
arbitrary size bios, it's pretty small.

Also a few related small refactoring patches.

This is on top of your for-3.15/core branch.  If you want to pull these patches
from my tree, here's that:

The following changes since commit c46fff2a3b29794b35d717b5680a27f31a6a6bc0:

  smp: Rename __smp_call_function_single() to smp_call_function_single_async() (2014-02-24 14:47:15 -0800)

are available in the git repository at:

  git://evilpiepirate.org/~kent/linux-bcache.git for-jens

for you to fetch changes up to 089f8de5c42a121f351ef9d240d66e1128fa0ea2:

  iov_iter: Kill written arg to iov_iter_init() (2014-02-26 15:17:36 -0800)

----------------------------------------------------------------
Kent Overstreet (9):
      block: Make generic_make_request handle arbitrary sized bios
      block: Gut bio_add_page()
      blk-lib.c: generic_make_request() handles large bios now
      bcache: generic_make_request() handles large bios now
      btrfs: generic_make_request() handles arbitrary size bios now
      btrfs: Convert to bio_for_each_segment()
      iov_iter: Move iov_iter to uio.h
      iov_iter: Kill iov_iter_single_seg_count()
      iov_iter: Kill written arg to iov_iter_init()

 block/blk-core.c                            |  19 ++-
 block/blk-lib.c                             | 175 +++++-----------------------
 block/blk-merge.c                           | 150 ++++++++++++++++++++++--
 block/blk-mq.c                              |   2 +
 drivers/block/drbd/drbd_req.c               |   2 +
 drivers/block/mtip32xx/mtip32xx.c           |   6 +-
 drivers/block/nvme-core.c                   |   2 +
 drivers/block/pktcdvd.c                     |   6 +-
 drivers/block/ps3vram.c                     |   2 +
 drivers/block/rsxx/dev.c                    |   2 +
 drivers/block/umem.c                        |   2 +
 drivers/block/zram/zram_drv.c               |   2 +
 drivers/md/bcache/bcache.h                  |  18 ---
 drivers/md/bcache/io.c                      | 100 +---------------
 drivers/md/bcache/journal.c                 |   4 +-
 drivers/md/bcache/request.c                 |  16 +--
 drivers/md/bcache/super.c                   |  32 +----
 drivers/md/bcache/util.h                    |   5 +-
 drivers/md/bcache/writeback.c               |   4 +-
 drivers/md/dm.c                             |   2 +
 drivers/md/md.c                             |   2 +
 drivers/s390/block/dcssblk.c                |   2 +
 drivers/s390/block/xpram.c                  |   2 +
 drivers/staging/lustre/lustre/llite/lloop.c |   2 +
 fs/bio.c                                    | 137 +++++++++-------------
 fs/btrfs/extent_io.c                        |  12 +-
 fs/btrfs/file-item.c                        |  59 ++++------
 fs/btrfs/file.c                             |   8 +-
 fs/btrfs/inode.c                            |  22 ++--
 fs/btrfs/volumes.c                          |  73 ------------
 fs/ceph/file.c                              |   7 +-
 fs/cifs/file.c                              |   4 +-
 fs/fuse/file.c                              |  17 +--
 include/linux/blkdev.h                      |   3 +
 include/linux/fs.h                          |  32 -----
 include/linux/uio.h                         |  46 ++++++++
 mm/filemap.c                                |  19 +--
 37 files changed, 399 insertions(+), 599 deletions(-)


