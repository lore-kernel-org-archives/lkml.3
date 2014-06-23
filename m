Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaFWIiQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:38:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55623 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752677AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Helmut Schaa <helmut.schaa@googlemail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 001/111] ath9k: Fix sequence number assignment for non-data frames
Date: Mon, 23 Jun 2014 10:30:36 +0200
Message-Id: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Helmut Schaa <helmut.schaa@googlemail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5998be879719384af2014b79697eed6e38ee2706 upstream.

Since commit 558ff225de80ac95b132d3a115ddadcd64498b4f (ath9k: fix
ps-poll responses under a-mpdu sessions) non-data frames would have
gotten a sequence number from a TIDs sequence counter instead of
using the global sequence counter.

This can lead to instable connections.

To fix this only select the correct TID if we are processing a
data frame. Furthermore, prevent non-data frames to get a sequence
number from a TID sequence counter by adding a check to
ath_tx_setup_buffer.

Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 00e3f49fcf9b..7514b1ad9abd 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2078,7 +2078,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 
 	ATH_TXBUF_RESET(bf);
 
-	if (tid) {
+	if (tid && ieee80211_is_data_present(hdr->frame_control)) {
 		fragno = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
 		seqno = tid->seq_next;
 		hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
@@ -2201,7 +2201,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
-	if (txctl->an)
+	if (txctl->an && ieee80211_is_data_present(hdr->frame_control))
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
 	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
-- 
2.0.0

