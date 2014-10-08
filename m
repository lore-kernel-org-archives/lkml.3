Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbaJHUoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 16:44:03 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:42016 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJHUoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 16:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <1412799101.28467.68.camel@acox1-desk.ger.corp.intel.com>
References: <1412798258-23655-1-git-send-email-ricardo.ribalda@gmail.com>
 <1412798258-23655-4-git-send-email-ricardo.ribalda@gmail.com> <1412799101.28467.68.camel@acox1-desk.ger.corp.intel.com>
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 8 Oct 2014 22:43:38 +0200
Message-ID: <CAPybu_1vXc+=dVbradArvFYiFBy2c=0tTM7RAHDhycCkQQv_5g@mail.gmail.com>
Subject: Re: [PATCH 03/12] serial_core: Handle TIOC[GS]RS485 ioctls.
To: Alan Cox <alan@linux.intel.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Alan

This patchset adds no extra locking features, if the drivers did not
implement a locking mechanism (and none did) there is chance of
conflict.

I can add a call to lock/unlock around uart_[gs]et_rs485_config. And
then, inside the drivers, use the lock when the structure is used.

I would prefer to add it as new patches in the patchset, so in case
this adds some bugs they can be bisected easily.

Thanks for your fast reply



On Wed, Oct 8, 2014 at 10:11 PM, Alan Cox <alan@linux.intel.com> wrote:
> On Wed, 2014-10-08 at 21:57 +0200, Ricardo Ribalda Delgado wrote:
>> The following drivers: 8250_core, atmel_serial, max310x, mcf, omap-serial
>> and sci16is7xx implement code to handle RS485 ioctls.
>
>>
>> +static int uart_get_rs485_config(struct uart_port *port,
>> +                      struct serial_rs485 __user *rs485)
>> +{
>> +     if (!port->rs485_config)
>> +             return -ENOIOCTLCMD;
>> +
>> +     if (copy_to_user(rs485, &port->rs485, sizeof(port->rs485)))
>> +             return -EFAULT;
>> +     return 0;
>> +}
>> +
>> +static int uart_set_rs485_config(struct uart_port *port,
>> +                      struct serial_rs485 __user *rs485_user)
>> +{
>> +     struct serial_rs485 rs485;
>> +     int ret;
>> +
>> +     if (!port->rs485_config)
>> +             return -ENOIOCTLCMD;
>> +
>> +     if (copy_from_user(&rs485, rs485_user, sizeof(rs485_user)))
>> +             return -EFAULT;
>> +
>> +     ret = port->rs485_config(port, &rs485);
>> +     if (ret)
>> +             return ret;
>> +
>> +     if (copy_to_user(rs485_user, &port->rs485, sizeof(port->rs485)))
>> +             return -EFAULT;
>> +
>> +     return 0;
>> +
>
> What is the locking between setting/getting/driver use of the config ?
> This really needs a lock (termios sem I think is perhaps appropriate
> given when the values are normally referenced).
>
> Alan
>
>



-- 
Ricardo Ribalda
