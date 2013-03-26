Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759919Ab3CZSAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 14:00:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31989 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929Ab3CZRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:05 -0400
X-Authority-Analysis: v=2.0 cv=BZhaI8R2 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=VIEMLKkSXxQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=zJevVm7YZ_UA:10 a=CbDCq_QkAAAA:8 a=J1Y8HTJGAAAA:8 a=kWDgOHFhbxVf0gkMJRgA:9 a=E3yz0KKPV6YA:10 a=4N9Db7Z2_RYA:10 a=uA1z-oN-uQlDX4N1:21 a=gbJC4E-X5ZUZjFls:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173601.894860524@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:12 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Yan Burman <yanb@mellanox.com>,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 13/86] net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0013-net-mlx4_en-Fix-bridged-vSwitch-configuration-for-no.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yan Burman <yanb@mellanox.com>

[ Upstream commit 213815a1e6ae70b9648483b110bc5081795f99e8 ]

Commit 5b4c4d36860e "mlx4_en: Allow communication between functions on
same host" introduced a regression under which a bridge acting as vSwitch
whose uplink is an mlx4 Ethernet device become non-operative in native
(non sriov) mode. This happens since broadcast ARP requests sent by VMs
were loopback-ed by the HW and hence the bridge learned VM source MACs
on both the VM and the uplink ports.

The fix is to place the DMAC in the send WQE only under SRIOV/eSwitch
configuration or when the device is in selftest.

Reviewed-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yan Burman <yanb@mellanox.com>
Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 10bba09..2af24ba 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -630,10 +630,15 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		ring->tx_csum++;
 	}
 
-	/* Copy dst mac address to wqe */
-	ethh = (struct ethhdr *)skb->data;
-	tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
-	tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
+	if (mlx4_is_mfunc(mdev->dev) || priv->validate_loopback) {
+		/* Copy dst mac address to wqe. This allows loopback in eSwitch,
+		 * so that VFs and PF can communicate with each other
+		 */
+		ethh = (struct ethhdr *)skb->data;
+		tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
+		tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
+	}
+
 	/* Handle LSO (TSO) packets */
 	if (lso_header_size) {
 		/* Mark opcode as LSO */
-- 
1.7.10.4


