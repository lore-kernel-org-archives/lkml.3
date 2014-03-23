Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaCWTIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 15:08:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:3667 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaCWTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 15:08:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,715,1389772800"; 
   d="scan'208";a="505943968"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com
Subject: [PATCH v2 0/6] Page I/O
Date: Sun, 23 Mar 2014 15:08:22 -0400
Message-Id: <cover.1395593198.git.matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Page I/O allows us to read/write pages to storage without allocating any
memory (in particular, it avoids allocating a BIO).  This is nice for
the purposes of swap and reduces overhead for fast storage devices.  The
downside is that it removes all batching from the I/O path, potentially
sending dozens of commands for a large I/O instead of just one.

This iteration of the Page I/O patchset has been tested with xfstests
on ext4 on brd, and there are no unexpected failures.

Changes since v1:

 - Rebased to 3.14-rc7
 - Separate out the clean_buffers() refactoring into its own patch
 - Change the page_endio() interface to take an error code rather than
   a boolean 'success'.  All of its callers prefer this (and my earlier
   patchset got this wrong in one caller).
 - Added kerneldoc to bdev_read_page() and bdev_write_page()
 - bdev_write_page() now does less on failure.  Since its two customers
   (swap and mpage) want to do different things to the page flags on
   failure, let them.
 - Drop the virtio_blk patch, since I don't think it should be included

Keith Busch (1):
  NVMe: Add support for rw_page

Matthew Wilcox (5):
  Factor clean_buffers() out of __mpage_writepage()
  Factor page_endio() out of mpage_end_io()
  Add bdev_read_page() and bdev_write_page()
  swap: Use bdev_read_page() / bdev_write_page()
  brd: Add support for rw_page

 drivers/block/brd.c       |  10 ++++
 drivers/block/nvme-core.c | 129 +++++++++++++++++++++++++++++++++++++---------
 fs/block_dev.c            |  63 ++++++++++++++++++++++
 fs/mpage.c                |  84 +++++++++++++++---------------
 include/linux/blkdev.h    |   4 ++
 include/linux/pagemap.h   |   2 +
 mm/filemap.c              |  25 +++++++++
 mm/page_io.c              |  23 ++++++++-
 8 files changed, 273 insertions(+), 67 deletions(-)

-- 
1.9.0

