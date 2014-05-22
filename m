Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589AbaEVFGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:06:37 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:60398 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaEVFGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:06:36 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Chander Kashyap <k.chander@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V6] PM/OPP: discard duplicate OPPs
Date: Thu, 22 May 2014 10:36:26 +0530
Message-Id: <087f56979fa572b3021f0fb9b2ad1bc791b55f66.1400734949.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chander Kashyap <k.chander@samsung.com>

We don't have any protection against addition of duplicate OPPs currently and in
case some code tries to add them, it will end up corrupting OPP tables.

We need to handle some duplication cases separately as returning error might not
be the right thing always. The new list of return values for dev_pm_opp_add()
are:

0:          On success OR
            Duplicate OPPs (both freq and volt are same) and opp->available
-EEXIST:    Freq are same and volt are different OR
            Duplicate OPPs (both freq and volt are same) and !opp->available
-ENOMEM:    Memory allocation failure

Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Chander Kashyap <k.chander@samsung.com>
Signed-off-by: Inderpal Singh <inderpal.s@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
I took some rest before sending V6, just to make sure I don't send another
version in hurry with any obvious mistake.

V5->V6:
- Remove parenthesis around initialization of 'ret'.
- s/Returns/Return
- Fix checkpatch.pl --strict warning: 'Alignment should match open parenthesis'
- Tried improving changelog..

 drivers/base/power/opp.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index faae9cf..89ced95 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -393,6 +393,13 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_find_freq_floor);
  * to keep the integrity of the internal data structures. Callers should ensure
  * that this function is *NOT* called under RCU protection or in contexts where
  * mutex cannot be locked.
+ *
+ * Return:
+ * 0:		On success OR
+ *		Duplicate OPPs (both freq and volt are same) and opp->available
+ * -EEXIST:	Freq are same and volt are different OR
+ *		Duplicate OPPs (both freq and volt are same) and !opp->available
+ * -ENOMEM:	Memory allocation failure
  */
 int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
 {
@@ -442,15 +449,31 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
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
+		int ret = opp->available && new_opp->u_volt == opp->u_volt ?
+			0 : -EEXIST;
+
+		dev_warn(dev, "%s: duplicate OPPs detected. Existing: freq: %lu, volt: %lu, enabled: %d. New: freq: %lu, volt: %lu, enabled: %d\n",
+			 __func__, opp->rate, opp->u_volt, opp->available,
+			 new_opp->rate, new_opp->u_volt, new_opp->available);
+		mutex_unlock(&dev_opp_list_lock);
+		kfree(new_opp);
+		return ret;
+	}
+
 	list_add_rcu(&new_opp->node, head);
 	mutex_unlock(&dev_opp_list_lock);
 
-- 
2.0.0.rc2

