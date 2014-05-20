Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaETOxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:53:43 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:39613 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753756AbaETOxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:53:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com,
        Chander Kashyap <k.chander@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5] PM/OPP: discard duplicate OPPs
Date: Tue, 20 May 2014 20:23:28 +0530
Message-Id: <7cb6e0e039e0935e37c81d0f23d26b0b81ad8cda.1400597170.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chander Kashyap <k.chander@samsung.com>

We don't have any protection against addition of duplicate OPPs currently and
in case some code tries to add them it will end up corrupting OPP tables.

There can be many combinations in which we may end up trying duplicate OPPs:
- both freq and volt are same, but earlier OPP may or may not be active.
- only freq is same and volt is different.

This patch tries to implement below logic for these cases:

Return 0 if new OPP was duplicate of existing one (i.e. same freq and volt) and
return -EEXIST if new OPP had same freq but different volt as of an existing OPP
OR if both freq/volt were same but earlier OPP was disabled.

Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V4->V5:
- Mention Return values under 'Return:' clause of doc style comment.
- s/pr_warn/dev_warn
- s/linrao/linaro in my email id :(

 drivers/base/power/opp.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..6a06d43 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -394,6 +394,13 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
  * to keep the integrity of the internal data structures. Callers should ensure
  * that this function is *NOT* called under RCU protection or in contexts where
  * mutex cannot be locked.
+ *
+ * Returns:
+ * 0:		On success OR
+ *		Duplicate OPPs (both freq and volt are same) and opp->available
+ * -EEXIST:	Freq are same and volt are different OR
+ *		Duplicate OPPs (both freq and volt are same) and !opp->available
+ * -ENOMEM:	Memory allocation failure
  */
 int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 {
@@ -443,15 +450,31 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
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
 
+	/* Duplicate OPPs ? */
+	if (new_opp->rate == opp->rate) {
+		int ret = (new_opp->u_volt == opp->u_volt) && opp->available ?
+			0 : -EEXIST;
+
+		dev_warn(dev, "%s: duplicate OPPs detected. Existing: freq: %lu, volt: %lu, enabled: %d. New: freq: %lu, volt: %lu, enabled: %d\n",
+			__func__, opp->rate, opp->u_volt, opp->available,
+			new_opp->rate, new_opp->u_volt, new_opp->available);
+		mutex_unlock(&dev_opp_list_lock);
+		kfree(new_opp);
+		return ret;
+	}
+
 	list_add_rcu(&new_opp->node, head);
 	mutex_unlock(&dev_opp_list_lock);
 
-- 
2.0.0.rc2

