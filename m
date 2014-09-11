Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbaIKM6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:58:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:39901 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbaIKM6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:58:37 -0400
Date: Thu, 11 Sep 2014 14:58:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>, x86@kernel.org
Subject: Re: Ask help about pre_init_apic_IRQ0()
In-Reply-To: <54116106.5090904@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1409111225380.4178@nanos>
References: <54116106.5090904@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiang,

On Thu, 11 Sep 2014, Jiang Liu wrote:
> When converting IOAPIC to hierarchy irqdomain, I ran into trouble when
> dealing with pre_init_apic_IRQ0(). Currently pre_init_apic_IRQ0() is
> only used by intel-mid platform and is called before initializing of
> IOAPIC irqdomains. That really causes headache when converting to
> hierarchy irqdomain. So could we delay
> 	io_apic_setup_irq_pin(0, 0, &attr);
>         irq_set_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq,
>                                       "edge");
> to the point of "check_timer()"?

MID has no PIC, but depending on the platform it requires the
abt_timer, which is connected to irq0. The timer is set up at
late_time_init().

But, looking at the MID code it seems, that there is no reason to do
so. The only code which might need the timer working is the TSC
calibration code, but thats a non issue on MID as that is using its
own empty calibration function. And check_timer() is not invoked
either because MID has no PIC and therefor no legacy irqs.

So if you look at intel_mid_time_init() then you'll see that in the
ARAT case the timer setup is skipped already. So until the point where
x86_init.timers.setup_percpu_clockev() is called for the boot cpu
nothing really needs a timer on MID.

According to the MID code the apbt horror is only used for moorestown.
Medfield and later use the local apic timer without the apbt nonsense.

The best thing we can do is to drop moorestown support and get rid of
that apbt nonsense alltogether.

I don't think anyone deeply cares about it not being supported from
3.18 on. The number of devices which sport a moorestown should be
pretty limited and the only relevant use case of those is to act as a
pocket heater with short battery life time. Its pretty pointless to
update kernels on pocket heaters except for bragging reasons.

If someone at Intel really thinks that we need to keep moorestown
alive for other than documentary and sentimental reasons, then we can
move the apbt setup to x86_init.timers.setup_percpu_clockev(). At that
point the IOAPIC is setup already, so it should just work. Untested
patch below.

Thanks,

	tglx

------------------
Index: linux/arch/x86/platform/intel-mid/intel-mid.c
===================================================================
--- linux.orig/arch/x86/platform/intel-mid/intel-mid.c
+++ linux/arch/x86/platform/intel-mid/intel-mid.c
@@ -81,26 +81,34 @@ static unsigned long __init intel_mid_ca
 	return 0;
 }
 
+static void __init intel_mid_setup_bp_timer(void)
+{
+	apbt_time_init();
+	setup_boot_APIC_clock();
+}
+
 static void __init intel_mid_time_init(void)
 {
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
+
 	switch (intel_mid_timer_options) {
 	case INTEL_MID_TIMER_APBT_ONLY:
 		break;
 	case INTEL_MID_TIMER_LAPIC_APBT:
-		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
+		/* Use apbt and local apic */
+		x86_init.timers.setup_percpu_clockev = intel_mid_setup_bp_timer;
 		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
-		break;
+		return;
 	default:
 		if (!boot_cpu_has(X86_FEATURE_ARAT))
 			break;
+		/* Lapic only, no apbt */
 		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
 		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
 		return;
 	}
-	/* we need at least one APB timer */
-	pre_init_apic_IRQ0();
-	apbt_time_init();
+
+	x86_init.timers.setup_percpu_clockev = apbt_time_init;
 }
 
 static void intel_mid_arch_setup(void)
