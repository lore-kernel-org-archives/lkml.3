Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab3DBAku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:40:50 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:58738 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757993Ab3DBAks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:40:48 -0400
Message-ID: <1364863243.3557.136.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] Fix IXP4xx coherent allocations
From: Ben Hutchings <bhutchings@solarflare.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <c.aeschlimann@acn-group.ch>
Date: Tue, 2 Apr 2013 01:40:43 +0100
In-Reply-To: <m3d2uexaxw.fsf@intrepid.localdomain>
References: <m3obe9lxil.fsf@intrepid.localdomain>
	 <20130323.195740.2108147521543354261.davem@davemloft.net>
	 <1364152267.3620.31.camel@deadeye.wl.decadent.org.uk>
	 <m3r4j4sdmv.fsf@intrepid.localdomain>
	 <20130330132915.GB17995@n2100.arm.linux.org.uk>
	 <m3d2uhdl1l.fsf@intrepid.localdomain>
	 <20130330153135.GC17995@n2100.arm.linux.org.uk>
	 <m3d2uexaxw.fsf@intrepid.localdomain>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19760.005
X-TM-AS-Result: No--36.208600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 22:17 +0200, Krzysztof Halasa wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> 
> > Right, so, the answer is - yes you are talking about platform devices,
> > and the reason that these aren't already set is because if you grep for
> > ixp4xx_eth or ixp4xx_hss in arch/arm/mach-ixp4xx, you'll notice that
> > _none_ of the device declarations set either of the DMA masks at all.
> > They don't even set the dev->dma_mask pointer.  That is why the masks
> > are zero.  For a device which does DMA, that is wrong.
> 
> Well, that's new to me. Please tell me how it should be done.
> Should I simply add in platform code (on all platforms):
> 
> +++ b/arch/arm/mach-ixp4xx/XXX.c
> @@ -380,10 +380,12 @@ static struct platform_device device_eth_tab[] = {
>          .name           = "ixp4xx_eth",
>          .id         = IXP4XX_ETH_NPEB,
>          .dev.platform_data  = eth_plat,
> +        .dev.coherent_dma_mask  = DMA_BIT_MASK(32),
>      }, {
>          .name           = "ixp4xx_eth",
>          .id         = IXP4XX_ETH_NPEC,
>          .dev.platform_data  = eth_plat + 1,
> +        .dev.coherent_dma_mask  = DMA_BIT_MASK(32),
>      }
>  };
> 
> This alone isn't going to work, the problem is coherent DMA mask in
> net_dev->dev and not in platform_device. So what do I do in the network
> drivers? Copy the masks from platform_device to the actual newly created
> net_dev->dev?
>
> Should I use the parent device (net_dev->dev.parent which is the
> platform_device) as the argument to the allocator? This would probably
> work though I'm not sure of its correctness.
[...]

Passing the parent device to DMA API functions seems to be the right
thing to do.  It's what you would do in a PCI device driver.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

