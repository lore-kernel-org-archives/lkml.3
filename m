Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415AbaCSFzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 01:55:14 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47923 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaCSFzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 01:55:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: remove unused notifier: CPUFREQ_{SUSPENDCHANGE|RESUMECHANGE}
Date: Wed, 19 Mar 2014 11:24:58 +0530
Message-Id: <6ccbcafd3e17a4c34a9ed7f4f1927205512aa180.1395208441.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two cpufreq notifiers CPUFREQ_RESUMECHANGE and CPUFREQ_SUSPENDCHANGE were unused
since sometime. And so better remove them to clean code a bit.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpu-freq/core.txt       | 4 ----
 arch/arm/kernel/smp.c                 | 3 +--
 arch/arm/kernel/smp_twd.c             | 2 +-
 arch/arm/mach-pxa/viper.c             | 3 ---
 arch/powerpc/oprofile/op_model_cell.c | 3 +--
 arch/sparc/kernel/time_64.c           | 3 +--
 arch/x86/kernel/tsc.c                 | 3 +--
 drivers/cpufreq/cpufreq.c             | 3 +--
 drivers/pcmcia/sa11xx_base.c          | 3 ---
 drivers/tty/serial/sh-sci.c           | 3 +--
 include/linux/cpufreq.h               | 2 --
 11 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/Documentation/cpu-freq/core.txt b/Documentation/cpu-freq/core.txt
index ce0666e..0060d76 100644
--- a/Documentation/cpu-freq/core.txt
+++ b/Documentation/cpu-freq/core.txt
@@ -92,7 +92,3 @@ values:
 cpu	- number of the affected CPU
 old	- old frequency
 new	- new frequency
