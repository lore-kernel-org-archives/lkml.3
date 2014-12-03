Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaLCTbD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:31:03 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:53506 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaLCTa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:30:59 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 0/3] Add "Simple" / Renesas Bus State Controller Driver
References: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
	<6261300.I132f1jLqB@wuerfel>
	<CAMuHMdVjpL-QgS0aAdMo4EHXibhpKCJC73yY+HDY=+Ae=LMigA@mail.gmail.com>
	<7h4mtlen8f.fsf@deeprootsystems.com>
	<CAMuHMdWCGQwLVb1K5jRxWToe-de8T_A5n08FsjEiv8z1B9Q4oA@mail.gmail.com>
Date: Wed, 03 Dec 2014 11:30:55 -0800
In-Reply-To: <CAMuHMdWCGQwLVb1K5jRxWToe-de8T_A5n08FsjEiv8z1B9Q4oA@mail.gmail.com>
	(Geert Uytterhoeven's message of "Wed, 3 Dec 2014 10:30:06 +0100")
Message-ID: <7hbnnkzg28.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:

> Hi Kevin, Arnd,
>
> I've been giving this some more thoughts...
>
> On Wed, Nov 26, 2014 at 9:11 PM, Kevin Hilman <khilman@kernel.org> wrote:
>> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>>> On Mon, Nov 24, 2014 at 9:15 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>>>> On Monday 24 November 2014 21:10:05 Geert Uytterhoeven wrote:
>>>>> As this minimal BSC driver isn't hardware-specific at all, I'm wondering
>>>>> if there's a simpler way to do this?
>>>>>   - Should the driver be renamed to "simple-bus", and match "simple-bus"?
>>>>>   - Should this be moved to core code, without an explicit driver for
>>>>>     "simple-bus"? I.e. should the driver core just enable runtime PM for
>>>>>     all devices not bound to a driver, as they may represent buses with
>>>>>     child devices that do rely on runtime PM?
>>>>>
>>>>> Thanks for your comments and suggestions!
>>>>
>>>> My understanding of simple-bus is that it's something that does
>>>> not have any power-management capabilities, and I'd rather not
>>>> add clocks or interrupts to it.
>
> Should I not add the interrupt to the device node, even though I do
> know the hardware block has an interrupt?
> Of course, to make use of the interrupt, you do need a hardware-specific
> driver that binds to the specific compatible name. But for now such a
> driver is overkill, as I do not need to use the interrupt.
>
> Power domains (and clocks used for power management) are different,
> as they are platform features: they may appear in any device node, even if
> the bindings for the device node don't mention them.
> Else I cannot add them to a node that's compatible with e.g. "arm,cortex-a15"
> or "arm,pl310-cache", without adding (or completely replacing them with)
> compatible names like "renesas,r8a73a4-cortex-a15" resp.
> "renesas,sh73a0-pl310-cache"?
> Hence I think they should be allowed in "simple-bus" nodes, too.
>
>>>> What I think makes more sense is to have a bus driver for it
>>>> in drivers/bus, remove the "simple-bus" compatibility value
>>>> and have the driver take care of registering the power domain
>>>> and probing the child devices using of_platform_populate on
>>>> itself.
>>>
>>> Registering power domains is already handled by the core code.
>>>
>>> So compared to my RFC code, I only have to
>>>   1. Drop "simple-bus" from the compatible property in the .dtsi,
>>>   2. Call of_platform_populate() from renesas_bsc_probe(), to
>>>      register the child devices, now the core code no longer does that.
>>>
>>> I find it a bit strange having to add _more_ code, as the core code handles
>>> registering child devices fine. Doing it from my bus driver only protects
>>> against people trying to run a kernel without my bus driver included
>>> (which currently works fine, as long as no PM domain or clock is involved,
>>>  e.g. if the clock is forgotten in the SoC's .dtsi :-).
>>
>> I actually rather like the simple bus driver in it's current form, where
>> the device and pm-domain registration is taken care of by the
>> core. Since it's really not HW specific at all, maybe just rename it
>> simple-pm-bus or something like that?
>
> That means writing bindings for a new bus type "simple-pm-bus"?

Well, I'm OK with adding common properties to simple-bus also, but
presuably you'll want to document those as well in a binding doc for
simple-bus.

Kevin

