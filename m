Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbbATDMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:12:13 -0500
Received: from mga03.intel.com ([134.134.136.65]:51467 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751811AbbATDMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:12:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442529700"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: [Patch Part1 v7 29/38] x86/intel-mid: Delay initialization of APB timer
Date: Tue, 20 Jan 2015 11:08:32 +0800
Message-Id: <1421723321-8386-30-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

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
point the IOAPIC is setup already, so it should just work.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Link: http://lkml.kernel.org/r/1416901802-24211-2-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c             |    4 ----
 arch/x86/platform/intel-mid/intel-mid.c |   18 +++++++++++++-----
 arch/x86/platform/intel-mid/sfi.c       |    2 --
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index b708738d016e..7cfdc5467922 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -179,10 +179,6 @@ static int __init apbt_clockevent_register(void)
 
 static void apbt_setup_irq(struct apbt_dev *adev)
 {
-	/* timer0 irq has been setup early */
-	if (adev->irq == 0)
-		return;
-
 	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
 	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
 }
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 1bbedc4b0f88..d8e23a622a33 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -81,26 +81,34 @@ static unsigned long __init intel_mid_calibrate_tsc(void)
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
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index c14ad34776c4..aa59f88868f8 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -95,8 +95,6 @@ int __init sfi_parse_mtmr(struct sfi_table_header *table)
 		pr_debug("timer[%d]: paddr = 0x%08x, freq = %dHz, irq = %d\n",
 			totallen, (u32)pentry->phys_addr,
 			pentry->freq_hz, pentry->irq);
-			if (!pentry->irq)
-				continue;
 			mp_irq.type = MP_INTSRC;
 			mp_irq.irqtype = mp_INT;
 /* triggering mode edge bit 2-3, active high polarity bit 0-1 */
-- 
1.7.10.4

