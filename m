Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab3KKRtp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:49:45 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:60358 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3KKRti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:49:38 -0500
Date: Mon, 11 Nov 2013 18:49:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/hyperv changes for v3.13
Message-ID: <20131111174934.GA14141@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-hyperv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-hyperv-for-linus

   # HEAD: 4c08edd305019061bf1ac95ce089497bdbb8b8ac x86, hyperv: Move a variable to avoid an unused variable warning

These changes enable Linux guests to boot as 'Modern VM' guest kernels on 
MS-Hyperv hosts.

 Thanks,

	Ingo

------------------>
David Rientjes (1):
      x86, hyperv: Fix build error due to missing <asm/apic.h> include

H. Peter Anvin (1):
      x86, hyperv: Move a variable to avoid an unused variable warning

K. Y. Srinivasan (2):
      x86, hyperv: Get the local APIC timer frequency from the hypervisor
      x86, hyperv: Correctly guard the local APIC calibration code


 arch/x86/include/uapi/asm/hyperv.h | 19 +++++++++++++++++++
 arch/x86/kernel/cpu/mshyperv.c     | 27 +++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/x86/include/uapi/asm/hyperv.h b/arch/x86/include/uapi/asm/hyperv.h
index b80420b..b8f1c01 100644
--- a/arch/x86/include/uapi/asm/hyperv.h
+++ b/arch/x86/include/uapi/asm/hyperv.h
@@ -27,6 +27,19 @@
 #define HV_X64_MSR_VP_RUNTIME_AVAILABLE		(1 << 0)
 /* Partition Reference Counter (HV_X64_MSR_TIME_REF_COUNT) available*/
 #define HV_X64_MSR_TIME_REF_COUNT_AVAILABLE	(1 << 1)
+
+/*
+ * There is a single feature flag that signifies the presence of the MSR
+ * that can be used to retrieve both the local APIC Timer frequency as
+ * well as the TSC frequency.
+ */
+
+/* Local APIC timer frequency MSR (HV_X64_MSR_APIC_FREQUENCY) is available */
+#define HV_X64_MSR_APIC_FREQUENCY_AVAILABLE (1 << 11)
+
+/* TSC frequency MSR (HV_X64_MSR_TSC_FREQUENCY) is available */
+#define HV_X64_MSR_TSC_FREQUENCY_AVAILABLE (1 << 11)
+
 /*
  * Basic SynIC MSRs (HV_X64_MSR_SCONTROL through HV_X64_MSR_EOM
  * and HV_X64_MSR_SINT0 through HV_X64_MSR_SINT15) available
@@ -136,6 +149,12 @@
 /* MSR used to read the per-partition time reference counter */
 #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
 
+/* MSR used to retrieve the TSC frequency */
+#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
+
+/* MSR used to retrieve the local APIC timer frequency */
+#define HV_X64_MSR_APIC_FREQUENCY		0x40000023
+
 /* Define the virtual APIC registers */
 #define HV_X64_MSR_EOI				0x40000070
 #define HV_X64_MSR_ICR				0x40000071
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 71a39f3..9f7ca26 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -15,6 +15,7 @@
 #include <linux/clocksource.h>
 #include <linux/module.h>
 #include <linux/hardirq.h>
+#include <linux/efi.h>
 #include <linux/interrupt.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
@@ -23,6 +24,8 @@
 #include <asm/desc.h>
 #include <asm/idle.h>
 #include <asm/irq_regs.h>
+#include <asm/i8259.h>
+#include <asm/apic.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -76,6 +79,30 @@ static void __init ms_hyperv_init_platform(void)
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
 
+#ifdef CONFIG_X86_LOCAL_APIC
+	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
+		/*
+		 * Get the APIC frequency.
+		 */
+		u64	hv_lapic_frequency;
+
+		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, hv_lapic_frequency);
+		hv_lapic_frequency = div_u64(hv_lapic_frequency, HZ);
+		lapic_timer_frequency = hv_lapic_frequency;
+		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
+				lapic_timer_frequency);
+
+		/*
+		 * On Hyper-V, when we are booting off an EFI firmware stack,
+		 * we do not have many legacy devices including PIC, PIT etc.
+		 */
+		if (efi_enabled(EFI_BOOT)) {
+			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
+			legacy_pic = &null_legacy_pic;
+		}
+	}
+#endif
+
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
 }
