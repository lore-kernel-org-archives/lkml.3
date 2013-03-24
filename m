Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3CXP6W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:58:22 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58517 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753997Ab3CXP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:58:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: acpi-cpufreq: Don't set policy->related_cpus from .init()
Date: Sun, 24 Mar 2013 21:28:12 +0530
Message-Id: <0eb6a6ce25c71e60dc69e1897f80b7ce3bb41fb2.1364140610.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of following patch:

fcf8058 cpufreq: Simplify cpufreq_add_dev()

cpufreq driver's .init() routine must initialize policy->cpus with mask of all
possible cpus (Online + Offline) that share the clock. Then the core would copy
this mask onto policy->related_cpus and will reset policy->cpus to carry only
online cpus.

acpi-cpufreq driver wasn't updated with this assumption and so sometimes when
we try to hot[un]plug cpus at run time, sysfs directories gets corrupted.

This patch fixes acpi-cpufreq driver against this corruption.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Tested-by: Maciej Rutecki <maciej.rutecki@gmail.com>
---
 drivers/cpufreq/acpi-cpufreq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index afbef9c..11b8b4b 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -723,7 +723,6 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	    policy->shared_type == CPUFREQ_SHARED_TYPE_ANY) {
 		cpumask_copy(policy->cpus, perf->shared_cpu_map);
 	}
-	cpumask_copy(policy->related_cpus, perf->shared_cpu_map);
 
 #ifdef CONFIG_SMP
 	dmi_check_system(sw_any_bug_dmi_table);
@@ -735,7 +734,6 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	if (check_amd_hwpstate_cpu(cpu) && !acpi_pstate_strict) {
 		cpumask_clear(policy->cpus);
 		cpumask_set_cpu(cpu, policy->cpus);
-		cpumask_copy(policy->related_cpus, cpu_sibling_mask(cpu));
 		policy->shared_type = CPUFREQ_SHARED_TYPE_HW;
 		pr_info_once(PFX "overriding BIOS provided _PSD data\n");
 	}
-- 
1.7.12.rc2.18.g61b472e

