Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaATNm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 08:42:27 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:38673 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbaATNmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 08:42:24 -0500
Date: Mon, 20 Jan 2014 14:42:20 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.14
Message-ID: <20140120134220.GA12050@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   # HEAD: 5b4d1dbc24bb6fd7179ada0f47be34e27e64decb x86, apic: Make disabled_cpu_apicid static read_mostly, fix typos

Two main changes:

 - Improve local APIC Error Status Register reporting robustness.

 - Add the 'disable_cpu_apicid=x' boot parameter for kexec booting.

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, apic: Make disabled_cpu_apicid static read_mostly, fix typos

HATAYAMA Daisuke (1):
      x86, apic, kexec: Add disable_cpu_apicid kernel parameter

Richard Weinberger (1):
      x86/apic: Read Error Status Register correctly


 Documentation/kernel-parameters.txt |  9 +++++
 arch/x86/kernel/apic/apic.c         | 66 ++++++++++++++++++++++++++++++++-----
 2 files changed, 66 insertions(+), 9 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b9e9bd8..6fdbf8c 100644
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
index d278736..7f26c9a 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -75,6 +75,13 @@ unsigned int max_physical_apicid;
 physid_mask_t phys_cpu_present_map;
 
 /*
+ * Processor to be disabled specified by kernel parameter
+ * disable_cpu_apicid=<int>, mostly used for the kdump 2nd kernel to
+ * avoid undefined behaviour caused by sending INIT from AP to BSP.
+ */
+static unsigned int disabled_cpu_apicid __read_mostly = BAD_APICID;
+
+/*
  * Map cpu index to physical APIC ID
  */
 DEFINE_EARLY_PER_CPU_READ_MOSTLY(u16, x86_cpu_to_apicid, BAD_APICID);
@@ -1968,7 +1975,7 @@ __visible void smp_trace_spurious_interrupt(struct pt_regs *regs)
  */
 static inline void __smp_error_interrupt(struct pt_regs *regs)
 {
-	u32 v0, v1;
+	u32 v;
 	u32 i = 0;
 	static const char * const error_interrupt_reason[] = {
 		"Send CS error",		/* APIC Error Bit 0 */
@@ -1982,21 +1989,20 @@ static inline void __smp_error_interrupt(struct pt_regs *regs)
 	};
 
 	/* First tickle the hardware, only then report what went on. -- REW */
-	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
-	v1 = apic_read(APIC_ESR);
+	v = apic_read(APIC_ESR);
 	ack_APIC_irq();
 	atomic_inc(&irq_err_count);
 
-	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
-		    smp_processor_id(), v0 , v1);
+	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x",
+		    smp_processor_id(), v);
 
-	v1 = v1 & 0xff;
-	while (v1) {
-		if (v1 & 0x1)
+	v &= 0xff;
+	while (v) {
+		if (v & 0x1)
 			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
 		i++;
-		v1 >>= 1;
+		v >>= 1;
 	}
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
@@ -2115,6 +2121,39 @@ int generic_processor_info(int apicid, int version)
 				phys_cpu_present_map);
 
 	/*
+	 * boot_cpu_physical_apicid is designed to have the apicid
+	 * returned by read_apic_id(), i.e, the apicid of the
+	 * currently booting-up processor. However, on some platforms,
+	 * it is temporarily modified by the apicid reported as BSP
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
+		pr_warning("APIC: Disabling requested cpu."
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
@@ -2592,3 +2631,12 @@ static int __init lapic_insert_resource(void)
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
