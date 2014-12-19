Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaLSOzT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:55:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:6793 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbaLSOzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:55:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,607,1413270000"; 
   d="scan'208,223";a="626595180"
Message-ID: <54943C44.5080503@linux.intel.com>
Date: Fri, 19 Dec 2014 22:55:00 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>, konrad.wilk@oracle.com,
        David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: Bisected Linux regression: ACPI powerbutton events don't work
 under Xen since commit b81975eade8c6495f3c4d6746d22bdc95f617777
References: <1824124380.20141219141645@eikelenboom.it>
In-Reply-To: <1824124380.20141219141645@eikelenboom.it>
Content-Type: multipart/mixed;
 boundary="------------070406090201060806040107"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070406090201060806040107
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi Sander,
	Could you please help to test attached patch? It works
on native but I have no Xen environment at hand.
Thanks!
Gerry

On 2014/12/19 21:16, Sander Eikelenboom wrote:
> Hi,
> 
> When running under Xen, ACPI powerbutton events don't work anymore, 
> there is no reaction when pressing the powerbutton.
> 
> On baremetal everything works fine, acpid gets the event and the 
> machine powers down perfectly. The machine is an Intel NUC.
>  
> Bisection has lead to:
> 
> b81975eade8c6495f3c4d6746d22bdc95f617777 is the first bad commit
> commit b81975eade8c6495f3c4d6746d22bdc95f617777
> Author: Jiang Liu <jiang.liu@linux.intel.com>
> Date:   Mon Jun 9 16:20:11 2014 +0800
> 
>     x86, irq: Clean up irqdomain transition code
> 
>     Now we have completely switched to irqdomain, so clean up transition code
>     in IOAPIC drivers.
> 
>     Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>     Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>     Cc: Tony Luck <tony.luck@intel.com>
>     Cc: Joerg Roedel <joro@8bytes.org>
>     Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>     Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>     Cc: Grant Likely <grant.likely@linaro.org>
>     Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
>     Cc: Bjorn Helgaas <bhelgaas@google.com>
>     Cc: Randy Dunlap <rdunlap@infradead.org>
>     Cc: Yinghai Lu <yinghai@kernel.org>
>     Link: http://lkml.kernel.org/r/1402302011-23642-43-git-send-email-jiang.liu@linux.intel.com
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Reverting this specific commit on linux-tip (3.19-mw) gets things working again under Xen.
> Kernel .config is attached.
> 
> --
> Sander
> 

--------------070406090201060806040107
Content-Type: text/x-patch;
 name="0001-x86-apic-Fix-xen-failure-caused-by-commit-b81975eade.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-apic-Fix-xen-failure-caused-by-commit-b81975eade.pa";
 filename*1="tch"

>From a6928b3c93a5119c79b8a7aec953579c87d2a4cc Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@linux.intel.com>
Date: Fri, 19 Dec 2014 22:33:56 +0800
Subject: [PATCH] x86/apic: Fix xen failure caused by commit b81975eade8c

Commit b81975eade8c "x86, irq: Clean up irqdomain transition code"
breaks Xen because xen_smp_prepare_cpus() doesn't call setup_IO_APIC()
so mp_map_pin_to_irq() fails at the very beginning.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h        |    2 +-
 arch/x86/include/asm/smpboot_hooks.h |    6 +++---
 arch/x86/kernel/apic/apic.c          |    6 +++---
 arch/x86/kernel/apic/io_apic.c       |   32 +++++++++++++++-----------------
 arch/x86/xen/smp.c                   |    3 +++
 5 files changed, 25 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 4615906d83df..0c6530dfd817 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -98,7 +98,7 @@ extern void trace_call_function_single_interrupt(void);
 #define IO_APIC_IRQ(x) (((x) >= NR_IRQS_LEGACY) || ((1<<(x)) & io_apic_irqs))
 extern unsigned long io_apic_irqs;
 
-extern void setup_IO_APIC(void);
+extern void setup_IO_APIC(bool xen_smp);
 extern void disable_IO_APIC(void);
 
 struct io_apic_irq_attr {
diff --git a/arch/x86/include/asm/smpboot_hooks.h b/arch/x86/include/asm/smpboot_hooks.h
index 0da7409f0bec..76e5731b03cb 100644
--- a/arch/x86/include/asm/smpboot_hooks.h
+++ b/arch/x86/include/asm/smpboot_hooks.h
@@ -52,9 +52,9 @@ static inline void __init smpboot_setup_io_apic(void)
 	 * Here we can be sure that there is an IO-APIC in the system. Let's
 	 * go and set it up:
 	 */
-	if (!skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else {
+	if (!skip_ioapic_setup && nr_ioapics) {
+		setup_IO_APIC(false);
+	} else {
 		nr_ioapics = 0;
 	}
 #endif
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index ba6cc041edb1..33ba1f97abea 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1912,9 +1912,9 @@ int __init APIC_init_uniprocessor(void)
 	bsp_end_local_APIC_setup();
 
 #ifdef CONFIG_X86_IO_APIC
-	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
-		setup_IO_APIC();
-	else {
+	if (smp_found_config && !skip_ioapic_setup && nr_ioapics) {
+		setup_IO_APIC(false);
+	} else {
 		nr_ioapics = 0;
 	}
 #endif
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a6745e756729..5879ac58c3b6 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2965,31 +2965,29 @@ static int mp_irqdomain_create(int ioapic)
 	return 0;
 }
 
-void __init setup_IO_APIC(void)
+void __init setup_IO_APIC(bool xen_smp)
 {
 	int ioapic;
 
-	/*
-	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
-	 */
-	io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
+	if (!xen_smp) {
+		apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
+		io_apic_irqs = nr_legacy_irqs() ? ~PIC_IRQS : ~0UL;
+
+		/* Set up IO-APIC IRQ routing. */
+		x86_init.mpparse.setup_ioapic_ids();
+		sync_Arb_IDs();
+	}
 
-	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 	for_each_ioapic(ioapic)
 		BUG_ON(mp_irqdomain_create(ioapic));
-
-	/*
-         * Set up IO-APIC IRQ routing.
-         */
-	x86_init.mpparse.setup_ioapic_ids();
-
-	sync_Arb_IDs();
 	setup_IO_APIC_irqs();
-	init_IO_APIC_traps();
-	if (nr_legacy_irqs())
-		check_timer();
-
 	ioapic_initialized = 1;
+
+	if (!xen_smp) {
+		init_IO_APIC_traps();
+		if (nr_legacy_irqs())
+			check_timer();
+	}
 }
 
 /*
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 4c071aeb8417..7eb0283901fa 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -326,7 +326,10 @@ static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 
 		xen_raw_printk(m);
 		panic(m);
+	} else {
+		setup_IO_APIC(true);
 	}
+
 	xen_init_lock_cpu(0);
 
 	smp_store_boot_cpu_info();
-- 
1.7.10.4


--------------070406090201060806040107--
