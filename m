Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbbAGOP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 09:15:27 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:56146 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbbAGOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 09:15:24 -0500
MIME-Version: 1.0
In-Reply-To: <C2D7FE5348E1B147BCA15975FBA2307565BCA499@IN01WEMBXA.internal.synopsys.com>
References: <54ABD526.9020907@hurleysoftware.com> <1420552747-27544-1-git-send-email-vgupta@synopsys.com>
 <CAL_JsqLzzLajoQAT3nYd5zi4=+zchXfVVPnYNriAZZi4tpa6yA@mail.gmail.com> <C2D7FE5348E1B147BCA15975FBA2307565BCA499@IN01WEMBXA.internal.synopsys.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 7 Jan 2015 08:15:01 -0600
X-Google-Sender-Auth: FeWbAecrR1rDuk7096tYMpJ_3_c
Message-ID: <CAL_JsqJ85u=vDK--AcYWV68ExXjo===YCPMe12qHF7QQV7EuPw@mail.gmail.com>
Subject: Re: [Patch v4] ARC: Dynamically determine BASE_BAUD from DeviceTree
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 12:36 AM, Vineet Gupta
<Vineet.Gupta1@synopsys.com> wrote:
> On Tuesday 06 January 2015 08:08 PM, Rob Herring wrote:
>> On Tue, Jan 6, 2015 at 7:59 AM, Vineet Gupta <Vineet.Gupta1@synopsys.com> wrote:
>>> 8250 earlycon is broken on multi-platform ARC because the UART clk
>>> value (BASE_BAUD) is fixed at build time.
>> Note that it should only be broken if you rely on the kernel to init
>> the uart. It should work if the boot loader configured the UART and
>> you don't specify the baudrate.
>
> But even if uboot set it up right - when the early 8250 is enabled in kernel, it
> will try to apply BASE_BAUD to re init it again.
> So if that doesn't match platform expectations, early prints will be garbled. Am I
> missing something here?

I could be wrong as I've only tested under QEMU which is why I'm
curious if you find it doesn't work for you. If you do not specify the
baud rate, the code will detect it by reading the divider registers.
Of course it will get a crap baud rate if BASE_BAUD is wrong, but it
just ends up setting the divider to the same value. I suppose there
could be a problem later on when the full driver loads if the wrong
baud rate is used then with a correct clock rate.

>>>  #include <asm/mach_desc.h>
>>>
>>> +#ifdef CONFIG_SERIAL_8250_CONSOLE
>>> +
>>> +static unsigned int arc_base_baud;
>> This can be initdata.
>
> OK !
>
>>
>>> +unsigned int __init arc_early_base_baud(void)
>>> +{
>>> +       return arc_base_baud/16;
>>> +}
>>> +
>>> +static void __init arc_set_early_base_baud(unsigned long dt_root)
>>> +{
>>> +       unsigned int core_clk = arc_get_core_freq();
>>> +
>>> +       if (of_flat_dt_is_compatible(dt_root, "abilis,arc-tb10x"))
>>> +               arc_base_baud = core_clk/3;
>> How many platforms do you expect this to be? This scales to maybe 10,
>> but not to 100 platforms. It certainly would not scale for ARM.
>
> The need for this came from our internal development of 2 new platform based on
> new ARCv2 ISA.
> They are slated to hit mainline sometime this year. Hence this is in a sense prep
> patch and converts the
> only existing upstream user of BASE_BAUD for ARC (tb10x). For ARC atleast I don't
> expect the scalability issue - yet :-)
> ARM doesn't seem define asm/serial.h (BASE_BAUD) and it probably works OK with the
> stub value in asm-generic ?

ARM does not yet have the necessary early fixmap support in mainline
to enable this feature yet.

Rob

>> If it
>> is a lot, then we need to find a generic way to describe this in DT.
>> For example, perhaps we require the uart node to have a
>> clock-frequency property or add a chosen property.
>
> Yeah that would indeed be cleanest way. But I think we shd be ok for now.
>
>> You could make this
>> part of the machine descriptor instead, but that wouldn't be my first
>> choice.
>
> Me neither !
>
> Thx,
> -Vineet
>
>>
>> Rob
>>
>
