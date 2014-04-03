Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665AbaDCAnG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 20:43:06 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:39411 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933652AbaDCAnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 20:43:04 -0400
Date: Thu, 3 Apr 2014 08:42:50 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mingo@kernel.org,
        riel@redhat.com, hughd@google.com, mgorman@suse.de,
        torvalds@linux-foundation.org
Subject: [patch]x86: clearing access bit don't flush tlb
Message-ID: <20140403004250.GA14597@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a few acks and resend this patch.

We use access bit to age a page at page reclaim. When clearing pte access bit,
we could skip tlb flush in X86. The side effect is if the pte is in tlb and pte
access bit is unset in page table, when cpu access the page again, cpu will not
set page table pte's access bit. Next time page reclaim will think this hot
page is yong and reclaim it wrongly, but this doesn't corrupt data.

And according to intel manual, tlb has less than 1k entries, which covers < 4M
memory. In today's system, several giga byte memory is normal. After page
reclaim clears pte access bit and before cpu access the page again, it's quite
unlikely this page's pte is still in TLB. And context swich will flush tlb too.
The chance skiping tlb flush to impact page reclaim should be very rare.

Originally (in 2.5 kernel maybe), we didn't do tlb flush after clear access bit.
Hugh added it to fix some ARM and sparc issues. Since I only change this for
x86, there should be no risk.

And in some workloads, TLB flush overhead is very heavy. In my simple
multithread app with a lot of swap to several pcie SSD, removing the tlb flush
gives about 20% ~ 30% swapout speedup.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Acked-by: Rik van Riel <riel@redhat.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Acked-by: Hugh Dickins <hughd@google.com>
---
 arch/x86/mm/pgtable.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

Index: linux/arch/x86/mm/pgtable.c
===================================================================
--- linux.orig/arch/x86/mm/pgtable.c	2014-03-27 05:22:08.572100549 +0800
+++ linux/arch/x86/mm/pgtable.c	2014-03-27 05:46:12.456131121 +0800
@@ -399,13 +399,12 @@ int pmdp_test_and_clear_young(struct vm_
 int ptep_clear_flush_young(struct vm_area_struct *vma,
 			   unsigned long address, pte_t *ptep)
 {
-	int young;
-
-	young = ptep_test_and_clear_young(vma, address, ptep);
-	if (young)
-		flush_tlb_page(vma, address);
-
-	return young;
+	/*
+	 * In X86, clearing access bit without TLB flush doesn't cause data
+	 * corruption. Doing this could cause wrong page aging and so hot pages
+	 * are reclaimed, but the chance should be very rare.
+	 */
+	return ptep_test_and_clear_young(vma, address, ptep);
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
