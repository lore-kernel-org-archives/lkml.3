Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3LLAi6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:38:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47801 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab3LLAi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:38:56 -0500
Date: Wed, 11 Dec 2013 19:38:53 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] powernow-k6: correctly initialize default parameters
In-Reply-To: <alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1312111938370.23022@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1312111751180.9686@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1312111937570.23022@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The powernow-k6 driver used to read the initial multiplier from the
powernow register. However, there is a problem with this:

* If there was a frequency transition before, the multiplier read from the
  register corresponds to the current multiplier.
* If there was no frequency transition since reset, the field in the
  register always reads as zero, regardless of the current multiplier that
  is set using switches on the mainboard and that the CPU is running at.

The zero value corresponds to multiplier 4.5, so as a consequence, the
powernow-k6 driver always assumes multiplier 4.5.

For example, if we have 550MHz CPU with bus frequency 100MHz and
multiplier 5.5, the powernow-k6 driver thinks that the multiplier is 4.5
and bus frequency is 122MHz. The powernow-k6 driver then sets the
multiplier to 4.5, underclocking the CPU to 450MHz, but reports the
current frequency as 550MHz.

There is no reliable way how to read the initial multiplier. I modified
the driver so that it contains a table of known frequencies (based on
parameters of existing CPUs and some common overclocking schemes) and sets
the multiplier according to the frequency. If the frequency is unknown
(because of unusual overclocking or underclocking), the user must supply
the bus speed and maximum multiplier as module parameters.

This patch should be backported to all stable kernels. If it doesn't
apply cleanly, change it, or ask me to change it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@kernel.org

---
 drivers/cpufreq/powernow-k6.c |   76 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 72 insertions(+), 4 deletions(-)

Index: linux-3.13-rc3/drivers/cpufreq/powernow-k6.c
===================================================================
--- linux-3.13-rc3.orig/drivers/cpufreq/powernow-k6.c	2013-12-06 22:28:32.000000000 +0100
+++ linux-3.13-rc3/drivers/cpufreq/powernow-k6.c	2013-12-06 22:29:51.000000000 +0100
@@ -26,6 +26,14 @@
 static unsigned int                     busfreq;   /* FSB, in 10 kHz */
 static unsigned int                     max_multiplier;
 
+static unsigned int			param_busfreq = 0;
+static unsigned int			param_max_multiplier = 0;
+
+module_param_named(max_multiplier, param_max_multiplier, uint, S_IRUGO);
+MODULE_PARM_DESC(max_multiplier, "Maximum multiplier (allowed values: 20 30 35 40 45 50 55 60)");
+
+module_param_named(bus_frequency, param_busfreq, uint, S_IRUGO);
+MODULE_PARM_DESC(bus_frequency, "Bus frequency in kHz");
 
 /* Clock ratio multiplied by 10 - see table 27 in AMD#23446 */
 static struct cpufreq_frequency_table clock_ratio[] = {
@@ -40,6 +48,27 @@ static struct cpufreq_frequency_table cl
 	{0, CPUFREQ_TABLE_END}
 };
 
+static const struct {
+	unsigned freq;
+	unsigned mult;
+} usual_frequency_table[] = {
+	{ 400000, 40 },	// 100   * 4
+	{ 450000, 45 }, // 100   * 4.5
+	{ 475000, 50 }, //  95   * 5
+	{ 500000, 50 }, // 100   * 5
+	{ 506250, 45 }, // 112.5 * 4.5
+	{ 533500, 55 }, //  97   * 5.5
+	{ 550000, 55 }, // 100   * 5.5
+	{ 562500, 50 }, // 112.5 * 5
+	{ 570000, 60 }, //  95   * 6
+	{ 600000, 60 }, // 100   * 6
+	{ 618750, 55 }, // 112.5 * 5.5
+	{ 660000, 55 }, // 120   * 5.5
+	{ 675000, 60 }, // 112.5 * 6
+	{ 720000, 60 }, // 120   * 6
+};
+
+#define FREQ_RANGE		3000
 
 /**
  * powernow_k6_get_cpu_multiplier - returns the current FSB multiplier
@@ -125,17 +154,56 @@ static int powernow_k6_target(struct cpu
 	return 0;
 }
 
-
 static int powernow_k6_cpu_init(struct cpufreq_policy *policy)
 {
 	unsigned int i, f;
+	unsigned khz;
 
 	if (policy->cpu != 0)
 		return -ENODEV;
 
-	/* get frequencies */
-	max_multiplier = powernow_k6_get_cpu_multiplier();
-	busfreq = cpu_khz / max_multiplier;
+	max_multiplier = 0;
+	khz = cpu_khz;
+	for (i = 0; i < ARRAY_SIZE(usual_frequency_table); i++) {
+		if (khz >= usual_frequency_table[i].freq - FREQ_RANGE &&
+		    khz <= usual_frequency_table[i].freq + FREQ_RANGE) {
+			khz = usual_frequency_table[i].freq;
+			max_multiplier = usual_frequency_table[i].mult;
+			break;
+		}
+	}
+	if (param_max_multiplier) {
+		for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
+			if (clock_ratio[i].driver_data == param_max_multiplier) {
+				max_multiplier = param_max_multiplier;
+				goto have_max_multiplier;
+			}
+		}
+		printk(KERN_ERR "powernow-k6: invalid max_multiplier parameter, valid parameters 20, 30, 35, 40, 45, 50, 55, 60\n");
+		return -EINVAL;
+	}
+
+	if (!max_multiplier) {
+		printk(KERN_WARNING "powernow-k6: unknown frequency %u, cannot determine current multiplier\n", khz);
+		printk(KERN_WARNING "powernow-k6: use module parameters max_multiplier and bus_frequency\n");
+		return -EOPNOTSUPP;
+	}
+
+have_max_multiplier:
+	param_max_multiplier = max_multiplier;
+
+	if (param_busfreq) {
+		if (param_busfreq >= 50000 && param_busfreq <= 150000) {
+			busfreq = param_busfreq / 10;
+			goto have_busfreq;
+		}
+		printk(KERN_ERR "powernow-k6: invalid bus_frequency parameter, allowed range 50000 - 150000 kHz\n");
+		return -EINVAL;
+	}
+
+	busfreq = khz / max_multiplier;
+have_busfreq:
+	param_busfreq = busfreq * 10;
 
 	/* table init */
 	for (i = 0; (clock_ratio[i].frequency != CPUFREQ_TABLE_END); i++) {
