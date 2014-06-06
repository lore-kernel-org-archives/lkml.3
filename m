Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaFFNKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:10:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52839 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752386AbaFFNKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:10:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: jslaby@suse.cz, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [patch NOT added to the 3.12 stable tree] MIPS/loongson2_cpufreq: Fix CPU clock rate setting
Date: Fri,  6 Jun 2014 15:05:23 +0200
Message-Id: <1402059923-821-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aaro Koskinen <aaro.koskinen@iki.fi>

This patch does NOT apply to the 3.12 stable tree. If you still want
it applied, please provide a backport.

===============

commit 8e8acb32960f42c81b1d50deac56a2c07bb6a18a upstream.

Loongson2 has been using (incorrectly) kHz for cpu_clk rate. This has
been unnoticed, as loongson2_cpufreq was the only place where the rate
was set/get. After commit 652ed95d5fa6074b3c4ea245deb0691f1acb6656
(cpufreq: introduce cpufreq_generic_get() routine) things however broke,
and now loops_per_jiffy adjustments are incorrect (1000 times too long).
The patch fixes this by changing cpu_clk rate to Hz.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: stable@vger.kernel.org
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Patchwork: https://patchwork.linux-mips.org/patch/6678/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
---
 arch/mips/loongson/lemote-2f/clock.c | 5 +++--
 drivers/cpufreq/loongson2_cpufreq.c  | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/mips/loongson/lemote-2f/clock.c b/arch/mips/loongson/lemote-2f/clock.c
index e1f427f4f5f3..67dd94ef28e6 100644
--- a/arch/mips/loongson/lemote-2f/clock.c
+++ b/arch/mips/loongson/lemote-2f/clock.c
@@ -91,6 +91,7 @@ EXPORT_SYMBOL(clk_put);
 
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
+	unsigned int rate_khz = rate / 1000;
 	int ret = 0;
 	int regval;
 	int i;
@@ -111,10 +112,10 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
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
index f0bc31f5db27..d4add8621944 100644
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
1.9.3

