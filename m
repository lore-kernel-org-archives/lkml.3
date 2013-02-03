Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3BCO5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:10 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34429 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754607Ab3BCO5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:04 -0500
Message-Id: <20130203144651.260050208@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 081/128] ath9k: do not link receive buffers during flush
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit a3dc48e82bb146ef11cf75676c8410c1df29b0c4 upstream.

On AR9300 the rx FIFO needs to be empty during reset to ensure that no
further DMA activity is generated, otherwise it might lead to memory
corruption issues.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/recv.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d4df98a..01c3ba4 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -744,6 +744,7 @@ static struct ath_buf *ath_get_next_rx_buf(struct ath_softc *sc,
 			return NULL;
 	}
 
+	list_del(&bf->list);
 	if (!bf->bf_mpdu)
 		return bf;
 
@@ -1254,14 +1255,15 @@ requeue_drop_frag:
 			sc->rx.frag = NULL;
 		}
 requeue:
+		list_add_tail(&bf->list, &sc->rx.rxbuf);
+		if (flush)
+			continue;
+
 		if (edma) {
-			list_add_tail(&bf->list, &sc->rx.rxbuf);
 			ath_rx_edma_buf_link(sc, qtype);
 		} else {
-			list_move_tail(&bf->list, &sc->rx.rxbuf);
 			ath_rx_buf_link(sc, bf);
-			if (!flush)
-				ath9k_hw_rxena(ah);
+			ath9k_hw_rxena(ah);
 		}
 	} while (1);
 


