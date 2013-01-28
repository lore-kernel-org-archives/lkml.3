Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab3A1JYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:24:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:26134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab3A1JXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:23:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,550,1355126400"; 
   d="scan'208";a="282975167"
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
Subject: [PATCH, RFC 15/16] thp, mm: split huge page on mmap file page
Date: Mon, 28 Jan 2013 11:24:27 +0200
Message-Id: <1359365068-10147-16-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1359365068-10147-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

We are not ready to mmap file-backed tranparent huge pages. Let's split
them on mmap() attempt.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index a7331fb..2e08582 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1692,6 +1692,8 @@ retry_find:
 			goto no_cached_page;
 	}
 
+	if (PageTransCompound(page))
+		split_huge_page(page);
 	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
 		page_cache_release(page);
 		return ret | VM_FAULT_RETRY;
-- 
1.7.10.4

