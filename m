Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaAYOZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:25:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52540 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaAYOZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:25:39 -0500
Date: Sat, 25 Jan 2014 06:24:58 -0800
From: tip-bot for Mel Gorman <tipbot@zytor.com>
Message-ID: <tip-15aa368255f249df0b2af630c9487bb5471bd7da@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, hughd@google.com,
        alex.shi@linaro.org, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, hughd@google.com,
        alex.shi@linaro.org, riel@redhat.com, akpm@linux-foundation.org,
        mgorman@suse.de, tglx@linutronix.de, davidlohr@hp.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  Clean up inconsistencies when flushing TLB ranges
Git-Commit-ID: 15aa368255f249df0b2af630c9487bb5471bd7da
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:25:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  15aa368255f249df0b2af630c9487bb5471bd7da
Gitweb:     http://git.kernel.org/tip/15aa368255f249df0b2af630c9487bb5471bd7da
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Tue, 21 Jan 2014 14:33:18 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 25 Jan 2014 09:10:42 +0100

x86/mm: Clean up inconsistencies when flushing TLB ranges

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
