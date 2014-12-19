Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaLSQK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:10:57 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:58235 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaLSQK4 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Fri, 19 Dec 2014 11:10:56 -0500
Message-Id: <54945C1E020000780005114E@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Fri, 19 Dec 2014 16:10:54 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Yinghai Lu" <yinghai@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix step size adjustment during initial memory
 mapping
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old scheme can lead to failure in certain cases - the problem is
that after bumping step_size the next (non-final) iteration is only
guaranteed to make available a memory block the size of what step_size
was before. E.g. for a memory block [0,3004600000) we'd have

iter	start		end		step		amount
1	3004400000	30045fffff	 2M		  2M
2	3004000000	30043fffff	64M		  4M
3	3000000000	3003ffffff	 2G		 64M
4	2000000000	2fffffffff	64G		 64G

Yet to map 64G with 4k pages (as happens e.g. under PV Xen) we need
slightly over 128M, but the first three iterations made only about 70M
available.

The condition (new_mapped_ram_size > mapped_ram_size) for bumping
step_size is just not suitable. Instead we want to bump it when we know
we have enough memory available to cover a block of the new step_size.
And rather than making that condition more complicated than needed,
simply adjust step_size by the largest possible factor we know we can
cover at that point - which is shifting it left by one less than the
difference between page table level shifts. (Interestingly the original
STEP_SIZE_SHIFT definition had a comment hinting at that having been
the intention, just that it should have been PUD_SHIFT-PMD_SHIFT-1
instead of (PUD_SHIFT-PMD_SHIFT)/2, and of course for non-PAE 32-bit we
can't really use these two constants as they're equal there.)

Furthermore the comment in get_new_step_size() didn't get updated
when the bottom-down mapping logic got added. Yet while an overflow
(flushing step_size to zero) of the shift doesn't matter for the
top-down method, it does for bottom-up because round_up(x, 0) = 0,
and an upper range boundary of zero can't really work well.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/init.c |   34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

--- 3.18/arch/x86/mm/init.c
+++ 3.18-x86-init-mem-steps/arch/x86/mm/init.c
@@ -409,20 +409,20 @@ static unsigned long __init init_range_m
 static unsigned long __init get_new_step_size(unsigned long step_size)
 {
 	/*
-	 * Explain why we shift by 5 and why we don't have to worry about
-	 * 'step_size << 5' overflowing:
-	 *
-	 * initial mapped size is PMD_SIZE (2M).
+	 * Initial mapped size is PMD_SIZE (2M).
 	 * We can not set step_size to be PUD_SIZE (1G) yet.
 	 * In worse case, when we cross the 1G boundary, and
 	 * PG_LEVEL_2M is not set, we will need 1+1+512 pages (2M + 8k)
-	 * to map 1G range with PTE. Use 5 as shift for now.
+	 * to map 1G range with PTE. Hence we use one less than the
+	 * difference of page table level shifts.
 	 *
-	 * Don't need to worry about overflow, on 32bit, when step_size
-	 * is 0, round_down() returns 0 for start, and that turns it
-	 * into 0x100000000ULL.
+	 * Don't need to worry about overflow in the top-down case, on 32bit,
+	 * when step_size is 0, round_down() returns 0 for start, and that
+	 * turns it into 0x100000000ULL.
+	 * In the bottom-up case, round_up(x, 0) returns 0 though too, which
+	 * needs to be taken into consideration by the code below.
 	 */
-	return step_size << 5;
+	return step_size << (PMD_SHIFT - PAGE_SHIFT - 1);
 }
 
 /**
@@ -442,7 +442,6 @@ static void __init memory_map_top_down(u
 	unsigned long step_size;
 	unsigned long addr;
 	unsigned long mapped_ram_size = 0;
-	unsigned long new_mapped_ram_size;
 
 	/* xen has big range in reserved near end of ram, skip it at first.*/
 	addr = memblock_find_in_range(map_start, map_end, PMD_SIZE, PMD_SIZE);
@@ -467,14 +466,12 @@ static void __init memory_map_top_down(u
 				start = map_start;
 		} else
 			start = map_start;
-		new_mapped_ram_size = init_range_memory_mapping(start,
+		mapped_ram_size += init_range_memory_mapping(start,
 							last_start);
 		last_start = start;
 		min_pfn_mapped = last_start >> PAGE_SHIFT;
-		/* only increase step_size after big range get mapped */
-		if (new_mapped_ram_size > mapped_ram_size)
+		if (mapped_ram_size >= step_size)
 			step_size = get_new_step_size(step_size);
-		mapped_ram_size += new_mapped_ram_size;
 	}
 
 	if (real_end < map_end)
@@ -495,7 +492,7 @@ static void __init memory_map_top_down(u
 static void __init memory_map_bottom_up(unsigned long map_start,
 					unsigned long map_end)
 {
-	unsigned long next, new_mapped_ram_size, start;
+	unsigned long next, start;
 	unsigned long mapped_ram_size = 0;
 	/* step_size need to be small so pgt_buf from BRK could cover it */
 	unsigned long step_size = PMD_SIZE;
@@ -510,19 +507,18 @@ static void __init memory_map_bottom_up(
 	 * for page table.
 	 */
 	while (start < map_end) {
-		if (map_end - start > step_size) {
+		if (step_size && map_end - start > step_size) {
 			next = round_up(start + 1, step_size);
 			if (next > map_end)
 				next = map_end;
 		} else
 			next = map_end;
 
-		new_mapped_ram_size = init_range_memory_mapping(start, next);
+		mapped_ram_size += init_range_memory_mapping(start, next);
 		start = next;
 
-		if (new_mapped_ram_size > mapped_ram_size)
+		if (mapped_ram_size >= step_size)
 			step_size = get_new_step_size(step_size);
-		mapped_ram_size += new_mapped_ram_size;
 	}
 }
 


