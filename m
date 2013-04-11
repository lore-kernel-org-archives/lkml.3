Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422767Ab3DKV13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:27:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20734 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935291Ab3DKUso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:48:44 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=JBjWEgReoVwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=isdH_D3Cl94A:10 a=A5s3B-U6AAAA:8 a=J1Y8HTJGAAAA:8 a=jxmzqFaGyG0Eqw49Wu4A:9 a=11TNX-_U9X8A:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=ww_kWFq1BvpRb_q_:21 a=DjLwqR7_kY4omhe0:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202614.090975420@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:27:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 170/171 ] smsc75xx: fix jumbo frame support
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0170-smsc75xx-fix-jumbo-frame-support.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/usb/smsc75xx.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index 376143e..0d9a895 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -724,8 +724,12 @@ static int smsc75xx_set_rx_max_frame_length(struct usbnet *dev, int size)
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
@@ -983,7 +987,7 @@ static int smsc75xx_reset(struct usbnet *dev)
 
 	netif_dbg(dev, ifup, dev->net, "FCT_TX_CTL set to 0x%08x", buf);
 
-	ret = smsc75xx_set_rx_max_frame_length(dev, 1514);
+	ret = smsc75xx_set_rx_max_frame_length(dev, dev->net->mtu + ETH_HLEN);
 	check_warn_return(ret, "Failed to set max rx frame length");
 
 	ret = smsc75xx_read_reg(dev, MAC_RX, &buf);
@@ -1127,8 +1131,8 @@ static int smsc75xx_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
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
-- 
1.7.10.4


