Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbbAOV1Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:27:25 -0500
Received: from www.linutronix.de ([62.245.132.108]:58317 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328AbbAOVWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:38 -0500
Message-Id: <20150115211702.955392443@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:22 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 09/23] x86/x2apic: Add proper state tracking
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-x2apic-add-state-tracking.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having 3 different variables to track the state is just silly and
error prone. Add a proper state tracking variable which covers the
three possible states: ON/OFF/DISABLED.

We cannot use x2apic_mode for this as this would require to change all
users of x2apic_mode with explicit comparisons for a state value
instead of treating it as boolean.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1480,6 +1480,14 @@ static bool nox2apic __initdata;
 #ifdef CONFIG_X86_X2APIC
 int x2apic_mode;
 static int x2apic_disabled;
+
+enum {
+	X2APIC_OFF,
+	X2APIC_ON,
+	X2APIC_DISABLED,
+};
+static int x2apic_state;
+
 static int __init setup_nox2apic(char *str)
 {
 	if (x2apic_enabled()) {
@@ -1496,7 +1504,7 @@ static int __init setup_nox2apic(char *s
 		setup_clear_cpu_cap(X86_FEATURE_X2APIC);
 
 	nox2apic = true;
-
+	x2apic_state = X2APIC_DISABLED;
 	return 0;
 }
 early_param("nox2apic", setup_nox2apic);
@@ -1539,6 +1547,7 @@ static __init void disable_x2apic(void)
 	}
 
 	x2apic_disabled = 1;
+	x2apic_state = X2APIC_DISABLED;
 }
 
 void enable_x2apic(void)
@@ -1559,6 +1568,7 @@ void enable_x2apic(void)
 		printk_once(KERN_INFO "Enabling x2apic\n");
 		wrmsrl(MSR_IA32_APICBASE, msr | X2APIC_ENABLE);
 	}
+	x2apic_state = X2APIC_ON;
 }
 
 static __init void try_to_enable_x2apic(int remap_mode)
@@ -1597,6 +1607,9 @@ void __init check_x2apic(void)
 	if (x2apic_enabled()) {
 		pr_info("x2apic: enabled by BIOS, switching to x2apic ops\n");
 		x2apic_mode = 1;
+		x2apic_state = X2APIC_ON;
+	} else if (!cpu_has_x2apic) {
+		x2apic_state = X2APIC_DISABLED;
 	}
 }
 #else /* CONFIG_X86_X2APIC */


