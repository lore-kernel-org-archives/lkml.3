Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbaCCTAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 14:00:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbaCCTAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 14:00:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 40/67] mac80211: release the channel in error path in start_ap
Date: Mon,  3 Mar 2014 10:55:28 -0800
Message-Id: <1393872955-28810-41-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 0297ea17bf7879fb5846fafd1be4c0471e72848d upstream.

When the driver cannot start the AP or when the assignement
of the beacon goes wrong, we need to unassign the vif.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/cfg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 795aea6..f2a171a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -954,8 +954,10 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	sdata->vif.bss_conf.p2p_oppps = params->p2p_opp_ps;
 
 	err = ieee80211_assign_beacon(sdata, &params->beacon);
-	if (err < 0)
+	if (err < 0) {
+		ieee80211_vif_release_channel(sdata);
 		return err;
+	}
 	changed |= err;
 
 	err = drv_start_ap(sdata->local, sdata);
@@ -964,6 +966,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
 		if (old)
 			kfree_rcu(old, rcu_head);
 		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+		ieee80211_vif_release_channel(sdata);
 		return err;
 	}
 
-- 
1.8.3.2

