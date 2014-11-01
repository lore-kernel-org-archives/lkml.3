Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308AbaKAXBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:01:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60002 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.666383181@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 014/102] Revert "iwlwifi: dvm: don't enable CTS to self"
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit f47f46d7b09cf1d09e4b44b6cc4dd7d68a08028c upstream.

This reverts commit 43d826ca5979927131685cc2092c7ce862cb91cd.

This commit caused packet loss.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[bwh: Backported to 3.2:
 - Adjust filename
 - Condition for RXON_FLG_SELF_CTS_EN in iwlagn_commit_rxon() was different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c | 13 -------------
 1 file changed, 13 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -440,6 +440,14 @@ int iwlagn_commit_rxon(struct iwl_priv *
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
+	/*
+	 * force CTS-to-self frames protection if RTS-CTS is not preferred
+	 * one aggregation protection method
+	 */
+	if (!(priv->cfg->ht_params &&
+	      priv->cfg->ht_params->use_rts_for_aggregation))
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
@@ -872,6 +880,11 @@ void iwlagn_bss_info_changed(struct ieee
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 
+	if (bss_conf->use_cts_prot)
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+	else
+		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
+
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
 	if (vif->type == NL80211_IFTYPE_AP ||

