Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3KNQBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:01:46 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:49719 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880Ab3KNQBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:01:38 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Florian Meier <florian.meier@koalo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4] dmaengine: Add support for BCM2835
Date: Thu, 14 Nov 2013 17:01:35 +0100
Message-ID: <2385512.qcT1vt8HYp@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CABDT8WyUH=z67_bOy-DF9NQn6R0eKsGJPDWSwijrhLRyNLvaSQ@mail.gmail.com>
References: <5283BC93.1090801@koalo.de> <4043887.oz5IYRs5go@flatron> <CABDT8WyUH=z67_bOy-DF9NQn6R0eKsGJPDWSwijrhLRyNLvaSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 of November 2013 16:41:56 Florian Meier wrote:
> 2013/11/14 Tomasz Figa <tomasz.figa@gmail.com>:
> > On Thursday 14 of November 2013 15:44:05 Florian Meier wrote:
> >> 2013/11/14 Tomasz Figa <tomasz.figa@gmail.com>:
> >> > On Thursday 14 of November 2013 08:12:46 Florian Meier wrote:
> >> >> On 13.11.2013 21:39, Tomasz Figa wrote:
> >> >> > On Wednesday 13 of November 2013 20:35:22 Florian Meier wrote:
> >> >> >>>> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
> >> >> >>>> new file mode 100644
> >> >> >>>> index 0000000..baf072e
> >> >> >>>> --- /dev/null
> >> >> >>>> +++ b/drivers/dma/bcm2835-dma.c
> >> >> >>> [snip]
> >> >> >>>> +static int bcm2835_dma_probe(struct platform_device *pdev)
> >> >> >>>> +{
> >> >> >>>> +        struct bcm2835_dmadev *od;
> >> >> >>>> +        struct resource *dma_res = NULL;
> >> >> >>>> +        void __iomem *dma_base = NULL;
> >> >> >>>> +        int rc = 0;
> >> >> >>>> +        int i = 0;
> >> >> >>>> +        int irq;
> >> >> >>>> +        uint32_t chans_available;
> >> >> >>> [snip]
> >> >> >>>> +        if (pdev->dev.of_node) {
> >> >> >>>
> >> >> >>> Is this driver supposed to support non-DT based instantation (aka board
> >> >> >>> files)? If not, maybe it would be cleaner to simply check for
> >> >> >>> !pdev->dev.of_node at the beginning of probe and return an error?
> >> >> >>
> >> >> >> I would like to maintain the possibility for board file based
> >> >> >> instatiation, because the Raspberry Pi downstream kernel still doesn't
> >> >> >> support device tree. If this is a no-go, I will accept that.
> >> >> >
> >> >> > Sure, you are free to do so.
> >> >> >
> >> >> > What I meant is that your probe won't call bcm2835_dma_chan_init() at all
> >> >> > if there is no pdev->dev.of_node, because the loop iterating over channels
> >> >> > is under the if clause.
> >> >>
> >> >> Yes you are right, but I think it will make the patching easier, later.
> >> >> Currently, nothing bad happens without device tree - it just allocates
> >> >> no channels.
> >> >
> >> > But isn't it really an error condition, if no channels are allocated?
> >>
> >> A fridge is still a working fridge, even if no beer is inside ;-)
> >> Ok, bad example, but you will get an error message anyway when you try
> >> to get a channel.
> >>
> >> > Anyway, back to my point about leaving non-DT support in a driver, the
> >> > point is still valid only for drivers, not for platforms/boards. So if
> >> > there are no boards supported using board files in mainline that could
> >> > benefit from this driver, then this driver can be safely made DT-only,
> >> > because no new non-DT platforms/boards can be added.
> >>
> >> I don't have a telling argument against this, but just thought writing
> >> it this way will
> >> make the migration of the downstream kernel to upstream easier, but if you say I
> >> should change it, I will of course do that.
> >
> > I'm just presenting you the possible options. You are still free to have
> > non-DT support in the driver, but if you don't need it (because you can't
> > have any new non-DT platforms in mainline) then you can simplify some
> > code.
> >
> > However the driver shouldn't be left with illusionary support for non-DT
> > platforms until you decide to implement that. Instead, if you don't want
> > to add non-DT support now, just make the driver DT-only, while keeping
> > its design in a way allowing you to add non-DT support in future.
> 
> This statement hits the nail on the head. Thank you!
> 
> > In other words, a driver should not be able to probe using board files
> > if support for such probing method is not available in it yet.
> 
> That is meaningful. So would the following be ok?
> 
> + .....
> +       if (pdev->dev.of_node) {
> + .....
> +       } else {
> +               dev_err(&pdev->dev,
> +                       "Failed to initialize channels, because device
> tree not available: %d\n", rc);
> +               bcm2835_dma_free(od);
> +               return rc;
> +      }
> +
> +       dev_dbg(&pdev->dev, "Initialized %i DMA channels\n", i);
> +
> + .....
> 

I mean, something closer to:

static int bcm2835_dma_probe(struct platform_device *pdev)
{
	uint32_t chan_mask;
	// ...

	if (pdev->dev.of_node) {
		rc = of_property_read_u32(..., &chan_mask);
		if (rc) {
			// Error out
		}
	} else {
		// Error message
		return -EINVAL;
	}

	// ...
	// Channel registration loop (independent of any OF functions)
	// ...

	if (pdev->dev.of_node) {
		rc = of_dma_controller_register(...);
		// ...
	}

	// ...
}

> >> I am becoming desperate anyway that this migration will ever fully
> >> take place....
> >
> > Why not? It's just a matter of people like you working on this (and
> > addressing some review comments ;)).
> 
> The most common comment about this is that people will not put effort in
> the upstream kernel as long as there is no comfortable way for debugging
> in the upstream kernel (i.e. at least USB support).......

Right, you need USB to have ethernet working. Still, IMHO UART (for
console) + ethernet (for file transfer or NFS root) is the reasonable
setup allowing you to debug further drivers in a comfortable way.

Best regards,
Tomasz

