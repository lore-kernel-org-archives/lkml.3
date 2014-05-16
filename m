Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbaEPW0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 18:26:30 -0400
Received: from ns3094689.ip-91-121-202.eu ([91.121.202.112]:51819 "EHLO
	ns3094689.ip-91-121-202.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766AbaEPW03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 18:26:29 -0400
From: Denis Pithon <denis.pithon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: himangi774@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging/wlan-ng: log with netdev_xxx and dev_xxx
Date: Sat, 17 May 2014 00:24:09 +0200
Message-Id: <1400279049-2205-1-git-send-email-denis.pithon@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140515215739.GC4642@kroah.com>
References: <20140515215739.GC4642@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wherever possible, replaced printk() and pr_xxx() calls with
netdev_xxx() / dev_xxx() calls; used pr_xxx() otherwise.

Signed-off-by: Denis Pithon <denis.pithon@gmail.com>
---
 drivers/staging/wlan-ng/p80211netdev.c | 45 +++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 21ca17e..00b186c 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -279,7 +279,7 @@ static int p80211_convert_to_ether(wlandevice_t *wlandev, struct sk_buff *skb)
 		return 0;
 	}
 
-	pr_debug("p80211_to_ether failed.\n");
+	netdev_dbg(wlandev->netdev, "p80211_convert_to_ether failed.\n");
 	return CONV_TO_ETHER_FAILED;
 }
 
@@ -365,7 +365,7 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 	memset(&p80211_wep, 0, sizeof(struct p80211_metawep));
 
 	if (netif_queue_stopped(netdev)) {
-		pr_debug("called when queue stopped.\n");
+		netdev_dbg(netdev, "called when queue stopped.\n");
 		result = 1;
 		goto failed;
 	}
@@ -385,8 +385,7 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 		 */
 		if (skb->protocol != ETH_P_80211_RAW) {
 			netif_start_queue(wlandev->netdev);
-			printk(KERN_NOTICE
-			       "Tx attempt prior to association, frame dropped.\n");
+			netdev_notice(netdev, "Tx attempt prior to association, frame dropped.\n");
 			wlandev->linux_stats.tx_dropped++;
 			result = 0;
 			goto failed;
@@ -408,8 +407,8 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 		    (wlandev, wlandev->ethconv, skb, &p80211_hdr,
 		     &p80211_wep) != 0) {
 			/* convert failed */
-			pr_debug("ether_to_80211(%d) failed.\n",
-				 wlandev->ethconv);
+			netdev_dbg(netdev, "ether_to_80211(%d) failed.\n",
+				   wlandev->ethconv);
 			result = 1;
 			goto failed;
 		}
@@ -434,17 +433,17 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 		result = NETDEV_TX_OK;
 	} else if (txresult == 1) {
 		/* success, no more avail */
-		pr_debug("txframe success, no more bufs\n");
+		netdev_dbg(netdev, "txframe success, no more bufs\n");
 		/* netdev->tbusy = 1;  don't set here, irqhdlr */
 		/*   may have already cleared it */
 		result = NETDEV_TX_OK;
 	} else if (txresult == 2) {
 		/* alloc failure, drop frame */
-		pr_debug("txframe returned alloc_fail\n");
+		netdev_dbg(netdev, "txframe returned alloc_fail\n");
 		result = NETDEV_TX_BUSY;
 	} else {
 		/* buffer full or queue busy, drop frame. */
-		pr_debug("txframe returned full or busy\n");
+		netdev_dbg(netdev, "txframe returned full or busy\n");
 		result = NETDEV_TX_BUSY;
 	}
 
@@ -564,7 +563,7 @@ static int p80211knetdev_do_ioctl(netdevice_t *dev, struct ifreq *ifr, int cmd)
 	wlandevice_t *wlandev = dev->ml_priv;
 	u8 *msgbuf;
 
