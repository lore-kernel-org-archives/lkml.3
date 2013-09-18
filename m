Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365Ab3IRPWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 11:22:41 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:32832 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3IRPWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 11:22:39 -0400
Message-ID: <1379517747.1522.9.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [REGRESSION][BISECTED] skge: add dma_mapping check
From: Ben Hutchings <bhutchings@solarflare.com>
To: Stephen Hemminger <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC: Mirko Lindner <mlindner@marvell.com>, <linux-kernel@vger.kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>
Date: Wed, 18 Sep 2013 16:22:27 +0100
In-Reply-To: <1379494844.2294.12.camel@ThinkPad-X230.localdomain>
References: <1379494844.2294.12.camel@ThinkPad-X230.localdomain>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20158.002
X-TM-AS-Result: No--10.670400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 13:00 +0400, Igor Gnatenko wrote:
> Since 136d8f377e1575463b47840bc5f1b22d94bf8f63 commit we have kernel
> panic on:
[...]

At a first glance, it looks like this bit is wrong:

> @@ -3058,13 +3090,17 @@ static struct sk_buff *skge_rx_get(struct net_device *dev,
>  		if (!nskb)
>  			goto resubmit;
>  
> +		if (skge_rx_setup(skge, e, nskb, skge->rx_buf_size) < 0) {
> +			dev_kfree_skb(nskb);
> +			goto resubmit;
> +		}
> +
>  		pci_unmap_single(skge->hw->pdev,
>  				 dma_unmap_addr(e, mapaddr),
>  				 dma_unmap_len(e, maplen),
>  				 PCI_DMA_FROMDEVICE);
>  		skb = e->skb;
>  		prefetch(skb->data);
> -		skge_rx_setup(skge, e, nskb, skge->rx_buf_size);
>  	}
>  
>  	skb_put(skb, len);

That pci_unmap_single() appears to unmap the *new*, rather than old, DMA
mapping.  I think you need to copy out the old DMA address and length
before doing skge_rx_setup().

Try it with an IOMMU in strict mode (intel_iommu=on,strict or
amd_iommu=fullflush).

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

