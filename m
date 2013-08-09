Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030344Ab3HICC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:02:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030240Ab3HIB7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 091/102] usbnet: do not pretend to support SG/TSO
Date: Thu,  8 Aug 2013 18:58:07 -0700
Message-Id: <20130809015031.717812636@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 20f0170377264e8449b6987041f0bcc4d746d3ed ]

usbnet doesn't support yet SG, so drivers should not advertise SG or TSO
capabilities, as they allow TCP stack to build large TSO packets that
need to be linearized and might use order-5 pages.

This adds an extra copy overhead and possible allocation failures.

Current code ignore skb_linearize() return code so crashes are even
possible.

Best is to not pretend SG/TSO is supported, and add this again when/if
usbnet really supports SG for devices who could get a performance gain.

Based on a prior patch from Freddy Xin <freddy@asix.com.tw>

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    9 ++++-----
 drivers/net/usb/smsc75xx.c     |   12 +++---------
 2 files changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1029,10 +1029,10 @@ static int ax88179_bind(struct usbnet *d
 	dev->mii.supports_gmii = 1;
 
 	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO;
+			      NETIF_F_RXCSUM;
 
 	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO;
+				 NETIF_F_RXCSUM;
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
@@ -1173,7 +1173,6 @@ ax88179_tx_fixup(struct usbnet *dev, str
 	if (((skb->len + 8) % frame_size) == 0)
 		tx_hdr2 |= 0x80008000;	/* Enable padding */
 
-	skb_linearize(skb);
 	headroom = skb_headroom(skb);
 	tailroom = skb_tailroom(skb);
 
@@ -1317,10 +1316,10 @@ static int ax88179_reset(struct usbnet *
 			  1, 1, tmp);
 
 	dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-			      NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO;
+			      NETIF_F_RXCSUM;
 
 	dev->net->hw_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-				 NETIF_F_RXCSUM | NETIF_F_SG | NETIF_F_TSO;
+				 NETIF_F_RXCSUM;
 
 	/* Enable checksum offload */
 	*tmp = AX_RXCOE_IP | AX_RXCOE_TCP | AX_RXCOE_UDP |
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -45,7 +45,6 @@
 #define EEPROM_MAC_OFFSET		(0x01)
 #define DEFAULT_TX_CSUM_ENABLE		(true)
 #define DEFAULT_RX_CSUM_ENABLE		(true)
-#define DEFAULT_TSO_ENABLE		(true)
 #define SMSC75XX_INTERNAL_PHY_ID	(1)
 #define SMSC75XX_TX_OVERHEAD		(8)
 #define MAX_RX_FIFO_SIZE		(20 * 1024)
@@ -1410,17 +1409,14 @@ static int smsc75xx_bind(struct usbnet *
 
 	INIT_WORK(&pdata->set_multicast, smsc75xx_deferred_multicast_write);
 
-	if (DEFAULT_TX_CSUM_ENABLE) {
+	if (DEFAULT_TX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-		if (DEFAULT_TSO_ENABLE)
-			dev->net->features |= NETIF_F_SG |
-				NETIF_F_TSO | NETIF_F_TSO6;
-	}
+
 	if (DEFAULT_RX_CSUM_ENABLE)
 		dev->net->features |= NETIF_F_RXCSUM;
 
 	dev->net->hw_features = NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
-		NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_RXCSUM;
+				NETIF_F_RXCSUM;
 
 	ret = smsc75xx_wait_ready(dev, 0);
 	if (ret < 0) {
@@ -2200,8 +2196,6 @@ static struct sk_buff *smsc75xx_tx_fixup
 {
 	u32 tx_cmd_a, tx_cmd_b;
 
-	skb_linearize(skb);
-
 	if (skb_headroom(skb) < SMSC75XX_TX_OVERHEAD) {
 		struct sk_buff *skb2 =
 			skb_copy_expand(skb, SMSC75XX_TX_OVERHEAD, 0, flags);


