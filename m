Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaHIL3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 07:29:49 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53856 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaHIL3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 07:29:43 -0400
Message-ID: <53E605F0.50404@ti.com>
Date: Sat, 9 Aug 2014 07:28:48 -0400
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
References: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com> <53E39B44.60406@hurleysoftware.com> <53E3A67B.6070709@ti.com> <20140807171254.GA13097@kroah.com> <53E3B67E.80705@hurleysoftware.com> <53E3B88C.2000209@ti.com> <53E3C685.5010600@hurleysoftware.com> <53E3E597.7070305@ti.com> <53E405B6.7030602@hurleysoftware.com> <53E526CB.6060504@ti.com> <53E536CB.9080503@hurleysoftware.com> <53E53AD2.3020100@ti.com> <53E54A80.5070900@hurleysoftware.com> <53E55647.9010800@ti.com>
In-Reply-To: <53E55647.9010800@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 06:59 PM, Murali Karicheri wrote:
> On 08/08/2014 06:09 PM, Peter Hurley wrote:
>> On 08/08/2014 05:02 PM, Murali Karicheri wrote:
>>> On 08/08/2014 04:44 PM, Peter Hurley wrote:
>>>> On 08/08/2014 03:36 PM, Murali Karicheri wrote:
>>>>> On 08/07/2014 07:03 PM, Peter Hurley wrote:
>>>>
>>>> [...]
>>>>
>>>>>> But I realize now that a different question needs asking:
>>>>>> Is the MSR read showing delta CTS set when AFE is on, ever?
>>>>>
>>>>> Unfortunately this was tested on a customer board that I don't have
>>>>> access to and can't check this out right away. I am trying to
>>>>> findout if I can get some hardware to test the patch to address the
>>>>> issue being discussed. Customer board is currently using RTS and
>>>>> CTS lines and the same works fine for them with this patch.
>>>>
>>>> Ok.
>>>>
>>>>
>>>>>> Because serial8250_modem_status() assumes the answer is no for
>>>>>> _all_ AFE-capable devices, and if yes, would mean that
>>>>>> serial8250_modem_status()
>>>>>> is broken if AFE is on.
>>>>>
>>>>> As per Keystone UART spec
>>>>>
>>>>> bit 0 in MSR: DCTS: Change in CTS indicator bit. DCTS indicates
>>>>> that the CTS input has changed state since the last time it was
>>>>> read by the CPU. When DCTS is set (autoflow control is not enabled
>>>>> and the modem status interrupt is enabled), a modem status
>>>>> interrupt is generated. When autoflow control is enabled, no
>>>>> interrupt is generated
>>>>>
>>>>> So based on this, there shouldn't be any CTS change if AFE is
>>>>> enabled and will indicate change if AFE is disabled. Probably add
>>>>> WARN_ON_ONCE() as you suggested to detect any offending h/w.
>>>>
>>>> That's identical wording to the 16750 datasheet.
>>>>
>>>> But notice that it only says "no interrupt is generated" when AFE is
>>>> on.
>>>> It doesn't say if the MSR is read, that DCTS won't be set. And that's
>>>> an important difference for how serial8250_modem_status() works.
>>>>
>>>> [...]
>>>>
>>>>
>>>>>>>> uart_throttle() and uart_unthrottle() are used indirectly by
>>>>>>>> line disciplines
>>>>>>>> for high-level rx flow control, such as when a read buffer fills
>>>>>>>> up because
>>>>>>>> there is no userspace reader. The 8250 core doesn't define a
>>>>>>>> throttle/unthrottle
>>>>>>>> method because writing MCR to drop RTS is sufficient to disable
>>>>>>>> auto-RTS.
>>>>>>>
>>>>>>> As per spec. hardware has rx threshold levels set to trigger an
>>>>>>> RTS level change to tell
>>>>>>> the remote from sending more bytes. So if h/w flow control is
>>>>>>> enabled, then not sure why
>>>>>>> uart_throttle() is to be doing anything when h/w flow control is
>>>>>>> supported? A dummy
>>>>>>> function required to satisfy the line discipline?
>>>>>>
>>>>>> I understand how auto-RTS works.
>>>>>>
>>>>>> Let's pretend for a moment that uart_throttle() does nothing when
>>>>>> auto-RTS is enabled:
>>>>>>
>>>>>> 1. tty buffers start to fill up because no process is reading the
>>>>>> data.
>>>>>> 2. The throttle threshold is reached.
>>>>>> 3. uart_throttle() is called but does nothing.
>>>>>> 4. more data arrives and the DR interrupt is triggered
>>>>>> 5. serial8250_rx_chars() reads in the new data.
>>>>>> 6. tty buffers keep filling up even though the driver was told to
>>>>>> throttle
>>>>>> 7. eventually the tty buffers will cap at about 64KB and start
>>>>>> counting
>>>>>> buf_overrun errors
>>>>>>
>>>>> Ok.
>>>>>
>>>>> Couple of observation on the AFE implementation in 8250 driver
>>>>> prior to my patch.
>>>>>
>>>>> From the discussion so far, AFE is actually hardware assisted
>>>>> hardware flow control. Auto CTS is sw assisted hardware flow control
>>>>> where sw uses RTS line for recieve side flow control and I assume
>>>>> it uses MCR RTS bit for this where AFE does this automatically. From
>>>>> the 16550 or Keystone UART spec, I can't find how RTS line can be
>>>>> asserted to do this through sw instead of hardware doing it
>>>>> automatically. Spec says
>>>>>
>>>>> MCR RTS bit: RTS control. When AFE = 1, the RTS bit determines th
>>>>> e autoflow control enabled. Note that all UARTs do not support this
>>>>> feature. See the device-specific data manual for supported
>>>>> features. If this feature is not available, this bit is reserved
>>>>> and should be cleared to 0.
>>>>> 0 = UARTn_RTS is disabled, only UARTn_CTS is enabled.
>>>>> 1 = UARTn_RTS and UARTn_CTS are enabled.
>>>>>
>>>>> Then since AFE was already supported before my patch for FIFO size
>>>>> 32bytes or higher, I am wondering why there was no implementation
>>>>> of throttle()/unthrottle() to begin with and why UPF_HARD_FLOW flag
>>>>> is not set at all if AFE implemented in 8250 driver is hw assisted,
>>>>> hw flow control. Also what do these API supposed to do?
>>>>
>>>> uart_throttle() does _not_ call ops->throttle() unless either
>>>> UPF_SOFT_FLOW and/or UPF_HARD_FLOW is set in uport->flags.
>>>>
>>>
>>> Not based on port flag. Here is the actual code in serial_core.c as I
>>> see it.
>>
>> You're misreading the code.
>>
>>
>>> static void uart_throttle(struct tty_struct *tty)
>>> {
>>> struct uart_state *state = tty->driver_data;
>>> struct uart_port *port = state->uart_port;
>>> uint32_t mask = 0;
>>>
>>> if (I_IXOFF(tty))
>>> mask |= UPF_SOFT_FLOW;
>>> if (tty->termios.c_cflag& CRTSCTS)
>>> mask |= UPF_HARD_FLOW;
>>
>> mask = UPF_HARD_FLOW
>>
>> port->flags does not have UPF_HARD_FLOW set so
>>
>> (port->flags& mask) == false
>>
>
> Ok. My bad.
>
>>> if (port->flags& mask) {
>>> port->ops->throttle(port);
>>> mask&= ~port->flags;
>>> }
>>>
>>> if (mask& UPF_SOFT_FLOW)
>>> uart_send_xchar(tty, STOP_CHAR(tty));
>>>
>>> if (mask& UPF_HARD_FLOW)
>>> uart_clear_mctrl(port, TIOCM_RTS);
>>> }
>>
>> [...]
>>
>>>>> Based on my above discussion, there are few things required to be
>>>>> done on top of AFE and some of it is done by my patch and the
>>>>> remaining thing to be addressed in another patch.
>>>>
>>>> Assuming that AFE, as already implemented in the 8250 driver, works
>>>> as expected,
>>>> the fifo level check seems to be the only hurdle, right?
>>>
>>> Also how uart_set_termios() expect to work without my patch? that is
>>> needed as well.
>>
>> That looks buggy, even if UPF_HARD_FLOW is set.
>>
>> But that's my point: the most general cases should be fixed, if
>> necessary.
>> Then, a trivial change to override the fifo size check from firmware
>> is all you'll need
>
>
> But then it seems like UPF_HARD_FLOW flag was introduced by
> dba05832cbe4f305dfd998fb26d7c685d91fbbd8 SERIAL: core: add hardware
> assisted h/w flow control support and I worked my patch around this.
> This is misleading.
>
> Assume we don't use the UPF_HARD_FLOW anymore. Then in
> uart_set_termios(), how does it know if the port has hw assisted hw flow
> control? What is the other bug you mentioned?
>>
>>
>>>>>>> I want to work to fix this rather than revert this change as our
>>>>>>> customer is already using this feature.
>>>>>>
>>>>>> 3.16 was released 4 days ago.
>>>>>
>>>>> As I said, I will work to address this with priority.
>>>>
>>>> My point was that I'm not understanding how your customer could be
>>>> using this
>>>> feature when it came out 4 days ago, but yet now you can't even test
>>>> on the
>>>> hardware?
>>>
>>> This fix was back ported to v3.13 that the customer is using.
>>
>> Ok, so your customer is running a custom kernel. Then I don't see the
>> problem with backing
>> this change out, rather than building on top of it.
>
> Customer will soon be switching to newer kernel and this become an
> issue. So this must be addressed even if it requires a different fix.
> At this point, I still think a fix is workable if we can make use of
> existing UPF_HARD_FLOW flag that is meant for this scenario.
>
> Assuming we re-use auto-flow-control instead of the has-hw-flow-control,
> and discard UPF_HARD_FLOW, we need to fix
>
> 1. limit to 32 bytes for fifo size as we have 16 bytes for keystone uart
> 2. uart_prt_startup() support for the hw flow control
> 3. uart_set_termios(), avoid stopping the hardware if port has hw flow
> control
>
> For 1) no idea why 32 byte limit is required and for hw flow control
> this is not needed. For 2) and 3, how does the serial core driver knows
> if the uart port has the AFE capability with out using the flag.
>

