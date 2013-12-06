Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162394Ab3LFN0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:26:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44476 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab3LFNDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:53 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 194/272] iwl4965: better skb management in rx path
Date: Fri,  6 Dec 2013 12:58:03 +0000
Message-Id: <1386334761-25517-195-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit c1de4a9557d9e25e41fc4ba034b9659152205539 upstream.

4965 version of Eric patch "iwl3945: better skb management in rx path".
It fixes several problems :

1) skb->truesize is underestimated.
   We really consume PAGE_SIZE bytes for a fragment,
   not the frame length.
2) 128 bytes of initial headroom is a bit low and forces reallocations.
3) We can avoid consuming a full page for small enough frames.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 7acf5ee..5ab50a5 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -574,9 +574,11 @@ il4965_translate_rx_status(struct il_priv *il, u32 decrypt_in)
 	return decrypt_out;
 }
 
+#define SMALL_PACKET_SIZE 256
+
 static void
 il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
-			       u16 len, u32 ampdu_status, struct il_rx_buf *rxb,
+			       u32 len, u32 ampdu_status, struct il_rx_buf *rxb,
 			       struct ieee80211_rx_status *stats)
 {
 	struct sk_buff *skb;
@@ -598,21 +600,25 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 	    il_set_decrypted_flag(il, hdr, ampdu_status, stats))
 		return;
 
-	skb = dev_alloc_skb(128);
+	skb = dev_alloc_skb(SMALL_PACKET_SIZE);
 	if (!skb) {
 		IL_ERR("dev_alloc_skb failed\n");
 		return;
 	}
 
-	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len,
-			len);
+	if (len <= SMALL_PACKET_SIZE) {
+		memcpy(skb_put(skb, len), hdr, len);
+	} else {
+		skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb),
+				len, PAGE_SIZE << il->hw_params.rx_page_order);
+		il->alloc_rxb_page--;
+		rxb->page = NULL;
+	}
 
 	il_update_stats(il, false, fc, len);
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(il->hw, skb);
-	il->alloc_rxb_page--;
-	rxb->page = NULL;
 }
 
 /* Called for N_RX (legacy ABG frames), or
-- 
1.8.3.2

