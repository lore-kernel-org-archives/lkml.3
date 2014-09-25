Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694AbaIYPPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:15:30 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59684 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaIYPP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:15:29 -0400
Date: Thu, 25 Sep 2014 15:15:19 +0000
From: "Sylvain 'ythier' Hitier" <sylvain.hitier@gmail.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Meelis Roos <mroos@linux.ee>
Subject: [PATCH v2] 3c59x: fix bad split of cpu_to_le32(pci_map_single())
Message-ID: <20140925151519.GA12225@erable>
References: <20140924093021.GA7929@erable>
 <20140924101647.GA4651@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924101647.GA4651@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When: 2014-09-24_3@06-16-47 -0400
Who:  Neil Horman
What:
> You do probably want to fixup
> the changelog to be a bit more clear as to whats going on here.

Date:   Wed Sep 24 09:22:16 2014 +0000

3c59x: fix bad split of cpu_to_le32(pci_map_single())

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

Fixes: 6f2b6a3005b2c34c39f207a87667564f64f2f91a
  # 3c59x: Add dma error checking and recovery
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Sylvain "ythier" Hitier <sylvain.hitier@gmail.com>
---
 drivers/net/ethernet/3com/3c59x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/3com/3c59x.c b/drivers/net/ethernet/3com/3c59x.c
index 8ca49f04..0a3108b3 100644
--- a/drivers/net/ethernet/3com/3c59x.c
+++ b/drivers/net/ethernet/3com/3c59x.c
@@ -2214,7 +2214,7 @@ boomerang_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 #else
-	dma_addr = cpu_to_le32(pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE));
+	dma_addr = pci_map_single(VORTEX_PCI(vp), skb->data, skb->len, PCI_DMA_TODEVICE);
 	if (dma_mapping_error(&VORTEX_PCI(vp)->dev, dma_addr))
 		goto out_dma_err;
 	vp->tx_ring[entry].addr = cpu_to_le32(dma_addr);

Regards,
Sylvain "ythier" Hitier

-- 
Business is about being busy, not being rich...
Lived 777 days in a Debian package => http://en.wikipedia.org/wiki/Apt,_Vaucluse
There's THE room for ideals in this mechanical place!
