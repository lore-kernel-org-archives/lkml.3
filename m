Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaH1Sge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:36:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaH1SgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:36:05 -0400
From: Mel Gorman <mgorman@suse.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Linux-Stable <stable@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 17/97] x86/mm: Clean up inconsistencies when flushing TLB ranges
Date: Thu, 28 Aug 2014 19:34:25 +0100
Message-Id: <1409250945-30874-18-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1409250945-30874-1-git-send-email-mgorman@suse.de>
References: <1409250945-30874-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 15aa368255f249df0b2af630c9487bb5471bd7da upstream.

NR_TLB_LOCAL_FLUSH_ALL is not always accounted for correctly and
the comparison with total_vm is done before taking
tlb_flushall_shift into account.  Clean it up.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Tested-by: Davidlohr Bueso <davidlohr@hp.com>
Reviewed-by: Alex Shi <alex.shi@linaro.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Link: http://lkml.kernel.org/n/tip-Iz5gcahrgskIldvukulzi0hh@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/mm/tlb.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 05446c1..5176526 100644
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
 		count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ALL);
 		local_flush_tlb();
 	} else {
-		if (has_large_page(mm, start, end)) {
-			local_flush_tlb();
-			goto flush_all;
-		}
 		/* flush range by one by one 'invlpg' */
 		for (addr = start; addr < end;	addr += PAGE_SIZE) {
 			count_vm_tlb_event(NR_TLB_LOCAL_FLUSH_ONE);
-- 
1.8.4.5

