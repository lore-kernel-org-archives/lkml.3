Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbaJDAHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:07:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbaJCVxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eyal Shapira <eyalx.shapira@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.16 242/357] iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate
Date: Fri,  3 Oct 2014 14:30:28 -0700
Message-Id: <20141003212940.774825549@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/tx.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -169,10 +169,14 @@ static void iwl_mvm_set_tx_cmd_rate(stru
 
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


