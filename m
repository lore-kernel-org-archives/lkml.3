Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaAJCkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:40:11 -0500
Received: from mga02.intel.com ([134.134.136.20]:49025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaAJCkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:40:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="436681337"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 0/6] Page I/O
Date: Thu,  9 Jan 2014 21:39:45 -0500
Message-Id: <1389321591-25455-1-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set implements pageio as I described in my talk at
Linux.Conf.AU.  It's for review more than application, I think
benchmarking is going to be required to see if it's a win.  We've done
some benchmarking with an earlier version of the patch and a Chatham card,
and it's a win for us.

The fundamental point of these patches is that we *can* do I/O without
allocating a BIO (or request, or ...) and so we can end up doing fun
things like swapping out a page without allocating any memory.

Possibly it would be interesting to do sub-page I/Os (ie change the
rw_page prototype to take a 'start' and 'length' instead of requiring the
I/O to be the entire page), but the problem then arises about what the
'done' callback should be.

Keith Busch (1):
  NVMe: Add support for rw_page

Matthew Wilcox (5):
  Add bdev_read_page() and bdev_write_page()
  Factor page_endio() out of mpage_end_io()
  swap: Use bdev_read_page() / bdev_write_page()
  brd: Add support for rw_page
  virtio_blk: Add rw_page implementation

 drivers/block/brd.c        |   10 +++
 drivers/block/nvme-core.c  |  129 ++++++++++++++++++++++++++++++++++++---------
 drivers/block/virtio_blk.c |   44 +++++++++++++++
 fs/block_dev.c             |   34 +++++++++++
 fs/mpage.c                 |   83 +++++++++++++++-------------
 include/linux/blkdev.h     |    4 +
 include/linux/pagemap.h    |    2 
 mm/filemap.c               |   25 ++++++++
 mm/page_io.c               |   23 +++++++-
 9 files changed, 288 insertions(+), 66 deletions(-)

