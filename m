Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248Ab3APQDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:03:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216Ab3APQDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:03:43 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 098/222] iwlwifi: silently ignore fw flaws in Tx path
Date: Wed, 16 Jan 2013 13:54:58 -0200
Message-Id: <1358351822-7675-99-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 27edb1accf5695ff00a32c85c4a00ac7e1e7f298 upstream.

We know that we have issues with the fw in the reclaim path.
This is why iwl_reclaim doesn't complain too loud when it
happens since it is recoverable. Somehow, the caller of
iwl_reclaim however WARNed when it happens. This doesn't
make any sense.

When I digged into the history of that code, I discovered
that this bug occurs only when we receive a BA notification.
So move the W/A in the BA notification handling code where
it was before.

This patch addresses:
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2387

Reported-by: Florian Reitmeir <florian@reitmeir.org>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ herton: code to patch is in drivers/net/wireless/iwlwifi/iwl-agn-tx.c,
  WARN_ON instead of WARN_ON_ONCE used on iwlagn_rx_reply_tx ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   48 +++++++++++------------------
 1 file changed, 18 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 3366e2e..ca0e7c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -1094,29 +1094,6 @@ static void iwl_check_abort_status(struct iwl_priv *priv,
 	}
 }
 
-static int iwl_reclaim(struct iwl_priv *priv, int sta_id, int tid,
-		       int txq_id, int ssn, struct sk_buff_head *skbs)
-{
-	if (unlikely(txq_id >= IWLAGN_FIRST_AMPDU_QUEUE &&
-		     tid != IWL_TID_NON_QOS &&
-		     txq_id != priv->tid_data[sta_id][tid].agg.txq_id)) {
-		/*
-		 * FIXME: this is a uCode bug which need to be addressed,
-		 * log the information and return for now.
-		 * Since it is can possibly happen very often and in order
-		 * not to fill the syslog, don't use IWL_ERR or IWL_WARN
-		 */
-		IWL_DEBUG_TX_QUEUES(priv,
-			"Bad queue mapping txq_id=%d, agg_txq[sta:%d,tid:%d]=%d\n",
-			txq_id, sta_id, tid,
-			priv->tid_data[sta_id][tid].agg.txq_id);
-		return 1;
-	}
-
-	iwl_trans_reclaim(priv->trans, txq_id, ssn, skbs);
-	return 0;
-}
-
 int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 			       struct iwl_device_cmd *cmd)
 {
@@ -1175,8 +1152,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
 						  next_reclaimed);
 		}
 
-		/*we can free until ssn % q.n_bd not inclusive */
-		WARN_ON(iwl_reclaim(priv, sta_id, tid, txq_id, ssn, &skbs));
+		iwl_trans_reclaim(priv->trans, txq_id, ssn, &skbs);
+
 		iwlagn_check_ratid_empty(priv, sta_id, tid);
 		freed = 0;
 
@@ -1289,16 +1266,27 @@ int iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 		return 0;
 	}
 
+	if (unlikely(scd_flow != agg->txq_id)) {
+		/*
+		 * FIXME: this is a uCode bug which need to be addressed,
+		 * log the information and return for now.
+		 * Since it is can possibly happen very often and in order
+		 * not to fill the syslog, don't use IWL_ERR or IWL_WARN
+		 */
+		IWL_DEBUG_TX_QUEUES(priv,
+				    "Bad queue mapping txq_id=%d, agg_txq[sta:%d,tid:%d]=%d\n",
+				    scd_flow, sta_id, tid, agg->txq_id);
+		spin_unlock(&priv->sta_lock);
+		return 0;
+	}
+
 	__skb_queue_head_init(&reclaimed_skbs);
 
 	/* Release all TFDs before the SSN, i.e. all TFDs in front of
 	 * block-ack window (we assume that they've been successfully
 	 * transmitted ... if not, it's too late anyway). */
-	if (iwl_reclaim(priv, sta_id, tid, scd_flow,
-			ba_resp_scd_ssn, &reclaimed_skbs)) {
-		spin_unlock(&priv->sta_lock);
-		return 0;
-	}
+	iwl_trans_reclaim(priv->trans, scd_flow, ba_resp_scd_ssn,
+			  &reclaimed_skbs);
 
 	IWL_DEBUG_TX_REPLY(priv, "REPLY_COMPRESSED_BA [%d] Received from %pM, "
 			   "sta_id = %d\n",
-- 
1.7.9.5

