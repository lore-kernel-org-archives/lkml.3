Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab3KUCAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:00:44 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38041 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab3KUCAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:00:41 -0500
Subject: [PATCH v6 1/3] x86, apic: add bios_bsp_physical_apicid
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Thu, 21 Nov 2013 11:00:39 +0900
Message-ID: <20131121020039.2748.72482.stgit@localhost6.localdomain6>
In-Reply-To: <20131121015951.2748.47826.stgit@localhost6.localdomain6>
References: <20131121015951.2748.47826.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add bios_bsp_physical_apicid variable. This variable is initialized
with the value reported by BIOS tables such as ACPI MADT or MP table.

Without this variable, boot_cpu_physical_apicid temporarilly has the
value around MP table related codes such as kernel/mpparse.c,
mm/amdtopology.c and platform/visws/visws_quirks.c until it is
rewritten back in init_apic_mappings() to the initial APIC ID for the
processor that is doing boot up.

This change is also required by the next commit introducing new
disable_cpu_apicid kernel parameter, where the value specified via
disable_cpu_apicid is compared with boot_cpu_physical_apicid in
generic_processor_info(), but in case of using MP table, the
boot_cpu_physical_apicid is rewiriten by MP_processor_info() to the
initial APIC ID of the BSP reported by BIOS, which is problematic if
some AP is specified in disable_cpu_apic.

There's no functional change intended on kernel/mpparse.c,
mm/amdtopology.c and platform/visws/visws_quirks.c by the introduction
of bios_bsp_physical_apicid.

The reason why we don't use cpuid is that we cannot use IA32_APIC_BASE
MSR to determine if the booting up cpu is BSP since rdmsr() to the MSR
could not work well even if it exists on some system, e.g. some
cluster system.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/include/asm/mpspec.h          |    1 +
 arch/x86/kernel/acpi/boot.c            |    8 ++++++++
 arch/x86/kernel/apic/apic.c            |    9 +++++++++
 arch/x86/kernel/mpparse.c              |    2 +-
 arch/x86/mm/amdtopology.c              |    6 +++---
 arch/x86/platform/visws/visws_quirks.c |    2 +-
 6 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 626cf70..3f9f94b 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -47,6 +47,7 @@ extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 extern DECLARE_BITMAP(mp_bus_not_pci, MAX_MP_BUSSES);
 
 extern unsigned int boot_cpu_physical_apicid;
+extern unsigned int bios_bsp_physical_apicid;
 extern unsigned int max_physical_apicid;
 extern int mpc_default_type;
 extern unsigned long mp_lapic_addr;
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 40c7660..f62226a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -206,6 +206,14 @@ static void acpi_register_lapic(int id, u8 enabled)
 	if (boot_cpu_physical_apicid != -1U)
 		ver = apic_version[boot_cpu_physical_apicid];
 
+	/*
+	 * ACPI specification describes that platform firmware should
+	 * list the BSP processor as the first LAPIC entry in the
+	 * MADT.
+	 */
+	if (!num_processors && !disabled_cpus)
+		bios_bsp_physical_apicid = id;
+
 	generic_processor_info(id, ver);
 }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a7eb82d..cff8d71 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -63,6 +63,15 @@ unsigned disabled_cpus;
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
 
+/* Processor with BP flag on IA32_APIC_BASE MSR to be initialized with
+ * the value reported by BIOS tables such as ACPI MADT or MP table,
+ * not with the value obtained by rdmsr(IA32_APIC_MSR) since it
+ * possibly doesn't work well on some clustered system.
+ *
+ * In case of kexec, this can differ from the processor that is doing
+ * the boot up. */
+unsigned int bios_bsp_physical_apicid = BAD_APICID;
+
 /*
  * The highest APIC ID seen during enumeration.
  */
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b5648..5bb5220 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -64,7 +64,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->apicid;
+		bios_bsp_physical_apicid = m->apicid;
 	}
 
 	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
index 2ca15b5..788012e 100644
--- a/arch/x86/mm/amdtopology.c
+++ b/arch/x86/mm/amdtopology.c
@@ -183,9 +183,9 @@ int __init amd_numa_init(void)
 
 	/* get the APIC ID of the BSP early for systems with apicid lifting */
 	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0) {
-		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
-		apicid_base = boot_cpu_physical_apicid;
+	if (bios_bsp_physical_apicid > 0) {
+		pr_info("BSP APIC ID: %02x\n", bios_bsp_physical_apicid);
+		apicid_base = bios_bsp_physical_apicid;
 	}
 
 	for_each_node_mask(i, numa_nodes_parsed)
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index 94d8a39..5a91e50 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -166,7 +166,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	       (m->cpufeature & CPU_MODEL_MASK) >> 4, m->apicver);
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR)
-		boot_cpu_physical_apicid = m->apicid;
+		bios_bsp_physical_apicid = m->apicid;
 
 	ver = m->apicver;
 	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {

