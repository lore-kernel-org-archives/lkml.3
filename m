Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760740AbaJCX5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:57:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45708 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756791AbaJCVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 239/357] Revert "iwlwifi: dvm: dont enable CTS to self"
Date: Fri,  3 Oct 2014 14:30:25 -0700
Message-Id: <20141003212940.689210597@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit f47f46d7b09cf1d09e4b44b6cc4dd7d68a08028c upstream.

This reverts commit 43d826ca5979927131685cc2092c7ce862cb91cd.

This commit caused packet loss.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/rxon.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1068,6 +1068,13 @@ int iwlagn_commit_rxon(struct iwl_priv *
 	/* recalculate basic rates */
 	iwl_calc_basic_rates(priv, ctx);
 
+	/*
+	 * force CTS-to-self frames protection if RTS-CTS is not preferred
+	 * one aggregation protection method
+	 */
+	if (!priv->hw_params.use_rts_for_aggregation)
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+
 	if ((ctx->vif && ctx->vif->bss_conf.use_short_slot) ||
 	    !(ctx->staging.flags & RXON_FLG_BAND_24G_MSK))
 		ctx->staging.flags |= RXON_FLG_SHORT_SLOT_MSK;
@@ -1473,6 +1480,11 @@ void iwlagn_bss_info_changed(struct ieee
 	else
 		ctx->staging.flags &= ~RXON_FLG_TGG_PROTECT_MSK;
 
+	if (bss_conf->use_cts_prot)
+		ctx->staging.flags |= RXON_FLG_SELF_CTS_EN;
+	else
+		ctx->staging.flags &= ~RXON_FLG_SELF_CTS_EN;
+
 	memcpy(ctx->staging.bssid_addr, bss_conf->bssid, ETH_ALEN);
 
 	if (vif->type == NL80211_IFTYPE_AP ||


