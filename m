Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbaBFOeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:34:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:35176 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaBFOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:34:13 -0500
Date: Thu, 6 Feb 2014 15:34:18 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
cc: Ingo Molnar <mingo@kernel.org>, Bin Gao <bin.gao@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v3 1/2] x86, tsc: Fallback to normal calibration if fast
 MSR calibration fails
In-Reply-To: <1391687365-10922-1-git-send-email-mika.westerberg@linux.intel.com>
Message-ID: <alpine.DEB.2.02.1402061531310.21991@ionos.tec.linutronix.de>
References: <20140206054410.GB18884@gmail.com> <1391687365-10922-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, Mika Westerberg wrote:
>  arch/x86/kernel/tsc.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 19e5adb49a27..56facfc54575 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -655,10 +655,11 @@ unsigned long native_calibrate_tsc(void)
>  	local_irq_save(flags);
>  	i = try_msr_calibrate_tsc(&fast_calibrate);
>  	local_irq_restore(flags);
> -	if (i >= 0) {
> -		if (i == 0)
> -			pr_warn("Fast TSC calibration using MSR failed\n");
> +	if (i > 0) {
>  		return fast_calibrate;
> +	} else if (i == 0) {
> +		pr_warn("Fast TSC calibration using MSR failed\n");
> +		/* Continue with the normal calibration */
>  	}

Bah. Can we please fix that proper. The whole 0,1,-1 return value from
try_msr_calibrate_tsc() is just horrible. Why not doing the obvious?

Thanks,

	tglx
---
Index: tip/arch/x86/include/asm/tsc.h
===================================================================
--- tip.orig/arch/x86/include/asm/tsc.h
+++ tip/arch/x86/include/asm/tsc.h
@@ -66,6 +66,6 @@ extern void tsc_save_sched_clock_state(v
 extern void tsc_restore_sched_clock_state(void);
 
 /* MSR based TSC calibration for Intel Atom SoC platforms */
-int try_msr_calibrate_tsc(unsigned long *fast_calibrate);
+unsigned long try_msr_calibrate_tsc(void);
 
 #endif /* _ASM_X86_TSC_H */
Index: tip/arch/x86/kernel/tsc.c
===================================================================
--- tip.orig/arch/x86/kernel/tsc.c
+++ tip/arch/x86/kernel/tsc.c
@@ -653,13 +653,10 @@ unsigned long native_calibrate_tsc(void)
 
 	/* Calibrate TSC using MSR for Intel Atom SoCs */
 	local_irq_save(flags);
-	i = try_msr_calibrate_tsc(&fast_calibrate);
+	fast_calibrate = try_msr_calibrate_tsc();
 	local_irq_restore(flags);
-	if (i >= 0) {
-		if (i == 0)
-			pr_warn("Fast TSC calibration using MSR failed\n");
+	if (fast_calibrate)
 		return fast_calibrate;
-	}
 
 	local_irq_save(flags);
 	fast_calibrate = quick_pit_calibrate();
Index: tip/arch/x86/kernel/tsc_msr.c
===================================================================
--- tip.orig/arch/x86/kernel/tsc_msr.c
+++ tip/arch/x86/kernel/tsc_msr.c
@@ -77,21 +77,18 @@ static int match_cpu(u8 family, u8 model
 
 /*
  * Do MSR calibration only for known/supported CPUs.
- * Return values:
- * -1: CPU is unknown/unsupported for MSR based calibration
- *  0: CPU is known/supported, but calibration failed
- *  1: CPU is known/supported, and calibration succeeded
+ *
+ * Returns the calibration value or 0 if MSR calibration failed.
  */
-int try_msr_calibrate_tsc(unsigned long *fast_calibrate)
+unsigned long try_msr_calibrate_tsc(void)
 {
-	int cpu_index;
 	u32 lo, hi, ratio, freq_id, freq;
+	unsigned long res;
+	int cpu_index;
 
 	cpu_index = match_cpu(boot_cpu_data.x86, boot_cpu_data.x86_model);
 	if (cpu_index < 0)
-		return -1;
-
-	*fast_calibrate = 0;
+		return 0;
 
 	if (freq_desc_tables[cpu_index].msr_plat) {
 		rdmsr(MSR_PLATFORM_INFO, lo, hi);
@@ -103,7 +100,7 @@ int try_msr_calibrate_tsc(unsigned long
 	pr_info("Maximum core-clock to bus-clock ratio: 0x%x\n", ratio);
 
 	if (!ratio)
-		return 0;
+		goto fail;
 
 	/* Get FSB FREQ ID */
 	rdmsr(MSR_FSB_FREQ, lo, hi);
@@ -112,16 +109,19 @@ int try_msr_calibrate_tsc(unsigned long
 	pr_info("Resolved frequency ID: %u, frequency: %u KHz\n",
 				freq_id, freq);
 	if (!freq)
-		return 0;
+		goto fail;
 
 	/* TSC frequency = maximum resolved freq * maximum resolved bus ratio */
-	*fast_calibrate = freq * ratio;
-	pr_info("TSC runs at %lu KHz\n", *fast_calibrate);
+	res = freq * ratio;
+	pr_info("TSC runs at %lu KHz\n", res);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	lapic_timer_frequency = (freq * 1000) / HZ;
 	pr_info("lapic_timer_frequency = %d\n", lapic_timer_frequency);
 #endif
+	return res;
 
-	return 1;
+fail:
+	pr_warn("Fast TSC calibration using MSR failed\n");
+	return 0;
 }
