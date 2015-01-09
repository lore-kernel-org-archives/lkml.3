Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbbAIJ4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 04:56:06 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:37321 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbbAIJzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 04:55:08 -0500
From: "pi-cheng.chen" <pi-cheng.chen@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: "pi-cheng.chen" <pi-cheng.chen@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linaro-kernel@lists.linaro.org,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>
Subject: [PATCH 1/2] cpufreq-dt: check CPU clock/power domain during initializing
Date: Fri,  9 Jan 2015 17:54:50 +0800
Message-Id: <1420797291-15972-2-git-send-email-pi-cheng.chen@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420797291-15972-1-git-send-email-pi-cheng.chen@linaro.org>
References: <1420797291-15972-1-git-send-email-pi-cheng.chen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the DT based cpufreq driver is missing some way to check which
CPUs share clocks. In the 1st patch, CPU clock/power domain information is
added to the platform_data of cpufreq-dt so that cpufreq-dt driver could
check which CPUs share clock/power.

Signed-off-by: pi-cheng.chen <pi-cheng.chen@linaro.org>
---
 drivers/cpufreq/cpufreq-dt.c | 15 +++++++++++++++
 include/linux/cpufreq-dt.h   |  6 ++++++
 2 files changed, 21 insertions(+)

diff --git a/drivers/cpufreq/cpufreq-dt.c b/drivers/cpufreq/cpufreq-dt.c
index fde97d6..ff8c266 100644
--- a/drivers/cpufreq/cpufreq-dt.c
+++ b/drivers/cpufreq/cpufreq-dt.c
@@ -296,6 +296,21 @@ static int cpufreq_init(struct cpufreq_policy *policy)
 	pd = cpufreq_get_driver_data();
 	if (!pd || !pd->independent_clocks)
 		cpumask_setall(policy->cpus);
+	else if (pd && !list_empty(&pd->domain_list)) {
+		struct list_head *domain_node;
+
+		list_for_each(domain_node, &pd->domain_list) {
+			struct cpufreq_cpu_domain *domain;
+
+			domain = container_of(domain_node,
+					      struct cpufreq_cpu_domain, node);
+			if (!cpumask_test_cpu(policy->cpu, &domain->cpus))
+				continue;
+
+			cpumask_copy(policy->cpus, &domain->cpus);
+			break;
+		}
+	}
 
 	of_node_put(np);
 
diff --git a/include/linux/cpufreq-dt.h b/include/linux/cpufreq-dt.h
index 0414009..92bffd3 100644
--- a/include/linux/cpufreq-dt.h
+++ b/include/linux/cpufreq-dt.h
@@ -10,6 +10,11 @@
 #ifndef __CPUFREQ_DT_H__
 #define __CPUFREQ_DT_H__
 
+struct cpufreq_cpu_domain {
+	struct list_head node;
+	cpumask_t cpus;
+};
+
 struct cpufreq_dt_platform_data {
 	/*
 	 * True when each CPU has its own clock to control its
@@ -17,6 +22,7 @@ struct cpufreq_dt_platform_data {
 	 * clock.
 	 */
 	bool independent_clocks;
+	struct list_head domain_list;
 };
 
 #endif /* __CPUFREQ_DT_H__ */
-- 
1.9.1

