Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab3CNR5a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 13:57:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:49929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab3CNRtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 13:49:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,845,1355126400"; 
   d="scan'208";a="302267315"
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
Subject: [PATCHv2, RFC 11/30] thp, mm: handle tail pages in page_cache_get_speculative()
Date: Thu, 14 Mar 2013 19:50:16 +0200
Message-Id: <1363283435-7666-12-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1363283435-7666-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

For tail page we call __get_page_tail(). It has the same semantics, but
for tail page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/pagemap.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3521b0d..408c4e3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -159,6 +159,9 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
+	if (unlikely(PageTail(page)))
+		return __get_page_tail(page);
+
 #ifdef CONFIG_TINY_RCU
 # ifdef CONFIG_PREEMPT_COUNT
 	VM_BUG_ON(!in_atomic());
@@ -185,7 +188,6 @@ static inline int page_cache_get_speculative(struct page *page)
 		return 0;
 	}
 #endif
-	VM_BUG_ON(PageTail(page));
 
 	return 1;
 }
-- 
1.7.10.4

