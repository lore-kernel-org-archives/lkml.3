Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab3GQTlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:41:22 -0400
Received: from mail-qa0-f73.google.com ([209.85.216.73]:50265 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab3GQTlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:41:20 -0400
From: Andrew Hunter <ahh@google.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        Andrew Hunter <ahh@google.com>
Subject: [RFC] [PATCH] x86: avoid per_cpu for APIC id tables
Date: Wed, 17 Jul 2013 12:41:13 -0700
Message-Id: <1374090073-1957-1-git-send-email-ahh@google.com>
X-Mailer: git-send-email 1.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I have a patch (following) that modifies handling of APIC id tables,
trading a small amount of space in the (NR_CPUS - nr_cpu_ids) >> 0 case for
faster accesses and slightly better cache layout (as APIC ids are mostly used
cross-cpu.)  I'm not an APIC expert so I'd appreciate some eyes on this, but
it shouldn't change any behavior whatsoever.  Thoughts? (We're likely to merge
this internally even if upstream judges the space loss too much of a cost, so
I'd like to know if there's some other problem I've missed that this causes.)

I've tested this cursorily in most of our internal configurations but not in
any particularly exotic hardware/config.


>From e6bf354c05d98651e8c27f96582f0ab56992e58a Mon Sep 17 00:00:00 2001
From: Andrew Hunter <ahh@google.com>
Date: Tue, 16 Jul 2013 16:50:36 -0700
Subject: [PATCH] x86: avoid per_cpu for APIC id tables

DEFINE_PER_CPU(var) and friends go to lengths to arrange all of cpu
i's per cpu variables as contiguous with each other; this requires a
double indirection to reference a variable.

For data that is logically per-cpu but

a) rarely modified
b) commonly accessed from other CPUs

this is bad: no writes means we don't have to worry about cache ping
pong, and cross-CPU access means there's no cache savings from not
pulling in remote entries.  (Actually, it's worse than "no" cache
savings: instead of one cache line containing 32 useful APIC ids, it
will contain 3 useful APIC ids and much other percpu data from the
remote CPU we don't want.)  It's also slower to access, due to the
indirection.

So instead use a flat array for APIC ids, most commonly used for IPIs
and the like.  This makes a measurable improvement (up to 10%) in some
benchmarks that heavily stress remote wakeups.

The one disadvantage is that we waste 8 bytes per unused CPU (NR_CPUS
- actual). But this is a fairly small amount of memory for reasonable
values of NR_CPUS.

Tested: builds and boots, runs a suite of wakeup-intensive test without failure.

---
 arch/x86/include/asm/apic.h           |  5 ++---
 arch/x86/include/asm/smp.h            |  8 +++----
 arch/x86/kernel/acpi/boot.c           |  4 ++--
 arch/x86/kernel/apic/apic.c           | 42 ++++++++++++-----------------------
 arch/x86/kernel/apic/apic_numachip.c  |  2 +-
 arch/x86/kernel/apic/bigsmp_32.c      | 11 +++++----
 arch/x86/kernel/apic/es7000_32.c      | 12 +++++-----
 arch/x86/kernel/apic/ipi.c            | 14 ++++++------
 arch/x86/kernel/apic/numaq_32.c       |  2 +-
 arch/x86/kernel/apic/summit_32.c      | 12 +++++-----
 arch/x86/kernel/apic/x2apic_cluster.c | 12 +++++-----
 arch/x86/kernel/apic/x2apic_phys.c    |  2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c    |  4 ++--
 arch/x86/kernel/setup_percpu.c        | 17 --------------
 arch/x86/kernel/smpboot.c             |  2 +-
 arch/x86/mm/numa.c                    |  5 +----
 arch/x86/platform/uv/tlb_uv.c         |  2 +-
 17 files changed, 60 insertions(+), 96 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f8119b5..9a80f49 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -547,8 +547,7 @@ static inline const struct cpumask *online_target_cpus(void)
 	return cpu_online_mask;
 }
 
-DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
-
+extern u16 x86_bios_cpu_apicid[NR_CPUS];
 
 static inline unsigned int read_apic_id(void)
 {
@@ -660,7 +659,7 @@ static inline void default_ioapic_phys_id_map(physid_mask_t *phys_map, physid_ma
 static inline int __default_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids && cpu_present(mps_cpu))
-		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
+		return (int)x86_bios_cpu_apicid[mps_cpu];
 	else
 		return BAD_APICID;
 }
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index b073aae..25deeac0 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -53,10 +53,10 @@ static inline struct cpumask *cpu_llc_shared_mask(int cpu)
 	return per_cpu(cpu_llc_shared_map, cpu);
 }
 
-DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid);
-DECLARE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid);
+extern u16 x86_cpu_to_apicid[NR_CPUS];
+extern u16 x86_bios_cpu_apicid[NR_CPUS];
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
-DECLARE_EARLY_PER_CPU_READ_MOSTLY(int, x86_cpu_to_logical_apicid);
+extern u16 x86_cpu_to_logical_apicid[NR_CPUS];
 #endif
 
 /* Static state in head.S used to set up a CPU */
@@ -168,7 +168,7 @@ void x86_idle_thread_init(unsigned int cpu, struct task_struct *idle);
 
 void smp_store_boot_cpu_info(void);
 void smp_store_cpu_info(int id);
-#define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
+#define cpu_physical_id(cpu)	x86_cpu_to_apicid[cpu]
 
 #else /* !CONFIG_SMP */
 #define wbinvd_on_cpu(cpu)     wbinvd()
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d81a972..5bae841 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -704,10 +704,10 @@ EXPORT_SYMBOL(acpi_map_lsapic);
 int acpi_unmap_lsapic(int cpu)
 {
 #ifdef CONFIG_ACPI_NUMA
-	set_apicid_to_node(per_cpu(x86_cpu_to_apicid, cpu), NUMA_NO_NODE);
+	set_apicid_to_node(x86_cpu_to_apicid[cpu], NUMA_NO_NODE);
 #endif
 
-	per_cpu(x86_cpu_to_apicid, cpu) = -1;
+	x86_cpu_to_apicid[cpu] = -1;
 	set_cpu_present(cpu, false);
 	num_processors--;
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 99663b5..d5e6a66 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -76,20 +76,17 @@ physid_mask_t phys_cpu_present_map;
 /*
  * Map cpu index to physical APIC ID
  */
-DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid, BAD_APICID);
-DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_bios_cpu_apicid, BAD_APICID);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_cpu_to_apicid);
-EXPORT_EARLY_PER_CPU_SYMBOL(x86_bios_cpu_apicid);
-
+u16 x86_cpu_to_apicid[NR_CPUS];
+u16 x86_bios_cpu_apicid[NR_CPUS];
 #ifdef CONFIG_X86_32
 
 /*
  * On x86_32, the mapping between cpu and logical apicid may vary
- * depending on apic in use.  The following early percpu variable is
- * used for the mapping.  This is where the behaviors of x86_64 and 32
- * actually diverge.  Let's keep it ugly for now.
+ * depending on apic in use.  The following variable is used for the
+ * mapping.  This is where the behaviors of x86_64 and 32 actually
+ * diverge.  Let's keep it ugly for now.
  */
-DEFINE_EARLY_PER_CPU_READ_MOSTLY(int, x86_cpu_to_logical_apicid, BAD_APICID);
+int x86_cpu_to_logical_apicid[NR_CPUS] = { [0 ... NR_CPUS-1] = BAD_APICID };
 
 /* Local APIC was disabled by the BIOS and enabled by the kernel */
 static int enabled_via_apicbase;
@@ -1322,10 +1319,10 @@ void __cpuinit setup_local_APIC(void)
 	 * initialized during get_smp_config(), make sure it matches the
 	 * actual value.
 	 */
-	i = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	i = x86_cpu_to_logical_apicid[cpu];
 	WARN_ON(i != BAD_APICID && i != logical_smp_processor_id());
 	/* always use the value from LDR */
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+	x86_cpu_to_logical_apicid[cpu] =
 		logical_smp_processor_id();
 
 	/*
@@ -1336,7 +1333,7 @@ void __cpuinit setup_local_APIC(void)
 	 * proper NUMA affinity.
 	 */
 	if (apic->x86_32_numa_cpu_node)
