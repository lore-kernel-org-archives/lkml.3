Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703Ab3CEPGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:06:35 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34971 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757415Ab3CEPAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:00:05 -0500
Message-ID: <51360856.8030306@ti.com>
Date: Tue, 5 Mar 2013 20:29:34 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <s-guiriec@ti.com>, <gg@slimlogic.co.uk>,
        <sameo@linux.intel.com>, <broonie@opensource.wolfsonmicro.com>,
        <ldewangan@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: dwc3: dwc3-omap: set dma_mask for dwc3 inorder
 for host mode to work
References: <1362493320-13913-1-git-send-email-kishon@ti.com> <1362493320-13913-2-git-send-email-kishon@ti.com> <20130305145458.GF12123@arwen.pp.htv.fi>
In-Reply-To: <20130305145458.GF12123@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 05 March 2013 08:24 PM, Felipe Balbi wrote:
> On Tue, Mar 05, 2013 at 07:51:57PM +0530, Kishon Vijay Abraham I wrote:
>> While creating the child devices, *of_platform_populate* sets only
>> coherent_dma_mask but USBHCD sets *uses_dma* (determines whether the
>> controller is DMA'able) based on dma_mask. So If we haven't explicitly set
>> dma_mask, the HCD thinks the controller is not DMA'able and the
>> controller will fail. So explicity set dma_mask for dwc3 after
>> *of_platform_populate*.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>   drivers/usb/dwc3/dwc3-omap.c |   10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
>> index 35b9673..19c6e72 100644
>> --- a/drivers/usb/dwc3/dwc3-omap.c
>> +++ b/drivers/usb/dwc3/dwc3-omap.c
>> @@ -277,6 +277,14 @@ static void dwc3_omap_disable_irqs(struct dwc3_omap *omap)
>>   	dwc3_omap_writel(omap->base, USBOTGSS_IRQENABLE_SET_0, 0x00);
>>   }
>>
>> +static u64 dwc3_omap_dma_mask = DMA_BIT_MASK(32);
>> +
>> +static int dwc3_omap_set_dmamask(struct device *dev, void *c)
>> +{
>> +	dev->dma_mask = &dwc3_omap_dma_mask;
>> +	return 0;
>> +}
>> +
>>   static int dwc3_omap_probe(struct platform_device *pdev)
>>   {
>>   	struct device_node	*node = pdev->dev.of_node;
>> @@ -381,6 +389,8 @@ static int dwc3_omap_probe(struct platform_device *pdev)
>>   		return ret;
>>   	}
>>
>> +	device_for_each_child(&pdev->dev, NULL, dwc3_omap_set_dmamask);
>
> I don't think this is correct. Child should be setting its own by
> copying from parent. In summary I think we should add this to dwc3 core:
>
> dma_set_coherent_mask(&pdev->dev, pdev->dev.parent->coherent_dma_mask);
> pdev->dev.dma_mask = pdev->dev.parent->dma_mask;
> pdev->dev.dma_parms = pdev->dev.parent->dma_parms;
>
> And add the same thing to xhci-plat.c btw.

hmm.. ok.

Thanks
Kishon
