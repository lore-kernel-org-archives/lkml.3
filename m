Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab3KZXUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:20:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:19201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757592Ab3KZXUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:20:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,778,1378882800"; 
   d="scan'208";a="434758882"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 2/3] cpuidle: check for pm qos constraint override
Date: Tue, 26 Nov 2013 15:20:10 -0800
Message-Id: <1385508011-26914-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a QOS class is disabled due to platform thermal or power capping
needs, idle governor shall pick the deepest idle state to conserve power.

Power saving should be prioritized over QOS in this case in that
hardware based catastrophic measure is more intrusive than
managed idle.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 drivers/cpuidle/governors/ladder.c |  4 ++++
 drivers/cpuidle/governors/menu.c   | 13 +++++++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/cpuidle/governors/ladder.c b/drivers/cpuidle/governors/ladder.c
index 9f08e8c..40161d3 100644
--- a/drivers/cpuidle/governors/ladder.c
+++ b/drivers/cpuidle/governors/ladder.c
@@ -71,6 +71,10 @@ static int ladder_select_state(struct cpuidle_driver *drv,
 	int last_residency, last_idx = ldev->last_state_idx;
 	int latency_req = pm_qos_request(PM_QOS_CPU_DMA_LATENCY);
 
+	/* qos ignored, pick the deepest idle state */
+	if (unlikely(latency_req == PM_QOS_DEFAULT_VALUE))
+		return drv->state_count - 1;
+
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0)) {
 		ladder_do_selection(ldev, last_idx, 0);
diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index cf7f2f0..afa0088 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -297,12 +297,21 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		data->needs_update = 0;
 	}
 
+	/* qos ignored, pick the deepest idle state */
+	if (unlikely(latency_req == PM_QOS_DEFAULT_VALUE)) {
+		struct cpuidle_state *s = &drv->states[drv->state_count - 1];
+
+		data->last_state_idx = drv->state_count - 1;
+		data->exit_us = s->exit_latency;
+		goto exit_done;
+	}
+
 	data->last_state_idx = 0;
 	data->exit_us = 0;
 
 	/* Special case when user has set very strict latency requirement */
 	if (unlikely(latency_req == 0))
-		return 0;
+		goto exit_done;
 
 	/* determine the expected residency time, round up */
 	t = ktime_to_timespec(tick_nohz_get_sleep_length());
@@ -361,7 +370,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
 		data->last_state_idx = i;
 		data->exit_us = s->exit_latency;
 	}
-
+exit_done:
 	return data->last_state_idx;
 }
 
-- 
1.8.1.2

