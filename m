Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257AbaHHWVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:21:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35088 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbaHHUq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:46:58 -0400
Message-ID: <53E53720.7090706@ti.com>
Date: Fri, 8 Aug 2014 16:46:24 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Slaby <jslaby@suse.cz>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] serial: uart: add hw flow control support configuration
References: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com> <53E39B44.60406@hurleysoftware.com> <53E3A67B.6070709@ti.com> <20140807171254.GA13097@kroah.com> <53E3B67E.80705@hurleysoftware.com> <53E3B88C.2000209@ti.com> <53E3C685.5010600@hurleysoftware.com> <53E3E597.7070305@ti.com> <53E405B6.7030602@hurleysoftware.com> <53E526CB.6060504@ti.com>
In-Reply-To: <53E526CB.6060504@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 03:36 PM, Murali Karicheri wrote:
> On 08/07/2014 07:03 PM, Peter Hurley wrote:
>
> ----Cut-------------
>>>>>
>>>>>>
>>>>>> 1. The patch enables UPF_HARD_FLOW, but provides no throttle() and
>>>>>> unthrottle()
>>>>>> methods for 8250, which is guaranteed to blow-up when either
>>>>>> uart_throttle() or
>>>>>> uart_unthrottle() is called.
>>>>>>
>>>>>> 2. The patch adds capabilities which already exist, namely
>>>>>> UART_CAP_AFE.
>>>>
>>>>> AFAIK, UART_CAP_AFE is a software assisted hw flow control and it
>>>>> was described in my commit log as well where as this patch add
>>>>> support for pure h/w controlled flow control and no software
>>>>> intervention is needed. Do you think uart_throttle() or
>>>>> uart_unthrottle() is applicable
>>>>> in this case?
>>>>
>>>> UART_CAP_AFE is used to indicate 16750-compatible hw flow control,
>>>> which is
>>>> auto-CTS and auto-RTS flow control as described in the TI datasheet at
>>>> http://www.ti.com/lit/ds/symlink/tl16c750.pdf
>>>
>>> Peter,
>>>
>>> This patch was added to support hw flow control on boards based on
>>> Keystone SoCs that has UART with h/w flow control capability.
>>> Keystone SoCs UART spec is at
>>> http://www.ti.com/lit/ug/sprugp1/sprugp1.pdf
>>> and it uses tl16550c as per the document. The equivalent spec seems
>>> to be http://www.ti.com/lit/ds/symlink/tl16c550c.pdf. Only difference
>>> between tl16c750 and tl16c550 seems to be 16 byte FIFO available
>>> instead of 16 or 64 byte FIFO in 16c750.
>>
>> So this is just a way to avoid the fifo size check.
>> Then I'd rather see a capability that only overrides the fifo size check
>> and does not enable UPF_HARD_FLOW.
>>
>> Or show that the fifo size check is not actually required for AFE.
>>
>>
>>> And about your original question
>>>>>>>>> Why is a modem status interrupt being generated for DCTS
>>>>>>>>> if autoflow control is enabled?
>>>
>>> Are you asking why this patch didn't disable generating CTS interrupt
>>> when h/w flow control is enable?
>>
>> No. I was asking what chip had AFE on but still generated modem status
>> interrupts for delta CTS.
>>
>> But I realize now that a different question needs asking:
>> Is the MSR read showing delta CTS set when AFE is on, ever?
>
> Unfortunately this was tested on a customer board that I don't have
> access to and can't check this out right away. I am trying to findout if
> I can get some hardware to test the patch to address the issue being
> discussed. Customer board is currently using RTS and CTS lines and the
> same works fine for them with this patch.
>
>>
>> Because serial8250_modem_status() assumes the answer is no for
>> _all_ AFE-capable devices, and if yes, would mean that
>> serial8250_modem_status()
>> is broken if AFE is on.
>
> As per Keystone UART spec
>
> bit 0 in MSR: DCTS: Change in CTS indicator bit. DCTS indicates that the
> CTS input has changed state since the last time it was read by the CPU.
> When DCTS is set (autoflow control is not enabled and the modem status
> interrupt is enabled), a modem status interrupt is generated. When
> autoflow control is enabled, no interrupt is generated
>
> So based on this, there shouldn't be any CTS change if AFE is enabled
> and will indicate change if AFE is disabled. Probably add WARN_ON_ONCE()
> as you suggested to detect any offending h/w.
>
>>
>>
>>> If so,
>>>
>>> unsigned int serial8250_modem_status(struct uart_8250_port *up)
>>> {
>>> ...
>>> if (status& UART_MSR_DCTS)
>>> uart_handle_cts_change(port, status& UART_MSR_CTS);
>>> }
>>>
>>> Probably in the above check if UPF_HARD_FLOW is set, we can avoid
>>> calling
>  >> uart_handle_cts_change() and undo the current code change in
> uart_handle_cts_change()
>  >> and just add a WARN_ON_ONCE() as you have suggested.
>>
>> Let's come back to this question after determining the answer for the
>> above question.
>>
>>
>>>>
>>>> uart_throttle() and uart_unthrottle() are used indirectly by line
>>>> disciplines
>>>> for high-level rx flow control, such as when a read buffer fills up
>>>> because
>>>> there is no userspace reader. The 8250 core doesn't define a
>>>> throttle/unthrottle
>>>> method because writing MCR to drop RTS is sufficient to disable
>>>> auto-RTS.
>>>
>>> As per spec. hardware has rx threshold levels set to trigger an RTS
>>> level change to tell
>  >> the remote from sending more bytes. So if h/w flow control is
> enabled, then not sure why
>  >> uart_throttle() is to be doing anything when h/w flow control is
> supported? A dummy
>  >> function required to satisfy the line discipline?
>>
>> I understand how auto-RTS works.
>>
>> Let's pretend for a moment that uart_throttle() does nothing when
>> auto-RTS is enabled:
>>
>> 1. tty buffers start to fill up because no process is reading the data.
>> 2. The throttle threshold is reached.
>> 3. uart_throttle() is called but does nothing.
>> 4. more data arrives and the DR interrupt is triggered
>> 5. serial8250_rx_chars() reads in the new data.
>> 6. tty buffers keep filling up even though the driver was told to
>> throttle
>> 7. eventually the tty buffers will cap at about 64KB and start counting
>> buf_overrun errors
>>
> Ok.
>
> Couple of observation on the AFE implementation in 8250 driver prior to
> my patch.
>
>  From the discussion so far, AFE is actually hardware assisted hardware
> flow control. Auto CTS is sw assisted hardware flow control
> where sw uses RTS line for recieve side flow control and I assume it
> uses MCR RTS bit for this where AFE does this automatically. From
> the 16550 or Keystone UART spec, I can't find how RTS line can be
> asserted to do this through sw instead of hardware doing it
> automatically. Spec says
>
> MCR RTS bit: RTS control. When AFE = 1, the RTS bit determines th
> e autoflow control enabled. Note that all UARTs do not support this
> feature. See the device-specific data manual for supported features. If
> this feature is not available, this bit is reserved and should be
> cleared to 0.
> 0 = UARTn_RTS is disabled, only UARTn_CTS is enabled.
> 1 = UARTn_RTS and UARTn_CTS are enabled.
>
> Then since AFE was already supported before my patch for FIFO size
> 32bytes or higher, I am wondering why there was no implementation of
> throttle()/unthrottle() to begin with and why UPF_HARD_FLOW flag is not
> set at all if AFE implemented in 8250 driver is hw assisted, hw flow
> control. Also what do these API supposed to do?
>
> in serial_core.c, uart_throttle() function
>
> if CRTSCTS is set
> port->ops->throttle(port);
> Also call at the end
> uart_clear_mctrl(port, TIOCM_RTS);
> and this go an clear the MCR RTS bit.
>
> So what does uart_throttle() API expected to do since MCR is updated
> using uart_clear_mctrl().
>
> I searched who sets the UPF_HARD_FLOW in port->flags and only driver
> that does set this flag is omap-serial.c. The check was introduced by
> commit from Ruessel King to support h/w assisted h/w flow control.
>
> ======================================================================
> commit dba05832cbe4f305dfd998fb26d7c685d91fbbd8
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date: Tue Apr 17 16:41:10 2012 +0100
>
> SERIAL: core: add hardware assisted h/w flow control support
>
> Ports which are handling h/w flow control in hardware must not have
> their RTS state altered depending on the tty's hardware-stopped state.
> Avoid this additional logic when setting the termios state.
>
> Acked-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ======================================================================
>
> This flag is checked in uart_set_termios() and the reason is in the
> commit log above.
>
> So shouldn't AFE support in 8250 make use of this flag? My patch uses DT
> attribute to set this flag so above uart_set_termios() function behave
> as expected. But as you have rightly pointed out throttle()/unthrottle()
> is missing that needs to be added. Only driver that I can find that has
> implemented this is omap_serial.c. It does disable RDI and RLSI as part
> of throttle() interrupt and re-enable it as part of unthrottle().
> Probably I can add this in this driver as well if this is what is
> expected. I will post a patch for this anyways, with some basic testing,
> but testing on customer h/w for this was initialially implemented has to
> wait until my return from vacation (on vacation from 08/11-08/16).
>
>>
>>> Also 8250.c support other port types that doesn't have AFE. So shoudl
>>> this
>  >> be driving RTS line to stop the sender and resume when
> uart_unthrottle() is called?
>>
>> Yes, because that's how sw-assisted CTS flow control works, and the
>> default behavior of uart_throttle/uart_unthrottle.
>>
>> IOW, with no extra code or special-casing, AFE just works.
>>
>
> Based on my above discussion, there are few things required to be done
> on top of AFE and some of it is done by my patch and the remaining thing
> to be addressed in another patch.
>
>>> I want to work to fix this rather than revert this change as our
>>> customer is already using this feature.
>>
>> 3.16 was released 4 days ago.
>
> As I said, I will work to address this with priority.
Peter, Greg,

I have send out an RFC "serial: uart: update to support hw assisted hw 
flow control" to address this issue based on this thread.
I did only some basic testing on this and want to get your feedback.
I will work to test this patch on our customer board once I return from 
my vacation. Please review and give your comments..

Thanks and regards,

Murali Karicheri

>
>>
>> Regards,
>> Peter Hurley
>>
>

