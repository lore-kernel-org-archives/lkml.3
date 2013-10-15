Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933102Ab3JOFnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:43:33 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50500 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933078Ab3JOFn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:43:29 -0400
Subject: [PATCH v2 2/2] x86, apic: Disable BSP if boot cpu is AP
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Tue, 15 Oct 2013 14:43:27 +0900
Message-ID: <20131015054327.13666.1689.stgit@localhost6.localdomain6>
In-Reply-To: <20131015054214.13666.11737.stgit@localhost6.localdomain6>
References: <20131015054214.13666.11737.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, on x86 architecture, if crash happens on AP in the kdump
1st kernel, the 2nd kernel fails to wake up multiple CPUs. The typical
behaviour we actually see is immediate system reset or hang.

This comes from the hardware specification that the processor with BSP
flag is jumped at BIOS init code when receiving INIT; the behaviour we
then see depends on the init code.

This never happens if we use only one cpu in the 2nd kernel. So, we
have avoided the issue by the workaround that specifying maxcpus=1 or
nr_cpus=1 in kernel parameter of the 2nd kernel.

In order to address the issue, this patch disables BSP if boot cpu is
an AP, and thus we don't try to wake up the BSP by sending INIT.

Before this idea we discussed the following two ideas but we cannot
adopt them in each reasons:

1. Switch CPU from AP to BSP via IPI NMI at crash in the 1st kernel

   This is done in the kdump crash path where logic is in inconsistent
   state. Any part of memory can be corrupted, including
   hardware-related table being accessed for example when paging is
   performed or interruption is performed.

2. Unset BSP flag of the boot cpu in the 1st kernel

   Unsetting BSP flag can affect some real world firmware badly. For
   example, Ma verified that some HP systems fail to reboot under this
   configuration. See:

   http://lkml.indiana.edu/hypermail/linux/kernel/1308.1/03574.html

Due to the idea 1, we have to address the issue in the 2nd kernel on
AP. Then, it's impossible to know which CPU is BSP by rdmsr
instruction because the CPU is the one we are now trying to wake
up. From the same reason, it's also impossible to unset BSP flag of
the BSP by wrmsr instruction.

Next, due to the idea 2, BSP is halting in the 1st kernel while
keeping BSP flag set (or possibly could be running somewhere in
catastrophic state.) In generall, CPUs except for the boot cpu in the
2nd kernel -- the cpu under which crash happened --- can be thought of
as remaining in any inconsistent state in the 1st kernel. For APs,
it's possible to recover sane state by initiating INIT to them; see
3.7.3 Processor-specific INIT in MultiProcessor
specification. However, there's no way for BSP. Therefore, there's no
other way to disable BSP.

My motivation is to generate crash dump quickly on the system with
huge memory. We can assume such system also has a lot of N-cpus and
(N-1)-cpus are still available.

To identify which CPU is BSP, we lookup ACPI table or MP table. One
concern is that ACPI guidlines BIOS *should* list the BSP in the first
MADT LAPIC entry; not *must*. In this sense, this logic relis on BIOS
following ACPI's guideline. On the other hand, we don't need to worry
about this in MP table case because it has explit BSP flag.

To avoid any undesirable bahaviour caused by any broken BIOS that
doesn't conform to the guideline, it's enough to limit the number of
cpus to 1 by specifying maxcpu=1 or nr_cpus=1, as is currently done in
default kdump configuration. (But of course, it's problematic in
maxcpu=1 case if trying to wake up other cpus later in user space.)

SFI and devicetree doesn't provide BSP information, so there's no
functionality change in their codes, only assigning false for all the
entries, keeping interface uniform.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/include/asm/mpspec.h |    2 +-
 arch/x86/kernel/acpi/boot.c   |    6 +++++-
 arch/x86/kernel/apic/apic.c   |   18 +++++++++++++++++-
 arch/x86/kernel/devicetree.c  |    1 +
 arch/x86/kernel/mpparse.c     |   15 +++++++++++++--
 arch/x86/platform/sfi/sfi.c   |    2 +-
 6 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/mpspec.h b/arch/x86/include/asm/mpspec.h
