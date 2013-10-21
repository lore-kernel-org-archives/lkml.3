Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3JUIvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:51:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39400 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab3JUIvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:02 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Felix Fietkau" <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.230744131@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 026/149] ath9k: fix rx descriptor related race condition
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  5 +----
 drivers/net/wireless/ath/ath9k/recv.c  | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -77,10 +77,6 @@ struct ath_config {
 		       sizeof(struct ath_buf_state));		\
 	} while (0)
 
-#define ATH_RXBUF_RESET(_bf) do {		\
-		(_bf)->bf_stale = false;	\
-	} while (0)
-
 /**
  * enum buffer_type - Buffer type flags
  *
@@ -308,6 +304,7 @@ struct ath_rx {
 	struct ath_buf *rx_bufptr;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
+	struct ath_buf *buf_hold;
 	struct sk_buff *frag;
 };
 
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -78,8 +78,6 @@ static void ath_rx_buf_link(struct ath_s
 	struct ath_desc *ds;
 	struct sk_buff *skb;
 
-	ATH_RXBUF_RESET(bf);
-
 	ds = bf->bf_desc;
 	ds->ds_link = 0; /* link to null */
 	ds->ds_data = bf->bf_buf_addr;
@@ -106,6 +104,14 @@ static void ath_rx_buf_link(struct ath_s
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
@@ -153,7 +159,6 @@ static bool ath_rx_edma_buf_link(struct
 
 	skb = bf->bf_mpdu;
 
-	ATH_RXBUF_RESET(bf);
 	memset(skb->data, 0, ah->caps.rx_status_len);
 	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
 				ah->caps.rx_status_len, DMA_TO_DEVICE);
@@ -492,6 +497,7 @@ int ath_startrecv(struct ath_softc *sc)
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
+	sc->rx.buf_hold = NULL;
 	sc->rx.rxlink = NULL;
 	list_for_each_entry_safe(bf, tbf, &sc->rx.rxbuf, list) {
 		ath_rx_buf_link(sc, bf);
@@ -742,6 +748,9 @@ static struct ath_buf *ath_get_next_rx_b
 	}
 
 	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	if (bf == sc->rx.buf_hold)
+		return NULL;
+
 	ds = bf->bf_desc;
 
 	/*
@@ -1974,7 +1983,7 @@ requeue:
 		if (edma) {
 			ath_rx_edma_buf_link(sc, qtype);
 		} else {
-			ath_rx_buf_link(sc, bf);
+			ath_rx_buf_relink(sc, bf);
 			ath9k_hw_rxena(ah);
 		}
 	} while (1);

