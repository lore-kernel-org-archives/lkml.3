Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab3KHCU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:20:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34774 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756782Ab3KHCUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:20:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 43/91] mac80211: use sta_info_get_bss() for nl80211 tx and client probing
Date: Thu,  7 Nov 2013 18:14:58 -0800
Message-Id: <1383876946-2396-44-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 03bb7f42765ce596604f03d179f3137d7df05bba upstream.

This allows calls for clients in AP_VLANs (e.g. for 4-addr) to succeed

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/cfg.c | 2 +-
 net/mac80211/tx.c  | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 40732e3..a1df92b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3113,7 +3113,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 		return -EINVAL;
 	}
 	band = chanctx_conf->def.chan->band;
-	sta = sta_info_get(sdata, peer);
+	sta = sta_info_get_bss(sdata, peer);
 	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
 	} else {
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 467c1d1..6b976b7 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1149,7 +1149,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+	} else if (info->flags & (IEEE80211_TX_CTL_INJECTED |
+				  IEEE80211_TX_INTFL_NL80211_FRAME_TX) ||
 		   tx->sdata->control_port_protocol == tx->skb->protocol) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}
-- 
1.8.1.2

