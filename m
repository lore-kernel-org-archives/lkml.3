Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab3F2BCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 21:02:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50878 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3F2BCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 21:02:39 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tejun Heo <tj@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: [PATCH] WIP: HACK: LPAE, BOOTMEM and NO_BOOTMEM
Date: Fri, 28 Jun 2013 21:01:03 -0400
Message-ID: <1372467663-31425-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** The initial solution.
The easier solution is to update the bootmem APIs semantics to use
phys_addr_t which makes things works but needs to update almost
all bootmem API semantics and the changes were too intrusive. Many suggested
to use memblock.

** NO_BOOTMEM is suppose to be memblock

- Initially started with the assumption that NO_BOOTMEM can work easily on ARM.
- It does actually work on 32 bit machines nicely..
- But doesn't for LPAE for obvious reason of bootmem.h API signatures truncates
the addresses.

** So I tried to remove BOOTMEM and NO_BOOTMEM dependency for ARM (read 32 bit arch)

- Started replacing bootmem_* usage with dirty hacked memblock based API.
This can be letter wrapped with only needed parameter export.
- Couple of ARM related patch-ups were fine but soon realized that we need
to patch generic kernel multiple places .. So decided to stop and check again
These changes are becoming too much...

So I need to hear back again from folks who has been involved in the discussion
in past. Am sending the email with changes just to explain the idea and issues
o.w patch as such is crappy.

Thanks for help

Cc: Tejun Heo <tj@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
---
 arch/arm/kernel/devtree.c |    2 +-
 arch/arm/kernel/setup.c   |    2 +-
 include/linux/bootmem.h   |    2 ++
 init/main.c               |    4 ++--
 mm/nobootmem.c            |    2 +-
 mm/percpu.c               |    4 ++--
 6 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 5af04f6..720b9f9 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -33,7 +33,7 @@ void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 
 void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 {
-	return alloc_bootmem_align(size, align);
+	return __alloc_memory_core_early(MAX_NUMNODES, size, align, 0, ARCH_LOW_ADDRESS_LIMIT);
 }
 
 void __init arm_dt_memblock_reserve(void)
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 385131c..57698ed 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -619,7 +619,7 @@ static void __init request_standard_resources(struct machine_desc *mdesc)
 	kernel_data.end     = virt_to_phys(_end - 1);
 
 	for_each_memblock(memory, region) {
-		res = alloc_bootmem_low(sizeof(*res));
+		res = __alloc_memory_core_early(MAX_NUMNODES, sizeof(*res), SMP_CACHE_BYTES, 0, ARCH_LOW_ADDRESS_LIMIT);
 		res->name  = "System RAM";
 		res->start = __pfn_to_phys(memblock_region_memory_base_pfn(region));
 		res->end = __pfn_to_phys(memblock_region_memory_end_pfn(region)) - 1;
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 5f0b0e1..a916df6 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -142,6 +142,8 @@ extern void *__alloc_bootmem_low_node(pg_data_t *pgdat,
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
 
+extern void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+					u64 goal, u64 limit);
 #ifdef CONFIG_HAVE_ARCH_ALLOC_REMAP
 extern void *alloc_remap(int nid, unsigned long size);
 #else
diff --git a/init/main.c b/init/main.c
index 9484f4b..53c488d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -344,8 +344,8 @@ static inline void smp_prepare_cpus(unsigned int maxcpus) { }
  */
 static void __init setup_command_line(char *command_line)
 {
-	saved_command_line = alloc_bootmem(strlen (boot_command_line)+1);
-	static_command_line = alloc_bootmem(strlen (command_line)+1);
+	saved_command_line =__alloc_memory_core_early(MAX_NUMNODES, (strlen (boot_command_line)+1), SMP_CACHE_BYTES, 0, ARCH_LOW_ADDRESS_LIMIT);
+	static_command_line =__alloc_memory_core_early(MAX_NUMNODES, (strlen (command_line)+1), SMP_CACHE_BYTES, 0, ARCH_LOW_ADDRESS_LIMIT);
 	strcpy (saved_command_line, boot_command_line);
 	strcpy (static_command_line, command_line);
 }
diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index bdd3fa2..43a2f95 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -32,7 +32,7 @@ unsigned long max_low_pfn;
 unsigned long min_low_pfn;
 unsigned long max_pfn;
 
-static void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
+void * __init __alloc_memory_core_early(int nid, u64 size, u64 align,
 					u64 goal, u64 limit)
 {
 	void *ptr;
diff --git a/mm/percpu.c b/mm/percpu.c
index 8c8e08f..30cd3df 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1063,7 +1063,7 @@ struct pcpu_alloc_info * __init pcpu_alloc_alloc_info(int nr_groups,
 			  __alignof__(ai->groups[0].cpu_map[0]));
 	ai_size = base_size + nr_units * sizeof(ai->groups[0].cpu_map[0]);
 
-	ptr = alloc_bootmem_nopanic(PFN_ALIGN(ai_size));
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, PFN_ALIGN(ai_size), SMP_CACHE_BYTES, 0, ARCH_LOW_ADDRESS_LIMIT);
 	if (!ptr)
 		return NULL;
 	ai = ptr;
@@ -1895,7 +1895,7 @@ void __init setup_per_cpu_areas(void)
 	void *fc;
 
 	ai = pcpu_alloc_alloc_info(1, 1);
-	fc = __alloc_bootmem(unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	fc = __alloc_memory_core_early(MAX_NUMNODES, unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS), ARCH_LOW_ADDRESS_LIMIT);
 	if (!ai || !fc)
 		panic("Failed to allocate memory for percpu areas.");
 	/* kmemleak tracks the percpu allocations separately */
-- 
1.7.9.5

