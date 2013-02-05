Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab3BEWZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:25:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47991 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab3BEWJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:53 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 36/93] ath9k: fix rx flush handling
Date: Tue,  5 Feb 2013 20:06:25 -0200
Message-Id: <1360102042-10732-37-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 4b883f021b9ccf2df3d14425e6e610281fb6a35e upstream.

Right now the rx flush is not doing anything useful on AR9003+, as it only
works if the buffers in the rx FIFO have not been purged yet, as is done
by ath_stoprecv.

To fix this, always call ath_flushrecv from within ath_stoprecv before
the FIFO is emptied, but still after the hw receive path has been stopped.

This ensures that frames received (and ACKed by the hardware) shortly before
a reset will be seen by the software, which should improve A-MPDU session
stability.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   16 +++-------------
 drivers/net/wireless/ath/ath9k/recv.c  |   16 +++++++++-------
 3 files changed, 12 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index cd23a03..8697014 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -320,7 +320,6 @@ struct ath_rx {
 
 int ath_startrecv(struct ath_softc *sc);
 bool ath_stoprecv(struct ath_softc *sc);
-void ath_flushrecv(struct ath_softc *sc);
 u32 ath_calcrxfilter(struct ath_softc *sc);
 int ath_rx_init(struct ath_softc *sc, int nbufs);
 void ath_rx_cleanup(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index ecd306f..e5c9575 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -235,7 +235,7 @@ static void ath_cancel_work(struct ath_softc *sc)
 	cancel_work_sync(&sc->hw_reset_work);
 }
 
-static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
+static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
@@ -258,14 +258,6 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 	if (!ath_drain_all_txq(sc, retry_tx))
 		ret = false;
 
-	if (!flush) {
-		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-			ath_rx_tasklet(sc, 1, true);
-		ath_rx_tasklet(sc, 1, false);
-	} else {
-		ath_flushrecv(sc);
-	}
-
 	tasklet_enable(&sc->intr_tq);
 
 	return ret;
@@ -325,7 +317,6 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath9k_hw_cal_data *caldata = NULL;
 	bool fastcc = true;
-	bool flush = false;
 	int r;
 
 	__ath_cancel_work(sc);
@@ -339,11 +330,10 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
 
 	if (!hchan) {
 		fastcc = false;
-		flush = true;
 		hchan = ah->curchan;
 	}
 
-	if (!ath_prepare_reset(sc, retry_tx, flush))
+	if (!ath_prepare_reset(sc, retry_tx))
 		fastcc = false;
 
 	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
@@ -1218,7 +1208,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
 	}
 
-	ath_prepare_reset(sc, false, true);
+	ath_prepare_reset(sc, false);
 
 	if (sc->rx.frag) {
 		dev_kfree_skb_any(sc->rx.frag);
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4d31389..039c220 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -506,6 +506,13 @@ start_recv:
 	return 0;
 }
 
+static void ath_flushrecv(struct ath_softc *sc)
+{
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
+		ath_rx_tasklet(sc, 1, true);
+	ath_rx_tasklet(sc, 1, false);
+}
+
 bool ath_stoprecv(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
@@ -516,6 +523,8 @@ bool ath_stoprecv(struct ath_softc *sc)
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah, &reset);
 
+	ath_flushrecv(sc);
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		ath_edma_stop_recv(sc);
 	else
@@ -532,13 +541,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 	return stopped && !reset;
 }
 
-void ath_flushrecv(struct ath_softc *sc)
-{
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-		ath_rx_tasklet(sc, 1, true);
-	ath_rx_tasklet(sc, 1, false);
-}
-
 static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
 {
 	/* Check whether the Beacon frame has DTIM indicating buffered bc/mc */
-- 
1.7.9.5

