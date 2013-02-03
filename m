Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3BCO5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:57:32 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34447 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754226Ab3BCO50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:57:26 -0500
Message-Id: <20130203144651.350330525@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 082/128] ath9k: fix double-free bug on beacon generate failure
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

commit 1adb2e2b5f85023d17eb4f95386a57029df27c88 upstream.

When the next beacon is sent, the ath_buf from the previous run is reused.
If getting a new beacon from mac80211 fails, bf->bf_mpdu is not reset, yet
the skb is freed, leading to a double-free on the next beacon tx attempt,
resulting in a system crash.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -155,6 +155,7 @@ static struct ath_buf *ath_beacon_genera
 				 skb->len, DMA_TO_DEVICE);
 		dev_kfree_skb_any(skb);
 		bf->bf_buf_addr = 0;
+		bf->bf_mpdu = NULL;
 	}
 
 	/* Get a new beacon from mac80211 */


