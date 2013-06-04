Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab3FDQ66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:58:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48282 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab3FDQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 16/75] cfg80211: fix wiphy_register error path
Date: Tue,  4 Jun 2013 09:55:00 -0700
Message-Id: <1370364959-9475-17-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 03cd7e4e1ea16cd151c799a33b5ca1fd41a464df upstream.

If rfkill_register() fails in wiphy_register() the struct device
is unregistered but everything else isn't (regulatory, debugfs)
and we even leave the wiphy instance on all internal lists even
though it will likely be freed soon, which is clearly a problem.
Fix this by cleaning up properly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/wireless/core.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index b677eab..2dca5e3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -597,17 +597,21 @@ int wiphy_register(struct wiphy *wiphy)
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
1.8.1.2

