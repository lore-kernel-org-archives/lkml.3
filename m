Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361Ab3ATF4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 00:56:53 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:32935 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab3ATF4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 00:56:51 -0500
Date: Sat, 19 Jan 2013 21:56:47 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
cc: Johannes Berg <johannes.berg@intel.com>, ilw@linux.intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: iwlwifi: regression in 3.8-rc4 and 3.7.3
Message-ID: <alpine.LNX.2.00.1301192141540.1303@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After sending the first 2MB, scp over wireless becomes unbearably slow,
with frequent stalls: on this ThinkPad T420s running 3.8-rc4 or 3.7.3.
Not always, but often.

Bisection led to commit f590dcec944552f9a4a61155810f3abd17d6465d
"iwlwifi: fix the reclaimed packet tracking upon flush queue"
(below); and indeed backing that out brings them back to speed.

Here are the "iwlwifi" lines from my dmesg:
[    1.936640] iwlwifi 0000:03:00.0: irq 44 for MSI/MSI-X
[    8.384905] iwlwifi 0000:03:00.0: loaded firmware version 9.221.4.1 build 25532
[    8.406425] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUG disabled
[    8.427099] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEBUGFS disabled
[    8.447888] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
[    8.468369] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE disabled
[    8.489008] iwlwifi 0000:03:00.0: CONFIG_IWLWIFI_P2P disabled
[    8.509588] iwlwifi 0000:03:00.0: Detected Intel(R) Centrino(R) Ultimate-N 6300 AGN, REV=0x74
[    8.531309] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    9.891162] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[    9.891399] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1
[   10.260205] iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
[   10.260405] iwlwifi 0000:03:00.0: Radio type=0x0-0x3-0x1

Thanks,
Hugh

commit f590dcec944552f9a4a61155810f3abd17d6465d
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Mon Dec 31 09:26:10 2012 +0200

    iwlwifi: fix the reclaimed packet tracking upon flush queue
    
    There's a bug in the currently released firmware version,
    the sequence control in the Tx response isn't updated in
    all cases. Take it from the packet as a workaround.
    
    Cc: stable@vger.kernel.org
    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index da21328..a790599 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -1151,13 +1151,6 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
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
@@ -1208,11 +1201,28 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb,
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
