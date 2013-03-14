Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934504Ab3CNRtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:49:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:54841 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab3CNRtM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="302267164"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2, RFC 02/30] mm: implement zero_huge_user_segment and friends
Date: Thu, 14 Mar 2013 19:50:07 +0200
Message-Id: <1363283435-7666-3-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Let's add helpers to clear huge page segment(s). They provide the same
functionallity as zero_user_segment{,s} and zero_user, but for huge
pages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/mm.h |   15 +++++++++++++++
 mm/memory.c        |   26 ++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5b7fd4e..df83ab9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1731,6 +1731,21 @@ extern void dump_page(struct page *page);
 extern void clear_huge_page(struct page *page,
 			    unsigned long addr,
 			    unsigned int pages_per_huge_page);
+extern void zero_huge_user_segment(struct page *page,
+		unsigned start, unsigned end);
+static inline void zero_huge_user_segments(struct page *page,
+		unsigned start1, unsigned end1,
+		unsigned start2, unsigned end2)
+{
+	zero_huge_user_segment(page, start1, end1);
+	zero_huge_user_segment(page, start2, end2);
+}
+static inline void zero_huge_user(struct page *page,
+		unsigned start, unsigned len)
+{
+	zero_huge_user_segment(page, start, start+len);
+}
+
 extern void copy_user_huge_page(struct page *dst, struct page *src,
 				unsigned long addr, struct vm_area_struct *vma,
 				unsigned int pages_per_huge_page);
diff --git a/mm/memory.c b/mm/memory.c
index 494526a..98c25dd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4213,6 +4213,32 @@ void clear_huge_page(struct page *page,
 	}
 }
 
+void zero_huge_user_segment(struct page *page, unsigned start, unsigned end)
+{
+	int i;
+
+	BUG_ON(end < start);
+
+	might_sleep();
+
+	if (start == end)
+		return;
+
+	/* start and end are on the same small page */
+	if ((start & PAGE_MASK) == ((end - 1) & PAGE_MASK))
+		return zero_user_segment(page + (start >> PAGE_SHIFT),
+				start & ~PAGE_MASK,
+				((end - 1) & ~PAGE_MASK) + 1);
+
+	zero_user_segment(page + (start >> PAGE_SHIFT),
+			start & ~PAGE_MASK, PAGE_SIZE);
+	for (i = (start >> PAGE_SHIFT) + 1; i < (end >> PAGE_SHIFT) - 1; i++) {
+		cond_resched();
+		clear_highpage(page + i);
+	}
+	zero_user_segment(page + i, 0, ((end - 1) & ~PAGE_MASK) + 1);
+}
+
 static void copy_user_gigantic_page(struct page *dst, struct page *src,
 				    unsigned long addr,
 				    struct vm_area_struct *vma,
-- 
1.7.10.4

