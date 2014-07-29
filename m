Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaG2JRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:17:30 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44670 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbaG2JR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:17:28 -0400
Message-ID: <53D766A2.1070004@linaro.org>
Date: Tue, 29 Jul 2014 10:17:22 +0100
From: Graeme Gregory <graeme.gregory@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andre Przywara <andre.przywara@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: Mark Rutland <Mark.Rutland@arm.com>, Mark Brown <broonie@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 19/19] Documentation: ACPI for ARM64
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <5959830.lpqeqL7HbK@wuerfel> <53D65C16.2050202@arm.com> <13731398.6CtXoCyCVq@wuerfel> <53D67703.7090306@arm.com>
In-Reply-To: <53D67703.7090306@arm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 28/07/2014 17:14, Andre Przywara wrote:
>
> On 28/07/14 16:23, Arnd Bergmann wrote:
>> On Monday 28 July 2014 15:20:06 Andre Przywara wrote:
>>> On 28/07/14 11:46, Arnd Bergmann wrote:
>>>> On Monday 28 July 2014 10:23:57 Graeme Gregory wrote:
>>>>> The PL011 UART is the use-case I keep hitting, that IP block has a
>>>>> variable input clock on pretty much everything I have seen in the wild.
>>>> Ok, I see. What does ACPI-5.1 say about pl011?
>>>>
>>>> Interestingly, the subset of pl011 that is specified by SBSA does not
>>>> contain the IBRD/FBRD registers, effectively making it a fixed-rated
>>>> UART (I guess that would be a ART, without the U then), and you
>>>> consequently don't even need to know the clock rate.
>>> The idea of this was probably to let the baudrate set by some firmware
>>> code to the "right" value and the spec just didn't want to expose the
>>> details for the generic UART:
>>> "This specification does not cover registers needed to configure the
>>> UART as these are considered hardware-specific and will be set up by
>>> hardware-specific software."
>>> To me that reads like the SBSA UART is just for debugging, and you are
>>> expected just to access the data register.
>> Right, makes sense. It also avoids the case where Linux for some reason
>> ends up using a different line rate than the firmware, which can
>> cause a lot of unnecessary pain.
I must be suffering snow blindness reading specs, I totally missed that 
the pl011 subset does not allow baud setting. This means that my current 
test hardware "Juno" does not actually need any clocks defined in DSDT 
at this stage (given that this new driver is created).

I may then return to my original opinion of not defining clocks in the 
DSDT at all.

Graeme

>>>> However, my guess is that most hardware in the real world contains
>>>> an actual pl011 and it does make a lot of sense to allow setting
>>>> the baud rate on it, which then requires knowing the input clock.
>>>>
>>>> If there is any hardware that implements just the SBSA-mandated subset
>>>> rather than the full pl011, we should probably implement both
>>>> in the kernel: a dumb driver that can only send and receive, and the
>>>> more complex one that can set the bit rates and flow-control but that
>>>> requires a standardized ACPI table with the input clock rate.
>>> The fast model I use can be switched to use the SBSA restricted PL011,
>>> and as expected the Linux kernel crashes at the device doesn't support
>>> DMA (and a lot more stuff) - but the current code requires it.
>> It does? We have a lot of platforms that don't have DMA support for
>> pl011.
> Well, to be honest I just booted the full featured kernel with the
> changed fast model config, so the platform and the DT claimed DMA
> support, just the emulated hardware doesn't implement it ;-)
> And beside that a whole lot of other PL011 registers are not available,
> so the crash could be caused by anything. I didn't look to closely why
> it broke.
>
>>> So I am about to implement a new driver for that SBSA subset. So far
>>> this will be a separate driver, starting from a copy of amba-pl011.c,
>>> but removing most of the code ;-)
>> Ok. You might want to consider starting from a different base though.
>> IIRC, pl011 uses uart_port as the basic abstraction, while the
>> new driver should probably use the raw tty_port instead.
>> drivers/tty/goldfish.c is probably a good example to look at for
>> that.
> Good hint, will look at this.
>
> Cheers,
> Andre.
>
>> You could also make it a hvc_driver like drivers/tty/hvc/hvc_vio.c,
>> but I'm not sure if that model seen favorable by the tty maintainers.
>> It would probably be the shortest driver though.
>>
>> 	Arnd
>>
>>

