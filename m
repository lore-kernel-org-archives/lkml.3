Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3ERDI1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:08:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab3ERDAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:23 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=zrhU2d_gMaEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=EWVNVC7EjcwA:10 a=wMNdZWldAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=9JqjeM8GuxjQ_mRbtR8A:9 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=22jIUV9-6o7OjHRu:21 a=ElKhx2FUaTHmW046:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021655.896249455@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 088/136 ] net/eth/ibmveth: Fixup retrieval of MAC address
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0088-net-eth-ibmveth-Fixup-retrieval-of-MAC-address.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit 13f85203e1060da83d9ec1c1c5a63343eaab8de4 ]

Some ancient pHyp versions used to create a 8 bytes local-mac-address
property in the device-tree instead of a 6 bytes one for veth.

The Linux driver code to deal with that is an insane hack which also
happens to break with some choices of MAC addresses in qemu by testing
for a bit in the address rather than just looking at the size of the
property.

Sanitize this by doing the latter instead.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: <stable@vger.kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/ibm/ibmveth.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index b68d28a..33a1760 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1327,7 +1327,7 @@ static const struct net_device_ops ibmveth_netdev_ops = {
 static int __devinit ibmveth_probe(struct vio_dev *dev,
 				   const struct vio_device_id *id)
 {
-	int rc, i;
+	int rc, i, mac_len;
 	struct net_device *netdev;
 	struct ibmveth_adapter *adapter;
 	unsigned char *mac_addr_p;
@@ -1337,11 +1337,19 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 		dev->unit_address);
 
 	mac_addr_p = (unsigned char *)vio_get_attribute(dev, VETH_MAC_ADDR,
-							NULL);
+							&mac_len);
 	if (!mac_addr_p) {
 		dev_err(&dev->dev, "Can't find VETH_MAC_ADDR attribute\n");
 		return -EINVAL;
 	}
+	/* Workaround for old/broken pHyp */
+	if (mac_len == 8)
+		mac_addr_p += 2;
+	else if (mac_len != 6) {
+		dev_err(&dev->dev, "VETH_MAC_ADDR attribute wrong len %d\n",
+			mac_len);
+		return -EINVAL;
+	}
 
 	mcastFilterSize_p = (unsigned int *)vio_get_attribute(dev,
 						VETH_MCAST_FILTER_SIZE, NULL);
@@ -1366,17 +1374,6 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 
 	netif_napi_add(netdev, &adapter->napi, ibmveth_poll, 16);
 
-	/*
-	 * Some older boxes running PHYP non-natively have an OF that returns
-	 * a 8-byte local-mac-address field (and the first 2 bytes have to be
-	 * ignored) while newer boxes' OF return a 6-byte field. Note that
-	 * IEEE 1275 specifies that local-mac-address must be a 6-byte field.
-	 * The RPA doc specifies that the first byte must be 10b, so we'll
-	 * just look for it to solve this 8 vs. 6 byte field issue
-	 */
-	if ((*mac_addr_p & 0x3) != 0x02)
-		mac_addr_p += 2;
-
 	adapter->mac_addr = 0;
 	memcpy(&adapter->mac_addr, mac_addr_p, 6);
 
-- 
1.7.10.4


