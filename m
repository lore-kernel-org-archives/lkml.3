Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3ERC2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:28:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4820 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab3ERCQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:47 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=qe3r2_PU8McA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=j4NbqyUeqYUA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021643.224390004@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 009/136 ] iwlwifi: dvm: dont send zeroed LQ cmd
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0009-iwlwifi-dvm-don-t-send-zeroed-LQ-cmd.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 63b77bf489881747c5118476918cc8c29378ee63 ]

When the stations are being restored because of unassoc
RXON, the LQ cmd may not have been initialized because it
is initialized only after association.
Sending zeroed LQ_CMD makes the fw unhappy: it raises
SYSASSERT_2078.

Cc: stable@vger.kernel.org
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[move zero_lq and make static const]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/sta.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/sta.c b/drivers/net/wireless/iwlwifi/dvm/sta.c
index b29b798..efe8a4f 100644
--- a/drivers/net/wireless/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/dvm/sta.c
@@ -706,6 +706,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_addsta_cmd sta_cmd;
+	static const struct iwl_link_quality_cmd zero_lq = {};
 	struct iwl_link_quality_cmd lq;
 	int i;
 	bool found = false;
@@ -744,7 +745,9 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 				else
 					memcpy(&lq, priv->stations[i].lq,
 					       sizeof(struct iwl_link_quality_cmd));
-				send_lq = true;
+
+				if (!memcmp(&lq, &zero_lq, sizeof(lq)))
+					send_lq = true;
 			}
 			spin_unlock_bh(&priv->sta_lock);
 			ret = iwl_send_add_sta(priv, &sta_cmd, CMD_SYNC);
-- 
1.7.10.4


