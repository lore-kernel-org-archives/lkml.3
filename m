Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab3AXUVv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:21:51 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49749 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3AXUVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:21:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/35] x86, mm: Fix page table early allocation offset checking
Date: Thu, 24 Jan 2013 12:19:42 -0800
Message-Id: <1359058816-7615-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During debugging loading kernel above 4G, found that one page is not used
in pre-allocated BRK area for early page allocation.
pgt_buf_top is address that can not be used, so should check if that new
end is above that top, otherwise last page will not be used.

Fix that checking and also add print out for allocation from pre-allocated
BRK area to catch possible bugs later.

But after we get back that page for pgt, it tiggers one bug in pgt allocation
with xen: We need to avoid to use page as pgt to map range that is
overlapping with that pgt page.

Add checking about overlapping, when it happens, use memblock allocation
instead.  That fixes crash on Xen PV guest with 2G that Stefan found.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Tested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/mm/init.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6f85de8..78d1ef3 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -25,6 +25,8 @@ static unsigned long __initdata pgt_buf_top;
 
 static unsigned long min_pfn_mapped;
 
+static bool __initdata can_use_brk_pgt = true;
+
 /*
  * Pages returned are already directly mapped.
  *
@@ -47,7 +49,7 @@ __ref void *alloc_low_pages(unsigned int num)
 						__GFP_ZERO, order);
 	}
 
-	if ((pgt_buf_end + num) >= pgt_buf_top) {
+	if ((pgt_buf_end + num) > pgt_buf_top || !can_use_brk_pgt) {
 		unsigned long ret;
 		if (min_pfn_mapped >= max_pfn_mapped)
 			panic("alloc_low_page: ran out of memory");
@@ -61,6 +63,8 @@ __ref void *alloc_low_pages(unsigned int num)
 	} else {
 		pfn = pgt_buf_end;
 		pgt_buf_end += num;
+		printk(KERN_DEBUG "BRK [%#010lx, %#010lx] PGTABLE\n",
+			pfn << PAGE_SHIFT, (pgt_buf_end << PAGE_SHIFT) - 1);
 	}
 
 	for (i = 0; i < num; i++) {
@@ -370,8 +374,15 @@ static unsigned long __init init_range_memory_mapping(
 		if (start >= end)
 			continue;
 
+		/*
+		 * if it is overlapping with brk pgt, we need to
+		 * alloc pgt buf from memblock instead.
+		 */
+		can_use_brk_pgt = max(start, (u64)pgt_buf_end<<PAGE_SHIFT) >=
+				    min(end, (u64)pgt_buf_top<<PAGE_SHIFT);
 		init_memory_mapping(start, end);
 		mapped_ram_size += end - start;
+		can_use_brk_pgt = true;
 	}
 
 	return mapped_ram_size;
-- 
1.7.10.4

