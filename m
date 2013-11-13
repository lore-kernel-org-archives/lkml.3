Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3KMTf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 14:35:56 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:43842 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3KMTft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 14:35:49 -0500
Message-ID: <5283D47A.7060503@koalo.de>
Date: Wed, 13 Nov 2013 20:35:22 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv4] dmaengine: Add support for BCM2835
References: <5283BC93.1090801@koalo.de> <3722902.ByNK8Ptc5Y@flatron>
In-Reply-To: <3722902.ByNK8Ptc5Y@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.2013 19:43, Tomasz Figa wrote:
> Hi Florian,
> 
> Seems like I accidentally replied to some old version of this patch.
> Not sure how many of those comments were still relevant for V3, but
> let me look at this version and see whether we can still improve things
> a bit. Please see my comments inline.

Some were still helpful (especially the idea to use the chan_init
function for setting the irq), thanks.

>> ....
>> diff --git a/Documentation/devicetree/bindings/dma/bcm2835-dma.txt b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
>> new file mode 100644
>> index 0000000..bca5e84
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
>> @@ -0,0 +1,59 @@
>> +* BCM2835 DMA controller
>> +
>> +Required properties:
>> +- compatible: Should be "brcm,bcm2835-dma".
>> +- reg: Should contain DMA registers location and length.
>> +- interrupts: Should contain the DMA interrupts associated
>> +		to the DMA channels in ascending order.
>> +		First cell is the IRQ bank.
>> +		Second cell is the IRQ number.
>> +- #dma-cells: Must be <1>, used to represent the number of integer cells in
>> +		the dmas property of client devices.
>> +- dma-channels: Maximum number of DMA channels available.
>> +- dma-requests: Number of DMA Requests.
> 
> The two properties above do not seem to be used anywhere in the driver.

Aren't they necessary for the DMA engine core?

>> +- brcm,dma-channel-mask: Bit mask representing the channels available.
> 
> What does the value of this property depend on? Could you describe the
> structure of this DMA controller?
> 
>> +
>> +Example:
>> +
>> +dma: dma@7e007000 {
>> +	compatible = "brcm,bcm2835-dma";
>> +	reg = <0x7e007000 0xf00>;
>> +	interrupts = <1 16
>> +		      1 17
>> +		      1 18
>> +		      1 19
>> +		      1 20
>> +		      1 21
>> +		      1 22
>> +		      1 23
>> +		      1 24
>> +		      1 25
>> +		      1 26
>> +		      1 27
>> +		      1 28>;
> 
> There are 13 interrupts specified here, but...
> 
>> +
>> +	#dma-cells = <1>;
>> +	dma-channels = <16>;
> 
> ...16 channels here...
> 
>> +	dma-requests = <32>;
>> +	brcm,dma-channel-mask = <0x7f35>;
> 
> ...and 11 set bits here. May I ask you to explain this to me, please?

How I understand this DMA controller:
There are 16 DMA channels in the DMA controller, but only 13 interrupts
are available at the IRQ controller. Therefore, the upper DMA channels
can just not be used. Maybe because there are to many other IRQs and
they didn't want to implement another IRQ bank.
Furthermore, some of the DMA channels are already used by the
VideoCore/GPU/firmware. This is what dma-channel-mask indicates. This
should be automatically set by the firmware in the future.
Finally, there are some channels with special functionality that should
not be used by DMA engine, too. Therefore, these lines:
		/* do not use the FIQ and BULK channels */
		chans_available &= ~0xD;

> [snip]
>> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
>> new file mode 100644
>> index 0000000..baf072e
>> --- /dev/null
>> +++ b/drivers/dma/bcm2835-dma.c
> [snip]
>> +static int bcm2835_dma_probe(struct platform_device *pdev)
>> +{
>> +	struct bcm2835_dmadev *od;
>> +	struct resource *dma_res = NULL;
>> +	void __iomem *dma_base = NULL;
>> +	int rc = 0;
>> +	int i = 0;
>> +	int irq;
>> +	uint32_t chans_available;
> [snip]
>> +	if (pdev->dev.of_node) {
> 
> Is this driver supposed to support non-DT based instantation (aka board
> files)? If not, maybe it would be cleaner to simply check for
> !pdev->dev.of_node at the beginning of probe and return an error?

I would like to maintain the possibility for board file based
instatiation, because the Raspberry Pi downstream kernel still doesn't
support device tree. If this is a no-go, I will accept that.

Greetings,
Florian

