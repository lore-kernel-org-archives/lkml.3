Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669Ab3EGN4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:56:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab3EGNmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:42:06 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 092/118] iwlwifi: dvm: don't send zeroed LQ cmd
Date: Tue,  7 May 2013 14:38:58 +0100
Message-Id: <1367933964-1564-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
References: <1367933964-1564-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 63b77bf489881747c5118476918cc8c29378ee63 upstream.

When the stations are being restored because of unassoc
RXON, the LQ cmd may not have been initialized because it
is initialized only after association.
Sending zeroed LQ_CMD makes the fw unhappy: it raises
SYSASSERT_2078.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
[move zero_lq and make static const]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backport to 3.5:
  - file rename: dvm/sta.c -> iwl-agn-sta.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-sta.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
index 287fdd0..b4f0661 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-sta.c
@@ -723,6 +723,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
 {
 	struct iwl_addsta_cmd sta_cmd;
+	static const struct iwl_link_quality_cmd zero_lq = {};
 	struct iwl_link_quality_cmd lq;
 	int i;
 	bool found = false;
@@ -761,7 +762,9 @@ void iwl_restore_stations(struct iwl_priv *priv, struct iwl_rxon_context *ctx)
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
1.8.1.2

