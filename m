Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbaAJO3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:29:08 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:34392 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbaAJO3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:29:04 -0500
Message-ID: <52D003AC.3000808@cogentembedded.com>
Date: Fri, 10 Jan 2014 18:29:00 +0400
From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "anton@enomsg.org" <anton@enomsg.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mk7.kang@samsung.com" <mk7.kang@samsung.com>
Subject: Re: [PATCH 1/3] power_supply: modelgauge_battery: Maxim ModelGauge
 ICs gauge
References: <1389286145-15375-1-git-send-email-vladimir.barinov@cogentembedded.com> <1389286145-15375-2-git-send-email-vladimir.barinov@cogentembedded.com> <20140110111130.GD6798@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140110111130.GD6798@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/10/2014 03:11 PM, Mark Rutland wrote:
> On Thu, Jan 09, 2014 at 04:49:03PM +0000, Vladimir Barinov wrote:
>> Add Maxim ModelGauge ICs gauge driver for MAX17040/41/43/44/48/49/58/59 chips
>>
>> Signed-off-by: Vladimir Barinov<vladimir.barinov@cogentembedded.com>
>>
>> ---
>>   drivers/power/Kconfig                            |    8
>>   drivers/power/Makefile                           |    1
>>   drivers/power/modelgauge_battery.c               |  875 +++++++++++++++++++++++
>>   include/linux/platform_data/battery-modelgauge.h |   44 +
>>   4 files changed, 928 insertions(+)
> [...]
>
>> +static struct modelgauge_platform_data *modelgauge_parse_dt(struct device *dev)
>> +{
>> +       struct device_node *np = dev->of_node;
>> +       struct modelgauge_platform_data *pdata;
>> +       struct property *prop;
>> +
>> +       if (!of_get_property(np, "maxim,empty_alert_threshold", NULL)&&
>> +           !of_get_property(np, "maxim,soc_change_alert", NULL)&&
>> +           !of_get_property(np, "maxim,hibernate_threshold", NULL)&&
>> +           !of_get_property(np, "maxim,active_threshold", NULL)&&
>> +           !of_get_property(np, "maxim,undervoltage", NULL)&&
>> +           !of_get_property(np, "maxim,overvoltage", NULL)&&
>> +           !of_get_property(np, "maxim,resetvoltage", NULL))
>> +               return NULL;
> These were described as optional in the binding. It wasn't clear that to
> have one you need the others. It would be nice for that to be clarified
> in the binding.
Yes, since they are optional then we'll return NULL here, that means no 
platform data provided.
The "if" statement checked if nothing was provided in DT then there is 
not platform data.

Since, you requested to remove above binding from DT and make the driver 
to take care, then I'll move them to sysfs.
>
>> +
>> +       pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +       if (!pdata)
>> +               return NULL;
>> +
>> +       of_property_read_u8(np, "maxim,empty_alert_threshold",
>> +&pdata->empty_alert_threshold);
>> +       pdata->soc_change_alert =
>> +                       of_property_read_bool(np, "maxim,soc_change_alert");
> As mentioned in my comments on the binding document, I don't think this
> property is necessary at all.
Yes, I will move it into driver.
>
>> +       of_property_read_u8(np, "maxim,hibernate_threshold",
>> +&pdata->hibernate_threshold);
>> +       of_property_read_u8(np, "maxim,active_threshold",
>> +&pdata->active_threshold);
>> +       of_property_read_u16(np, "maxim,undervoltage",&pdata->undervoltage);
>> +       of_property_read_u16(np, "maxim,overvoltage",&pdata->overvoltage);
>> +       of_property_read_u16(np, "maxim,resetvoltage",&pdata->resetvoltage);
Ditto for above.
>> +
>> +       prop = of_find_property(np, "maxim,ocvtest", NULL);
> Here you seem to be using of_find_property to check if a property is
> present, but earlier you used of_get_property for this purpose. It would
> be nice if one or the other were used consistently.
Since above code will be removed then only this parameter will be used 
for battery specific data presence check.
>
>> +       if (prop) {
>> +               pdata->model = devm_kzalloc(dev, sizeof(*pdata->model),
>> +                                           GFP_KERNEL);
>> +               if (!pdata->model)
>> +                       return NULL;
>> +
>> +               of_property_read_u8(np, "maxim,empty_adjustment",
>> +&pdata->model->empty_adjustment);
>> +               of_property_read_u8(np, "maxim,full_adjustment",
>> +&pdata->model->full_adjustment);
>> +               of_property_read_u8(np, "maxim,rcomp0",
>> +&pdata->model->rcomp0);
>> +               prop = of_find_property(np, "maxim,temp_co_up", NULL);
>> +               if (prop)
>> +                       pdata->model->temp_co_up = be32_to_cpup(prop->value);
> Use of_property_read_u32. If it can't read the property it won't
> modify the pointer it's been handed, and it handles the endianness
> conversion.
>
> You seem to be happy to use of_property_read_u{8,16}, so I don't
> understand why you are treating 32-bit differently.
Because the this property is signed. So I can't use of_property_read_u32.
>
>> +               prop = of_find_property(np, "maxim,temp_co_down", NULL);
>> +               if (prop)
>> +                       pdata->model->temp_co_down = be32_to_cpup(prop->value);
> Likewise.
Ditto.
>
>> +               of_property_read_u16(np, "maxim,ocvtest",
>> +&pdata->model->ocvtest);
> While you've checked that this property was present earlier, you don't
> know it's size. You might want to check the return value of
> of_property_read_u16 (and you might want to do so for other accessors
> too).
Ok, I will add checking of of_property_read_XX() return values.
>
>> +               of_property_read_u8(np, "maxim,soc_check_a",
>> +&pdata->model->soc_check_a);
>> +               of_property_read_u8(np, "maxim,soc_check_b",
>> +&pdata->model->soc_check_b);
>> +               of_property_read_u8(np, "maxim,bits",
>> +&pdata->model->bits);
>> +               of_property_read_u16(np, "maxim,rcomp_seg",
>> +&pdata->model->rcomp_seg);
>> +       }
>> +
>> +       prop = of_find_property(np, "maxim,model_data", NULL);
>> +       if (prop&&  prop->length == MODELGAUGE_TABLE_SIZE) {
>> +               pdata->model->model_data = devm_kzalloc(dev,
>> +                                                       MODELGAUGE_TABLE_SIZE,
>> +                                                       GFP_KERNEL);
>> +               if (!pdata->model->model_data)
>> +                       return NULL;
>> +
>> +               of_property_read_u8_array(np, "maxim,model_data",
>> +                                         pdata->model->model_data,
>> +                                         MODELGAUGE_TABLE_SIZE);
>> +       }
> It's probably worth printing a warning or error if this isn't the size
> you expect (perhaps failing to probe).
okay.
>
>> +
>> +       return pdata;
>> +}
> Thanks,
> Mark.
Regards,
Vladimir

