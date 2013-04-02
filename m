Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab3DBWeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:34:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535Ab3DBWNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:13:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 124/124] smsc75xx: fix jumbo frame support
Date: Tue,  2 Apr 2013 15:11:46 -0700
Message-Id: <20130402221118.571289096@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130402221104.163133110@linuxfoundation.org>
References: <20130402221104.163133110@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/smsc75xx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -914,8 +914,12 @@ static int smsc75xx_set_rx_max_frame_len
 static int smsc75xx_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct usbnet *dev = netdev_priv(netdev);
+	int ret;
+
+	if (new_mtu > MAX_SINGLE_PACKET_SIZE)
+		return -EINVAL;
 
-	int ret = smsc75xx_set_rx_max_frame_length(dev, new_mtu);
+	ret = smsc75xx_set_rx_max_frame_length(dev, new_mtu + ETH_HLEN);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Failed to set mac rx frame length\n");
 		return ret;
@@ -1324,7 +1328,7 @@ static int smsc75xx_reset(struct usbnet
 
 	netif_dbg(dev, ifup, dev->net, "FCT_TX_CTL set to 0x%08x\n", buf);
 
-	ret = smsc75xx_set_rx_max_frame_length(dev, 1514);
+	ret = smsc75xx_set_rx_max_frame_length(dev, dev->net->mtu + ETH_HLEN);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Failed to set max rx frame length\n");
 		return ret;
@@ -2136,8 +2140,8 @@ static int smsc75xx_rx_fixup(struct usbn
 			else if (rx_cmd_a & (RX_CMD_A_LONG | RX_CMD_A_RUNT))
 				dev->net->stats.rx_frame_errors++;
 		} else {
-			/* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
-			if (unlikely(size > (ETH_FRAME_LEN + 12))) {
+			/* MAX_SINGLE_PACKET_SIZE + 4(CRC) + 2(COE) + 4(Vlan) */
+			if (unlikely(size > (MAX_SINGLE_PACKET_SIZE + ETH_HLEN + 12))) {
 				netif_dbg(dev, rx_err, dev->net,
 					  "size err rx_cmd_a=0x%08x\n",
 					  rx_cmd_a);


