Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbaCDK2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:28:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34056 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870AbaCDK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:28:17 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-c0-5315aab358d7
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
Subject: [RFC v3 3/5] cpufreq:LAB:lab Add LAB governor code
Date: Tue, 04 Mar 2014 11:27:30 +0100
Message-id: <1393928852-22725-4-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t9jAd3Nq0SDDS7/07fYOGM9q8XTph/s
	Fp1nnzBbvHnEbfHm4WZGi02Pr7FaXN41h83ic+8RRosZ5/cxWdxuXMFmceb0JVaL9TNes1hs
	nrCRzaJjGaPFxq8eDvweO2fdZfe4c20Pm8fmJfUe66a9ZfbYcrWdxaNvyypGj8+b5ALYo7hs
	UlJzMstSi/TtErgyfvWoF1xPqfh3eB9zA+O6wC5GTg4JAROJvvtfWCFsMYkL99azdTFycQgJ
	LGKUWDF5GztIQkigi0ni2YcsEJtNQE/i892nTCC2iECoxNGpX9lBGpgFzrBIvH2xG2ySsIC1
	xJsmiKksAqoS5xY+A7N5Bdwknt9vZIHYpijR/WwCG4jNKeAucXxFMzPE5lZGics7bzBNYORd
	wMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4ZJ9J7WBc2WBxiFGAg1GJh3fGNJFgIdbE
	suLK3EOMEhzMSiK8igtFg4V4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1I
	LYLJMnFwSjUwblSdpNBjYeTGprdzjtxr68gtMksW797xTrm7xEHs7/ISLj+FtN0bnV/v3Ga7
	mCearYgt0+6/sfbnXQmWayZaHe+w8X2YeP0a5xanxXc48zcwVt4Pm3Xw3a71ZrNylCYU8W07
	uO/1lUVrG4PlZzfNvL23/mhVuNDz490zas24Xk5gOiAdZbhEQImlOCPRUIu5qDgRAO3qPMhV	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds code for LAB governor. It shall be noted, that it reuses
a lot of ondemand code.

The main difference is that it works on top of ondemand, and this code is
able to "call" ondemand when needed. This means that all ondemand "backing"
data are properly updated.

Such approach has one major advantage - with LAB we can focus on saving
energy and leave the "normal" cpufreq management to well tested ondemand.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/Makefile      |    1 +
 drivers/cpufreq/cpufreq_lab.c |  457 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 458 insertions(+)
 create mode 100644 drivers/cpufreq/cpufreq_lab.c

diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 7494565..64bff8dc 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_CPU_FREQ_GOV_POWERSAVE)	+= cpufreq_powersave.o
 obj-$(CONFIG_CPU_FREQ_GOV_USERSPACE)	+= cpufreq_userspace.o
 obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
 obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
+obj-$(CONFIG_CPU_FREQ_GOV_LAB)		+= cpufreq_lab.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
 obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
