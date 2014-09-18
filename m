Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaIRHGx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 03:06:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:5265 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaIRHGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 03:06:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,545,1406617200"; 
   d="scan'208";a="478362482"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Cpufreq: Keep cpufreq sysfs nodes across S2RAM/S2DISK when using intel_pstate driver.
Date: Thu, 18 Sep 2014 15:03:07 +0800
Message-Id: <1411023787-11458-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cpufreq core introduces cpufreq_suspended flag to let cpufreq sysfs nodes
across S2RAM/S2DISK. But the flag is only set in the cpufreq_suspend()
for cpufreq drivers which have target or target_index callback. This
skips intel_pstate driver. This patch is to set the flag before checking
target or target_index callback.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/cpufreq/cpufreq.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index d9fdedd..eb9bb78 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1656,6 +1656,8 @@ void cpufreq_suspend(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpufreq_suspended = true;
+
 	if (!has_target())
 		return;
 
@@ -1670,8 +1672,6 @@ void cpufreq_suspend(void)
 			pr_err("%s: Failed to suspend driver: %p\n", __func__,
 				policy);
 	}
-
-	cpufreq_suspended = true;
 }
 
 /**
@@ -1687,13 +1687,13 @@ void cpufreq_resume(void)
 	if (!cpufreq_driver)
 		return;
 
+	cpufreq_suspended = false;
+
 	if (!has_target())
 		return;
 
 	pr_debug("%s: Resuming Governors\n", __func__);
 
-	cpufreq_suspended = false;
-
 	list_for_each_entry(policy, &cpufreq_policy_list, policy_list) {
 		if (cpufreq_driver->resume && cpufreq_driver->resume(policy))
 			pr_err("%s: Failed to resume driver: %p\n", __func__,
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

