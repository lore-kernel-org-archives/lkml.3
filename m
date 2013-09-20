Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119Ab3ITUbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:31:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3ITUKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:10:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 17/93] ath9k: fix rx descriptor related race condition
Date: Fri, 20 Sep 2013 13:08:12 -0700
Message-Id: <1379707768-1804-18-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  5 +----
 drivers/net/wireless/ath/ath9k/recv.c  | 17 +++++++++++++----
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 42794c5..46e1fa7 100644
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
@@ -322,6 +318,7 @@ struct ath_rx {
 	struct ath_buf *rx_bufptr;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
+	struct ath_buf *buf_hold;
 	struct sk_buff *frag;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 90752f2..262491d 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -41,8 +41,6 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	struct ath_desc *ds;
 	struct sk_buff *skb;
 
-	ATH_RXBUF_RESET(bf);
-
 	ds = bf->bf_desc;
 	ds->ds_link = 0; /* link to null */
 	ds->ds_data = bf->bf_buf_addr;
@@ -69,6 +67,14 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
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
@@ -116,7 +122,6 @@ static bool ath_rx_edma_buf_link(struct ath_softc *sc,
 
 	skb = bf->bf_mpdu;
 
-	ATH_RXBUF_RESET(bf);
 	memset(skb->data, 0, ah->caps.rx_status_len);
 	dma_sync_single_for_device(sc->dev, bf->bf_buf_addr,
 				ah->caps.rx_status_len, DMA_TO_DEVICE);
@@ -444,6 +449,7 @@ int ath_startrecv(struct ath_softc *sc)
 	if (list_empty(&sc->rx.rxbuf))
 		goto start_recv;
 
+	sc->rx.buf_hold = NULL;
 	sc->rx.rxlink = NULL;
 	list_for_each_entry_safe(bf, tbf, &sc->rx.rxbuf, list) {
 		ath_rx_buf_link(sc, bf);
@@ -689,6 +695,9 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 	}
 
 	bf = list_first_entry(&sc->rx.rxbuf, struct ath_buf, list);
+	if (bf == sc->rx.buf_hold)
+		return NULL;
+
 	ds = bf->bf_desc;
 
 	/*
@@ -1238,7 +1247,7 @@ requeue:
 		if (edma) {
 			ath_rx_edma_buf_link(sc, qtype);
 		} else {
-			ath_rx_buf_link(sc, bf);
+			ath_rx_buf_relink(sc, bf);
 			ath9k_hw_rxena(ah);
 		}
 	} while (1);
-- 
1.8.1.2

