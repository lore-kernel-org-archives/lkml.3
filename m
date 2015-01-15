Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbbAOV2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:28:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:58268 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306AbbAOVWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:30 -0500
Message-Id: <20150115211702.541280622@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:14 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 04/23] x86/ioapic: Check x2apic really
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-ioapic-check-x2apic-really.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x2apic_preenabled flag is just a horrible hack and if X2APIC
support is disabled it does not reflect the actual hardware
state. Check the hardware instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/apic.h    |    2 --
 arch/x86/kernel/apic/apic.c    |    4 +++-
 arch/x86/kernel/apic/io_apic.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

Index: tip/arch/x86/include/asm/apic.h
===================================================================
--- tip.orig/arch/x86/include/asm/apic.h
+++ tip/arch/x86/include/asm/apic.h
@@ -177,7 +177,6 @@ static inline u64 native_x2apic_icr_read
 
 extern int x2apic_mode;
 extern int x2apic_phys;
-extern int x2apic_preenabled;
 extern void check_x2apic(void);
 extern void enable_x2apic(void);
 static inline int x2apic_enabled(void)
@@ -209,7 +208,6 @@ static inline void x2apic_force_phys(voi
 }
 
 #define x2apic_mode		(0)
-#define	x2apic_preenabled	(0)
 #define	x2apic_supported()	(0)
 #endif
 
Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1480,7 +1480,7 @@ static bool nox2apic __initdata;
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
 /* x2apic enabled before OS handover */
-int x2apic_preenabled;
+static int x2apic_preenabled;
 static int x2apic_disabled;
 static int __init setup_nox2apic(char *str)
 {
@@ -1569,6 +1569,8 @@ void enable_x2apic(void)
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
+#else
+#define x2apic_preenabled	(0)
 #endif /* CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
Index: tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/io_apic.c
+++ tip/arch/x86/kernel/apic/io_apic.c
@@ -2295,7 +2295,7 @@ static inline void __init check_timer(vo
 	}
 	local_irq_disable();
 	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
-	if (x2apic_preenabled)
+	if (apic_is_x2apic_enabled())
 		apic_printk(APIC_QUIET, KERN_INFO
 			    "Perhaps problem with the pre-enabled x2apic mode\n"
 			    "Try booting with x2apic and interrupt-remapping disabled in the bios.\n");


