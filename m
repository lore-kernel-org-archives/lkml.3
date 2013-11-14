Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3KNHNH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 02:13:07 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61733 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941Ab3KNHMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 02:12:55 -0500
Message-ID: <528477EE.4060407@koalo.de>
Date: Thu, 14 Nov 2013 08:12:46 +0100
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
References: <5283BC93.1090801@koalo.de> <3722902.ByNK8Ptc5Y@flatron> <5283D47A.7060503@koalo.de> <2049375.GR9Xb2zuek@flatron>
In-Reply-To: <2049375.GR9Xb2zuek@flatron>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.11.2013 21:39, Tomasz Figa wrote:
> On Wednesday 13 of November 2013 20:35:22 Florian Meier wrote:
>> On 13.11.2013 19:43, Tomasz Figa wrote:
>>>> ....
>>>> diff --git a/Documentation/devicetree/bindings/dma/bcm2835-dma.txt b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
>>>> new file mode 100644
>>>> index 0000000..bca5e84
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/dma/bcm2835-dma.txt
>>>> @@ -0,0 +1,59 @@
>>>> +* BCM2835 DMA controller
>>>> +
>>>> +Required properties:
>>>> +- compatible: Should be "brcm,bcm2835-dma".
>>>> +- reg: Should contain DMA registers location and length.
>>>> +- interrupts: Should contain the DMA interrupts associated
>>>> +		to the DMA channels in ascending order.
>>>> +		First cell is the IRQ bank.
>>>> +		Second cell is the IRQ number.
>>>> +- #dma-cells: Must be <1>, used to represent the number of integer cells in
>>>> +		the dmas property of client devices.
>>>> +- dma-channels: Maximum number of DMA channels available.
>>>> +- dma-requests: Number of DMA Requests.
>>>
>>> The two properties above do not seem to be used anywhere in the driver.
>>
>> Aren't they necessary for the DMA engine core?
> 
> Honestly, looking at the DMA bindings documentation, these two are quite
> a mystery for me. They don't seem to be used in DMA engine core, but
> instead several drivers use them for private purposes.
> 
> So, since they are optional and you don't seem to need them, I wouldn't
> list them.

Ok

>>>> +- brcm,dma-channel-mask: Bit mask representing the channels available.
>>>
>>> What does the value of this property depend on? Could you describe the
>>> structure of this DMA controller?
>>>
>>>> +
>>>> +Example:
>>>> +
>>>> +dma: dma@7e007000 {
>>>> +	compatible = "brcm,bcm2835-dma";
>>>> +	reg = <0x7e007000 0xf00>;
>>>> +	interrupts = <1 16
>>>> +		      1 17
>>>> +		      1 18
>>>> +		      1 19
>>>> +		      1 20
>>>> +		      1 21
>>>> +		      1 22
>>>> +		      1 23
>>>> +		      1 24
>>>> +		      1 25
>>>> +		      1 26
>>>> +		      1 27
>>>> +		      1 28>;
>>>
>>> There are 13 interrupts specified here, but...
>>>
>>>> +
>>>> +	#dma-cells = <1>;
>>>> +	dma-channels = <16>;
>>>
>>> ...16 channels here...
>>>
>>>> +	dma-requests = <32>;
>>>> +	brcm,dma-channel-mask = <0x7f35>;
>>>
>>> ...and 11 set bits here. May I ask you to explain this to me, please?
>>
>> How I understand this DMA controller:
>> There are 16 DMA channels in the DMA controller, but only 13 interrupts
>> are available at the IRQ controller. Therefore, the upper DMA channels
>> can just not be used. Maybe because there are to many other IRQs and
>> they didn't want to implement another IRQ bank.
>> Furthermore, some of the DMA channels are already used by the
>> VideoCore/GPU/firmware. This is what dma-channel-mask indicates. This
>> should be automatically set by the firmware in the future.
>> Finally, there are some channels with special functionality that should
>> not be used by DMA engine, too. Therefore, these lines:
>> 		/* do not use the FIQ and BULK channels */
>> 		chans_available &= ~0xD;
> 
> OK, this makes it much more clear.
> 
> So, my only comment remaining here is that you shouldn't include the
> channels without interrupt signal in the mask. This would allow you
> to define it as a mask of channels that are operable and then just
> iterate over all set bits in the driver, instead of using tricks with
> interrupt resources. What do you think?

Since the mask will come directly from the firmware, this would require
patching the firmware. I think that is not worth the effort.

>>> [snip]
>>>> diff --git a/drivers/dma/bcm2835-dma.c b/drivers/dma/bcm2835-dma.c
>>>> new file mode 100644
>>>> index 0000000..baf072e
>>>> --- /dev/null
>>>> +++ b/drivers/dma/bcm2835-dma.c
>>> [snip]
>>>> +static int bcm2835_dma_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct bcm2835_dmadev *od;
>>>> +	struct resource *dma_res = NULL;
>>>> +	void __iomem *dma_base = NULL;
>>>> +	int rc = 0;
>>>> +	int i = 0;
>>>> +	int irq;
>>>> +	uint32_t chans_available;
>>> [snip]
>>>> +	if (pdev->dev.of_node) {
>>>
>>> Is this driver supposed to support non-DT based instantation (aka board
>>> files)? If not, maybe it would be cleaner to simply check for
>>> !pdev->dev.of_node at the beginning of probe and return an error?
>>
>> I would like to maintain the possibility for board file based
>> instatiation, because the Raspberry Pi downstream kernel still doesn't
>> support device tree. If this is a no-go, I will accept that.
> 
> Sure, you are free to do so.
> 
> What I meant is that your probe won't call bcm2835_dma_chan_init() at all
> if there is no pdev->dev.of_node, because the loop iterating over channels
> is under the if clause.

Yes you are right, but I think it will make the patching easier, later.
Currently, nothing bad happens without device tree - it just allocates
no channels.

Greetings,
Florian
