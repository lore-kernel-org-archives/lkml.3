Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab3IMNAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:00:07 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:56463 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704Ab3IMNAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:00:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/2] cpufreq: powernow-k8: mark freq transition complete on error cases
Date: Fri, 13 Sep 2013 18:29:39 +0530
Message-Id: <68dc892ac44a619e3bb8a69ec8314c59f19c514a.1379062834.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379062834.git.viresh.kumar@linaro.org>
References: <cover.1379062834.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379062834.git.viresh.kumar@linaro.org>
References: <cover.1379062834.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch "cpufreq: make sure frequency transitions are serialized"
guarantees that we don't have any races while changing cpu frequency or sending
notifications. It handled a special case with CPUFREQ_ASYNC_NOTIFICATION flag
for drivers that don't complete their freq change from ->target() and exynos5440
driver is well adopted to it as well..

There is one more driver powernow-k8 that has similar implementation, schedules
a work for doing transitions. All is good if that work function does
notifications on every call to it and so the transition_ongoing count stays
stable. But there are chances that the work function may return without actually
doing the notifications, in which case transition_ongoing count will not be set
to zero and so no transitions would be possible after that.

This patch fixes powernow-k8 driver to get transition_ongoing count stable. It
does following to ensure proper working of this driver:
- return -EINPROGRESS from ->target() so that core doesn't mark transfer over at
  the end of ->target().
- mark cpufreq_driver->flags with CPUFREQ_ASYNC_NOTIFICATION, so that core knows
  that driver would terminate its transition.
- call cpufreq_transition_complete() whenever we are returning before sending
  notifications

Hopefully things will work well after this patch, only compiled tested at my
end.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/powernow-k8.c | 47 +++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index 2344a9e..8215bbc 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -952,7 +952,7 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data,
 	if ((data->currvid == vid) && (data->currfid == fid)) {
 		pr_debug("target matches current values (fid 0x%x, vid 0x%x)\n",
 			fid, vid);
-		return 0;
+		return -EALREADY;
 	}
 
 	pr_debug("cpu %d, changing to fid 0x%x, vid 0x%x\n",
@@ -993,22 +993,27 @@ static long powernowk8_target_fn(void *arg)
 	unsigned int newstate;
 	int ret;
 
-	if (!data)
-		return -EINVAL;
+	if (!data) {
+		ret = -EINVAL;
+		goto transition_complete;
+	}
 
 	checkfid = data->currfid;
 	checkvid = data->currvid;
 
 	if (pending_bit_stuck()) {
 		printk(KERN_ERR PFX "failing targ, change pending bit set\n");
-		return -EIO;
+		ret = -EIO;
+		goto transition_complete;
 	}
 
 	pr_debug("targ: cpu %d, %d kHz, min %d, max %d, relation %d\n",
 		pol->cpu, targfreq, pol->min, pol->max, relation);
 
-	if (query_current_values_with_pending_wait(data))
-		return -EIO;
+	if (query_current_values_with_pending_wait(data)) {
+		ret = -EIO;
+		goto transition_complete;
+	}
 
 	pr_debug("targ: curr fid 0x%x, vid 0x%x\n",
 		 data->currfid, data->currvid);
@@ -1022,25 +1027,36 @@ static long powernowk8_target_fn(void *arg)
 	}
 
 	if (cpufreq_frequency_table_target(pol, data->powernow_table,
-				targfreq, relation, &newstate))
-		return -EIO;
+				targfreq, relation, &newstate)) {
+		ret = -EIO;
+		goto transition_complete;
+	}
 
 	mutex_lock(&fidvid_mutex);
 
 	powernow_k8_acpi_pst_values(data, newstate);
 
 	ret = transition_frequency_fidvid(data, newstate);
+	mutex_unlock(&fidvid_mutex);
 
 	if (ret) {
-		printk(KERN_ERR PFX "transition frequency failed\n");
-		mutex_unlock(&fidvid_mutex);
-		return 1;
+		/* Not a error case, just need to mark transition complete */
+		if (ret == -EALREADY) {
+			ret = 0;
+		} else {
+			printk(KERN_ERR PFX "transition frequency failed\n");
+			ret = 1;
+		}
+		goto transition_complete;
 	}
-	mutex_unlock(&fidvid_mutex);
 
 	pol->cur = find_khz_freq_from_fid(data->currfid);
 
 	return 0;
+
+transition_complete:
+	cpufreq_transition_complete(pol);
+	return ret;
 }
 
 /* Driver entry point to switch to the target frequency */
@@ -1049,8 +1065,12 @@ static int powernowk8_target(struct cpufreq_policy *pol,
 {
 	struct powernowk8_target_arg pta = { .pol = pol, .targfreq = targfreq,
 					     .relation = relation };
+	int ret;
 
-	return work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
+	ret = work_on_cpu(pol->cpu, powernowk8_target_fn, &pta);
+	if (!ret)
+		ret = -EINPROGRESS;	/* Mark transition as In-progress */
+	return ret;
 }
 
 /* Driver entry point to verify the policy and range of frequencies */
@@ -1233,6 +1253,7 @@ static struct freq_attr *powernow_k8_attr[] = {
 };
 
 static struct cpufreq_driver cpufreq_amd64_driver = {
+	.flags		= CPUFREQ_ASYNC_NOTIFICATION,
 	.verify		= powernowk8_verify,
 	.target		= powernowk8_target,
 	.bios_limit	= acpi_processor_get_bios_limit,
-- 
1.7.12.rc2.18.g61b472e

