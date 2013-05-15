Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759846Ab3EOTNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:13:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:58865 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759756Ab3EOTNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:13:22 -0400
Date: Wed, 15 May 2013 21:13:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: [GIT pull] x86 fixes for 3.10
Message-ID: <alpine.LFD.2.02.1305152111120.1388@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

Content:

	* Fix for a CPU hot-add deadlock in microcode update code

	* Fix for idle consolidation fallout 

	* Documentation update for initial kernel direct mapping

Thanks,

	tglx

------------------>
Konrad Rzeszutek Wilk (1):
      x86/microcode: Add local mutex to fix physical CPU hot-add deadlock

Thomas Gleixner (1):
      x86: Fix idle consolidation fallout

Zhang Yanfei (1):
      x86/mm: Add missing comments for initial kernel direct mapping


 arch/x86/kernel/microcode_intel_early.c |    5 +++--
 arch/x86/kernel/process.c               |    5 ++---
 arch/x86/mm/init.c                      |   19 ++++++++++++++++++-
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index d893e8e..2e9e128 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -487,6 +487,7 @@ static inline void show_saved_mc(void)
 #endif
 
 #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
+static DEFINE_MUTEX(x86_cpu_microcode_mutex);
 /*
  * Save this mc into mc_saved_data. So it will be loaded early when a CPU is
  * hot added or resumes.
@@ -507,7 +508,7 @@ int save_mc_for_early(u8 *mc)
 	 * Hold hotplug lock so mc_saved_data is not accessed by a CPU in
 	 * hotplug.
 	 */
-	cpu_hotplug_driver_lock();
+	mutex_lock(&x86_cpu_microcode_mutex);
 
 	mc_saved_count_init = mc_saved_data.mc_saved_count;
 	mc_saved_count = mc_saved_data.mc_saved_count;
@@ -544,7 +545,7 @@ int save_mc_for_early(u8 *mc)
 	}
 
 out:
-	cpu_hotplug_driver_unlock();
+	mutex_unlock(&x86_cpu_microcode_mutex);
 
 	return ret;
 }
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 607af0d..4e7a37f 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -312,6 +312,8 @@ void arch_cpu_idle(void)
 {
 	if (cpuidle_idle_call())
 		x86_idle();
+	else
+		local_irq_enable();
 }
 
 /*
@@ -368,9 +370,6 @@ void amd_e400_remove_cpu(int cpu)
  */
 static void amd_e400_idle(void)
 {
-	if (need_resched())
-		return;
-
 	if (!amd_e400_c1e_detected) {
 		u32 lo, hi;
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fdc5dca..eaac174 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -359,7 +359,17 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 }
 
 /*
- * would have hole in the middle or ends, and only ram parts will be mapped.
+ * We need to iterate through the E820 memory map and create direct mappings
+ * for only E820_RAM and E820_KERN_RESERVED regions. We cannot simply
+ * create direct mappings for all pfns from [0 to max_low_pfn) and
+ * [4GB to max_pfn) because of possible memory holes in high addresses
+ * that cannot be marked as UC by fixed/variable range MTRRs.
+ * Depending on the alignment of E820 ranges, this may possibly result
+ * in using smaller size (i.e. 4K instead of 2M or 1G) page tables.
+ *
+ * init_mem_mapping() calls init_range_memory_mapping() with big range.
+ * That range would have hole in the middle or ends, and only ram parts
+ * will be mapped in init_range_memory_mapping().
  */
 static unsigned long __init init_range_memory_mapping(
 					   unsigned long r_start,
@@ -419,6 +429,13 @@ void __init init_mem_mapping(void)
 	max_pfn_mapped = 0; /* will get exact value next */
 	min_pfn_mapped = real_end >> PAGE_SHIFT;
 	last_start = start = real_end;
+
+	/*
+	 * We start from the top (end of memory) and go to the bottom.
+	 * The memblock_find_in_range() gets us a block of RAM from the
+	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) used as new pages
+	 * for page table.
+	 */
 	while (last_start > ISA_END_ADDRESS) {
 		if (last_start > step_size) {
 			start = round_down(last_start - 1, step_size);
