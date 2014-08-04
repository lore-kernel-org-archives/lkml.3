Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaHDQuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:50:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56596 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752110AbaHDQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Emmanuel Grumbach" <emmanuel.grumbach@intel.com>
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.38496038@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 22/94] iwlwifi: dvm: don't enable CTS to self
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 43d826ca5979927131685cc2092c7ce862cb91cd upstream.

We should always prefer to use full RTS protection. Using
CTS to self gives a meaningless improvement, but this flow
is much harder for the firmware which is likely to have
issues with it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
[bwh: Backported to 3.2:
 - Adjust filename
 - Condition for RXON_FLG_SELF_CTS_EN in iwlagn_commit_rxon() was different]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c | 12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -440,14 +440,6 @@ int iwlagn_commit_rxon(struct iwl_priv *
 	/* always get timestamp with Rx frame */
 	ctx->staging.flags |= RXON_FLG_TSF2HOST_MSK;
 
-	/*
-	 * force CTS-to-self frames protection if RTS-CTS is not preferred
-	 * one aggregation protection method
-	 */
-	if (!(priv->cfg->ht_params &&
-	      priv->cfg->ht_params->use_rts_for_aggregation))
-		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
@@ -880,11 +872,6 @@ void iwlagn_bss_info_changed(struct ieee
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 
-	if (bss_conf->use_cts_prot)
-		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
-	else
-		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
-
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
 	if (vif->type == NL80211_IFTYPE_AP ||

