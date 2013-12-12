Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3LLLzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:55:46 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab3LLLzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:55:14 -0500
From: Mel Gorman <mgorman@suse.de>
To: Alex Shi <alex.shi@linaro.org>
Cc: H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [PATCH 3/3] x86: mm: Account for the of CPUs that must be flushed during a TLB range flush
Date: Thu, 12 Dec 2013 11:55:09 +0000
Message-Id: <1386849309-22584-4-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1386849309-22584-1-git-send-email-mgorman@suse.de>
References: <1386849309-22584-1-git-send-email-mgorman@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

X86 TLB range flushing uses a balance point to decide if a single global TLB
flush or multiple single page flushes would perform best.  This patch takes into
account how many CPUs must be flushed.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/x86/mm/tlb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 09b8cb8..0cababa 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -217,6 +217,9 @@ void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,
 	act_entries = mm->total_vm > act_entries ? act_entries : mm->total_vm;
 	nr_base_pages = (end - start) >> PAGE_SHIFT;
 
+	/* Take the number of CPUs to range flush into account */
+	nr_base_pages *= cpumask_weight(mm_cpumask(mm));
+
 	/* tlb_flushall_shift is on balance point, details in commit log */
 	if (nr_base_pages > act_entries || has_large_page(mm, start, end)) {
 		count_vm_event(NR_TLB_LOCAL_FLUSH_ALL);
-- 
1.8.4

