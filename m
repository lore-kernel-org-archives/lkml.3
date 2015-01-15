Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbbAOVW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:28 -0500
Received: from www.linutronix.de ([62.245.132.108]:58248 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbbAOVW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:27 -0500
Message-Id: <20150115211702.285038186@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:09 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 01/23] x86/apic: Avoid open coded x2apic detection
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-avoid-open-coded-x2apic-detection.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable_IR_x2apic() grew a open coded x2apic detection. Implement a
proper helper function which shares the code with the already existing
x2apic_enabled().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h |   18 +++++++++---------
 arch/x86/kernel/apic/apic.c |    5 +----
 2 files changed, 10 insertions(+), 13 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -108,6 +108,14 @@ extern u64 native_apic_icr_read(void);
 
 extern int x2apic_mode;
 
+static inline bool apic_is_x2apic_enabled(void)
+{
+	u64 msr;
+
+	rdmsrl(MSR_IA32_APICBASE, msr);
+	return msr & X2APIC_ENABLE;
+}
+
 #ifdef CONFIG_X86_X2APIC
 /*
  * Make previous memory operations globally visible before
@@ -175,15 +183,7 @@ extern void check_x2apic(void);
 extern void enable_x2apic(void);
 static inline int x2apic_enabled(void)
 {
-	u64 msr;
-
-	if (!cpu_has_x2apic)
-		return 0;
-
-	rdmsrl(MSR_IA32_APICBASE, msr);
-	if (msr & X2APIC_ENABLE)
-		return 1;
-	return 0;
+	return cpu_has_x2apic && apic_is_x2apic_enabled();
 }
 
 #define x2apic_supported()	(cpu_has_x2apic)
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1625,10 +1625,7 @@ void __init enable_IR_x2apic(void)
 	int ret, ir_stat;
 
 	if (!IS_ENABLED(CONFIG_X86_X2APIC)) {
-		u64 msr;
-
-		rdmsrl(MSR_IA32_APICBASE, msr);
-		if (msr & X2APIC_ENABLE)
+		if (apic_is_x2apic_enabled())
 			panic("BIOS has enabled x2apic but kernel doesn't support x2apic, please disable x2apic in BIOS.\n");
 	}
 


