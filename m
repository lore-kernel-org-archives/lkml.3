Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3FXTdH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:33:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:47690 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab3FXTc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:32:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
Subject: [PATCH 23/32] x86: delete __cpuinit usage from all x86 files
Date: Mon, 24 Jun 2013 15:30:28 -0400
Message-ID: <1372102237-8757-24-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
References: <1372102237-8757-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __cpuinit type of throwaway sections might have made sense
some time ago when RAM was more constrained, but now the savings
do not offset the cost and complications.  For example, the fix in
commit 5e427ec2d0 ("x86: Fix bit corruption at CPU resume time")
is a good example of the nasty type of bugs that can be created
with improper use of the various __init prefixes.

After a discussion on LKML[1] it was decided that cpuinit should go
the way of devinit and be phased out.  Once all the users are gone,
we can then finally remove the macros themselves from linux/init.h.

Note that some harmless section mismatch warnings may result, since
notify_cpu_starting() and cpu_up() are arch independent (kernel/cpu.c)
are flagged as __cpuinit  -- so if we remove the __cpuinit from
arch specific callers, we will also get section mismatch warnings.
As an intermediate step, we intend to turn the linux/init.h cpuinit
content into no-ops as early as possible, since that will get rid
of these warnings.  In any case, they are temporary and harmless.

This removes all the arch/x86 uses of the __cpuinit macros from
all C files.  x86 only had the one __CPUINIT used in assembly files,
and it wasn't paired off with a .previous or a __FINIT, so we can
delete it directly w/o any corresponding additional change there.

[1] https://lkml.org/lkml/2013/5/20/589

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[This commit is part of the __cpuinit removal work.  If you don't see
 any problems with it, then you don't have to do anything ; it will be
 submitted with all the rest of the __cpuinit removal work.  On the
 other hand, if you want to carry this patch in with your other pending
 changes so as to handle conflicts with other pending work yourself, then
 that is fine too, as the commits can largely be treated independently.
 For more information, please see: https://lkml.org/lkml/2013/6/20/513 ]

 arch/x86/include/asm/cpu.h                    |  2 +-
 arch/x86/include/asm/microcode.h              |  4 +-
 arch/x86/include/asm/microcode_intel.h        |  4 +-
 arch/x86/include/asm/mmconfig.h               |  4 +-
 arch/x86/include/asm/mpspec.h                 |  2 +-
 arch/x86/include/asm/numa.h                   |  6 +--
 arch/x86/include/asm/prom.h                   |  2 +-
 arch/x86/include/asm/smp.h                    |  2 +-
 arch/x86/kernel/acpi/boot.c                   |  6 +--
 arch/x86/kernel/apic/apic.c                   | 30 ++++++-------
 arch/x86/kernel/apic/apic_numachip.c          |  2 +-
 arch/x86/kernel/apic/es7000_32.c              |  2 +-
 arch/x86/kernel/apic/numaq_32.c               |  2 +-
 arch/x86/kernel/apic/x2apic_cluster.c         |  2 +-
 arch/x86/kernel/apic/x2apic_uv_x.c            | 14 +++---
 arch/x86/kernel/cpu/amd.c                     | 33 +++++++-------
 arch/x86/kernel/cpu/centaur.c                 | 26 +++++------
 arch/x86/kernel/cpu/common.c                  | 64 +++++++++++++--------------
 arch/x86/kernel/cpu/cyrix.c                   | 40 ++++++++---------
 arch/x86/kernel/cpu/hypervisor.c              |  2 +-
 arch/x86/kernel/cpu/intel.c                   | 30 ++++++-------
 arch/x86/kernel/cpu/intel_cacheinfo.c         | 55 +++++++++++------------
 arch/x86/kernel/cpu/mcheck/mce.c              | 23 +++++-----
 arch/x86/kernel/cpu/mcheck/mce_amd.c          | 14 +++---
 arch/x86/kernel/cpu/mcheck/therm_throt.c      |  9 ++--
 arch/x86/kernel/cpu/perf_event.c              |  2 +-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c      |  2 +-
 arch/x86/kernel/cpu/perf_event_amd_uncore.c   | 31 +++++++------
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 20 ++++-----
 arch/x86/kernel/cpu/rdrand.c                  |  2 +-
 arch/x86/kernel/cpu/scattered.c               |  4 +-
 arch/x86/kernel/cpu/topology.c                |  2 +-
 arch/x86/kernel/cpu/transmeta.c               |  6 +--
 arch/x86/kernel/cpu/umc.c                     |  2 +-
 arch/x86/kernel/cpu/vmware.c                  |  2 +-
 arch/x86/kernel/cpuid.c                       |  7 ++-
 arch/x86/kernel/devicetree.c                  |  2 +-
 arch/x86/kernel/head_32.S                     |  1 -
 arch/x86/kernel/i387.c                        |  8 ++--
 arch/x86/kernel/irq_32.c                      |  2 +-
 arch/x86/kernel/kvm.c                         | 10 ++---
 arch/x86/kernel/kvmclock.c                    |  2 +-
 arch/x86/kernel/microcode_core.c              |  2 +-
 arch/x86/kernel/microcode_core_early.c        |  6 +--
 arch/x86/kernel/microcode_intel_early.c       | 26 +++++------
 arch/x86/kernel/mmconf-fam10h_64.c            | 12 ++---
 arch/x86/kernel/msr.c                         |  6 +--
 arch/x86/kernel/process.c                     |  2 +-
 arch/x86/kernel/setup.c                       |  2 +-
 arch/x86/kernel/smpboot.c                     | 28 ++++++------
 arch/x86/kernel/tboot.c                       |  6 +--
 arch/x86/kernel/tsc.c                         |  4 +-
 arch/x86/kernel/tsc_sync.c                    | 18 ++++----
 arch/x86/kernel/vsyscall_64.c                 |  6 +--
 arch/x86/kernel/x86_init.c                    |  4 +-
 arch/x86/kernel/xsave.c                       |  4 +-
 arch/x86/mm/mmio-mod.c                        |  4 +-
 arch/x86/mm/numa.c                            | 12 ++---
 arch/x86/mm/numa_emulation.c                  | 12 ++---
 arch/x86/mm/setup_nx.c                        |  4 +-
 arch/x86/pci/amd_bus.c                        |  8 ++--
 arch/x86/platform/ce4100/ce4100.c             |  2 +-
 arch/x86/platform/mrst/mrst.c                 |  4 +-
 arch/x86/xen/enlighten.c                      |  6 +--
 arch/x86/xen/setup.c                          |  6 +--
 arch/x86/xen/smp.c                            | 12 ++---
 arch/x86/xen/spinlock.c                       |  2 +-
 arch/x86/xen/xen-ops.h                        |  2 +-
 68 files changed, 337 insertions(+), 348 deletions(-)

diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index 5f9a124..d2b1298 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -28,7 +28,7 @@ struct x86_cpu {
 #ifdef CONFIG_HOTPLUG_CPU
 extern int arch_register_cpu(int num);
 extern void arch_unregister_cpu(int);
-extern void __cpuinit start_cpu0(void);
+extern void start_cpu0(void);
 #ifdef CONFIG_DEBUG_HOTPLUG_CPU0
 extern int _debug_hotplug_cpu(int cpu, int action);
 #endif
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 6bc3985..f98bd66 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -60,11 +60,11 @@ static inline void __exit exit_amd_microcode(void) {}
 #ifdef CONFIG_MICROCODE_EARLY
 #define MAX_UCODE_COUNT 128
 extern void __init load_ucode_bsp(void);
-extern void __cpuinit load_ucode_ap(void);
+extern void load_ucode_ap(void);
 extern int __init save_microcode_in_initrd(void);
 #else
 static inline void __init load_ucode_bsp(void) {}
-static inline void __cpuinit load_ucode_ap(void) {}
+static inline void load_ucode_ap(void) {}
 static inline int __init save_microcode_in_initrd(void)
 {
 	return 0;
diff --git a/arch/x86/include/asm/microcode_intel.h b/arch/x86/include/asm/microcode_intel.h
index 87a0853..9067166 100644
--- a/arch/x86/include/asm/microcode_intel.h
+++ b/arch/x86/include/asm/microcode_intel.h
@@ -65,12 +65,12 @@ update_match_revision(struct microcode_header_intel *mc_header, int rev);
 
 #ifdef CONFIG_MICROCODE_INTEL_EARLY
 extern void __init load_ucode_intel_bsp(void);
-extern void __cpuinit load_ucode_intel_ap(void);
+extern void load_ucode_intel_ap(void);
 extern void show_ucode_info_early(void);
 extern int __init save_microcode_in_initrd_intel(void);
 #else
 static inline __init void load_ucode_intel_bsp(void) {}
-static inline __cpuinit void load_ucode_intel_ap(void) {}
+static inline void load_ucode_intel_ap(void) {}
 static inline void show_ucode_info_early(void) {}
 static inline int __init save_microcode_in_initrd_intel(void) { return -EINVAL; }
 #endif
diff --git a/arch/x86/include/asm/mmconfig.h b/arch/x86/include/asm/mmconfig.h
index 9b119da..04a3fed 100644
--- a/arch/x86/include/asm/mmconfig.h
+++ b/arch/x86/include/asm/mmconfig.h
@@ -2,8 +2,8 @@
 #define _ASM_X86_MMCONFIG_H
 
 #ifdef CONFIG_PCI_MMCONFIG
-extern void __cpuinit fam10h_check_enable_mmcfg(void);
-extern void __cpuinit check_enable_amd_mmconf_dmi(void);
+extern void fam10h_check_enable_mmcfg(void);
+extern void check_enable_amd_mmconf_dmi(void);
 #else
 static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3e2f42a..626cf70 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -94,7 +94,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #define default_get_smp_config x86_init_uint_noop
 #endif
 
-void __cpuinit generic_processor_info(int apicid, int version);
+void generic_processor_info(int apicid, int version);
 #ifdef CONFIG_ACPI
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 1b99ee5..4064aca 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -39,7 +39,7 @@ static inline void set_apicid_to_node(int apicid, s16 node)
 	__apicid_to_node[apicid] = node;
 }
 
-extern int __cpuinit numa_cpu_node(int cpu);
+extern int numa_cpu_node(int cpu);
 
 #else	/* CONFIG_NUMA */
 static inline void set_apicid_to_node(int apicid, s16 node)
@@ -60,8 +60,8 @@ static inline int numa_cpu_node(int cpu)
 extern void numa_set_node(int cpu, int node);
 extern void numa_clear_node(int cpu);
 extern void __init init_cpu_to_node(void);
-extern void __cpuinit numa_add_cpu(int cpu);
-extern void __cpuinit numa_remove_cpu(int cpu);
+extern void numa_add_cpu(int cpu);
+extern void numa_remove_cpu(int cpu);
 #else	/* CONFIG_NUMA */
 static inline void numa_set_node(int cpu, int node)	{ }
 static inline void numa_clear_node(int cpu)		{ }
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 60bef66..bade6ac 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -27,7 +27,7 @@ extern int of_ioapic;
 extern u64 initial_dtb;
 extern void add_dtb(u64 data);
 extern void x86_add_irq_domains(void);
-void __cpuinit x86_of_pci_init(void);
+void x86_of_pci_init(void);
 void x86_dtb_init(void);
 #else
 static inline void add_dtb(u64 data) { }
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index b073aae..4137890 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -179,7 +179,7 @@ static inline int wbinvd_on_all_cpus(void)
 }
 #endif /* CONFIG_SMP */
 
-extern unsigned disabled_cpus __cpuinitdata;
+extern unsigned disabled_cpus;
 
 #ifdef CONFIG_X86_32_SMP
 /*
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d81a972..2627a81 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -195,7 +195,7 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
 	return 0;
 }
 
-static void __cpuinit acpi_register_lapic(int id, u8 enabled)
+static void acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
@@ -607,7 +607,7 @@ void __init acpi_set_irq_model_ioapic(void)
 #ifdef CONFIG_ACPI_HOTPLUG_CPU
 #include <acpi/processor.h>
 
-static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
+static void acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 {
 #ifdef CONFIG_ACPI_NUMA
 	int nid;
@@ -620,7 +620,7 @@ static void __cpuinit acpi_map_cpu2node(acpi_handle handle, int cpu, int physid)
 #endif
 }
 
-static int __cpuinit _acpi_map_lsapic(acpi_handle handle, int *pcpu)
+static int _acpi_map_lsapic(acpi_handle handle, int *pcpu)
 {
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 1600b1c..c40eee8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -57,7 +57,7 @@
 
 unsigned int num_processors;
 
-unsigned disabled_cpus __cpuinitdata;
+unsigned disabled_cpus;
 
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
@@ -543,7 +543,7 @@ static DEFINE_PER_CPU(struct clock_event_device, lapic_events);
  * Setup the local APIC timer for this CPU. Copy the initialized values
  * of the boot CPU and register the clock event in the framework.
  */
-static void __cpuinit setup_APIC_timer(void)
+static void setup_APIC_timer(void)
 {
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 
@@ -865,7 +865,7 @@ void __init setup_boot_APIC_clock(void)
 	setup_APIC_timer();
 }
 
-void __cpuinit setup_secondary_APIC_clock(void)
+void setup_secondary_APIC_clock(void)
 {
 	setup_APIC_timer();
 }
@@ -1210,7 +1210,7 @@ void __init init_bsp_APIC(void)
 	apic_write(APIC_LVT1, value);
 }
 
