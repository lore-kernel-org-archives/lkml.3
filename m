Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbbALLok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:44:40 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:57339 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362AbbALLoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:44:37 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [RFC PATCH v2 0/7] preparation for block layer simplification
Date: Mon, 12 Jan 2015 12:43:57 +0100
Message-Id: <cover.1421052656.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation series for simplifying block layer based on immutable
biovecs, a spin off of the v1 of simplifying patchset. [1] The original
goal of simplifying block layer was actually making generic_make_request()
accept arbitrarily sized bios, and pushing the splitting down to the
underlying drivers.

This patchset aims at cleaning up several parts that are independent of
core changes in the block layer. Doing that, it could be possible to
change block layer relatively easily without keeping up with many patches.

- Patches 01-04/07 do refactoring to make the block layer use the new
  iov_iter interface.
- Patch 05/07 does refactoring and cleanup in MD-RAID10.
- Patch 06/07 changes a way of refcounting in fs/buffer.c, to be consistent
  with immutable biovecs API.
- Patch 07/07 makes bio submission in kernel/power in a sane way.

Patches are against 3.19-rc4. These are also available in my git repo at:

  https://github.com/dongsupark/linux.git block-prep-simplify

This patchset should be first applied prior to upcoming patchsets such as
"simplify block layer based on immutable biovecs." This patchset itself
should not bring any regression to end-users.

Comments are welcome.
Dongsu

Changes in v2:
- split up preparation patches from v1 into this separate series.
- In the patch 02, pass iov_iter by value to __bio_copy_iov(), and split
  into read/write variants, as suggested by Christoph Hellwig.
- minor changes like writing more commit messages etc.

[1] https://lkml.org/lkml/2014/12/22/128


Dongsu Park (1):
  block: rewrite __bio_copy_iov()

Kent Overstreet (6):
  block: replace sg_iovec with iov_iter
  block: refactor iov_count_pages() from bio_{copy,map}_user_iov()
  block: refactor bio_get_user_pages() from __bio_map_user_iov()
  md/raid10: make sync_request_write() call bio_copy_data()
  fs: make _submit_bh consistent with generic bio chaining
  PM: submit bio in a sane way in cases without bio_chain

 block/bio.c             | 330 +++++++++++++++++++++++++-----------------------
 block/blk-map.c         |  27 ++--
 block/scsi_ioctl.c      |  19 +--
 drivers/md/raid10.c     |  20 +--
 drivers/scsi/sg.c       |  15 +--
 fs/buffer.c             |   4 +-
 include/linux/bio.h     |  10 +-
 include/linux/blkdev.h  |   4 +-
 include/linux/uio.h     |   2 +
 kernel/power/block_io.c |  23 +++-
 lib/iovec.c             |  30 +++++
 11 files changed, 263 insertions(+), 221 deletions(-)

-- 
2.1.0

