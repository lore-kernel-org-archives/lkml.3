Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab3C0Whd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 18:37:33 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:49124
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754115Ab3C0Wh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 18:37:28 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCC69-02-1UY-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 1/2] cpufreq: ondemand: allow custom od_ops to be registered
Date: Wed, 27 Mar 2013 17:37:20 -0500
Message-ID: <1364423841-6920-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364423841-6920-1-git-send-email-jacob.shin@amd.com>
References: <1364423841-6920-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows for another [arch specific] driver to hook into existing
powersave bias function of the ondemand governor. i.e. This allows AMD
specific powersave bias function (in a separate AMD specific driver)
to aid ondemand governor's frequency transition deicisions.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 drivers/cpufreq/cpufreq_governor.h |    2 ++
 drivers/cpufreq/cpufreq_ondemand.c |   32 +++++++++++++++++++++++++++-----
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index c83cabf..d1f7b23 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -262,4 +262,6 @@ bool need_load_eval(struct cpu_dbs_common_info *cdbs,
 		unsigned int sampling_rate);
 int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		struct common_dbs_data *cdata, unsigned int event);
+void od_register_ops(struct od_ops *ops);
+void od_unregister_ops(struct od_ops *ops);
 #endif /* _CPUFREQ_GOVERNER_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 15e80ee..0a101eb 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -40,6 +40,8 @@
 
 static DEFINE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
 
+static struct od_ops od_ops;
+
 #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
 static struct cpufreq_governor cpufreq_gov_ondemand;
 #endif
@@ -135,7 +137,7 @@ static void ondemand_powersave_bias_init(void)
 {
 	int i;
 	for_each_online_cpu(i) {
-		ondemand_powersave_bias_init_cpu(i);
+		od_ops.powersave_bias_init_cpu(i);
 	}
 }
 
@@ -145,7 +147,8 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 
 	if (od_tuners->powersave_bias)
-		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
+		freq = od_ops.powersave_bias_target(p, freq,
+				CPUFREQ_RELATION_H);
 	else if (p->cur == p->max)
 		return;
 
@@ -177,7 +180,7 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 		if (policy->cur < policy->max)
 			dbs_info->rate_mult =
 				od_tuners->sampling_down_factor;
-		dbs_freq_increase(policy, policy->max);
+		od_ops.freq_increase(policy, policy->max);
 		return;
 	}
 
@@ -206,8 +209,8 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 			__cpufreq_driver_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
 		} else {
-			int freq = powersave_bias_target(policy, freq_next,
-					CPUFREQ_RELATION_L);
+			int freq = od_ops.powersave_bias_target(policy,
+					freq_next, CPUFREQ_RELATION_L);
 			__cpufreq_driver_target(policy, freq,
 					CPUFREQ_RELATION_L);
 		}
@@ -565,6 +568,25 @@ static struct common_dbs_data od_dbs_cdata = {
 	.exit = od_exit,
 };
 
+void od_register_ops(struct od_ops *ops)
+{
+	if (ops->powersave_bias_init_cpu)
+		od_ops.powersave_bias_init_cpu = ops->powersave_bias_init_cpu;
+	if (ops->powersave_bias_target)
+		od_ops.powersave_bias_target = ops->powersave_bias_target;
+	if (ops->freq_increase)
+		od_ops.freq_increase = ops->freq_increase;
+}
+EXPORT_SYMBOL_GPL(od_register_ops);
+
+void od_unregister_ops(struct od_ops *ops)
+{
+	od_ops.powersave_bias_init_cpu = ondemand_powersave_bias_init_cpu;
+	od_ops.powersave_bias_target = powersave_bias_target;
+	od_ops.freq_increase = dbs_freq_increase;
+}
+EXPORT_SYMBOL_GPL(od_unregister_ops);
+
 static int od_cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		unsigned int event)
 {
-- 
1.7.9.5


