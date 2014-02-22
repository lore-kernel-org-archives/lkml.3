Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaBVX7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:59:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:49251 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBVX7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:59:44 -0500
Date: Sun, 23 Feb 2014 00:59:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 fixes for 3.14
Message-ID: <alpine.DEB.2.02.1402230050020.21251@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

This pull request provides:

     * A bugfix which prevents a divide by 0 panic when the in 3.14
       newly introduced try_msr_calibrate_tsc() fails.

     * The enablement of the Baytrail platform to utilize the new
       fangled msr based calibration

Thanks,

	tglx

------------------>
Mika Westerberg (1):
      x86: tsc: Add missing Baytrail frequency to the table

Thomas Gleixner (1):
      x86, tsc: Fallback to normal calibration if fast MSR calibration fails


 arch/x86/include/asm/tsc.h |    2 +-
 arch/x86/kernel/tsc.c      |    7 ++-----
 arch/x86/kernel/tsc_msr.c  |   30 +++++++++++++++---------------
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/tsc.h b/arch/x86/include/asm/tsc.h
index 57ae63c..94605c0 100644
--- a/arch/x86/include/asm/tsc.h
+++ b/arch/x86/include/asm/tsc.h
@@ -66,6 +66,6 @@ extern void tsc_save_sched_clock_state(void);
 extern void tsc_restore_sched_clock_state(void);
 
 /* MSR based TSC calibration for Intel Atom SoC platforms */
-int try_msr_calibrate_tsc(unsigned long *fast_calibrate);
+unsigned long try_msr_calibrate_tsc(void);
 
 #endif /* _ASM_X86_TSC_H */
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index acb3b60..cfbe99f 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
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
diff --git a/arch/x86/kernel/tsc_msr.c b/arch/x86/kernel/tsc_msr.c
index 8b5434f..92ae6ac 100644
--- a/arch/x86/kernel/tsc_msr.c
+++ b/arch/x86/kernel/tsc_msr.c
@@ -53,7 +53,7 @@ static struct freq_desc freq_desc_tables[] = {
 	/* TNG */
 	{ 6, 0x4a, 1, { 0, FREQ_100, FREQ_133, 0, 0, 0, 0, 0 } },
 	/* VLV2 */
-	{ 6, 0x37, 1, { 0, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
+	{ 6, 0x37, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_166, 0, 0, 0, 0 } },
 	/* ANN */
 	{ 6, 0x5a, 1, { FREQ_83, FREQ_100, FREQ_133, FREQ_100, 0, 0, 0, 0 } },
 };
@@ -77,21 +77,18 @@ static int match_cpu(u8 family, u8 model)
 
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
@@ -103,7 +100,7 @@ int try_msr_calibrate_tsc(unsigned long *fast_calibrate)
 	pr_info("Maximum core-clock to bus-clock ratio: 0x%x\n", ratio);
 
 	if (!ratio)
-		return 0;
+		goto fail;
 
 	/* Get FSB FREQ ID */
 	rdmsr(MSR_FSB_FREQ, lo, hi);
@@ -112,16 +109,19 @@ int try_msr_calibrate_tsc(unsigned long *fast_calibrate)
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
