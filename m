Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab3LLAii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:38:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3LLAig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:38:36 -0500
Date: Wed, 11 Dec 2013 19:38:32 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] powernow-k6: disable cache when changing frequency
In-Reply-To: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found out that a system with k6-3+ processor is unstable during network
server load. The system locks up or the network card stops receiving. The
reason for the instability is the CPU frequency scaling.

During frequency transition the processor is in "EPM Stop Grant" state.
The documentation says that the processor doesn't respond to inquiry
requests in this state. Consequently, coherency of processor caches and
bus master devices is not maintained, causing the system instability.

This patch flushes the cache during frequency transition. It fixes the
instability.

Other minor changes:
* u64 invalue changed to unsigned long because the variable is 32-bit
* move the logic to set the multiplier to a separate function
  powernow_k6_set_cpu_multiplier
* preserve lower 5 bits of the powernow port instead of 4 (the voltage
  field has 5 bits)
* mask interrupts when reading the multiplier, so that the port is not
  open during other activity (running other kernel code with the port open
  shouldn't cause any misbehavior, but we should better be safe and keep
  the port closed)

This patch should be backported to all stable kernels. If it doesn't
apply cleanly, change it, or ask me to change it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/cpufreq/powernow-k6.c |   56 +++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 17 deletions(-)

Index: linux-3.13-rc3/drivers/cpufreq/powernow-k6.c
===================================================================
--- linux-3.13-rc3.orig/drivers/cpufreq/powernow-k6.c	2013-11-30 00:19:59.000000000 +0100
+++ linux-3.13-rc3/drivers/cpufreq/powernow-k6.c	2013-12-06 22:25:42.000000000 +0100
@@ -44,23 +44,58 @@ static struct cpufreq_frequency_table cl
 /**
  * powernow_k6_get_cpu_multiplier - returns the current FSB multiplier
  *
- *   Returns the current setting of the frequency multiplier. Core clock
+ * Returns the current setting of the frequency multiplier. Core clock
  * speed is frequency of the Front-Side Bus multiplied with this value.
  */
 static int powernow_k6_get_cpu_multiplier(void)
 {
-	u64 invalue = 0;
+	unsigned long invalue = 0;
 	u32 msrval;
 
+	local_irq_disable();
+
 	msrval = POWERNOW_IOPORT + 0x1;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
 	invalue = inl(POWERNOW_IOPORT + 0x8);
 	msrval = POWERNOW_IOPORT + 0x0;
 	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
 
+	local_irq_enable();
+
 	return clock_ratio[(invalue >> 5)&7].driver_data;
 }
 
+static void powernow_k6_set_cpu_multiplier(unsigned int best_i)
+{
+	unsigned long outvalue, invalue;
+	unsigned long msrval;
+	unsigned long cr0;
+
+	/* we now need to transform best_i to the BVC format, see AMD#23446 */
+
+	/*
+	 * The processor doesn't respond to inquiry cycles while changing the
+	 * frequency, so we must disable cache.
+	 */
+	local_irq_disable();
+	cr0 = read_cr0();
+	write_cr0(cr0 | X86_CR0_CD);
+	wbinvd();
+
+	outvalue = (1<<12) | (1<<10) | (1<<9) | (best_i<<5);
+
+	msrval = POWERNOW_IOPORT + 0x1;
+	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
+	invalue = inl(POWERNOW_IOPORT + 0x8);
+	invalue = invalue & 0x1f;
+	outvalue = outvalue | invalue;
+	outl(outvalue, (POWERNOW_IOPORT + 0x8));
+	msrval = POWERNOW_IOPORT + 0x0;
+	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
+
+	write_cr0(cr0);
+	local_irq_enable();
+}
 
 /**
  * powernow_k6_target - set the PowerNow! multiplier
@@ -71,8 +106,6 @@ static int powernow_k6_get_cpu_multiplie
 static int powernow_k6_target(struct cpufreq_policy *policy,
 		unsigned int best_i)
 {
-	unsigned long outvalue = 0, invalue = 0;
-	unsigned long msrval;
 	struct cpufreq_freqs freqs;
 
 	if (clock_ratio[best_i].driver_data > max_multiplier) {
@@ -85,18 +118,7 @@ static int powernow_k6_target(struct cpu
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
 
-	/* we now need to transform best_i to the BVC format, see AMD#23446 */
-
-	outvalue = (1<<12) | (1<<10) | (1<<9) | (best_i<<5);
-
-	msrval = POWERNOW_IOPORT + 0x1;
-	wrmsr(MSR_K6_EPMR, msrval, 0); /* enable the PowerNow port */
-	invalue = inl(POWERNOW_IOPORT + 0x8);
-	invalue = invalue & 0xf;
-	outvalue = outvalue | invalue;
-	outl(outvalue , (POWERNOW_IOPORT + 0x8));
-	msrval = POWERNOW_IOPORT + 0x0;
-	wrmsr(MSR_K6_EPMR, msrval, 0); /* disable it again */
+	powernow_k6_set_cpu_multiplier(best_i);
 
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 
@@ -125,7 +147,7 @@ static int powernow_k6_cpu_init(struct c
 	}
 
 	/* cpuinfo and default policy values */
-	policy->cpuinfo.transition_latency = 200000;
+	policy->cpuinfo.transition_latency = 500000;
 
 	return cpufreq_table_validate_and_show(policy, clock_ratio);
 }
