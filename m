Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3BEWYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:24:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710Ab3BEWKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:01 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 38/93] ath9k: remove sc->rx.rxbuflock to fix a deadlock
Date: Tue,  5 Feb 2013 20:06:27 -0200
Message-Id: <1360102042-10732-39-git-send-email-herton.krzesinski@canonical.com>
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
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 -
 drivers/net/wireless/ath/ath9k/recv.c  |   13 -------------
 2 files changed, 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8697014..e9a14c0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -309,7 +309,6 @@ struct ath_rx {
 	u8 rxotherant;
 	u32 *rxlink;
 	unsigned int rxfilter;
-	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
 	struct ath_buf *rx_bufptr;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 039c220..0247fb1 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -291,8 +291,6 @@ rx_init_fail:
 
 static void ath_edma_start_recv(struct ath_softc *sc)
 {
-	spin_lock_bh(&sc->rx.rxbuflock);
-
 	ath9k_hw_rxena(sc->sc_ah);
 
 	ath_rx_addbuffer_edma(sc, ATH9K_RX_QUEUE_HP,
@@ -304,8 +302,6 @@ static void ath_edma_start_recv(struct ath_softc *sc)
 	ath_opmode_init(sc);
 
 	ath9k_hw_startpcureceive(sc->sc_ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
-
-	spin_unlock_bh(&sc->rx.rxbuflock);
 }
 
 static void ath_edma_stop_recv(struct ath_softc *sc)
@@ -322,7 +318,6 @@ int ath_rx_init(struct ath_softc *sc, int nbufs)
 	int error = 0;
 
 	spin_lock_init(&sc->sc_pcu_lock);
-	spin_lock_init(&sc->rx.rxbuflock);
 
 	common->rx_bufsize = IEEE80211_MAX_MPDU_LEN / 2 +
 			     sc->sc_ah->caps.rx_status_len;
@@ -480,7 +475,6 @@ int ath_startrecv(struct ath_softc *sc)
 		return 0;
 	}
 
-	spin_lock_bh(&sc->rx.rxbuflock);
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
@@ -501,8 +495,6 @@ start_recv:
 	ath_opmode_init(sc);
 	ath9k_hw_startpcureceive(ah, (sc->sc_flags & SC_OP_OFFCHANNEL));
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	return 0;
 }
 
@@ -518,7 +510,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 	struct ath_hw *ah = sc->sc_ah;
 	bool stopped, reset = false;
 
-	spin_lock_bh(&sc->rx.rxbuflock);
 	ath9k_hw_abortpcurecv(ah);
 	ath9k_hw_setrxfilter(ah, 0);
 	stopped = ath9k_hw_stopdmarecv(ah, &reset);
@@ -529,7 +520,6 @@ bool ath_stoprecv(struct ath_softc *sc)
 		ath_edma_stop_recv(sc);
 	else
 		sc->rx.rxlink = NULL;
-	spin_unlock_bh(&sc->rx.rxbuflock);
 
 	if (!(ah->ah_flags & AH_UNPLUGGED) &&
 	    unlikely(!stopped)) {
@@ -1796,7 +1786,6 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 		dma_type = DMA_FROM_DEVICE;
 
 	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
-	spin_lock_bh(&sc->rx.rxbuflock);
 
 	tsf = ath9k_hw_gettsf64(ah);
 	tsf_lower = tsf & 0xffffffff;
@@ -1988,8 +1977,6 @@ requeue:
 		}
 	} while (1);
 
-	spin_unlock_bh(&sc->rx.rxbuflock);
-
 	if (!(ah->imask & ATH9K_INT_RXEOL)) {
 		ah->imask |= (ATH9K_INT_RXEOL | ATH9K_INT_RXORN);
 		ath9k_hw_set_interrupts(ah);
-- 
1.7.9.5

