Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758981Ab3E3SuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 14:50:11 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58178 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997Ab3E3SuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 14:50:06 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Hansen <dave.hansen@intel.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH] sparsemem: BUILD_BUG_ON when sizeof mem_section is non-power-of-2
Date: Thu, 30 May 2013 11:40:48 -0700
Message-Id: <1369939248-10006-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <51A78EC4.4080703@intel.com>
References: <51A78EC4.4080703@intel.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053018-5806-0000-0000-0000216F4130
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of leaving a hidden trap for the next person who comes along and
wants to add something to mem_section, add a big fat warning about it
needing to be a power-of-2, and insert a BUILD_BUG_ON() in sparse_init()
to catch mistakes.

Right now non-power-of-2 mem_sections cause a number of WARNs at boot
(which don't clearly point to the size of mem_section as an issue), but
the system limps on (temporarily, at least).

This is based upon Dave Hansen's earlier RFC where he ran into the same
issue:
	"sparsemem: fix boot when SECTIONS_PER_ROOT is not power-of-2"
	http://lkml.indiana.edu/hypermail/linux/kernel/1205.2/03077.html

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---

Dave: Consider it resurrected.

---

 include/linux/mmzone.h | 4 ++++
 mm/sparse.c            | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 131989a..88e23f3 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1127,6 +1127,10 @@ struct mem_section {
 	struct page_cgroup *page_cgroup;
 	unsigned long pad;
 #endif
+	/*
+	 * WARNING: mem_section must be a power-of-2 in size for the
+	 * calculation and use of SECTION_ROOT_MASK to make sense.
+	 */
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
diff --git a/mm/sparse.c b/mm/sparse.c
index 1c91f0d3..3194ec4 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -481,6 +481,9 @@ void __init sparse_init(void)
 	struct page **map_map;
 #endif
 
+	/* see include/linux/mmzone.h 'struct mem_section' definition */
+	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
+
 	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
 	set_pageblock_order();
 
-- 
1.8.3