diff --git a/drivers/cpufreq/cpufreq_lab.c b/drivers/cpufreq/cpufreq_lab.c
new file mode 100644
index 0000000..153c06b
--- /dev/null
+++ b/drivers/cpufreq/cpufreq_lab.c
@@ -0,0 +1,457 @@
+/*
+ * Copyright (c) 2013-2014 Samsung Electronics Co., Ltd.
+ *		http://www.samsung.com
+ *		Jonghwa Lee <jonghw3.lee@samusng.com>
+ *		Lukasz Majewski <l.majewski@samsung.com>
+ *
+ * LAB (Legacy Application Boost) cpufreq governor
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/cpufreq.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kernel_stat.h>
+#include <linux/kobject.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/percpu-defs.h>
+#include <linux/sysfs.h>
+#include <linux/tick.h>
+#include <linux/types.h>
+#include <linux/cpuidle.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+
+#include "cpufreq_governor.h"
+
+#define MAX_HIST		5
+
+#define LB_BOOST_ENABLE        ~0UL
+#define LB_MIN_FREQ            ~1UL
+#define LB_ONDEMAND             0
+
+/*
+ * Pre-calculated summation of weight, 0.5
+ * 1
+ * 1 + 0.5^1 = 1.5
+ * 1 + 0.5^1 + 0.5^2 = 1.75
+ * 1 + 0.5^1 + 0.5^2 + 0.5^3 = 1.87
+ * 1 + 0.5^1 + 0.5^2 + 0.5^3 + 0.5^4 = 1.93
+ */
+static int history_weight_sum[] = { 100, 150, 175, 187, 193 };
+
+static unsigned int *idle_avg;
+static unsigned int *idle_hist;
+static int idle_cpus, lb_threshold = 90;
+static unsigned int *lb_ctrl_table, lb_load;
+static int lb_ctrl_table_size, lb_num_of_states;
+static bool boost_init_state;
+
+static DECLARE_BITMAP(boost_hist, MAX_HIST);
+DECLARE_PER_CPU(struct od_cpu_dbs_info_s, od_cpu_dbs_info);
+
+struct cpufreq_governor cpufreq_gov_lab;
+
+
+static struct lb_wq_boost_data {
+	bool state;
+	struct work_struct work;
+} lb_boost_data;
+
+/*
+ * Calculate average of idle time with weighting 50% less to older one.
+ * With weight, average can be affected by current phase more rapidly than
+ * normal average. And it also has tolerance for temporary fluctuation of
+ * idle time as normal average has.
+ *
+ * Weigted average = sum(ai * wi) / sum(wi)
+ */
+static inline int cpu_idle_calc_avg(unsigned int *p, int size)
+{
+	int i, sum;
+
+	for (i = 0, sum = 0; i < size; p++, i++) {
+		sum += *p;
+		*p >>= 1;
+	}
+	sum *= 100;
+
+	return (int) (sum / history_weight_sum[size - 1]);
+}
+
+static unsigned int lb_chose_freq(unsigned int load, int idle_cpus)
+{
+	unsigned int p, q = 100 / lb_num_of_states;
+	int idx;
+
+	for (idx = 0, p = q; idx < lb_num_of_states; idx++, p += q)
+		if (load <= p)
+			break;
+
+	return *(lb_ctrl_table + (lb_num_of_states * idle_cpus) + idx);
+}
+
+static void lb_cpufreq_boost_work(struct work_struct *work)
+{
+	struct lb_wq_boost_data *d = container_of(work,
+						  struct lb_wq_boost_data,
+						  work);
+	cpufreq_boost_trigger_state(d->state);
+}
+
+static struct common_dbs_data lb_dbs_cdata;
+/*
+ * LAB governor policy adjustement
+ */
+static void lb_check_cpu(int cpu, unsigned int load)
+{
+	struct od_cpu_dbs_info_s *dbs_info = &per_cpu(od_cpu_dbs_info, cpu);
+	struct cpufreq_policy *policy = dbs_info->cdbs.cur_policy;
+	unsigned int freq = 0, op;
+	static int cnt;
+	int i, idx, bs;
+
+	idle_cpus = 0;
+	lb_load = load;
+	idx = cnt++ % MAX_HIST;
+
+	for_each_possible_cpu(i) {
+		struct od_cpu_dbs_info_s *dbs_cpu_info =
+			&per_cpu(od_cpu_dbs_info, i);
+
+		idle_hist[i * MAX_HIST + idx] = dbs_cpu_info->idle_time;
+		idle_avg[i] = cpu_idle_calc_avg(&idle_hist[i * MAX_HIST],
+					cnt < MAX_HIST ? cnt : MAX_HIST);
+
+		if (idle_avg[i] > lb_threshold)
+			idle_cpus++;
+	}
+
+	if (idle_cpus < 0 || idle_cpus > num_possible_cpus()) {
+		pr_warn("%s: idle_cpus: %d out of range\n", __func__,
+			idle_cpus);
+		return;
+	}
+
+	if (!lb_ctrl_table)
+		return;
+
+	op = lb_chose_freq(load, idle_cpus);
+	if (op == LB_BOOST_ENABLE)
+		set_bit(idx, boost_hist);
+	else
+		clear_bit(idx, boost_hist);
+
+	bs = cpufreq_boost_enabled();
+	/*
+	 * - To disable boost -
+	 *
+	 * Operation different than LB_BOOST_ENABLE is
+	 * required for at least MAX_HIST previous operations
+	 */
+	if (bs && bitmap_empty(boost_hist, MAX_HIST)) {
+		lb_boost_data.state = false;
+		schedule_work_on(cpu, &lb_boost_data.work);
+	}
+
+	/*
+	 * - To enable boost -
+	 *
+	 * Only (MAX_HIST - 1) bits are required. This allows entering
+	 * BOOST mode earlier, since we skip one "round" of LAB operation
+	 * before work is executed.
+	 */
+	if (!bs &&
+	    (bitmap_weight(boost_hist, MAX_HIST) == (MAX_HIST - 1))) {
+		lb_boost_data.state = true;
+		schedule_work_on(cpu, &lb_boost_data.work);
+	}
+
+	switch (op) {
+	case LB_BOOST_ENABLE:
+		freq = policy->max;
+		break;
+
+	case LB_MIN_FREQ:
+		freq = policy->min;
+		break;
+
+	case LB_ONDEMAND:
+		od_check_cpu(cpu, load);
+		return;
+
+	default:
+		freq = op;
+	}
+
+	if (policy->cur == freq)
+		return;
+
+	__cpufreq_driver_target(policy, freq, CPUFREQ_RELATION_L);
+}
+
+static ssize_t show_load(struct kobject *kobj,
+			 struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", lb_load);
+}
+define_one_global_ro(load);
+
+static ssize_t show_idle_cpus_num(struct kobject *kobj,
+				  struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", idle_cpus);
+}
+define_one_global_ro(idle_cpus_num);
+
+static ssize_t show_idle_avg_cpus_val(struct kobject *kobj,
+				      struct attribute *attr, char *buf)
+{
+	char off;
+	int i;
+
+	for (i = 0, off = 0; i < num_possible_cpus(); i++)
+		off += sprintf(buf + off, "%u ", idle_avg[i]);
+
+	*(buf + off - 1) = '\n';
+
+	return off;
+}
+define_one_global_ro(idle_avg_cpus_val);
+
+static ssize_t show_idle_threshold(struct kobject *kobj,
+				   struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%u\n", lb_threshold);
+}
+
+static ssize_t store_idle_threshold(struct kobject *a, struct attribute *b,
+				    const char *buf, size_t count)
+{
+	unsigned int val;
+	int ret;
+
+	ret = sscanf(buf, "%u", &val);
+	if (ret != 1)
+		return -EINVAL;
+
+	if (val < 0 || val > 100) {
+		pr_err("%s: Only value in a range 0 to 100 accepted\n",
+		       __func__);
+		return -EINVAL;
+	}
+
+	lb_threshold = val;
+	return count;
+}
+define_one_global_rw(idle_threshold);
+
+ssize_t store_sampling_rate(struct kobject *a, struct attribute *b,
+				   const char *buf, size_t count)
+{
+	struct dbs_data *dbs_data = lb_dbs_cdata.gdbs_data;
+	unsigned int input;
+	int ret;
+	ret = sscanf(buf, "%u", &input);
+	if (ret != 1)
+		return -EINVAL;
+
+	update_sampling_rate(dbs_data, input);
+	return count;
+}
+
+static ssize_t show_sampling_rate(struct kobject *kobj, struct attribute *attr,
+				  char *buf)
+{
+	struct od_dbs_tuners *tuners = lb_dbs_cdata.gdbs_data->tuners;
+
+	return sprintf(buf, "%u\n", tuners->sampling_rate);
+}
+define_one_global_rw(sampling_rate);
+
+static ssize_t show_sampling_rate_min(struct kobject *kobj,
+				      struct attribute *attr, char *buf)
+{
+	struct dbs_data *dbs_data = lb_dbs_cdata.gdbs_data;
+
+	return sprintf(buf, "%u\n", dbs_data->min_sampling_rate);
+}
+define_one_global_ro(sampling_rate_min);
+
+static struct attribute *dbs_attributes_gov_sys[] = {
+	&sampling_rate_min.attr,
+	&idle_avg_cpus_val.attr,
+	&idle_threshold.attr,
+	&idle_cpus_num.attr,
+	&sampling_rate.attr,
+	&load.attr,
+	NULL
+};
+
+static struct attribute_group lb_attr_group_gov_sys = {
+	.attrs = dbs_attributes_gov_sys,
+	.name = "lab",
+};
+
+static int lb_ctrl_table_of_init(struct device_node *dn,
+				 unsigned int **ctrl_tab, int size)
+{
+	struct property *pp;
+	int len;
+
+	pp = of_find_property(dn, "lab-ctrl-freq", &len);
+	if (!pp) {
+		pr_err("%s: Property: 'lab-ctrl-freq'  not found\n", __func__);
+		return -ENODEV;
+	}
+
+	if (len != (size * sizeof(**ctrl_tab))) {
+		pr_err("%s: Wrong 'lab-ctrl-freq' size\n", __func__);
+		return -EINVAL;
+	}
+
+	*ctrl_tab = kzalloc(len, GFP_KERNEL);
+	if (!*ctrl_tab) {
+		pr_err("%s: Not enough memory for LAB control structure\n",
+		       __func__);
+		return -ENOMEM;
+	}
+
+	if (of_property_read_u32_array(dn, pp->name, *ctrl_tab, size)) {
+		pr_err("Property: %s cannot be read!\n", pp->name);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int lb_of_init(void)
+{
+	struct device_node *dn;
+	struct property *pp;
+	int ret;
+
+	dn = of_find_node_by_path("/cpus/cpu@0");
+	if (!dn) {
+		pr_err("%s: Node: '/cpus/cpu@0/' not found\n", __func__);
+		return -ENODEV;
+	}
+
+	pp = of_find_property(dn, "lab-num-of-states", NULL);
+	if (!pp) {
+		pr_err("%s: Property: 'lab-num-of-states'  not found\n",
+		       __func__);
+		ret = -ENODEV;
+		goto dn_err;
+	}
+	lb_num_of_states = be32_to_cpup(pp->value);
+
+	lb_ctrl_table_size = lb_num_of_states * (num_possible_cpus() + 1);
+	ret = lb_ctrl_table_of_init(dn, &lb_ctrl_table, lb_ctrl_table_size);
+	if (ret) {
+		kfree(lb_ctrl_table);
+		lb_ctrl_table = NULL;
+		pr_err("%s: Cannot parse LAB control structure from OF\n",
+		       __func__);
+		return ret;
+	}
+
+dn_err:
+	of_node_put(dn);
+	return ret;
+}
+
+static int lb_init(struct dbs_data *dbs_data)
+{
+	int ret;
+
+	idle_avg = kzalloc(num_possible_cpus() * sizeof(*idle_avg), GFP_KERNEL);
+	if (!idle_avg) {
+		pr_err("%s: Not enough memory", __func__);
+		return -ENOMEM;
+	}
+
+	idle_hist = kzalloc(num_possible_cpus() * MAX_HIST * sizeof(*idle_hist),
+			    GFP_KERNEL);
+	if (!idle_hist) {
+		pr_err("%s: Not enough memory", __func__);
+		ret = -ENOMEM;
+		goto err_idle_avg;
+	}
+
+	ret = lb_of_init();
+	if (ret)
+		goto err_idle_hist;
+
+	boost_init_state = cpufreq_boost_enabled();
+	if (boost_init_state)
+		cpufreq_boost_trigger_state(false);
+
+	od_init(dbs_data);
+
+	INIT_WORK(&lb_boost_data.work, lb_cpufreq_boost_work);
+
+	return 0;
+
+err_idle_hist:
+	kfree(idle_hist);
+err_idle_avg:
+	kfree(idle_avg);
+
+	return ret;
+}
+
+void lb_exit(struct dbs_data *dbs_data)
+{
+	od_exit(dbs_data);
+
+	kfree(lb_ctrl_table);
+	lb_ctrl_table = NULL;
+
+	cpufreq_boost_trigger_state(boost_init_state);
+
+	kfree(idle_avg);
+	kfree(idle_hist);
+}
+
+define_get_cpu_dbs_routines(od_cpu_dbs_info);
+
+static struct common_dbs_data lb_dbs_cdata = {
+	.governor = GOV_LAB,
+	.attr_group_gov_sys = &lb_attr_group_gov_sys,
+	.get_cpu_cdbs = get_cpu_cdbs,
+	.get_cpu_dbs_info_s = get_cpu_dbs_info_s,
+	.gov_dbs_timer = od_dbs_timer,
+	.gov_check_cpu = lb_check_cpu,
+	.gov_ops = &od_ops,
+	.init = lb_init,
+	.exit = lb_exit,
+};
+
+static int lb_cpufreq_governor_dbs(struct cpufreq_policy *policy,
+		unsigned int event)
+{
+	return cpufreq_governor_dbs(policy, &lb_dbs_cdata, event);
+}
+
+struct cpufreq_governor cpufreq_gov_lab = {
+	.name			= "lab",
+	.governor		= lb_cpufreq_governor_dbs,
+	.max_transition_latency = TRANSITION_LATENCY_LIMIT,
+	.owner			= THIS_MODULE,
+};
+
+static int __init cpufreq_gov_dbs_init(void)
+{
+	return cpufreq_register_governor(&cpufreq_gov_lab);
+}
+
+#ifdef CONFIG_CPU_FREQ_DEFAULT_GOV_LAB
+fs_initcall(cpufreq_gov_dbs_init);
+#else
+module_init(cpufreq_gov_dbs_init);
+#endif
-- 
1.7.10.4

