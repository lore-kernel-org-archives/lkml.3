Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbaGaNuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 09:50:10 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:64743 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223AbaGaNuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 09:50:03 -0400
MIME-Version: 1.0
In-Reply-To: <CADVatmOooxEKJ26i9nED2OKmBghOwuz6fjGJmYO0tuopTEoLDw@mail.gmail.com>
References: <1406729236-19887-1-git-send-email-sudipm.mukherjee@gmail.com>
	<53D90340.3010000@suse.cz>
	<CADVatmOooxEKJ26i9nED2OKmBghOwuz6fjGJmYO0tuopTEoLDw@mail.gmail.com>
Date: Thu, 31 Jul 2014 19:20:01 +0530
Message-ID: <CADVatmNyxzz5aborjsBGj6nE_u7jVyWss26gFQV7EPWXSGjZGQ@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: serial_core.c: printk replacement
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 8:22 PM, Sudip Mukherjee
<sudipm.mukherjee@gmail.com> wrote:
> On Wed, Jul 30, 2014 at 8:07 PM, Jiri Slaby <jslaby@suse.cz> wrote:
>> On 07/30/2014, 04:07 PM, Sudip Mukherjee wrote:
>>> printk replaced with corresponding dev_*
>>> fixed two broken user-visible strings used by the corresponding printk
>>>
>>>
>>> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
>>> ---
>>>  drivers/tty/serial/serial_core.c | 19 ++++++++++---------
>>>  1 file changed, 10 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
>>> index 8bb19da..ef48d0f 100644
>>> --- a/drivers/tty/serial/serial_core.c
>>> +++ b/drivers/tty/serial/serial_core.c
>> ...
>>> @@ -1974,8 +1974,8 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
>>>               for (tries = 3; !ops->tx_empty(uport) && tries; tries--)
>>>                       msleep(10);
>>>               if (!tries)
>>> -                     printk(KERN_ERR "%s%s%s%d: Unable to drain "
>>> -                                     "transmitter\n",
>>> +                     dev_err(uport->dev,
>>> +                             "%s%s%s%d: Unable to drain transmitter\n",
>>>                              uport->dev ? dev_name(uport->dev) : "",
>>
>> Hi, this does not look correct. You use uport->dev, but there is a test
>> whether it is NULL in the parameters.
>>
>> You would have to investigate if and when uport->dev can be NULL and
>> document it in the commit log above.
>
> HI
> Thanks for reviewing it . I am checking out all the cases in which
> uport can be null and will resend the patch.
>
> Thanks
> Sudip
>
>>
>> thanks,
>> --
>> js
>> suse labs

Hi
All the investigations has made me even more confused , and I am
looking for a bit of guidance from you now.

uport->dev can only be null if it is a virtual device and no real
device is attached to the driver , but that again should not be the
case with a serial port . And , for the function uart_suspend_port ,
if i use dev_err , then i feel it wllll be much more better to use
tty_dev instead of uport->dev . ( in that function we have tty_dev =
device_find_child(uport->dev, &match, serial_match_port); ) - using
tty_dev as the device in the dev_err is giving better device
description.

Now to my confusion :
we have  tty_dev = device_find_child(uport->dev, &match,
serial_match_port);  - so if uport->dev is NULL , then
device_find_child also returns NULL , making tty_dev = NULL .  But
immediately after that statement we have : if
(device_may_wakeup(tty_dev)) -  so if tty_dev is NULL , then
device_may_wakeup will try to access tty_dev->power , in short it will
try to access NULL->power . So shouldn't we have kernel panic if we
try dereferencing a NULL pointer or then should we assume that
uport->dev can never by NULL ....

Thanks
Sudip
