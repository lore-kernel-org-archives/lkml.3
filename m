Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307Ab3HIB7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:59:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55964 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030271Ab3HIB7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        David Spinadel <david.spinadel@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 101/102] iwlwifi: mvm: set SSID bits for passive channels
Date: Thu,  8 Aug 2013 18:58:17 -0700
Message-Id: <20130809015034.081855154@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Spinadel <david.spinadel@intel.com>

commit bb963c4a43eb5127eb0bbfa16c7a6a209b0af5db upstream.

Set SSID bitmap for direct scan even on passive channels,
for the passive-to-active feature. Without this patch only
the SSID from probe request template is sent on passive
channels, after passive-to-active switching, causing us to
not find all desired networks.

Remove the unused passive scan mask constant.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h |    1 -
 drivers/net/wireless/iwlwifi/mvm/scan.c        |   11 ++---------
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-scan.h
@@ -69,7 +69,6 @@
 /* Scan Commands, Responses, Notifications */
 
 /* Masks for iwl_scan_channel.type flags */
-#define SCAN_CHANNEL_TYPE_PASSIVE	0
 #define SCAN_CHANNEL_TYPE_ACTIVE	BIT(0)
 #define SCAN_CHANNEL_NARROW_BAND	BIT(22)
 
--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -176,19 +176,12 @@ static void iwl_mvm_scan_fill_channels(s
 	struct iwl_scan_channel *chan = (struct iwl_scan_channel *)
 		(cmd->data + le16_to_cpu(cmd->tx_cmd.len));
 	int i;
-	__le32 chan_type_value;
-
-	if (req->n_ssids > 0)
-		chan_type_value = cpu_to_le32(BIT(req->n_ssids + 1) - 1);
-	else
-		chan_type_value = SCAN_CHANNEL_TYPE_PASSIVE;
 
 	for (i = 0; i < cmd->channel_count; i++) {
 		chan->channel = cpu_to_le16(req->channels[i]->hw_value);
+		chan->type = cpu_to_le32(BIT(req->n_ssids) - 1);
 		if (req->channels[i]->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			chan->type = SCAN_CHANNEL_TYPE_PASSIVE;
-		else
-			chan->type = chan_type_value;
+			chan->type &= cpu_to_le32(~SCAN_CHANNEL_TYPE_ACTIVE);
 		chan->active_dwell = cpu_to_le16(active_dwell);
 		chan->passive_dwell = cpu_to_le16(passive_dwell);
 		chan->iteration_count = cpu_to_le16(1);


