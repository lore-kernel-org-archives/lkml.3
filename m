Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbaHUTdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 15:33:51 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:45646 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753383AbaHUTdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 15:33:49 -0400
Message-ID: <53F6498E.8000802@hurleysoftware.com>
Date: Thu, 21 Aug 2014 15:33:34 -0400
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
References: <1398971093-17164-1-git-send-email-m-karicheri2@ti.com> <53E39B44.60406@hurleysoftware.com> <53E3A67B.6070709@ti.com> <20140807171254.GA13097@kroah.com> <53E3B67E.80705@hurleysoftware.com> <53E3B88C.2000209@ti.com> <53E3C685.5010600@hurleysoftware.com> <53E3E597.7070305@ti.com> <53E405B6.7030602@hurleysoftware.com> <53E526CB.6060504@ti.com> <53E536CB.9080503@hurleysoftware.com> <53E53AD2.3020100@ti.com> <53E54A80.5070900@hurleysoftware.com> <53E55647.9010800@ti.com> <53E605F0.50404@ti.com>
In-Reply-To: <53E605F0.50404@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2014 07:28 AM, Murali Karicheri wrote:
> On 08/08/2014 06:59 PM, Murali Karicheri wrote:
>> On 08/08/2014 06:09 PM, Peter Hurley wrote:
>>> On 08/08/2014 05:02 PM, Murali Karicheri wrote:
>>>> On 08/08/2014 04:44 PM, Peter Hurley wrote:
>>>>> On 08/08/2014 03:36 PM, Murali Karicheri wrote:
>>>>>> On 08/07/2014 07:03 PM, Peter Hurley wrote:

[cut]

>>>>>> Based on my above discussion, there are few things required to be
>>>>>> done on top of AFE and some of it is done by my patch and the
>>>>>> remaining thing to be addressed in another patch.
>>>>>
>>>>> Assuming that AFE, as already implemented in the 8250 driver, works
>>>>> as expected,
>>>>> the fifo level check seems to be the only hurdle, right?
>>>>
>>>> Also how uart_set_termios() expect to work without my patch? that is
>>>> needed as well.
>>>
>>> That looks buggy, even if UPF_HARD_FLOW is set.
>>>
>>> But that's my point: the most general cases should be fixed, if
>>> necessary.
>>> Then, a trivial change to override the fifo size check from firmware
>>> is all you'll need
>>
>>
>> But then it seems like UPF_HARD_FLOW flag was introduced by
>> dba05832cbe4f305dfd998fb26d7c685d91fbbd8 SERIAL: core: add hardware
>> assisted h/w flow control support and I worked my patch around this.
>> This is misleading.
>>
>> Assume we don't use the UPF_HARD_FLOW anymore. Then in
>> uart_set_termios(), how does it know if the port has hw assisted hw flow
>> control?

Well UPF_HARD_FLOW seems to have been added specifically to handle
the requirements of the omap UART driver, rather than a comprehensive
API for handling hw flow control.

>> What is the other bug you mentioned?

It assumes the port hasn't been reconfigured from non-UPF_HARD_FLOW to
UPF_HARD_FLOW.

>>>>>>>> I want to work to fix this rather than revert this change as our
>>>>>>>> customer is already using this feature.
>>>>>>>
>>>>>>> 3.16 was released 4 days ago.
>>>>>>
>>>>>> As I said, I will work to address this with priority.
>>>>>
>>>>> My point was that I'm not understanding how your customer could be
>>>>> using this
>>>>> feature when it came out 4 days ago, but yet now you can't even test
>>>>> on the
>>>>> hardware?
>>>>
>>>> This fix was back ported to v3.13 that the customer is using.
>>>
>>> Ok, so your customer is running a custom kernel. Then I don't see the
>>> problem with backing
>>> this change out, rather than building on top of it.
>>
>> Customer will soon be switching to newer kernel and this become an
>> issue. So this must be addressed even if it requires a different fix.
>> At this point, I still think a fix is workable if we can make use of
>> existing UPF_HARD_FLOW flag that is meant for this scenario.
>>
>> Assuming we re-use auto-flow-control instead of the has-hw-flow-control,
>> and discard UPF_HARD_FLOW, we need to fix
>>
>> 1. limit to 32 bytes for fifo size as we have 16 bytes for keystone uart
>> 2. uart_prt_startup() support for the hw flow control
>> 3. uart_set_termios(), avoid stopping the hardware if port has hw flow
>> control
>>
>> For 1) no idea why 32 byte limit is required and for hw flow control
>> this is not needed. For 2) and 3, how does the serial core driver knows
>> if the uart port has the AFE capability with out using the flag.

As long as either UART_IER_RLSI or UART_IER_RDI is _always_ enabled, the
fifo size test is bogus; received data will continue to be read so the
receive FIFO will never overflow.

However, if throttling involves disabling both interrupts (UART_IER_RLSI
and UART_IER_RDI) _and_ the remote is not using hw flow control, then
the receive FIFO could overflow (because the remote has not stopped
transmitting fast enough and the 8250 irq handler is not reading data).

