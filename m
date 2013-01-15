Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3APAI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:08:28 -0500
Received: from mail.kernel.org ([198.145.19.201]:43049 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758523Ab3AOWdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 151/221] iwlwifi: fix the reclaimed packet tracking upon flush queue
Date: Tue, 15 Jan 2013 10:51:18 -0800
Message-Id: <20130115185008.950255283@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit f590dcec944552f9a4a61155810f3abd17d6465d upstream.

There's a bug in the currently released firmware version,
the sequence control in the Tx response isn't updated in
all cases. Take it from the packet as a workaround.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/tx.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1154,13 +1154,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *
 			next_reclaimed = ssn;
 		}
 
-		if (tid != IWL_TID_NON_QOS) {
-			priv->tid_data[sta_id][tid].next_reclaimed =
-				next_reclaimed;
-			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
-						  next_reclaimed);
-		}
-
 		iwl_trans_reclaim(priv->trans, txq_id, ssn, &skbs);
 
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
@@ -1211,11 +1204,28 @@ int iwlagn_rx_reply_tx(struct iwl_priv *
 			if (!is_agg)
 				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
 
+			/*
+			 * W/A for FW bug - the seq_ctl isn't updated when the
+			 * queues are flushed. Fetch it from the packet itself
+			 */
+			if (!is_agg && status == TX_STATUS_FAIL_FIFO_FLUSHED) {
+				next_reclaimed = le16_to_cpu(hdr->seq_ctrl);
+				next_reclaimed =
+					SEQ_TO_SN(next_reclaimed + 0x10);
+			}
+
 			is_offchannel_skb =
 				(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN);
 			freed++;
 		}
 
+		if (tid != IWL_TID_NON_QOS) {
+			priv->tid_data[sta_id][tid].next_reclaimed =
+				next_reclaimed;
+			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
+					   next_reclaimed);
+		}
+
 		WARN_ON(!is_agg && freed != 1);
 
 		/*


