Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab3KRMQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 07:16:39 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:47663 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3KRMQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 07:16:29 -0500
Message-ID: <528A051A.7000703@koalo.de>
Date: Mon, 18 Nov 2013 13:16:26 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Shevchenko, Andriy" <andriy.shevchenko@intel.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv7] dmaengine: Add support for BCM2835
References: <5288E327.8050809@koalo.de> <1384768816.14845.186.camel@smile>
In-Reply-To: <1384768816.14845.186.camel@smile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you! Few comments below.

> []
>> +static enum dma_status bcm2835_dma_tx_status(struct dma_chan *chan,
>> +	dma_cookie_t cookie, struct dma_tx_state *txstate)
>> +{
> 
> []
> 
>> +	} else {
>> +		txstate->residue = 0;
> 
> Useless assignment since dmaengine will do this for you in
> dma_cookie_status.

I agree that it is useless, but I think otherwise it might be concealed
that there is a third case left that uses a residue of 0. Do you think a
comment is better? E.g.:

+	} else {
+		/* residue = 0 per default */

>> +	/* Bus width translates to the element size (ES) */
>> +	switch (dev_width) {
>> +	case DMA_SLAVE_BUSWIDTH_4_BYTES:
>> +		es = BCM2835_DMA_DATA_TYPE_S32;
>> +		break;
>> +	default:
>> +		return NULL;
>> +	}
> 
> So, you use switch-case on hope to extend it later, correct?

Yes, there is a S128 case left, but that is not implemented yet.

>> +static int bcm2835_dma_probe(struct platform_device *pdev)
>> +{
>> +	struct bcm2835_dmadev *od;
>> +	struct resource *res;
>> +	void __iomem *base;
>> +	int rc;
>> +	int i;
>> +	int irq;
>> +	uint32_t chans_available;
> 
> Why uint32_t?

Because it is a bit mask of fixed length that directly comes from the
firmware.

>> +		/* Request DMA channel mask from device tree */
>> +		if (of_property_read_u32(pdev->dev.of_node,
>> +				"brcm,dma-channel-mask",
>> +				&chans_available)) {
>> +			dev_err(&pdev->dev, "Failed to get channel mask\n");
>> +			bcm2835_dma_free(od);
>> +			return -EINVAL;
>> +		}
>> +	} else {
>> +		dev_err(&pdev->dev, "Failed to get channel mask. No device tree.\n");
>> +		bcm2835_dma_free(od);
>> +		return -EINVAL;
>> +	}
> 
>> +	dev_dbg(&pdev->dev, "Initialized %i DMA channels\n", i);
>> +
>> +	if (pdev->dev.of_node) {
> 
> Does it make sense?

There was already a discussion about that in PATCHv4. It should be
possible to add board file initialization later with few patching.
Although, maybe this will not be relevant anymore, because device tree
support of this platform is getting better more and more.
