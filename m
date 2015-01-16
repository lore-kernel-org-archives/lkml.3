Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbbAPIHe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 03:07:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:29232 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398AbbAPIH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 03:07:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,409,1418112000"; 
   d="scan'208";a="670932582"
Message-ID: <54B8C6BE.7020904@linux.intel.com>
Date: Fri, 16 Jan 2015 16:07:26 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [patch 06/23] x86/apic: Check x2apic early
References: <20150115210458.625399149@linutronix.de> <20150115211702.702479404@linutronix.de>
In-Reply-To: <20150115211702.702479404@linutronix.de>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	check_x2apic() is a little too early. If system panics
in check_x2apic(), it's a blank console if system panics in
check_x2apic().
	I also tried to disabled x2apic in check_x2apic() if
x2apic is enabled by BIOS but kernel doesn't support x2apic.
It may continue for a while, but eventually run into livelock
with following log messages:
[  222.436829] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[  222.436829] INTR-REMAP:[fault reason 36] Detected reserved fields in
the IRTE entry
[  222.452737] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[  222.452737] INTR-REMAP:[fault reason 36] Detected reserved fields in
the IRTE entry
[  222.468645] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[  222.468645] INTR-REMAP:[fault reason 36] Detected reserved fields in
the IRTE entry
[  222.484554] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[  222.484554] INTR-REMAP:[fault reason 36] Detected reserved fields in
the IRTE entry
[  222.500463] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[  222.500463] INTR-REMAP:[fault reason 36] Detected reserved fields in
the IRTE entry
[  222.516371] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[  222.516371] INTR-REMAP:[fault reason 36] Detected reserved fields in
the IRTE entry
[  222.532285] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2
[  222.532285] INTR-REMAP:[fault reason 36] Detected reserved fields in
the IRTE entry
[  222.548200] dmar: INTR-REMAP: Request device [[f0:1f.7] fault index 2

So seems we need to revert to original solution.
Thanks!
Gerry
	
------------------------------------------------------------------------
On 2015/1/16 5:22, Thomas Gleixner wrote:


No point in delaying the x2apic detection for the CONFIG_X86_X2APIC=n
case to enable_IR_x2apic(). We rather detect that in the early boot
code in check_x2apic().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |    6 ++----
 arch/x86/kernel/apic/apic.c |   33 +++++++++++++++++++--------------
 2 files changed, 21 insertions(+), 18 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -177,7 +177,6 @@ static inline u64 native_x2apic_icr_read

 extern int x2apic_mode;
 extern int x2apic_phys;
-extern void check_x2apic(void);
 extern void enable_x2apic(void);
 static inline int x2apic_enabled(void)
 {
@@ -193,9 +192,6 @@ static inline void x2apic_force_phys(voi
 static inline void disable_x2apic(void)
 {
 }
-static inline void check_x2apic(void)
-{
-}
 static inline void enable_x2apic(void)
 {
 }
@@ -429,6 +425,7 @@ static inline u32 safe_apic_wait_icr_idl
 }

 extern void __init apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v));
+extern void __init check_x2apic(void);

 #else /* CONFIG_X86_LOCAL_APIC */

@@ -440,6 +437,7 @@ static inline void apic_icr_write(u32 lo
 static inline void apic_wait_icr_idle(void) { }
 static inline u32 safe_apic_wait_icr_idle(void) { return 0; }
 static inline void apic_set_eoi_write(void (*eoi_write)(u32 reg, u32 v)) {}
+static inline void check_x2apic(void) { }

 #endif /* CONFIG_X86_LOCAL_APIC */

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1541,14 +1541,6 @@ static __init void disable_x2apic(void)
 	x2apic_disabled = 1;
 }

-void check_x2apic(void)
-{
-	if (x2apic_enabled()) {
-		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_mode = 1;
-	}
-}
-
 void enable_x2apic(void)
 {
 	u64 msr;
@@ -1568,7 +1560,25 @@ void enable_x2apic(void)
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
-#endif /* CONFIG_X86_X2APIC */
+
+void __init check_x2apic(void)
+{
+	if (x2apic_enabled()) {
+		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
+		x2apic_mode = 1;
+	}
+}
+#else /* CONFIG_X86_X2APIC */
+void __init check_x2apic(void)
+{
+	if (!cpu_has_apic || !apic_is_x2apic_enabled())
+		return;
+	/*
+	 * Checkme: Can we simply turn off x2apic here instead of panic?
+	 */
+	panic("BIOS has enabled x2apic but kernel doesn't support x2apic,
please disable x2apic in BIOS.\n");
+}
+#endif /* !CONFIG_X86_X2APIC */

 static int __init try_to_enable_IR(void)
 {
@@ -1620,11 +1630,6 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	int ret, ir_stat;

-	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
-		if (apic_is_x2apic_enabled())
-			panic("BIOS has enabled x2apic but kernel doesn't support x2apic,
please disable x2apic in BIOS.\n");
-	}
-
 	ir_stat = irq_remapping_prepare();
 	if (ir_stat < 0 && !x2apic_supported())
 		return;


