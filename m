Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3LXBlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:41:22 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:64049 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3LXBlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:41:19 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@mork.no,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: =?UTF-8?q?=5BPATCH=202/2=5D=20cpufreq=3A=20preserve=20user=5Fpolicy=20across=20suspend/resume?=
Date: Tue, 24 Dec 2013 07:11:01 +0530
Message-Id: <03303e46795a89272ba66d5fa230cbfdb9a177a9.1387848958.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
In-Reply-To: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __cpufreq_add_dev() we are reinitializing user_policy with default values and
hence would loose values of user_policy.{min|max|policy|governor} fields.

Preserve them by not overriding these for suspend/resume.

Reported-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0a48e71..59e918e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -839,9 +839,6 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 
 	/* set default policy */
 	ret = cpufreq_set_policy(policy, &new_policy);
-	policy->user_policy.policy = policy->policy;
-	policy->user_policy.governor = policy->governor;
-
 	if (ret) {
 		pr_debug("setting policy failed\n");
 		if (cpufreq_driver->exit)
@@ -1077,8 +1074,10 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	 */
 	cpumask_and(policy->cpus, policy->cpus, cpu_online_mask);
 
-	policy->user_policy.min = policy->min;
-	policy->user_policy.max = policy->max;
+	if (!frozen) {
+		policy->user_policy.min = policy->min;
+		policy->user_policy.max = policy->max;
+	}
 
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 				     CPUFREQ_START, policy);
@@ -1109,6 +1108,11 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 
 	cpufreq_init_policy(policy);
 
+	if (!frozen) {
+		policy->user_policy.policy = policy->policy;
+		policy->user_policy.governor = policy->governor;
+	}
+
 	kobject_uevent(&policy->kobj, KOBJ_ADD);
 	up_read(&cpufreq_rwsem);
 
-- 
1.7.12.rc2.18.g61b472e

