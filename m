Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbaAPJmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 04:42:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38274 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaAPJmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 04:42:12 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <52D7A8F0.70807@jp.fujitsu.com>
Date: Thu, 16 Jan 2014 18:40:00 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "x86@kernel.org" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] x86, apic: clean up handling of boot_cpu_physical_apicid
 in boot process
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch deals with the issue of handling boot_cpu_physical_apicid
in boot process I avoided in disable_cpu_apicid patch because I
cannot guess how long it needs to take for the review of this fix.

This patch is made on top of today's x86/apic branch of tip tree.
Its commit hash is 5b4d1dbc24bb6fd7179ada0f47be34e27e64decb

I tested this patch in each combination of the following table:

  BIOS table    boot cpu
-------------+--------------
  ACPI MADT     AP
  MP Table      BSP


>From 10946038252fc91f3ae2740953b2484ea0076ed4 Mon Sep 17 00:00:00 2001
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date: Thu, 16 Jan 2014 15:47:25 +0900
Subject: [PATCH] x86, apic: clean up handling of boot_cpu_physical_apicid in
 boot process

boot_cpu_physical_apicid variable is intended to have the apicid of
the processor that is doing the boot up by read_apic_id() that picks
up the value from APIC_ID register of local APIC.

boot_cpu_physical_apicid variable could be initialized with the value
from MP table if there's no acpi support on the system or acpi=off is
manually specified.

The first issue is that if kexec boots the 2nd kernel on some AP, the
processor that is doing the boot up of the 2nd kernel is no longer
BSP. This means that boot_cpu_physical_apicid is modified to
unintended BSP's apicid.

The second issue is that in the current code, once the
boot_cpu_physical_apicid variable is modified by the value from MP
table, it is again modified back to read_apic_id().

Concretely, they are processed as follows in setup_arch():

  1) boot_cpu_physical_apicid is first initialized by read_apic_id()
     in acpi_boot_init(), then
  2) re-initialized by get_smp_config() and finally
  3) modified back by read_apic_id() in init_apic_mappings().

In source code:

	/*
	 * Read APIC and some other early information from ACPI tables.
	 */
	acpi_boot_init();                   <== 1)
	sfi_init();
	x86_dtb_init();

	/*
	 * get boot-time SMP configuration:
	 */
	if (smp_found_config)
		get_smp_config();           <== 2)

	prefill_possible_map();

	init_cpu_to_node();

	init_apic_mappings();               <== 3)

It is confusing that meaning of the variable changes in the middle of
boot up.

To fix these issues, this patch adds bios_bsp_physical_apicid variable
to store the apicid value reported by BIOS via ACPI MADT or MP table,
by which boot_cpu_physical_apicid variable is cleanly handled in boot
up.

This patch also fixes the workaround done in generic_processor_info()
that directly calls read_apic_id() to avoid the first issue.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/include/asm/mpspec.h          |  1 +
 arch/x86/kernel/acpi/boot.c            |  8 ++++++++
 arch/x86/kernel/apic/apic.c            | 31 ++++++++++---------------------
 arch/x86/kernel/mpparse.c              |  2 +-
 arch/x86/platform/visws/visws_quirks.c |  2 +-
 5 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 3142a94..724853f 100644
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
index 6c0b43b..4f460e2 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -213,6 +213,14 @@ static int acpi_register_lapic(int id, u8 enabled)
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
 	return generic_processor_info(id, ver);
 }
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7f26c9a..107614f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -64,6 +64,15 @@ unsigned disabled_cpus;
 unsigned int boot_cpu_physical_apicid = -1U;
 EXPORT_SYMBOL_GPL(boot_cpu_physical_apicid);
 
+/* Processor with BP flag on IP32_APIC_BASE MSR to be initialized with
+ * the value reported by BIOS tables such as ACPI MADT or MP table.
+ *
+ * If kexec boots the 2nd kernel on some AP, this differs from the
+ * processor that is doing the boot up: boot_cpu_physical_apicid !=
+ * bios_bsp_physical_apicid.
+ */
+unsigned int bios_bsp_physical_apicid = BAD_APICID;
+
 /*
  * The highest APIC ID seen during enumeration.
  */
@@ -2120,28 +2129,8 @@ int generic_processor_info(int apicid, int version)
 	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
 				phys_cpu_present_map);
 
-	/*
-	 * boot_cpu_physical_apicid is designed to have the apicid
-	 * returned by read_apic_id(), i.e, the apicid of the
-	 * currently booting-up processor. However, on some platforms,
-	 * it is temporarily modified by the apicid reported as BSP
-	 * through MP table. Concretely:
-	 *
-	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
-	 * - arch/x86/mm/amdtopology.c: amd_numa_init()
-	 * - arch/x86/platform/visws/visws_quirks.c: MP_processor_info()
-	 *
-	 * This function is executed with the modified
-	 * boot_cpu_physical_apicid. So, disabled_cpu_apicid kernel
-	 * parameter doesn't work to disable APs on kdump 2nd kernel.
-	 *
-	 * Since fixing handling of boot_cpu_physical_apicid requires
-	 * another discussion and tests on each platform, we leave it
-	 * for now and here we use read_apic_id() directly in this
-	 * function, generic_processor_info().
-	 */
 	if (disabled_cpu_apicid != BAD_APICID &&
-	    disabled_cpu_apicid != read_apic_id() &&
+	    disabled_cpu_apicid != boot_cpu_physical_apicid &&
 	    disabled_cpu_apicid == apicid) {
 		int thiscpu = num_processors + disabled_cpus;
 
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
diff --git a/arch/x86/platform/visws/visws_quirks.c b/arch/x86/platform/visws/visws_quirks.c
index 94d8a39..069ed83 100644
--- a/arch/x86/platform/visws/visws_quirks.c
+++ b/arch/x86/platform/visws/visws_quirks.c
@@ -166,7 +166,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	       (m->cpufeature & CPU_MODEL_MASK) >> 4, m->apicver);
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR)
-		boot_cpu_physical_apicid = m->apicid;
+		bios_cpu_physical_apicid = m->apicid;
 
 	ver = m->apicver;
 	if ((ver >= 0x14 && m->apicid >= 0xff) || m->apicid >= 0xf) {
-- 
1.8.4.2


-- 
Thanks.
HATAYAMA, Daisuke

