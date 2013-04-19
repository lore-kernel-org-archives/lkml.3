Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030406Ab3DSNR0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 09:17:26 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:64323 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030323Ab3DSNRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 09:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <51713A25.308@yahoo.es>
References: <51713A25.308@yahoo.es>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Fri, 19 Apr 2013 21:17:03 +0800
Message-ID: <CAMPhdO-NVW5Wwa7OVWQB5yiT2ahdfzhzrrGp9pBeer9vH561CQ@mail.gmail.com>
Subject: Re: [PATCH] platform: fall-back to driver name check if there is no
 id found
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg KH <greg@kroah.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 8:35 PM, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> Hi Andy, Mika,
>
> On 8 Feb 2013, Andy Shevchenko wrote:
>
>> Some of the platform devices rely on the name of their driver to match with. In
>> the current implementation, if platform id table is needed, they have to add
>> the name to the platform id table which sounds alogical. The patch adjustes the
>> logic of the id table matching to make sure we will fall-back to match by the
>> driver name. This will make it similar to the DT or ACPI cases.
>>
>> Signed-off-by: Andy Shevchenko <andriy.shevchenko@xxxxxxxxxxxxxxx>
>> Reported-by: Mika Westerberg <mika.westerberg@xxxxxxxxxxxxxxx>
>> Cc: Eric Miao <eric.miao@xxxxxxxxxxx>
>> Cc: Greg Kroah-Hartman <gregkh@xxxxxxx>
>> ---
>>  drivers/base/platform.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
>> index c0b8df3..452ba4b 100644
>> --- a/drivers/base/platform.c
>> +++ b/drivers/base/platform.c
>> @@ -732,8 +732,8 @@ static int platform_match(struct device *dev, struct device_driver *drv)
>>               return 1;
>>
>>       /* Then try to match against the id table */
>> -     if (pdrv->id_table)
>> -             return platform_match_id(pdrv->id_table, pdev) != NULL;
>> +     if (pdrv->id_table && platform_match_id(pdrv->id_table, pdev))
>> +             return 1;
>>
>>       /* fall-back to driver name match */
>>       return (strcmp(pdev->name, drv->name) == 0);
>
> When I upgraded an avr32 system from 3.8 to a recent next release, I found it was
> broken: DMA was not available because the dw_dma driver did not get probed anymore.
>
> The dw_dma driver does have a id_table, but the boards in arch/avr32 are still expecting
> driver identification by name.

I think this is a different philosophy here. I'm actually fine with either. The
questions are really:

1. will it be a bit inconsistent if the driver is using id_table,
while the device
is still using a legacy way?

2. instead of introducing a different logic in the platform driver core code,
is it possible this could be fixed at the board level?

>
> As long as we want to support this simple identification-by-name, I'd say Andy's patch
> should get quickly into stable release.
