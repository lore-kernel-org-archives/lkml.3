Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933463Ab3IMNRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:17:51 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63121 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933451Ab3IMNRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:17:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 124/228] cpufreq: speedstep: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:31:10 +0530
Message-Id: <3ea9c6cfddb691784394460150aced29ea6783f5.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/speedstep-centrino.c |  5 -----
 drivers/cpufreq/speedstep-ich.c      | 15 +--------------
 drivers/cpufreq/speedstep-smi.c      | 13 -------------
 3 files changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index c7c14ae..6b882c7 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -343,7 +343,6 @@ static unsigned int get_cur_freq(unsigned int cpu)
 static int centrino_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpuinfo_x86 *cpu = &cpu_data(policy->cpu);
-	unsigned freq;
 	unsigned l, h;
 	int i;
 
@@ -394,12 +393,8 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 		}
 	}
 
-	freq = get_cur_freq(policy->cpu);
 	policy->cpuinfo.transition_latency = 10000;
 						/* 10uS transition latency */
-	policy->cur = freq;
-
-	pr_debug("centrino_cpu_init: cur=%dkHz\n", policy->cur);
 
 	return cpufreq_table_validate_and_show(policy,
 		per_cpu(centrino_model, policy->cpu)->op_points);
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 929a4f0..1a8b01b 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -308,7 +308,7 @@ static void get_freqs_on_cpu(void *_get_freqs)
 
 static int speedstep_cpu_init(struct cpufreq_policy *policy)
 {
-	unsigned int policy_cpu, speed;
+	unsigned int policy_cpu;
 	struct get_freqs gf;
 
 	/* only run on CPU to be set, or on its sibling */
@@ -323,19 +323,6 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 	if (gf.ret)
 		return gf.ret;
 
-	/* get current speed setting */
-	speed = speedstep_get(policy_cpu);
-	if (!speed)
-		return -EIO;
-
-	pr_debug("currently at %s speed setting - %i MHz\n",
-		(speed == speedstep_freqs[SPEEDSTEP_LOW].frequency)
-		? "low" : "high",
-		(speed / 1000));
-
-	/* cpuinfo and default policy values */
-	policy->cur = speed;
-
 	return cpufreq_table_validate_and_show(policy, speedstep_freqs);
 }
 
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index b3dfba0..a02b649 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -267,7 +267,6 @@ static int speedstep_target(struct cpufreq_policy *policy,
 static int speedstep_cpu_init(struct cpufreq_policy *policy)
 {
 	int result;
-	unsigned int speed, state;
 	unsigned int *low, *high;
 
 	/* capability check */
@@ -303,19 +302,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 			pr_debug("workaround worked.\n");
 	}
 
-	/* get current speed setting */
-	state = speedstep_get_state();
-	speed = speedstep_freqs[state].frequency;
-
-	pr_debug("currently at %s speed setting - %i MHz\n",
-		(speed == speedstep_freqs[SPEEDSTEP_LOW].frequency)
-		? "low" : "high",
-		(speed / 1000));
-
-	/* cpuinfo and default policy values */
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
-	policy->cur = speed;
-
 	return cpufreq_table_validate_and_show(policy, speedstep_freqs);
 }
 
-- 
1.7.12.rc2.18.g61b472e