-	pr_debug("rx'd ioctl, cmd=%d, len=%d\n", cmd, req->len);
+	netdev_dbg(dev, "rx'd ioctl, cmd=%d, len=%d\n", cmd, req->len);
 
 #ifdef SIOCETHTOOL
 	if (cmd == SIOCETHTOOL) {
@@ -685,8 +684,7 @@ static int p80211knetdev_set_mac_address(netdevice_t *dev, void *addr)
 	 * change the netdev address
 	 */
 	if (result != 0 || resultcode->data != P80211ENUM_resultcode_success) {
-		printk(KERN_ERR
-		       "Low-level driver failed dot11req_mibset(dot11MACAddress).\n");
+		netdev_err(dev, "Low-level driver failed dot11req_mibset(dot11MACAddress).\n");
 		result = -EADDRNOTAVAIL;
 	} else {
 		/* everything's ok, change the addr in netdev */
@@ -765,7 +763,7 @@ int wlan_setup(wlandevice_t *wlandev, struct device *physdev)
 	/* Allocate and initialize the wiphy struct */
 	wiphy = wlan_create_wiphy(physdev, wlandev);
 	if (wiphy == NULL) {
-		printk(KERN_ERR "Failed to alloc wiphy.\n");
+		dev_err(physdev, "Failed to alloc wiphy.\n");
 		return 1;
 	}
 
@@ -773,7 +771,7 @@ int wlan_setup(wlandevice_t *wlandev, struct device *physdev)
 	netdev = alloc_netdev(sizeof(struct wireless_dev), "wlan%d",
 				ether_setup);
 	if (netdev == NULL) {
-		printk(KERN_ERR "Failed to alloc netdev.\n");
+		dev_err(physdev, "Failed to alloc netdev.\n");
 		wlan_free_wiphy(wiphy);
 		result = 1;
 	} else {
@@ -949,7 +947,8 @@ static int p80211_rx_typedrop(wlandevice_t *wlandev, u16 fc)
 	ftype = WLAN_GET_FC_FTYPE(fc);
 	fstype = WLAN_GET_FC_FSTYPE(fc);
 #if 0
-	pr_debug("rx_typedrop : ftype=%d fstype=%d.\n", ftype, fstype);
+	netdev_dbg(wlandev->netdev, "rx_typedrop : ftype=%d fstype=%d.\n",
+		   ftype, fstype);
 #endif
 	switch (ftype) {
 	case WLAN_FTYPE_MGMT:
@@ -958,7 +957,7 @@ static int p80211_rx_typedrop(wlandevice_t *wlandev, u16 fc)
 			drop = 1;
 			break;
 		}
-		pr_debug("rx'd mgmt:\n");
+		netdev_dbg(wlandev->netdev, "rx'd mgmt:\n");
 		wlandev->rx.mgmt++;
 		switch (fstype) {
 		case WLAN_FSTYPE_ASSOCREQ:
@@ -1020,7 +1019,7 @@ static int p80211_rx_typedrop(wlandevice_t *wlandev, u16 fc)
 			drop = 1;
 			break;
 		}
-		pr_debug("rx'd ctl:\n");
+		netdev_dbg(wlandev->netdev, "rx'd ctl:\n");
 		wlandev->rx.ctl++;
 		switch (fstype) {
 		case WLAN_FSTYPE_PSPOLL:
@@ -1072,19 +1071,19 @@ static int p80211_rx_typedrop(wlandevice_t *wlandev, u16 fc)
 			wlandev->rx.data__cfack_cfpoll++;
 			break;
 		case WLAN_FSTYPE_NULL:
-			pr_debug("rx'd data:null\n");
+			netdev_dbg(wlandev->netdev, "rx'd data:null\n");
 			wlandev->rx.null++;
 			break;
 		case WLAN_FSTYPE_CFACK:
-			pr_debug("rx'd data:cfack\n");
+			netdev_dbg(wlandev->netdev, "rx'd data:cfack\n");
 			wlandev->rx.cfack++;
 			break;
 		case WLAN_FSTYPE_CFPOLL:
-			pr_debug("rx'd data:cfpoll\n");
+			netdev_dbg(wlandev->netdev, "rx'd data:cfpoll\n");
 			wlandev->rx.cfpoll++;
 			break;
 		case WLAN_FSTYPE_CFACK_CFPOLL:
-			pr_debug("rx'd data:cfack_cfpoll\n");
+			netdev_dbg(wlandev->netdev, "rx'd data:cfack_cfpoll\n");
 			wlandev->rx.cfack_cfpoll++;
 			break;
 		default:
@@ -1105,8 +1104,8 @@ static void p80211knetdev_tx_timeout(netdevice_t *netdev)
 	if (wlandev->tx_timeout) {
 		wlandev->tx_timeout(wlandev);
 	} else {
-		printk(KERN_WARNING "Implement tx_timeout for %s\n",
-		       wlandev->nsdname);
+		netdev_warn(netdev, "Implement tx_timeout for %s\n",
+			    wlandev->nsdname);
 		netif_wake_queue(wlandev->netdev);
 	}
 }
-- 
1.9.0

