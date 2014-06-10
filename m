Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbaFJTxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:53:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35474 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289AbaFJTxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:53:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        =?UTF-8?q?Fejes=20J=C3=B3zsef?= <jozsef.fejes@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 050/160] ath9k: Fix sequence number assignment for non-data frames
Date: Tue, 10 Jun 2014 12:44:50 -0700
Message-Id: <1402429600-20477-51-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helmut Schaa <helmut.schaa@googlemail.com>

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
Cc: Fejes József <jozsef.fejes@gmail.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 0471c6a..6fa2d35 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2074,7 +2074,7 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
 
 	ATH_TXBUF_RESET(bf);
 
-	if (tid) {
+	if (tid && ieee80211_is_data_present(hdr->frame_control)) {
 		fragno = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
 		seqno = tid->seq_next;
 		hdr->seq_ctrl = cpu_to_le16(tid->seq_next << IEEE80211_SEQ_SEQ_SHIFT);
@@ -2197,7 +2197,7 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
 		txq->stopped = true;
 	}
 
-	if (txctl->an)
+	if (txctl->an && ieee80211_is_data_present(hdr->frame_control))
 		tid = ath_get_skb_tid(sc, txctl->an, skb);
 
 	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
-- 
1.9.1

