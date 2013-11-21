Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3KUCAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 21:00:52 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38057 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176Ab3KUCAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 21:00:46 -0500
Subject: [PATCH v6 2/3] x86, apic: Add disable_cpu_apicid kernel parameter
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Thu, 21 Nov 2013 11:00:44 +0900
Message-ID: <20131121020044.2748.70221.stgit@localhost6.localdomain6>
In-Reply-To: <20131121015951.2748.47826.stgit@localhost6.localdomain6>
References: <20131121015951.2748.47826.stgit@localhost6.localdomain6>
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

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/kernel/apic/apic.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index cff8d71..77fd68d 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -83,6 +83,13 @@ unsigned int max_physical_apicid;
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
@@ -2122,6 +2129,19 @@ void generic_processor_info(int apicid, int version)
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
+		return;
+	}
+
 	/*
 	 * If boot cpu has not been detected yet, then only allow upto
 	 * nr_cpu_ids - 1 processors and keep one slot free for boot cpu
@@ -2598,3 +2618,12 @@ static int __init lapic_insert_resource(void)
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