-static void __cpuinit lapic_setup_esr(void)
+static void lapic_setup_esr(void)
 {
 	unsigned int oldvalue, value, maxlvt;
 
@@ -1257,7 +1257,7 @@ static void __cpuinit lapic_setup_esr(void)
  * Used to setup local APIC while initializing BSP or bringin up APs.
  * Always called with preemption disabled.
  */
-void __cpuinit setup_local_APIC(void)
+void setup_local_APIC(void)
 {
 	int cpu = smp_processor_id();
 	unsigned int value, queued;
@@ -1452,7 +1452,7 @@ void __cpuinit setup_local_APIC(void)
 #endif
 }
 
-void __cpuinit end_local_APIC_setup(void)
+void end_local_APIC_setup(void)
 {
 	lapic_setup_esr();
 
@@ -2062,7 +2062,7 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	apic_write(APIC_LVT1, value);
 }
 
-void __cpuinit generic_processor_info(int apicid, int version)
+void generic_processor_info(int apicid, int version)
 {
 	int cpu, max = nr_cpu_ids;
 	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
@@ -2332,7 +2332,7 @@ static struct syscore_ops lapic_syscore_ops = {
 	.suspend	= lapic_suspend,
 };
 
-static void __cpuinit apic_pm_activate(void)
+static void apic_pm_activate(void)
 {
 	apic_pm_state.active = 1;
 }
@@ -2357,7 +2357,7 @@ static void apic_pm_activate(void) { }
 
 #ifdef CONFIG_X86_64
 
-static int __cpuinit apic_cluster_num(void)
+static int apic_cluster_num(void)
 {
 	int i, clusters, zeros;
 	unsigned id;
@@ -2402,10 +2402,10 @@ static int __cpuinit apic_cluster_num(void)
 	return clusters;
 }
 
-static int __cpuinitdata multi_checked;
-static int __cpuinitdata multi;
+static int multi_checked;
+static int multi;
 
-static int __cpuinit set_multi(const struct dmi_system_id *d)
+static int set_multi(const struct dmi_system_id *d)
 {
 	if (multi)
 		return 0;
@@ -2414,7 +2414,7 @@ static int __cpuinit set_multi(const struct dmi_system_id *d)
 	return 0;
 }
 
-static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
+static const struct dmi_system_id multi_dmi_table[] = {
 	{
 		.callback = set_multi,
 		.ident = "IBM System Summit2",
@@ -2426,7 +2426,7 @@ static const __cpuinitconst struct dmi_system_id multi_dmi_table[] = {
 	{}
 };
 
-static void __cpuinit dmi_check_multi(void)
+static void dmi_check_multi(void)
 {
 	if (multi_checked)
 		return;
@@ -2443,7 +2443,7 @@ static void __cpuinit dmi_check_multi(void)
  * multi-chassis.
  * Use DMI to check them
  */
-__cpuinit int apic_is_clustered_box(void)
+int apic_is_clustered_box(void)
 {
 	dmi_check_multi();
 	if (multi)
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index 9a91109..3e67f9e 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -74,7 +74,7 @@ static int numachip_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
-static int __cpuinit numachip_wakeup_secondary(int phys_apicid, unsigned long start_rip)
+static int numachip_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 	union numachip_csr_g3_ext_irq_gen int_gen;
 
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 0874799..c552247 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -130,7 +130,7 @@ int					es7000_plat;
  */
 
 
-static int __cpuinit wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
+static int wakeup_secondary_cpu_via_mip(int cpu, unsigned long eip)
 {
 	unsigned long vect = 0, psaival = 0;
 
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index d661ee9..1e42e8f 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -105,7 +105,7 @@ static void __init smp_dump_qct(void)
 	}
 }
 
-void __cpuinit numaq_tsc_disable(void)
+void numaq_tsc_disable(void)
 {
 	if (!found_numaq)
 		return;
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index c88baa4..140e29d 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -148,7 +148,7 @@ static void init_x2apic_ldr(void)
  /*
   * At CPU state changes, update the x2apic cluster sibling info.
   */
-static int __cpuinit
+static int
 update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int this_cpu = (unsigned long)hcpu;
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 63092af..1191ac1 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -209,7 +209,7 @@ EXPORT_SYMBOL_GPL(uv_possible_blades);
 unsigned long sn_rtc_cycles_per_second;
 EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
-static int __cpuinit uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
+static int uv_wakeup_secondary(int phys_apicid, unsigned long start_rip)
 {
 #ifdef CONFIG_SMP
 	unsigned long val;
@@ -416,7 +416,7 @@ static struct apic __refdata apic_x2apic_uv_x = {
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
 
-static __cpuinit void set_x2apic_extra_bits(int pnode)
+static void set_x2apic_extra_bits(int pnode)
 {
 	__this_cpu_write(x2apic_extra_bits, pnode << uvh_apicid.s.pnode_shift);
 }
@@ -735,7 +735,7 @@ static void uv_heartbeat(unsigned long ignored)
 	mod_timer_pinned(timer, jiffies + SCIR_CPU_HB_INTERVAL);
 }
 
-static void __cpuinit uv_heartbeat_enable(int cpu)
+static void uv_heartbeat_enable(int cpu)
 {
 	while (!uv_cpu_hub_info(cpu)->scir.enabled) {
 		struct timer_list *timer = &uv_cpu_hub_info(cpu)->scir.timer;
@@ -752,7 +752,7 @@ static void __cpuinit uv_heartbeat_enable(int cpu)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static void __cpuinit uv_heartbeat_disable(int cpu)
+static void uv_heartbeat_disable(int cpu)
 {
 	if (uv_cpu_hub_info(cpu)->scir.enabled) {
 		uv_cpu_hub_info(cpu)->scir.enabled = 0;
@@ -764,8 +764,8 @@ static void __cpuinit uv_heartbeat_disable(int cpu)
 /*
  * cpu hotplug notifier
  */
-static __cpuinit int uv_scir_cpu_notify(struct notifier_block *self,
-				       unsigned long action, void *hcpu)
+static int uv_scir_cpu_notify(struct notifier_block *self, unsigned long action,
+			      void *hcpu)
 {
 	long cpu = (long)hcpu;
 
@@ -835,7 +835,7 @@ int uv_set_vga_state(struct pci_dev *pdev, bool decode,
  * Called on each cpu to initialize the per_cpu UV data area.
  * FIXME: hotplug not supported yet
  */
-void __cpuinit uv_cpu_init(void)
+void uv_cpu_init(void)
 {
 	/* CPU 0 initilization will be done via uv_system_init. */
 	if (!uv_blade_info)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c587a87..f654ece 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -69,7 +69,7 @@ static inline int wrmsrl_amd_safe(unsigned msr, unsigned long long val)
 extern void vide(void);
 __asm__(".align 4\nvide: ret");
 
-static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
+static void init_amd_k5(struct cpuinfo_x86 *c)
 {
 /*
  * General Systems BIOSen alias the cpu frequency registers
@@ -87,7 +87,7 @@ static void __cpuinit init_amd_k5(struct cpuinfo_x86 *c)
 }
 
 
-static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
+static void init_amd_k6(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 	int mbytes = get_num_physpages() >> (20-PAGE_SHIFT);
@@ -179,7 +179,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
+static void amd_k7_smp_check(struct cpuinfo_x86 *c)
 {
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
@@ -222,7 +222,7 @@ static void __cpuinit amd_k7_smp_check(struct cpuinfo_x86 *c)
 	add_taint(TAINT_UNSAFE_SMP, LOCKDEP_NOW_UNRELIABLE);
 }
 
-static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
+static void init_amd_k7(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 
@@ -267,7 +267,7 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
  * To workaround broken NUMA config.  Read the comment in
  * srat_detect_node().
  */
-static int __cpuinit nearby_node(int apicid)
+static int nearby_node(int apicid)
 {
 	int i, node;
 
@@ -292,7 +292,7 @@ static int __cpuinit nearby_node(int apicid)
  * (2) AMD processors supporting compute units
  */
 #ifdef CONFIG_X86_HT
-static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
+static void amd_get_topology(struct cpuinfo_x86 *c)
 {
 	u32 nodes, cores_per_cu = 1;
 	u8 node_id;
@@ -342,7 +342,7 @@ static void __cpuinit amd_get_topology(struct cpuinfo_x86 *c)
  * On a AMD dual core setup the lower bits of the APIC id distingush the cores.
  * Assumes number of cores is a power of two.
  */
-static void __cpuinit amd_detect_cmp(struct cpuinfo_x86 *c)
+static void amd_detect_cmp(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits;
@@ -369,7 +369,7 @@ u16 amd_get_nb_id(int cpu)
 }
 EXPORT_SYMBOL_GPL(amd_get_nb_id);
 
-static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
+static void srat_detect_node(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_NUMA
 	int cpu = smp_processor_id();
@@ -421,7 +421,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
+static void early_init_amd_mc(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	unsigned bits, ecx;
@@ -447,7 +447,7 @@ static void __cpuinit early_init_amd_mc(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
+static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
 
@@ -475,7 +475,7 @@ static void __cpuinit bsp_init_amd(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit early_init_amd(struct cpuinfo_x86 *c)
+static void early_init_amd(struct cpuinfo_x86 *c)
 {
 	early_init_amd_mc(c);
 
@@ -514,7 +514,7 @@ static const int amd_erratum_383[];
 static const int amd_erratum_400[];
 static bool cpu_has_amd_erratum(const int *erratum);
 
-static void __cpuinit init_amd(struct cpuinfo_x86 *c)
+static void init_amd(struct cpuinfo_x86 *c)
 {
 	u32 dummy;
 	unsigned long long value;
@@ -740,8 +740,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_X86_32
-static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
-							unsigned int size)
+static unsigned int amd_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/* AMD errata T13 (order #21922) */
 	if ((c->x86 == 6)) {
@@ -757,7 +756,7 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c,
 }
 #endif
 
-static void __cpuinit cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
+static void cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
 {
 	tlb_flushall_shift = 5;
 
@@ -765,7 +764,7 @@ static void __cpuinit cpu_set_tlb_flushall_shift(struct cpuinfo_x86 *c)
 		tlb_flushall_shift = 4;
 }
 
-static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
+static void cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 {
 	u32 ebx, eax, ecx, edx;
 	u16 mask = 0xfff;
@@ -820,7 +819,7 @@ static void __cpuinit cpu_detect_tlb_amd(struct cpuinfo_x86 *c)
 	cpu_set_tlb_flushall_shift(c);
 }
 
-static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
+static const struct cpu_dev amd_cpu_dev = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 159103c..fbf6c3b 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -11,7 +11,7 @@
 
 #ifdef CONFIG_X86_OOSTORE
 
-static u32 __cpuinit power2(u32 x)
+static u32 power2(u32 x)
 {
 	u32 s = 1;
 
@@ -25,7 +25,7 @@ static u32 __cpuinit power2(u32 x)
 /*
  * Set up an actual MCR
  */
-static void __cpuinit centaur_mcr_insert(int reg, u32 base, u32 size, int key)
+static void centaur_mcr_insert(int reg, u32 base, u32 size, int key)
 {
 	u32 lo, hi;
 
@@ -42,7 +42,7 @@ static void __cpuinit centaur_mcr_insert(int reg, u32 base, u32 size, int key)
  *
  * Shortcut: We know you can't put 4Gig of RAM on a winchip
  */
-static u32 __cpuinit ramtop(void)
+static u32 ramtop(void)
 {
 	u32 clip = 0xFFFFFFFFUL;
 	u32 top = 0;
@@ -91,7 +91,7 @@ static u32 __cpuinit ramtop(void)
 /*
  * Compute a set of MCR's to give maximum coverage
  */
-static int __cpuinit centaur_mcr_compute(int nr, int key)
+static int centaur_mcr_compute(int nr, int key)
 {
 	u32 mem = ramtop();
 	u32 root = power2(mem);
@@ -157,7 +157,7 @@ static int __cpuinit centaur_mcr_compute(int nr, int key)
 	return ct;
 }
 
-static void __cpuinit centaur_create_optimal_mcr(void)
+static void centaur_create_optimal_mcr(void)
 {
 	int used;
 	int i;
@@ -181,7 +181,7 @@ static void __cpuinit centaur_create_optimal_mcr(void)
 		wrmsr(MSR_IDT_MCR0+i, 0, 0);
 }
 
-static void __cpuinit winchip2_create_optimal_mcr(void)
+static void winchip2_create_optimal_mcr(void)
 {
 	u32 lo, hi;
 	int used;
@@ -217,7 +217,7 @@ static void __cpuinit winchip2_create_optimal_mcr(void)
 /*
  * Handle the MCR key on the Winchip 2.
  */
-static void __cpuinit winchip2_unprotect_mcr(void)
+static void winchip2_unprotect_mcr(void)
 {
 	u32 lo, hi;
 	u32 key;
@@ -229,7 +229,7 @@ static void __cpuinit winchip2_unprotect_mcr(void)
 	wrmsr(MSR_IDT_MCR_CTRL, lo, hi);
 }
 
-static void __cpuinit winchip2_protect_mcr(void)
+static void winchip2_protect_mcr(void)
 {
 	u32 lo, hi;
 
@@ -247,7 +247,7 @@ static void __cpuinit winchip2_protect_mcr(void)
 #define RNG_ENABLED	(1 << 3)
 #define RNG_ENABLE	(1 << 6)	/* MSR_VIA_RNG */
 
-static void __cpuinit init_c3(struct cpuinfo_x86 *c)
+static void init_c3(struct cpuinfo_x86 *c)
 {
 	u32  lo, hi;
 
@@ -318,7 +318,7 @@ enum {
 		EAMD3D		= 1<<20,
 };
 
-static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
+static void early_init_centaur(struct cpuinfo_x86 *c)
 {
 	switch (c->x86) {
 #ifdef CONFIG_X86_32
@@ -337,7 +337,7 @@ static void __cpuinit early_init_centaur(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
+static void init_centaur(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_32
 	char *name;
@@ -468,7 +468,7 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 #endif
 }
 
-static unsigned int __cpuinit
+static unsigned int
 centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 #ifdef CONFIG_X86_32
@@ -488,7 +488,7 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	return size;
 }
 
-static const struct cpu_dev __cpuinitconst centaur_cpu_dev = {
+static const struct cpu_dev centaur_cpu_dev = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d4dd993..965c45f 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -63,7 +63,7 @@ void __init setup_cpu_local_masks(void)
 	alloc_bootmem_cpumask_var(&cpu_sibling_setup_mask);
 }
 
-static void __cpuinit default_init(struct cpuinfo_x86 *c)
+static void default_init(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_64
 	cpu_detect_cache_sizes(c);
@@ -80,13 +80,13 @@ static void __cpuinit default_init(struct cpuinfo_x86 *c)
 #endif
 }
 
-static const struct cpu_dev __cpuinitconst default_cpu = {
+static const struct cpu_dev default_cpu = {
 	.c_init		= default_init,
 	.c_vendor	= "Unknown",
 	.c_x86_vendor	= X86_VENDOR_UNKNOWN,
 };
 
-static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
+static const struct cpu_dev *this_cpu = &default_cpu;
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #ifdef CONFIG_X86_64
@@ -160,8 +160,8 @@ static int __init x86_xsaveopt_setup(char *s)
 __setup("noxsaveopt", x86_xsaveopt_setup);
 
 #ifdef CONFIG_X86_32
-static int cachesize_override __cpuinitdata = -1;
-static int disable_x86_serial_nr __cpuinitdata = 1;
+static int cachesize_override = -1;
+static int disable_x86_serial_nr = 1;
 
 static int __init cachesize_setup(char *str)
 {
@@ -215,12 +215,12 @@ static inline int flag_is_changeable_p(u32 flag)
 }
 
 /* Probe for the CPUID instruction */
-int __cpuinit have_cpuid_p(void)
+int have_cpuid_p(void)
 {
 	return flag_is_changeable_p(X86_EFLAGS_ID);
 }
 
-static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
+static void squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
 
@@ -298,7 +298,7 @@ struct cpuid_dependent_feature {
 	u32 level;
 };
 
-static const struct cpuid_dependent_feature __cpuinitconst
+static const struct cpuid_dependent_feature
 cpuid_dependent_features[] = {
 	{ X86_FEATURE_MWAIT,		0x00000005 },
 	{ X86_FEATURE_DCA,		0x00000009 },
@@ -306,7 +306,7 @@ cpuid_dependent_features[] = {
 	{ 0, 0 }
 };
 
-static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
+static void filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 {
 	const struct cpuid_dependent_feature *df;
 
@@ -344,7 +344,7 @@ static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
  */
 
 /* Look up CPU names by table lookup. */
-static const char *__cpuinit table_lookup_model(struct cpuinfo_x86 *c)
+static const char *table_lookup_model(struct cpuinfo_x86 *c)
 {
 	const struct cpu_model_info *info;
 
@@ -364,8 +364,8 @@ static const char *__cpuinit table_lookup_model(struct cpuinfo_x86 *c)
 	return NULL;		/* Not found */
 }
 
-__u32 cpu_caps_cleared[NCAPINTS] __cpuinitdata;
-__u32 cpu_caps_set[NCAPINTS] __cpuinitdata;
+__u32 cpu_caps_cleared[NCAPINTS];
+__u32 cpu_caps_set[NCAPINTS];
 
 void load_percpu_segment(int cpu)
 {
@@ -394,9 +394,9 @@ void switch_to_new_gdt(int cpu)
 	load_percpu_segment(cpu);
 }
 
-static const struct cpu_dev *__cpuinitdata cpu_devs[X86_VENDOR_NUM] = {};
+static const struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
-static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
+static void get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
 	char *p, *q;
@@ -425,7 +425,7 @@ static void __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	}
 }
 
-void __cpuinit cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
+void cpu_detect_cache_sizes(struct cpuinfo_x86 *c)
 {
 	unsigned int n, dummy, ebx, ecx, edx, l2size;
 
@@ -479,7 +479,7 @@ u16 __read_mostly tlb_lld_4m[NR_INFO];
  */
 s8  __read_mostly tlb_flushall_shift = -1;
 
-void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
+void cpu_detect_tlb(struct cpuinfo_x86 *c)
 {
 	if (this_cpu->c_detect_tlb)
 		this_cpu->c_detect_tlb(c);
@@ -493,7 +493,7 @@ void __cpuinit cpu_detect_tlb(struct cpuinfo_x86 *c)
 		tlb_flushall_shift);
 }
 
-void __cpuinit detect_ht(struct cpuinfo_x86 *c)
+void detect_ht(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_HT
 	u32 eax, ebx, ecx, edx;
@@ -544,7 +544,7 @@ out:
 #endif
 }
 
-static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
+static void get_cpu_vendor(struct cpuinfo_x86 *c)
 {
 	char *v = c->x86_vendor_id;
 	int i;
@@ -571,7 +571,7 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 	this_cpu = &default_cpu;
 }
 
-void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
+void cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
 	cpuid(0x00000000, (unsigned int *)&c->cpuid_level,
@@ -601,7 +601,7 @@ void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 	}
 }
 
-void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
+void get_cpu_cap(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
 	u32 ebx;
@@ -652,7 +652,7 @@ void __cpuinit get_cpu_cap(struct cpuinfo_x86 *c)
 	init_scattered_cpuid_features(c);
 }
 
-static void __cpuinit identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
+static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_32
 	int i;
@@ -767,7 +767,7 @@ void __init early_cpu_init(void)
  * unless we can find a reliable way to detect all the broken cases.
  * Enable it explicitly on 64-bit for non-constant inputs of cpu_has().
  */
-static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
+static void detect_nopl(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_X86_32
 	clear_cpu_cap(c, X86_FEATURE_NOPL);
@@ -776,7 +776,7 @@ static void __cpuinit detect_nopl(struct cpuinfo_x86 *c)
 #endif
 }
 
-static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
+static void generic_identify(struct cpuinfo_x86 *c)
 {
 	c->extended_cpuid_level = 0;
 
@@ -813,7 +813,7 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+static void identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
@@ -958,7 +958,7 @@ void __init identify_boot_cpu(void)
 	cpu_detect_tlb(&boot_cpu_data);
 }
 
-void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
+void identify_secondary_cpu(struct cpuinfo_x86 *c)
 {
 	BUG_ON(c == &boot_cpu_data);
 	identify_cpu(c);
@@ -973,14 +973,14 @@ struct msr_range {
 	unsigned	max;
 };
 
-static const struct msr_range msr_range_array[] __cpuinitconst = {
+static const struct msr_range msr_range_array[] = {
 	{ 0x00000000, 0x00000418},
 	{ 0xc0000000, 0xc000040b},
 	{ 0xc0010000, 0xc0010142},
 	{ 0xc0011000, 0xc001103b},
 };
 
-static void __cpuinit __print_cpu_msr(void)
+static void __print_cpu_msr(void)
 {
 	unsigned index_min, index_max;
 	unsigned index;
@@ -999,7 +999,7 @@ static void __cpuinit __print_cpu_msr(void)
 	}
 }
 
-static int show_msr __cpuinitdata;
+static int show_msr;
 
 static __init int setup_show_msr(char *arg)
 {
@@ -1020,7 +1020,7 @@ static __init int setup_noclflush(char *arg)
 }
 __setup("noclflush", setup_noclflush);
 
-void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
+void print_cpu_info(struct cpuinfo_x86 *c)
 {
 	const char *vendor = NULL;
 
@@ -1049,7 +1049,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	print_cpu_msr(c);
 }
 
-void __cpuinit print_cpu_msr(struct cpuinfo_x86 *c)
+void print_cpu_msr(struct cpuinfo_x86 *c)
 {
 	if (c->cpu_index < show_msr)
 		__print_cpu_msr();
@@ -1214,7 +1214,7 @@ static void dbg_restore_debug_regs(void)
  */
 #ifdef CONFIG_X86_64
 
-void __cpuinit cpu_init(void)
+void cpu_init(void)
 {
 	struct orig_ist *oist;
 	struct task_struct *me;
@@ -1313,7 +1313,7 @@ void __cpuinit cpu_init(void)
 
 #else
 
-void __cpuinit cpu_init(void)
+void cpu_init(void)
 {
 	int cpu = smp_processor_id();
 	struct task_struct *curr = current;
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 7582f47..d0969c7 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -15,7 +15,7 @@
 /*
  * Read NSC/Cyrix DEVID registers (DIR) to get more detailed info. about the CPU
  */
-static void __cpuinit __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+static void __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned char ccr2, ccr3;
 
@@ -44,7 +44,7 @@ static void __cpuinit __do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 	}
 }
 
-static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
+static void do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
 {
 	unsigned long flags;
 
@@ -59,25 +59,25 @@ static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
  * Actually since bugs.h doesn't even reference this perhaps someone should
  * fix the documentation ???
  */
-static unsigned char Cx86_dir0_msb __cpuinitdata = 0;
+static unsigned char Cx86_dir0_msb = 0;
 
-static const char __cpuinitconst Cx86_model[][9] = {
+static const char Cx86_model[][9] = {
 	"Cx486", "Cx486", "5x86 ", "6x86", "MediaGX ", "6x86MX ",
 	"M II ", "Unknown"
 };
-static const char __cpuinitconst Cx486_name[][5] = {
+static const char Cx486_name[][5] = {
 	"SLC", "DLC", "SLC2", "DLC2", "SRx", "DRx",
 	"SRx2", "DRx2"
 };
-static const char __cpuinitconst Cx486S_name[][4] = {
+static const char Cx486S_name[][4] = {
 	"S", "S2", "Se", "S2e"
 };
-static const char __cpuinitconst Cx486D_name[][4] = {
+static const char Cx486D_name[][4] = {
 	"DX", "DX2", "?", "?", "?", "DX4"
 };
-static char Cx86_cb[] __cpuinitdata = "?.5x Core/Bus Clock";
-static const char __cpuinitconst cyrix_model_mult1[] = "12??43";
-static const char __cpuinitconst cyrix_model_mult2[] = "12233445";
+static char Cx86_cb[] = "?.5x Core/Bus Clock";
+static const char cyrix_model_mult1[] = "12??43";
+static const char cyrix_model_mult2[] = "12233445";
 
 /*
  * Reset the slow-loop (SLOP) bit on the 686(L) which is set by some old
@@ -87,7 +87,7 @@ static const char __cpuinitconst cyrix_model_mult2[] = "12233445";
  * FIXME: our newer udelay uses the tsc. We don't need to frob with SLOP
  */
 
-static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
+static void check_cx686_slop(struct cpuinfo_x86 *c)
 {
 	unsigned long flags;
 
@@ -112,7 +112,7 @@ static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
 }
 
 
-static void __cpuinit set_cx86_reorder(void)
+static void set_cx86_reorder(void)
 {
 	u8 ccr3;
 
@@ -127,7 +127,7 @@ static void __cpuinit set_cx86_reorder(void)
 	setCx86(CX86_CCR3, ccr3);
 }
 
-static void __cpuinit set_cx86_memwb(void)
+static void set_cx86_memwb(void)
 {
 	printk(KERN_INFO "Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
 
@@ -143,7 +143,7 @@ static void __cpuinit set_cx86_memwb(void)
  *	Configure later MediaGX and/or Geode processor.
  */
 
-static void __cpuinit geode_configure(void)
+static void geode_configure(void)
 {
 	unsigned long flags;
 	u8 ccr3;
@@ -166,7 +166,7 @@ static void __cpuinit geode_configure(void)
 	local_irq_restore(flags);
 }
 
-static void __cpuinit early_init_cyrix(struct cpuinfo_x86 *c)
+static void early_init_cyrix(struct cpuinfo_x86 *c)
 {
 	unsigned char dir0, dir0_msn, dir1 = 0;
 
@@ -185,7 +185,7 @@ static void __cpuinit early_init_cyrix(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
+static void init_cyrix(struct cpuinfo_x86 *c)
 {
 	unsigned char dir0, dir0_msn, dir0_lsn, dir1 = 0;
 	char *buf = c->x86_model_id;
@@ -356,7 +356,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 /*
  * Handle National Semiconductor branded processors
  */
-static void __cpuinit init_nsc(struct cpuinfo_x86 *c)
+static void init_nsc(struct cpuinfo_x86 *c)
 {
 	/*
 	 * There may be GX1 processors in the wild that are branded
@@ -405,7 +405,7 @@ static inline int test_cyrix_52div(void)
 	return (unsigned char) (test >> 8) == 0x02;
 }
 
-static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
+static void cyrix_identify(struct cpuinfo_x86 *c)
 {
 	/* Detect Cyrix with disabled CPUID */
 	if (c->x86 == 4 && test_cyrix_52div()) {
@@ -441,7 +441,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 	}
 }
 
-static const struct cpu_dev __cpuinitconst cyrix_cpu_dev = {
+static const struct cpu_dev cyrix_cpu_dev = {
 	.c_vendor	= "Cyrix",
 	.c_ident	= { "CyrixInstead" },
 	.c_early_init	= early_init_cyrix,
@@ -452,7 +452,7 @@ static const struct cpu_dev __cpuinitconst cyrix_cpu_dev = {
 
 cpu_dev_register(cyrix_cpu_dev);
 
-static const struct cpu_dev __cpuinitconst nsc_cpu_dev = {
+static const struct cpu_dev nsc_cpu_dev = {
 	.c_vendor	= "NSC",
 	.c_ident	= { "Geode by NSC" },
 	.c_init		= init_nsc,
diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 1e7e84a..8727921 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -60,7 +60,7 @@ detect_hypervisor_vendor(void)
 	}
 }
 
-void __cpuinit init_hypervisor(struct cpuinfo_x86 *c)
+void init_hypervisor(struct cpuinfo_x86 *c)
 {
 	if (x86_hyper && x86_hyper->set_cpu_features)
 		x86_hyper->set_cpu_features(c);
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 9b0c441..ec72995 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -26,7 +26,7 @@
 #include <asm/apic.h>
 #endif
 
-static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
+static void early_init_intel(struct cpuinfo_x86 *c)
 {
 	u64 misc_enable;
 
@@ -163,7 +163,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
  *	This is called before we do cpu ident work
  */
 
-int __cpuinit ppro_with_ram_bug(void)
+int ppro_with_ram_bug(void)
 {
 	/* Uses data from early_cpu_detect now */
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
@@ -176,7 +176,7 @@ int __cpuinit ppro_with_ram_bug(void)
 	return 0;
 }
 
-static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
+static void intel_smp_check(struct cpuinfo_x86 *c)
 {
 	/* calling is from identify_secondary_cpu() ? */
 	if (!c->cpu_index)
@@ -196,7 +196,7 @@ static void __cpuinit intel_smp_check(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
+static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 	unsigned long lo, hi;
 
@@ -275,12 +275,12 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	intel_smp_check(c);
 }
 #else
-static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
+static void intel_workarounds(struct cpuinfo_x86 *c)
 {
 }
 #endif
 
-static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
+static void srat_detect_node(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_NUMA
 	unsigned node;
@@ -300,7 +300,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 /*
  * find out the number of processor cores on the die
  */
-static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
+static int intel_num_cpu_cores(struct cpuinfo_x86 *c)
 {
 	unsigned int eax, ebx, ecx, edx;
 
@@ -315,7 +315,7 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
+static void detect_vmx_virtcap(struct cpuinfo_x86 *c)
 {
 	/* Intel VMX MSR indicated features */
 #define X86_VMX_FEATURE_PROC_CTLS_TPR_SHADOW	0x00200000
@@ -353,7 +353,7 @@ static void __cpuinit detect_vmx_virtcap(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_intel(struct cpuinfo_x86 *c)
+static void init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
 
@@ -472,7 +472,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_X86_32
-static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
+static unsigned int intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
 	/*
 	 * Intel PIII Tualatin. This comes in two flavours.
@@ -506,7 +506,7 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned i
 
 #define STLB_4K		0x41
 
-static const struct _tlb_table intel_tlb_table[] __cpuinitconst = {
+static const struct _tlb_table intel_tlb_table[] = {
 	{ 0x01, TLB_INST_4K,		32,	" TLB_INST 4 KByte pages, 4-way set associative" },
 	{ 0x02, TLB_INST_4M,		2,	" TLB_INST 4 MByte pages, full associative" },
 	{ 0x03, TLB_DATA_4K,		64,	" TLB_DATA 4 KByte pages, 4-way set associative" },
@@ -536,7 +536,7 @@ static const struct _tlb_table intel_tlb_table[] __cpuinitconst = {
 	{ 0x00, 0, 0 }
 };
 
-static void __cpuinit intel_tlb_lookup(const unsigned char desc)
+static void intel_tlb_lookup(const unsigned char desc)
 {
 	unsigned char k;
 	if (desc == 0)
@@ -605,7 +605,7 @@ static void __cpuinit intel_tlb_lookup(const unsigned char desc)
 	}
 }
 
-static void __cpuinit intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
+static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 {
 	switch ((c->x86 << 8) + c->x86_model) {
 	case 0x60f: /* original 65 nm celeron/pentium/core2/xeon, "Merom"/"Conroe" */
@@ -634,7 +634,7 @@ static void __cpuinit intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit intel_detect_tlb(struct cpuinfo_x86 *c)
+static void intel_detect_tlb(struct cpuinfo_x86 *c)
 {
 	int i, j, n;
 	unsigned int regs[4];
@@ -661,7 +661,7 @@ static void __cpuinit intel_detect_tlb(struct cpuinfo_x86 *c)
 	intel_tlb_flushall_shift_set(c);
 }
 
-static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
+static const struct cpu_dev intel_cpu_dev = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7c6f7d5..8e2a3b9 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -37,7 +37,7 @@ struct _cache_table {
 /* All the cache descriptor types we care about (no TLB or
    trace cache entries) */
 
-static const struct _cache_table __cpuinitconst cache_table[] =
+static const struct _cache_table cache_table[] =
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
@@ -203,7 +203,7 @@ union l3_cache {
 	unsigned val;
 };
 
-static const unsigned short __cpuinitconst assocs[] = {
+static const unsigned short assocs[] = {
 	[1] = 1,
 	[2] = 2,
 	[4] = 4,
@@ -217,10 +217,10 @@ static const unsigned short __cpuinitconst assocs[] = {
 	[0xf] = 0xffff /* fully associative - no way to show this currently */
 };
 
-static const unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
-static const unsigned char __cpuinitconst types[] = { 1, 2, 3, 3 };
+static const unsigned char levels[] = { 1, 1, 2, 3 };
+static const unsigned char types[] = { 1, 2, 3, 3 };
 
-static void __cpuinit
+static void
 amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		     union _cpuid4_leaf_ebx *ebx,
 		     union _cpuid4_leaf_ecx *ecx)
@@ -302,7 +302,7 @@ struct _cache_attr {
 /*
  * L3 cache descriptors
  */
-static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
+static void amd_calc_l3_indices(struct amd_northbridge *nb)
 {
 	struct amd_l3_cache *l3 = &nb->l3_cache;
 	unsigned int sc0, sc1, sc2, sc3;
@@ -325,7 +325,7 @@ static void __cpuinit amd_calc_l3_indices(struct amd_northbridge *nb)
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
-static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf, int index)
+static void amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf, int index)
 {
 	int node;
 
@@ -528,8 +528,7 @@ static struct _cache_attr subcaches =
 #endif  /* CONFIG_AMD_NB && CONFIG_SYSFS */
 
 static int
-__cpuinit cpuid4_cache_lookup_regs(int index,
-				   struct _cpuid4_info_regs *this_leaf)
+cpuid4_cache_lookup_regs(int index, struct _cpuid4_info_regs *this_leaf)
 {
 	union _cpuid4_leaf_eax	eax;
 	union _cpuid4_leaf_ebx	ebx;
@@ -560,7 +559,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 	return 0;
 }
 
-static int __cpuinit find_num_cache_leaves(struct cpuinfo_x86 *c)
+static int find_num_cache_leaves(struct cpuinfo_x86 *c)
 {
 	unsigned int		eax, ebx, ecx, edx, op;
 	union _cpuid4_leaf_eax	cache_eax;
@@ -580,7 +579,7 @@ static int __cpuinit find_num_cache_leaves(struct cpuinfo_x86 *c)
 	return i;
 }
 
-void __cpuinit init_amd_cacheinfo(struct cpuinfo_x86 *c)
+void init_amd_cacheinfo(struct cpuinfo_x86 *c)
 {
 
 	if (cpu_has_topoext) {
@@ -593,7 +592,7 @@ void __cpuinit init_amd_cacheinfo(struct cpuinfo_x86 *c)
 	}
 }
 
-unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
+unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c)
 {
 	/* Cache sizes */
 	unsigned int trace = 0, l1i = 0, l1d = 0, l2 = 0, l3 = 0;
@@ -746,7 +745,7 @@ static DEFINE_PER_CPU(struct _cpuid4_info *, ici_cpuid4_info);
 
 #ifdef CONFIG_SMP
 
-static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
+static int cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info *this_leaf;
 	int i, sibling;
@@ -795,7 +794,7 @@ static int __cpuinit cache_shared_amd_cpu_map_setup(unsigned int cpu, int index)
 	return 1;
 }
 
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+static void cache_shared_cpu_map_setup(unsigned int cpu, int index)
 {
 	struct _cpuid4_info *this_leaf, *sibling_leaf;
 	unsigned long num_threads_sharing;
@@ -830,7 +829,7 @@ static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
 		}
 	}
 }
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
+static void cache_remove_shared_cpu_map(unsigned int cpu, int index)
 {
 	struct _cpuid4_info	*this_leaf, *sibling_leaf;
 	int sibling;
@@ -843,16 +842,16 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 	}
 }
 #else
-static void __cpuinit cache_shared_cpu_map_setup(unsigned int cpu, int index)
+static void cache_shared_cpu_map_setup(unsigned int cpu, int index)
 {
 }
 
-static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
+static void cache_remove_shared_cpu_map(unsigned int cpu, int index)
 {
 }
 #endif
 
-static void __cpuinit free_cache_attributes(unsigned int cpu)
+static void free_cache_attributes(unsigned int cpu)
 {
 	int i;
 
@@ -863,7 +862,7 @@ static void __cpuinit free_cache_attributes(unsigned int cpu)
 	per_cpu(ici_cpuid4_info, cpu) = NULL;
 }
 
-static void __cpuinit get_cpu_leaves(void *_retval)
+static void get_cpu_leaves(void *_retval)
 {
 	int j, *retval = _retval, cpu = smp_processor_id();
 
@@ -883,7 +882,7 @@ static void __cpuinit get_cpu_leaves(void *_retval)
 	}
 }
 
-static int __cpuinit detect_cache_attributes(unsigned int cpu)
+static int detect_cache_attributes(unsigned int cpu)
 {
 	int			retval;
 
@@ -1017,7 +1016,7 @@ static struct attribute *default_attrs[] = {
 };
 
 #ifdef CONFIG_AMD_NB
-static struct attribute ** __cpuinit amd_l3_attrs(void)
+static struct attribute **amd_l3_attrs(void)
 {
 	static struct attribute **attrs;
 	int n;
@@ -1093,7 +1092,7 @@ static struct kobj_type ktype_percpu_entry = {
 	.sysfs_ops	= &sysfs_ops,
 };
 
-static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
+static void cpuid4_cache_sysfs_exit(unsigned int cpu)
 {
 	kfree(per_cpu(ici_cache_kobject, cpu));
 	kfree(per_cpu(ici_index_kobject, cpu));
@@ -1102,7 +1101,7 @@ static void __cpuinit cpuid4_cache_sysfs_exit(unsigned int cpu)
 	free_cache_attributes(cpu);
 }
 
-static int __cpuinit cpuid4_cache_sysfs_init(unsigned int cpu)
+static int cpuid4_cache_sysfs_init(unsigned int cpu)
 {
 	int err;
 
@@ -1134,7 +1133,7 @@ err_out:
 static DECLARE_BITMAP(cache_dev_map, NR_CPUS);
 
 /* Add/Remove cache interface for CPU device */
-static int __cpuinit cache_add_dev(struct device *dev)
+static int cache_add_dev(struct device *dev)
 {
 	unsigned int cpu = dev->id;
 	unsigned long i, j;
@@ -1185,7 +1184,7 @@ static int __cpuinit cache_add_dev(struct device *dev)
 	return 0;
 }
 
-static void __cpuinit cache_remove_dev(struct device *dev)
+static void cache_remove_dev(struct device *dev)
 {
 	unsigned int cpu = dev->id;
 	unsigned long i;
@@ -1202,8 +1201,8 @@ static void __cpuinit cache_remove_dev(struct device *dev)
 	cpuid4_cache_sysfs_exit(cpu);
 }
 
-static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
-					unsigned long action, void *hcpu)
+static int cacheinfo_cpu_callback(struct notifier_block *nfb,
+				  unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	struct device *dev;
@@ -1222,7 +1221,7 @@ static int __cpuinit cacheinfo_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata cacheinfo_cpu_notifier = {
+static struct notifier_block cacheinfo_cpu_notifier = {
 	.notifier_call = cacheinfo_cpu_callback,
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 9239504..ce660f6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1360,7 +1360,7 @@ int mce_notify_irq(void)
 }
 EXPORT_SYMBOL_GPL(mce_notify_irq);
 
-static int __cpuinit __mcheck_cpu_mce_banks_init(void)
+static int __mcheck_cpu_mce_banks_init(void)
 {
 	int i;
 	u8 num_banks = mca_cfg.banks;
@@ -1381,7 +1381,7 @@ static int __cpuinit __mcheck_cpu_mce_banks_init(void)
 /*
  * Initialize Machine Checks for a CPU.
  */
-static int __cpuinit __mcheck_cpu_cap_init(void)
+static int __mcheck_cpu_cap_init(void)
 {
 	unsigned b;
 	u64 cap;
@@ -1480,7 +1480,7 @@ static void quirk_sandybridge_ifu(int bank, struct mce *m, struct pt_regs *regs)
 }
 
 /* Add per CPU specific workarounds here */
-static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
+static int __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 {
 	struct mca_config *cfg = &mca_cfg;
 
@@ -1590,7 +1590,7 @@ static int __cpuinit __mcheck_cpu_apply_quirks(struct cpuinfo_x86 *c)
 	return 0;
 }
 
-static int __cpuinit __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
+static int __mcheck_cpu_ancient_init(struct cpuinfo_x86 *c)
 {
 	if (c->x86 != 5)
 		return 0;
@@ -1661,7 +1661,7 @@ void (*machine_check_vector)(struct pt_regs *, long error_code) =
  * Called for each booted CPU to set up machine checks.
  * Must be called with preempt off:
  */
-void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
+void mcheck_cpu_init(struct cpuinfo_x86 *c)
 {
 	if (mca_cfg.disabled)
 		return;
@@ -2079,7 +2079,6 @@ static struct bus_type mce_subsys = {
 
 DEFINE_PER_CPU(struct device *, mce_device);
 
-__cpuinitdata
 void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
 static inline struct mce_bank *attr_to_bank(struct device_attribute *attr)
@@ -2225,7 +2224,7 @@ static void mce_device_release(struct device *dev)
 }
 
 /* Per cpu device init. All of the cpus still share the same ctrl bank: */
-static __cpuinit int mce_device_create(unsigned int cpu)
+static int mce_device_create(unsigned int cpu)
 {
 	struct device *dev;
 	int err;
@@ -2271,7 +2270,7 @@ error:
 	return err;
 }
 
-static __cpuinit void mce_device_remove(unsigned int cpu)
+static void mce_device_remove(unsigned int cpu)
 {
 	struct device *dev = per_cpu(mce_device, cpu);
 	int i;
@@ -2291,7 +2290,7 @@ static __cpuinit void mce_device_remove(unsigned int cpu)
 }
 
 /* Make sure there are no machine checks on offlined CPUs. */
-static void __cpuinit mce_disable_cpu(void *h)
+static void mce_disable_cpu(void *h)
 {
 	unsigned long action = *(unsigned long *)h;
 	int i;
@@ -2309,7 +2308,7 @@ static void __cpuinit mce_disable_cpu(void *h)
 	}
 }
 
-static void __cpuinit mce_reenable_cpu(void *h)
+static void mce_reenable_cpu(void *h)
 {
 	unsigned long action = *(unsigned long *)h;
 	int i;
@@ -2328,7 +2327,7 @@ static void __cpuinit mce_reenable_cpu(void *h)
 }
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static int __cpuinit
+static int
 mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
@@ -2364,7 +2363,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
 	return NOTIFY_OK;
 }
 
-static struct notifier_block mce_cpu_notifier __cpuinitdata = {
+static struct notifier_block mce_cpu_notifier = {
 	.notifier_call = mce_cpu_callback,
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 9cb5276..603df4f 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -458,10 +458,8 @@ static struct kobj_type threshold_ktype = {
 	.default_attrs		= default_attrs,
 };
 
-static __cpuinit int allocate_threshold_blocks(unsigned int cpu,
-					       unsigned int bank,
-					       unsigned int block,
-					       u32 address)
+static int allocate_threshold_blocks(unsigned int cpu, unsigned int bank,
+				     unsigned int block, u32 address)
 {
 	struct threshold_block *b = NULL;
 	u32 low, high;
@@ -543,7 +541,7 @@ out_free:
 	return err;
 }
 
-static __cpuinit int __threshold_add_blocks(struct threshold_bank *b)
+static int __threshold_add_blocks(struct threshold_bank *b)
 {
 	struct list_head *head = &b->blocks->miscj;
 	struct threshold_block *pos = NULL;
@@ -567,7 +565,7 @@ static __cpuinit int __threshold_add_blocks(struct threshold_bank *b)
 	return err;
 }
 
-static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
+static int threshold_create_bank(unsigned int cpu, unsigned int bank)
 {
 	struct device *dev = per_cpu(mce_device, cpu);
 	struct amd_northbridge *nb = NULL;
@@ -632,7 +630,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 }
 
 /* create dir/files for all valid threshold banks */
-static __cpuinit int threshold_create_device(unsigned int cpu)
+static int threshold_create_device(unsigned int cpu)
 {
 	unsigned int bank;
 	struct threshold_bank **bp;
@@ -736,7 +734,7 @@ static void threshold_remove_device(unsigned int cpu)
 }
 
 /* get notified when a cpu comes on/off */
-static void __cpuinit
+static void
 amd_64_threshold_cpu_callback(unsigned long action, unsigned int cpu)
 {
 	switch (action) {
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 6d10fbf..c4f3453 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -239,8 +239,7 @@ __setup("int_pln_enable", int_pln_enable_setup);
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct device *dev,
-				unsigned int cpu)
+static int thermal_throttle_add_dev(struct device *dev, unsigned int cpu)
 {
 	int err;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
@@ -266,7 +265,7 @@ static __cpuinit int thermal_throttle_add_dev(struct device *dev,
 	return err;
 }
 
-static __cpuinit void thermal_throttle_remove_dev(struct device *dev)
+static void thermal_throttle_remove_dev(struct device *dev)
 {
 	sysfs_remove_group(&dev->kobj, &thermal_attr_group);
 }
@@ -275,7 +274,7 @@ static __cpuinit void thermal_throttle_remove_dev(struct device *dev)
 static DEFINE_MUTEX(therm_cpu_lock);
 
 /* Get notified when a cpu comes on/off. Be hotplug friendly. */
-static __cpuinit int
+static int
 thermal_throttle_cpu_callback(struct notifier_block *nfb,
 			      unsigned long action,
 			      void *hcpu)
@@ -306,7 +305,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	return notifier_from_errno(err);
 }
 
-static struct notifier_block thermal_throttle_cpu_notifier __cpuinitdata =
+static struct notifier_block thermal_throttle_cpu_notifier =
 {
 	.notifier_call = thermal_throttle_cpu_callback,
 };
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index ab33952..0bfb4d8 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1261,7 +1261,7 @@ perf_event_nmi_handler(unsigned int cmd, struct pt_regs *regs)
 struct event_constraint emptyconstraint;
 struct event_constraint unconstrained;
 
-static int __cpuinit
+static int
 x86_pmu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index 5f0581e..e09f0bf 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -851,7 +851,7 @@ static void clear_APIC_ibs(void *dummy)
 		setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_FIX, 1);
 }
 
-static int __cpuinit
+static int
 perf_ibs_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
diff --git a/arch/x86/kernel/cpu/perf_event_amd_uncore.c b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
index c0c661a..754291a 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_uncore.c
@@ -288,13 +288,13 @@ static struct pmu amd_l2_pmu = {
 	.read		= amd_uncore_read,
 };
 
-static struct amd_uncore * __cpuinit amd_uncore_alloc(unsigned int cpu)
+static struct amd_uncore *amd_uncore_alloc(unsigned int cpu)
 {
 	return kzalloc_node(sizeof(struct amd_uncore), GFP_KERNEL,
 			cpu_to_node(cpu));
 }
 
-static void __cpuinit amd_uncore_cpu_up_prepare(unsigned int cpu)
+static void amd_uncore_cpu_up_prepare(unsigned int cpu)
 {
 	struct amd_uncore *uncore;
 
@@ -322,8 +322,8 @@ static void __cpuinit amd_uncore_cpu_up_prepare(unsigned int cpu)
 }
 
 static struct amd_uncore *
-__cpuinit amd_uncore_find_online_sibling(struct amd_uncore *this,
-					 struct amd_uncore * __percpu *uncores)
+amd_uncore_find_online_sibling(struct amd_uncore *this,
+			       struct amd_uncore * __percpu *uncores)
 {
 	unsigned int cpu;
 	struct amd_uncore *that;
@@ -348,7 +348,7 @@ __cpuinit amd_uncore_find_online_sibling(struct amd_uncore *this,
 	return this;
 }
 
-static void __cpuinit amd_uncore_cpu_starting(unsigned int cpu)
+static void amd_uncore_cpu_starting(unsigned int cpu)
 {
 	unsigned int eax, ebx, ecx, edx;
 	struct amd_uncore *uncore;
@@ -376,8 +376,8 @@ static void __cpuinit amd_uncore_cpu_starting(unsigned int cpu)
 	}
 }
 
-static void __cpuinit uncore_online(unsigned int cpu,
-				    struct amd_uncore * __percpu *uncores)
+static void uncore_online(unsigned int cpu,
+			  struct amd_uncore * __percpu *uncores)
 {
 	struct amd_uncore *uncore = *per_cpu_ptr(uncores, cpu);
 
@@ -388,7 +388,7 @@ static void __cpuinit uncore_online(unsigned int cpu,
 		cpumask_set_cpu(cpu, uncore->active_mask);
 }
 
-static void __cpuinit amd_uncore_cpu_online(unsigned int cpu)
+static void amd_uncore_cpu_online(unsigned int cpu)
 {
 	if (amd_uncore_nb)
 		uncore_online(cpu, amd_uncore_nb);
@@ -397,8 +397,8 @@ static void __cpuinit amd_uncore_cpu_online(unsigned int cpu)
 		uncore_online(cpu, amd_uncore_l2);
 }
 
-static void __cpuinit uncore_down_prepare(unsigned int cpu,
-					  struct amd_uncore * __percpu *uncores)
+static void uncore_down_prepare(unsigned int cpu,
+				struct amd_uncore * __percpu *uncores)
 {
 	unsigned int i;
 	struct amd_uncore *this = *per_cpu_ptr(uncores, cpu);
@@ -423,7 +423,7 @@ static void __cpuinit uncore_down_prepare(unsigned int cpu,
 	}
 }
 
-static void __cpuinit amd_uncore_cpu_down_prepare(unsigned int cpu)
+static void amd_uncore_cpu_down_prepare(unsigned int cpu)
 {
 	if (amd_uncore_nb)
 		uncore_down_prepare(cpu, amd_uncore_nb);
@@ -432,8 +432,7 @@ static void __cpuinit amd_uncore_cpu_down_prepare(unsigned int cpu)
 		uncore_down_prepare(cpu, amd_uncore_l2);
 }
 
-static void __cpuinit uncore_dead(unsigned int cpu,
-				  struct amd_uncore * __percpu *uncores)
+static void uncore_dead(unsigned int cpu, struct amd_uncore * __percpu *uncores)
 {
 	struct amd_uncore *uncore = *per_cpu_ptr(uncores, cpu);
 
@@ -445,7 +444,7 @@ static void __cpuinit uncore_dead(unsigned int cpu,
 	*per_cpu_ptr(amd_uncore_nb, cpu) = NULL;
 }
 
-static void __cpuinit amd_uncore_cpu_dead(unsigned int cpu)
+static void amd_uncore_cpu_dead(unsigned int cpu)
 {
 	if (amd_uncore_nb)
 		uncore_dead(cpu, amd_uncore_nb);
@@ -454,7 +453,7 @@ static void __cpuinit amd_uncore_cpu_dead(unsigned int cpu)
 		uncore_dead(cpu, amd_uncore_l2);
 }
 
-static int __cpuinit
+static int
 amd_uncore_cpu_notifier(struct notifier_block *self, unsigned long action,
 			void *hcpu)
 {
@@ -489,7 +488,7 @@ amd_uncore_cpu_notifier(struct notifier_block *self, unsigned long action,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block amd_uncore_cpu_notifier_block __cpuinitdata = {
+static struct notifier_block amd_uncore_cpu_notifier_block = {
 	.notifier_call	= amd_uncore_cpu_notifier,
 	.priority	= CPU_PRI_PERF + 1,
 };
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 9dd9975..cad791d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3297,7 +3297,7 @@ static void __init uncore_pci_exit(void)
 /* CPU hot plug/unplug are serialized by cpu_add_remove_lock mutex */
 static LIST_HEAD(boxes_to_free);
 
-static void __cpuinit uncore_kfree_boxes(void)
+static void uncore_kfree_boxes(void)
 {
 	struct intel_uncore_box *box;
 
@@ -3309,7 +3309,7 @@ static void __cpuinit uncore_kfree_boxes(void)
 	}
 }
 
-static void __cpuinit uncore_cpu_dying(int cpu)
+static void uncore_cpu_dying(int cpu)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
@@ -3328,7 +3328,7 @@ static void __cpuinit uncore_cpu_dying(int cpu)
 	}
 }
 
-static int __cpuinit uncore_cpu_starting(int cpu)
+static int uncore_cpu_starting(int cpu)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
@@ -3371,7 +3371,7 @@ static int __cpuinit uncore_cpu_starting(int cpu)
 	return 0;
 }
 
-static int __cpuinit uncore_cpu_prepare(int cpu, int phys_id)
+static int uncore_cpu_prepare(int cpu, int phys_id)
 {
 	struct intel_uncore_type *type;
 	struct intel_uncore_pmu *pmu;
@@ -3397,7 +3397,7 @@ static int __cpuinit uncore_cpu_prepare(int cpu, int phys_id)
 	return 0;
 }
 
-static void __cpuinit
+static void
 uncore_change_context(struct intel_uncore_type **uncores, int old_cpu, int new_cpu)
 {
 	struct intel_uncore_type *type;
@@ -3435,7 +3435,7 @@ uncore_change_context(struct intel_uncore_type **uncores, int old_cpu, int new_c
 	}
 }
 
-static void __cpuinit uncore_event_exit_cpu(int cpu)
+static void uncore_event_exit_cpu(int cpu)
 {
 	int i, phys_id, target;
 
@@ -3463,7 +3463,7 @@ static void __cpuinit uncore_event_exit_cpu(int cpu)
 	uncore_change_context(pci_uncores, cpu, target);
 }
 
-static void __cpuinit uncore_event_init_cpu(int cpu)
+static void uncore_event_init_cpu(int cpu)
 {
 	int i, phys_id;
 
@@ -3479,8 +3479,8 @@ static void __cpuinit uncore_event_init_cpu(int cpu)
 	uncore_change_context(pci_uncores, -1, cpu);
 }
 
-static int
- __cpuinit uncore_cpu_notifier(struct notifier_block *self, unsigned long action, void *hcpu)
+static int uncore_cpu_notifier(struct notifier_block *self,
+			       unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (long)hcpu;
 
@@ -3520,7 +3520,7 @@ static int
 	return NOTIFY_OK;
 }
 
-static struct notifier_block uncore_cpu_nb __cpuinitdata = {
+static struct notifier_block uncore_cpu_nb = {
 	.notifier_call	= uncore_cpu_notifier,
 	/*
 	 * to migrate uncore events, our notifier should be executed
diff --git a/arch/x86/kernel/cpu/rdrand.c b/arch/x86/kernel/cpu/rdrand.c
index feca286..88db010 100644
--- a/arch/x86/kernel/cpu/rdrand.c
+++ b/arch/x86/kernel/cpu/rdrand.c
@@ -52,7 +52,7 @@ static inline int rdrand_long(unsigned long *v)
  */
 #define RESEED_LOOP ((512*128)/sizeof(unsigned long))
 
-void __cpuinit x86_init_rdrand(struct cpuinfo_x86 *c)
+void x86_init_rdrand(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_ARCH_RANDOM
 	unsigned long tmp;
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index d92b5da..f2cc63e 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -24,13 +24,13 @@ enum cpuid_regs {
 	CR_EBX
 };
 
-void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
+void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 {
 	u32 max_level;
 	u32 regs[4];
 	const struct cpuid_bit *cb;
 
-	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
+	static const struct cpuid_bit cpuid_bits[] = {
 		{ X86_FEATURE_DTHERM,		CR_EAX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_IDA,		CR_EAX, 1, 0x00000006, 0 },
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
diff --git a/arch/x86/kernel/cpu/topology.c b/arch/x86/kernel/cpu/topology.c
index 4397e98..4c60eaf 100644
--- a/arch/x86/kernel/cpu/topology.c
+++ b/arch/x86/kernel/cpu/topology.c
@@ -26,7 +26,7 @@
  * exists, use it for populating initial_apicid and cpu topology
  * detection.
  */
-void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
+void detect_extended_topology(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned int eax, ebx, ecx, edx, sub_index;
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 2800074..aa0430d 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -5,7 +5,7 @@
 #include <asm/msr.h>
 #include "cpu.h"
 
-static void __cpuinit early_init_transmeta(struct cpuinfo_x86 *c)
+static void early_init_transmeta(struct cpuinfo_x86 *c)
 {
 	u32 xlvl;
 
@@ -17,7 +17,7 @@ static void __cpuinit early_init_transmeta(struct cpuinfo_x86 *c)
 	}
 }
 
-static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
+static void init_transmeta(struct cpuinfo_x86 *c)
 {
 	unsigned int cap_mask, uk, max, dummy;
 	unsigned int cms_rev1, cms_rev2;
@@ -98,7 +98,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 #endif
 }
 
-static const struct cpu_dev __cpuinitconst transmeta_cpu_dev = {
+static const struct cpu_dev transmeta_cpu_dev = {
 	.c_vendor	= "Transmeta",
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
 	.c_early_init	= early_init_transmeta,
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index fd2c37b..202759a 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -8,7 +8,7 @@
  * so no special init takes place.
  */
 
-static const struct cpu_dev __cpuinitconst umc_cpu_dev = {
+static const struct cpu_dev umc_cpu_dev = {
 	.c_vendor	= "UMC",
 	.c_ident	= { "UMC UMC UMC" },
 	.c_models = {
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 03a3632..7076878 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -122,7 +122,7 @@ static bool __init vmware_platform(void)
  * so that the kernel could just trust the hypervisor with providing a
  * reliable virtual TSC that is suitable for timekeeping.
  */
-static void __cpuinit vmware_set_cpu_features(struct cpuinfo_x86 *c)
+static void vmware_set_cpu_features(struct cpuinfo_x86 *c)
 {
 	set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
 	set_cpu_cap(c, X86_FEATURE_TSC_RELIABLE);
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 1e4dbcf..7d9481c 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -137,7 +137,7 @@ static const struct file_operations cpuid_fops = {
 	.open = cpuid_open,
 };
 
-static __cpuinit int cpuid_device_create(int cpu)
+static int cpuid_device_create(int cpu)
 {
 	struct device *dev;
 
@@ -151,9 +151,8 @@ static void cpuid_device_destroy(int cpu)
 	device_destroy(cpuid_class, MKDEV(CPUID_MAJOR, cpu));
 }
 
-static int __cpuinit cpuid_class_cpu_callback(struct notifier_block *nfb,
-					      unsigned long action,
-					      void *hcpu)
+static int cpuid_class_cpu_callback(struct notifier_block *nfb,
+				    unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	int err = 0;
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 4934890..69eb2fa 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -133,7 +133,7 @@ static void x86_of_pci_irq_disable(struct pci_dev *dev)
 {
 }
 
-void __cpuinit x86_of_pci_init(void)
+void x86_of_pci_init(void)
 {
 	pcibios_enable_irq = x86_of_pci_irq_enable;
 	pcibios_disable_irq = x86_of_pci_irq_disable;
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index e65ddc6..5dd87a8 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -292,7 +292,6 @@ ENDPROC(start_cpu0)
  * If cpu hotplug is not supported then this code can go in init section
  * which will be freed later
  */
-__CPUINIT
 ENTRY(startup_32_smp)
 	cld
 	movl $(__BOOT_DS),%eax
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index b627746..573bcb3 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -108,9 +108,9 @@ EXPORT_SYMBOL(unlazy_fpu);
 unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
 unsigned int xstate_size;
 EXPORT_SYMBOL_GPL(xstate_size);
-static struct i387_fxsave_struct fx_scratch __cpuinitdata;
+static struct i387_fxsave_struct fx_scratch;
 
-static void __cpuinit mxcsr_feature_mask_init(void)
+static void mxcsr_feature_mask_init(void)
 {
 	unsigned long mask = 0;
 
@@ -124,7 +124,7 @@ static void __cpuinit mxcsr_feature_mask_init(void)
 	mxcsr_feature_mask &= mask;
 }
 
-static void __cpuinit init_thread_xstate(void)
+static void init_thread_xstate(void)
 {
 	/*
 	 * Note that xstate_size might be overwriten later during
@@ -153,7 +153,7 @@ static void __cpuinit init_thread_xstate(void)
  * into all processes.
  */
 
-void __cpuinit fpu_init(void)
+void fpu_init(void)
 {
 	unsigned long cr0;
 	unsigned long cr4_mask = 0;
diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
index 344faf8..4186755 100644
--- a/arch/x86/kernel/irq_32.c
+++ b/arch/x86/kernel/irq_32.c
@@ -119,7 +119,7 @@ execute_on_irq_stack(int overflow, struct irq_desc *desc, int irq)
 /*
  * allocate per-cpu stacks for hardirq and for softirq processing
  */
-void __cpuinit irq_ctx_init(int cpu)
+void irq_ctx_init(int cpu)
 {
 	union irq_ctx *irqctx;
 
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index cd6d9a5..a96d32c 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -320,7 +320,7 @@ static void kvm_guest_apic_eoi_write(u32 reg, u32 val)
 	apic_write(APIC_EOI, APIC_EOI_ACK);
 }
 
-void __cpuinit kvm_guest_cpu_init(void)
+void kvm_guest_cpu_init(void)
 {
 	if (!kvm_para_available())
 		return;
@@ -421,7 +421,7 @@ static void __init kvm_smp_prepare_boot_cpu(void)
 	native_smp_prepare_boot_cpu();
 }
 
-static void __cpuinit kvm_guest_cpu_online(void *dummy)
+static void kvm_guest_cpu_online(void *dummy)
 {
 	kvm_guest_cpu_init();
 }
@@ -435,8 +435,8 @@ static void kvm_guest_cpu_offline(void *dummy)
 	apf_task_wake_all();
 }
 
-static int __cpuinit kvm_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
+static int kvm_cpu_notify(struct notifier_block *self, unsigned long action,
+			  void *hcpu)
 {
 	int cpu = (unsigned long)hcpu;
 	switch (action) {
@@ -455,7 +455,7 @@ static int __cpuinit kvm_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata kvm_cpu_notifier = {
+static struct notifier_block kvm_cpu_notifier = {
         .notifier_call  = kvm_cpu_notify,
 };
 #endif
diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 1f354f4..1570e07 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -182,7 +182,7 @@ static void kvm_restore_sched_clock_state(void)
 }
 
 #ifdef CONFIG_X86_LOCAL_APIC
-static void __cpuinit kvm_setup_secondary_clock(void)
+static void kvm_setup_secondary_clock(void)
 {
 	/*
 	 * Now that the first cpu already had this clocksource initialized,
diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
index 22db92b..15c9876 100644
--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -468,7 +468,7 @@ static struct syscore_ops mc_syscore_ops = {
 	.resume			= mc_bp_resume,
 };
 
-static __cpuinit int
+static int
 mc_cpu_callback(struct notifier_block *nb, unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
diff --git a/arch/x86/kernel/microcode_core_early.c b/arch/x86/kernel/microcode_core_early.c
index 86119f6..be7f851 100644
--- a/arch/x86/kernel/microcode_core_early.c
+++ b/arch/x86/kernel/microcode_core_early.c
@@ -41,7 +41,7 @@
  *
  * x86_vendor() gets vendor information directly through cpuid.
  */
-static int __cpuinit x86_vendor(void)
+static int x86_vendor(void)
 {
 	u32 eax = 0x00000000;
 	u32 ebx, ecx = 0, edx;
@@ -57,7 +57,7 @@ static int __cpuinit x86_vendor(void)
 	return X86_VENDOR_UNKNOWN;
 }
 
-static int __cpuinit x86_family(void)
+static int x86_family(void)
 {
 	u32 eax = 0x00000001;
 	u32 ebx, ecx = 0, edx;
@@ -96,7 +96,7 @@ void __init load_ucode_bsp(void)
 	}
 }
 
-void __cpuinit load_ucode_ap(void)
+void load_ucode_ap(void)
 {
 	int vendor, x86;
 
diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index dabef95..1575deb 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -34,7 +34,7 @@ struct mc_saved_data {
 	struct microcode_intel **mc_saved;
 } mc_saved_data;
 
-static enum ucode_state __cpuinit
+static enum ucode_state
 generic_load_microcode_early(struct microcode_intel **mc_saved_p,
 			     unsigned int mc_saved_count,
 			     struct ucode_cpu_info *uci)
@@ -69,7 +69,7 @@ out:
 	return state;
 }
 
-static void __cpuinit
+static void
 microcode_pointer(struct microcode_intel **mc_saved,
 		  unsigned long *mc_saved_in_initrd,
 		  unsigned long initrd_start, int mc_saved_count)
@@ -82,7 +82,7 @@ microcode_pointer(struct microcode_intel **mc_saved,
 }
 
 #ifdef CONFIG_X86_32
-static void __cpuinit
+static void
 microcode_phys(struct microcode_intel **mc_saved_tmp,
 	       struct mc_saved_data *mc_saved_data)
 {
@@ -101,7 +101,7 @@ microcode_phys(struct microcode_intel **mc_saved_tmp,
 }
 #endif
 
-static enum ucode_state __cpuinit
+static enum ucode_state
 load_microcode(struct mc_saved_data *mc_saved_data,
 	       unsigned long *mc_saved_in_initrd,
 	       unsigned long initrd_start,
@@ -375,7 +375,7 @@ do {						\
 #define native_wrmsr(msr, low, high)		\
 	native_write_msr(msr, low, high);
 
-static int __cpuinit collect_cpu_info_early(struct ucode_cpu_info *uci)
+static int collect_cpu_info_early(struct ucode_cpu_info *uci)
 {
 	unsigned int val[2];
 	u8 x86, x86_model;
@@ -584,7 +584,7 @@ scan_microcode(unsigned long start, unsigned long end,
 /*
  * Print ucode update info.
  */
-static void __cpuinit
+static void
 print_ucode_info(struct ucode_cpu_info *uci, unsigned int date)
 {
 	int cpu = smp_processor_id();
@@ -605,7 +605,7 @@ static int current_mc_date;
 /*
  * Print early updated ucode info after printk works. This is delayed info dump.
  */
-void __cpuinit show_ucode_info_early(void)
+void show_ucode_info_early(void)
 {
 	struct ucode_cpu_info uci;
 
@@ -621,7 +621,7 @@ void __cpuinit show_ucode_info_early(void)
  * mc_saved_data.mc_saved and delay printing microcode info in
  * show_ucode_info_early() until printk() works.
  */
-static void __cpuinit print_ucode(struct ucode_cpu_info *uci)
+static void print_ucode(struct ucode_cpu_info *uci)
 {
 	struct microcode_intel *mc_intel;
 	int *delay_ucode_info_p;
@@ -643,12 +643,12 @@ static void __cpuinit print_ucode(struct ucode_cpu_info *uci)
  * Flush global tlb. We only do this in x86_64 where paging has been enabled
  * already and PGE should be enabled as well.
  */
-static inline void __cpuinit flush_tlb_early(void)
+static inline void flush_tlb_early(void)
 {
 	__native_flush_tlb_global_irq_disabled();
 }
 
-static inline void __cpuinit print_ucode(struct ucode_cpu_info *uci)
+static inline void print_ucode(struct ucode_cpu_info *uci)
 {
 	struct microcode_intel *mc_intel;
 
@@ -660,8 +660,8 @@ static inline void __cpuinit print_ucode(struct ucode_cpu_info *uci)
 }
 #endif
 
-static int __cpuinit apply_microcode_early(struct mc_saved_data *mc_saved_data,
-					   struct ucode_cpu_info *uci)
+static int apply_microcode_early(struct mc_saved_data *mc_saved_data,
+				 struct ucode_cpu_info *uci)
 {
 	struct microcode_intel *mc_intel;
 	unsigned int val[2];
@@ -763,7 +763,7 @@ load_ucode_intel_bsp(void)
 #endif
 }
 
-void __cpuinit load_ucode_intel_ap(void)
+void load_ucode_intel_ap(void)
 {
 	struct mc_saved_data *mc_saved_data_p;
 	struct ucode_cpu_info uci;
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index ac861b8..f4c886d 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -24,14 +24,14 @@ struct pci_hostbridge_probe {
 	u32 device;
 };
 
-static u64 __cpuinitdata fam10h_pci_mmconf_base;
+static u64 fam10h_pci_mmconf_base;
 
-static struct pci_hostbridge_probe pci_probes[] __cpuinitdata = {
+static struct pci_hostbridge_probe pci_probes[] = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
 	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
 };
 
-static int __cpuinit cmp_range(const void *x1, const void *x2)
+static int cmp_range(const void *x1, const void *x2)
 {
 	const struct range *r1 = x1;
 	const struct range *r2 = x2;
@@ -49,7 +49,7 @@ static int __cpuinit cmp_range(const void *x1, const void *x2)
 /* need to avoid (0xfd<<32), (0xfe<<32), and (0xff<<32), ht used space */
 #define FAM10H_PCI_MMCONF_BASE (0xfcULL<<32)
 #define BASE_VALID(b) ((b) + MMCONF_SIZE <= (0xfdULL<<32) || (b) >= (1ULL<<40))
-static void __cpuinit get_fam10h_pci_mmconf_base(void)
+static void get_fam10h_pci_mmconf_base(void)
 {
 	int i;
 	unsigned bus;
@@ -166,7 +166,7 @@ out:
 	fam10h_pci_mmconf_base = base;
 }
 
-void __cpuinit fam10h_check_enable_mmcfg(void)
+void fam10h_check_enable_mmcfg(void)
 {
 	u64 val;
 	u32 address;
@@ -230,7 +230,7 @@ static const struct dmi_system_id __initconst mmconf_dmi_table[] = {
 	{}
 };
 
-/* Called from a __cpuinit function, but only on the BSP. */
+/* Called from a non __init function, but only on the BSP. */
 void __ref check_enable_amd_mmconf_dmi(void)
 {
 	dmi_check_system(mmconf_dmi_table);
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index ce13049..88458fa 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -200,7 +200,7 @@ static const struct file_operations msr_fops = {
 	.compat_ioctl = msr_ioctl,
 };
 
-static int __cpuinit msr_device_create(int cpu)
+static int msr_device_create(int cpu)
 {
 	struct device *dev;
 
@@ -214,8 +214,8 @@ static void msr_device_destroy(int cpu)
 	device_destroy(msr_class, MKDEV(MSR_MAJOR, cpu));
 }
 
-static int __cpuinit msr_class_cpu_callback(struct notifier_block *nfb,
-				unsigned long action, void *hcpu)
+static int msr_class_cpu_callback(struct notifier_block *nfb,
+				  unsigned long action, void *hcpu)
 {
 	unsigned int cpu = (unsigned long)hcpu;
 	int err = 0;
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 81a5f5e..83369e5 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -398,7 +398,7 @@ static void amd_e400_idle(void)
 		default_idle();
 }
 
-void __cpuinit select_idle_routine(const struct cpuinfo_x86 *c)
+void select_idle_routine(const struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	if (boot_option_idle_override == IDLE_POLL && smp_num_siblings > 1)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e68709d..f8ec578 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -170,7 +170,7 @@ static struct resource bss_resource = {
 
 #ifdef CONFIG_X86_32
 /* cpu data as detected by the assembly code in head.S */
-struct cpuinfo_x86 new_cpu_data __cpuinitdata = {
+struct cpuinfo_x86 new_cpu_data = {
 	.wp_works_ok = -1,
 };
 /* common cpu data for all cpus */
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bfd348e..aecc98a 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -130,7 +130,7 @@ atomic_t init_deasserted;
  * Report back to the Boot Processor during boot time or to the caller processor
  * during CPU online.
  */
-static void __cpuinit smp_callin(void)
+static void smp_callin(void)
 {
 	int cpuid, phys_id;
 	unsigned long timeout;
@@ -237,7 +237,7 @@ static int enable_start_cpu0;
 /*
  * Activate a secondary processor.
  */
-notrace static void __cpuinit start_secondary(void *unused)
+static void notrace start_secondary(void *unused)
 {
 	/*
 	 * Don't put *anything* before cpu_init(), SMP booting is too
@@ -300,7 +300,7 @@ void __init smp_store_boot_cpu_info(void)
  * The bootstrap kernel entry code has set these up. Save them for
  * a given CPU
  */
-void __cpuinit smp_store_cpu_info(int id)
+void smp_store_cpu_info(int id)
 {
 	struct cpuinfo_x86 *c = &cpu_data(id);
 
@@ -313,7 +313,7 @@ void __cpuinit smp_store_cpu_info(int id)
 	identify_secondary_cpu(c);
 }
 
-static bool __cpuinit
+static bool
 topology_sane(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o, const char *name)
 {
 	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
@@ -330,7 +330,7 @@ do {									\
 	cpumask_set_cpu((c2), cpu_##_m##_mask(c1));			\
 } while (0)
 
-static bool __cpuinit match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+static bool match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
 	if (cpu_has_topoext) {
 		int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
@@ -348,7 +348,7 @@ static bool __cpuinit match_smt(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 	return false;
 }
 
-static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
 	int cpu1 = c->cpu_index, cpu2 = o->cpu_index;
 
@@ -359,7 +359,7 @@ static bool __cpuinit match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 	return false;
 }
 
-static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
+static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
 	if (c->phys_proc_id == o->phys_proc_id) {
 		if (cpu_has(c, X86_FEATURE_AMD_DCM))
@@ -370,7 +370,7 @@ static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 	return false;
 }
 
-void __cpuinit set_cpu_sibling_map(int cpu)
+void set_cpu_sibling_map(int cpu)
 {
 	bool has_smt = smp_num_siblings > 1;
 	bool has_mp = has_smt || boot_cpu_data.x86_max_cores > 1;
@@ -499,7 +499,7 @@ void __inquire_remote_apic(int apicid)
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-int __cpuinit
+int
 wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -533,7 +533,7 @@ wakeup_secondary_cpu_via_nmi(int apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
-static int __cpuinit
+static int
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -649,7 +649,7 @@ wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 }
 
 /* reduce the number of lines printed when booting a large cpu count system */
-static void __cpuinit announce_cpu(int cpu, int apicid)
+static void announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
 	int node = early_cpu_to_node(cpu);
@@ -691,7 +691,7 @@ static int wakeup_cpu0_nmi(unsigned int cmd, struct pt_regs *regs)
  * We'll change this code in the future to wake up hard offlined CPU0 if
  * real platform and request are available.
  */
-static int __cpuinit
+static int
 wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
 	       int *cpu0_nmi_registered)
 {
@@ -731,7 +731,7 @@ wakeup_cpu_via_init_nmi(int cpu, unsigned long start_ip, int apicid,
  * Returns zero if CPU booted OK, else error code from
  * ->wakeup_secondary_cpu.
  */
-static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
+static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 {
 	volatile u32 *trampoline_status =
 		(volatile u32 *) __va(real_mode_header->trampoline_status);
@@ -872,7 +872,7 @@ static int __cpuinit do_boot_cpu(int apicid, int cpu, struct task_struct *idle)
 	return boot_error;
 }
 
-int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int apicid = apic->cpu_present_to_apicid(cpu);
 	unsigned long flags;
diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index f84fe00..088681d 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -319,8 +319,8 @@ static int tboot_wait_for_aps(int num_aps)
 	return !(atomic_read((atomic_t *)&tboot->num_in_wfs) == num_aps);
 }
 
-static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,
-			unsigned long action, void *hcpu)
+static int tboot_cpu_callback(struct notifier_block *nfb, unsigned long action,
+			      void *hcpu)
 {
 	switch (action) {
 	case CPU_DYING:
@@ -333,7 +333,7 @@ static int __cpuinit tboot_cpu_callback(struct notifier_block *nfb,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block tboot_cpu_notifier __cpuinitdata =
+static struct notifier_block tboot_cpu_notifier =
 {
 	.notifier_call = tboot_cpu_callback,
 };
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 098b3cf..6ff4924 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -824,7 +824,7 @@ static void __init check_system_tsc_reliable(void)
  * Make an educated guess if the TSC is trustworthy and synchronized
  * over all CPUs.
  */
-__cpuinit int unsynchronized_tsc(void)
+int unsynchronized_tsc(void)
 {
 	if (!cpu_has_tsc || tsc_unstable)
 		return 1;
@@ -1020,7 +1020,7 @@ void __init tsc_init(void)
  * been calibrated. This assumes that CONSTANT_TSC applies to all
  * cpus in the socket - this should be a safe assumption.
  */
-unsigned long __cpuinit calibrate_delay_is_known(void)
+unsigned long calibrate_delay_is_known(void)
 {
 	int i, cpu = smp_processor_id();
 
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index fc25e60..adfdf56 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -25,24 +25,24 @@
  * Entry/exit counters that make sure that both CPUs
  * run the measurement code at once:
  */
-static __cpuinitdata atomic_t start_count;
-static __cpuinitdata atomic_t stop_count;
+static atomic_t start_count;
+static atomic_t stop_count;
 
 /*
  * We use a raw spinlock in this exceptional case, because
  * we want to have the fastest, inlined, non-debug version
  * of a critical section, to be able to prove TSC time-warps:
  */
-static __cpuinitdata arch_spinlock_t sync_lock = __ARCH_SPIN_LOCK_UNLOCKED;
+static arch_spinlock_t sync_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 
-static __cpuinitdata cycles_t last_tsc;
-static __cpuinitdata cycles_t max_warp;
-static __cpuinitdata int nr_warps;
+static cycles_t last_tsc;
+static cycles_t max_warp;
+static int nr_warps;
 
 /*
  * TSC-warp measurement loop running on both CPUs:
  */
-static __cpuinit void check_tsc_warp(unsigned int timeout)
+static void check_tsc_warp(unsigned int timeout)
 {
 	cycles_t start, now, prev, end;
 	int i;
@@ -121,7 +121,7 @@ static inline unsigned int loop_timeout(int cpu)
  * Source CPU calls into this - it waits for the freshly booted
  * target CPU to arrive and then starts the measurement:
  */
-void __cpuinit check_tsc_sync_source(int cpu)
+void check_tsc_sync_source(int cpu)
 {
 	int cpus = 2;
 
@@ -187,7 +187,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 /*
  * Freshly booted CPUs call into this:
  */
-void __cpuinit check_tsc_sync_target(void)
+void check_tsc_sync_target(void)
 {
 	int cpus = 2;
 
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 9a907a6..1f96f93 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -331,7 +331,7 @@ sigsegv:
  * Assume __initcall executes before all user space. Hopefully kmod
  * doesn't violate that. We'll find out if it does.
  */
-static void __cpuinit vsyscall_set_cpu(int cpu)
+static void vsyscall_set_cpu(int cpu)
 {
 	unsigned long d;
 	unsigned long node = 0;
@@ -353,13 +353,13 @@ static void __cpuinit vsyscall_set_cpu(int cpu)
 	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PER_CPU, &d, DESCTYPE_S);
 }
 
-static void __cpuinit cpu_vsyscall_init(void *arg)
+static void cpu_vsyscall_init(void *arg)
 {
 	/* preemption should be already off */
 	vsyscall_set_cpu(raw_smp_processor_id());
 }
 
-static int __cpuinit
+static int
 cpu_vsyscall_notifier(struct notifier_block *n, unsigned long action, void *arg)
 {
 	long cpu = (long)arg;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 45a14db..5f24c71 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -25,7 +25,7 @@
 #include <asm/iommu.h>
 #include <asm/mach_traps.h>
 
-void __cpuinit x86_init_noop(void) { }
+void x86_init_noop(void) { }
 void __init x86_init_uint_noop(unsigned int unused) { }
 int __init iommu_init_noop(void) { return 0; }
 void iommu_shutdown_noop(void) { }
@@ -85,7 +85,7 @@ struct x86_init_ops x86_init __initdata = {
 	},
 };
 
-struct x86_cpuinit_ops x86_cpuinit __cpuinitdata = {
+struct x86_cpuinit_ops x86_cpuinit = {
 	.early_percpu_clock_init	= x86_init_noop,
 	.setup_percpu_clockev		= setup_secondary_APIC_clock,
 };
diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index d6c28ac..422fd82 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -573,7 +573,7 @@ static void __init xstate_enable_boot_cpu(void)
  * This is somewhat obfuscated due to the lack of powerful enough
  * overrides for the section checks.
  */
-void __cpuinit xsave_init(void)
+void xsave_init(void)
 {
 	static __refdata void (*next_func)(void) = xstate_enable_boot_cpu;
 	void (*this_func)(void);
@@ -594,7 +594,7 @@ static inline void __init eager_fpu_init_bp(void)
 		setup_init_fpu_buf();
 }
 
-void __cpuinit eager_fpu_init(void)
+void eager_fpu_init(void)
 {
 	static __refdata void (*boot_func)(void) = eager_fpu_init_bp;
 
diff --git a/arch/x86/mm/mmio-mod.c b/arch/x86/mm/mmio-mod.c
index dc0b727..0057a7a 100644
--- a/arch/x86/mm/mmio-mod.c
+++ b/arch/x86/mm/mmio-mod.c
@@ -410,9 +410,7 @@ out:
 		pr_warning("multiple CPUs still online, may miss events.\n");
 }
 
-/* __ref because leave_uniprocessor calls cpu_up which is __cpuinit,
-   but this whole function is ifdefed CONFIG_HOTPLUG_CPU */
-static void __ref leave_uniprocessor(void)
+static void leave_uniprocessor(void)
 {
 	int cpu;
 	int err;
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index a71c4e2..8bf93ba 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -60,7 +60,7 @@ s16 __apicid_to_node[MAX_LOCAL_APIC] = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
 };
 
-int __cpuinit numa_cpu_node(int cpu)
+int numa_cpu_node(int cpu)
 {
 	int apicid = early_per_cpu(x86_cpu_to_apicid, cpu);
 
@@ -691,12 +691,12 @@ void __init init_cpu_to_node(void)
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
 
 # ifndef CONFIG_NUMA_EMU
-void __cpuinit numa_add_cpu(int cpu)
+void numa_add_cpu(int cpu)
 {
 	cpumask_set_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
 
-void __cpuinit numa_remove_cpu(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	cpumask_clear_cpu(cpu, node_to_cpumask_map[early_cpu_to_node(cpu)]);
 }
@@ -763,17 +763,17 @@ void debug_cpumask_set_cpu(int cpu, int node, bool enable)
 }
 
 # ifndef CONFIG_NUMA_EMU
-static void __cpuinit numa_set_cpumask(int cpu, bool enable)
+static void numa_set_cpumask(int cpu, bool enable)
 {
 	debug_cpumask_set_cpu(cpu, early_cpu_to_node(cpu), enable);
 }
 
-void __cpuinit numa_add_cpu(int cpu)
+void numa_add_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, true);
 }
 
-void __cpuinit numa_remove_cpu(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, false);
 }
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index dbbbb47..a8f90ce 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -10,7 +10,7 @@
 
 #include "numa_internal.h"
 
-static int emu_nid_to_phys[MAX_NUMNODES] __cpuinitdata;
+static int emu_nid_to_phys[MAX_NUMNODES];
 static char *emu_cmdline __initdata;
 
 void __init numa_emu_cmdline(char *str)
@@ -444,7 +444,7 @@ no_emu:
 }
 
 #ifndef CONFIG_DEBUG_PER_CPU_MAPS
-void __cpuinit numa_add_cpu(int cpu)
+void numa_add_cpu(int cpu)
 {
 	int physnid, nid;
 
@@ -462,7 +462,7 @@ void __cpuinit numa_add_cpu(int cpu)
 			cpumask_set_cpu(cpu, node_to_cpumask_map[nid]);
 }
 
-void __cpuinit numa_remove_cpu(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	int i;
 
@@ -470,7 +470,7 @@ void __cpuinit numa_remove_cpu(int cpu)
 		cpumask_clear_cpu(cpu, node_to_cpumask_map[i]);
 }
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
-static void __cpuinit numa_set_cpumask(int cpu, bool enable)
+static void numa_set_cpumask(int cpu, bool enable)
 {
 	int nid, physnid;
 
@@ -490,12 +490,12 @@ static void __cpuinit numa_set_cpumask(int cpu, bool enable)
 	}
 }
 
-void __cpuinit numa_add_cpu(int cpu)
+void numa_add_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, true);
 }
 
-void __cpuinit numa_remove_cpu(int cpu)
+void numa_remove_cpu(int cpu)
 {
 	numa_set_cpumask(cpu, false);
 }
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
index 410531d..90555bf 100644
--- a/arch/x86/mm/setup_nx.c
+++ b/arch/x86/mm/setup_nx.c
@@ -5,7 +5,7 @@
 #include <asm/pgtable.h>
 #include <asm/proto.h>
 
-static int disable_nx __cpuinitdata;
+static int disable_nx;
 
 /*
  * noexec = on|off
@@ -29,7 +29,7 @@ static int __init noexec_setup(char *str)
 }
 early_param("noexec", noexec_setup);
 
-void __cpuinit x86_configure_nx(void)
+void x86_configure_nx(void)
 {
 	if (cpu_has_nx && !disable_nx)
 		__supported_pte_mask |= _PAGE_NX;
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index e9e6ed5..a48be98 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -312,7 +312,7 @@ static int __init early_fill_mp_bus_info(void)
 
 #define ENABLE_CF8_EXT_CFG      (1ULL << 46)
 
-static void __cpuinit enable_pci_io_ecs(void *unused)
+static void enable_pci_io_ecs(void *unused)
 {
 	u64 reg;
 	rdmsrl(MSR_AMD64_NB_CFG, reg);
@@ -322,8 +322,8 @@ static void __cpuinit enable_pci_io_ecs(void *unused)
 	}
 }
 
-static int __cpuinit amd_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
+static int amd_cpu_notify(struct notifier_block *self, unsigned long action,
+			  void *hcpu)
 {
 	int cpu = (long)hcpu;
 	switch (action) {
@@ -337,7 +337,7 @@ static int __cpuinit amd_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block __cpuinitdata amd_cpu_notifier = {
+static struct notifier_block amd_cpu_notifier = {
 	.notifier_call	= amd_cpu_notify,
 };
 
diff --git a/arch/x86/platform/ce4100/ce4100.c b/arch/x86/platform/ce4100/ce4100.c
index f8ab494..baec704 100644
--- a/arch/x86/platform/ce4100/ce4100.c
+++ b/arch/x86/platform/ce4100/ce4100.c
@@ -134,7 +134,7 @@ static void __init sdv_arch_setup(void)
 }
 
 #ifdef CONFIG_X86_IO_APIC
-static void __cpuinit sdv_pci_init(void)
+static void sdv_pci_init(void)
 {
 	x86_of_pci_init();
 	/* We can't set this earlier, because we need to calibrate the timer */
diff --git a/arch/x86/platform/mrst/mrst.c b/arch/x86/platform/mrst/mrst.c
index a0a0a43..47fe66f 100644
--- a/arch/x86/platform/mrst/mrst.c
+++ b/arch/x86/platform/mrst/mrst.c
@@ -65,7 +65,7 @@
  * lapic (always-on,ARAT) ------ 150
  */
 
-__cpuinitdata enum mrst_timer_options mrst_timer_options;
+enum mrst_timer_options mrst_timer_options;
 
 static u32 sfi_mtimer_usage[SFI_MTMR_MAX_NUM];
 static struct sfi_timer_table_entry sfi_mtimer_array[SFI_MTMR_MAX_NUM];
@@ -248,7 +248,7 @@ static void __init mrst_time_init(void)
 	apbt_time_init();
 }
 
-static void __cpuinit mrst_arch_setup(void)
+static void mrst_arch_setup(void)
 {
 	if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 0x27)
 		__mrst_cpu_chip = MRST_CPU_CHIP_PENWELL;
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index db58b68..22bd4bd 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1719,8 +1719,8 @@ static void __init init_hvm_pv_info(void)
 	xen_domain_type = XEN_HVM_DOMAIN;
 }
 
-static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
-				    unsigned long action, void *hcpu)
+static int xen_hvm_cpu_notify(struct notifier_block *self, unsigned long action,
+			      void *hcpu)
 {
 	int cpu = (long)hcpu;
 	switch (action) {
@@ -1738,7 +1738,7 @@ static int __cpuinit xen_hvm_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
-static struct notifier_block xen_hvm_cpu_notifier __cpuinitdata = {
+static struct notifier_block xen_hvm_cpu_notifier = {
 	.notifier_call	= xen_hvm_cpu_notify,
 };
 
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index c4874c0..38b3df4 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -503,7 +503,7 @@ static void __init fiddle_vdso(void)
 #endif
 }
 
-static int __cpuinit register_callback(unsigned type, const void *func)
+static int register_callback(unsigned type, const void *func)
 {
 	struct callback_register callback = {
 		.type = type,
@@ -514,7 +514,7 @@ static int __cpuinit register_callback(unsigned type, const void *func)
 	return HYPERVISOR_callback_op(CALLBACKOP_register, &callback);
 }
 
-void __cpuinit xen_enable_sysenter(void)
+void xen_enable_sysenter(void)
 {
 	int ret;
 	unsigned sysenter_feature;
@@ -533,7 +533,7 @@ void __cpuinit xen_enable_sysenter(void)
 		setup_clear_cpu_cap(sysenter_feature);
 }
 
-void __cpuinit xen_enable_syscall(void)
+void xen_enable_syscall(void)
 {
 #ifdef CONFIG_X86_64
 	int ret;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 3d88499..e98f85f 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -65,7 +65,7 @@ static irqreturn_t xen_reschedule_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void __cpuinit cpu_bringup(void)
+static void cpu_bringup(void)
 {
 	int cpu;
 
@@ -99,7 +99,7 @@ static void __cpuinit cpu_bringup(void)
 	wmb();			/* make sure everything is out */
 }
 
-static void __cpuinit cpu_bringup_and_idle(void)
+static void cpu_bringup_and_idle(void)
 {
 	cpu_bringup();
 	cpu_startup_entry(CPUHP_ONLINE);
@@ -329,7 +329,7 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 		set_cpu_present(cpu, true);
 }
 
-static int __cpuinit
+static int
 cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 {
 	struct vcpu_guest_context *ctxt;
@@ -416,7 +416,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	return 0;
 }
 
-static int __cpuinit xen_cpu_up(unsigned int cpu, struct task_struct *idle)
+static int xen_cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int rc;
 
@@ -489,7 +489,7 @@ static void xen_cpu_die(unsigned int cpu)
 	xen_teardown_timer(cpu);
 }
 
-static void __cpuinit xen_play_dead(void) /* used only with HOTPLUG_CPU */
+static void xen_play_dead(void) /* used only with HOTPLUG_CPU */
 {
 	play_dead_common();
 	HYPERVISOR_vcpu_op(VCPUOP_down, smp_processor_id(), NULL);
@@ -710,7 +710,7 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
 	xen_init_lock_cpu(0);
 }
 
-static int __cpuinit xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle)
+static int xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int rc;
 	rc = native_cpu_up(cpu, tidle);
diff --git a/arch/x86/xen/spinlock.c b/arch/x86/xen/spinlock.c
index a40f850..cf3caee 100644
--- a/arch/x86/xen/spinlock.c
+++ b/arch/x86/xen/spinlock.c
@@ -361,7 +361,7 @@ static irqreturn_t dummy_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-void __cpuinit xen_init_lock_cpu(int cpu)
+void xen_init_lock_cpu(int cpu)
 {
 	int irq;
 	char *name;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index a95b417..86782c5 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -73,7 +73,7 @@ static inline void xen_hvm_smp_init(void) {}
 
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void __init xen_init_spinlocks(void);
-void __cpuinit xen_init_lock_cpu(int cpu);
+void xen_init_lock_cpu(int cpu);
 void xen_uninit_lock_cpu(int cpu);
 #else
 static inline void xen_init_spinlocks(void)
-- 
1.8.1.2

