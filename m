Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3IYAf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 20:35:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755272Ab3IYAUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 20:20:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 067/117] ath9k: fix rx descriptor related race condition
Date: Tue, 24 Sep 2013 17:18:53 -0700
Message-Id: <20130925001748.183107177@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130925001740.833541979@linuxfoundation.org>
References: <20130925001740.833541979@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit e96542e55a2aacf4bdeccfe2f17b77c4895b4df2 upstream.

Similar to a race condition that exists in the tx path, the hardware
might re-read the 'next' pointer of a descriptor of the last completed
frame. This only affects non-EDMA (pre-AR93xx) devices.

To deal with this race, defer clearing and re-linking a completed rx
descriptor until the next one has been processed.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    5 +----
 drivers/net/wireless/ath/ath9k/recv.c  |   17 +++++++++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -79,10 +79,6 @@ struct ath_config {
 		       sizeof(struct ath_buf_state));		\
 	} while (0)
 
-#define ATH_RXBUF_RESET(_bf) do {		\
-		(_bf)->bf_stale = false;	\
-	} while (0)
-
 /**
  * enum buffer_type - Buffer type flags
  *
@@ -317,6 +313,7 @@ struct ath_rx {
 	struct ath_descdma rxdma;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
+	struct ath_buf *buf_hold;
 	struct sk_buff *frag;
 
 	u32 ampdu_ref;
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -42,8 +42,6 @@ static void ath_rx_buf_link(struct ath_s
 	struct ath_desc *ds;
 	struct sk_buff *skb;
 
-	ATH_RXBUF_RESET(bf);
-
 	ds = bf->bf_desc;
 	ds->ds_link = 0; /* link to null */
 	ds->ds_data = bf->bf_buf_addr;
@@ -70,6 +68,14 @@ static void ath_rx_buf_link(struct ath_s
 	sc->rx.rxlink = &ds->ds_link;
 }
 
+static void ath_rx_buf_relink(struct ath_softc *sc, struct ath_buf *bf)
+{
+	if (sc->rx.buf_hold)
+		ath_rx_buf_link(sc, sc->rx.buf_hold);
+
+	sc->rx.buf_hold = bf;
+}
+
 static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 {
 	/* XXX block beacon interrupts */
@@ -117,7 +123,6 @@ static bool ath_rx_edma_buf_link(struct
 
 	skb = bf->bf_mpdu;
 
-	ATH_RXBUF_RESET(bf);
 	memset(skb->data, 0, ah->caps.rx_status_len);
 	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
 				ah->caps.rx_status_len, DMA_TO_DEVICE);
@@ -432,6 +437,7 @@ int ath_startrecv(struct ath_softc *sc)
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
+	sc->rx.buf_hold = NULL;
 	sc->rx.rxlink = NULL;
 	list_for_each_entry_safe(bf, tbf, &sc->rx.rxbuf, list) {
 		ath_rx_buf_link(sc, bf);
@@ -677,6 +683,9 @@ static struct ath_buf *ath_get_next_rx_b
 	}
 
 	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	if (bf == sc->rx.buf_hold)
+		return NULL;
+
 	ds = bf->bf_desc;
 
 	/*
@@ -1375,7 +1384,7 @@ requeue:
 		if (edma) {
 			ath_rx_edma_buf_link(sc, qtype);
 		} else {
-			ath_rx_buf_link(sc, bf);
+			ath_rx_buf_relink(sc, bf);
 			ath9k_hw_rxena(ah);
 		}
 	} while (1);


