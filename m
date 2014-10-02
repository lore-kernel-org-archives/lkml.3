Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbaJBGyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 02:54:44 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5049 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbaJBGym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 02:54:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 01 Oct 2014 23:54:38 -0700
From: Vince Hsu <vinceh@nvidia.com>
To: <viresh.kumar@linaro.org>, <rjw@rjwysocki.net>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bilhuang@nvidia.com>, <dgreid@google.com>, <olofj@chromium.org>,
        Vince Hsu <vinceh@nvidia.com>
Subject: [PATCH] cpufreq: respect the min/max settings from user space
Date: Thu, 2 Oct 2014 14:55:00 +0800
Message-ID: <1412232900-11238-1-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the user space tries to set scaling_(max|min)_freq through
sysfs, the cpufreq_set_policy() asks other driver's opinions
for the max/min frequencies. Some device drivers, like Tegra
CPU EDP which is not upstreamed yet though, may constrain the
CPU maximum frequency dynamically because of board design.
So if the user space access happens and some driver is capping
the cpu frequency at the same time, the user_policy->(max|min)
is overridden by the capped value, and that's not expected by
the user space. And if the user space is not invoked again,
the CPU will always be capped by the user_policy->(max|min)
even no drivers limit the CPU frequency any more.

This patch preserves the user specified min/max settings, so that
every time the cpufreq policy is updated, the new max/min can
be re-evaluated correctly based on the user's expection and
the present device drivers' status.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
---
Hi,

I'm not sure if any platform that is supported mainlin might have this
issue, and this patch is complie tested only. We hit the problem when 
the laptop_mode tool configures the scaling_max_freq and the Tegra
CPU EDP driver is limiting the CPU maximum frequency.

 drivers/cpufreq/cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 24bf76fba141..c007cf2a3d2a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -524,7 +524,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 static ssize_t store_##file_name					\
 (struct cpufreq_policy *policy, const char *buf, size_t count)		\
 {									\
-	int ret;							\
+	int ret, temp;						\
 	struct cpufreq_policy new_policy;				\
 									\
 	ret = cpufreq_get_policy(&new_policy, policy->cpu);		\
@@ -535,8 +535,10 @@ static ssize_t store_##file_name					\
 	if (ret != 1)							\
 		return -EINVAL;						\
 									\
+	temp = new_policy.object;					\
 	ret = cpufreq_set_policy(policy, &new_policy);		\
-	policy->user_policy.object = policy->object;			\
+	if (!ret)							\
+		policy->user_policy.object = temp;			\
 									\
 	return ret ? ret : count;					\
 }
-- 
1.9.1

