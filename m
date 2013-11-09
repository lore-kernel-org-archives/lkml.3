Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506Ab3KIHky (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:40:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32855 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab3KIGuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 12/74] mac80211: use sta_info_get_bss() for nl80211 tx and client probing
Date: Fri,  8 Nov 2013 22:51:17 -0800
Message-Id: <20131109065114.411501357@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 03bb7f42765ce596604f03d179f3137d7df05bba upstream.

This allows calls for clients in AP_VLANs (e.g. for 4-addr) to succeed

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c |    2 +-
 net/mac80211/tx.c  |    3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3315,7 +3315,7 @@ static int ieee80211_probe_client(struct
 		return -EINVAL;
 	}
 	band = chanctx_conf->def.chan->band;
-	sta = sta_info_get(sdata, peer);
+	sta = sta_info_get_bss(sdata, peer);
 	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
 	} else {
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1100,7 +1100,8 @@ ieee80211_tx_prepare(struct ieee80211_su
 		tx->sta = rcu_dereference(sdata->u.vlan.sta);
 		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
 			return TX_DROP;
-	} else if (info->flags & IEEE80211_TX_CTL_INJECTED ||
+	} else if (info->flags & (IEEE80211_TX_CTL_INJECTED |
+				  IEEE80211_TX_INTFL_NL80211_FRAME_TX) ||
 		   tx->sdata->control_port_protocol == tx->skb->protocol) {
 		tx->sta = sta_info_get_bss(sdata, hdr->addr1);
 	}