-		set_apicid_to_node(early_per_cpu(x86_cpu_to_apicid, cpu),
+		set_apicid_to_node(x86_cpu_to_apicid[cpu],
 				   apic->x86_32_numa_cpu_node(cpu));
 #endif
 
@@ -2174,12 +2171,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
 		max_physical_apicid = apicid;
 
 #if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
-	early_per_cpu(x86_cpu_to_apicid, cpu) = apicid;
-	early_per_cpu(x86_bios_cpu_apicid, cpu) = apicid;
+	x86_cpu_to_apicid[cpu] = apicid;
+	x86_bios_cpu_apicid[cpu] = apicid;
 #endif
 #ifdef CONFIG_X86_32
-	early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
-		apic->x86_32_early_logical_apicid(cpu);
+	x86_cpu_to_logical_apicid[cpu] = apic->x86_32_early_logical_apicid(cpu);
 #endif
 	set_cpu_possible(cpu, true);
 	set_cpu_present(cpu, true);
@@ -2212,7 +2208,7 @@ int default_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	}
 
 	if (likely(cpu < nr_cpu_ids)) {
-		*apicid = per_cpu(x86_cpu_to_apicid, cpu);
+		*apicid = x86_cpu_to_apicid[cpu];
 		return 0;
 	}
 
