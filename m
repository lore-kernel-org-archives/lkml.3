Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269AbaBUApK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:45:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362AbaBTXvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:51:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 10/82] mac80211: release the channel in error path in start_ap
Date: Thu, 20 Feb 2014 15:51:53 -0800
Message-Id: <20140220235019.795083526@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 0297ea17bf7879fb5846fafd1be4c0471e72848d upstream.

When the driver cannot start the AP or when the assignement
of the beacon goes wrong, we need to unassign the vif.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -995,8 +995,10 @@ static int ieee80211_start_ap(struct wip
 					IEEE80211_P2P_OPPPS_ENABLE_BIT;
 
 	err = ieee80211_assign_beacon(sdata, &params->beacon);
-	if (err < 0)
+	if (err < 0) {
+		ieee80211_vif_release_channel(sdata);
 		return err;
+	}
 	changed |= err;
 
 	err = drv_start_ap(sdata->local, sdata);
@@ -1005,6 +1007,7 @@ static int ieee80211_start_ap(struct wip
 		if (old)
 			kfree_rcu(old, rcu_head);
 		RCU_INIT_POINTER(sdata->u.ap.beacon, NULL);
+		ieee80211_vif_release_channel(sdata);
 		return err;
 	}
 


