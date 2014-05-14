Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaENFl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 01:41:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54128 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbaENFlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 01:41:23 -0400
Message-ID: <537301FE.7080207@ti.com>
Date: Wed, 14 May 2014 11:11:18 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rogerq@ti.com>, <kishon@ti.com>
Subject: Re: [PATCH 1/5] usb: dwc3: dwc3-omap: Add dwc3_omap_map_offset function
References: <1399541587-14067-1-git-send-email-george.cherian@ti.com> <1399541587-14067-2-git-send-email-george.cherian@ti.com> <20140513160227.GQ1151@saruman.home>
In-Reply-To: <20140513160227.GQ1151@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/2014 9:32 PM, Felipe Balbi wrote:
> Hi,
>
> On Thu, May 08, 2014 at 03:03:03PM +0530, George Cherian wrote:
>> Calculate the wrapper register offsets in a seperate function.
>> Improve code readability, decrease the dwc3_probe() size.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/usb/dwc3/dwc3-omap.c | 80 ++++++++++++++++++++++++--------------------
>>   1 file changed, 44 insertions(+), 36 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
>> index 1160ff4..872f065 100644
>> --- a/drivers/usb/dwc3/dwc3-omap.c
>> +++ b/drivers/usb/dwc3/dwc3-omap.c
>> @@ -383,6 +383,49 @@ static int dwc3_omap_vbus_notifier(struct notifier_block *nb,
>>   	return NOTIFY_DONE;
>>   }
>>   
>> +static void dwc3_omap_map_offset(struct dwc3_omap *omap)
>> +{
>> +	u32			reg;
>> +	struct device_node	*node = omap->dev->of_node;
>> +	int			x_major;
>> +
>> +	reg = dwc3_omap_readl(omap->base, USBOTGSS_REVISION);
>> +	omap->revision = reg;
>> +	x_major = USBOTGSS_REVISION_XMAJOR(reg);
>> +
>> +	/* Differentiate between OMAP5 and AM437x */
>> +	switch (x_major) {
>> +	case USBOTGSS_REVISION_XMAJOR1:
>> +	case USBOTGSS_REVISION_XMAJOR2:
>> +		omap->irq_eoi_offset = 0;
>> +		omap->irq0_offset = 0;
>> +		omap->irqmisc_offset = 0;
>> +		omap->utmi_otg_offset = 0;
>> +		omap->debug_offset = 0;
>> +		break;
>> +	default:
>> +		/* Default to the latest revision */
>> +		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
>> +		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
>> +		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
>> +		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
>> +		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
>> +		break;
>> +	}
>> +
>> +	/* For OMAP5(ES2.0) and AM437x x_major is 2 even though there are
>> +	 * changes in wrapper registers, Using dt compatible for aegis
>> +	 */
>> +
>> +	if (of_device_is_compatible(node, "ti,am437x-dwc3")) {
>> +		omap->irq_eoi_offset = USBOTGSS_EOI_OFFSET;
>> +		omap->irq0_offset = USBOTGSS_IRQ0_OFFSET;
>> +		omap->irqmisc_offset = USBOTGSS_IRQMISC_OFFSET;
>> +		omap->utmi_otg_offset = USBOTGSS_UTMI_OTG_OFFSET;
>> +		omap->debug_offset = USBOTGSS_DEBUG_OFFSET;
>> +	}
> can you add a patch before $subject which gets rid of the switch
> statement above since it's pretty much useless now that we use
> compatible strings to differentiate omap5 and am437x ?'
okay will do in v2.
>


-- 
-George

