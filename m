Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab3BLVK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:10:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab3BLUfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 09/61] Revert "iwlwifi: fix the reclaimed packet tracking upon flush queue"
Date: Tue, 12 Feb 2013 12:34:29 -0800
Message-Id: <20130212203419.357872976@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit ae023b2795d36f0f077e157428eb7eafa29ee412 upstream.

This reverts commit f590dcec944552f9a4a61155810f3abd17d6465d
which has been reported to cause issues.

See https://lkml.org/lkml/2013/1/20/4 for further details.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/tx.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1154,6 +1154,13 @@ int iwlagn_rx_reply_tx(struct iwl_priv *
 			next_reclaimed = ssn;
 		}
 
+		if (tid != IWL_TID_NON_QOS) {
+			priv->tid_data[sta_id][tid].next_reclaimed =
+				next_reclaimed;
+			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
+						  next_reclaimed);
+		}
+
 		iwl_trans_reclaim(priv->trans, txq_id, ssn, &skbs);
 
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
@@ -1204,28 +1211,11 @@ int iwlagn_rx_reply_tx(struct iwl_priv *
 			if (!is_agg)
 				iwlagn_non_agg_tx_status(priv, ctx, hdr->addr1);
 
-			/*
-			 * W/A for FW bug - the seq_ctl isn't updated when the
-			 * queues are flushed. Fetch it from the packet itself
-			 */
-			if (!is_agg && status == TX_STATUS_FAIL_FIFO_FLUSHED) {
-				next_reclaimed = le16_to_cpu(hdr->seq_ctrl);
-				next_reclaimed =
-					SEQ_TO_SN(next_reclaimed + 0x10);
-			}
-
 			is_offchannel_skb =
 				(info->flags & IEEE80211_TX_CTL_TX_OFFCHAN);
 			freed++;
 		}
 
-		if (tid != IWL_TID_NON_QOS) {
-			priv->tid_data[sta_id][tid].next_reclaimed =
-				next_reclaimed;
-			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
-					   next_reclaimed);
-		}
-
 		WARN_ON(!is_agg && freed != 1);
 
 		/*


