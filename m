Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758871AbaDBTEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:04:00 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:55785 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785AbaDBTD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:03:58 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Ralf Baechle <ralf@linux-mips.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, stable@vger.kernel.org
Subject: [PATCH] MIPS/loongson2_cpufreq: fix CPU clock rate setting
Date: Wed,  2 Apr 2014 22:07:04 +0300
Message-Id: <1396465624-21661-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loongson2 has been using (incorrectly) kHz for cpu_clk rate. This has
been unnoticed, as loongson2_cpufreq was the only place where the rate
was set/get. After commit 652ed95d5fa6074b3c4ea245deb0691f1acb6656
(cpufreq: introduce cpufreq_generic_get() routine) things however broke,
and now loops_per_jiffy adjustments are incorrect (1000 times too long).
The patch fixes this by changing cpu_clk rate to Hz.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: stable@vger.kernel.org
---
 arch/mips/loongson/lemote-2f/clock.c | 7 +++++--
 drivers/cpufreq/loongson2_cpufreq.c  | 4 ++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index aed32b8..699f388 100644
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -91,6 +91,7 @@ EXPORT_SYMBOL(clk_put);
 
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
+	unsigned int rate_khz;
 	int ret = 0;
 	int regval;
 	int i;
@@ -106,15 +107,17 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 	if (unlikely(clk->flags & CLK_RATE_PROPAGATES))
 		propagate_rate(clk);
 
+	rate_khz = rate / 1000;
+
 	for (i = 0; loongson2_clockmod_table[i].frequency != CPUFREQ_TABLE_END;
 	     i++) {
 		if (loongson2_clockmod_table[i].frequency ==
 		    CPUFREQ_ENTRY_INVALID)
 			continue;
-		if (rate == loongson2_clockmod_table[i].frequency)
+		if (rate_khz == loongson2_clockmod_table[i].frequency)
 			break;
 	}
-	if (rate != loongson2_clockmod_table[i].frequency)
+	if (rate_khz != loongson2_clockmod_table[i].frequency)
 		return -ENOTSUPP;
 
 	clk->rate = rate;
diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index b6581ab..807d006 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -62,7 +62,7 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
 	/* setting the cpu frequency */
-	clk_set_rate(policy->clk, freq);
+	clk_set_rate(policy->clk, freq * 1000);
 
 	return 0;
 }
@@ -92,7 +92,7 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	     i++)
 		loongson2_clockmod_table[i].frequency = (rate * i) / 8;
 
-	ret = clk_set_rate(cpuclk, rate);
+	ret = clk_set_rate(cpuclk, rate * 1000);
 	if (ret) {
 		clk_put(cpuclk);
 		return ret;
-- 
1.9.0

