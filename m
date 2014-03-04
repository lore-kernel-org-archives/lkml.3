Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbaCDUmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:42:39 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9598 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbaCDUm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:42:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 04 Mar 2014 12:39:28 -0800
From: Aaron Plattner <aplattner@nvidia.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Aaron Plattner <aplattner@nvidia.com>, <cpufreq@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: use cpufreq_cpu_get to avoid cpufreq_get race conditions
Date: Tue, 4 Mar 2014 12:42:15 -0800
Message-ID: <1393965735-15610-1-git-send-email-aplattner@nvidia.com>
X-Mailer: git-send-email 1.9.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a module calls cpufreq_get while cpufreq is initializing, it's possible for
it to be called after cpufreq_driver is set but before cpufreq_cpu_data is
written during subsys_interface_register.  This happens because cpufreq_get
doesn't take the cpufreq_driver_lock around its use of cpufreq_cpu_data.

Fix this by using cpufreq_cpu_get(cpu) to look up the policy rather than reading
it out of cpufreq_cpu_data directly.  cpufreq_cpu_get takes the appropriate
locks to prevent this race from happening.

Since it's possible for policy to be NULL if the caller passes in an invalid CPU
number or calls the function before cpufreq is initialized, delete the
BUG_ON(!policy) and simply return 0.  Don't try to return -ENOENT because that's
negative and the function returns an unsigned integer.

Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
---
 drivers/cpufreq/cpufreq.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 8d19f7c..158d0b5 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1447,23 +1447,16 @@ static unsigned int __cpufreq_get(unsigned int cpu)
  */
 unsigned int cpufreq_get(unsigned int cpu)
 {
-	struct cpufreq_policy *policy = per_cpu(cpufreq_cpu_data, cpu);
+	struct cpufreq_policy *policy = cpufreq_cpu_get(cpu);
 	unsigned int ret_freq = 0;
 
-	if (cpufreq_disabled() || !cpufreq_driver)
-		return -ENOENT;
-
-	BUG_ON(!policy);
-
-	if (!down_read_trylock(&cpufreq_rwsem))
-		return 0;
-
-	down_read(&policy->rwsem);
-
-	ret_freq = __cpufreq_get(cpu);
+	if (policy) {
+		down_read(&policy->rwsem);
+		ret_freq = __cpufreq_get(cpu);
+		up_read(&policy->rwsem);
 
-	up_read(&policy->rwsem);
-	up_read(&cpufreq_rwsem);
+		cpufreq_cpu_put(policy);
+	}
 
 	return ret_freq;
 }
-- 
1.9.0

