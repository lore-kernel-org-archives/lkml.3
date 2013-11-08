Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3KHCaS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:30:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178Ab3KHCVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 46/91] ath9k: fix tx queue scheduling after channel changes
Date: Thu,  7 Nov 2013 18:15:01 -0800
Message-Id: <1383876946-2396-47-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit ec30326ea773900da210c495e14cfeb532550ba2 upstream.

Otherwise, if queues are full during a scan, tx scheduling does not
resume after switching back to the home channel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index fc8dc93..e0eb87b 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -209,6 +209,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	unsigned long flags;
+	int i;
 
 	if (ath_startrecv(sc) != 0) {
 		ath_err(common, "Unable to restart recv logic\n");
@@ -236,6 +237,15 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 		}
 	work:
 		ath_restart_work(sc);
+
+		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
+			if (!ATH_TXQ_SETUP(sc, i))
+				continue;
+
+			spin_lock_bh(&sc->tx.txq[i].axq_lock);
+			ath_txq_schedule(sc, &sc->tx.txq[i]);
+			spin_unlock_bh(&sc->tx.txq[i].axq_lock);
+		}
 	}
 
 	if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx != 3)
@@ -546,20 +556,8 @@ static int ath_reset(struct ath_softc *sc, bool retry_tx)
 	int r;
 
 	ath9k_ps_wakeup(sc);
-
 	r = ath_reset_internal(sc, NULL, retry_tx);
 
-	if (retry_tx) {
-		int i;
-		for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++) {
-			if (ATH_TXQ_SETUP(sc, i)) {
-				spin_lock_bh(&sc->tx.txq[i].axq_lock);
-				ath_txq_schedule(sc, &sc->tx.txq[i]);
-				spin_unlock_bh(&sc->tx.txq[i].axq_lock);
-			}
-		}
-	}
-
 	ath9k_ps_restore(sc);
 
 	return r;
-- 
1.8.1.2

