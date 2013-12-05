Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3LEX5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:57:34 -0500
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:44920 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754427Ab3LEX5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:57:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3868:3871:3872:4321:4384:4605:5007:7652:7809:7875:8957:10004:10400:10481:10848:11026:11233:11473:11658:11914:12043:12296:12438:12517:12519:12555:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: corn52_7b74e9c389923
X-Filterd-Recvd-Size: 3511
Message-ID: <1386287846.10003.34.camel@joe-AO722>
Subject: [PATCH -next] staging: slicoss:  Remove last reference to
 compare_ether_addr
From: Joe Perches <joe@perches.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel <devel@driverdev.osuosl.org>, LKML <linux-kernel@vger.kernel.org>
Date: Thu, 05 Dec 2013 15:57:26 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And use the normal is_<foo>_ether_addr functions and ETH_ALEN too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/slicoss/README    |  1 -
 drivers/staging/slicoss/slicoss.c | 21 ++++++++-------------
 2 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/slicoss/README b/drivers/staging/slicoss/README
index cb04a87..53052c4 100644
--- a/drivers/staging/slicoss/README
+++ b/drivers/staging/slicoss/README
@@ -14,7 +14,6 @@ TODO:
 	- use net_device_ops
 	- use dev->stats rather than adapter->stats
 	- don't cast netdev_priv it is already void
-	- use compare_ether_addr
 	- GET RID OF MACROS
 	- work on all architectures
 	   - without CONFIG_X86_64 confusion
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index f340cb9..1426ca4 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -595,15 +595,12 @@ static void slic_adapter_set_hwaddr(struct adapter *adapter)
 		memcpy(adapter->macaddr,
 		       card->config.MacInfo[adapter->functionnumber].macaddrA,
 		       sizeof(struct slic_config_mac));
-		if (!(adapter->currmacaddr[0] || adapter->currmacaddr[1] ||
-		      adapter->currmacaddr[2] || adapter->currmacaddr[3] ||
-		      adapter->currmacaddr[4] || adapter->currmacaddr[5])) {
-			memcpy(adapter->currmacaddr, adapter->macaddr, 6);
-		}
-		if (adapter->netdev) {
+		if (is_zero_ether_addr(adapter->currmacaddr))
+			memcpy(adapter->currmacaddr, adapter->macaddr,
+			       ETH_ALEN);
+		if (adapter->netdev)
 			memcpy(adapter->netdev->dev_addr, adapter->currmacaddr,
-			       6);
-		}
+			       ETH_ALEN);
 	}
 }
 
@@ -767,13 +764,11 @@ static bool slic_mac_filter(struct adapter *adapter,
 {
 	struct net_device *netdev = adapter->netdev;
 	u32 opts = adapter->macopts;
-	u32 *dhost4 = (u32 *)&ether_frame->ether_dhost[0];
-	u16 *dhost2 = (u16 *)&ether_frame->ether_dhost[4];
 
 	if (opts & MAC_PROMISC)
 		return true;
 
-	if ((*dhost4 == 0xFFFFFFFF) && (*dhost2 == 0xFFFF)) {
+	if (is_broadcast_ether_addr(ether_frame->ether_dhost)) {
 		if (opts & MAC_BCAST) {
 			adapter->rcv_broadcasts++;
 			return true;
@@ -782,7 +777,7 @@ static bool slic_mac_filter(struct adapter *adapter,
 		}
 	}
 
-	if (ether_frame->ether_dhost[0] & 0x01) {
+	if (is_multicast_ether_addr(ether_frame->ether_dhost)) {
 		if (opts & MAC_ALLMCAST) {
 			adapter->rcv_multicasts++;
 			netdev->stats.multicast++;
@@ -2335,7 +2330,7 @@ static int slic_mcast_add_list(struct adapter *adapter, char *address)
 	if (mcaddr == NULL)
 		return 1;
 
-	memcpy(mcaddr->address, address, 6);
+	memcpy(mcaddr->address, address, ETH_ALEN);
 
 	mcaddr->next = adapter->mcastaddrs;
 	adapter->mcastaddrs = mcaddr;


