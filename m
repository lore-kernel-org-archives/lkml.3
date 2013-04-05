Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161801Ab3DEMFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 08:05:54 -0400
Received: from mga03.intel.com ([143.182.124.21]:62677 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161509Ab3DEL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:58:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,414,1363158000"; 
   d="scan'208";a="223209001"
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
Subject: [PATCHv3, RFC 11/34] mm: trace filemap: dump page order
Date: Fri,  5 Apr 2013 14:59:35 +0300
Message-Id: <1365163198-29726-12-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Dump page order to trace to be able to distinguish between small page
and huge page in page cache.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/trace/events/filemap.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/trace/events/filemap.h b/include/trace/events/filemap.h
index 0421f49..7e14b13 100644
--- a/include/trace/events/filemap.h
+++ b/include/trace/events/filemap.h
@@ -21,6 +21,7 @@ DECLARE_EVENT_CLASS(mm_filemap_op_page_cache,
 		__field(struct page *, page)
 		__field(unsigned long, i_ino)
 		__field(unsigned long, index)
+		__field(int, order)
 		__field(dev_t, s_dev)
 	),
 
@@ -28,18 +29,20 @@ DECLARE_EVENT_CLASS(mm_filemap_op_page_cache,
 		__entry->page = page;
 		__entry->i_ino = page->mapping->host->i_ino;
 		__entry->index = page->index;
+		__entry->order = compound_order(page);
 		if (page->mapping->host->i_sb)
 			__entry->s_dev = page->mapping->host->i_sb->s_dev;
 		else
 			__entry->s_dev = page->mapping->host->i_rdev;
 	),
 
-	TP_printk("dev %d:%d ino %lx page=%p pfn=%lu ofs=%lu",
+	TP_printk("dev %d:%d ino %lx page=%p pfn=%lu ofs=%lu order=%d",
 		MAJOR(__entry->s_dev), MINOR(__entry->s_dev),
 		__entry->i_ino,
 		__entry->page,
 		page_to_pfn(__entry->page),
-		__entry->index << PAGE_SHIFT)
+		__entry->index << PAGE_SHIFT,
+		__entry->order)
 );
 
 DEFINE_EVENT(mm_filemap_op_page_cache, mm_filemap_delete_from_page_cache,
-- 
1.7.10.4

