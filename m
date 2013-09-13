Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab3IMND3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:03:29 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32945 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756781Ab3IMNDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:03:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 003/228] cpufreq: remove __cpufreq_remove_dev()
Date: Fri, 13 Sep 2013 18:29:09 +0530
Message-Id: <9efdaeff9bbdd0f9df3b0edd7b274535708de3dd.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody except cpufreq_remove_dev() is calling __cpufreq_remove_dev() and so we
don't need separate routines here. Lets merge code from __cpufreq_remove_dev()
to cpufreq_remove_dev() and get rid of __cpufreq_remove_dev().

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 6a8cae9..e217d8f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1343,36 +1343,26 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 }
 
 /**
- * __cpufreq_remove_dev - remove a CPU device
+ * cpufreq_remove_dev - remove a CPU device
  *
  * Removes the cpufreq interface for a CPU device.
  * Caller should already have policy_rwsem in write mode for this CPU.
  * This routine frees the rwsem before returning.
  */
-static inline int __cpufreq_remove_dev(struct device *dev,
-				       struct subsys_interface *sif,
-				       bool frozen)
-{
-	int ret;
-
-	ret = __cpufreq_remove_dev_prepare(dev, sif, frozen);
-
-	if (!ret)
-		ret = __cpufreq_remove_dev_finish(dev, sif, frozen);
-
-	return ret;
-}
-
 static int cpufreq_remove_dev(struct device *dev, struct subsys_interface *sif)
 {
 	unsigned int cpu = dev->id;
-	int retval;
+	int ret;
 
 	if (cpu_is_offline(cpu))
 		return 0;
 
-	retval = __cpufreq_remove_dev(dev, sif, false);
-	return retval;
+	ret = __cpufreq_remove_dev_prepare(dev, sif, false);
+
+	if (!ret)
+		ret = __cpufreq_remove_dev_finish(dev, sif, false);
+
+	return ret;
 }
 
 static void handle_update(struct work_struct *work)
-- 
1.7.12.rc2.18.g61b472e

