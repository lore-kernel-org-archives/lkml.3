Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab3KNPBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:01:20 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46909 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab3KNPBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:01:12 -0500
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
Date: Thu, 14 Nov 2013 16:01:10 +0100
Message-ID: <4043887.oz5IYRs5go@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <CABDT8Wz4r0iN-Ady41tpdZgPF1wC=Qap5_jNGmKbSYQmRdPAHg@mail.gmail.com>
References: <5283BC93.1090801@koalo.de> <5235663.VIm8z9qphx@flatron> <CABDT8Wz4r0iN-Ady41tpdZgPF1wC=Qap5_jNGmKbSYQmRdPAHg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 of November 2013 15:44:05 Florian Meier wrote:
> 2013/11/14 Tomasz Figa <tomasz.figa@gmail.com>:
> > On Thursday 14 of November 2013 08:12:46 Florian Meier wrote:
> >> On 13.11.2013 21:39, Tomasz Figa wrote:
> >> > On Wednesday 13 of November 2013 20:35:22 Florian Meier wrote:
> >> >>>> +- brcm,dma-channel-mask: Bit mask representing the channels available.
> >> >>>
> >> >>> What does the value of this property depend on? Could you describe the
> >> >>> structure of this DMA controller?
> >> >>>
> >> >>>> +
> >> >>>> +Example:
> >> >>>> +
> >> >>>> +dma: dma@7e007000 {
> >> >>>> +        compatible = "brcm,bcm2835-dma";
> >> >>>> +        reg = <0x7e007000 0xf00>;
> >> >>>> +        interrupts = <1 16
> >> >>>> +                      1 17
> >> >>>> +                      1 18
> >> >>>> +                      1 19
> >> >>>> +                      1 20
> >> >>>> +                      1 21
> >> >>>> +                      1 22
> >> >>>> +                      1 23
> >> >>>> +                      1 24
> >> >>>> +                      1 25
> >> >>>> +                      1 26
> >> >>>> +                      1 27
> >> >>>> +                      1 28>;
> >> >>>
> >> >>> There are 13 interrupts specified here, but...
> >> >>>
> >> >>>> +
> >> >>>> +        #dma-cells = <1>;
> >> >>>> +        dma-channels = <16>;
> >> >>>
> >> >>> ...16 channels here...
> >> >>>
> >> >>>> +        dma-requests = <32>;
> >> >>>> +        brcm,dma-channel-mask = <0x7f35>;
> >> >>>
> >> >>> ...and 11 set bits here. May I ask you to explain this to me, please?
> >> >>
> >> >> How I understand this DMA controller:
> >> >> There are 16 DMA channels in the DMA controller, but only 13 interrupts
> >> >> are available at the IRQ controller. Therefore, the upper DMA channels
> >> >> can just not be used. Maybe because there are to many other IRQs and
> >> >> they didn't want to implement another IRQ bank.
> >> >> Furthermore, some of the DMA channels are already used by the
> >> >> VideoCore/GPU/firmware. This is what dma-channel-mask indicates. This
> >> >> should be automatically set by the firmware in the future.
> >> >> Finally, there are some channels with special functionality that should
> >> >> not be used by DMA engine, too. Therefore, these lines:
> >> >>            /* do not use the FIQ and BULK channels */
> >> >>            chans_available &= ~0xD;
> >> >
> >> > OK, this makes it much more clear.
> >> >
> >> > So, my only comment remaining here is that you shouldn't include the
> >> > channels without interrupt signal in the mask. This would allow you
> >> > to define it as a mask of channels that are operable and then just
> >> > iterate over all set bits in the driver, instead of using tricks with
> >> > interrupt resources. What do you think?
> >>
> >> Since the mask will come directly from the firmware, this would require
> >> patching the firmware. I think that is not worth the effort.
> >
> > Now I'm slightly confused. Do you already have code in your firmware that
> > adds this property to your device tree?
> >
> > Otherwise in what circumstances such patching would take place? On given
> > hardware (unless it's an FPGA) the configuration of available DMA channels
> > that have interrupt signals should not change.
> 
> It is very confusing. I agree.
> There is already a DMA driver with a proprietary API in the downstream
> kernel. The firmware already creates this mask and passes it to this
> proprietary driver.
> There was already a discussion about this in the first version thread
> that (as long as I understand it) resulted in "we should pass this
> mask on to the driver via device tree". So I did that. I have no idea
> about how this firmware->devicetree interface will take place, but
> since I didn't want to run in circles I hardcoded it in the device
> tree.
> 

OK. So the firmware defines what set and clear bits in the mask mean.
It's fine then.

> 
> >> >>> [snip]
> >> >>>> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
> >> >>>> new file mode 100644
> >> >>>> index 0000000..baf072e
> >> >>>> --- /dev/null
> >> >>>> +++ b/drivers/dma/bcm2835-dma.c
> >> >>> [snip]
> >> >>>> +static int bcm2835_dma_probe(struct platform_device *pdev)
> >> >>>> +{
> >> >>>> +        struct bcm2835_dmadev *od;
> >> >>>> +        struct resource *dma_res = NULL;
> >> >>>> +        void __iomem *dma_base = NULL;
> >> >>>> +        int rc = 0;
> >> >>>> +        int i = 0;
> >> >>>> +        int irq;
> >> >>>> +        uint32_t chans_available;
> >> >>> [snip]
> >> >>>> +        if (pdev->dev.of_node) {
> >> >>>
> >> >>> Is this driver supposed to support non-DT based instantation (aka board
> >> >>> files)? If not, maybe it would be cleaner to simply check for
> >> >>> !pdev->dev.of_node at the beginning of probe and return an error?
> >> >>
> >> >> I would like to maintain the possibility for board file based
> >> >> instatiation, because the Raspberry Pi downstream kernel still doesn't
> >> >> support device tree. If this is a no-go, I will accept that.
> >> >
> >> > Sure, you are free to do so.
> >> >
> >> > What I meant is that your probe won't call bcm2835_dma_chan_init() at all
> >> > if there is no pdev->dev.of_node, because the loop iterating over channels
> >> > is under the if clause.
> >>
> >> Yes you are right, but I think it will make the patching easier, later.
> >> Currently, nothing bad happens without device tree - it just allocates
> >> no channels.
> >
> > But isn't it really an error condition, if no channels are allocated?
> 
> A fridge is still a working fridge, even if no beer is inside ;-)
> Ok, bad example, but you will get an error message anyway when you try
> to get a channel.
> 
> > Anyway, back to my point about leaving non-DT support in a driver, the
> > point is still valid only for drivers, not for platforms/boards. So if
> > there are no boards supported using board files in mainline that could
> > benefit from this driver, then this driver can be safely made DT-only,
> > because no new non-DT platforms/boards can be added.
> 
> I don't have a telling argument against this, but just thought writing
> it this way will
> make the migration of the downstream kernel to upstream easier, but if you say I
> should change it, I will of course do that.

I'm just presenting you the possible options. You are still free to have
non-DT support in the driver, but if you don't need it (because you can't
have any new non-DT platforms in mainline) then you can simplify some
code.

However the driver shouldn't be left with illusionary support for non-DT
platforms until you decide to implement that. Instead, if you don't want
to add non-DT support now, just make the driver DT-only, while keeping
its design in a way allowing you to add non-DT support in future.

In other words, a driver should not be able to probe using board files
if support for such probing method is not available in it yet.

> I am becoming desperate anyway that this migration will ever fully
> take place....

Why not? It's just a matter of people like you working on this (and
addressing some review comments ;)).

Best regards,
Tomasz

