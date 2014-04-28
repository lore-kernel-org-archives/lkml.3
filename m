Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaD1BdE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:33:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42827 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752342AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Mikulas Patocka" <mpatocka@redhat.com>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.342887870@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 91/94] powernow-k6: disable cache when changing frequency
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/cpufreq/powernow-k6.c | 56 ++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 17 deletions(-)

--- a/drivers/cpufreq/powernow-k6.c
+++ b/drivers/cpufreq/powernow-k6.c
@@ -43,23 +43,58 @@ static struct cpufreq_frequency_table cl
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
 	return clock_ratio[(invalue >> 5)&7].index;
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
@@ -69,8 +104,6 @@ static int powernow_k6_get_cpu_multiplie
  */
 static void powernow_k6_set_state(unsigned int best_i)
 {
-	unsigned long outvalue = 0, invalue = 0;
-	unsigned long msrval;
 	struct cpufreq_freqs freqs;
 
 	if (clock_ratio[best_i].index > max_multiplier) {
@@ -84,18 +117,7 @@ static void powernow_k6_set_state(unsign
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 
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
 
 	cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 
@@ -163,7 +185,7 @@ static int powernow_k6_cpu_init(struct c
 	}
 
 	/* cpuinfo and default policy values */
-	policy->cpuinfo.transition_latency = 200000;
+	policy->cpuinfo.transition_latency = 500000;
 	policy->cur = busfreq * max_multiplier;
 
 	result = cpufreq_frequency_table_cpuinfo(policy, clock_ratio);

