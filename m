Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbbAOVY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:24:56 -0500
Received: from www.linutronix.de ([62.245.132.108]:58386 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755786AbbAOVWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:22:50 -0500
Message-Id: <20150115211703.569830549@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:34 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 16/23] x86/apic: Sanitize ioapic handling
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-apic-sanitize-ioapic-handling.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have proper stubs for the IOAPIC=n case and the setup/enable
function have the required checks inside now. Remove the ifdeffery and
the copy&pasted conditionals.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |   17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -1903,24 +1903,13 @@ int __init APIC_init_uniprocessor(void)
 	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	setup_local_APIC();
 
-#ifdef CONFIG_X86_IO_APIC
-	/*
-	 * Now enable IO-APICs, actually call clear_IO_APIC
-	 * We need clear_IO_APIC before enabling error vector
-	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		enable_IO_APIC();
-#endif
+	/* Enable IO-APICs before enabling error vector */
+	enable_IO_APIC();
 
 	bsp_end_local_APIC_setup();
 
-#ifdef CONFIG_X86_IO_APIC
-	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
+	if (smp_found_config)
 		setup_IO_APIC();
-	else {
-		nr_ioapics = 0;
-	}
-#endif
 
 	x86_init.timers.setup_percpu_clockev();
 	return 0;


