Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161591Ab3DEL60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:58:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:14854 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161483Ab3DEL6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:58:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,414,1363158000"; 
   d="scan'208";a="317363658"
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
Subject: [PATCHv3, RFC 08/34] thp, mm: introduce mapping_can_have_hugepages() predicate
Date: Fri,  5 Apr 2013 14:59:32 +0300
Message-Id: <1365163198-29726-9-git-send-email-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
References: <1365163198-29726-1-git-send-email-kirill.shutemov@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Returns true if mapping can have huge pages. Just check for __GFP_COMP
in gfp mask of the mapping for now.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 include/linux/pagemap.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index e3dea75..56debde 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -84,6 +84,17 @@ static inline void mapping_set_gfp_mask(struct address_space *m, gfp_t mask)
 				(__force unsigned long)mask;
 }
 
+static inline bool mapping_can_have_hugepages(struct address_space *m)
+{
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		gfp_t gfp_mask = mapping_gfp_mask(m);
+		/* __GFP_COMP is key part of GFP_TRANSHUGE */
+		return !!(gfp_mask & __GFP_COMP);
+	}
+
+	return false;
+}
+
 /*
  * The page cache can done in larger chunks than
  * one page, because it allows for more efficient
-- 
1.7.10.4

