Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660Ab3K0A6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:58:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425Ab3K0A6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.12 030/116] rt2x00: fix a crash bug in the HT descriptor handling fix
Date: Tue, 26 Nov 2013 16:56:43 -0800
Message-Id: <20131127005739.021607962@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit b4089d6d8e71a7293e2192025dfa507a04f661c4 upstream.

Commit "rt2x00: fix HT TX descriptor settings regression"
assumes that the control parameter to rt2x00mac_tx is always non-NULL.
There is an internal call in rt2x00lib_bc_buffer_iter where NULL is
passed. Fix the resulting crash by adding an initialized dummy on-stack
ieee80211_tx_control struct.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -181,6 +181,7 @@ static void rt2x00lib_autowakeup(struct
 static void rt2x00lib_bc_buffer_iter(void *data, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
+	struct ieee80211_tx_control control = {};
 	struct rt2x00_dev *rt2x00dev = data;
 	struct sk_buff *skb;
 
@@ -195,7 +196,7 @@ static void rt2x00lib_bc_buffer_iter(voi
 	 */
 	skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	while (skb) {
-		rt2x00mac_tx(rt2x00dev->hw, NULL, skb);
+		rt2x00mac_tx(rt2x00dev->hw, &control, skb);
 		skb = ieee80211_get_buffered_bc(rt2x00dev->hw, vif);
 	}
 }


