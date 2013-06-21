Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161574Ab3FUQFT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 12:05:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49002 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161419Ab3FUQFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 12:05:18 -0400
Message-ID: <1371830716.19215.37.camel@joe-AO722>
Subject: Re: [PATCH v7] ethernet/arc/arc_emac - Add new driver
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Florian Fainelli <florian@openwrt.org>
Date: Fri, 21 Jun 2013 09:05:16 -0700
In-Reply-To: <201306211758.26094.arnd@arndb.de>
References: <1371799241-27771-1-git-send-email-abrodkin@synopsys.com>
	 <4881796E12491D4BB15146FE0209CE643F5F587E@DE02WEMBXB.internal.synopsys.com>
	 <1371825813.19215.34.camel@joe-AO722> <201306211758.26094.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 17:58 +0200, Arnd Bergmann wrote:
> On Friday 21 June 2013, Joe Perches wrote:
> > On Fri, 2013-06-21 at 10:53 +0000, Alexey Brodkin wrote:
> > > On 06/21/2013 02:32 PM, Joe Perches wrote:
> > > > On Fri, 2013-06-21 at 11:20 +0400, Alexey Brodkin wrote:
> > > >> Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
> > > >> instantiated in some legacy ARC (Synopsys) FPGA Boards such as
> > > >> ARCAngel4/ML50x.
> > []
> > > >> +          rxbd->data = (unsigned char *)cpu_to_le32(rx_buff->skb->data);
> > > >
> > > > 32 bit only.  Should the Kconfig block have some arch_arc dependency
> > > > so it can't get compiled for 64 bit systems?
> > []
> > > So for now I may easily add dependency on ARC if it makes acceptance of 
> > > driver easier.
> > 
> > I don't think it's a big problem.
> > 
> > Maybe add a Kconfig "depends on !64BIT".
> > 
> > Another thing to do would be to run it through sparse
> > with make C=1
> 
> No, I think the driver should just be made 64-bit clean. Not because
> anyone is going to need that of course, but to avoid having
> to add silly dependencies.
> 
> The problem is that rxbd->data is the wrong type. It is declared
> as a void*, but it is not a kernel pointer at all, it is a DMA
> pointer. Look at this code in context:

So it should be declared dma_addr_t then,

> +               addr = dma_map_single(&ndev->dev, (void *)rx_buff->skb->data,
> +                                     buflen, DMA_FROM_DEVICE);
> +               if (dma_mapping_error(&ndev->dev, addr)) {
> +                       if (net_ratelimit())
> +                               netdev_err(ndev, "cannot dma map\n");
> +                       dev_kfree_skb(rx_buff->skb);
> +                       stats->rx_errors++;
> +                       continue;
> +               }
> +               dma_unmap_addr_set(&rx_buff, mapping, addr);
> +               dma_unmap_len_set(&rx_buff, len, buflen);
> +
> +               rxbd->data = (unsigned char *)cpu_to_le32(rx_buff->skb->data);
> 
> the 'addr' returned by dma_map_single is what the device really
> needs, although it is the same as rx_buff->skb->data with the
> trivial definition of dma_map_single.
> 
> The last line here needs to be
>                 rxbd->data = cpu_to_le32(addr);
> 
> which fixes the bug, and has no dependency on a 32 bit CPU.

It still has a dependency on dma_addr_t size being 32 bit



