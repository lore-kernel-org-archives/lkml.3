Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbbAOVXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:23:05 -0500
Received: from www.linutronix.de ([62.245.132.108]:58453 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbbAOVXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:23:02 -0500
Message-Id: <20150115211704.162567839@linutronix.de>
User-Agent: quilt/0.63-1
Date: Thu, 15 Jan 2015 21:22:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org, Tony Luck <tony.luck@intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [patch 23/23] x86: Consolidate boot cpu timer setup
References: <20150115210458.625399149@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=x86-consolidate-bsp-timer-setup.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the APIC bringup is consolidated we can move the setup call
for the percpu clock event device to apic_bsp_setup().

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/apic.c |    4 ++--
 arch/x86/kernel/smpboot.c   |    4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: tip/arch/x86/kernel/apic/apic.c
===================================================================
--- tip.orig/arch/x86/kernel/apic/apic.c
+++ tip/arch/x86/kernel/apic/apic.c
@@ -2243,6 +2243,8 @@ int __init apic_bsp_setup(bool upmode)
 	end_local_APIC_setup();
 	irq_remap_enable_fault_handling();
 	setup_IO_APIC();
+	/* Setup local timer */
+	x86_init.timers.setup_percpu_clockev();
 	return id;
 }
 
@@ -2283,8 +2285,6 @@ int __init APIC_init_uniprocessor(void)
 	default_setup_apic_routing();
 	verify_local_APIC();
 	apic_bsp_setup(true);
-
-	x86_init.timers.setup_percpu_clockev();
 	return 0;
 }
 #ifndef CONFIG_SMP
Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -1163,12 +1163,8 @@ void __init native_smp_prepare_cpus(unsi
 
 	cpu0_logical_apicid = apic_bsp_setup(false);
 
-	/*
-	 * Set up local APIC timer on boot CPU.
-	 */
 	pr_info("CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
-	x86_init.timers.setup_percpu_clockev();
 
 	if (is_uv_system())
 		uv_system_init();


