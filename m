Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3BANLN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:11:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:44939 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab3BANLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:11:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 40/89] ath9k: remove sc->rx.rxbuflock to fix a deadlock
Date: Fri,  1 Feb 2013 14:07:55 +0100
Message-Id: <20130201130210.391278491@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 463e3ed3eacc8f47866e5d612bd8ee0bcee5e2f0 upstream.

The commit "ath9k: fix rx flush handling" added a deadlock that happens
because ath_rx_tasklet is called in a section that has already taken the
rx buffer lock.

It seems that the only purpose of the rxbuflock was a band-aid fix to the
reset vs rx tasklet race, which has been properly fixed in the commit
"ath9k: add a better fix for the rx tasklet vs rx flush race".

Now that the fix is in, we can safely remove the lock to avoid such issues.

Reported-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/recv.c  |   13 -------------
 2 files changed, 14 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -315,7 +315,6 @@ struct ath_rx {
 	u32 *rxlink;
 	u32 num_pkts;
 	unsigned int rxfilter;
-	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
 	struct ath_buf *rx_bufptr;
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -254,8 +254,6 @@ rx_init_fail:
 
 static void ath_edma_start_recv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->rx.rxbuflock);
-
 	ath9k_hw_rxena(sc->sc_ah);
 
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP,
@@ -267,8 +265,6 @@ static void ath_edma_start_recv(struct a
 	ath_opmode_init(sc);
 
 	ath9k_hw_startpcureceive(sc->sc_ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
-
-	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -285,7 +281,6 @@ int ath_rx_init(struct ath_softc *sc, in
 	int error = 0;
 
 	spin_lock_init(&sc->sc_pcu_lock);
-	spin_lock_init(&sc->rx.rxbuflock);
 
 	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
 			     sc->sc_ah->caps.rx_status_len;
@@ -446,7 +441,6 @@ int ath_startrecv(struct ath_softc *sc)
 		return 0;
 	}
 
-	spin_lock_bh(&sc->rx.rxbuflock);
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
@@ -467,8 +461,6 @@ start_recv:
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, !!(sc->hw->conf.flags & IEEE80211_CONF_OFFCHANNEL));
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	return 0;
 }
 
@@ -484,7 +476,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	bool stopped, reset = false;
 
-	spin_lock_bh(&sc->rx.rxbuflock);
 	ath9k_hw_abortpcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah, &reset);
@@ -495,7 +486,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 		ath_edma_stop_recv(sc);
 	else
 		sc->rx.rxlink = NULL;
-	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	if (!(ah->ah_flags & AH_UNPLUGGED) &&
 	    unlikely(!stopped)) {
@@ -1059,7 +1049,6 @@ int ath_rx_tasklet(struct ath_softc *sc,
 		dma_type = DMA_FROM_DEVICE;
 
 	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
-	spin_lock_bh(&sc->rx.rxbuflock);
 
 	tsf = ath9k_hw_gettsf64(ah);
 	tsf_lower = tsf & 0xffffffff;
@@ -1251,8 +1240,6 @@ requeue:
 		}
 	} while (1);
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	if (!(ah->imask & ATH9K_INT_RXEOL)) {
 		ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
 		ath9k_hw_set_interrupts(ah);


