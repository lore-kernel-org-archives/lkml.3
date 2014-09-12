Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbaILIS4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 04:18:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:38217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbaILISx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 04:18:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,511,1406617200"; 
   d="scan'208";a="572189658"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC Part2 v1 2/2] intel_mid: Refine the way to initialize IRQ for apb timer
Date: Fri, 12 Sep 2014 16:20:39 +0800
Message-Id: <1410510039-12759-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410510039-12759-1-git-send-email-jiang.liu@linux.intel.com>
References: <y>
 <1410510039-12759-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delay initialization of APB timer 0 after irqdomains for IOAPICs
have been initialized.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c             |   26 +++++++++++---------------
 arch/x86/platform/intel-mid/intel-mid.c |   18 ++++++++++--------
 arch/x86/platform/intel-mid/sfi.c       |   20 +++++++++-----------
 3 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 59180cd0f462..4222ba9296de 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -143,6 +143,13 @@ static inline int is_apbt_capable(void)
 	return apbt_virt_address ? 1 : 0;
 }
 
+static void apbt_setup_irq(struct apbt_dev *adev)
+{
+	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
+	__irq_set_handler(adev->irq, handle_edge_irq, 0, "edge");
+}
+
 static int __init apbt_clockevent_register(void)
 {
 	struct sfi_timer_table_entry *mtmr;
@@ -155,11 +162,12 @@ static int __init apbt_clockevent_register(void)
 		return -ENODEV;
 	}
 
-	adev->num = smp_processor_id();
+	adev->cpu = adev->num = smp_processor_id();
+	apbt_setup_irq(adev);
 	adev->timer = dw_apb_clockevent_init(smp_processor_id(), "apbt0",
 		intel_mid_timer_options == INTEL_MID_TIMER_LAPIC_APBT ?
 		APBT_CLOCKEVENT_RATING - 100 : APBT_CLOCKEVENT_RATING,
-		adev_virt_addr(adev), 0, apbt_freq);
+		adev_virt_addr(adev), adev->irq, apbt_freq);
 	/* Firmware does EOI handling for us. */
 	adev->timer->eoi = NULL;
 
@@ -177,18 +185,6 @@ static int __init apbt_clockevent_register(void)
 
 #ifdef CONFIG_SMP
 
-static void apbt_setup_irq(struct apbt_dev *adev)
-{
-	/* timer0 irq has been setup early */
-	if (adev->irq == 0)
-		return;
-
-	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
-	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
-	/* APB timer irqs are set up as mp_irqs, timer is edge type */
-	__irq_set_handler(adev->irq, handle_edge_irq, 0, "edge");
-}
-
 /* Should be called with per cpu */
 void apbt_setup_secondary_clock(void)
 {
@@ -202,6 +198,7 @@ void apbt_setup_secondary_clock(void)
 
 	adev = &__get_cpu_var(cpu_apbt_dev);
 	if (!adev->timer) {
+		apbt_setup_irq(adev);
 		adev->timer = dw_apb_clockevent_init(cpu, adev->name,
 			APBT_CLOCKEVENT_RATING, adev_virt_addr(adev),
 			adev->irq, apbt_freq);
@@ -213,7 +210,6 @@ void apbt_setup_secondary_clock(void)
 	printk(KERN_INFO "Registering CPU %d clockevent device %s, cpu %08x\n",
 	       cpu, adev->name, adev->cpu);
 
-	apbt_setup_irq(adev);
 	dw_apb_clockevent_register(adev->timer);
 
 	return;
diff --git a/arch/x86/platform/intel-mid/intel-mid.c b/arch/x86/platform/intel-mid/intel-mid.c
index 1bbedc4b0f88..9d5d841a6ae5 100644
--- a/arch/x86/platform/intel-mid/intel-mid.c
+++ b/arch/x86/platform/intel-mid/intel-mid.c
@@ -81,6 +81,12 @@ static unsigned long __init intel_mid_calibrate_tsc(void)
 	return 0;
 }
 
+static void __init intel_mid_setup_timer(void)
+{
+	apbt_time_init();
+	setup_boot_APIC_clock();
+}
+
 static void __init intel_mid_time_init(void)
 {
 	sfi_table_parse(SFI_SIG_MTMR, NULL, NULL, sfi_parse_mtmr);
@@ -88,7 +94,7 @@ static void __init intel_mid_time_init(void)
 	case INTEL_MID_TIMER_APBT_ONLY:
 		break;
 	case INTEL_MID_TIMER_LAPIC_APBT:
-		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
+		x86_init.timers.setup_percpu_clockev = intel_mid_setup_timer;
 		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
 		break;
 	default:
@@ -96,11 +102,8 @@ static void __init intel_mid_time_init(void)
 			break;
 		x86_init.timers.setup_percpu_clockev = setup_boot_APIC_clock;
 		x86_cpuinit.setup_percpu_clockev = setup_secondary_APIC_clock;
-		return;
+		break;
 	}
-	/* we need at least one APB timer */
-	pre_init_apic_IRQ0();
-	apbt_time_init();
 }
 
 static void intel_mid_arch_setup(void)
@@ -165,14 +168,13 @@ void __init x86_intel_mid_early_setup(void)
 	x86_init.resources.reserve_resources = x86_init_noop;
 
 	x86_init.timers.timer_init = intel_mid_time_init;
-	x86_init.timers.setup_percpu_clockev = x86_init_noop;
+	x86_init.timers.setup_percpu_clockev = apbt_time_init;
+	x86_cpuinit.setup_percpu_clockev = apbt_setup_secondary_clock;
 
 	x86_init.irqs.pre_vector_init = x86_init_noop;
 
 	x86_init.oem.arch_setup = intel_mid_arch_setup;
 
-	x86_cpuinit.setup_percpu_clockev = apbt_setup_secondary_clock;
-
 	x86_platform.calibrate_tsc = intel_mid_calibrate_tsc;
 	x86_platform.i8042_detect = intel_mid_i8042_detect;
 	x86_init.timers.wallclock_init = intel_mid_rtc_init;
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 3c53a90fdb18..1c012fc8373c 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -95,17 +95,15 @@ int __init sfi_parse_mtmr(struct sfi_table_header *table)
 		pr_debug("timer[%d]: paddr = 0x%08x, freq = %dHz, irq = %d\n",
 			totallen, (u32)pentry->phys_addr,
 			pentry->freq_hz, pentry->irq);
-			if (!pentry->irq)
-				continue;
-			mp_irq.type = MP_INTSRC;
-			mp_irq.irqtype = mp_INT;
-/* triggering mode edge bit 2-3, active high polarity bit 0-1 */
-			mp_irq.irqflag = 5;
-			mp_irq.srcbus = MP_BUS_ISA;
-			mp_irq.srcbusirq = pentry->irq;	/* IRQ */
-			mp_irq.dstapic = MP_APIC_ALL;
-			mp_irq.dstirq = pentry->irq;
-			mp_save_irq(&mp_irq);
+		mp_irq.type = MP_INTSRC;
+		mp_irq.irqtype = mp_INT;
+		/* triggering mode edge bit 2-3, active high polarity bit 0-1 */
+		mp_irq.irqflag = 5;
+		mp_irq.srcbus = MP_BUS_ISA;
+		mp_irq.srcbusirq = pentry->irq;	/* IRQ */
+		mp_irq.dstapic = MP_APIC_ALL;
+		mp_irq.dstirq = pentry->irq;
+		mp_save_irq(&mp_irq);
 	}
 
 	return 0;
-- 
1.7.10.4

