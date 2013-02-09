Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947457Ab3BIAEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 19:04:04 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:54952 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947321Ab3BIAEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 19:04:01 -0500
From: Michel Lespinasse <walken@google.com>
To: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] fixes for large mm_populate() and munlock() operations
Date: Fri,  8 Feb 2013 16:03:54 -0800
Message-Id: <1360368237-26768-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These 3 changes are to improve the handling of large mm_populate and
munlock operations. They apply on top of mmotm (in particular, they
depend on both my prior mm_populate work and Kirill's "thp: avoid
dumping huge zero page" change).

- Patch 1 fixes an integer overflow issue when populating 2^32 pages.
  The nr_pages argument to get_user_pages would overflow, resulting in 0
  pages being processed per iteration. I am proposing to simply convert
  the nr_pages argument to an unsigned long.

- Patch 2 accelerates populating regions with THP pages. get_user_pages()
  can increment the address by a huge page size in this case instead of
  a small page size, and avoid repeated mm->page_table_lock acquisitions.
  This fixes an issue reported by Roman Dubtsov where populating regions
  via mmap MAP_POPULATE was significantly slower than doing so by
  touching pages from userspace.

- Patch 3 is a similar acceleration for the munlock case.

Changes between v1 and v2:

- Andrew accepted patch 1 into his -mm tree but suggested the nr_pages
  argument type should actually be unsigned long; I am sending this as
  a "fix" for the previous patch 1 to be collapsed over the previous one.

- In patch 2, I am adding a separate follow_page_mask() function so that
  the callers to the original follow_page() don't have to be modified to
  ignore the returned page_mask (following another suggestion from Andrew).
  Also the page_mask argument type was changed to unsigned int.

- In patch 3, I similarly changed the page_mask values to unsigned int.

Changes between v2 and v3:

- In patch 1, updated mm/nommu.c to match the updated gup function prototype
  and avoid breaking the nommu build.

- In patch 1, removed incorrect VM_BUG_ON in mm/mlock.c

- In patch 3, fixed munlock_vma_page() to return a page mask as expected
  by munlock_vma_pages_range() instead of a number of pages.

Michel Lespinasse (3):
  mm: use long type for page counts in mm_populate() and get_user_pages()
  mm: accelerate mm_populate() treatment of THP pages
  mm: accelerate munlock() treatment of THP pages

 include/linux/hugetlb.h |  6 +++---
 include/linux/mm.h      | 28 +++++++++++++++++++---------
 mm/hugetlb.c            | 12 ++++++------
 mm/internal.h           |  2 +-
 mm/memory.c             | 49 ++++++++++++++++++++++++++++++++-----------------
 mm/mlock.c              | 38 +++++++++++++++++++++++++-------------
 mm/nommu.c              | 21 ++++++++++++---------
 7 files changed, 98 insertions(+), 58 deletions(-)

-- 
1.8.1
