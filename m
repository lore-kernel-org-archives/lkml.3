Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090AbaDPKzN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:55:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51624 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaDPKcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 06/46] powernow-k6: disable cache when changing frequency
Date: Wed, 16 Apr 2014 11:31:22 +0100
Message-Id: <1397644322-13905-7-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit e20e1d0ac02308e2211306fc67abcd0b2668fb8b upstream.

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
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/powernow-k6.c | 56 ++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/drivers/cpufreq/powernow-k6.c b/drivers/cpufreq/powernow-k6.c
index ea8e103..ff3bb8f 100644
--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -44,23 +44,58 @@ static struct cpufreq_frequency_table clock_ratio[] = {
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
  * powernow_k6_set_state - set the PowerNow! multiplier
@@ -71,8 +106,6 @@ static int powernow_k6_get_cpu_multiplier(void)
 static void powernow_k6_set_state(struct cpufreq_policy *policy,
 		unsigned int best_i)
 {
-	unsigned long outvalue = 0, invalue = 0;
-	unsigned long msrval;
 	struct cpufreq_freqs freqs;
 
 	if (clock_ratio[best_i].driver_data > max_multiplier) {
@@ -85,18 +118,7 @@ static void powernow_k6_set_state(struct cpufreq_policy *policy,
 
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
 
@@ -164,7 +186,7 @@ static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 	}
 
 	/* cpuinfo and default policy values */
-	policy->cpuinfo.transition_latency = 200000;
+	policy->cpuinfo.transition_latency = 500000;
 	policy->cur = busfreq * max_multiplier;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);
-- 
1.9.1

