Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013Ab3FSRNb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:13:31 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64940 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934924Ab3FSRN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:13:28 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-5a-51c1e6b6d2b0
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocky" <rjw@sisk.pl>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH v4 5/7] cpufreq: Calculate number of busy CPUs
Date: Wed, 19 Jun 2013 19:12:46 +0200
Message-id: <1371661969-7660-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jQd3tzw4GGhy/yWLx5+1yVounTT/Y
	LeZ9lrVYs/8nk0Xn2SfMFr0LrrJZvHnEbfHm4WZGi8u75rBZfO49wmhxu3EFm0X/wl4miycP
	+9gsOo58Y7bY+NXDgd9j8Z6XTB53ru1h81g37S2zR9+WVYwejxa3MHocv7GdyePzJrkA9igu
	m5TUnMyy1CJ9uwSujBONE5gLelQrfly8w9rA+E2ui5GTQ0LARKJnywIWCFtM4sK99WxdjFwc
	QgLTGSXmnn7HCuF0MUn0vzjIDFLFJqAn8fnuUyYQW0TAV6Jn2SEmkCJmgX0sElO/dbCCJIQF
	7CRW3p3BCGKzCKhKzL9+C6yBV8BV4vHMs1Dr5CWe3u9jA7E5Bdwkjn/rglrdyCixdsMD5gmM
	vAsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBAfuM+kdjKsaLA4xCnAwKvHwalw+GCjE
	mlhWXJl7iFGCg1lJhHfpUaAQb0piZVVqUX58UWlOavEhRmkOFiVx3oOt1oFCAumJJanZqakF
	qUUwWSYOTqkGxq1zptjvm/Lz3YfNytd4Tkhu25pw/nf+Ix7Bn5zL++fs1bh0b27ZYxUXWd+y
	hXHz9yccykk9ON+36bLTzDVrz3F98TnKeDZx30HuEs1ZU3kuSPjNkTixfcq7SZv2n0nVnm8+
	88st29dLtjz7sfuN88zjJ8IZ98Y+njeTx628JFvszcGgtCmCPYf3K7EUZyQaajEXFScCACpD
	5FxYAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the core governor code, per cpu load value is calculated. This patch
uses it to mark processor as a "busy" one, when load value is higher than
90%.

New cpufreq sysfs attribute is created (busy_cpus). It is read only
and provides information about number of actually busy CPU.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v4:
- New patch
---
 drivers/cpufreq/cpufreq.c          |   31 ++++++++++++++++++++++++++++++-
 drivers/cpufreq/cpufreq_governor.c |    1 +
 include/linux/cpufreq.h            |    3 +++
 3 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 9141d33..f785273 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -48,6 +48,7 @@ static DEFINE_PER_CPU(char[CPUFREQ_NAME_LEN], cpufreq_cpu_governor);
 #endif
 static DEFINE_RWLOCK(cpufreq_driver_lock);
 static LIST_HEAD(cpufreq_policy_list);
+static cpumask_t cpufreq_busy_cpus;
 
 /*
  * cpu_policy_rwsem is a per CPU reader-writer semaphore designed to cure
@@ -317,6 +318,13 @@ EXPORT_SYMBOL_GPL(cpufreq_notify_transition);
 /*********************************************************************
  *                          SYSFS INTERFACE                          *
  *********************************************************************/
+ssize_t show_busy_cpus(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", cpufreq_num_busy_cpu());
+}
+define_one_global_ro(busy_cpus);
+
 ssize_t show_boost(struct kobject *kobj,
 				 struct attribute *attr, char *buf)
 {
@@ -1980,6 +1988,17 @@ int cpufreq_boost_enabled(void)
 	return boost_enabled;
 }
 
+int cpufreq_num_busy_cpu(void)
+{
+	return cpumask_weight(&cpufreq_busy_cpus);
+}
+
+void cpufreq_set_busy_cpu(int cpu, int val)
+{
+	val ? cpumask_set_cpu(cpu, &cpufreq_busy_cpus) :
+		cpumask_clear_cpu(cpu, &cpufreq_busy_cpus);
+}
+
 /*********************************************************************
  *               REGISTER / UNREGISTER CPUFREQ DRIVER                *
  *********************************************************************/
@@ -2019,6 +2038,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	cpufreq_driver = driver_data;
 	write_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+	ret = cpufreq_sysfs_create_file(&(busy_cpus.attr));
+	if (ret) {
+		pr_err("%s: cannot register global busy_cpus sysfs file\n",
+		       __func__);
+		goto err_null_driver;
+	}
+
 	if (!cpufreq_driver->boost_supported)
 		boost.attr.mode = 0444;
 
@@ -2026,7 +2052,7 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	if (ret) {
 		pr_err("%s: cannot register global boost sysfs file\n",
 		       __func__);
-		goto err_null_driver;
+		goto err_busy_idle_unreg;
 	}
 
 	ret = subsys_interface_register(&cpufreq_interface);
@@ -2058,6 +2084,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 	return 0;
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
+err_busy_idle_unreg:
+	cpufreq_sysfs_remove_file(&(busy_cpus.attr));
 err_null_driver:
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver = NULL;
@@ -2086,6 +2114,7 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 
 	subsys_interface_unregister(&cpufreq_interface);
 
+	cpufreq_sysfs_remove_file(&(busy_cpus.attr));
 	cpufreq_sysfs_remove_file(&(boost.attr));
 	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 077cea7..3402533 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -148,6 +148,7 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			continue;
 
 		load = 100 * (wall_time - idle_time) / wall_time;
+		cpufreq_set_busy_cpu(j, load > 90 ? 1 : 0);
 
 		if (dbs_data->cdata->governor == GOV_ONDEMAND) {
 			int freq_avg = __cpufreq_driver_getavg(policy, j);
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 4783c4c..536abfc 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -436,6 +436,9 @@ int cpufreq_frequency_table_target(struct cpufreq_policy *policy,
 int cpufreq_boost_trigger_state(int state);
 int cpufreq_boost_supported(void);
 int cpufreq_boost_enabled(void);
+
+void cpufreq_set_busy_cpu(int cpu, int val);
+int cpufreq_num_busy_cpu(void);
 /* the following 3 funtions are for cpufreq core use only */
 struct cpufreq_frequency_table *cpufreq_frequency_get_table(unsigned int cpu);
 
-- 
1.7.10.4

