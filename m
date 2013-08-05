Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3HES1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:27:52 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:56877 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab3HES1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:27:50 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, stable@vger.kernel.org
Subject: [PATCH v2] cpufreq: loongson2: fix broken cpufreq
Date: Mon,  5 Aug 2013 21:27:12 +0300
Message-Id: <1375727232-17796-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.8.3.2
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
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Cc: stable@vger.kernel.org
---

	Changes since the first version
	(http://marc.info/?l=linux-kernel&m=137357177225034&w=2):

	- Changed the subject prefix. I guess this should be merged through
	  the cpufreq/PM instead of MIPS tree?

	- Added ACK from Viresh Kumar.

 drivers/cpufreq/loongson2_cpufreq.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index bb838b9..9536852 100644
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
1.8.3.2

