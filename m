Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834AbaIEOMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:12:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44763 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932201AbaIEOMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:12:13 -0400
Message-ID: <5409C490.6020009@arm.com>
Date: Fri, 05 Sep 2014 15:11:28 +0100
From: Andre Przywara <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [RFC PATCH 1/1] drivers: introduce ARM SBSA generic UART driver
References: <1409328803-1953-1-git-send-email-andre.przywara@arm.com> <8453809.d9xRztN9Sq@wuerfel> <5401086F.1050601@arm.com> <3427461.cOVRFPXkyG@wuerfel>
In-Reply-To: <3427461.cOVRFPXkyG@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 02/09/14 20:51, Arnd Bergmann wrote:
> On Saturday 30 August 2014 00:10:39 Andre Przywara wrote:
>> On 08/29/2014 07:59 PM, Arnd Bergmann wrote:
>>> On Friday 29 August 2014 17:13:23 Andre Przywara wrote:
>>>> The ARM Server Base System Architecture (SBSA) describes a generic
>>>> UART which all compliant level 1 systems should implement. This is
>>>> actually a PL011 subset, so a full PL011 implementation will satisfy
>>>> this requirement.
>>>> However if a system does not have a PL011, a very stripped down
>>>> implementation complying to the SBSA defined specification will
>>>> suffice. The Linux PL011 driver is not guaranteed to drive this
>>>> limited device (and indeed the fast model implentation hangs the
>>>> kernel if driven by the PL011 driver).
>>>> So introduce a new driver just implementing the part specified by the
>>>> SBSA (which lacks DMA, the modem control signals and many of the
>>>> registers including baud rate control). This driver has been derived
>>>> by the actual PL011 one, removing all unnecessary code.
>>>>
>>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>>
>>>
>>> Hi Andre,
>>>
>>> Thanks for getting this driver ready. There is one high-level comment
>>> I have: As mentioned in the discussion in
>>> https://lkml.org/lkml/2014/7/28/386 , I think this should really be
>>> a tty driver using tty_port, not a serial driver using uart_port.
>>>
>>> What is the reason you chose to do a uart_port driver?
>>
>> Mainly because the SBSA is more of an UART than I originally
>> anticipated. It's intention may be more for debugging only, but it's
>> implementation is that of a real UART.
>> So the goldfish driver for instance seems to be tailored for a virtual
>> device, where TX/RX actually does not cost much. Also it supports
>> transmitting large chunks of data at once, an UART cannot do that. I
>> didn't find an obvious or easy way of implementing IRQ based
>> transmission. So if someone throws 10 KB at the driver, it will hog the
>> CPU for a second :-(
> 
> I think the driver is supposed to just return '0' from its tty->write
> function when there is no room for more data, and then call
> tty_wakeup() from the interrupt handler once some buffer space has
> been freed up.
> 
> Note that this is actually much simpler to do than the circ_buf
> handling in uart_port.
> 
>> Also there is this console line ending issue. The UART layer takes care
>> about changing LF into CR/LF, but in a pure TTY driver this needs to be
>> done explicitly. Hooking this into the code was a real nightmare.
> 
> It should not do that. Did you forget to set tty_std_termios?
> 
>> Also the error conditions the UART supports (frame error, break) are
>> hard to model in a pure TTY driver.
> 
> The register subset doesn't even support flow control, so what's the
> point in trying to support get_icount?

Thanks for those hints. I didn't dive too deep into this whole TTY layer
stuff, so I just took what goldfish used.
This looks like I could give this approach a try again then - it should
solve my problems - BUT the ttyxxx naming thing still stands.

And it seems like this is a show-stopper.
Introducing yet another serial prefix seems to be the wrong direction.
Actually one should rather rework the whole serial subsystem to allow a
single prefix naming regardless of the driver(s) used. And NO, I am not
volunteering - I already have a job for the next year ;-)

>> So after having coded it based on goldfish I decided to go for a real
>> UART driver instead, and the result is much better.
> 
>>> A few more details below:
>>>
>>>> +}
>>>> +EARLYCON_DECLARE(pl011, sbsa_uart_early_console_setup);
>>>> +OF_EARLYCON_DECLARE(pl011, "arm,sbsa-uart", sbsa_uart_early_console_setup);
>>>
>>> Stray 'pl011' left from copying the code?
>>
>> Actually left in deliberately (to reuse existing kernel command lines),
>> but I know see that this was silly.
>> The earlycon routines of PL011 are actually the same as for the SBSA
>> UART, so both can use one implementation. And registering them twice
>> under the same name triggers a warning during boot.
>> I have to check how this can be shared if only one driver is compiled in.
>>
>>>> +static struct uart_driver sbsa_uart_reg = {
>>>> +	.owner			= THIS_MODULE,
>>>> +	.driver_name		= "sbsa_uart",
>>>> +	.dev_name		= "ttyAMA",
>>>> +	.nr			= UART_NR,
>>>> +	.cons			= SBSA_UART_CONSOLE,
>>>> +};
>>>
>>> I don't think we should overload the ttyAMA name.
>>
>> That triggered a lot of discussion here. Actually most people don't want
>> to introduce yet another serial prefix. Also since the both devices are
>> so similar and this driver can drive a full PL011 also, I decided to
>> reuse it.
>> This still has issues if both drivers are active, but I consider this
>> saner for the user this way.
> 
> I'm not convinced. It sounds absolutely possible that someone makes a
> system that needs both drivers simultaneously, sbsa_uart for the console
> (with the settings in place from the boot loader and no registers to
> change them) and a proper uart for talking to other devices. If the
> earlycon line or the device names are conflicting, you get into
> trouble.

I agree - and looking more closely I see a suspicious boot message when
I tried a setup similar to your one (on the model).
So this earlycon things needs to be addressed separately. I think the
smartest solution is to integrate the driver in the PL011 one.
In fact I was working on this lately, coming pretty far without being
too ugly. It includes some refactoring of PL011 (which makes the code
even more readable, IMO) and introducing a second set of struct uart_ops
plus an AMBA-less probe routine (which could be used by ACPI later, too).
I will post it as soon as I have found a smart solution for this one
remaining issue (accessing CR to enable the UART in the console code).

>>>> +#ifdef CONFIG_OF
>>>> +
>>>> +static int dt_probe_serial_alias(int index, struct device *dev)
>>>> +{
>>>> +	struct device_node *np;
>>>> +	static bool seen_dev_with_alias;
>>>> +	static bool seen_dev_without_alias;
>>>> +	int ret = index;
>>>> +
>>>> +	if (!IS_ENABLED(CONFIG_OF))
>>>> +		return ret;
>>>
>>> The #ifdef should go away since you already have the if
>>> (!IS_ENABLED(CONFIG_OF)) logic here.
>>
>> Right, this is redundant, but I'd rather remove the IS_ENABLED() line,
>> since I provide a non-DT implementation of that routine below.
> 
> That would mean you don't get any build-time coverage if CONFIG_OF
> is disabled. Please just remove all the #ifdefs you can so that the
> compiler gets to see the code and discard all unused parts of it.

Good point. Will try this (in the reworked PL011 driver).

Thanks for looking more closely at the code and for good hints.

Grüße,
Andre.