-
-If the cpufreq core detects the frequency has changed while the system
-was suspended, these notifiers are called with CPUFREQ_RESUMECHANGE as
-second argument.
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index b7b4c86..7c4fada 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -674,8 +674,7 @@ static int cpufreq_callback(struct notifier_block *nb,
 	}
 
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
-	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
-	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
+	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new)) {
 		loops_per_jiffy = cpufreq_scale(global_l_p_j_ref,
 						global_l_p_j_ref_freq,
 						freq->new);
diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 6591e26..dfc3213 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -166,7 +166,7 @@ static int twd_cpufreq_transition(struct notifier_block *nb,
 	 * frequency.  The timer is local to a cpu, so cross-call to the
 	 * changing cpu.
 	 */
-	if (state == CPUFREQ_POSTCHANGE || state == CPUFREQ_RESUMECHANGE)
+	if (state == CPUFREQ_POSTCHANGE)
 		smp_call_function_single(freqs->cpu, twd_update_frequency,
 			NULL, 1);
 
diff --git a/arch/arm/mach-pxa/viper.c b/arch/arm/mach-pxa/viper.c
index 29905b1..41f27f6 100644
--- a/arch/arm/mach-pxa/viper.c
+++ b/arch/arm/mach-pxa/viper.c
@@ -885,9 +885,6 @@ static int viper_cpufreq_notifier(struct notifier_block *nb,
 			viper_set_core_cpu_voltage(freq->new, 0);
 		}
 		break;
-	case CPUFREQ_RESUMECHANGE:
-		viper_set_core_cpu_voltage(freq->new, 0);
-		break;
 	default:
 		/* ignore */
 		break;
diff --git a/arch/powerpc/oprofile/op_model_cell.c b/arch/powerpc/oprofile/op_model_cell.c
index 1f0ebde..863d893 100644
--- a/arch/powerpc/oprofile/op_model_cell.c
+++ b/arch/powerpc/oprofile/op_model_cell.c
@@ -1121,8 +1121,7 @@ oprof_cpufreq_notify(struct notifier_block *nb, unsigned long val, void *data)
 	int ret = 0;
 	struct cpufreq_freqs *frq = data;
 	if ((val == CPUFREQ_PRECHANGE && frq->old < frq->new) ||
-	    (val == CPUFREQ_POSTCHANGE && frq->old > frq->new) ||
-	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE))
+	    (val == CPUFREQ_POSTCHANGE && frq->old > frq->new))
 		set_spu_profiling_frequency(frq->new, spu_cycle_reset);
 	return ret;
 }
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index c3d82b5..b397e05 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -659,8 +659,7 @@ static int sparc64_cpufreq_notifier(struct notifier_block *nb, unsigned long val
 		ft->clock_tick_ref = cpu_data(cpu).clock_tick;
 	}
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
-	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
-	    (val == CPUFREQ_RESUMECHANGE)) {
+	    (val == CPUFREQ_POSTCHANGE && freq->old > freq->new)) {
 		cpu_data(cpu).clock_tick =
 			cpufreq_scale(ft->clock_tick_ref,
 				      ft->ref_freq,
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index cfbe99f..7a9296a 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -914,8 +914,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 		tsc_khz_ref = tsc_khz;
 	}
 	if ((val == CPUFREQ_PRECHANGE  && freq->old < freq->new) ||
-			(val == CPUFREQ_POSTCHANGE && freq->old > freq->new) ||
-			(val == CPUFREQ_RESUMECHANGE)) {
+			(val == CPUFREQ_POSTCHANGE && freq->old > freq->new)) {
 		*lpj = cpufreq_scale(loops_per_jiffy_ref, ref_freq, freq->new);
 
 		tsc_khz = cpufreq_scale(tsc_khz_ref, ref_freq, freq->new);
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index bf7f9c2..d0f0b7b 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -264,8 +264,7 @@ static void adjust_jiffies(unsigned long val, struct cpufreq_freqs *ci)
 		pr_debug("saving %lu as reference value for loops_per_jiffy; freq is %u kHz\n",
 			 l_p_j_ref, l_p_j_ref_freq);
 	}
-	if ((val == CPUFREQ_POSTCHANGE && ci->old != ci->new) ||
-	    (val == CPUFREQ_RESUMECHANGE || val == CPUFREQ_SUSPENDCHANGE)) {
+	if (val == CPUFREQ_POSTCHANGE && ci->old != ci->new) {
 		loops_per_jiffy = cpufreq_scale(l_p_j_ref, l_p_j_ref_freq,
 								ci->new);
 		pr_debug("scaling loops_per_jiffy to %lu for frequency %u kHz\n",
diff --git a/drivers/pcmcia/sa11xx_base.c b/drivers/pcmcia/sa11xx_base.c
index 6eecd7c..54d3089 100644
--- a/drivers/pcmcia/sa11xx_base.c
+++ b/drivers/pcmcia/sa11xx_base.c
@@ -125,9 +125,6 @@ sa1100_pcmcia_frequency_change(struct soc_pcmcia_socket *skt,
 		if (freqs->new < freqs->old)
 			sa1100_pcmcia_set_mecr(skt, freqs->new);
 		break;
-	case CPUFREQ_RESUMECHANGE:
-		sa1100_pcmcia_set_mecr(skt, freqs->new);
-		break;
 	}
 
 	return 0;
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index be33d2b..7e0b626 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -1041,8 +1041,7 @@ static int sci_notifier(struct notifier_block *self,
 
 	sci_port = container_of(self, struct sci_port, freq_transition);
 
-	if ((phase == CPUFREQ_POSTCHANGE) ||
-	    (phase == CPUFREQ_RESUMECHANGE)) {
+	if (phase == CPUFREQ_POSTCHANGE) {
 		struct uart_port *port = &sci_port->port;
 
 		spin_lock_irqsave(&port->lock, flags);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index e5cebce..4c3bcdc 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -320,8 +320,6 @@ static inline void cpufreq_resume(void) {}
 /* Transition notifiers */
 #define CPUFREQ_PRECHANGE		(0)
 #define CPUFREQ_POSTCHANGE		(1)
-#define CPUFREQ_RESUMECHANGE		(8)
-#define CPUFREQ_SUSPENDCHANGE		(9)
 
 /* Policy Notifiers  */
 #define CPUFREQ_ADJUST			(0)
-- 
1.7.12.rc2.18.g61b472e

