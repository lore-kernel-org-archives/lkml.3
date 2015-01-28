Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbbA1V7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:59:16 -0500
Received: from smtprelay0226.hostedemail.com ([216.40.44.226]:45738 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932889AbbA1U0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:26:25 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:2:41:69:355:379:541:800:960:966:968:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2194:2196:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3867:3868:3870:3874:4050:4119:4321:4384:4385:4395:4419:4605:5007:6119:6261:7903:9592:10004:10848:11026:11473:11658:11914:12043:12294:12296:12438:12517:12519:12555:12683:14110:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: shame35_347e0033e9919
X-Filterd-Recvd-Size: 8173
From: Joe Perches <joe@perches.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-kernel@vger.kernel.org
Cc: linux-media@vger.kernel.org
Subject: [PATCH 2/3] dvb_net: Use standard debugging facilities
Date: Wed, 28 Jan 2015 10:05:51 -0800
Message-Id: <1cdb444dd553279f1369bc9059f775425b5df791.1422468185.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1422468185.git.joe@perches.com>
References: <cover.1422468185.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert dprintk to netdev_dbg where appropriate.
Remove dvb_net_debug module_param.
Remove __func__ from output as that can be added by dynamic_debug.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb-core/dvb_net.c | 57 +++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 33 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_net.c b/drivers/media/dvb-core/dvb_net.c
index ff79b0b..0b0f97a 100644
--- a/drivers/media/dvb-core/dvb_net.c
+++ b/drivers/media/dvb-core/dvb_net.c
@@ -68,13 +68,6 @@
 #include "dvb_demux.h"
 #include "dvb_net.h"
 
-static int dvb_net_debug;
-module_param(dvb_net_debug, int, 0444);
-MODULE_PARM_DESC(dvb_net_debug, "enable debug messages");
-
-#define dprintk(x...) do { if (dvb_net_debug) printk(x); } while (0)
-
-
 static inline __u32 iov_crc32( __u32 c, struct kvec *iov, unsigned int cnt )
 {
 	unsigned int j;
@@ -312,9 +305,9 @@ static int handle_ule_extensions( struct dvb_net_priv *p )
 			return l;	/* Stop extension header processing and discard SNDU. */
 		total_ext_len += l;
 #ifdef ULE_DEBUG
-		dprintk("handle_ule_extensions: ule_next_hdr=%p, ule_sndu_type=%i, "
-			"l=%i, total_ext_len=%i\n", p->ule_next_hdr,
-			(int) p->ule_sndu_type, l, total_ext_len);
+		pr_debug("ule_next_hdr=%p, ule_sndu_type=%i, l=%i, total_ext_len=%i\n",
+			 p->ule_next_hdr, (int)p->ule_sndu_type,
+			 l, total_ext_len);
 #endif
 
 	} while (p->ule_sndu_type < ETH_P_802_3_MIN);
@@ -697,8 +690,8 @@ static void dvb_net_ule( struct net_device *dev, const u8 *buf, size_t buf_len )
 
 					if (drop) {
 #ifdef ULE_DEBUG
-						dprintk("Dropping SNDU: MAC destination address does not match: dest addr: %pM, dev addr: %pM\n",
-							priv->ule_skb->data, dev->dev_addr);
+						netdev_dbg(dev, "Dropping SNDU: MAC destination address does not match: dest addr: %pM, dev addr: %pM\n",
+							   priv->ule_skb->data, dev->dev_addr);
 #endif
 						dev_kfree_skb(priv->ule_skb);
 						goto sndu_done;
@@ -961,8 +954,7 @@ static int dvb_net_filter_sec_set(struct net_device *dev,
 	(*secfilter)->filter_mask[10] = mac_mask[1];
 	(*secfilter)->filter_mask[11]=mac_mask[0];
 
-	dprintk("%s: filter mac=%pM\n", dev->name, mac);
-	dprintk("%s: filter mask=%pM\n", dev->name, mac_mask);
+	netdev_dbg(dev, "filter mac=%pM mask=%pM\n", mac, mac_mask);
 
 	return 0;
 }
@@ -974,7 +966,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 	struct dmx_demux *demux = priv->demux;
 	unsigned char *mac = (unsigned char *) dev->dev_addr;
 
-	dprintk("%s: rx_mode %i\n", __func__, priv->rx_mode);
+	netdev_dbg(dev, "rx_mode %i\n", priv->rx_mode);
 	mutex_lock(&priv->mutex);
 	if (priv->tsfeed || priv->secfeed || priv->secfilter || priv->multi_secfilter[0])
 		printk("%s: BUG %d\n", __func__, __LINE__);
@@ -984,7 +976,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 	priv->tsfeed = NULL;
 
 	if (priv->feedtype == DVB_NET_FEEDTYPE_MPE) {
-		dprintk("%s: alloc secfeed\n", __func__);
+		netdev_dbg(dev, "alloc secfeed\n");
 		ret=demux->allocate_section_feed(demux, &priv->secfeed,
 					 dvb_net_sec_callback);
 		if (ret<0) {
@@ -1002,38 +994,38 @@ static int dvb_net_feed_start(struct net_device *dev)
 		}
 
 		if (priv->rx_mode != RX_MODE_PROMISC) {
-			dprintk("%s: set secfilter\n", __func__);
+			netdev_dbg(dev, "set secfilter\n");
 			dvb_net_filter_sec_set(dev, &priv->secfilter, mac, mask_normal);
 		}
 
 		switch (priv->rx_mode) {
 		case RX_MODE_MULTI:
 			for (i = 0; i < priv->multi_num; i++) {
-				dprintk("%s: set multi_secfilter[%d]\n", __func__, i);
+				netdev_dbg(dev, "set multi_secfilter[%d]\n", i);
 				dvb_net_filter_sec_set(dev, &priv->multi_secfilter[i],
 						       priv->multi_macs[i], mask_normal);
 			}
 			break;
 		case RX_MODE_ALL_MULTI:
 			priv->multi_num=1;
-			dprintk("%s: set multi_secfilter[0]\n", __func__);
+			netdev_dbg(dev, "set multi_secfilter[0]\n");
 			dvb_net_filter_sec_set(dev, &priv->multi_secfilter[0],
 					       mac_allmulti, mask_allmulti);
 			break;
 		case RX_MODE_PROMISC:
 			priv->multi_num=0;
-			dprintk("%s: set secfilter\n", __func__);
+			netdev_dbg(dev, "set secfilter\n");
 			dvb_net_filter_sec_set(dev, &priv->secfilter, mac, mask_promisc);
 			break;
 		}
 
-		dprintk("%s: start filtering\n", __func__);
+		netdev_dbg(dev, "start filtering\n");
 		priv->secfeed->start_filtering(priv->secfeed);
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
 		struct timespec timeout = { 0, 10000000 }; // 10 msec
 
 		/* we have payloads encapsulated in TS */
-		dprintk("%s: alloc tsfeed\n", __func__);
+		netdev_dbg(dev, "alloc tsfeed\n");
 		ret = demux->allocate_ts_feed(demux, &priv->tsfeed, dvb_net_ts_callback);
 		if (ret < 0) {
 			printk("%s: could not allocate ts feed\n", dev->name);
@@ -1057,7 +1049,7 @@ static int dvb_net_feed_start(struct net_device *dev)
 			goto error;
 		}
 
-		dprintk("%s: start filtering\n", __func__);
+		netdev_dbg(dev, "start filtering\n");
 		priv->tsfeed->start_filtering(priv->tsfeed);
 	} else
 		ret = -EINVAL;
@@ -1072,17 +1064,16 @@ static int dvb_net_feed_stop(struct net_device *dev)
 	struct dvb_net_priv *priv = netdev_priv(dev);
 	int i, ret = 0;
 
-	dprintk("%s\n", __func__);
 	mutex_lock(&priv->mutex);
 	if (priv->feedtype == DVB_NET_FEEDTYPE_MPE) {
 		if (priv->secfeed) {
 			if (priv->secfeed->is_filtering) {
-				dprintk("%s: stop secfeed\n", __func__);
+				netdev_dbg(dev, "stop secfeed\n");
 				priv->secfeed->stop_filtering(priv->secfeed);
 			}
 
 			if (priv->secfilter) {
-				dprintk("%s: release secfilter\n", __func__);
+				netdev_dbg(dev, "release secfilter\n");
 				priv->secfeed->release_filter(priv->secfeed,
 							      priv->secfilter);
 				priv->secfilter=NULL;
@@ -1090,8 +1081,8 @@ static int dvb_net_feed_stop(struct net_device *dev)
 
 			for (i=0; i<priv->multi_num; i++) {
 				if (priv->multi_secfilter[i]) {
-					dprintk("%s: release multi_filter[%d]\n",
-						__func__, i);
+					netdev_dbg(dev, "release multi_filter[%d]\n",
+						   i);
 					priv->secfeed->release_filter(priv->secfeed,
 								      priv->multi_secfilter[i]);
 					priv->multi_secfilter[i] = NULL;
@@ -1105,7 +1096,7 @@ static int dvb_net_feed_stop(struct net_device *dev)
 	} else if (priv->feedtype == DVB_NET_FEEDTYPE_ULE) {
 		if (priv->tsfeed) {
 			if (priv->tsfeed->is_filtering) {
-				dprintk("%s: stop tsfeed\n", __func__);
+				netdev_dbg(dev, "stop tsfeed\n");
 				priv->tsfeed->stop_filtering(priv->tsfeed);
 			}
 			priv->demux->release_ts_feed(priv->demux, priv->tsfeed);
@@ -1145,16 +1136,16 @@ static void wq_set_multicast_list (struct work_struct *work)
 	netif_addr_lock_bh(dev);
 
 	if (dev->flags & IFF_PROMISC) {
-		dprintk("%s: promiscuous mode\n", dev->name);
+		netdev_dbg(dev, "promiscuous mode\n");
 		priv->rx_mode = RX_MODE_PROMISC;
 	} else if ((dev->flags & IFF_ALLMULTI)) {
-		dprintk("%s: allmulti mode\n", dev->name);
+		netdev_dbg(dev, "allmulti mode\n");
 		priv->rx_mode = RX_MODE_ALL_MULTI;
 	} else if (!netdev_mc_empty(dev)) {
 		struct netdev_hw_addr *ha;
 
-		dprintk("%s: set_mc_list, %d entries\n",
-			dev->name, netdev_mc_count(dev));
+		netdev_dbg(dev, "set_mc_list, %d entries\n",
+			   netdev_mc_count(dev));
 
 		priv->rx_mode = RX_MODE_MULTI;
 		priv->multi_num = 0;
-- 
2.1.2

