Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763788Ab3DDRSP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:18:15 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:15126
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763773Ab3DDRSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:18:13 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI1432I1447Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKQQQ7-02-207-02
X-M-MSG: 
Date: Thu, 4 Apr 2013 12:18:04 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Thomas Renninger <trenn@suse.de>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH V4 1/2] cpufreq: ondemand: allow custom
 powersave_bias_target handler to be registered
Message-ID: <20130404171804.GA4696@jshin-Toonie>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
 <1365092344-11310-2-git-send-email-jacob.shin@amd.com>
 <CAKohpom6BSJZc_ohgnjRTV2EBUAPy8TKVphtoRaNSt1wFP70uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAKohpom6BSJZc_ohgnjRTV2EBUAPy8TKVphtoRaNSt1wFP70uA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 10:06:35PM +0530, Viresh Kumar wrote:
> On 4 April 2013 21:49, Jacob Shin <jacob.shin@amd.com> wrote:
> > diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
> 
> > +static void od_set_powersave_bias(unsigned int powersave_bias)
> > +{
> > +       unsigned int cpu;
> > +       struct od_dbs_tuners *od_tuners;
> > +
> > +       if (!have_governor_per_policy()) {
> > +               od_tuners = od_dbs_cdata.gdbs_data->tuners;
> > +               od_tuners->powersave_bias = powersave_bias;
> > +               return;
> > +       }
> > +
> > +       for_each_online_cpu(cpu) {
> > +               struct cpufreq_policy *policy;
> > +               struct dbs_data *dbs_data;
> > +               policy = per_cpu(od_cpu_dbs_info, cpu).cdbs.cur_policy;
> > +               dbs_data = policy->governor_data;
> > +               od_tuners = dbs_data->tuners;
> > +               od_tuners->powersave_bias = powersave_bias;
> > +       }
> 
> You can keep only the for_each_online_cpu() loop and remove the other
> one. And in that one also, you don't have to do this for every cpu...
> 
> something like this will help you...
> 
> cpus_processed = NULL;
> 
> for_each_online_cpu(cpu) {
>     if cpu-is-present-in cpus_processed
>         continue;
> 
>     cpu-set-mask(cpus_processed, policy->cpus);
> 
> }
> 
> Syntax is poor, please choose the correct one.

Ah okay, thanks for the hint, here:

>From 59728d09d0dc5403c9bb0238336ecb367c04694f Mon Sep 17 00:00:00 2001
From: Jacob Shin <jacob.shin@amd.com>
Date: Tue, 2 Apr 2013 09:56:56 -0500
Subject: [PATCH 1/2] cpufreq: ondemand: allow custom powersave_bias_target
 handler to be registered

This allows for another [arch specific] driver to hook into existing
powersave bias function of the ondemand governor. i.e. This allows AMD
specific powersave bias function (in a separate AMD specific driver)
to aid ondemand governor's frequency transition decisions.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 drivers/cpufreq/cpufreq_governor.h |    4 +++
 drivers/cpufreq/cpufreq_ondemand.c |   58 +++++++++++++++++++++++++++++++-----
 2 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index 6593769..8ac3353 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -263,4 +263,8 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		struct common_dbs_data *cdata, unsigned int event);
 void gov_queue_work(struct dbs_data *dbs_data, struct cpufreq_policy *policy,
 		unsigned int delay, bool all_cpus);
+void od_register_powersave_bias_handler(unsigned int (*f)
+		(struct cpufreq_policy *, unsigned int, unsigned int),
+		unsigned int powersave_bias);
+void od_unregister_powersave_bias_handler(void);
 #endif /* _CPUFREQ_GOVERNOR_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 1471478..80fb624 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -40,6 +40,8 @@
 
 static DEFINE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
 
+static struct od_ops od_ops;
+
 #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
 static struct cpufreq_governor cpufreq_gov_ondemand;
 #endif
@@ -80,7 +82,7 @@ static int should_io_be_busy(void)
  * Returns the freq_hi to be used right now and will set freq_hi_jiffies,
  * freq_lo, and freq_lo_jiffies in percpu area for averaging freqs.
  */
-static unsigned int powersave_bias_target(struct cpufreq_policy *policy,
+static unsigned int generic_powersave_bias_target(struct cpufreq_policy *policy,
 		unsigned int freq_next, unsigned int relation)
 {
 	unsigned int freq_req, freq_reduc, freq_avg;
@@ -145,7 +147,8 @@ static void dbs_freq_increase(struct cpufreq_policy *p, unsigned int freq)
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
 
 	if (od_tuners->powersave_bias)
-		freq = powersave_bias_target(p, freq, CPUFREQ_RELATION_H);
+		freq = od_ops.powersave_bias_target(p, freq,
+				CPUFREQ_RELATION_H);
 	else if (p->cur == p->max)
 		return;
 
@@ -205,12 +208,12 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
 		if (!od_tuners->powersave_bias) {
 			__cpufreq_driver_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
-		} else {
-			int freq = powersave_bias_target(policy, freq_next,
-					CPUFREQ_RELATION_L);
-			__cpufreq_driver_target(policy, freq,
-					CPUFREQ_RELATION_L);
+			return;
 		}
+
+		freq_next = od_ops.powersave_bias_target(policy, freq_next,
+					CPUFREQ_RELATION_L);
+		__cpufreq_driver_target(policy, freq_next, CPUFREQ_RELATION_L);
 	}
 }
 
@@ -557,7 +560,7 @@ define_get_cpu_dbs_routines(od_cpu_dbs_info);
 
 static struct od_ops od_ops = {
 	.powersave_bias_init_cpu = ondemand_powersave_bias_init_cpu,
-	.powersave_bias_target = powersave_bias_target,
+	.powersave_bias_target = generic_powersave_bias_target,
 	.freq_increase = dbs_freq_increase,
 };
 
@@ -574,6 +577,45 @@ static struct common_dbs_data od_dbs_cdata = {
 	.exit = od_exit,
 };
 
+static void od_set_powersave_bias(unsigned int powersave_bias)
+{
+	struct cpufreq_policy *policy;
+	struct dbs_data *dbs_data;
+	struct od_dbs_tuners *od_tuners;
+	unsigned int cpu;
+	cpumask_t done;
+
+	cpumask_clear(&done);
+
+	for_each_online_cpu(cpu) {
+		if (cpumask_test_cpu(cpu, &done))
+			continue;
+
+		policy = per_cpu(od_cpu_dbs_info, cpu).cdbs.cur_policy;
+		dbs_data = policy->governor_data;
+		od_tuners = dbs_data->tuners;
+		od_tuners->powersave_bias = powersave_bias;
+
+		cpumask_or(&done, &done, policy->cpus);
+	}
+}
+
+void od_register_powersave_bias_handler(unsigned int (*f)
+		(struct cpufreq_policy *, unsigned int, unsigned int),
+		unsigned int powersave_bias)
+{
+	od_ops.powersave_bias_target = f;
+	od_set_powersave_bias(powersave_bias);
+}
+EXPORT_SYMBOL_GPL(od_register_powersave_bias_handler);
+
+void od_unregister_powersave_bias_handler(void)
+{
+	od_ops.powersave_bias_target = generic_powersave_bias_target;
+	od_set_powersave_bias(0);
+}
+EXPORT_SYMBOL_GPL(od_unregister_powersave_bias_handler);
+
 static int od_cpufreq_governor_dbs(struct cpufreq_policy *policy,
 		unsigned int event)
 {
-- 
1.7.9.5


