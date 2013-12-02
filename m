Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3LBTO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:14:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3LBTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Steinar H. Gunderson" <sesse@google.com>,
        Eric Dumazet <edumazet@google.com>, Paul Stewart <pstew@google.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.10 171/173] iwl3945: better skb management in rx path
Date: Mon,  2 Dec 2013 11:12:34 -0800
Message-Id: <20131202191202.605691643@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 45fe142cefa864b685615bcb930159f6749c3667 upstream.

Steinar reported reallocations of skb->head with IPv6, leading to
a warning in skb_try_coalesce()

It turns out iwl3945 has several problems :

1) skb->truesize is underestimated.
   We really consume PAGE_SIZE bytes for a fragment,
   not the frame length.
2) 128 bytes of initial headroom is a bit low and forces reallocations.
3) We can avoid consuming a full page for small enough frames.

Reported-by: Steinar H. Gunderson <sesse@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paul Stewart <pstew@google.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlegacy/3945.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -462,6 +462,8 @@ il3945_is_network_packet(struct il_priv
 	}
 }
 
+#define SMALL_PACKET_SIZE 256
+
 static void
 il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 			       struct ieee80211_rx_status *stats)
@@ -470,14 +472,13 @@ il3945_pass_packet_to_mac80211(struct il
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IL_RX_DATA(pkt);
 	struct il3945_rx_frame_hdr *rx_hdr = IL_RX_HDR(pkt);
 	struct il3945_rx_frame_end *rx_end = IL_RX_END(pkt);
-	u16 len = le16_to_cpu(rx_hdr->len);
+	u32 len = le16_to_cpu(rx_hdr->len);
 	struct sk_buff *skb;
 	__le16 fc = hdr->frame_control;
+	u32 fraglen = PAGE_SIZE << il->hw_params.rx_page_order;
 
 	/* We received data from the HW, so stop the watchdog */
-	if (unlikely
-	    (len + IL39_RX_FRAME_SIZE >
-	     PAGE_SIZE << il->hw_params.rx_page_order)) {
+	if (unlikely(len + IL39_RX_FRAME_SIZE > fraglen)) {
 		D_DROP("Corruption detected!\n");
 		return;
 	}
@@ -488,26 +489,32 @@ il3945_pass_packet_to_mac80211(struct il
 		return;
 	}
 
-	skb = dev_alloc_skb(128);
+	skb = dev_alloc_skb(SMALL_PACKET_SIZE);
 	if (!skb) {
 		IL_ERR("dev_alloc_skb failed\n");
 		return;
 	}
 
 	if (!il3945_mod_params.sw_crypto)
-		il_set_decrypted_flag(il, (struct ieee80211_hdr *)rxb_addr(rxb),
+		il_set_decrypted_flag(il, (struct ieee80211_hdr *)pkt,
 				      le32_to_cpu(rx_end->status), stats);
 
-	skb_add_rx_frag(skb, 0, rxb->page,
-			(void *)rx_hdr->payload - (void *)pkt, len,
-			len);
-
+	/* If frame is small enough to fit into skb->head, copy it
+	 * and do not consume a full page
+	 */
+	if (len <= SMALL_PACKET_SIZE) {
+		memcpy(skb_put(skb, len), rx_hdr->payload, len);
+	} else {
+		skb_add_rx_frag(skb, 0, rxb->page,
+				(void *)rx_hdr->payload - (void *)pkt, len,
+				fraglen);
+		il->alloc_rxb_page--;
+		rxb->page = NULL;
+	}
 	il_update_stats(il, false, fc, len);
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(il->hw, skb);
-	il->alloc_rxb_page--;
-	rxb->page = NULL;
 }
 
 #define IL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)


