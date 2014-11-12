Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952AbaKLBUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:20:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58388 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbaKLBUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:20:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 020/319] net/mlx4_en: Dont attempt to TX offload the outer UDP checksum for VXLAN
Date: Wed, 12 Nov 2014 10:12:38 +0900
Message-Id: <20141112010956.063479743@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

[ Upstream commit a4f2dacbf2a5045e34b98a35d9a3857800f25a7b ]

For VXLAN/NVGRE encapsulation, the current HW doesn't support offloading
both the outer UDP TX checksum and the inner TCP/UDP TX checksum.

The driver doesn't advertize SKB_GSO_UDP_TUNNEL_CSUM, however we are wrongly
telling the HW to offload the outer UDP checksum for encapsulated packets,
fix that.

Fixes: 837052d0ccc5 ('net/mlx4_en: Add netdev support for TCP/IP
		     offloads of vxlan tunneling')
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -808,8 +808,11 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff
 	tx_desc->ctrl.fence_size = (real_size / 16) & 0x3f;
 	tx_desc->ctrl.srcrb_flags = priv->ctrl_flags;
 	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
-		tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM |
-							 MLX4_WQE_CTRL_TCP_UDP_CSUM);
+		if (!skb->encapsulation)
+			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM |
+								 MLX4_WQE_CTRL_TCP_UDP_CSUM);
+		else
+			tx_desc->ctrl.srcrb_flags |= cpu_to_be32(MLX4_WQE_CTRL_IP_CSUM);
 		ring->tx_csum++;
 	}
 


