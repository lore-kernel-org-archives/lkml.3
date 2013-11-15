Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3KOGBv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 01:01:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:17510 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472Ab3KOGBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 01:01:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,704,1378882800"; 
   d="scan'208";a="428053601"
From: Lan Tianyu <tianyu.lan@intel.com>
To: rjw@rjwysocki.net, viresh.kumar@linaro.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] Cpufreq: Make governor data on nonboot cpus across system syspend/resume
Date: Fri, 15 Nov 2013 14:01:34 +0800
Message-Id: <1384495294-10565-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, governor of nonboot cpus will be put to EXIT when system syspend.
Since all these cpus will be unplugged and the governor usage_count decreases
to zero. The governor data and its sysfs interfaces will be freed or released.
This makes user config of these governors loss during suspend and resume.

This doesn't happen on the governor covering boot cpu because it isn't
unplugged during system suspend.

To fix this issue, skipping governor exit during system suspend and check
policy governor data to determine whether the governor is really needed
to be initialized when do init. If not, return EALREADY to indicate the
governor has been initialized and should do nothing. __cpufreq_governor()
convert EALREADY to 0 as return value for INIT event since governor is
still under INIT state and can do START operation.

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/cpufreq/cpufreq.c          |  5 ++++-
 drivers/cpufreq/cpufreq_governor.c | 13 ++++++++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 02d534d..38f2e4a 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1239,7 +1239,7 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 
 	/* If cpu is last user of policy, free policy */
 	if (cpus == 1) {
-		if (has_target()) {
+		if (has_target() && !frozen) {
 			ret = __cpufreq_governor(policy,
 					CPUFREQ_GOV_POLICY_EXIT);
 			if (ret) {
@@ -1822,6 +1822,9 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 			((event == CPUFREQ_GOV_POLICY_EXIT) && !ret))
 		module_put(policy->governor->owner);
 
+	if ((event == CPUFREQ_GOV_POLICY_INIT) && ret == -EALREADY)
+		ret = 0;
+
 	return ret;
 }
 
diff --git a/drivers/cpufreq/cpufreq_governor.c b/drivers/cpufreq/cpufreq_governor.c
index 0806c31..ddb93af 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -204,9 +204,20 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 
 	switch (event) {
 	case CPUFREQ_GOV_POLICY_INIT:
+		/*
+		 * In order to keep governor data across suspend/resume,
+		 * Governor doesn't exit when suspend and will be
+		 * reinitialized when resume. Here check policy governor
+		 * data to determine whether the governor has been exited.
+		 * If not, return EALREADY.
+		 */
 		if (have_governor_per_policy()) {
-			WARN_ON(dbs_data);
+			if (dbs_data)
+				return -EALREADY;
 		} else if (dbs_data) {
+			if (policy->governor_data == dbs_data)
+				return -EALREADY;
+
 			dbs_data->usage_count++;
 			policy->governor_data = dbs_data;
 			return 0;
-- 
1.8.2.1

