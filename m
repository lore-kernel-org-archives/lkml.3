Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab3GYQSn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:18:43 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:43532 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244Ab3GYQSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:18:39 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:f1aa]
In-Reply-To: <20130725161406.GD31835@radagast>
References: <1374605750-29565-1-git-send-email-olof@lixom.net>
	<20130725161406.GD31835@radagast>
Date: Thu, 25 Jul 2013 09:18:39 -0700
Message-ID: <CAOesGMiupSqpqfyuJ_abr4UQj9Ot77aGJZTsCEY63v-XttgPgw@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
From: Olof Johansson <olof@lixom.net>
To: Felipe Balbi <balbi@ti.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 9:14 AM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Tue, Jul 23, 2013 at 11:55:50AM -0700, Olof Johansson wrote:
>> This resolves the following valid build warning:
>>
>> drivers/usb/gadget/at91_udc.c:1685:34: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
>>
>> I switched from ? : to !! mostly to save from wrapping the lines while
>> I was at it.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>> ---
>>
>> Felipe, this would be nice to see fixed for 3.11 but I'd argue that it's
>> been here long enough to not really be needed for -stable.
>>
>>  drivers/usb/gadget/at91_udc.c |   12 ++++++++++--
>>  1 file changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
>> index 073b938..f3dbcd0 100644
>> --- a/drivers/usb/gadget/at91_udc.c
>> +++ b/drivers/usb/gadget/at91_udc.c
>> @@ -1682,12 +1682,20 @@ static void at91udc_of_init(struct at91_udc *udc,
>>
>>       board->vbus_pin = of_get_named_gpio_flags(np, "atmel,vbus-gpio", 0,
>>                                                 &flags);
>> -     board->vbus_active_low = (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
>> +     if (board->vbus_pin < 0)
>> +             pr_err("%s: Failed to get atmel,vbus-gpio property\n",
>> +                    np->full_name);
>> +     else
>> +             board->vbus_active_low = !!(flags & OF_GPIO_ACTIVE_LOW);
>
> should you even continue if you can't get the gpio ? If this gpio is
> optional, then it's not really and error, rather a debugging or
> informational message.

That's what the code does today, and I wasn't trying to second-guess
their decisions on that. Chances are firmware, in some instances, have
left power on so continuing might do no harm.

> BTW, this vbus-gpio looks, to me at least, like a fixed regulator
> controlled by a GPIO, no ?

Yes, it does. We have plenty of these kind of bindings from before
everything had to be a regulator.


-Olof
