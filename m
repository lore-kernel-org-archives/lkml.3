Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab3HNNgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:36:24 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:48157 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab3HNNgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:36:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 28/37] cpufreq: pxa: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:17 +0530
Message-Id: <7c73727c0fa0aa486ecf945693924918369a75b4.1376486713.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 2 --
 drivers/cpufreq/pxa3xx-cpufreq.c | 7 +++----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index a91274a..183bc13 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -388,8 +388,6 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 
 	/* set default policy and cpuinfo */
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
-	policy->cur = get_clk_frequency_khz(0);	   /* current freq */
-	policy->min = policy->max = policy->cur;
 
 	/* Generate pxa25x the run cpufreq_frequency_table struct */
 	for (i = 0; i < NUM_PXA25x_RUN_FREQS; i++) {
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 61e3e6a..132e37d 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -190,11 +190,10 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 	int ret = -EINVAL;
 
 	/* set default policy and cpuinfo */
-	policy->cpuinfo.min_freq = 104000;
-	policy->cpuinfo.max_freq = (cpu_is_pxa320()) ? 806000 : 624000;
+	policy->min = policy->cpuinfo.min_freq = 104000;
+	policy->max = policy->cpuinfo.max_freq =
+		(cpu_is_pxa320()) ? 806000 : 624000;
 	policy->cpuinfo.transition_latency = 1000; /* FIXME: 1 ms, assumed */
-	policy->max = pxa3xx_get_clk_frequency_khz(0);
-	policy->cur = policy->min = policy->max;
 
 	if (cpu_is_pxa300() || cpu_is_pxa310())
 		ret = setup_freqs_table(policy, pxa300_freqs,
-- 
1.7.12.rc2.18.g61b472e

