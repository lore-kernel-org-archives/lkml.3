Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab3LDIMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:12:31 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56939 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab3LDIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:12:29 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.9
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-2
Message-ID: <529EE392.6060400@jp.fujitsu.com>
Date: Wed, 04 Dec 2013 17:10:58 +0900
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@alien8.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jingbai Ma <jingbai.ma@hp.com>
Subject: [PATCH v10] x86, apic, kexec, Documentation: Add disable_cpu_apic
 kernel parameter
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is to allow kdump 2nd kernel to wake up multiple CPUs,
a continueing work from:

  [PATCH v3 0/2] x86, apic, kdump: Disable BSP if boot cpu is AP
  https://lkml.org/lkml/2013/10/16/300.

At v4, basic design has changed. Now users need to figure out initial
APIC ID of BSP in the 1st kernel and configures kernel parameter for
the 2nd kernel manually using disable_cpu_apicid kernel parameter,
which is newly introduced by this patch set. This design is more
flexible than the previous version in that we no longer have to rely
on ACPI/MP table to get initial APIC ID of BSP.

Sorry, this patch set have not include in-source documentation
requested by Borislav Petkov yet, but I'll post it later separately,
which would be better to focus on documentation reviewing.

ChangeLog

v9 => v10)

- Remove KEXEC tag from the description of disable_cpu_apicid since
  the parameter is generic, independent of CONFIG_KEXEC, at least in
  this version.

v8 => v9)

- Rebased on top of v3.13-rc2

- Call read_apic_id() in case of disable_cpu_apiid only in
  generic_processor_info().

v7 => v8)

- Merge the patch that adds new descption in
  Documentations/kernel-parameters.txt in the first patch.

- Call read_apic_id() directly in generic_processor_info() instead of
  overriding global boot_cpu_physical_apicid with the local variable
  with the same name.

v6 => v7)

- Rebased on top of v3.13-rc1

- Remove a patch that cleans up the code around
  x86_cpu_physical_apicid. Instead, use read_apic_id() directly in
  generic_processor_info(). The clean up removed here will be done in
  different patch set.

v5 => v6)

- Remove use of rdmsr(IA32_APIC_BASE) to initialize
  bsp_physical_apicid since the MSR doesn't work well on some cluster
  systems, suggested by HPA. Also, current users of the variable
  expects the initial apicid reported through MP table only; removing
  the use of the MSR is not problematic.

- Rename bsp_physical_apicid as bios_bsp_physical_apicid to make it
  clear that the apidid contained there is the one reported from some
  BIOS table. Also, initialize it not only by MP table but also by
  ACPI MADT.

- Change message displayed when specified cpu is disabled from:

  ACPI: Disable specified CPU. Processor 0/0x0 ignored.

  to:

  ACPI: Disabling requested cpu. Processor 0/0x0 ignored.

v4 => v5)

- Rebased on top of v3.12

- Introduce bsp_physical_apicid that has the initial APIC ID for the
  processor with BSP flag on IA32_APIC_BASE MSR. Without this,
  boot_cpu_physical_apicid has temporarilly the value around MP table
  related codes, although it's designed to have the initial APIC ID
  for the processor that is doing the boot up. Use the
  bsp_physical_apicid in MP table related codes; no impact on
  semantics at runtime there.

v3 => v4)

- Rebased on top of v3.12-rc6

- Basic design has been changed. Now users need to figure out initial
  APIC ID of BSP in the 1st kernel and configures kernel parameter for
  the 2nd kernel manually using disable_cpu_apic kernel parameter to
  be newly introduced in this patch set. This design is more flexible
  than the previous version in that we no longer have to rely on
  ACPI/MP table to get initial APIC ID of BSP.

v2 => v3)

- Change default value of boot_cpu_is_bsp to true.

- Before executing rdmsr(MSR_IA32_APICBASE), check if the number of
  processor family is larger than or equal to 6 in order to avoid
  invalid opcode exception on processors where MSR_IA32_APICBASE is
  not supported.

v1 => v2)

- Rebased on top of v3.12-rc5.

- Fix linking time error of boot_cpu_is_bsp_init() in case of
  CONFIG_LOCAL_APIC disabled by adding empty static inline function
  instead.

- Fix missing feature check by means of cpu_has_apic macro in
  boot_cpu_is_bsp_init() before calling rdmsr_safe(MSR_IA32_APICBASE).

  NOTE: I've checked local apic-present case only; I don't have any
  x86 processor without local apic.

- Add __init annotation to boot_cpu_is_bsp_init().

Test

- built with and without CONFIG_LOCAL_APIC
- tested x86_64 in case of acpi and MP table
- tested disable_cpu_apicid=<n> to disable both AP and BSP


>From d03e159d9479755b36ac7d4a7d323b3ce95481be Mon Sep 17 00:00:00 2001
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Date: Tue, 3 Dec 2013 09:21:56 +0900
Subject: [PATCH] x86, apic, kexec, Documentation: Add disable_cpu_apicid
 kernel parameter

Add disable_cpu_apicid kernel parameter. To use this kernel parameter,
specify an initial APIC ID of the corresponding CPU you want to
disable.

