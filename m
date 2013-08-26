Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3HZXBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 19:01:55 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45112
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616Ab3HZXBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 19:01:53 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, hpa@zytor.com, JBeulich@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] X86: Hyper-V: Get the local APIC timer frequency from the hypervisor
Date: Mon, 26 Aug 2013 16:42:15 -0700
Message-Id: <1377560535-8184-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hyper-V supports a mechanism for retrieving the local API frequency.Use this and bypass
the calibration code in the kernel. This would allow us to boot the Linux kernel as a
"modern VM" on Hyper-V where many of the legacy devices (such as PIT) are not emulated.

I would like to thank Olaf Hering <olaf@aepfle.de>, Jan Beulich <JBeulich@suse.com> and
H. Peter Anvin <h.peter.anvin@intel.com> for their help in this effort.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/include/uapi/asm/hyperv.h |   13 +++++++++++++
 arch/x86/kernel/cpu/mshyperv.c     |   17 +++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/uapi/asm/hyperv.h b/arch/x86/include/uapi/asm/hyperv.h
index b80420b..df3d680 100644
--- a/arch/x86/include/uapi/asm/hyperv.h
+++ b/arch/x86/include/uapi/asm/hyperv.h
@@ -27,6 +27,13 @@
 #define HV_X64_MSR_VP_RUNTIME_AVAILABLE		(1 << 0)
 /* Partition Reference Counter (HV_X64_MSR_TIME_REF_COUNT) available*/
 #define HV_X64_MSR_TIME_REF_COUNT_AVAILABLE	(1 << 1)
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
@@ -136,6 +143,12 @@
 /* MSR used to read the per-partition time reference counter */
 #define HV_X64_MSR_TIME_REF_COUNT		0x40000020
 
+/* MSR used to retrive the TSC frequency */
+#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
+
+/* MSR used to retrive the local APIC timer frequency */
+#define HV_X64_MSR_APIC_FREQUENCY		0x40000023
+
 /* Define the virtual APIC registers */
 #define HV_X64_MSR_EOI				0x40000070
 #define HV_X64_MSR_ICR				0x40000071
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 71a39f3..0593fd9 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -23,6 +23,7 @@
 #include <asm/desc.h>
 #include <asm/idle.h>
 #include <asm/irq_regs.h>
+#include <asm/i8259.h>
 
 struct ms_hyperv_info ms_hyperv;
 EXPORT_SYMBOL_GPL(ms_hyperv);
@@ -76,6 +77,22 @@ static void __init ms_hyperv_init_platform(void)
 	printk(KERN_INFO "HyperV: features 0x%x, hints 0x%x\n",
 	       ms_hyperv.features, ms_hyperv.hints);
 
+	if (ms_hyperv.features & HV_X64_MSR_APIC_FREQUENCY_AVAILABLE) {
+		/*
+		 * There is no need to calibrate APIC timer frequency;
+		 * nor is there a need to calibrate timer.
+		 */
+		legacy_pic = &null_legacy_pic;
+
+		/*
+		 * Get the APIC frequency.
+		 */
+		rdmsrl(HV_X64_MSR_APIC_FREQUENCY, lapic_timer_frequency);
+		lapic_timer_frequency /= HZ;
+		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: 0x%x\n",
+				lapic_timer_frequency);
+	}
+
 	if (ms_hyperv.features & HV_X64_MSR_TIME_REF_COUNT_AVAILABLE)
 		clocksource_register_hz(&hyperv_cs, NSEC_PER_SEC/100);
 }
-- 
1.7.4.1

