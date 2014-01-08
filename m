Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbaAHG3G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:29:06 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52450 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaAHG3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:29:02 -0500
Message-ID: <52CCF027.6040607@ti.com>
Date: Wed, 8 Jan 2014 11:58:55 +0530
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <sameo@linux.intel.com>, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mfd: omap-usb-tll: Don't hold lock during pm_runtime_get/put_sync()
References: <1387360909-10624-1-git-send-email-rogerq@ti.com> <20131218103641.GD14274@lee--X1>
In-Reply-To: <20131218103641.GD14274@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/18/2013 04:06 PM, Lee Jones wrote:
>> pm_runtime_get/put_sync() can sleep so don't hold spinlock while
>> calling them.
>>
>> This patch prevents a BUG() when CONFIG_DEBUG_ATOMIC_SLEEP is enabled.
>> Bug is present in Kernel versions v3.9 onwards.
>>
>> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> Tested-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Cc: <stable@vger.kernel.org> # 3.9+
>> ---
>>  drivers/mfd/omap-usb-tll.c | 11 ++++++-----
>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
>> index 0d946ae1..248004c 100644
>> --- a/drivers/mfd/omap-usb-tll.c
>> +++ b/drivers/mfd/omap-usb-tll.c
>> @@ -346,7 +346,9 @@ int omap_tll_init(struct usbhs_omap_platform_data *pdata)
>>  	for (i = 0; i < tll->nch; i++)
>>  		needs_tll |= omap_usb_mode_needs_tll(pdata->port_mode[i]);
>>  
>> +	spin_unlock(&tll_lock);
>>  	pm_runtime_get_sync(tll_dev);
>> +	spin_lock(&tll_lock);
> 
> This is pretty ugly. Can't you move it above the spin_lock() instead?

OK. I'll also remove NULL check for tll_dev outside the spin_lock().

> 
> <snip>
> 
>>  	tll = dev_get_drvdata(tll_dev);
>>  
>> +	spin_unlock(&tll_lock);
>>  	pm_runtime_get_sync(tll_dev);
>> +	spin_lock(&tll_lock);
> 
> Same here?

Yes.

> 
>>  	for (i = 0; i < tll->nch; i++) {
>>  		if (omap_usb_mode_needs_tll(pdata->port_mode[i])) {
>> @@ -438,7 +441,6 @@ int omap_tll_enable(struct usbhs_omap_platform_data *pdata)
>>  	}
>>  
>>  	spin_unlock(&tll_lock);
>> -
> 
> This doesn't belong in this patch and is now inconsistent with the
> other functions in the driver.

OK.

> 
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL_GPL(omap_tll_enable);
>> @@ -464,9 +466,8 @@ int omap_tll_disable(struct usbhs_omap_platform_data *pdata)
>>  		}
>>  	}
>>  
>> -	pm_runtime_put_sync(tll_dev);
>> -
>>  	spin_unlock(&tll_lock);
>> +	pm_runtime_put_sync(tll_dev);
>>  
>>  	return 0;
>>  }
> 

cheers,
-roger

