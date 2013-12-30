Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab3L3RTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:19:25 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:37279 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756206Ab3L3RTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:19:06 -0500
X-IronPort-AV: E=Sophos;i="4.95,574,1384297200"; 
   d="scan'208";a="51019970"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Johannes Berg <johannes.berg@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/11]  use ether_addr_equal_64bits
Date: Mon, 30 Dec 2013 19:15:00 +0100
Message-Id: <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Ether_addr_equal_64bits is more efficient than ether_addr_equal, and can be
used when each argument is an array within a structure that contains at
least two bytes of data beyond the array.

The structures involved are:
iwl_rxon_cmd defined in drivers/net/wireless/iwlwifi/dvm/commands.h and
ieee80211_hdr defined in include/linux/ieee80211.h

This was done using Coccinelle (http://coccinelle.lip6.fr/).

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch used is rather long and can be found in message 0 of
this patch series.

 drivers/net/wireless/iwlwifi/dvm/rx.c   |    4 ++--
 drivers/net/wireless/iwlwifi/dvm/rxon.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rxon.c b/drivers/net/wireless/iwlwifi/dvm/rxon.c
index d7ce2f1..0439dd5 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -875,10 +875,10 @@ static int iwl_full_rxon_required(struct iwl_priv *priv,
 
 	/* These items are only settable from the full RXON command */
 	CHK(!iwl_is_associated_ctx(ctx));
-	CHK(!ether_addr_equal(staging->bssid_addr, active->bssid_addr));
-	CHK(!ether_addr_equal(staging->node_addr, active->node_addr));
-	CHK(!ether_addr_equal(staging->wlap_bssid_addr,
-			      active->wlap_bssid_addr));
+	CHK(!ether_addr_equal_64bits(staging->bssid_addr, active->bssid_addr));
+	CHK(!ether_addr_equal_64bits(staging->node_addr, active->node_addr));
+	CHK(!ether_addr_equal_64bits(staging->wlap_bssid_addr,
+				     active->wlap_bssid_addr));
 	CHK_NEQ(staging->dev_type, active->dev_type);
 	CHK_NEQ(staging->channel, active->channel);
 	CHK_NEQ(staging->air_propagation, active->air_propagation);
diff --git a/drivers/net/wireless/iwlwifi/dvm/rx.c b/drivers/net/wireless/iwlwifi/dvm/rx.c
index d71776d..d18570b 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rx.c
@@ -780,8 +780,8 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 	*/
 	if (unlikely(ieee80211_is_beacon(fc) && priv->passive_no_rx)) {
 		for_each_context(priv, ctx) {
-			if (!ether_addr_equal(hdr->addr3,
-					      ctx->active.bssid_addr))
+			if (!ether_addr_equal_64bits(hdr->addr3,
+						     ctx->active.bssid_addr))
 				continue;
 			iwlagn_lift_passive_no_rx(priv);
 		}
