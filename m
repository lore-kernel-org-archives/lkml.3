Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaJMCag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 22:30:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46199 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727AbaJMCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 22:30:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>,
        "=?UTF-8?q?Sylvain=20 \"ythier\" =20Hitier?=" 
	<sylvain.hitier@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 06/25] 3c59x: fix bad split of cpu_to_le32(pci_map_single())
Date: Mon, 13 Oct 2014 04:24:59 +0200
Message-Id: <20141013022454.557344773@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141013022454.289398272@linuxfoundation.org>
References: <20141013022454.289398272@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Sylvain \\\"ythier\\\" Hitier" <sylvain.hitier@gmail.com>

[ Upstream commit 88b09a6d958af6c458acf055ee2eb5bc9564efda ]

In commit 6f2b6a3005b2c34c39f207a87667564f64f2f91a,
  # 3c59x: Add dma error checking and recovery
the intent is to split out the mapping from the byte-swapping in order to
insert a dma_mapping_error() check.

Kinda this semantic patch:

    // See http://coccinelle.lip6.fr/
    //
    // Beware, grouik-and-dirty!
    @@
    expression DEV, X, Y, Z;
    @@
    -   cpu_to_le32(pci_map_single(DEV, X, Y, Z))
    +   dma_addr_t addr = pci_map_single(DEV, X, Y, Z);
    +   if (dma_mapping_error(&DEV->dev, addr))
    +       /* snip */;
    +   cpu_to_le32(addr)

However, the #else part (of the #if DO_ZEROCOPY test) is changed this way:

    -   cpu_to_le32(pci_map_single(DEV, X, Y, Z))
    +   dma_addr_t addr = cpu_to_le32(pci_map_single(DEV, X, Y, Z));
    //                    ^^^^^^^^^^^
    //                    That mismatches the 3 other changes!
    +   if (dma_mapping_error(&DEV->dev, addr))
    +       /* snip */;
    +   cpu_to_le32(addr)

Let's remove the leftover cpu_to_le32() for coherency.

v2: Better changelog.
v3: Add Acked-by

Fixes: 6f2b6a3005b2c34c39f207a87667564f64f2f91a
  # 3c59x: Add dma error checking and recovery
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/3com/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2214,7 +2214,7 @@ boomerang_start_xmit(struct sk_buff *skb
 		}
 	}
 #else
-	dma_addr = cpu_to_le32(pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE));
+	dma_addr = pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE);
 	if (dma_mapping_error(&VORTEX_PCI(vp)->dev, dma_addr))
 		goto out_dma_err;
 	vp->tx_ring[entry].addr = cpu_to_le32(dma_addr);


