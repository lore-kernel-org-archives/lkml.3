Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3KLJwC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:52:02 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56329 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3KLJvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:51:55 -0500
Subject: [PATCH v5 1/3] x86, apic: add bsp_physical_apicid
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Tue, 12 Nov 2013 18:51:53 +0900
Message-ID: <20131112095153.4902.51290.stgit@localhost6.localdomain6>
In-Reply-To: <20131112094952.4902.72689.stgit@localhost6.localdomain6>
References: <20131112094952.4902.72689.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bsp_physical_apicid variable that has the initial APIC ID for the
processor with BSP flag on IA32_APIC_BASE MSR. Without this,
boot_cpu_physical_apicid temporarily has the value around MP table
related codes such as kernel/mpparse.c, mm/amdtopology.c and
platform/visws/visws_quirks.c until it is rewritten back in
init_apic_mappings() to the initial APIC ID for the processor that is
doing boot up.

This change is also required by the next commit introducing new
disable_cpu_apicid kernel parameter, where the value specified via
disable_cpu_apicid is compared with boot_cpu_physical_apicid in
generic_processor_info(), but in case of using MP table, the
boot_cpu_physical_apicid is rewiriten by MP_processor_info() to the
initial APIC ID of the BSP reported by BIOS, which is problematic if
some AP is specified in disable_cpu_apic.

Then, replace boot_cpu_physical_apicid in the MP table related codes
such as kernel/mpparse.c, mm/amdtopology.c and
platform/visws/visws_quirks.c by newly introduced bsp_physical_apicid,
where no functional change is intended.

If the cpu that is doing boot-up process is BSP, use cpuid to get the
initial APIC ID. If AP, assign the initial APIC ID obtained from MP
table or MADT. This covers the above MP table related codes with no
functional change.

Initialize boot_cpu_data.initial_apicid in early_identify_cpu() since
currently it is initialized after logical cpu number assignment is
performed.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/include/asm/mpspec.h          |    7 +++++++
 arch/x86/kernel/apic/apic.c            |   15 +++++++++++++++
 arch/x86/kernel/cpu/common.c           |    5 ++++-
 arch/x86/kernel/mpparse.c              |    3 ++-
 arch/x86/kernel/setup.c                |    2 ++
 arch/x86/mm/amdtopology.c              |    6 +++---
 arch/x86/platform/visws/visws_quirks.c |    6 ++++--
 7 files changed, 37 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 626cf70..894d6df 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -47,11 +47,18 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
+extern unsigned int bsp_physical_apicid;
 extern unsigned int max_physical_apicid;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
 
 #ifdef CONFIG_X86_LOCAL_APIC
+extern void bsp_physical_apicid_init(void);
+#else
+static inline void bsp_physical_apicid_init(void) { };
+#endif
+
+#ifdef CONFIG_X86_LOCAL_APIC
 extern int smp_found_config;
 #else
 # define smp_found_config 0
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a7eb82d..b60ad92 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -63,6 +63,10 @@ unsigned disabled_cpus;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
 
+/* Processor with BP flag on IA32_APIC_BASE MSR. In case of kexec,
+ * this can differ from the processor that is doing the boot up. */
+unsigned int bsp_physical_apicid = BAD_APICID;
+
 /*
  * The highest APIC ID seen during enumeration.
  */
@@ -2589,3 +2593,14 @@ static int __init lapic_insert_resource(void)
  * that is using request_resource
  */
 late_initcall(lapic_insert_resource);
+
+void __init bsp_physical_apicid_init(void)
+{
+	u32 l, h;
+
+	if (boot_cpu_data.x86 >= 6 && cpu_has_apic) {
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		if (!(l & MSR_IA32_APICBASE_BSP))
+			bsp_physical_apicid = boot_cpu_data.initial_apicid;
+	}
+}
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 2793d1f..28bea2c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -681,7 +681,7 @@ static void identify_cpu_without_cpuid(struct cpuinfo_x86 *c)
 /*
  * Do minimum CPU detection early.
  * Fields really needed: vendor, cpuid_level, family, model, mask,
- * cache alignment.
+ * cache alignment, initial_apicid.
  * The others are not touched to avoid unwanted side effects.
  *
  * WARNING: this function is only called on the BP.  Don't add code here
@@ -725,6 +725,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		this_cpu->c_bsp_init(c);
 
 	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
+
+	if (c->cpuid_level >= 0x00000001)
+		c->initial_apicid = (cpuid_ebx(1) >> 24) & 0xFF;
 }
 
 void __init early_cpu_init(void)
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b5648..209fbf6 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -64,7 +64,8 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->apicid;
+		if (bsp_physical_apicid == BAD_APICID)
+			bsp_physical_apicid = m->apicid;
 	}
 
 	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..8745b24 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1166,6 +1166,8 @@ void __init setup_arch(char **cmdline_p)
 
 	early_quirks();
 
+	bsp_physical_apicid_init();
+
 	/*
 	 * Read APIC and some other early information from ACPI tables.
 	 */
diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index 2ca15b5..bec16ad 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -183,9 +183,9 @@ int __init amd_numa_init(void)
 
 	/* get the APIC ID of the BSP early for systems with apicid lifting */
 	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0) {
-		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
-		apicid_base = boot_cpu_physical_apicid;
+	if (bsp_physical_apicid > 0) {
+		pr_info("BSP APIC ID: %02x\n", bsp_physical_apicid);
+		apicid_base = bsp_physical_apicid;
 	}
 
 	for_each_node_mask(i, numa_nodes_parsed)
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index 94d8a39..aebe821 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -165,8 +165,10 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	       m->apicid, (m->cpufeature & CPU_FAMILY_MASK) >> 8,
 	       (m->cpufeature & CPU_MODEL_MASK) >> 4, m->apicver);
 
-	if (m->cpuflag & CPU_BOOTPROCESSOR)
-		boot_cpu_physical_apicid = m->apicid;
+	if (m->cpuflag & CPU_BOOTPROCESSOR) {
+		if (bsp_physical_apicid == BAD_APICID)
+			bsp_physical_apicid = m->apicid;
+	}
 
 	ver = m->apicver;
 	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {

