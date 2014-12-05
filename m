Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaLEIse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:48:34 -0500
Received: from www.linutronix.de ([62.245.132.108]:34006 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaLEIsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:48:32 -0500
Message-Id: <20141205084147.153643952@linutronix.de>
User-Agent: quilt/0.63-1
Date: Fri, 05 Dec 2014 08:48:29 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: [patch 1/5] x86, smpboot: Remove pointless preempt_disable() in
 native_smp_prepare_cpus()
References: <20141204234737.728961990@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline;
 filename=x86-smpboot-remove-pointless-preempt-disables.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to keep preemption disabled in this function.

We only have two other threads live: kthreadd and idle. Neither of
them is going to preempt. But that preempt_disable forces all the code
inside to do GFP_ATOMIC allocations which is just insane.

Remove it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/smpboot.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -1084,7 +1084,6 @@ void __init native_smp_prepare_cpus(unsi
 {
 	unsigned int i;
 
-	preempt_disable();
 	smp_cpu_index_default();
 
 	/*
@@ -1102,22 +1101,19 @@ void __init native_smp_prepare_cpus(unsi
 	}
 	set_cpu_sibling_map(0);
 
-
 	if (smp_sanity_check(max_cpus) < 0) {
 		pr_info("SMP disabled\n");
 		disable_smp();
-		goto out;
+		return;
 	}
 
 	default_setup_apic_routing();
 
-	preempt_disable();
 	if (read_apic_id() != boot_cpu_physical_apicid) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
 		     read_apic_id(), boot_cpu_physical_apicid);
 		/* Or can we switch back to PIC here? */
 	}
-	preempt_enable();
 
 	connect_bsp_APIC();
 
@@ -1151,8 +1147,6 @@ void __init native_smp_prepare_cpus(unsi
 		uv_system_init();
 
 	set_mtrr_aps_delayed_init();
-out:
-	preempt_enable();
 }
 
 void arch_enable_nonboot_cpus_begin(void)