@@ -2406,23 +2402,13 @@ static int __cpuinit apic_cluster_num(void)
 {
 	int i, clusters, zeros;
 	unsigned id;
-	u16 *bios_cpu_apicid;
 	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
 
-	bios_cpu_apicid = early_per_cpu_ptr(x86_bios_cpu_apicid);
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
 
 	for (i = 0; i < nr_cpu_ids; i++) {
 		/* are we being called early in kernel startup? */
-		if (bios_cpu_apicid) {
-			id = bios_cpu_apicid[i];
-		} else if (i < nr_cpu_ids) {
-			if (cpu_present(i))
-				id = per_cpu(x86_bios_cpu_apicid, i);
-			else
-				continue;
-		} else
-			break;
+		id = x86_bios_cpu_apicid[i];
 
 		if (id != BAD_APICID)
 			__set_bit(APIC_CLUSTERID(id), clustermap);
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 9a91109..25e4e57 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -97,7 +97,7 @@ static int __cpuinit numachip_wakeup_secondary(int phys_apicid, unsigned long st
 static void numachip_send_IPI_one(int cpu, int vector)
 {
 	union numachip_csr_g3_ext_irq_gen int_gen;
-	int apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	int apicid = x86_cpu_to_apicid[cpu];
 
 	int_gen.s._destination_apic_id = apicid;
 	int_gen.s._vector = vector;
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index d50e364..8693d11 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -39,7 +39,7 @@ static unsigned long bigsmp_check_apicid_present(int bit)
 static int bigsmp_early_logical_apicid(int cpu)
 {
 	/* on bigsmp, logical apicid is the same as physical */
-	return early_per_cpu(x86_cpu_to_apicid, cpu);
+	return x86_cpu_to_apicid[cpu];
 }
 
 static inline unsigned long calculate_ldr(int cpu)
@@ -47,7 +47,7 @@ static inline unsigned long calculate_ldr(int cpu)
 	unsigned long val, id;
 
 	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	id = per_cpu(x86_bios_cpu_apicid, cpu);
+	id = x86_bios_cpu_apicid[cpu];
 	val |= SET_APIC_LOGICAL_ID(id);
 
 	return val;
@@ -80,7 +80,7 @@ static void bigsmp_setup_apic_routing(void)
 static int bigsmp_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
-		return (int) per_cpu(x86_bios_cpu_apicid, mps_cpu);
+		return (int) x86_bios_cpu_apicid[mps_cpu];
 
 	return BAD_APICID;
 }
@@ -225,10 +225,9 @@ void __init generic_bigsmp_probe(void)
 	apic = &apic_bigsmp;
 
 	for_each_possible_cpu(cpu) {
-		if (early_per_cpu(x86_cpu_to_logical_apicid,
-				  cpu) == BAD_APICID)
+		if (x86_cpu_to_logical_apicid[cpu] == BAD_APICID)
 			continue;
-		early_per_cpu(x86_cpu_to_logical_apicid, cpu) =
+		x86_cpu_to_logical_apicid[cpu] =
 			bigsmp_early_logical_apicid(cpu);
 	}
 
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 0874799..f5852cc 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -448,12 +448,12 @@ static unsigned long es7000_check_apicid_present(int bit)
 static int es7000_early_logical_apicid(int cpu)
 {
 	/* on es7000, logical apicid is the same as physical */
-	return early_per_cpu(x86_bios_cpu_apicid, cpu);
+	return x86_bios_cpu_apicid[cpu];
 }
 
 static unsigned long calculate_ldr(int cpu)
 {
-	unsigned long id = per_cpu(x86_bios_cpu_apicid, cpu);
+	unsigned long id = x86_bios_cpu_apicid[cpu];
 
 	return SET_APIC_LOGICAL_ID(id);
 }
@@ -487,7 +487,7 @@ static void es7000_init_apic_ldr(void)
 
 static void es7000_setup_apic_routing(void)
 {
-	int apic = per_cpu(x86_bios_cpu_apicid, smp_processor_id());
+	int apic = x86_bios_cpu_apicid[smp_processor_id()];
 
 	pr_info("Enabling APIC mode:  %s. Using %d I/O APICs, target cpus %lx\n",
 		(apic_version[apic] == 0x14) ?
@@ -500,7 +500,7 @@ static int es7000_cpu_present_to_apicid(int mps_cpu)
 	if (!mps_cpu)
 		return boot_cpu_physical_apicid;
 	else if (mps_cpu < nr_cpu_ids)
-		return per_cpu(x86_bios_cpu_apicid, mps_cpu);
+		return x86_bios_cpu_apicid[mps_cpu];
 	else
 		return BAD_APICID;
 }
@@ -535,7 +535,7 @@ es7000_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu_and(cpu, cpumask, cpu_online_mask) {
-		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+		int new_apicid = x86_cpu_to_logical_apicid[cpu];
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			WARN(1, "Not a valid mask!");
@@ -557,7 +557,7 @@ es7000_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      unsigned int *apicid)
 {
 	cpumask_var_t cpumask;
-	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
+	*apicid = x86_cpu_to_logical_apicid[0];
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
 		return 0;
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index 7434d85..70c1275 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -31,8 +31,8 @@ void default_send_IPI_mask_sequence_phys(const struct cpumask *mask, int vector)
 	 */
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask) {
-		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
-				query_cpu), vector, APIC_DEST_PHYSICAL);
+		__default_send_IPI_dest_field(x86_cpu_to_apicid[query_cpu],
+					vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
@@ -50,8 +50,8 @@ void default_send_IPI_mask_allbutself_phys(const struct cpumask *mask,
 	for_each_cpu(query_cpu, mask) {
 		if (query_cpu == this_cpu)
 			continue;
-		__default_send_IPI_dest_field(per_cpu(x86_cpu_to_apicid,
-				 query_cpu), vector, APIC_DEST_PHYSICAL);
+		__default_send_IPI_dest_field(x86_cpu_to_apicid[query_cpu],
+					vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
@@ -73,7 +73,7 @@ void default_send_IPI_mask_sequence_logical(const struct cpumask *mask,
 	local_irq_save(flags);
 	for_each_cpu(query_cpu, mask)
 		__default_send_IPI_dest_field(
-			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			x86_cpu_to_logical_apicid[query_cpu],
 			vector, apic->dest_logical);
 	local_irq_restore(flags);
 }
@@ -92,7 +92,7 @@ void default_send_IPI_mask_allbutself_logical(const struct cpumask *mask,
 		if (query_cpu == this_cpu)
 			continue;
 		__default_send_IPI_dest_field(
-			early_per_cpu(x86_cpu_to_logical_apicid, query_cpu),
+			x86_cpu_to_logical_apicid[query_cpu],
 			vector, apic->dest_logical);
 		}
 	local_irq_restore(flags);
@@ -143,7 +143,7 @@ static int convert_apicid_to_cpu(int apic_id)
 	int i;
 
 	for_each_possible_cpu(i) {
-		if (per_cpu(x86_cpu_to_apicid, i) == apic_id)
+		if (x86_cpu_to_apicid[i] == apic_id)
 			return i;
 	}
 	return -1;
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index d661ee9..e114d66 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -379,7 +379,7 @@ static inline int numaq_apicid_to_node(int logical_apicid)
 
 static int numaq_numa_cpu_node(int cpu)
 {
-	int logical_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	int logical_apicid = x86_cpu_to_logical_apicid[cpu];
 
 	if (logical_apicid != BAD_APICID)
 		return numaq_apicid_to_node(logical_apicid);
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 77c95c0..9e9cfb0 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -199,7 +199,7 @@ static unsigned long summit_check_apicid_present(int bit)
 static int summit_early_logical_apicid(int cpu)
 {
 	int count = 0;
-	u8 my_id = early_per_cpu(x86_cpu_to_apicid, cpu);
+	u8 my_id = x86_cpu_to_apicid[cpu];
 	u8 my_cluster = APIC_CLUSTER(my_id);
 #ifdef CONFIG_SMP
 	u8 lid;
@@ -207,7 +207,7 @@ static int summit_early_logical_apicid(int cpu)
 
 	/* Create logical APIC IDs by counting CPUs already in cluster. */
 	for (count = 0, i = nr_cpu_ids; --i >= 0; ) {
-		lid = early_per_cpu(x86_cpu_to_logical_apicid, i);
+		lid = x86_cpu_to_logical_apicid[i];
 		if (lid != BAD_APICID && APIC_CLUSTER(lid) == my_cluster)
 			++count;
 	}
@@ -221,7 +221,7 @@ static int summit_early_logical_apicid(int cpu)
 static void summit_init_apic_ldr(void)
 {
 	int cpu = smp_processor_id();
-	unsigned long id = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+	unsigned long id = x86_cpu_to_logical_apicid[cpu];
 	unsigned long val;
 
 	apic_write(APIC_DFR, SUMMIT_APIC_DFR_VALUE);
@@ -244,7 +244,7 @@ static void summit_setup_apic_routing(void)
 static int summit_cpu_present_to_apicid(int mps_cpu)
 {
 	if (mps_cpu < nr_cpu_ids)
-		return (int)per_cpu(x86_bios_cpu_apicid, mps_cpu);
+		return (int)x86_bios_cpu_apicid[mps_cpu];
 	else
 		return BAD_APICID;
 }
@@ -275,7 +275,7 @@ summit_cpu_mask_to_apicid(const struct cpumask *cpumask, unsigned int *dest_id)
 	 * The cpus in the mask must all be on the apic cluster.
 	 */
 	for_each_cpu_and(cpu, cpumask, cpu_online_mask) {
-		int new_apicid = early_per_cpu(x86_cpu_to_logical_apicid, cpu);
+		int new_apicid = x86_cpu_to_logical_apicid[cpu];
 
 		if (round && APIC_CLUSTER(apicid) != APIC_CLUSTER(new_apicid)) {
 			pr_err("Not a valid mask!\n");
@@ -296,7 +296,7 @@ summit_cpu_mask_to_apicid_and(const struct cpumask *inmask,
 			      unsigned int *apicid)
 {
 	cpumask_var_t cpumask;
-	*apicid = early_per_cpu(x86_cpu_to_logical_apicid, 0);
+	*apicid = x86_cpu_to_logical_apicid[0];
 
 	if (!alloc_cpumask_var(&cpumask, GFP_ATOMIC))
 		return 0;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index c88baa4..33e961d 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -10,7 +10,7 @@
 #include <asm/smp.h>
 #include <asm/x2apic.h>
 
-static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+u32 x86_cpu_to_logical_apicid[NR_CPUS];
 static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
 static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
 
@@ -21,7 +21,7 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 
 static inline u32 x2apic_cluster(int cpu)
 {
-	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
+	return x86_cpu_to_logical_apicid[cpu] >> 16;
 }
 
 static void
@@ -58,7 +58,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 		/* Collect cpus in cluster. */
 		for_each_cpu_and(i, ipi_mask_ptr, cpus_in_cluster_ptr) {
 			if (apic_dest == APIC_DEST_ALLINC || i != this_cpu)
-				dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+				dest |= x86_cpu_to_logical_apicid[i];
 		}
 
 		if (!dest)
@@ -108,7 +108,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	for_each_cpu_and(i, cpumask, andmask) {
 		if (!cpumask_test_cpu(i, cpu_online_mask))
 			continue;
-		dest = per_cpu(x86_cpu_to_logical_apicid, i);
+		dest = x86_cpu_to_logical_apicid[i];
 		cluster = x2apic_cluster(i);
 		break;
 	}
@@ -121,7 +121,7 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 			continue;
 		if (cluster != x2apic_cluster(i))
 			continue;
-		dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+		dest |= x86_cpu_to_logical_apicid[i];
 	}
 
 	*apicid = dest;
@@ -134,7 +134,7 @@ static void init_x2apic_ldr(void)
 	unsigned int this_cpu = smp_processor_id();
 	unsigned int cpu;
 
-	per_cpu(x86_cpu_to_logical_apicid, this_cpu) = apic_read(APIC_LDR);
+	x86_cpu_to_logical_apicid[this_cpu] = apic_read(APIC_LDR);
 
 	__cpu_set(this_cpu, per_cpu(cpus_in_cluster, this_cpu));
 	for_each_online_cpu(cpu) {
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index 562a76d..b048860 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -50,7 +50,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 	for_each_cpu(query_cpu, mask) {
 		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
 			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
+		__x2apic_send_IPI_dest(x86_cpu_to_apicid[query_cpu],
 				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 63092af..a328d06 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -239,7 +239,7 @@ static void uv_send_IPI_one(int cpu, int vector)
 	unsigned long apicid;
 	int pnode;
 
-	apicid = per_cpu(x86_cpu_to_apicid, cpu);
+	apicid = x86_cpu_to_apicid[cpu];
 	pnode = uv_apicid_to_pnode(apicid);
 	uv_hub_send_ipi(pnode, apicid, vector);
 }
@@ -310,7 +310,7 @@ uv_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	}
 
 	if (likely(cpu < nr_cpu_ids)) {
-		*apicid = per_cpu(x86_cpu_to_apicid, cpu) | uv_apicid_hibits;
+		*apicid = x86_cpu_to_apicid[cpu] | uv_apicid_hibits;
 		return 0;
 	}
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 5cdff03..efb7445 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -231,16 +231,6 @@ void __init setup_per_cpu_areas(void)
 		 * are zeroed indicating that the static arrays are
 		 * gone.
 		 */
-#ifdef CONFIG_X86_LOCAL_APIC
-		per_cpu(x86_cpu_to_apicid, cpu) =
-			early_per_cpu_map(x86_cpu_to_apicid, cpu);
-		per_cpu(x86_bios_cpu_apicid, cpu) =
-			early_per_cpu_map(x86_bios_cpu_apicid, cpu);
-#endif
-#ifdef CONFIG_X86_32
-		per_cpu(x86_cpu_to_logical_apicid, cpu) =
-			early_per_cpu_map(x86_cpu_to_logical_apicid, cpu);
-#endif
 #ifdef CONFIG_X86_64
 		per_cpu(irq_stack_ptr, cpu) =
 			per_cpu(irq_stack_union.irq_stack, cpu) +
@@ -268,13 +258,6 @@ void __init setup_per_cpu_areas(void)
 	}
 
 	/* indicate the early static arrays will soon be gone */
-#ifdef CONFIG_X86_LOCAL_APIC
-	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
-	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
-#endif
-#ifdef CONFIG_X86_32
-	early_per_cpu_ptr(x86_cpu_to_logical_apicid) = NULL;
-#endif
 #ifdef CONFIG_NUMA
 	early_per_cpu_ptr(x86_cpu_to_node_map) = NULL;
 #endif
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bfd348e..fdf1f21 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -850,7 +850,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 		cpumask_clear_cpu(cpu, cpu_initialized_mask);
 
 		set_cpu_present(cpu, false);
-		per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
+		x86_cpu_to_apicid[cpu] = BAD_APICID;
 	}
 
 	/* mark "stuck" area as not stuck */
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a71c4e2..a9cad04 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -62,7 +62,7 @@ s16 __apicid_to_node[MAX_LOCAL_APIC] = {
 
 int __cpuinit numa_cpu_node(int cpu)
 {
-	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
+	int apicid = x86_cpu_to_apicid[cpu];
 
 	if (apicid != BAD_APICID)
 		return __apicid_to_node[apicid];
@@ -673,9 +673,6 @@ static __init int find_near_online_node(int node)
 void __init init_cpu_to_node(void)
 {
 	int cpu;
-	u16 *cpu_to_apicid = early_per_cpu_ptr(x86_cpu_to_apicid);
-
-	BUG_ON(cpu_to_apicid == NULL);
 
 	for_each_possible_cpu(cpu) {
 		int node = numa_cpu_node(cpu);
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 0f92173..48f29ef 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -180,7 +180,7 @@ static int __init uvhub_to_first_apicid(int uvhub)
 
 	for_each_present_cpu(cpu)
 		if (uvhub == uv_cpu_to_blade_id(cpu))
-			return per_cpu(x86_cpu_to_apicid, cpu);
+			return x86_cpu_to_apicid[cpu];
 	return -1;
 }
 
-- 
1.8.3

