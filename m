Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3BEWJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:09:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47986 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757326Ab3BEWJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:09:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 35/93] ath9k: add a better fix for the rx tasklet vs rx flush race
Date: Tue,  5 Feb 2013 20:06:24 -0200
Message-Id: <1360102042-10732-36-git-send-email-herton.krzesinski@canonical.com>
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

commit 7fc00a3054b70b1794c2d64db703eb467ad0365c upstream.

Ensure that the rx tasklet is no longer running when entering the reset path.
Also remove the distinction between flush and no-flush frame processing.
If a frame has been received and ACKed by the hardware, the stack needs to see
it, so that the BA receive window does not go out of sync.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ herton: SC_OP_RXFLUSH defined as a macro, and *_bit operations were not
  being used yet ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/debug.c |    1 -
 drivers/net/wireless/ath/ath9k/debug.h |    2 --
 drivers/net/wireless/ath/ath9k/main.c  |    4 ++++
 drivers/net/wireless/ath/ath9k/recv.c  |   15 ---------------
 5 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4866550..cd23a03 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -588,7 +588,6 @@ struct ath_ant_comb {
 #define SC_OP_INVALID                BIT(0)
 #define SC_OP_BEACONS                BIT(1)
 #define SC_OP_OFFCHANNEL             BIT(2)
-#define SC_OP_RXFLUSH                BIT(3)
 #define SC_OP_TSF_RESET              BIT(4)
 #define SC_OP_BT_PRIORITY_DETECTED   BIT(5)
 #define SC_OP_BT_SCAN                BIT(6)
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index fde700c..9c6169e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -919,7 +919,6 @@ static ssize_t read_file_recv(struct file *file, char __user *user_buf,
 	RXS_ERR("RX-LENGTH-ERR", rx_len_err);
 	RXS_ERR("RX-OOM-ERR", rx_oom_err);
 	RXS_ERR("RX-RATE-ERR", rx_rate_err);
-	RXS_ERR("RX-DROP-RXFLUSH", rx_drop_rxflush);
 	RXS_ERR("RX-TOO-MANY-FRAGS", rx_too_many_frags_err);
 
 	PHY_ERR("UNDERRUN ERR", ATH9K_PHYERR_UNDERRUN);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index c34da09..3883bbe 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -184,7 +184,6 @@ struct ath_tx_stats {
  * @rx_oom_err:  No. of frames dropped due to OOM issues.
  * @rx_rate_err:  No. of frames dropped due to rate errors.
  * @rx_too_many_frags_err:  Frames dropped due to too-many-frags received.
- * @rx_drop_rxflush: No. of frames dropped due to RX-FLUSH.
  * @rx_beacons:  No. of beacons received.
  * @rx_frags:  No. of rx-fragements received.
  */
@@ -203,7 +202,6 @@ struct ath_rx_stats {
 	u32 rx_oom_err;
 	u32 rx_rate_err;
 	u32 rx_too_many_frags_err;
-	u32 rx_drop_rxflush;
 	u32 rx_beacons;
 	u32 rx_frags;
 };
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b5fa9eb..ecd306f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -250,6 +250,8 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 	ath9k_debug_samp_bb_mac(sc);
 	ath9k_hw_disable_interrupts(ah);
 
+	tasklet_disable(&sc->intr_tq);
+
 	if (!ath_stoprecv(sc))
 		ret = false;
 
@@ -264,6 +266,8 @@ static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx, bool flush)
 		ath_flushrecv(sc);
 	}
 
+	tasklet_enable(&sc->intr_tq);
+
 	return ret;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 14b4d07..4d31389 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -322,7 +322,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	int error = 0;
 
 	spin_lock_init(&sc->sc_pcu_lock);
-	sc->sc_flags &= ~SC_OP_RXFLUSH;
 	spin_lock_init(&sc->rx.rxbuflock);
 
 	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
@@ -535,11 +534,9 @@ bool ath_stoprecv(struct ath_softc *sc)
 
 void ath_flushrecv(struct ath_softc *sc)
 {
-	sc->sc_flags |= SC_OP_RXFLUSH;
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		ath_rx_tasklet(sc, 1, true);
 	ath_rx_tasklet(sc, 1, false);
-	sc->sc_flags &= ~SC_OP_RXFLUSH;
 }
 
 static bool ath_beacon_dtim_pending_cab(struct sk_buff *skb)
@@ -1804,9 +1801,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 	do {
 		bool decrypt_error = false;
-		/* If handling rx interrupt and flush is in progress => exit */
-		if ((sc->sc_flags & SC_OP_RXFLUSH) && (flush == 0))
-			break;
 
 		memset(&rs, 0, sizeof(rs));
 		if (edma)
@@ -1845,15 +1839,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 
 		ath_debug_stat_rx(sc, &rs);
 
-		/*
-		 * If we're asked to flush receive queue, directly
-		 * chain it back at the queue without processing it.
-		 */
-		if (sc->sc_flags & SC_OP_RXFLUSH) {
-			RX_STAT_INC(rx_drop_rxflush);
-			goto requeue_drop_frag;
-		}
-
 		memset(rxs, 0, sizeof(struct ieee80211_rx_status));
 
 		rxs->mactime = (tsf & ~0xffffffffULL) | rs.rs_tstamp;
-- 
1.7.9.5

