Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab3G3ITN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:19:13 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38486 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3G3IR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:17:58 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-b9-51f776b359ef
From: Konstantin Krivyakin <k.krivyakin@samsung.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        mingo@redhat.com, peterz@infradead.org, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org
Cc: k.krivyakin@samsung.com, i.zhbanov@samsung.com, e.voevodin@samsung.com,
        kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: [PATCH RFC 3/3] Update current cpu power when cpu freq change for
 exynos.
Date: Tue, 30 Jul 2013 12:17:39 +0400
Message-id: <1375172259-9641-4-git-send-email-k.krivyakin@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
References: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xq7qby74HGhyaJGUxZ/0aNou159qZ
	LFZcPcJoMXXhYXaL3gVX2SzONr1ht7i8aw6bxedeoMSlAwuYLI73HmCy6F/Yy2Sx8auHA4/H
	5hVaHneu7WHzODHjN4vH+31X2Tz6tqxi9Hi0uIXR4/MmuQD2KC6blNSczLLUIn27BK6MXddv
	shSsEK5Y9GseWwPjBoEuRk4OCQETidbHm9khbDGJC/fWs3UxcnEICSxllPjzaz8LhNPNJDFx
	Th8zSBUbUMfuvReZQRIiAosZJZbdnMQEkmAWaGKU+HeiCMQWFgiR6N90gA3EZhFQlZj6Yi/Y
	Cl4BN4mWJweBpnIArVOQmDPJBiTMKeAu0XLsGNh8IaCSa2dWME5g5F3AyLCKUTS1NLmgOCk9
	10ivODG3uDQvXS85P3cTIyQwv+5gXHrM6hCjAAejEg8vR/G3QCHWxLLiytxDjBIczEoivCw3
	gEK8KYmVValF+fFFpTmpxYcYmTg4pRoYT/PefH3wcdGJJSUty19qHo5xtFreXvjdtKGhxqY5
	7/KMy1JxXy2y2eUXsX3/+vdITdTMM0fqhZmfLv/BsXj9mbQTa/0acy+qC724J7jm0Z8DpqrP
	3t+4r+N8/nX6qeM2v06//3fxI8Mcz/fe9Y9Yb5fnW8iGShyVnbZi1YwrMx+tXTvxaFbHB3Ul
	luKMREMt5qLiRACqm87YKgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Konstantin Krivyakin <k.krivyakin@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c     |    2 ++
 drivers/cpufreq/exynos-cpufreq.h     |    1 +
 drivers/cpufreq/exynos4x12-cpufreq.c |   19 ++++++++++++++++++-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0d32f02..02f17bc 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -178,6 +178,8 @@ static int exynos_target(struct cpufreq_policy *policy,
 	}
 
 	new_freq = freq_table[index].frequency;
+	if (exynos_info->power_table)
+		policy->current_power = exynos_info->power_table[index];
 
 	ret = exynos_cpufreq_scale(new_freq);
 
diff --git a/drivers/cpufreq/exynos-cpufreq.h b/drivers/cpufreq/exynos-cpufreq.h
index 92b852e..64f964f 100644
--- a/drivers/cpufreq/exynos-cpufreq.h
+++ b/drivers/cpufreq/exynos-cpufreq.h
@@ -38,6 +38,7 @@ struct exynos_dvfs_info {
 	unsigned int	pll_safe_idx;
 	struct clk	*cpu_clk;
 	unsigned int	*volt_table;
+	u64		*power_table;
 	struct cpufreq_frequency_table	*freq_table;
 	void (*set_freq)(unsigned int, unsigned int);
 	bool (*need_apll_change)(unsigned int, unsigned int);
diff --git a/drivers/cpufreq/exynos4x12-cpufreq.c b/drivers/cpufreq/exynos4x12-cpufreq.c
index 08b7477..8905f9b 100644
--- a/drivers/cpufreq/exynos4x12-cpufreq.c
+++ b/drivers/cpufreq/exynos4x12-cpufreq.c
@@ -219,6 +219,7 @@ static void exynos4x12_set_frequency(unsigned int old_index,
 int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
 {
 	unsigned long rate;
+	int freq_count;
 
 	cpu_clk = clk_get(NULL, "armclk");
 	if (IS_ERR(cpu_clk))
@@ -252,8 +253,24 @@ int exynos4x12_cpufreq_init(struct exynos_dvfs_info *info)
 	info->set_freq = exynos4x12_set_frequency;
 	info->need_apll_change = exynos4x12_pms_change;
 
-	return 0;
+	freq_count = sizeof(exynos4x12_freq_table) /
+		sizeof(struct cpufreq_frequency_table);
+	info->power_table = kzalloc(sizeof(u64) * freq_count, GFP_KERNEL);
+	if (!info->power_table)
+		goto err_power_table;
+
+	for (i = 0; i <= freq_count; ++i) {
+		u64 freq = info->freq_table[i].frequency;
+		u64 volt = info->volt_table[i];
 
+		do_div(freq, 1000);
+		do_div(volt, 1000);
+		info->power_table[i] = freq * volt * volt;
+	}
+
+	return 0;
+err_power_table:
+	clk_put(mout_appl);
 err_mout_apll:
 	clk_put(mout_mpll);
 err_mout_mpll:
-- 
1.7.9.5

