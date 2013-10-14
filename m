Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234Ab3JNPPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:15:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61456 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3JNPPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:15:30 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <525C0A8B.8050703@roeck-us.net>
Date: Mon, 14 Oct 2013 08:15:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chris Eastwood <chris2027@gmail.com>
CC: Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: support for Intel Atom based QNAP LEDs/buttons/buzzer in Linux?
References: <1381707976.3914.22.camel@heisenberg.scientia.net> <525B46A7.8000605@roeck-us.net> <CAO69nHLG6dY+x9TdkrO2neXUwv60j6sV0TfeTf9GwYyyyp+fZg@mail.gmail.com>
In-Reply-To: <CAO69nHLG6dY+x9TdkrO2neXUwv60j6sV0TfeTf9GwYyyyp+fZg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 12:29 AM, Chris Eastwood wrote:
>
> Hi all, nice to meet you and thank you for replying Guenter,
>
> The code you are talking about wasn't actually written by me, and I have been unable to get hold of the author; I have just been recompiling it to see what I can do with it.
>
> I have found that the GPIO driver is able to control the following LEDs:
>
> Power LED (green)
> Status LED (green, red)
> USB LED (blue)
> 8 HDD LEDs (*red only)
> /(and the USB copy button)/
>
> It does not appear to be able to control the *green *HDD LEDs though
>
> I found that the *green* HDD LEDs can be enabled through */drivers/ata/libata-scsi.c* by including a new function, here is what I took from qnap's source:
>
> #define SGPIO_RETRY_MAX 15
> static void ata_port_led(struct ata_port *ap,u8 on)
> {
> int rc = 0;
> int retry=0;
> if (ap->ops->em_store && (ap->flags & ATA_FLAG_EM)){
> for(retry = 0 ; retry < SGPIO_RETRY_MAX ; retry++){
>        rc = ap->ops->em_store(ap, on ? "0x80000" : "0x0", 4);
>        if (rc == -EBUSY)
>          udelay(100);
>        else
>          break;
>      }
>    }
>    if(retry == SGPIO_RETRY_MAX)
>      printk("%s:SGPIO always busy\n",__func__);
> }
>
>
> Which is then called from the following two locations:
>
>
> *void ata_scsi_scan_host(struct ata_port *ap, int sync)*
> *{*
> *  ...*
> *if (!IS_ERR(sdev)) {*
> ata_port_led(ap,1);
> *    ...*
> *  }*
> *  ...*
> *}*
>
>
> *static void ata_scsi_remove_dev(struct ata_device *dev)*
> *{*
> *  ...*
> *  if (sdev) {*
> ata_port_led(ap,0);
> *    ...*
> *  }*
> *}*
> *
> *
> Once booting the newly compiled kernel the green HDD LEDs are working and blinking correctly.
>
> What are your thoughts on the green HDD LEDs ?
>
It appears the LED is supposed to be controlled from userspace, possibly
with a udev rule or script.

There is a sysfs attribute which should be used for this purpose.
Search for "em_message" on /sys. Writing '0x80000' (as text) should turn
the LED on, writing '0x0' should turn it off. The attribute supports other
values as well. Search for "Enclosure Management LED Message Type" in the
kernel source.

Thanks,
Guenter

> Thank you!
>
> Chris
>
>
>
> On 14 October 2013 11:19, Guenter Roeck <linux@roeck-us.net <mailto:linux@roeck-us.net>> wrote:
>
>     On 10/13/2013 04:46 PM, Christoph Anton Mitterer wrote:
>
>         Hi Greg, Guenter and Chris.
>
>         Coming back to the stuff discussed previously[0].
>
>         Chris Eastwood has made most of these (i.e. LEDs and buttons, the
>         buzzers may work on at least some of the devices via some other serial
>         device) working (AFAIU based on the previously mentioned code at
>         Github[1]), he told me in several iterations of private mail.
>
>         I'm not sure now, whether anything based on this code would be
>         appropriate for the mainline kernel, since Guenter mentioned he'd prefer
>         a mfd core driver for all that... OTOH, the later may probably never
>         happen, and Chris' work seems to already do the job.
>
>         I don't know however, whether he needs to patch any other places in the
>         kernel, but I'm sure he can show his work (and ask questions) better
>         than I, thereby inviting him to do so.
>         Greg you had mentioned before that you might be able to spend some time
>         on this, so if you could help Chris, that would be great.
>
>
>     You really have two options - either an mfd driver with client drivers
>     for hwmon, gpio, watchdog (and possibly others), or a gpio driver which
>     shares access to the superio control registers. Both the it87 hwmon driver
>     and the it87 watchdog driver support the latter mechanism already, so that
>     would be the (much) simpler option. To control the LEDs you would then
>     simply use the leds-gpio driver. Input would need something similar -
>     no idea if there is a generic input-gpio driver; if not it might make sense
>     to write one. Another option there would be to have a platform driver which
>     would tie into the gpio driver and pass the gpio pin status to the input
>     subsystem.
>
>     I had a look at Chris' driver, but in my opinion it is simply too hardware
>     specific to be acceptable as-is. Of course, I would not make the call,
>     so that is just my persional opinion.
>
>     Thanks,
>     Guenter
>
>