index 54d5f98..b5014cd 100644
--- a/arch/x86/include/asm/mpspec.h
+++ b/arch/x86/include/asm/mpspec.h
@@ -101,7 +101,7 @@ static inline void early_reserve_e820_mpc_new(void) { }
 #define default_get_smp_config x86_init_uint_noop
 #endif
 
-void generic_processor_info(int apicid, int version);
+void generic_processor_info(int apicid, bool isbsp, int version);
 #ifdef CONFIG_ACPI
 extern void mp_register_ioapic(int id, u32 address, u32 gsi_base);
 extern void mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 40c7660..7944d3f 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -192,6 +192,7 @@ static int __init acpi_parse_madt(struct acpi_table_header *table)
 static void acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
+	bool isbsp = false;
 
 	if (id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
@@ -206,7 +207,10 @@ static void acpi_register_lapic(int id, u8 enabled)
 	if (boot_cpu_physical_apicid != -1U)
 		ver = apic_version[boot_cpu_physical_apicid];
 
-	generic_processor_info(id, ver);
+	if (!num_processors && !disabled_cpus)
+		isbsp = true;
+
+	generic_processor_info(id, isbsp, ver);
 }
 
 static int __init
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 62ee365..2e4e036 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -2113,13 +2113,29 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 	apic_write(APIC_LVT1, value);
 }
 
-void generic_processor_info(int apicid, int version)
+void generic_processor_info(int apicid, bool isbsp, int version)
 {
 	int cpu, max = nr_cpu_ids;
 	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
 				phys_cpu_present_map);
 
 	/*
+	 * If boot cpu is AP, we now don't have any way to initialize
+	 * BSP. To save memory consumed, we disable BSP this case and
+	 * use (N - 1)-cpus.
+	 */
+	if (isbsp && !boot_cpu_is_bsp) {
+		int thiscpu = num_processors + disabled_cpus;
+
+		pr_warning("ACPI: The boot cpu is not BSP. "
+			   "The BSP Processor %d/0x%x ignored.\n",
+			   thiscpu, apicid);
+
+		disabled_cpus++;
+		return;
+	}
+
+	/*
 	 * If boot cpu has not been detected yet, then only allow upto
 	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
 	 */
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 376dc78..0ed2da8 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -182,6 +182,7 @@ static void __init dtb_lapic_setup(void)
 	pic_mode = 1;
 	register_lapic_address(r.start);
 	generic_processor_info(boot_cpu_physical_apicid,
+			       false,
 			       GET_APIC_VERSION(apic_read(APIC_LVR)));
 #endif
 }
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b5648..003b07fe 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -54,6 +54,7 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 {
 	int apicid;
 	char *bootup_cpu = "";
+	bool isbsp = false;
 
 	if (!(m->cpuflag & CPU_ENABLED)) {
 		disabled_cpus++;
@@ -64,11 +65,21 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->apicid;
+		/*
+		 * boot cpu cannot be BSP if any crash happens on AP
+		 * and kexec enters the 2nd kernel.
+		 *
+		 * Also, boot_cpu_physical_apicid can be initialized
+		 * before reaching here; for example, in
+		 * register_lapic_address().
+		 */
+		if (boot_cpu_is_bsp && boot_cpu_physical_apicid == -1U)
+			boot_cpu_physical_apicid = m->apicid;
+		isbsp = true;
 	}
 
 	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);
-	generic_processor_info(apicid, m->apicver);
+	generic_processor_info(apicid, isbsp, m->apicver);
 }
 
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/platform/sfi/sfi.c b/arch/x86/platform/sfi/sfi.c
index bcd1a70..4f111c7 100644
--- a/arch/x86/platform/sfi/sfi.c
+++ b/arch/x86/platform/sfi/sfi.c
@@ -45,7 +45,7 @@ static void __init mp_sfi_register_lapic(u8 id)
 
 	pr_info("registering lapic[%d]\n", id);
 
-	generic_processor_info(id, GET_APIC_VERSION(apic_read(APIC_LVR)));
+	generic_processor_info(id, false, GET_APIC_VERSION(apic_read(APIC_LVR)));
 }
 
 static int __init sfi_parse_cpus(struct sfi_table_header *table)

