Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3BGK2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 05:28:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52657 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757451Ab3BGK2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 05:28:02 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl, valdis.kletnieks@vt.edu, artem.savkov@gmail.com
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/4] cpufreq: Remove unused HOTPLUG_CPU code
Date: Thu,  7 Feb 2013 15:57:44 +0530
Message-Id: <eb7c28865762189a6b741550d4664c667ecbc24b.1360232293.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1360232293.git.viresh.kumar@linaro.org>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1360232293.git.viresh.kumar@linaro.org>
References: <cover.1360232293.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 07 Feb 2013 10:27:59.0880 (UTC) FILETIME=[CD6A2880:01CE051D]
X-MC-Unique: 113020710280100601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r17ASv7W028068

Because the sibling cpu of any online cpu is identified very early in
cpufreq_add_dev(), below code is never executed. And so can be removed.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3b941a1..795b0e8 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -858,7 +858,7 @@ static int cpufreq_add_policy_cpu(unsigned int cpu, unsigned int sibling,
 static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int j, cpu = dev->id;
-	int ret = -ENOMEM, found = 0;
+	int ret = -ENOMEM;
 	struct cpufreq_policy *policy;
 	struct cpufreq_driver *driver;
 	unsigned long flags;
@@ -908,6 +908,7 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 		goto err_free_cpumask;
 
 	policy->cpu = cpu;
+	policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	cpumask_copy(policy->cpus, cpumask_of(cpu));
 
 	/* Initially set CPU itself as the policy_cpu */
@@ -918,20 +919,6 @@ static int cpufreq_add_dev(struct device *dev, struct subsys_interface *sif)
 	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
-	/* Set governor before ->init, so that driver could check it */
-#ifdef CONFIG_HOTPLUG_CPU
-	for_each_online_cpu(sibling) {
-		struct cpufreq_policy *cp = per_cpu(cpufreq_cpu_data, sibling);
-		if (cp && cp->governor &&
-		    (cpumask_test_cpu(cpu, cp->related_cpus))) {
-			policy->governor = cp->governor;
-			found = 1;
-			break;
-		}
-	}
-#endif
-	if (!found)
-		policy->governor = CPUFREQ_DEFAULT_GOVERNOR;
 	/* call driver. From then on the cpufreq must be able
 	 * to accept all calls to ->verify and ->setpolicy for this CPU
 	 */
-- 
1.7.12.rc2.18.g61b472e


