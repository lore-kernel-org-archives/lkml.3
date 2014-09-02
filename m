Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaIBNVR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 09:21:17 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:59470 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaIBNVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 09:21:15 -0400
MIME-Version: 1.0
In-Reply-To: <540596A6.8000608@arm.com>
References: <1409328803-1953-1-git-send-email-andre.przywara@arm.com>
 <1409328803-1953-2-git-send-email-andre.przywara@arm.com> <CAL_JsqJbAWRhduzMwdQMh8sDdVqTWVK2Ej9LQjx4gp2ifwxe6Q@mail.gmail.com>
 <540596A6.8000608@arm.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 2 Sep 2014 08:20:53 -0500
Message-ID: <CAL_Jsq+Rs5MXC7s7EeWAEAPxxqaShAVGt=cdQxud5Us+-Zp6jw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] drivers: introduce ARM SBSA generic UART driver
To: Andre Przywara <andre.przywara@arm.com>
Cc: "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 5:06 AM, Andre Przywara <andre.przywara@arm.com> wrote:
> Hi Rob,
>
> thanks for looking at this.
>
> On 02/09/14 04:06, Rob Herring wrote:
>> On Fri, Aug 29, 2014 at 11:13 AM, Andre Przywara <andre.przywara@arm.com> wrote:
>>> The ARM Server Base System Architecture (SBSA) describes a generic
>>> UART which all compliant level 1 systems should implement. This is
>>> actually a PL011 subset, so a full PL011 implementation will satisfy
>>> this requirement.
>>> However if a system does not have a PL011, a very stripped down
>>> implementation complying to the SBSA defined specification will
>>> suffice. The Linux PL011 driver is not guaranteed to drive this
>>> limited device (and indeed the fast model implentation hangs the
>>> kernel if driven by the PL011 driver).
>>> So introduce a new driver just implementing the part specified by the
>>> SBSA (which lacks DMA, the modem control signals and many of the
>>> registers including baud rate control). This driver has been derived
>>> by the actual PL011 one, removing all unnecessary code.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  .../devicetree/bindings/serial/arm_sbsa_uart.txt   |    6 +
>>>  drivers/tty/serial/Kconfig                         |   28 +
>>>  drivers/tty/serial/Makefile                        |    1 +
>>>  drivers/tty/serial/sbsa_uart.c                     |  793 ++++++++++++++++++++
>>>  include/uapi/linux/serial_core.h                   |    1 +
>>
>> Sorry, but I think this is all wrong. We've now just duplicated some
>> subset of the pl011 driver leaving out the parts like setting baudrate
>> which can never be added since those things could be different for
>> every vendor.
>>
>> The original intent of the SBSA uart was to provide a common early
>> debug uart. It was not to have a full fledged driver. I think the SBSA
>> has failed in this area and created the potential to create a mess of
>> serial drivers different for every vendor. Reality will hopefully not
>> be that extreme and most vendors will just use the pl011 and create
>> their value add somewhere besides the uart. For the purpose of debug
>> output, we already support that as the pl011 earlycon only touches
>> SBSA compatible registers.
>
> I see your point (and was actually looking for those kind of comments
> when posting this).
> I agree to that debug aspect and understand that earlycon already does
> this, but I think we need some support beyond earlycon, to be able to
> login and use it as a console (which is not possible with earlycon,
> right?) This is probably still for debugging or emergency access to the
> system only, but maybe also for logging - actually quite similar to how
> UARTs are used on today's x86 servers.
> So after having written three incarnations of this driver (goldfish
> based, PL010 based, PL011 based) I wonder if supporting the SBSA subset
> in the real PL011 driver is an option. Either this would be enabled by a
> new explicit DT property or preferably by a clever compatible string.
> Ideally we would just provide a different set of "struct uart_ops"
> members, with some pointing to generic PL011 routines, some to SBSA UART
> specific ones.
> Maybe we make the full featured PL011 support a config option
> (defaulting to y), allowing people to only use the SBSA subset in their
> kernel?

I think your choices are add the option into pl011 driver or move the
common parts of pl011 driver into a common lib.

>
> Does that make more sense? (for a general SBSA h/w rationale see below)
>
>>>  5 files changed, 829 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/serial/arm_sbsa_uart.txt
>>>  create mode 100644 drivers/tty/serial/sbsa_uart.c
>>>
>>> diff --git a/Documentation/devicetree/bindings/serial/arm_sbsa_uart.txt b/Documentation/devicetree/bindings/serial/arm_sbsa_uart.txt
>>> new file mode 100644
>>> index 0000000..8e2c5d6
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/serial/arm_sbsa_uart.txt
>>> @@ -0,0 +1,6 @@
>>> +* ARM SBSA defined generic UART
>>> +
>>> +Required properties:
>>> +- compatible: must be "arm,sbsa-uart"
>>
>> This alone is not okay. There is no such implementation of hardware.
>
> But the SBSA explicitly allows this. I don't know of any vendor who just
> implements the subset, but I've been told that this has been asked for.

To use baudrate as an example, that must be configurable somehow
either with pl011 registers or in a vendor specific way. I suppose you
could do an actual implementation with all those things hardcoded in
the design, but that seems unlikely.

Regardless of config registers, if you have 10 different implementers
of a spec, you need 10 different compatible strings because you will
have 10 different sets of quirks. See the 8250 driver if you need
proof of that.

>> The DT must specify the implementation such as pl011.
>
> If it is a full featured PL011: sure. Then we don't need this driver at
> all and just use the SBSA UART spec as a guideline for our earlycon
> implementation.
> I will try to learn if there is someone actually implementing only the
> subset.

I would have assumed you knew someone is. Otherwise, I don't really
think anything should be implemented at this point. Perhaps adding
SBSA uart as an explicit earlycon option would be worthwhile. Also, we
should consider using ttySx instead of ttyAMAx for SBSA compliant
systems (including ones with pl011).

Rob
