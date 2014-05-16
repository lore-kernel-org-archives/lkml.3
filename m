Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbaEPIOR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 04:14:17 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38337 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbaEPIOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 04:14:12 -0400
From: Chander Kashyap <chander.kashyap@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: nm@ti.com, rjw@rjwysocki.net, pavel@ucw.cz, len.brown@intel.com,
        gregkh@linuxfoundation.org, viresh.kumar@linaro.org,
        Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: [PATCH v2] PM / OPP: discard duplicate OPP additions
Date: Fri, 16 May 2014 13:43:48 +0530
Message-Id: <1400228028-30165-1-git-send-email-chander.kashyap@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <CAKohpom1t2sOWr_S5Xzhx_OG=2qmgkZ5Z6UJ4TKAmJgeq0TU2Q@mail.gmail.com>
References: <CAKohpom1t2sOWr_S5Xzhx_OG=2qmgkZ5Z6UJ4TKAmJgeq0TU2Q@mail.gmail.com>
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
 Changes in v2:
	- Reorder check for duplicate opp

 drivers/base/power/opp.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index ca521e1..973da78 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -443,15 +443,24 @@ int dev_pm_opp_add(struct device *dev, unsigned long freq, unsigned long u_volt)
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
 
+	if (new_opp->rate == opp->rate) {
+		mutex_unlock(&dev_opp_list_lock);
+		kfree(new_opp);
+		return 0;
+	}
+
 	list_add_rcu(&new_opp->node, head);
 	mutex_unlock(&dev_opp_list_lock);
 
-- 
1.7.9.5

