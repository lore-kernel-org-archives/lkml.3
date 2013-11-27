Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab3K0CB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 21:01:28 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43076 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760757Ab3K0CAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 21:00:54 -0500
Subject: [PATCH v7 1/2] x86, apic: Add disable_cpu_apicid kernel parameter
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Wed, 27 Nov 2013 11:00:48 +0900
Message-ID: <20131127020048.1493.43123.stgit@localhost6.localdomain6>
In-Reply-To: <20131127020006.1493.86091.stgit@localhost6.localdomain6>
References: <20131127020006.1493.86091.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

boot_cpu_physical_apicid is designed to have the apicid returned by
read_apic_id(). However, on some platforms, it is temporarilly
modified by the apicid reported as BSP through MP table. This function
is called with the modified boot_cpu_physical_apicid.

On the platforms, boot_cpu_physical_apicid is always forced to be the
apicid of the BSP. Then, disabled_cpu_apicid kernel parameter doesn't
work well for apicids for APs.

Here we leave improvement of handling boot_cpu_physical_apicid as
another work for now since the temporary modification is done on
differnet platforms and tests on each platform are required. As a
workaround, we directly update boot_cpu_physical_apicid by
read_apic_id().

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/kernel/apic/apic.c |   49 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d278736..a94f618 100644
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
@@ -2111,9 +2118,42 @@ void disconnect_bsp_APIC(int virt_wire_setup)
 int generic_processor_info(int apicid, int version)
 {
 	int cpu, max = nr_cpu_ids;
+	/*
+	 * boot_cpu_physical_apicid is designed to have the apicid
+	 * returned by read_apic_id(). However, on some platforms, it
+	 * is temporarilly modified by the apicid reported as BSP
+	 * through MP table. Concretely:
+	 *
+	 * - arch/x86/kernel/mpparse.c: MP_processor_info()
+	 * - arch/x86/mm/amdtopology.c: amd_numa_init()
+	 * - arch/x86/platform/visws/visws_quirks.c: MP_processor_info()
+	 *
+	 * This function is executed with the modified
+	 * boot_cpu_physical_apicid. So, disabled_cpu_apicid kernel
+	 * parameter doesn't work.
+	 *
+	 * Since fixing handling of boot_cpu_physical_apicid requires
+	 * another discussion and tests on each platform, we leave it
+	 * for now and here we use read_apic_id() directly by updating
+	 * global scope of boot_cpu_physical_id with the local one.
+	 */
+	unsigned int boot_cpu_physical_apicid = read_apic_id();
 	bool boot_cpu_detected = physid_isset(boot_cpu_physical_apicid,
 				phys_cpu_present_map);
 
+	if (disabled_cpu_apicid != BAD_APICID &&
+	    disabled_cpu_apicid != boot_cpu_physical_apicid &&
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
 	/*
 	 * If boot cpu has not been detected yet, then only allow upto
 	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
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

