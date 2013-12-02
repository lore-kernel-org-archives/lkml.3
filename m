Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697Ab3LBIjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 03:39:18 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33941 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab3LBIjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 03:39:15 -0500
Message-ID: <529C4726.6080708@ti.com>
Date: Mon, 2 Dec 2013 10:39:02 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>, <lee.jones@linaro.org>,
        <sameo@linux.intel.com>
CC: <tomi.valkeinen@ti.com>, <balbi@ti.com>, <sr@denx.de>,
        <ljkenny.mailinglists@gmail.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH 1/1] mfd: omap-usb-host: Fix USB device detection problems
 on OMAP4 Panda
References: <1385730118-26402-1-git-send-email-rogerq@ti.com> <1385730118-26402-2-git-send-email-rogerq@ti.com> <AE90C24D6B3A694183C094C60CF0A2F6026B744D@saturn3.aculab.com>
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B744D@saturn3.aculab.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On 11/29/2013 03:17 PM, David Laight wrote:
>> From: Of Roger Quadros
>> With u-boot 2013.10, USB devices are sometimes not detected
>> on OMAP4 Panda. To make us independent of what bootloader does
>> with the USB Host module, we must RESET it to get it to a known
>> good state. This patch Soft RESETs the USB Host module.
> ...
>> +++ b/drivers/mfd/omap-usb-host.c
>> @@ -43,14 +43,18 @@
>>  /* UHH Register Set */
>>  #define	OMAP_UHH_REVISION				(0x00)
>>  #define	OMAP_UHH_SYSCONFIG				(0x10)
>> -#define	OMAP_UHH_SYSCONFIG_MIDLEMODE			(1 << 12)
>> +#define	OMAP_UHH_SYSCONFIG_MIDLEMASK			(3 << 12)
>> +#define OMAP_UHH_SYSCONFIG_MIDLESHIFT			(12)
> 
> (tab/space issue)

Weird, original code seems to use a tab instead of space after #define. 

> 
> Wouldn't it be clearer to define these in the opposite order with:
> +#define	OMAP_UHH_SYSCONFIG_MIDLEMASK			(3 << OMAP_UHH_SYSCONFIG_MIDLESHIFT)

Right.

> 
> ... 
>> +static void omap_usbhs_rev1_reset(struct device *dev)
>> +{
>> +	struct usbhs_hcd_omap *omap = dev_get_drvdata(dev);
>> +	u32 reg;
>> +	unsigned long timeout;
>> +
>> +	reg = usbhs_read(omap->uhh_base, OMAP_UHH_SYSCONFIG);
>> +
>> +	/* Soft Reset */
>> +	usbhs_write(omap->uhh_base, OMAP_UHH_SYSCONFIG,
>> +		    reg | OMAP_UHH_SYSCONFIG_SOFTRESET);
>> +
>> +	timeout = jiffies + msecs_to_jiffies(100);
>> +	while (!(usbhs_read(omap->uhh_base, OMAP_UHH_SYSSTATUS)
>> +			& OMAP_UHH_SYSSTATUS_RESETDONE)) {
>> +		cpu_relax();

You mean use msleep(1) here instead of cpu_relax()?
Shouldn't be a problem IMO, but can you please tell me why that is better
as the reset seems to complete usually in the first iteration.

>> +
>> +		if (time_after(jiffies, timeout)) {
>> +			dev_err(dev, "Soft RESET operation timed out\n");
>> +			break;
>> +		}
>> +	}
>> +
>> +	/* Set No-Standby */
>> +	reg &= ~OMAP_UHH_SYSCONFIG_MIDLEMASK;
>> +	reg |= OMAP_UHH_SYSCONFIG_MIDLE_NOSTANDBY
>> +		<< OMAP_UHH_SYSCONFIG_MIDLESHIFT;
>> +
>> +	/* Set No-Idle */
>> +	reg &= ~OMAP_UHH_SYSCONFIG_SIDLEMASK;
>> +	reg |= OMAP_UHH_SYSCONFIG_SIDLE_NOIDLE
>> +		<< OMAP_UHH_SYSCONFIG_SIDLESHIFT;
> 
> Why not pass in the mask and value and avoid replicating the
> entire function. I can't see any other significant differences,
> the udelay(2) won't be significant.

OK, I can pass the mask and value, but still there is a difference
in the way reset complete is checked between v1 and v2. But that
be in omap_usbhs_softreset() and the individual reset functions can be
replaced by a single omap_usbhs_set_sysconfig().

It seems the udelay() is not required for the USB Host module, so I'll
get rid of that.

> 
> I'm not sure of the context this code runs in, but if the reset
> is likely to take a significant portion of the 100ms timeout
> period, why not just sleep for a few ms between status polls.

covered in the related code above.

cheers,
-roger

