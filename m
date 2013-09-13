Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317Ab3IMN0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:26:31 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51527 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934282Ab3IMN0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:26:13 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 195/228] cpufreq: kirkwood: remove calls to cpufreq_notify_transition()
Date: Fri, 13 Sep 2013 18:32:21 +0530
Message-Id: <0a512914fd48b2d6db685446f88b9a096eff79a1.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the drivers do following in their ->target_index() routines:

	struct cpufreq_freqs freqs;
	freqs.old = old freq...
	freqs.new = new freq...

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);

	/* Change rate here */

	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);

This is replicated over all cpufreq drivers today and there doesn't exists a
good enough reason why this shouldn't be moved to cpufreq core instead.

Earlier patches have added support in cpufreq core to do cpufreq notification on
frequency change, this one removes it from this driver.

Some related minor cleanups are also done along with it.

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/kirkwood-cpufreq.c | 54 ++++++++++++++------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 0ae4dd7..0767a4e 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -58,48 +58,34 @@ static unsigned int kirkwood_cpufreq_get_cpu_frequency(unsigned int cpu)
 static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
 			    unsigned int index)
 {
-	struct cpufreq_freqs freqs;
 	unsigned int state = kirkwood_freq_table[index].driver_data;
 	unsigned long reg;
 
-	freqs.old = kirkwood_cpufreq_get_cpu_frequency(0);
-	freqs.new = kirkwood_freq_table[index].frequency;
+	local_irq_disable();
 
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_PRECHANGE);
+	/* Disable interrupts to the CPU */
+	reg = readl_relaxed(priv.base);
+	reg |= CPU_SW_INT_BLK;
+	writel_relaxed(reg, priv.base);
 
-	dev_dbg(priv.dev, "Attempting to set frequency to %i KHz\n",
-		kirkwood_freq_table[index].frequency);
-	dev_dbg(priv.dev, "old frequency was %i KHz\n",
-		kirkwood_cpufreq_get_cpu_frequency(0));
-
-	if (freqs.old != freqs.new) {
-		local_irq_disable();
-
-		/* Disable interrupts to the CPU */
-		reg = readl_relaxed(priv.base);
-		reg |= CPU_SW_INT_BLK;
-		writel_relaxed(reg, priv.base);
-
-		switch (state) {
-		case STATE_CPU_FREQ:
-			clk_disable(priv.powersave_clk);
-			break;
-		case STATE_DDR_FREQ:
-			clk_enable(priv.powersave_clk);
-			break;
-		}
+	switch (state) {
+	case STATE_CPU_FREQ:
+		clk_disable(priv.powersave_clk);
+		break;
+	case STATE_DDR_FREQ:
+		clk_enable(priv.powersave_clk);
+		break;
+	}
 
-		/* Wait-for-Interrupt, while the hardware changes frequency */
-		cpu_do_idle();
+	/* Wait-for-Interrupt, while the hardware changes frequency */
+	cpu_do_idle();
 
-		/* Enable interrupts to the CPU */
-		reg = readl_relaxed(priv.base);
-		reg &= ~CPU_SW_INT_BLK;
-		writel_relaxed(reg, priv.base);
+	/* Enable interrupts to the CPU */
+	reg = readl_relaxed(priv.base);
+	reg &= ~CPU_SW_INT_BLK;
+	writel_relaxed(reg, priv.base);
 
-		local_irq_enable();
-	}
-	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
+	local_irq_enable();
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

