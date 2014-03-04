Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbaCDK2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:28:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9794 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452AbaCDK2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:28:02 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-bd-5315aaa728bb
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        thomas.ab@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC v3 1/5] cpufreq:LAB:ondemand Adjust ondemand to be able to reuse
 its methods
Date: Tue, 04 Mar 2014 11:27:28 +0100
Message-id: <1393928852-22725-2-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd3lq0SDDVr2yVtsnLGe1eJp0w92
	i86zT5gt3jzitnjzcDOjxabH11gtLu+aw2bxufcIo8WM8/uYLG43rmCzOHP6EqvF+hmvWSw2
	T9jIZtGxjNFi41cPB36PnbPusnvcubaHzWPzknqPddPeMntsudrO4tG3ZRWjx+dNcgHsUVw2
	Kak5mWWpRfp2CVwZu27+Yy94oFyx+9pJ5gbG2XJdjJwcEgImEgcvPGeDsMUkLtxbD2RzcQgJ
	LGKU+PF3ATuE08Uk0bNmIzNIFZuAnsTnu0+ZQGwRgVCJo1O/ghUxC5xhkXj7YjcrSEJYIEbi
	z9cHYDaLgKrEh32zwWxeATeJ9z8fMEGsU5TofjYBbDWngLvE8RXNzBDbWhklLu+8wTSBkXcB
	I8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOCwfSa9g3FVg8UhRgEORiUeXocpIsFCrIll
	xZW5hxglOJiVRHgVF4oGC/GmJFZWpRblxxeV5qQWH2KU5mBREuc92GodKCSQnliSmp2aWpBa
	BJNl4uCUamA0Wfbhax3rrDSLZkMu7ilvz5jP/smSOfdx/4a/cWn7vy/P2/ftW4wIw6V1DBWr
	zn1ffj8nUHlthOGkB6X58/b11pezbfSen3pv2g6XoJkeimvqvRoSOq94SOTlPs/8cfTVyvKO
	NAchxXa1OXtLS+d2OS3I+jXn04ePp/xumxXW/wvx//7yjmCEEktxRqKhFnNRcSIAhj7hKVcC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ondemand code needed to be slightly adjusted to allow its reusage.
Mostly one needed to remove static qualifiers and provide some hacks to
allow its working with LAB.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/cpufreq_governor.h |   10 ++++++++++
 drivers/cpufreq/cpufreq_ondemand.c |   24 ++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_governor.h b/drivers/cpufreq/cpufreq_governor.h
index bfb9ae1..34b1cf2 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -270,4 +270,14 @@ void od_register_powersave_bias_handler(unsigned int (*f)
 		(struct cpufreq_policy *, unsigned int, unsigned int),
 		unsigned int powersave_bias);
 void od_unregister_powersave_bias_handler(void);
+
+/* COMMON CODE FOR DEMAND BASED SWITCHING */
+void od_dbs_timer(struct work_struct *work);
+int od_init(struct dbs_data *dbs_data);
+void od_exit(struct dbs_data *dbs_data);
+void od_check_cpu(int cpu, unsigned int load_freq);
+void update_sampling_rate(struct dbs_data *dbs_data,
+			  unsigned int new_rate);
+
+extern struct od_ops od_ops;
 #endif /* _CPUFREQ_GOVERNOR_H */
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 18d4091..a27326d 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -27,9 +27,9 @@
 #define MIN_FREQUENCY_UP_THRESHOLD		(11)
 #define MAX_FREQUENCY_UP_THRESHOLD		(100)
 
-static DEFINE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
+DEFINE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
 
-static struct od_ops od_ops;
+struct od_ops od_ops;
 
 #ifndef CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND
 static struct cpufreq_governor cpufreq_gov_ondemand;
@@ -152,7 +152,7 @@ static void dbs_freq_increase(struct cpufreq_policy *policy, unsigned int freq)
  * (default), then we try to increase frequency. Else, we adjust the frequency
  * proportional to load.
  */
-static void od_check_cpu(int cpu, unsigned int load)
+void od_check_cpu(int cpu, unsigned int load)
 {
 	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
 	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
@@ -188,7 +188,7 @@ static void od_check_cpu(int cpu, unsigned int load)
 	}
 }
 
-static void od_dbs_timer(struct work_struct *work)
+void od_dbs_timer(struct work_struct *work)
 {
 	struct od_cpu_dbs_info_s *dbs_info =
 		container_of(work, struct od_cpu_dbs_info_s, cdbs.work.work);
@@ -233,6 +233,9 @@ max_delay:
 /************************** sysfs interface ************************/
 static struct common_dbs_data od_dbs_cdata;
 
+#ifdef CONFIG_CPU_FREQ_GOV_LAB
+extern struct cpufreq_governor cpufreq_gov_lab;
+#endif
 /**
  * update_sampling_rate - update sampling rate effective immediately if needed.
  * @new_rate: new sampling rate
@@ -246,7 +249,7 @@ static struct common_dbs_data od_dbs_cdata;
  * reducing the sampling rate, we need to make the new value effective
  * immediately.
  */
-static void update_sampling_rate(struct dbs_data *dbs_data,
+void update_sampling_rate(struct dbs_data *dbs_data,
 		unsigned int new_rate)
 {
 	struct od_dbs_tuners *od_tuners = dbs_data->tuners;
@@ -263,7 +266,12 @@ static void update_sampling_rate(struct dbs_data *dbs_data,
 		policy = cpufreq_cpu_get(cpu);
 		if (!policy)
 			continue;
+#ifdef CONFIG_CPU_FREQ_GOV_LAB
+		if (policy->governor != &cpufreq_gov_ondemand &&
+		    policy->governor != &cpufreq_gov_lab) {
+#else
 		if (policy->governor != &cpufreq_gov_ondemand) {
+#endif
 			cpufreq_cpu_put(policy);
 			continue;
 		}
@@ -472,7 +480,7 @@ static struct attribute_group od_attr_group_gov_pol = {
 
 /************************** sysfs end ************************/
 
-static int od_init(struct dbs_data *dbs_data)
+int od_init(struct dbs_data *dbs_data)
 {
 	struct od_dbs_tuners *tuners;
 	u64 idle_time;
@@ -514,14 +522,14 @@ static int od_init(struct dbs_data *dbs_data)
 	return 0;
 }
 
-static void od_exit(struct dbs_data *dbs_data)
+void od_exit(struct dbs_data *dbs_data)
 {
 	kfree(dbs_data->tuners);
 }
 
 define_get_cpu_dbs_routines(od_cpu_dbs_info);
 
-static struct od_ops od_ops = {
+struct od_ops od_ops = {
 	.powersave_bias_init_cpu = ondemand_powersave_bias_init_cpu,
 	.powersave_bias_target = generic_powersave_bias_target,
 	.freq_increase = dbs_freq_increase,
-- 
1.7.10.4

