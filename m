Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558AbbAYTEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:04:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57411 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbbAYSJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        David Laight <david.laight@aculab.com>,
        Amir Vadai <amirv@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.18 014/183] net/mlx4_en: Doorbell is byteswapped in Little Endian archs
Date: Sun, 25 Jan 2015 10:05:36 -0800
Message-Id: <20150125180810.804001456@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Vadai <amirv@mellanox.com>

[ Upstream commit 492f5add4be84652bbe13da8a250d60c6856a5c5 ]

iowrite32() will byteswap it's argument on big endian archs.
iowrite32be() will byteswap on little endian archs.
Since we don't want to do this unnecessary byteswap on the fast path,
doorbell is stored in the NIC's native endianness. Using the right
iowrite() according to the arch endianness.

CC: Wei Yang <weiyang@linux.vnet.ibm.com>
CC: David Laight <david.laight@aculab.com>
Fixes: 6a4e812 ("net/mlx4_en: Avoid calling bswap in tx fast path")
Signed-off-by: Amir Vadai <amirv@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -954,7 +954,17 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff
 		tx_desc->ctrl.owner_opcode = op_own;
 		if (send_doorbell) {
 			wmb();
-			iowrite32(ring->doorbell_qpn,
+			/* Since there is no iowrite*_native() that writes the
+			 * value as is, without byteswapping - using the one
+			 * the doesn't do byteswapping in the relevant arch
+			 * endianness.
+			 */
+#if defined(__LITTLE_ENDIAN)
+			iowrite32(
+#else
+			iowrite32be(
+#endif
+				  ring->doorbell_qpn,
 				  ring->bf.uar->map + MLX4_SEND_DOORBELL);
 		} else {
 			ring->xmit_more++;