This is mostly used for the kdump 2nd kernel to disable BSP to wake up
multiple CPUs without causing system reset or hang due to sending INIT
from AP to BSP.

Kdump users first figure out initial APIC ID of the BSP, CPU0 in the
1st kernel, for example from /proc/cpuinfo and then set up this kernel
parameter for the 2nd kernel using the obtained APIC ID.

However, doing this procedure at each boot time manually is awkward,
which should be automatically done by user-land service scripts, for
example, kexec-tools on fedora/RHEL distributions.

This design is more flexible than disabling BSP in kernel boot time
automatically in that in kernel boot time we have no choice but
referring to ACPI/MP table to obtain initial APIC ID for BSP, meaning
that the method is not applicable to the systems without such BIOS
tables.

One assumption behind this design is that users get initial APIC ID of
the BSP in still healthy state and so BSP is uniquely kept in
CPU0. Thus, through the kernel parameter, only one initial APIC ID can
be specified.

In a comparison with disabled_cpu_apicid, we use read_apic_id(), not
boot_cpu_physical_apicid, because on some platforms, the variable is
modified to the apicid reported as BSP through MP table and this
function is executed with the temporarily modified
boot_cpu_physical_apicid. As a result, disabled_cpu_apicid kernel
parameter doesn't work well for apicids of APs.

Fixing the wrong handling of boot_cpu_physical_apicid requires some
reviews and tests beyond some platforms and it could take some
time. The fix here is a kind of workaround to focus on the main topic
of this patch.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 Documentation/kernel-parameters.txt |  9 +++++++
 arch/x86/kernel/apic/apic.c         | 49 +++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 50680a5..4e5528c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -774,6 +774,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	disable=	[IPV6]
 			See Documentation/networking/ipv6.txt.
 
+	disable_cpu_apicid= [X86,APIC,SMP]
+			Format: <int>
+			The number of initial APIC ID for the
+			corresponding CPU to be disabled at boot,
+			mostly used for the kdump 2nd kernel to
+			disable BSP to wake up multiple CPUs without
+			causing system reset or hang due to sending
+			INIT from AP to BSP.
+
 	disable_ddw     [PPC/PSERIES]
 			Disable Dynamic DMA Window support. Use this if
 			to workaround buggy firmware.
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d278736..6c0b7d5 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -75,6 +75,13 @@ unsigned int max_physical_apicid;
 physid_mask_t phys_cpu_present_map;
 
 /*
+ * Processor to be disabled specified by kernel parameter
+ * disable_cpu_apicid=<int>, mostly used for the kdump 2nd kernel to
+ * avoid undefined behaviour caused by sending INIT from AP to BSP.
+ */
+unsigned int disabled_cpu_apicid = BAD_APICID;
+
+/*
  * Map cpu index to physical APIC ID
  */
 DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid, BAD_APICID);
@@ -2115,6 +2122,39 @@ int generic_processor_info(int apicid, int version)
 				phys_cpu_present_map);
 
 	/*
+	 * boot_cpu_physical_apicid is designed to have the apicid
+	 * returned by read_apic_id(), i.e, the apicid of the
+	 * currently booting-up processor. However, on some platforms,
+	 * it is temporarilly modified by the apicid reported as BSP
+	 * through MP table. Concretely:
+	 *
+	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
+	 * - arch/x86/mm/amdtopology.c: amd_numa_init()
+	 * - arch/x86/platform/visws/visws_quirks.c: MP_processor_info()
+	 *
+	 * This function is executed with the modified
+	 * boot_cpu_physical_apicid. So, disabled_cpu_apicid kernel
+	 * parameter doesn't work to disable APs on kdump 2nd kernel.
+	 *
+	 * Since fixing handling of boot_cpu_physical_apicid requires
+	 * another discussion and tests on each platform, we leave it
+	 * for now and here we use read_apic_id() directly in this
+	 * function, generic_processor_info().
+	 */
+	if (disabled_cpu_apicid != BAD_APICID &&
+	    disabled_cpu_apicid != read_apic_id() &&
+	    disabled_cpu_apicid == apicid) {
+		int thiscpu = num_processors + disabled_cpus;
+
+		pr_warning("ACPI: Disabling requested cpu."
+			   " Processor %d/0x%x ignored.\n",
+			   thiscpu, apicid);
+
+		disabled_cpus++;
+		return -ENODEV;
+	}
+
+	/*
 	 * If boot cpu has not been detected yet, then only allow upto
 	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
 	 */
@@ -2592,3 +2632,12 @@ static int __init lapic_insert_resource(void)
  * that is using request_resource
  */
 late_initcall(lapic_insert_resource);
+
+static int __init apic_set_disabled_cpu_apicid(char *arg)
+{
+	if (!arg || !get_option(&arg, &disabled_cpu_apicid))
+		return -EINVAL;
+
+	return 0;
+}
+early_param("disable_cpu_apicid", apic_set_disabled_cpu_apicid);
-- 
1.8.3.1

-- 
Thanks.
HATAYAMA, Daisuke

