Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaDPREM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 13:04:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41926 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaDPREJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 13:04:09 -0400
Message-ID: <534EB803.5030101@wwwdotorg.org>
Date: Wed, 16 Apr 2014 11:04:03 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@nvidia.com>, Alan <gnomes@lxorguk.ukuu.org.uk>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V5.1] serial/uart/8250: Add tunable RX interrupt trigger
 I/F of FIFO buffers
References: <20140415055216.14660.18270.stgit@yunodevel> <20140415080649.19209.60645.stgit@yunodevel> <534D6EED.8000905@wwwdotorg.org> <534DE62C.3090300@hitachi.com>
In-Reply-To: <534DE62C.3090300@hitachi.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 08:08 PM, Yoshihiro YUNOMAE wrote:
> Hi Stephen,
> 
> Thank you for your review.
> 
> (2014/04/16 2:39), Stephen Warren wrote:
>> On 04/15/2014 02:06 AM, Yoshihiro YUNOMAE wrote:
>>> /* I found a bug in V5, so I resend this as V5.1. Please do not
>>> review V5. */
>>>
>>> Add tunable RX interrupt trigger I/F of FIFO buffers.
>>> Serial devices are used as not only message communication devices but
>>> control
>>> or sending communication devices. For the latter uses, normally small
>>> data
>>> will be exchanged, so user applications want to receive data unit as
>>> soon as
>>> possible for real-time tendency. If we have a sensor which sends a 1
>>> byte data
>>> each time and must control a device based on the sensor feedback, the RX
>>> interrupt should be triggered for each data.
>>>
>>> According to HW specification of serial UART devices, RX interrupt
>>> trigger
>>> can be changed, but the trigger is hard-coded. For example, RX
>>> interrupt trigger
>>> in 16550A can be set to 1, 4, 8, or 14 bytes for HW, but current
>>> driver sets
>>> the trigger to only 8bytes.

>>> diff --git a/drivers/tty/serial/8250/8250_core.c
>>> b/drivers/tty/serial/8250/8250_core.c
>>
>>> @@ -2275,10 +2276,9 @@ serial8250_do_set_termios(struct uart_port
>>> *port, struct ktermios *termios,
>>
>>>       if (up->capabilities & UART_CAP_FIFO && port->fifosize > 1) {
>>> -        fcr = uart_config[port->type].fcr;
>>> -        if ((baud < 2400 && !up->dma) || fifo_bug) {
>>> -            fcr &= ~UART_FCR_TRIGGER_MASK;
>>> -            fcr |= UART_FCR_TRIGGER_1;
>>> +        /* NOTE: If fifo_bug is not set, a uaser can set RX_trigger. */
>>> +        if ((baud < 2400 && !up->dma &&
>>> +            (up->fcr == uart_config[port->type].fcr)) ||
>>> up->fifo_bug) {
>>> +            up->fcr &= ~UART_FCR_TRIGGER_MASK;
>>> +            up->fcr |= UART_FCR_TRIGGER_1;
>>>           }
>>>       }
>>
>> Does the "(up->fcr == uart_config[port->type].fcr)" term prevent the
>> user from changing the trigger level multiple times? Perhaps this is
>> intended?
> 
> No, this means that if a user changed FCR value before setting termios,
> use the changed value because the user think changed value is always
> set. But, I thought this is not straightforward and it cannot help
> when the user want to use default FCR value.
> Could I add FCR changed flag(user_changed_fcr) in uart_8250_port
> structure and check the flag here?
> Or shouldn't the driver check the user changing?

Oh, I wasn't aware that the user could change FCR directly. To be
honest, I'm not sure of the best way to resolve that kind of conflict...
