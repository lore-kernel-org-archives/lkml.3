Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757247Ab3CNKh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51982 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756970Ab3CNKhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:37:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 55/88] ath9k_htc: fix signal strength handling issues
Date: Thu, 14 Mar 2013 10:35:48 +0000
Message-Id: <1363257381-15900-56-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 838f427955dcfd16858b0108ce29029da0d56a4e upstream.

The ath9k commit 2ef167557c0a26c88162ecffb017bfcc51eb7b29
(ath9k: fix signal strength reporting issues) fixed an issue where the
reported per-frame signal strength reported to mac80211 was being
overwritten with an internal average. The same issue is also present
in ath9k_htc.
In addition to preventing the driver from overwriting the value, this
commit also ensures that the internal average (which is used for ANI)
only tracks beacons of the AP that we're connected to.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |  1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 18 +++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 1357952..17f687b 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -22,6 +22,7 @@
 #include <linux/firmware.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/leds.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 3e40a64..9cbbb6a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1067,15 +1067,19 @@ static bool ath9k_rx_prepare(struct ath9k_htc_priv *priv,
 
 	last_rssi = priv->rx.last_rssi;
 
-	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
-						     ATH_RSSI_EP_MULTIPLIER);
+	if (ieee80211_is_beacon(hdr->frame_control) &&
+	    !is_zero_ether_addr(common->curbssid) &&
+	    ether_addr_equal(hdr->addr3, common->curbssid)) {
+		s8 rssi = rxbuf->rxstatus.rs_rssi;
 
-	if (rxbuf->rxstatus.rs_rssi < 0)
-		rxbuf->rxstatus.rs_rssi = 0;
+		if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
+			rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
 
-	if (ieee80211_is_beacon(fc))
-		priv->ah->stats.avgbrssi = rxbuf->rxstatus.rs_rssi;
+		if (rssi < 0)
+			rssi = 0;
+
+		priv->ah->stats.avgbrssi = rssi;
+	}
 
 	rx_status->mactime = be64_to_cpu(rxbuf->rxstatus.rs_tstamp);
 	rx_status->band = hw->conf.channel->band;
-- 
1.8.1.2

