Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756AbaHHWJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:09:15 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36866 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932500AbaHHWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 18:09:11 -0400
Message-ID: <53E54A80.5070900@hurleysoftware.com>
Date: Fri, 08 Aug 2014 18:09:04 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Murali Karicheri <m-karicheri2@ti.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Slaby <jslaby@suse.cz>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] serial: uart: add hw flow control support configuration
References: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com> <53E39B44.60406@hurleysoftware.com> <53E3A67B.6070709@ti.com> <20140807171254.GA13097@kroah.com> <53E3B67E.80705@hurleysoftware.com> <53E3B88C.2000209@ti.com> <53E3C685.5010600@hurleysoftware.com> <53E3E597.7070305@ti.com> <53E405B6.7030602@hurleysoftware.com> <53E526CB.6060504@ti.com> <53E536CB.9080503@hurleysoftware.com> <53E53AD2.3020100@ti.com>
In-Reply-To: <53E53AD2.3020100@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 05:02 PM, Murali Karicheri wrote:
> On 08/08/2014 04:44 PM, Peter Hurley wrote:
>> On 08/08/2014 03:36 PM, Murali Karicheri wrote:
>>> On 08/07/2014 07:03 PM, Peter Hurley wrote:
>>
>> [...]
>>
>>>> But I realize now that a different question needs asking:
>>>> Is the MSR read showing delta CTS set when AFE is on, ever?
>>>
>>> Unfortunately this was tested on a customer board that I don't have access to and can't check this out right away. I am trying to findout if I can get some hardware to test the patch to address the issue being discussed. Customer board is currently using RTS and CTS lines and the same works fine for them with this patch.
>>
>> Ok.
>>
>>
>>>> Because serial8250_modem_status() assumes the answer is no for
>>>> _all_ AFE-capable devices, and if yes, would mean that serial8250_modem_status()
>>>> is broken if AFE is on.
>>>
>>> As per Keystone UART spec
>>>
>>> bit 0 in MSR: DCTS: Change in CTS indicator bit. DCTS indicates that the CTS input has changed state since the last time it was read by the CPU. When DCTS is set (autoflow control is not enabled and the modem status interrupt is enabled), a modem status interrupt is generated. When autoflow control is enabled, no interrupt is generated
>>>
>>> So based on this, there shouldn't be any CTS change if AFE is enabled and will indicate change if AFE is disabled. Probably add WARN_ON_ONCE() as you suggested to detect any offending h/w.
>>
>> That's identical wording to the 16750 datasheet.
>>
>> But notice that it only says "no interrupt is generated" when AFE is on.
>> It doesn't say if the MSR is read, that DCTS won't be set. And that's
>> an important difference for how serial8250_modem_status() works.
>>
>> [...]
>>
>>
>>>>>> uart_throttle() and uart_unthrottle() are used indirectly by line disciplines
>>>>>> for high-level rx flow control, such as when a read buffer fills up because
>>>>>> there is no userspace reader. The 8250 core doesn't define a throttle/unthrottle
>>>>>> method because writing MCR to drop RTS is sufficient to disable auto-RTS.
>>>>>
>>>>> As per spec. hardware has rx threshold levels set to trigger an RTS level change to tell
>>>>> the remote from sending more bytes. So if h/w flow control is enabled, then not sure why
>>>>> uart_throttle() is to be doing anything when h/w flow control is supported? A dummy
>>>>> function required to satisfy the line discipline?
>>>>
>>>> I understand how auto-RTS works.
>>>>
>>>> Let's pretend for a moment that uart_throttle() does nothing when
>>>> auto-RTS is enabled:
>>>>
>>>> 1. tty buffers start to fill up because no process is reading the data.
>>>> 2. The throttle threshold is reached.
>>>> 3. uart_throttle() is called but does nothing.
>>>> 4. more data arrives and the DR interrupt is triggered
>>>> 5. serial8250_rx_chars() reads in the new data.
>>>> 6. tty buffers keep filling up even though the driver was told to throttle
>>>> 7. eventually the tty buffers will cap at about 64KB and start counting
>>>>      buf_overrun errors
>>>>
>>> Ok.
>>>
>>> Couple of observation on the AFE implementation in 8250 driver prior to my patch.
>>>
>>>  From the discussion so far, AFE is actually hardware assisted hardware flow control. Auto CTS is sw assisted hardware flow control
>>> where sw uses RTS line for recieve side flow control and I assume it uses MCR RTS bit for this where AFE does this automatically. From
>>> the 16550 or Keystone UART spec, I can't find how RTS line can be asserted to do this through sw instead of hardware doing it automatically. Spec says
>>>
>>> MCR RTS bit: RTS control. When AFE = 1, the RTS bit determines th
>>> e autoflow control enabled. Note that all UARTs do not support this feature. See the device-specific data manual for supported features. If this feature is not available, this bit is reserved and should be cleared to 0.
>>> 0 = UARTn_RTS is disabled, only UARTn_CTS is enabled.
>>> 1 = UARTn_RTS and UARTn_CTS are enabled.
>>>
>>> Then since AFE was already supported before my patch for FIFO size 32bytes or higher, I am wondering why there was no implementation of throttle()/unthrottle() to begin with and why UPF_HARD_FLOW flag is not set at all if AFE implemented in 8250 driver is hw assisted, hw flow control. Also what do these API supposed to do?
>>
>> uart_throttle() does _not_ call ops->throttle() unless either
>> UPF_SOFT_FLOW and/or UPF_HARD_FLOW is set in uport->flags.
>>
> 
> Not based on port flag. Here is the actual code in serial_core.c as I see it.

You're misreading the code.


> static void uart_throttle(struct tty_struct *tty)
> {
>     struct uart_state *state = tty->driver_data;
>     struct uart_port *port = state->uart_port;
>     uint32_t mask = 0;
> 
>     if (I_IXOFF(tty))
>         mask |= UPF_SOFT_FLOW;
>     if (tty->termios.c_cflag & CRTSCTS)
>         mask |= UPF_HARD_FLOW;

mask = UPF_HARD_FLOW

port->flags does not have UPF_HARD_FLOW set so

         (port->flags & mask) == false

>     if (port->flags & mask) {
>         port->ops->throttle(port);
>         mask &= ~port->flags;
>     }
> 
>     if (mask & UPF_SOFT_FLOW)
>         uart_send_xchar(tty, STOP_CHAR(tty));
> 
>     if (mask & UPF_HARD_FLOW)
>         uart_clear_mctrl(port, TIOCM_RTS);
> }

[...]

>>> Based on my above discussion, there are few things required to be done on top of AFE and some of it is done by my patch and the remaining thing to be addressed in another patch.
>>
>> Assuming that AFE, as already implemented in the 8250 driver, works as expected,
>> the fifo level check seems to be the only hurdle, right?
> 
> Also how uart_set_termios() expect to work without my patch? that is needed as well.

That looks buggy, even if UPF_HARD_FLOW is set.

But that's my point: the most general cases should be fixed, if necessary.
Then, a trivial change to override the fifo size check from firmware is all you'll need


>>>>> I want to work to fix this rather than revert this change as our customer is already using this feature.
>>>>
>>>> 3.16 was released 4 days ago.
>>>
>>> As I said, I will work to address this with priority.
>>
>> My point was that I'm not understanding how your customer could be using this
>> feature when it came out 4 days ago, but yet now you can't even test on the
>> hardware?
> 
> This fix was back ported to v3.13 that the customer is using.

Ok, so your customer is running a custom kernel. Then I don't see the problem with backing
this change out, rather than building on top of it.

Regards,
Peter Hurley
 

