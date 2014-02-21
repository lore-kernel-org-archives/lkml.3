Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933221AbaBUNgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:36:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47077 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbaBUMup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 071/121] mac80211: release the channel in error path in start_ap
Date: Fri, 21 Feb 2014 12:48:15 +0000
Message-Id: <1392986945-9693-72-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 0297ea17bf7879fb5846fafd1be4c0471e72848d upstream.

When the driver cannot start the AP or when the assignement
of the beacon goes wrong, we need to unassign the vif.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/cfg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2116285..216550e9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -989,8 +989,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 					IEEE80211_P2P_OPPPS_ENABLE_BIT;
 
 	err = ieee80211_assign_beacon(sdata, &params->beacon);
-	if (err < 0)
+	if (err < 0) {
+		ieee80211_vif_release_channel(sdata);
 		return err;
+	}
 	changed |= err;
 
 	err = drv_start_ap(sdata->local, sdata);
@@ -999,6 +1001,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		if (old)
 			kfree_rcu(old, rcu_head);
 		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+		ieee80211_vif_release_channel(sdata);
 		return err;
 	}
 
-- 
1.9.0

