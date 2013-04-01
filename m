Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab3DAURf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 16:17:35 -0400
Received: from inx.pm.waw.pl ([195.116.170.130]:47099 "EHLO inx.pm.waw.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756703Ab3DAURd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 16:17:33 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        c.aeschlimann@acn-group.ch
Subject: Re: [PATCH] Fix IXP4xx coherent allocations
References: <m3obe9lxil.fsf@intrepid.localdomain>
	<20130323.195740.2108147521543354261.davem@davemloft.net>
	<1364152267.3620.31.camel@deadeye.wl.decadent.org.uk>
	<m3r4j4sdmv.fsf@intrepid.localdomain>
	<20130330132915.GB17995@n2100.arm.linux.org.uk>
	<m3d2uhdl1l.fsf@intrepid.localdomain>
	<20130330153135.GC17995@n2100.arm.linux.org.uk>
Date: Mon, 01 Apr 2013 22:17:31 +0200
In-Reply-To: <20130330153135.GC17995@n2100.arm.linux.org.uk> (Russell King's
	message of "Sat, 30 Mar 2013 15:31:35 +0000")
Message-ID: <m3d2uexaxw.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> Right, so, the answer is - yes you are talking about platform devices,
> and the reason that these aren't already set is because if you grep for
> ixp4xx_eth or ixp4xx_hss in arch/arm/mach-ixp4xx, you'll notice that
> _none_ of the device declarations set either of the DMA masks at all.
> They don't even set the dev->dma_mask pointer.  That is why the masks
> are zero.  For a device which does DMA, that is wrong.

Well, that's new to me. Please tell me how it should be done.
Should I simply add in platform code (on all platforms):

+++ b/arch/arm/mach-ixp4xx/XXX.c
@@ -380,10 +380,12 @@ static struct platform_device device_eth_tab[] = {
         .name           = "ixp4xx_eth",
         .id         = IXP4XX_ETH_NPEB,
         .dev.platform_data  = eth_plat,
+        .dev.coherent_dma_mask  = DMA_BIT_MASK(32),
     }, {
         .name           = "ixp4xx_eth",
         .id         = IXP4XX_ETH_NPEC,
         .dev.platform_data  = eth_plat + 1,
+        .dev.coherent_dma_mask  = DMA_BIT_MASK(32),
     }
 };

This alone isn't going to work, the problem is coherent DMA mask in
net_dev->dev and not in platform_device. So what do I do in the network
drivers? Copy the masks from platform_device to the actual newly created
net_dev->dev?

Should I use the parent device (net_dev->dev.parent which is the
platform_device) as the argument to the allocator? This would probably
work though I'm not sure of its correctness.

BTW the platform code shouldn't IMHO need to declare the masks as they
aren't platform-specific. They are driver-specific (defined by CPU
design) and setting them in the driver seems clean to me (unlike the
platform code).

Several other device drivers simply set their masks directly. Is it the
recommended way?

> If you look at the PCI code, it pre-initializes the DMA mask to be 4GiB:
> drivers/pci/probe.c:        dev->dev.coherent_dma_mask = 0xffffffffull;
>
> And that is what is missing from the IXP4xx platform code.
>
> However, avoiding the call to dma_set_coherent_mask() from within the
> driver also seems to be questionable as it bypasses the "check if the
> mask is possible" part of the DMA API.

I thought about this for a second but the situation is the mask
is guaranteed to be valid (these are on-chip devices).
-- 
Krzysztof Halasa
