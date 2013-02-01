Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422690Ab3BAKun (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:50:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:39175 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161298Ab3BAKui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:50:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 18/33] ath9k: do not link receive buffers during flush
Date: Fri,  1 Feb 2013 11:49:23 +0100
Message-Id: <20130201104725.959614933@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201104724.605715763@linuxfoundation.org>
References: <20130201104724.605715763@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit a3dc48e82bb146ef11cf75676c8410c1df29b0c4 upstream.

On AR9300 the rx FIFO needs to be empty during reset to ensure that no
further DMA activity is generated, otherwise it might lead to memory
corruption issues.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/recv.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -778,6 +778,7 @@ static struct ath_buf *ath_get_next_rx_b
 			return NULL;
 	}
 
+	list_del(&bf->list);
 	if (!bf->bf_mpdu)
 		return bf;
 
@@ -1966,14 +1967,15 @@ requeue_drop_frag:
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
 


