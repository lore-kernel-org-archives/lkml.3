Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3H0BTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:19:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59492 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383Ab3H0BHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 09/74] iwlwifi: mvm: correctly configure MCAST in AP mode
Date: Mon, 26 Aug 2013 18:08:07 -0700
Message-Id: <20130827010426.433242076@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 86a91ec757338edbce51de5dabd7afb0366f485c upstream.

The AP mode needs to use the MCAST fifo for the MCAST
frames sent after the DTIM. This fifo needs to be
configured with the same parameters as the VOICE FIFO.

A separate SCD queue is mapped to this fifo - the cab_queue
(cab stands for Content After Beacon). This queue isn't
connected to any station, but rather to the MAC context.
This queue should (and is already) be set as the MCAST
queue - this is part of the of MAC context command.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h |    8 +++++++-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   |    6 +++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |    1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
@@ -71,7 +71,13 @@
 #define MAC_INDEX_MIN_DRIVER	0
 #define NUM_MAC_INDEX_DRIVER	MAC_INDEX_AUX
 
-#define AC_NUM	4 /* Number of access categories */
+enum iwl_ac {
+	AC_BK,
+	AC_BE,
+	AC_VI,
+	AC_VO,
+	AC_NUM,
+};
 
 /**
  * enum iwl_mac_protection_flags - MAC context flags
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -362,7 +362,7 @@ int iwl_mvm_mac_ctxt_init(struct iwl_mvm
 		break;
 	case NL80211_IFTYPE_AP:
 		iwl_trans_ac_txq_enable(mvm->trans, vif->cab_queue,
-					IWL_MVM_TX_FIFO_VO);
+					IWL_MVM_TX_FIFO_MCAST);
 		/* fall through */
 	default:
 		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++)
@@ -550,6 +550,10 @@ static void iwl_mvm_mac_ctxt_cmd_common(
 		cmd->ac[i].fifos_mask = BIT(iwl_mvm_ac_to_tx_fifo[i]);
 	}
 
+	/* in AP mode, the MCAST FIFO takes the EDCA params from VO */
+	if (vif->type == NL80211_IFTYPE_AP)
+		cmd->ac[AC_VO].fifos_mask |= BIT(IWL_MVM_TX_FIFO_MCAST);
+
 	if (vif->bss_conf.qos)
 		cmd->qos_flags |= cpu_to_le32(MAC_QOS_FLG_UPDATE_EDCA);
 
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -88,6 +88,7 @@ enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BE,
 	IWL_MVM_TX_FIFO_VI,
 	IWL_MVM_TX_FIFO_VO,
+	IWL_MVM_TX_FIFO_MCAST = 5,
 };
 
 extern struct ieee80211_ops iwl_mvm_hw_ops;


