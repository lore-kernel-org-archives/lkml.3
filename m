Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab3HMHKZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 03:10:25 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:44652 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751858Ab3HMHKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 03:10:23 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: <cpufreq@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <viresh.kumar@linaro.org>, <rjw@sisk.pl>, <chenxg.marvell@gmail.com>,
        <chenxg@marvell.com>
Subject: [PATCH 1/2] cpufreq: Add governor operation ongoing flag
Date: Tue, 13 Aug 2013 15:09:25 +0800
Message-ID: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_governor operation needs to be executed one by one.
If one operation is ongoing, the other operation can't be executed.
If the order is not guaranteed, there may be unexpected behavior.

 For example, governor is in enable state, and one process
tries to stop the goveror, but it is scheduled out before policy->
governor->governor() is executed, but the governor enable flag is
set to false already. Then one other process tries to start governor,
It finds enable flag is false, and it can process down to do governor
start operation, So the governor is started twice.

Add the governor_ops_ongoing flag to check whether there is governor
operation ongoing, if so, return -EAGAIN.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/cpufreq/cpufreq.c | 9 +++++++++
 include/linux/cpufreq.h   | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f0a5e2b..dfe0b86 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1652,6 +1652,11 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 		mutex_unlock(&cpufreq_governor_lock);
 		return -EBUSY;
 	}
+	if (policy->governor_ops_ongoing) {
+		mutex_unlock(&cpufreq_governor_lock);
+		return -EAGAIN;
+	}
+	policy->governor_ops_ongoing = true;
 
 	if (event == CPUFREQ_GOV_STOP)
 		policy->governor_enabled = false;
@@ -1684,6 +1689,10 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 	if ((event == CPUFREQ_GOV_STOP) && !ret)
 		module_put(policy->governor->owner);
 
+	mutex_lock(&cpufreq_governor_lock);
+	policy->governor_ops_ongoing = false;
+	mutex_unlock(&cpufreq_governor_lock);
+
 	return ret;
 }
 
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 90d5a15..8d3eac2 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -111,6 +111,7 @@ struct cpufreq_policy {
 	struct cpufreq_governor	*governor; /* see below */
 	void			*governor_data;
 	bool			governor_enabled; /* governor start/stop flag */
+	bool			governor_ops_ongoing;
 
 	struct work_struct	update; /* if update_policy() needs to be
 					 * called, but you're in IRQ context */
-- 
1.8.0

