Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbaFRAMv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 20:12:51 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:5024 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbaFRAMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 20:12:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 17 Jun 2014 17:07:11 -0700
From: Aaron Plattner <aplattner@nvidia.com>
To: <linux-pm@vger.kernel.org>
CC: Aaron Plattner <aplattner@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH] cpufreq: unlock when failing cpufreq_update_policy()
Date: Tue, 17 Jun 2014 17:12:42 -0700
Message-ID: <1403050362-20809-1-git-send-email-aplattner@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit bd0fa9bb455d introduced a failure path to cpufreq_update_policy() if
cpufreq_driver->get(cpu) returns NULL.  However, it jumps to the 'no_policy'
label, which exits without unlocking any of the locks the function acquired
earlier.  This causes later calls into cpufreq to hang.

Fix this by creating a new 'unlock' label and jumping to that instead.

Fixes: bd0fa9bb455d ("cpufreq: Return error if ->get() failed in cpufreq_update_policy()")
Link: https://devtalk.nvidia.com/default/topic/751903/kernel-3-15-and-nv-drivers-337-340-failed-to-initialize-the-nvidia-kernel-module-gtx-550-ti-/
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Aaron Plattner <aplattner@nvidia.com>
---
I haven't reproduced this problem so I couldn't test it, but the bug and its
solution seem obvious enough.

 drivers/cpufreq/cpufreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index aed2b0cb83dc..5b6d04f3b9ea 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2264,7 +2264,7 @@ int cpufreq_update_policy(unsigned int cpu)
 		new_policy.cur = cpufreq_driver->get(cpu);
 		if (WARN_ON(!new_policy.cur)) {
 			ret = -EIO;
-			goto no_policy;
+			goto unlock;
 		}
 
 		if (!policy->cur) {
@@ -2279,6 +2279,7 @@ int cpufreq_update_policy(unsigned int cpu)
 
 	ret = cpufreq_set_policy(policy, &new_policy);
 
+unlock:
 	up_write(&policy->rwsem);
 
 	cpufreq_cpu_put(policy);
-- 
2.0.0

