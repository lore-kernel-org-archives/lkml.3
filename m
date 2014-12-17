Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaLQNbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:31:47 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:40481 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaLQNbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:31:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFu+--Nn+o+aSngcM=WW3ZTycuAHws6wUi4t8U2bh74TRjA@mail.gmail.com>
References: <1418226977-17128-1-git-send-email-ricardo.ribalda@gmail.com>
 <CAAVeFuKp89U=tUwOSUYktdPamK2=HXqpnJxR7M=H0LSmSYqcDQ@mail.gmail.com>
 <CAPybu_2eXhh7PuOTb=qpnoOOKYwwFynowHpDL-2PdsEqQEWYTQ@mail.gmail.com> <CAAVeFu+--Nn+o+aSngcM=WW3ZTycuAHws6wUi4t8U2bh74TRjA@mail.gmail.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 17 Dec 2014 14:31:23 +0100
Message-ID: <CAPybu_3=UiWgsO5gTeZeWEG1w7Qr3ZuU1C6vCw4zv+ysGC+j4Q@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] gpio/xilinx: Convert the driver to platform device interface
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 2:26 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Wed, Dec 17, 2014 at 8:02 PM, Ricardo Ribalda Delgado
> <ricardo.ribalda@gmail.com> wrote:
>> Hello Alexandre
>>
>>> This should not be here. The mapping and call to gpiochip_add() are
>>> performed by of_mm_gpiochip_add(). We should thus have a
>>> of_mm_gpiochip_remove() function that undoes what _add did instead of
>>> expected all users to do unmap themselves. Can you add a patch to your
>>> series that adds this function?
>>
>>>
>>> Also I am not sure I understand why the unmapping is done only once.
>>> Both chips are supposed to have been added (and thus mapped) at this
>>> stage. Oh right I see, so this driver ends up mapping the same area
>>> twice! Not only are you iomapping the same area twice, you are
>>> unmapping it only once, and only if the chip is dual. This looks very
>>> broken.
>>>
>>
>> If you look carefully you can see that it is unmapped twice if it is
>> called twice. iounmap is called inside the  for loop.
>
> D'oh, you are right of course. I don't know why, but I thought the
> iounmap() was part of the if (i == 1) conditional block. >_<
>
>>
>>
>>> Couldn't you redesign the driver the following way: only add one chip
>>> (since you have 1 DT node), with an extra member to track which GPIOs
>>> belong to the second chip (in case it is dual), and change the other
>>> functions to handle this.
>>
>> I do not mind rearranging the driver so there is only one gpio device,
>> even for dual chips, but I think this should be done in a separate
>> patch.
>>
>> What about?
>>
>> 1) Keep the current patchset
>>
>> and then
>>
>> 2) Add another patchset with
>>
>>   - xilinx-gpio: only one gpio device
>>   - add  of_mm_gpiochip_remove() to the api
>>   - xilinx gpio: use of_mm_gpiochip_remove
>>   - others: use of_mm_gpiochip_remove
>
> I think this would look better this way:
>
> - xilinx-gpio: remove offset property
> - xilinx-gpio: only one gpio device
> - add  of_mm_gpiochip_remove() to the api
> - xilinx-gpio: use of_mm_gpiochip_remove
> - xilinx-gpio: Convert the driver to platform device interface.
>
> (others: use of_mm_gpiochip_remove would be appreciated of course, but
> I won't ask you to go that far and fix everybody).
>
> The reason for this order is that your current patch would be shorter
> is the driver is turned to add one device only first. It's also
> generally better to work on cleaner code. But to switch the driver to
> single-device, you will first need to remove the offset property
> (IIUC, at least).


I totally see your point but I rather do not touch the first patchset,
two reasons.

One is that other people has already acked it and that it will make my
life easier and probably have it ready before the holidays :)


Anyway I could change your mind to:
 - xilinx-gpio: remove offset property
 - xilinx-gpio: Convert the driver to platform device interface.
 - xilinx-gpio: only one gpio device
 - add  of_mm_gpiochip_remove() to the api
 - xilinx-gpio: use of_mm_gpiochip_remove
?

Regards!



-- 
Ricardo Ribalda
