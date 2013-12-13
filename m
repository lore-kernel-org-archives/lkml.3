Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab3LMUC0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:02:26 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46289 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607Ab3LMUBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:01:14 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>
Subject: [PATCH 1/4] x86: mm: Clean up inconsistencies when flushing TLB ranges
Date: Fri, 13 Dec 2013 20:01:07 +0000
Message-Id: <1386964870-6690-2-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386964870-6690-1-git-send-email-mgorman@suse.de>
References: <1386964870-6690-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NR_TLB_LOCAL_FLUSH_ALL is not always accounted for correctly and the
comparison with total_vm is done before taking tlb_flushall_shift into
account. Clean it up.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Alex Shi <alex.shi@linaro.org>
---
 arch/x86/mm/tlb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index ae699b3..09b8cb8 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -189,6 +189,7 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 {
 	unsigned long addr;
 	unsigned act_entries, tlb_entries = 0;
+	unsigned long nr_base_pages;
 
 	preempt_disable();
 	if (current->active_mm != mm)
@@ -210,18 +211,17 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 		tlb_entries = tlb_lli_4k[ENTRIES];
 	else
 		tlb_entries = tlb_lld_4k[ENTRIES];
+
 	/* Assume all of TLB entries was occupied by this task */
-	act_entries = mm->total_vm > tlb_entries ? tlb_entries : mm->total_vm;
+	act_entries = tlb_entries >> tlb_flushall_shift;
+	act_entries = mm->total_vm > act_entries ? act_entries : mm->total_vm;
+	nr_base_pages = (end - start) >> PAGE_SHIFT;
 
 	/* tlb_flushall_shift is on balance point, details in commit log */
-	if ((end - start) >> PAGE_SHIFT > act_entries >> tlb_flushall_shift) {
+	if (nr_base_pages > act_entries || has_large_page(mm, start, end)) {
 		count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
-		if (has_large_page(mm, start, end)) {
-			local_flush_tlb();
-			goto flush_all;
-		}
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
 			count_vm_event(NR_TLB_LOCAL_FLUSH_ONE);
-- 
1.8.4

