Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaETORY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 10:17:24 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:64546 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaETORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 10:17:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com,
        Chander Kashyap <k.chander@samsung.com>,
        Viresh Kumar <viresh.kumar@linrao.org>
Subject: [PATCH V4] PM/OPP: discard duplicate OPPs
Date: Tue, 20 May 2014 19:47:05 +0530
Message-Id: <d0200ee9e30de19f69ca1b7e53a8cd7a047fa436.1400595283.git.viresh.kumar@linaro.org>
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
Signed-off-by: Viresh Kumar <viresh.kumar@linrao.org>
---
V3->V4:
- handle duplicate OPPs more appropriately
- update comment over routine and enhance commit log

@Chander: I have kept your authorship as is, hope you don't mind me sending it
on your behalf :)

 drivers/base/power/opp.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..cd9af42 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -389,6 +389,11 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
  * The opp is made available by default and it can be controlled using
  * dev_pm_opp_enable/disable functions.
  *
+ * Duplicate OPPs are discarded. Will return 0 if new OPP was duplicate of
+ * existing one (i.e. same freq and volt) and -EEXIST would be returned if new
+ * OPP had same freq but different volt as of an existing OPP OR if both were
+ * same but earlier OPP was disabled.
+ *
  * Locking: The internal device_opp and opp structures are RCU protected.
  * Hence this function internally uses RCU updater strategy with mutex locks
  * to keep the integrity of the internal data structures. Callers should ensure
@@ -443,15 +448,31 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
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
+		pr_warn("%s: duplicate OPPs detected. Existing: freq: %lu, volt: %lu, enabled: %d. New: freq: %lu, volt: %lu, enabled: %d\n",
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

