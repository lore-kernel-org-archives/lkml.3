Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbaBEUDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:03:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:54120 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbaBEUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:03:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 003/213] Revert "percpu: fix chunk range calculation"
Date: Wed, 5 Feb 2014 14:59:18 -0500
Message-ID: <1391630568-49251-4-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

This reverts commit 264266e6897dd81c894d1c5cbd90b133707b32f3.

The backport had dependencies on other mm/percpu.c restructurings,
like those in commit 020ec6537aa65c18e9084c568d7b94727f2026fd
("percpu: factor out pcpu_addr_in_first/reserved_chunk() and update
per_cpu_ptr_to_phys()").  Rather than drag in more changes, we simply
revert the incomplete backport.

Reported-by: George G. Davis <george_davis@mentor.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 mm/percpu.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 83523d9a351b..558543b33b52 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -111,9 +111,9 @@ static int pcpu_atom_size __read_mostly;
 static int pcpu_nr_slots __read_mostly;
 static size_t pcpu_chunk_struct_size __read_mostly;
 
-/* cpus with the lowest and highest unit addresses */
-static unsigned int pcpu_low_unit_cpu __read_mostly;
-static unsigned int pcpu_high_unit_cpu __read_mostly;
+/* cpus with the lowest and highest unit numbers */
+static unsigned int pcpu_first_unit_cpu __read_mostly;
+static unsigned int pcpu_last_unit_cpu __read_mostly;
 
 /* the address of the first chunk which starts with the kernel static area */
 void *pcpu_base_addr __read_mostly;
@@ -747,8 +747,8 @@ static void pcpu_pre_unmap_flush(struct pcpu_chunk *chunk,
 				 int page_start, int page_end)
 {
 	flush_cache_vunmap(
-		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
-		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
 }
 
 static void __pcpu_unmap_pages(unsigned long addr, int nr_pages)
@@ -810,8 +810,8 @@ static void pcpu_post_unmap_tlb_flush(struct pcpu_chunk *chunk,
 				      int page_start, int page_end)
 {
 	flush_tlb_kernel_range(
-		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
-		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
 }
 
 static int __pcpu_map_pages(unsigned long addr, struct page **pages,
@@ -888,8 +888,8 @@ static void pcpu_post_map_flush(struct pcpu_chunk *chunk,
 				int page_start, int page_end)
 {
 	flush_cache_vmap(
-		pcpu_chunk_addr(chunk, pcpu_low_unit_cpu, page_start),
-		pcpu_chunk_addr(chunk, pcpu_high_unit_cpu, page_end));
+		pcpu_chunk_addr(chunk, pcpu_first_unit_cpu, page_start),
+		pcpu_chunk_addr(chunk, pcpu_last_unit_cpu, page_end));
 }
 
 /**
@@ -1345,19 +1345,19 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
 	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
 	bool in_first_chunk = false;
-	unsigned long first_low, first_high;
+	unsigned long first_start, first_end;
 	unsigned int cpu;
 
 	/*
-	 * The following test on unit_low/high isn't strictly
+	 * The following test on first_start/end isn't strictly
 	 * necessary but will speed up lookups of addresses which
 	 * aren't in the first chunk.
 	 */
-	first_low = pcpu_chunk_addr(pcpu_first_chunk, pcpu_low_unit_cpu, 0);
-	first_high = pcpu_chunk_addr(pcpu_first_chunk, pcpu_high_unit_cpu,
-				     pcpu_unit_pages);
-	if ((unsigned long)addr >= first_low &&
-	    (unsigned long)addr < first_high) {
+	first_start = pcpu_chunk_addr(pcpu_first_chunk, pcpu_first_unit_cpu, 0);
+	first_end = pcpu_chunk_addr(pcpu_first_chunk, pcpu_last_unit_cpu,
+				    pcpu_unit_pages);
+	if ((unsigned long)addr >= first_start &&
+	    (unsigned long)addr < first_end) {
 		for_each_possible_cpu(cpu) {
 			void *start = per_cpu_ptr(base, cpu);
 
@@ -1754,9 +1754,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
 		unit_map[cpu] = UINT_MAX;
-
-	pcpu_low_unit_cpu = NR_CPUS;
-	pcpu_high_unit_cpu = NR_CPUS;
+	pcpu_first_unit_cpu = NR_CPUS;
 
 	for (group = 0, unit = 0; group < ai->nr_groups; group++, unit += i) {
 		const struct pcpu_group_info *gi = &ai->groups[group];
@@ -1776,13 +1774,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 			unit_map[cpu] = unit + i;
 			unit_off[cpu] = gi->base_offset + i * ai->unit_size;
 
-			/* determine low/high unit_cpu */
-			if (pcpu_low_unit_cpu == NR_CPUS ||
-			    unit_off[cpu] < unit_off[pcpu_low_unit_cpu])
-				pcpu_low_unit_cpu = cpu;
-			if (pcpu_high_unit_cpu == NR_CPUS ||
-			    unit_off[cpu] > unit_off[pcpu_high_unit_cpu])
-				pcpu_high_unit_cpu = cpu;
+			if (pcpu_first_unit_cpu == NR_CPUS)
+				pcpu_first_unit_cpu = cpu;
+			pcpu_last_unit_cpu = cpu;
 		}
 	}
 	pcpu_nr_units = unit;
-- 
1.8.5.2

