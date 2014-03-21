Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967099AbaCUBXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:23:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760362AbaCUADg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.13 030/149] ath9k: fix ps-poll responses under a-mpdu sessions
Date: Thu, 20 Mar 2014 17:03:13 -0700
Message-Id: <20140321000438.012458905@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 558ff225de80ac95b132d3a115ddadcd64498b4f upstream.

When passing tx frames to the U-APSD queue for powersave poll responses,
the ath_atx_tid pointer needs to be passed to ath_tx_setup_buffer for
proper sequence number accounting.

This fixes high latency and connection stability issues with ath9k
running as AP and a few kinds of mobile phones as client, when PS-Poll
is heavily used

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/xmit.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2197,14 +2197,15 @@ int ath_tx_start(struct ieee80211_hw *hw
 		txq->stopped = true;
 	}
 
+	if (txctl->an)
+		tid = ath_get_skb_tid(sc, txctl->an, skb);
+
 	if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
 		ath_txq_unlock(sc, txq);
 		txq = sc->tx.uapsdq;
 		ath_txq_lock(sc, txq);
 	} else if (txctl->an &&
 		   ieee80211_is_data_present(hdr->frame_control)) {
-		tid = ath_get_skb_tid(sc, txctl->an, skb);
-
 		WARN_ON(tid->ac->txq != txctl->txq);
 
 		if (info->flags & IEEE80211_TX_CTL_CLEAR_PS_FILT)


