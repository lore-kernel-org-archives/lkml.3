Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3A3BUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:20:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3BUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:20:30 -0500
Date: Tue, 29 Jan 2013 17:20:07 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-c9b3234a6abadaa12684083d39552939baaed1f4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        stefano.stabellini@eu.citrix.com
In-Reply-To: <1359058816-7615-2-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-2-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, mm:
  Fix page table early allocation offset checking
Git-Commit-ID: c9b3234a6abadaa12684083d39552939baaed1f4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:20:13 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c9b3234a6abadaa12684083d39552939baaed1f4
Gitweb:     http://git.kernel.org/tip/c9b3234a6abadaa12684083d39552939baaed1f4
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:42 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:12:23 -0800

x86, mm: Fix page table early allocation offset checking

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
Link: http://lkml.kernel.org/r/1359058816-7615-2-git-send-email-yinghai@kernel.org
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Tested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init.c | 13 ++++++++++++-
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
