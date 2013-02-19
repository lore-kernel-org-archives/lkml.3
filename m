Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315Ab3BSSxN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:53:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298Ab3BSSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:53:08 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yan Burman <yanb@mellanox.com>, Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 49/81] net/mlx4_en: Fix bridged vSwitch configuration for non SRIOV mode
Date: Tue, 19 Feb 2013 15:49:12 -0300
Message-Id: <1361299784-8830-50-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yan Burman <yanb@mellanox.com>

commit 213815a1e6ae70b9648483b110bc5081795f99e8 upstream.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 019d856..8ba03c9 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -633,10 +633,15 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
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
1.7.9.5

