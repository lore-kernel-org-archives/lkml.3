Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3CREaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33374 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265Ab3CREaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:02 -0400
Message-Id: <20130318042145.652049664@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:58 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 14/82] ath9k_htc: fix signal strength handling issues
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use compare_ether_addr() instead of
 ether_addr_equal(), with opposite sense]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    1 +
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |   18 +++++++++++-------
 2 files changed, 12 insertions(+), 7 deletions(-)

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
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -1069,15 +1069,19 @@ static bool ath9k_rx_prepare(struct ath9
 
 	last_rssi = priv->rx.last_rssi;
 
-	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rxbuf->rxstatus.rs_rssi = ATH_EP_RND(last_rssi,
-						     ATH_RSSI_EP_MULTIPLIER);
+	if (ieee80211_is_beacon(hdr->frame_control) &&
+	    !is_zero_ether_addr(common->curbssid) &&
+	    compare_ether_addr(hdr->addr3, common->curbssid) == 0) {
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


