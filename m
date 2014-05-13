Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853AbaEMHlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 03:41:47 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:42252 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaEMHlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 03:41:46 -0400
X-Google-Original-From: "[Chander Kashyap" <k.chander@samsung.com>
From: "[Chander Kashyap" <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: [PATCH] PM / OPP: discard duplicate OPP additions
Date: Tue, 13 May 2014 13:11:30 +0530
Message-Id: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chander Kashyap <k.chander@samsung.com>

It may be possible to unregister and re-register the cpufreq driver.
One such example is arm big-little IKS cpufreq driver. While
re-registering the driver, same OPPs may get added again.

This patch detects the duplicacy and discards them.

Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
---
 drivers/base/power/opp.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..2e803a9 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -443,23 +443,33 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 	new_opp->u_volt = u_volt;
 	new_opp->available = true;
 
-	/* Insert new OPP in order of increasing frequency */
+	/*
+	 * Insert new OPP in order of increasing frequency
+	 * and discard if already present
+	 */
 	head = &dev_opp->opp_list;
 	list_for_each_entry_rcu(opp, &dev_opp->opp_list, node) {
-		if (new_opp->rate < opp->rate)
+		if (new_opp->rate <= opp->rate)
 			break;
 		else
 			head = &opp->node;
 	}
 
-	list_add_rcu(&new_opp->node, head);
-	mutex_unlock(&dev_opp_list_lock);
+	if (new_opp->rate != opp->rate) {
+		list_add_rcu(&new_opp->node, head);
+		mutex_unlock(&dev_opp_list_lock);
+
+		/*
+		 * Notify the changes in the availability of the operable
+		 * frequency/voltage list.
+		 */
+		srcu_notifier_call_chain(&dev_opp->head,
+						OPP_EVENT_ADD, new_opp);
+	} else {
+		mutex_unlock(&dev_opp_list_lock);
+		kfree(new_opp);
+	}
 
-	/*
-	 * Notify the changes in the availability of the operable
-	 * frequency/voltage list.
-	 */
-	srcu_notifier_call_chain(&dev_opp->head, OPP_EVENT_ADD, new_opp);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_add);
-- 
1.7.9.5

