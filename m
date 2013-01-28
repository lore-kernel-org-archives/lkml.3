Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab3A1JXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:23:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:60169 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab3A1JXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:23:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,550,1355126400"; 
   d="scan'208";a="282975103"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH, RFC 00/16] Transparent huge page cache
Date: Mon, 28 Jan 2013 11:24:12 +0200
Message-Id: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Here's first steps towards huge pages in page cache.

The intend of the work is get code ready to enable transparent huge page
cache for the most simple fs -- ramfs.

It's not yet near feature-complete. It only provides basic infrastructure.
At the moment we can read, write and truncate file on ramfs with huge pages in
page cache. The most interesting part, mmap(), is not yet there. For now
we split huge page on mmap() attempt.

I can't say that I see whole picture. I'm not sure if I understand locking
model around split_huge_page(). Probably, not.
Andrea, could you check if it looks correct?

Next steps (not necessary in this order):
 - mmap();
 - migration (?);
 - collapse;
 - stats, knobs, etc.;
 - tmpfs/shmem enabling;
 - ...

Kirill A. Shutemov (16):
  block: implement add_bdi_stat()
  mm: implement zero_huge_user_segment and friends
  mm: drop actor argument of do_generic_file_read()
  radix-tree: implement preload for multiple contiguous elements
  thp, mm: basic defines for transparent huge page cache
  thp, mm: rewrite add_to_page_cache_locked() to support huge pages
  thp, mm: rewrite delete_from_page_cache() to support huge pages
  thp, mm: locking tail page is a bug
  thp, mm: handle tail pages in page_cache_get_speculative()
  thp, mm: implement grab_cache_huge_page_write_begin()
  thp, mm: naive support of thp in generic read/write routines
  thp, libfs: initial support of thp in
    simple_read/write_begin/write_end
  thp: handle file pages in split_huge_page()
  thp, mm: truncate support for transparent huge page cache
  thp, mm: split huge page on mmap file page
  ramfs: enable transparent huge page cache

 fs/libfs.c                  |   54 +++++++++---
 fs/ramfs/inode.c            |    6 +-
 include/linux/backing-dev.h |   10 +++
 include/linux/huge_mm.h     |    8 ++
 include/linux/mm.h          |   15 ++++
 include/linux/pagemap.h     |   14 ++-
 include/linux/radix-tree.h  |    3 +
 lib/radix-tree.c            |   32 +++++--
 mm/filemap.c                |  204 +++++++++++++++++++++++++++++++++++--------
 mm/huge_memory.c            |   62 +++++++++++--
 mm/memory.c                 |   22 +++++
 mm/truncate.c               |   12 +++
 12 files changed, 375 insertions(+), 67 deletions(-)

-- 
1.7.10.4

