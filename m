Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaKZXSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:18:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbaKZXSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:42 -0500
Date: Wed, 26 Nov 2014 15:12:53 -0800
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-b1f0b70db8679a0e4fa456cd7c12fbb42050c190@git.kernel.org>
Cc: benh@kernel.crashing.org, rdunlap@infradead.org, tglx@linutronix.de,
        andriy.shevchenko@linux.intel.com, david.a.cohen@linux.intel.com,
        hpa@zytor.com, mingo@kernel.org, bp@alien8.de,
        sathyanarayanan.kuppuswamy@linux.intel.com, gregkh@linuxfoundation.org,
        yinghai@kernel.org, hpa@linux.intel.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com,
        bhelgaas@google.com, joro@8bytes.org, konrad.wilk@oracle.com,
        tony.luck@intel.com
Reply-To: konrad.wilk@oracle.com, tony.luck@intel.com, bhelgaas@google.com,
        joro@8bytes.org, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net, hpa@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bp@alien8.de,
        yinghai@kernel.org, gregkh@linuxfoundation.org, mingo@kernel.org,
        hpa@zytor.com, andriy.shevchenko@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de,
        rdunlap@infradead.org, benh@kernel.crashing.org
In-Reply-To: <1416901802-24211-2-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-2-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, intel-mid: Delay initialization of APB timer
Git-Commit-ID: b1f0b70db8679a0e4fa456cd7c12fbb42050c190
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b1f0b70db8679a0e4fa456cd7c12fbb42050c190
Gitweb:     http://git.kernel.org/tip/b1f0b70db8679a0e4fa456cd7c12fbb42050c190
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Tue, 25 Nov 2014 15:49:25 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:46 +0100

x86, intel-mid: Delay initialization of APB timer

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
 arch/x86/kernel/apb_timer.c             |  4 ----
 arch/x86/platform/intel-mid/intel-mid.c | 18 +++++++++++++-----
 arch/x86/platform/intel-mid/sfi.c       |  2 --
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index b708738..7cfdc54 100644
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
index 1bbedc4..d8e23a6 100644
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
index c14ad34..aa59f88 100644
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
