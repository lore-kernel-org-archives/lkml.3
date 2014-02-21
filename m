Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289AbaBUMub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47001 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaBUMu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:27 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 056/121] ath9k_htc: make ->sta_rc_update atomic for most calls
Date: Fri, 21 Feb 2014 12:48:00 +0000
Message-Id: <1392986945-9693-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index de02522..c3e1dd2 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -1340,21 +1340,22 @@ static void ath9k_htc_sta_rc_update(struct ieee80211_hw *hw,
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
1.9.0

