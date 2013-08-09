Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967420Ab3HIBmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 21:42:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967118Ab3HIBl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:41:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 19/22] usbnet: do not pretend to support SG/TSO
Date: Thu,  8 Aug 2013 18:41:35 -0700
Message-Id: <20130809013953.465282498@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809013949.226228694@linuxfoundation.org>
References: <20130809013949.226228694@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/usb/smsc75xx.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -43,7 +43,6 @@
 #define EEPROM_MAC_OFFSET		(0x01)
 #define DEFAULT_TX_CSUM_ENABLE		(true)
 #define DEFAULT_RX_CSUM_ENABLE		(true)
-#define DEFAULT_TSO_ENABLE		(true)
 #define SMSC75XX_INTERNAL_PHY_ID	(1)
 #define SMSC75XX_TX_OVERHEAD		(8)
 #define MAX_RX_FIFO_SIZE		(20 * 1024)
@@ -1034,17 +1033,14 @@ static int smsc75xx_bind(struct usbnet *
 
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
 
 	/* Init all registers */
 	ret = smsc75xx_reset(dev);
@@ -1169,8 +1165,6 @@ static struct sk_buff *smsc75xx_tx_fixup
 {
 	u32 tx_cmd_a, tx_cmd_b;
 
-	skb_linearize(skb);
-
 	if (skb_headroom(skb) < SMSC75XX_TX_OVERHEAD) {
 		struct sk_buff *skb2 =
 			skb_copy_expand(skb, SMSC75XX_TX_OVERHEAD, 0, flags);


