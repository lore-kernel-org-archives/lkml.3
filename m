Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaLPQOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 11:14:11 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:50534 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaLPQOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 11:14:09 -0500
Message-ID: <54905A4E.6060205@hurleysoftware.com>
Date: Tue, 16 Dec 2014 11:14:06 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: NeilBrown <neilb@suse.de>, Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] TTY: add support for "tty slave" devices.
References: <20141211214801.4127.93914.stgit@notabene.brown>	<20141211215943.4127.24792.stgit@notabene.brown>	<548A264D.8070103@hurleysoftware.com>	<20141212162352.66be5b5e@notabene.brown>	<548AE778.90205@hurleysoftware.com> <20141213142344.61372b92@lxorguk.ukuu.org.uk>
In-Reply-To: <20141213142344.61372b92@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 09:23 AM, One Thousand Gnomes wrote:
> On Fri, 12 Dec 2014 08:02:48 -0500
>> Which brings up another point: why not do this in the runtime power management;
>> ie, turn on the slave device when the master device is turned on? Sebastian
>> recently made the 8250 driver power-managed per access, which would enable
>> significant power savings over just leaving the slave device on the whole time.
> 
> That per access model only works on 8250 (in fact only on some 8250). On
> most devices if the UART is in low power you lose bytes send to it rather
> than then queuing up anywhere.
> 
> It doesn't handle cases where you need to keep power on to different rules
> (for example there are cases where you do things like power the uart down
> after no bits have been received for 'n' millseconds). Right now if you
> look into Androidspace you'll find people doing this in userspace by
> having the sysfs node open and playing crazy games with sysfs, Android
> glue hacks and gpio poking via the gpio sysfs/gpio lib routines.
> 
> Good example is some of the GPS and serial based sensor chips. The
> latency of tty open/close is unacceptable and risks losing bits so they
> keep the tty open and whack the power management by hand right now.
> 
> The kind of thing many of them want is stuff like
> 
> "hold power on until we see receive data, then keep it on until it shuts
> up for a bit"
> 
> "assert gpio, send, receive, wait idle, drop gpio"
> 
> "on GPIO interrupt wake uart, wait for data, when idle, power uart down"
> 
>>>> 2) why is this tied to the tty core and not the serial core
>>>>    if this is only for UART?
>>>
>>> Because the knowledge of "the device is being opened" or "the device is being
>>> closed" seems to exist in the tty core but not in the serial core.
>>
>> uart_open() = device file is being opened
>> uart_close() = device file is being released
> 
> Only for a subset of uart type devices that use the uart layer. Quite a
> few don't, including all the USB ones, and the sd ones.
> 
>>> I'm happy to move it to serial_core.c if that is preferred.
>>> I'll also move the open/close handling if you can point to where it should go.
>>
>> Yes, please.
> 
> NAK - I certainly object to it being moved to uart. That's the wrong
> abstraction layer for this. It's a generic behaviour, it's a tty level
> behaviour without any uart specific properties. It should work for uarts
> that don't use the legacy serial_core code, uarts that do, uarts that use
> USB, uarts that are directly connected to things like sdio etc.
> 
> That means it has to be tty layer.

I was reviewing the patch submitted, which does none of the things you
outlined and does not provide the necessary infrastructure to build upon it.

I'm all for the functionality you describe but I think that design will end
up subsystem-agnostic.

Regards,
Peter Hurley


