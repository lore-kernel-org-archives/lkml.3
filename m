Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbaKDIdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:33:51 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:33940 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbaKDIdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:33:46 -0500
MIME-Version: 1.0
In-Reply-To: <20141103145623.GH4538@x1>
References: <1414171197-18620-1-git-send-email-dbaryshkov@gmail.com>
	<20141103145623.GH4538@x1>
Date: Tue, 4 Nov 2014 12:33:46 +0400
Message-ID: <CALT56yNqnK-Xj3exPrgeXY_1ExcE2hbixZVS9e9ferE-gMxEig@mail.gmail.com>
Subject: Re: [PATCH] mfd: tc6393xb fail ohci suspend if full state restore is required
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

2014-11-03 17:56 GMT+03:00 Lee Jones <lee.jones@linaro.org>:
> On Fri, 24 Oct 2014, Dmitry Eremin-Solenikov wrote:
>
>> Some boards with TC6393XB chip require full state restore during system
>> resume thanks to chip's VCC being cut off during suspend (Sharp SL-6000
>> tosa is one of them). Failing to do so would result in ohci Oops on
>> resume due to internal memory contentes being changed. Fail ohci suspend
>> on tc6393xb is full state restore is required.
>>
>> Recommended workaround is to unbind tmio-ohci driver before suspend and
>> rebind it after resume.
>>
>> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  drivers/mfd/tc6393xb.c | 13 ++++++++++++-
>>  1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
>> index 11c19e5..48579e5 100644
>> --- a/drivers/mfd/tc6393xb.c
>> +++ b/drivers/mfd/tc6393xb.c
>> @@ -263,6 +263,17 @@ static int tc6393xb_ohci_disable(struct platform_device *dev)
>>       return 0;
>>  }
>>
>> +static int tc6393xb_ohci_suspend(struct platform_device *dev)
>> +{
>> +     struct tc6393xb_platform_data *tcpd = dev_get_platdata(dev->dev.parent);
>> +
>> +     /* We can't properly store/restore OHCI state, so fail here */
>> +     if (tcpd->resume_restore)
>> +             return -EBUSY;
>
> Wouldn't it be easier to just put these three lines into
> tc6393xb_ohci_disable() instead off adding 7 superfluous lines and
> making the Ops names inconsistent?

No. The problem only exists on suspend/resume path. tc6393xb_ohci_disable
is also used on driver removal and can (should?) be used on device shutdown.
Using the tc6393xb_ohci_disable() function in that paths is not a problem.

Also with this patch the Oops name will not be inconsistent - returning -EBUSY
from this disable callback will cancel the device suspension with
clearly stating
that OHCI is busy in dmesg.

>
>
>> +     return tc6393xb_ohci_disable(dev);
>> +}
>> +
>>  static int tc6393xb_fb_enable(struct platform_device *dev)
>>  {
>>       struct tc6393xb *tc6393xb = dev_get_drvdata(dev->dev.parent);
>> @@ -403,7 +414,7 @@ static struct mfd_cell tc6393xb_cells[] = {
>>               .num_resources = ARRAY_SIZE(tc6393xb_ohci_resources),
>>               .resources = tc6393xb_ohci_resources,
>>               .enable = tc6393xb_ohci_enable,
>> -             .suspend = tc6393xb_ohci_disable,
>> +             .suspend = tc6393xb_ohci_suspend,
>>               .resume = tc6393xb_ohci_enable,
>>               .disable = tc6393xb_ohci_disable,
>>       },


-- 
With best wishes
Dmitry