Since the 8250 driver does not disable either the line status or data
ready interrupt, throttling does not cause rx fifo overflow. It's
possible that buggy auto RTS implementations stop generating those
interrupts when RTS is deasserted automatically, but that should be
quirked for that silicon only if discovered to be true.

> I want to add one more piece of information related to my original patch that I had forgotten to mention so that right decision can be taken on this.
> 
> The patch was added for one more use case with a different customer. The use case was running BT over uart and this required hw flow control. In their testing they have never encountered any issue w.r.t throttle when they had run their performance test. So it makes me believe throttle is in fact may not be needed for keystone UART wih h/w flow control. So we might as well add a check in serial-core.c to check if throttle()/unthrottle() is implemented and then invoke it. This should address your concern. Also in your description of AFE, default behavior is good enough for AFE.

The bluetooth line discipline doesn't currently throttle; but if this is ever
fixed, the UART driver will start mysteriously blowing up because it didn't
implement throttle/unthrottle methods.

> Regarding the second issue, the change was added for the BT use case. As I don't have access to this customer's hardware, I wouldn't be able to verify if this use case indeed causes call to uart_handle_cts_change() due to a hardware bug since as per spec below, it is not supposed to generate interrupt or CTS change.
> 
> DCTS - Change in CTS indicator bit. DCTS indicates that the CTS input has changed state since the last time it was read by the CPU. When DCTS is set (autoflow control is not enabled and the modem status interrupt is  enabled), a modem status interrupt is generated. When autoflow control is enabled, no interrupt is generated.

I think DCTS is only latching the CTS input and has nothing to do with whether
an interrupt is being generated. IOW, a data ready interrupt will cause
the MSR to be read (in serial8250_modem_status()) which may indicate DCTS set,
if CTS was dropped to throttle this sender. Then if, for example, CLOCAL is off
and thus DCD is being monitored, this will cause uart_handle_cts_change() to be
called (because UART_IER_MSI will be on).

> I believe this check indeed can be moved to the 8250 function that make call to this and also increment the cts count as done in this function so that we could verify if this indeed increases for the AFE casee. I might be able to query the customer for the CTS count ever increase with BT use case, then if it doesn't this may be removed later or keep it to address the hardware issue.
> 
> As this patch was added to support 2 different use cases, one for a virtual serial port and another for BT over uart, I would strongly defer from reverting this patch and add a fix as described above. Do you know if there is any bug report because of this commit or you raised it as part of reviewing the code? If latter, I could send out a patch to fix it as described above.
> 
> Hope this will not get reverted and I will have an opportunity to send a fix once I am back from my vacation.

I think the way forward is:

1. Revert your patch
2. Remove the fifo size check

At this point both your use cases should work properly as the extra CTS
handling is just overhead and won't actually cause misbehavior.

Then, if you want to move forward from that point by eliminating the
extra CTS handling overhead then (as I see it) what's required is:

1. UPF_AUTO_CTS flag set if UART_EFR_CTS or UART_MCR_AFE (8250-specific)
2. Add UPF_AUTO_CTS test to UART_ENABLE_MS()
3. Suppress calls to uart_handle_cts_change if UPF_AUTO_CTS (or simply return
   from uart_handle_cts_change())
4. Set UPF_AUTO_CTS if UPF_HARD_FLOW is set (iow, UPF_HARD_FLOW should imply
   UPF_AUTO_CTS)
5. Check UPF_AUTO_CTS in uart_set_termios() (instead of UPF_HARD_FLOW),
   but only when changing to CRTSCTS, and not from CRTSCTS.
6. Override the check in uart_port_startup() if UPF_AUTO_CTS.

Other drivers that support auto CTS would also set UPF_AUTO_CTS; eg.,
mxs_auart and bfin_uart (when CONFIG_SERIAL_BFIN_HARD_CTSRTS).

UPF_HARD_FLOW should be scrapped, maybe along with the UART driver
throttle/unthrottle methods (although I haven't really given any thought
to handling in-band auto flow, aka UPF_SOFT_FLOW).

Any driver doing auto RTS would then override RTS by whatever method
required _whenever_ its set_mctrl() method indicates RTS has been lowered
(and reenabled when RTS is raised).

Right now, a driver doing UPF_HARD_FLOW via throttle/unthrottle doesn't
behave properly when the TIOCMSET ioctl is used to manually flow control
from userspace.

A UPF_AUTO_RTS flag could be added to help the UART driver remember
that its set_mctrl() method needs to virtualize RTS if required, like
for uarts where MCR RTS = 0 does not override the auto RTS setting.

Lastly, if a UART driver _knows_ that the remote is also wired for auto RTS
(like via a firmware flag), then its set_mctrl() method could _also_ disable
line status and data ready interrupts when RTS is lowered. UARTs with
a big rx fifo could do this always.

I would have already done this but I'm knee-deep in large patchsets for
serial and tty already.

Regards,
Peter Hurley
