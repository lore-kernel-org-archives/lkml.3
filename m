Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3GCSku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:40:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14341 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3GCSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:46 -0400
X-Authority-Analysis: v=2.0 cv=Tr1kdUrh c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=sSCaOzI_Le4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=3R_BB7P3zdsA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184045.121645714@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [003/141] cfg80211: fix wiphy_register error path
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0003-cfg80211-fix-wiphy_register-error-path.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 03cd7e4e1ea16cd151c799a33b5ca1fd41a464df ]

If rfkill_register() fails in wiphy_register() the struct device
is unregistered but everything else isn't (regulatory, debugfs)
and we even leave the wiphy instance on all internal lists even
though it will likely be freed soon, which is clearly a problem.
Fix this by cleaning up properly.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/wireless/core.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5797032..a10901b 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -572,17 +572,21 @@ int wiphy_register(struct wiphy *wiphy)
 	 * cfg80211_mutex lock
 	 */
 	res = rfkill_register(rdev->rfkill);
-	if (res)
-		goto out_rm_dev;
+	if (res) {
+		device_del(&rdev->wiphy.dev);
+
+		mutex_lock(&cfg80211_mutex);
+		debugfs_remove_recursive(rdev->wiphy.debugfsdir);
+		list_del_rcu(&rdev->list);
+		wiphy_regulatory_deregister(wiphy);
+		mutex_unlock(&cfg80211_mutex);
+		return res;
+	}
 
 	rtnl_lock();
 	rdev->wiphy.registered = true;
 	rtnl_unlock();
 	return 0;
-
-out_rm_dev:
-	device_del(&rdev->wiphy.dev);
-	return res;
 }
 EXPORT_SYMBOL(wiphy_register);
 
-- 
1.7.10.4