Peter,

I want to add one more piece of information related to my original patch 
that I had forgotten to mention so that right decision can be taken on this.

The patch was added for one more use case with a different customer. The 
use case was running BT over uart and this required hw flow control. In 
their testing they have never encountered any issue w.r.t throttle when 
they had run their performance test. So it makes me believe throttle is 
in fact may not be needed for keystone UART wih h/w flow control. So we 
might as well add a check in serial-core.c to check if 
throttle()/unthrottle() is implemented and then invoke it. This should 
address your concern. Also in your description of AFE, default behavior 
is good enough for AFE.

Regarding the second issue, the change was added for the BT use case. As 
I don't have access to this customer's hardware, I wouldn't be able to 
verify if this use case indeed causes call to uart_handle_cts_change() 
due to a hardware bug since as per spec below, it is not supposed to 
generate interrupt or CTS change.

DCTS - Change in CTS indicator bit. DCTS indicates that the CTS input 
has changed state since the last time it was read by the CPU. When DCTS 
is set (autoflow control is not enabled and the modem status interrupt 
is  enabled), a modem status interrupt is generated. When autoflow 
control is enabled, no interrupt is generated.

I believe this check indeed can be moved to the 8250 function that make 
call to this and also increment the cts count as done in this function 
so that we could verify if this indeed increases for the AFE casee. I 
might be able to query the customer for the CTS count ever increase with 
BT use case, then if it doesn't this may be removed later or keep it to 
address the hardware issue.

As this patch was added to support 2 different use cases, one for a 
virtual serial port and another for BT over uart, I would strongly defer 
from reverting this patch and add a fix as described above. Do you know 
if there is any bug report because of this commit or you raised it as 
part of reviewing the code? If latter, I could send out a patch to fix 
it as described above.

Hope this will not get reverted and I will have an opportunity to send a 
fix once I am back from my vacation.

Thanks and regards,

Murali

> I will restart this thread after my vacation. Meanwhile if you have
> suggestions as to how to deal with 1-3, please respond so that I can
> work on a patch based on it.
>
> Thanks and regards,
>
> Murali
>>
>> Regards,
>> Peter Hurley
>>
>>
>

