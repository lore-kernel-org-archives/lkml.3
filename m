Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab3BANKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:10:51 -0500
Received: from mail.kernel.org ([198.145.19.201]:44893 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757168Ab3BANKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:10:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 36/89] ath9k: fix double-free bug on beacon generate failure
Date: Fri,  1 Feb 2013 14:07:51 +0100
Message-Id: <20130201130210.115598750@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 1adb2e2b5f85023d17eb4f95386a57029df27c88 upstream.

When the next beacon is sent, the ath_buf from the previous run is reused.
If getting a new beacon from mac80211 fails, bf->bf_mpdu is not reset, yet
the skb is freed, leading to a double-free on the next beacon tx attempt,
resulting in a system crash.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -147,6 +147,7 @@ static struct ath_buf *ath9k_beacon_gene
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_buf_addr = 0;
+		bf->bf_mpdu = NULL;
 	}
 
 	skb = ieee80211_beacon_get(hw, vif);


