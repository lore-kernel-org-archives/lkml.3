Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935029Ab3FSRNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 13:13:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20449 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934924Ab3FSRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 13:13:33 -0400
X-AuditID: cbfee61a-b7f3b6d000006edd-6d-51c1e6bc3cf5
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
Subject: [PATCH v4 6/7] cpufreq: Enable software boost only when up to one busy
 core is running
Date: Wed, 19 Jun 2013 19:12:47 +0200
Message-id: <1371661969-7660-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1371661969-7660-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jQd09zw4GGrw4yWnx5+1yVounTT/Y
	LeZ9lrVYs/8nk0Xn2SfMFr0LrrJZvHnEbfHm4WZGi8u75rBZfO49wmhxu3EFm0X/wl4miycP
	+9gsOo58Y7bY+NXDgd9j8Z6XTB53ru1h81g37S2zR9+WVYwejxa3MHocv7GdyePzJrkA9igu
	m5TUnMyy1CJ9uwSujK93zrAVXBaqmN35jLGBcR9/FyMnh4SAicTxw1eYIGwxiQv31rN1MXJx
	CAlMZ5T42LwDyulikri7bBJYFZuAnsTnu0/BbBEBX4meZYeYQIqYBfaxSEz91sEKkhAWSJQ4
	sfIBC4jNIqAq0btrK5jNK+Aq8fX+GWaIdfIST+/3sYHYnAJuEse/dUFta2SUWLvhAfMERt4F
	jAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYID95nUDsaVDRaHGAU4GJV4eDUuHwwUYk0s
	K67MPcQowcGsJMK79ChQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUA+OUIHveK6Xv804cX6G+OtjgNiuTqYLVrI1VTPf7d6xV/13Z67SK7avrnCMCVcpT
	+rdKRyhuX7mH36v7Xo1x6888Z6nAY6d4W4rtJyxNmaAtd3vaal6Bq2FMP/42mehUTDgV9e/S
	a4WzK/iWa5U6W11m3LVs3m9pZ+65SsIXCtPN4xp25c1+90eJpTgj0VCLuag4EQC6qYZMWAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds protection from accidental enable of boost at systems,
which supports software boosting.

Boost software mode can be only enabled when up to one busy (with heavy
load) core is available on the system. Such approach brings extra
protection from over heating.

Moreover the boost is automatically disabled, when cpufreq core detects
more busy cores.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

Changes for v4:
- New patch
---
 drivers/cpufreq/cpufreq.c          |    9 +++++++--
 drivers/cpufreq/cpufreq_governor.c |    3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f785273..59d2cac 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1932,12 +1932,17 @@ static struct notifier_block __refdata cpufreq_cpu_notifier = {
 /*********************************************************************
  *               BOOST						     *
  *********************************************************************/
-static int cpufreq_boost_trigger_state_sw(void)
+static int cpufreq_boost_trigger_state_sw(int state)
 {
 	struct cpufreq_frequency_table *freq_table;
 	struct cpufreq_policy *policy;
 	int ret = -EINVAL;
 
+	if (state && cpufreq_num_busy_cpu() > 1) {
+		boost_enabled = 0;
+		return 0;
+	}
+
 	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
 		freq_table = cpufreq_frequency_get_table(policy->cpu);
 		if (freq_table)
@@ -1959,7 +1964,7 @@ int cpufreq_boost_trigger_state(int state)
 		if (cpufreq_driver->enable_boost)
 			ret = cpufreq_driver->enable_boost(state);
 		else
-			ret = cpufreq_boost_trigger_state_sw();
+			ret = cpufreq_boost_trigger_state_sw(state);
 
 		if (ret) {
 			boost_enabled = 0;
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 3402533..9383ab9 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -162,6 +162,9 @@ void dbs_check_cpu(struct dbs_data *dbs_data, int cpu)
 			max_load = load;
 	}
 
+	if (cpufreq_boost_supported() && cpufreq_num_busy_cpu() > 1)
+		cpufreq_boost_trigger_state(0);
+
 	dbs_data->cdata->gov_check_cpu(cpu, max_load);
 }
 EXPORT_SYMBOL_GPL(dbs_check_cpu);
-- 
1.7.10.4

