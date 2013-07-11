Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab3GKTmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:42:44 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:54501 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab3GKTmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:42:42 -0400
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Jul 2013 15:42:42 EDT
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>, cpufreq@vger.kernel.org,
        Julia Lawall <Julia.Lawall@lip6.fr>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>, stable@vger.kernel.org
Subject: [PATCH] MIPS: loongson2: cpufreq: fix broken cpufreq
Date: Thu, 11 Jul 2013 22:34:41 +0300
Message-Id: <1373571281-4457-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 42913c799 (MIPS: Loongson2: Use clk API instead of direct
dereferences) broke the cpufreq functionality on Loongson2 boards:
clk_set_rate() is called before the CPU frequency table is initialized,
and therefore will always fail.

Fix by moving the clk_set_rate() after the table initialization.
Tested on Lemote FuLoong mini-PC.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: stable@vger.kernel.org
---
 drivers/cpufreq/loongson2_cpufreq.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index d539127..f92b02a 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -118,11 +118,6 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		clk_put(cpuclk);
 		return -EINVAL;
 	}
-	ret = clk_set_rate(cpuclk, rate);
-	if (ret) {
-		clk_put(cpuclk);
-		return ret;
-	}
 
 	/* clock table init */
 	for (i = 2;
@@ -130,6 +125,12 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	     i++)
 		loongson2_clockmod_table[i].frequency = (rate * i) / 8;
 
+	ret = clk_set_rate(cpuclk, rate);
+	if (ret) {
+		clk_put(cpuclk);
+		return ret;
+	}
+
 	policy->cur = loongson2_cpufreq_get(policy->cpu);
 
 	cpufreq_frequency_table_get_attr(&loongson2_clockmod_table[0],
-- 
1.8.3.1

