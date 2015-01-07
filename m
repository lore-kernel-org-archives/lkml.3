Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbbAGC4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:56:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953AbbAGBwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.18 48/84] mac80211: copy chandef from AP vif to VLANs
Date: Tue,  6 Jan 2015 17:49:51 -0800
Message-Id: <20150107014030.570539893@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 2967e031d4d737d9cc8252d878a17924d7b704f0 upstream.

Instead of keeping track of all those special cases where
VLAN interfaces have no bss_conf.chandef, just make sure
they have the same as the AP interface they belong to.

Among others, this fixes a crash getting a VLAN's channel
from userspace since a NULL channel is returned as a good
result (return value 0) for VLANs since the commit below.

Fixes: c12bc4885f4b3 ("mac80211: return the vif's chandef in ieee80211_cfg_get_channel()")
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
[rewrite commit log]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/chan.c  |   23 +++++++++++++++++++----
 net/mac80211/iface.c |    1 +
 2 files changed, 20 insertions(+), 4 deletions(-)

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -929,6 +929,21 @@ ieee80211_vif_chanctx_reservation_comple
 	}
 }
 
+static void
+ieee80211_vif_update_chandef(struct ieee80211_sub_if_data *sdata,
+			     const struct cfg80211_chan_def *chandef)
+{
+	struct ieee80211_sub_if_data *vlan;
+
+	sdata->vif.bss_conf.chandef = *chandef;
+
+	if (sdata->vif.type != NL80211_IFTYPE_AP)
+		return;
+
+	list_for_each_entry(vlan, &sdata->u.ap.vlans, u.vlan.list)
+		vlan->vif.bss_conf.chandef = *chandef;
+}
+
 static int
 ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 {
@@ -991,7 +1006,7 @@ ieee80211_vif_use_reserved_reassign(stru
 	if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
 		changed = BSS_CHANGED_BANDWIDTH;
 
-	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+	ieee80211_vif_update_chandef(sdata, &sdata->reserved_chandef);
 
 	if (changed)
 		ieee80211_bss_info_change_notify(sdata, changed);
@@ -1333,7 +1348,7 @@ static int ieee80211_vif_use_reserved_sw
 			    sdata->reserved_chandef.width)
 				changed = BSS_CHANGED_BANDWIDTH;
 
-			sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
+			ieee80211_vif_update_chandef(sdata, &sdata->reserved_chandef);
 			if (changed)
 				ieee80211_bss_info_change_notify(sdata,
 								 changed);
@@ -1504,7 +1519,7 @@ int ieee80211_vif_use_channel(struct iee
 		goto out;
 	}
 
-	sdata->vif.bss_conf.chandef = *chandef;
+	ieee80211_vif_update_chandef(sdata, chandef);
 
 	ret = ieee80211_assign_vif_chanctx(sdata, ctx);
 	if (ret) {
@@ -1646,7 +1661,7 @@ int ieee80211_vif_change_bandwidth(struc
 		break;
 	}
 
-	sdata->vif.bss_conf.chandef = *chandef;
+	ieee80211_vif_update_chandef(sdata, chandef);
 
 	ieee80211_recalc_chanctx_chantype(local, ctx);
 
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -511,6 +511,7 @@ int ieee80211_do_open(struct wireless_de
 		sdata->vif.cab_queue = master->vif.cab_queue;
 		memcpy(sdata->vif.hw_queue, master->vif.hw_queue,
 		       sizeof(sdata->vif.hw_queue));
+		sdata->vif.bss_conf.chandef = master->vif.bss_conf.chandef;
 		break;
 		}
 	case NL80211_IFTYPE_AP:


