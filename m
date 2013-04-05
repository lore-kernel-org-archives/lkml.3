Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161749Ab3DEMEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:04:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:64472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161507Ab3DEL6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,414,1363158000"; 
   d="scan'208";a="317363698"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Hansen <dave@sr71.net>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv3, RFC 23/34] thp, mm: split huge page on mmap file page
Date: Fri,  5 Apr 2013 14:59:47 +0300
Message-Id: <1365163198-29726-24-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

We are not ready to mmap file-backed tranparent huge pages. Let's split
them on fault attempt.

Later in the patchset we'll implement mmap() properly and this code path
be used for fallback cases.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 mm/filemap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index 3296f5c..6f0e3be 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1683,6 +1683,8 @@ retry_find:
 			goto no_cached_page;
 	}
 
+	if (PageTransCompound(page))
+		split_huge_page(compound_trans_head(page));
 	if (!lock_page_or_retry(page, vma->vm_mm, vmf->flags)) {
 		page_cache_release(page);
 		return ret | VM_FAULT_RETRY;
-- 
1.7.10.4

