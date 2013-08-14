Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab3HNKtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:49:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34578 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467Ab3HNKiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:01 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 43/75] usbnet: do not pretend to support SG/TSO
Date: Wed, 14 Aug 2013 11:36:32 +0100
Message-Id: <1376476624-10011-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit 20f0170377264e8449b6987041f0bcc4d746d3ed upstream.

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
[ luis: backported to 3.5:
  - adjusted context
  - dropped changes to ASIX AX88179/178A driver ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/smsc75xx.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 2e50fbb..c241ae7 100644
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
@@ -1053,17 +1052,14 @@ static int smsc75xx_bind(struct usbnet *dev, struct usb_interface *intf)
 
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
@@ -1188,8 +1184,6 @@ static struct sk_buff *smsc75xx_tx_fixup(struct usbnet *dev,
 {
 	u32 tx_cmd_a, tx_cmd_b;
 
-	skb_linearize(skb);
-
 	if (skb_headroom(skb) < SMSC75XX_TX_OVERHEAD) {
 		struct sk_buff *skb2 =
 			skb_copy_expand(skb, SMSC75XX_TX_OVERHEAD, 0, flags);
-- 
1.8.3.2

