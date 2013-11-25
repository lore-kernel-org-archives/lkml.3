Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab3KYNa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:30:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56957 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3KYNHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:07:17 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 04/78] mac80211: use sta_info_get_bss() for nl80211 tx and client probing
Date: Mon, 25 Nov 2013 13:05:51 +0000
Message-Id: <1385384825-21681-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 03bb7f42765ce596604f03d179f3137d7df05bba upstream.

This allows calls for clients in AP_VLANs (e.g. for 4-addr) to succeed

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/cfg.c | 1 +
 net/mac80211/tx.c  | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0042e61..a461c10 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2847,6 +2847,7 @@ static int ieee80211_probe_client(struct wiphy *wiphy, struct net_device *dev,
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, peer);
+	sta = sta_info_get_bss(sdata, peer);
 	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
 		rcu_read_unlock();
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d417c48..83755a5 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1156,7 +1156,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
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
1.8.3.2

