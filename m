Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab3ERDAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:00:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab3ERDAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:08 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=aXP8fMTToM0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=7euwk4VhSqgA:10 a=cH6R9-kdAAAA:8 a=ag1SF4gXAAAA:8 a=Nc5lta3nJawr1F_pDB8A:9 a=bt0zGP92IBIA:10 a=1TSTQ8KKaH4A:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021703.235580069@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:18:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jerry Hoemann <jerry.hoemann@hp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 135/136 ] x86/mm: account for PGDIR_SIZE alignment
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0135-x86-mm-account-for-PGDIR_SIZE-alignment.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jerry Hoemann <jerry.hoemann@hp.com>

Patch for -stable.  Function find_early_table_space removed upstream.

Fixes panic in alloc_low_page due to pgt_buf overflow during
init_memory_mapping.

find_early_table_space sizes pgt_buf based upon the size of the
memory being mapped, but it does not take into account the alignment
of the memory.  When the region being mapped spans a 512GB (PGDIR_SIZE)
alignment, a panic from alloc_low_pages occurs.

kernel_physical_mapping_init takes into account PGDIR_SIZE alignment.
This causes an extra call to alloc_low_page to be made.  This extra call
isn't accounted for by find_early_table_space and causes a kernel panic.

Change is to take into account PGDIR_SIZE alignment in find_early_table_space.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/mm/init.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d7aea41..7d7a36d 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -45,11 +45,15 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	int i;
 	unsigned long puds = 0, pmds = 0, ptes = 0, tables;
 	unsigned long start = 0, good_end;
+	unsigned long pgd_extra = 0;
 	phys_addr_t base;
 
 	for (i = 0; i < nr_range; i++) {
 		unsigned long range, extra;
 
+		if ((mr[i].end >> PGDIR_SHIFT) - (mr[i].start >> PGDIR_SHIFT))
+			pgd_extra++;
+
 		range = mr[i].end - mr[i].start;
 		puds += (range + PUD_SIZE - 1) >> PUD_SHIFT;
 
@@ -74,6 +78,7 @@ static void __init find_early_table_space(struct map_range *mr, int nr_range)
 	tables = roundup(puds * sizeof(pud_t), PAGE_SIZE);
 	tables += roundup(pmds * sizeof(pmd_t), PAGE_SIZE);
 	tables += roundup(ptes * sizeof(pte_t), PAGE_SIZE);
+	tables += (pgd_extra * PAGE_SIZE);
 
 #ifdef CONFIG_X86_32
 	/* for fixmap */
-- 
1.7.10.4


