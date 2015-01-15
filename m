Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbbAOVWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:22:33 -0500
Received: from www.linutronix.de ([62.245.132.108]:58277 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbbAOVWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:32 -0500
Message-Id: <20150115211702.621431109@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 05/23] x86/apic: Make disable x2apic work really
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-apic-make-disable-x2apic-work-really.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If x2apic_preenabled is not enabled, then disable_x2apic() is not
called from various places which results in x2apic_disabled not being
set. So other code pathes can happily reenable the x2apic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1479,8 +1479,6 @@ static bool nox2apic __initdata;
 
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
-/* x2apic enabled before OS handover */
-static int x2apic_preenabled;
 static int x2apic_disabled;
 static int __init setup_nox2apic(char *str)
 {
@@ -1535,18 +1533,19 @@ static __init void disable_x2apic(void)
 			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 		}
 
-		x2apic_disabled = 1;
 		x2apic_mode = 0;
 
 		register_lapic_address(mp_lapic_addr);
 	}
+
+	x2apic_disabled = 1;
 }
 
 void check_x2apic(void)
 {
 	if (x2apic_enabled()) {
 		pr_info("x2apic enabled by BIOS, switching to x2apic ops\n");
-		x2apic_preenabled = x2apic_mode = 1;
+		x2apic_mode = 1;
 	}
 }
 
@@ -1569,8 +1568,6 @@ void enable_x2apic(void)
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
 }
-#else
-#define x2apic_preenabled	(0)
 #endif /* CONFIG_X86_X2APIC */
 
 static int __init try_to_enable_IR(void)
@@ -1599,8 +1596,7 @@ static __init void try_to_enable_x2apic(
 		    (IS_ENABLED(CONFIG_HYPERVISOR_GUEST) &&
 		     !hypervisor_x2apic_available())) {
 			pr_info("IRQ remapping doesn't support X2APIC mode, disable x2apic.\n");
-			if (x2apic_preenabled)
-				disable_x2apic();
+			disable_x2apic();
 			return;
 		}
 
@@ -1643,7 +1639,7 @@ void __init enable_IR_x2apic(void)
 	legacy_pic->mask_all();
 	mask_ioapic_entries();
 
-	if (x2apic_preenabled && nox2apic)
+	if (nox2apic)
 		disable_x2apic();
 	/* If irq_remapping_prepare() succeded, try to enable it */
 	if (ir_stat >= 0)


