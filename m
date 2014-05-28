Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbaE1Swb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:52:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45422 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaE1Sw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:52:29 -0400
Message-ID: <53863056.2070405@ahsoftware.de>
Date: Wed, 28 May 2014 20:52:06 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 01/27] mtd: nand: introduce function to fix a common bug
 in most nand-drivers not showing a device in sysfs
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de> <1401142372-14148-2-git-send-email-holler@ahsoftware.de> <20140528084344.GB4285@norris-Latitude-E6410>
In-Reply-To: <20140528084344.GB4285@norris-Latitude-E6410>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.05.2014 10:43, schrieb Brian Norris:
> On Tue, May 27, 2014 at 12:12:26AM +0200, Alexander Holler wrote:
>> --- a/include/linux/mtd/mtd.h
>> +++ b/include/linux/mtd/mtd.h
>> @@ -23,7 +23,7 @@
>>   #include <linux/types.h>
>>   #include <linux/uio.h>
>>   #include <linux/notifier.h>
>> -#include <linux/device.h>
>> +#include <linux/platform_device.h>
>>
>>   #include <mtd/mtd-abi.h>
>>
>> @@ -366,6 +366,15 @@ static inline int mtd_can_have_bb(const struct mtd_info *mtd)
>>   struct mtd_partition;
>>   struct mtd_part_parser_data;
>>
>> +static inline void mtd_setup_common_members(struct mtd_info *mtd, void *priv,
>> +						struct platform_device *pdev)
>
> Thanks for the diligence on catching these issues, but I'm not sure this
> helper function is fully the correct approach here.
>
>> +{
>> +	mtd->priv	= priv;
>
> I don't think you should hide this one here. It will be quite obvious if
> a driver didn't stash its private data but tries to access it later. Are
> there any drivers that missed this?

No, it just saves a line of source in all drivers and I think it fits 
there. I don't understand why do you think it is hidden.

>
>> +	mtd->owner	= pdev->dev.driver->owner;
>> +	mtd->dev.parent	= &pdev->dev;
>> +	mtd->name	= pdev->dev.driver->name;
>
> I think this is a little dangerous. You're potentially clobbering the
> name that a driver already chose here. And why did you pick to use the
> driver name? This gives non-unique names if there is more than one
> device instantiated for a driver. That's why some drivers already use
> the device name, not the driver name:
>
> 	mtd->name = dev_name(&pev->dev);
>
> And in fact, if any drivers are missing mtd->name, perhaps it's best to
> just modify the MTD registration to give them a default:
>
> 	if (!mtd->name)
> 		mtd->name = dev_name(&pdev->dev);
>
>> +}

I don't clobber any name. The name is set as default before drivers 
might do this. And the common pattern I've seen wasn't dev_name(foo) but 
the drivers name. And those drivers which do use dev_name(), still do so 
by overwriting the default I put into that function. But feel free to 
change this. I will not go again and again through the 26 drivers until 
all maintainers and other people are happy.

>
> BTW, nothing in this function actually makes sense to require a
> platform_device, does it? And it's possible to have non-platform drivers
> that want to do basic MTD initialization. So (if we still keep this
> helper function at all), I'd recommend just a 'struct device *dev'
> parameter.
>

Feel free to chgange it.


>> +
>>   extern int mtd_device_parse_register(struct mtd_info *mtd,
>>   				     const char * const *part_probe_types,
>>   				     struct mtd_part_parser_data *parser_data,
>
> How about we rethink the "helper" approach, and instead just do
> validation in the core code? This would cover most of the important
> parts of your helper, I think:

Feel free to change all drivers. I like my approach with fixing 21 bugs 
by reducing code by 44 lines.

And it offers a common function where future similiarities can be put 
into too. Of course you can just add 21 lines, but that is not how I do 
such stuff.

And I did the patches. If you don't like them, feel free to ignore them. 
I'm not playing remote keyboard but I do patches like I would do them, 
not like some arbitrary maintainer would do them. Sorry for the harsh words.

Regards,

Alexander Holler
