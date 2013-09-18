Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab3IRWIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:08:30 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:50138 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3IRWI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:08:29 -0400
Date: Thu, 19 Sep 2013 00:08:19 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Igor Gnatenko <i.gnatenko.brain@gmail.com>
Cc: Mirko Lindner <mlindner@marvell.com>, linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org,
        Joseph Salisbury <joseph.salisbury@canonical.com>,
        member graysky <graysky@archlinux.us>
Subject: Re: [REGRESSION][BISECTED] skge: add dma_mapping check
Message-ID: <20130918220819.GA11989@electric-eye.fr.zoreil.com>
References: <1379494844.2294.12.camel@ThinkPad-X230.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379494844.2294.12.camel@ThinkPad-X230.localdomain>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Gnatenko <i.gnatenko.brain@gmail.com> :
> Since 136d8f377e1575463b47840bc5f1b22d94bf8f63 commit we have kernel
> panic on:
> 01:05.0 Ethernet controller [0200]: Marvell Technology Group Ltd.
> 
> Screen: https://www.dropbox.com/s/mu3t3wxpxbn4ou5/IMAG0507.jpg
> 
> RHBZ: https://bugzilla.redhat.com/show_bug.cgi?id=1008323

Does the ugly stuff below against mainline make a difference ?

Note to testers: use a size argument above 500 for 'ping' to
exercize the relevant code path.

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index ef94a59..aa85a3f 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3086,6 +3086,7 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
 					       PCI_DMA_FROMDEVICE);
 		skge_rx_reuse(e, skge->rx_buf_size);
 	} else {
+		struct skge_element ee = *e;
 		struct sk_buff *nskb;
 
 		nskb = netdev_alloc_skb_ip_align(dev, skge->rx_buf_size);
@@ -3098,10 +3099,10 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
 		}
 
 		pci_unmap_single(skge->hw->pdev,
-				 dma_unmap_addr(e, mapaddr),
-				 dma_unmap_len(e, maplen),
+				 dma_unmap_addr(&ee, mapaddr),
+				 dma_unmap_len(&ee, maplen),
 				 PCI_DMA_FROMDEVICE);
-		skb = e->skb;
+		skb = ee.skb;
 		prefetch(skb->data);
 	}
 
