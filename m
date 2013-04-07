Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518Ab3DGWzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 18:55:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46325 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934447Ab3DGWzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 18:55:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Steve Glendinning" <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>
Date: Sun, 07 Apr 2013 23:45:43 +0100
Message-ID: <lsq.1365374743.251365964@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [72/74] smsc75xx: fix jumbo frame support
In-Reply-To: <lsq.1365374742.214522651@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:b4b3:7e2a:e2d0:3478
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.43-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Glendinning <steve.glendinning@shawell.net>

[ Upstream commit 4c51e53689569398d656e631c17308d9b8e84650 ]

This patch enables RX of jumbo frames for LAN7500.

Previously the driver would transmit jumbo frames succesfully but
would drop received jumbo frames (incrementing the interface errors
count).

With this patch applied the device can succesfully receive jumbo
frames up to MTU 9000 (9014 bytes on the wire including ethernet
header).

Signed-off-by: Steve Glendinning <steve.glendinning@shawell.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/usb/smsc75xx.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 7bd219b..f3d17f8 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -720,8 +720,12 @@ static int smsc75xx_set_rx_max_frame_length(struct usbnet *dev, int size)
 static int smsc75xx_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct usbnet *dev = netdev_priv(netdev);
+	int ret;
+
+	if (new_mtu > MAX_SINGLE_PACKET_SIZE)
+		return -EINVAL;
 
-	int ret = smsc75xx_set_rx_max_frame_length(dev, new_mtu);
+	ret = smsc75xx_set_rx_max_frame_length(dev, new_mtu + ETH_HLEN);
 	check_warn_return(ret, "Failed to set mac rx frame length");
 
 	return usbnet_change_mtu(netdev, new_mtu);
@@ -965,7 +969,7 @@ static int smsc75xx_reset(struct usbnet *dev)
 
 	netif_dbg(dev, ifup, dev->net, "FCT_TX_CTL set to 0x%08x", buf);
 
-	ret = smsc75xx_set_rx_max_frame_length(dev, 1514);
+	ret = smsc75xx_set_rx_max_frame_length(dev, dev->net->mtu + ETH_HLEN);
 	check_warn_return(ret, "Failed to set max rx frame length");
 
 	ret = smsc75xx_read_reg(dev, MAC_RX, &buf);
@@ -1109,8 +1113,8 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			else if (rx_cmd_a & (RX_CMD_A_LONG | RX_CMD_A_RUNT))
 				dev->net->stats.rx_frame_errors++;
 		} else {
-			/* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (ETH_FRAME_LEN + 12))) {
+			/* MAX_SINGLE_PACKET_SIZE + 4(CRC) + 2(COE) + 4(Vlan) */
+			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12))) {
 				netif_dbg(dev, rx_err, dev->net,
 					"size err rx_cmd_a=0x%08x", rx_cmd_a);
 				return 0;

