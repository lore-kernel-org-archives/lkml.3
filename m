Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797Ab3BYRWq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:22:46 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57222 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab3BYRWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:22:43 -0500
Date: Mon, 25 Feb 2013 18:22:37 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] cpufreq: cpufreq-cpu0: use the exact frequency for clk_set_rate()
Message-ID: <Pine.LNX.4.64.1302251820431.3030@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:2+7LZOC+kV7SlNR+P9Mhxx5cYfJ9n6j8TdUAnaGSneO
 0AcwV/I8Zg4BTQveNlbvdLBVyk6y/Y7Vl95UlJxb0hP/WwfpGy
 fcsec00nEj+hVa6CEZdYzQ90ifUry/ALAGv6VRTHUYdOjzD0UQ
 mDduLRLYPwK4rAr2V9tXrkMtw6D2tL7sBDD6xBgpVc4XXs3pxY
 p8/tpTgiQ3pR07CVeunJKGK/xFjBejQ2wHGJifUz3w89KT6JRg
 pwXZyTw6zGxoJvXHLb3VlTeWKLNvq6cOgTdG4bKqXitcdKtGZ7
 i/rkOyLXCg5oJt3wMNyGxbKBqfo1teUIIDWmZBfmDeYAldmYqg
 0/Ls2KqAz3BdXS26ttR0XQ3xIzvxQ0dWK8E4QDk1IYiTgUD1hz
 8o4TqqJXbjmaw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clk_set_rate() isn't supposed to accept approximate frequencies, instead
a supported frequency should be obtained from clk_round_rate() and then
used to set the clock.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Applies on top of my previous patch to fix unsigned freq_Hz "cpufreq: fix 
sign check of an unsigned variable in cpufreq-cpu0"

 drivers/cpufreq/cpufreq-cpu0.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index e7bad3c..6ce9b51 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -45,7 +45,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
 	unsigned long volt = 0, volt_old = 0, tol = 0;
-	long freq_Hz;
+	long freq_Hz, freq_exact;
 	unsigned int index, cpu;
 	int ret;
 
@@ -60,6 +60,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 	freq_Hz = clk_round_rate(cpu_clk, freq_table[index].frequency * 1000);
 	if (freq_Hz < 0)
 		freq_Hz = freq_table[index].frequency * 1000;
+	freq_exact = freq_Hz;
 	freqs.new = freq_Hz / 1000;
 	freqs.old = clk_get_rate(cpu_clk) / 1000;
 
@@ -96,7 +97,7 @@ static int cpu0_set_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	ret = clk_set_rate(cpu_clk, freqs.new * 1000);
+	ret = clk_set_rate(cpu_clk, freq_exact);
 	if (ret) {
 		pr_err("failed to set clock rate: %d\n", ret);
 		if (cpu_reg)
-- 
1.7.2.5

