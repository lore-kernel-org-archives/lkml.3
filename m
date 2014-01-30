Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaA3XJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 18:09:50 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:44879 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbaA3XJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 18:09:48 -0500
From: Zoran Markovic <zoran.markovic@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        Zoran Markovic <zoran.markovic@linaro.org>
Subject: [RFC PATCH] net: wireless: move regulatory timeout work to power efficient workqueue
Date: Thu, 30 Jan 2014 15:08:30 -0800
Message-Id: <1391123310-6425-1-git-send-email-zoran.markovic@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaibal Dutta <shaibal.dutta@broadcom.com>

For better use of CPU idle time, allow the scheduler to select the CPU
on which the timeout work of regulatory settings would be executed.
This extends CPU idle residency time and saves power.

This functionality is enabled when CONFIG_WQ_POWER_EFFICIENT is selected.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Shaibal Dutta <shaibal.dutta@broadcom.com>
[zoran.markovic@linaro.org: Rebased to latest kernel. Added commit message.]
Signed-off-by: Zoran Markovic <zoran.markovic@linaro.org>
---
 net/wireless/reg.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9b897fc..6e21011 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1703,7 +1703,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 		if (treatment == REG_REQ_OK ||
 		    treatment == REG_REQ_ALREADY_SET)
 			return;
-		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
+		queue_delayed_work(system_power_efficient_wq,
+				   &reg_timeout, msecs_to_jiffies(3142));
 		return;
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		treatment = reg_process_hint_driver(wiphy, reg_request);
@@ -2294,7 +2295,8 @@ static int reg_set_rd_driver(const struct ieee80211_regdomain *rd,
 
 	request_wiphy = wiphy_idx_to_wiphy(driver_request->wiphy_idx);
 	if (!request_wiphy) {
-		schedule_delayed_work(&reg_timeout, 0);
+		queue_delayed_work(system_power_efficient_wq,
+				   &reg_timeout, 0);
 		return -ENODEV;
 	}
 
@@ -2354,7 +2356,8 @@ static int reg_set_rd_country_ie(const struct ieee80211_regdomain *rd,
 
 	request_wiphy = wiphy_idx_to_wiphy(country_ie_request->wiphy_idx);
 	if (!request_wiphy) {
-		schedule_delayed_work(&reg_timeout, 0);
+		queue_delayed_work(system_power_efficient_wq,
+				   &reg_timeout, 0);
 		return -ENODEV;
 	}
 
-- 
1.7.9.5

