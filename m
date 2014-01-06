Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbaAFSmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:42:47 -0500
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:47829 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754620AbaAFSmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:42:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:4225:4321:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12517:12519:12555:12740:13095:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: touch66_6efd48648e319
X-Filterd-Recvd-Size: 4140
Message-ID: <1389033761.2433.7.camel@joe-AO722>
Subject: Re: [PATCH net] r8152: add terminating newline
From: Joe Perches <joe@perches.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Mon, 06 Jan 2014 10:42:41 -0800
In-Reply-To: <1388999999-9218-1-git-send-email-hayeswang@realtek.com>
References: <1388999999-9218-1-git-send-email-hayeswang@realtek.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-06 at 17:19 +0800, Hayes Wang wrote:
> The netif_err() and netif_info() should have the terminating newline
> at the end of the message.

dev_<level> uses also need terminating newlines.

Perhaps it's a bit more comprehensive to convert the
pr_<level>_ratelimited uses to use net_ratelimit and
netdev_<level>.
---
 drivers/net/usb/r8152.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 13fabbb..8ae97a5 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -966,10 +966,12 @@ static void read_bulk_callback(struct urb *urb)
 	case -ENOENT:
 		return;	/* the urb is in unlink state */
 	case -ETIME:
-		pr_warn_ratelimited("may be reset is needed?..\n");
+		if (net_ratelimit())
+			netdev_warn(netdev, "maybe reset is needed?\n");
 		break;
 	default:
-		pr_warn_ratelimited("Rx status %d\n", status);
+		if (net_ratelimit())
+			netdev_warn(netdev, "Rx status %d\n", status);
 		break;
 	}
 
@@ -1002,7 +1004,8 @@ static void write_bulk_callback(struct urb *urb)
 
 	stats = rtl8152_get_stats(tp->netdev);
 	if (status) {
-		pr_warn_ratelimited("Tx status %d\n", status);
+		if (net_ratelimit())
+			netdev_warn(tp->netdev, "Tx status %d\n", status);
 		stats->tx_errors += agg->skb_num;
 	} else {
 		stats->tx_packets += agg->skb_num;
@@ -1079,7 +1082,7 @@ resubmit:
 		netif_device_detach(tp->netdev);
 	else if (res)
 		netif_err(tp, intr, tp->netdev,
-			"can't resubmit intr, status %d\n", res);
+			  "can't resubmit intr, status %d\n", res);
 }
 
 static inline void *rx_agg_align(void *data)
@@ -1490,7 +1493,7 @@ static void rtl8152_tx_timeout(struct net_device *netdev)
 	struct r8152 *tp = netdev_priv(netdev);
 	int i;
 
-	netif_warn(tp, tx_err, netdev, "Tx timeout.\n");
+	netif_warn(tp, tx_err, netdev, "Tx timeout\n");
 	for (i = 0; i < RTL8152_MAX_TX; i++)
 		usb_unlink_urb(tp->tx_info[i].urb);
 }
@@ -2284,8 +2287,8 @@ static int rtl8152_open(struct net_device *netdev)
 	if (res) {
 		if (res == -ENODEV)
 			netif_device_detach(tp->netdev);
-		netif_warn(tp, ifup, netdev,
-			"intr_urb submit failed: %d\n", res);
+		netif_warn(tp, ifup, netdev, "intr_urb submit failed: %d\n",
+			   res);
 		return res;
 	}
 
@@ -2751,7 +2754,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	netdev = alloc_etherdev(sizeof(struct r8152));
 	if (!netdev) {
-		dev_err(&intf->dev, "Out of memory");
+		dev_err(&intf->dev, "Out of memory\n");
 		return -ENOMEM;
 	}
 
@@ -2760,7 +2763,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->msg_enable = 0x7FFF;
 
 	if (!rtl_ops_init(tp, id)) {
-		netif_err(tp, probe, netdev, "Unknown Device");
+		netif_err(tp, probe, netdev, "Unknown Device\n");
 		return -ENODEV;
 	}
 
@@ -2797,11 +2800,11 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
-		netif_err(tp, probe, netdev, "couldn't register the device");
+		netif_err(tp, probe, netdev, "couldn't register the device\n");
 		goto out1;
 	}
 
-	netif_info(tp, probe, netdev, "%s", DRIVER_VERSION);
+	netif_info(tp, probe, netdev, "%s\n", DRIVER_VERSION);
 
 	return 0;
 


