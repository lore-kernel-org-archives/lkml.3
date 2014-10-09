Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbaJIV1L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:27:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59423 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaJIVKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eyal Shapira <eyalx.shapira@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 118/163] iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate
Date: Thu,  9 Oct 2014 14:02:23 -0700
Message-Id: <1412888588-26755-119-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Shapira <eyal@wizery.com>

commit aa11bbf3df026d6b1c6b528bef634fd9de7c2619 upstream.

Using the LQ table which is initially set according to
the rssi could lead to EAPOLs being sent in high legacy
rates like 54mbps.
It's better to avoid sending EAPOLs in high rates as it reduces
the chances of a successful 4-Way handshake.
Avoid this and treat them like other mgmt frames which would
initially get sent at the basic rate.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/mvm/tx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index c8f6974..edf9f7b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -173,10 +173,14 @@ static void iwl_mvm_set_tx_cmd_rate(struct iwl_mvm *mvm,
 
 	/*
 	 * for data packets, rate info comes from the table inside the fw. This
-	 * table is controlled by LINK_QUALITY commands
+	 * table is controlled by LINK_QUALITY commands. Exclude ctrl port
+	 * frames like EAPOLs which should be treated as mgmt frames. This
+	 * avoids them being sent initially in high rates which increases the
+	 * chances for completion of the 4-Way handshake.
 	 */
 
-	if (ieee80211_is_data(fc) && sta) {
+	if (ieee80211_is_data(fc) && sta &&
+	    !(info->control.flags & IEEE80211_TX_CTRL_PORT_CTRL_PROTO)) {
 		tx_cmd->initial_rate_index = 0;
 		tx_cmd->tx_flags |= cpu_to_le32(TX_CMD_FLG_STA_RATE);
 		return;
-- 
1.9.1

