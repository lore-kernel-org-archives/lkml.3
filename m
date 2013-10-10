Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3JJTBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:01:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586Ab3JJTBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:01:04 -0400
Date: Thu, 10 Oct 2013 12:00:24 -0700
From: "tip-bot for K. Y. Srinivasan" <tipbot@zytor.com>
Message-ID: <tip-9e7827b5ea4ca93b4d864bc07c0fafb838d496b1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        olaf@aepfle.de, kys@microsoft.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        olaf@aepfle.de, kys@microsoft.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1380554932-9888-1-git-send-email-olaf@aepfle.de>
References: <1380554932-9888-1-git-send-email-olaf@aepfle.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/hyperv] x86, hyperv:
  Get the local APIC timer frequency from the hypervisor
Git-Commit-ID: 9e7827b5ea4ca93b4d864bc07c0fafb838d496b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 10 Oct 2013 12:00:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e7827b5ea4ca93b4d864bc07c0fafb838d496b1
Gitweb:     http://git.kernel.org/tip/9e7827b5ea4ca93b4d864bc07c0fafb838d496b1
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Mon, 30 Sep 2013 17:28:52 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 10 Oct 2013 11:44:12 -0700

x86, hyperv: Get the local APIC timer frequency from the hypervisor

Hyper-V supports a mechanism for retrieving the local APIC frequency.
Use this and bypass the calibration code in the kernel . This would
allow us to boot the Linux kernel as a "modern VM" on Hyper-V where
many of the legacy devices (such as PIT) are not emulated.

I would like to thank Olaf Hering <olaf@aepfle.de>, Jan Beulich <JBeulich@suse.com> and
H. Peter Anvin <h.peter.anvin@intel.com> for their help in this effort.

In this version of the patch, I have addressed Jan's comments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Link: http://lkml.kernel.org/r/1380554932-9888-1-git-send-email-olaf@aepfle.de
Tested-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/uapi/asm/hyperv.h | 19 +++++++++++++++++++
 arch/x86/kernel/cpu/mshyperv.c     | 24 ++++++++++++++++++++++++
 2 files changed, 43 insertions(+)

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
index 71a39f3..0a490ca 100644
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
@@ -23,6 +24,7 @@
 #include <asm/desc.h>
 #include <asm/idle.h>
 #include <asm/irq_regs.h>
+#include <asm/i8259.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -67,6 +69,8 @@ static struct clocksource hyperv_cs = {
 
 static void __init ms_hyperv_init_platform(void)
 {
+	u64	hv_lapic_frequency;
+
 	/*
 	 * Extract the features and hints
 	 */
@@ -76,6 +80,26 @@ static void __init ms_hyperv_init_platform(void)
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
 
+	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
+		/*
+		 * Get the APIC frequency.
+		 */
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
+
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
 }
