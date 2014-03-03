Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211AbaCCS6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:58:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56063 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaCCS6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:58:37 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 26/67] ath9k_htc: make ->sta_rc_update atomic for most calls
Date: Mon,  3 Mar 2014 10:55:14 -0800
Message-Id: <1393872955-28810-27-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393872955-28810-1-git-send-email-kamal@canonical.com>
References: <1393872955-28810-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 2fa4cb905605c863bf570027233af7afd8149ae4 upstream.

sta_rc_update() callback must be atomic, hence we can not take mutexes
or do other operations, which can sleep in ath9k_htc_sta_rc_update().

I think we can just return from ath9k_htc_sta_rc_update(), if it is
called without IEEE80211_RC_SUPP_RATES_CHANGED bit. That will help
with scheduling while atomic bug for most cases (except mesh and IBSS
modes).

For mesh and IBSS I do not see other solution like creating additional
workqueue, because sending firmware command require us to sleep, but
this can be done in additional patch.

Patch partially fixes bug:
https://bugzilla.redhat.com/show_bug.cgi?id=990955

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index 112116b..07f8817 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1329,21 +1329,22 @@ static void ath9k_htc_sta_rc_update(struct ieee80211_hw *hw,
 	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_htc_target_rate trate;
 
+	if (!(changed & IEEE80211_RC_SUPP_RATES_CHANGED))
+		return;
+
 	mutex_lock(&priv->mutex);
 	ath9k_htc_ps_wakeup(priv);
 
-	if (changed & IEEE80211_RC_SUPP_RATES_CHANGED) {
-		memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
-		ath9k_htc_setup_rate(priv, sta, &trate);
-		if (!ath9k_htc_send_rate_cmd(priv, &trate))
-			ath_dbg(common, CONFIG,
-				"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
-				sta->addr, be32_to_cpu(trate.capflags));
-		else
-			ath_dbg(common, CONFIG,
-				"Unable to update supported rates for sta: %pM\n",
-				sta->addr);
-	}
+	memset(&trate, 0, sizeof(struct ath9k_htc_target_rate));
+	ath9k_htc_setup_rate(priv, sta, &trate);
+	if (!ath9k_htc_send_rate_cmd(priv, &trate))
+		ath_dbg(common, CONFIG,
+			"Supported rates for sta: %pM updated, rate caps: 0x%X\n",
+			sta->addr, be32_to_cpu(trate.capflags));
+	else
+		ath_dbg(common, CONFIG,
+			"Unable to update supported rates for sta: %pM\n",
+			sta->addr);
 
 	ath9k_htc_ps_restore(priv);
 	mutex_unlock(&priv->mutex);
-- 
1.8.3.2

