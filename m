Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab3LXBlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:41:14 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58696 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab3LXBlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:41:12 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn@mork.no,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Date: Tue, 24 Dec 2013 07:11:00 +0530
Message-Id: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_add_dev() can fail sometimes while we are resuming our system.
Currently we are clearing all sysfs nodes for cpufreq's failed policy as that
could make userspace unstable. But if we suspend/resume again, we should atleast
try to bring back those policies.

This patch fixes this issue by clearing fallback data on failure and trying to
allocate a new struct cpufreq_policy on second resume.

Reported-and-tested-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
These are sent again (earlier sent as reply to emails), so that people can
give inputs if they have any.

Tested on my thinkpad T420.

 drivers/cpufreq/cpufreq.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 16d7b4a..0a48e71 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1016,16 +1016,24 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
-	if (frozen)
+	if (frozen) {
 		/* Restore the saved policy when doing light-weight init */
 		policy = cpufreq_policy_restore(cpu);
-	else
+
+		/*
+		 * As we failed to resume cpufreq core last time, lets try to
+		 * create a new policy.
+		 */
+		if (!policy)
+			frozen = false;
+	}
+
+	if (!frozen)
 		policy = cpufreq_policy_alloc();
 
 	if (!policy)
 		goto nomem_out;
 
-
 	/*
 	 * In the resume path, since we restore a saved policy, the assignment
 	 * to policy->cpu is like an update of the existing policy, rather than
@@ -1118,8 +1126,14 @@ err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
-	if (frozen)
+	if (frozen) {
+		/*
+		 * Clear fallback data as we should try to make things work on
+		 * next suspend/resume
+		 */
+		per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
 		cpufreq_policy_put_kobj(policy);
+	}
 	cpufreq_policy_free(policy);
 
 nomem_out:
-- 
1.7.12.rc2.18.g61b472e

