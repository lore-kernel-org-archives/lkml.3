Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3LDVGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 16:06:52 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45918 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3LDVGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 16:06:48 -0500
MIME-Version: 1.0
In-Reply-To: <20131202210719.GQ24997@rocoto.smurfnet.nu>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
	<1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
	<CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
	<20131202210719.GQ24997@rocoto.smurfnet.nu>
Date: Wed, 4 Dec 2013 15:06:47 -0600
Message-ID: <CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
From: Matt Sealey <neko@bakuhatsu.net>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, matt.fleming@intel.com,
        Grant Likely <grant.likely@linaro.org>,
        Roy Franz <roy.franz@linaro.org>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>, linaro-uefi@lists.linaro.org,
        Mark Rutland <mark.rutland@arm.com>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 3:07 PM, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> On Mon, Dec 02, 2013 at 01:51:22PM -0600, Matt Sealey wrote:
>> Here's where I think this whole thing falls down as being the weirdest
>> possible implementation of this. It defies logic to put this
>> information in the device tree /chosen node while also attempting to
>> boot the kernel using an EFI stub; the stub is going to have this
>> information because it is going to have the pointer to the system
>> System Table (since it was called by StartImage()). Why not stash the
>> System Table pointer somewhere safe in the stub?
>
> We do. In the DT.

Hang on... see way below about "reinventing the wheel"

>> The information in the device tree is all accessible from Boot
>> Services and as long as the System Table isn't being thrown away (my
>> suggestion would be.. stuff it in r2, and set r1 = "EFI\0" then work
>> with arch/arm/kernel/head{-common,}.S code to do the right thing)
>
> You left out the bit of redefining the kernel boot protocol to permit
> calling it with caches, MMU and interrupts enabled - also known as
> before ExitBootServices().

And that's a horrible idea because of what?

What's evident here is there could be two major ways to generate an
image that boots from a UEFI implementation;

* one whereby UEFI is jostled or coerced by second stage bootloader to
load a plain zImage and you lose all information about UEFI except in
the event that that information is preserved in the device tree by the
firmware
* one whereby a 'stock' UEFI is used and it boots only on UEFI because
it is in a format very reasonably only capable of being booted by UEFI
and, subordinately,
 - one where that plain zImage got glued to an EFI stub just like the
decompressor is glued to the Image
 - one where the kernel needs to be built with support for UEFI and
that somewhat changes the boot path

By the time we get half-way through arm/kernel/head.S the cache and
MMU has been turned off and on and off again by the decompressor, and
after a large amount of guesswork and arbitrary restriction-based
implementation, there's no guarantee that the kernel hasn't been
decompressed over some important UEFI feature or some memory hasn't
been trashed. You can't make that guarantee because by entering the
plain zImage, you forfeited that information. This is at worst case
going to be lots of blank screens and blinking serial console prompts
and little more than frustration..

Most of the guessing is ideally not required to be a guess at all, the
restrictions are purely to deal with the lack of trust for the
bootloader environment. Why can't we trust UEFI? Or at least hold it
to a higher standard. If someone ships a broken UEFI, they screw a
feature or have a horrible bug and ship it, laud the fact Linux
doesn't boot on it and the fact that it's their fault - over their
head. It actually works these days, Linux actually has "market share,"
companies really go out of their way to rescue their "image" and
resolve the situation when someone blogs about a serious UEFI bug on
their $1300 laptops, or even $300 tablets.

> Which is what we are going to implement anyway in order to permit
> firmware to supply DT hardware description in the same way as with
> ACPI. Yes, we could pass the system table pointer directly - but that
> doesn't get us the memory map.

Boot Services gives you the ability to get the memory map.. and the
kinds of things that live in those spots in the memory map. It's at
least a better guess than "I am located at a specific place and can
infer from linker data and masking off the bottom bits that there's
probably this amount of RAM that starts at this location or
thereabouts". It at least gives the ability to 'allocate' memory to
put the page table instead of having a firmware call walk all over it,
or having the kernel walk over some parts of firmware, or even not
have to do anything except link in a decompressor (eh, sure, it means
duplicating decompressor code in some cases, but I also don't think
it's a sane requirement to include the entire decompression suite in
the kernel proper if it only gets used once at early boot).

> I prefer to see it as a way to not reinvent things that do not need
> reinventing, while not adding more special-case code to the kernel.

Isn't putting the System Table pointer in the DT specifically
reinventing the UEFI boot process?

Booting from UEFI is a special case in itself.. the EFI stub here is
putting a round block in a square hole.

There are two much, much better solutions: put the round block in a
round hole. Put a square block in that square hole. We could do so
much better than gluing the round block into the square hole.

>> What that meant is nobody bothered to implement working, re-entrant,
>> re-locatable firmware to a great degree. This ended up being a
>> self-fulfilling prophecy of "don't trust the bootloader" and "get rid
>> of it as soon as we can," which essentially meant Linux never took
>> advantage of the resources available. In OF's case, the CIF sucked by
>> specification. In UEFI's case here, it's been implemented in Linux in
>> such a way that guarantees poor-performing firmware code with huge
>> penalties to call them, which isn't even required by UEFI if the
>> earlier boot code did the right things in the first place.
>
> I don't follow. In which way does this implementation result in poor
> performance or reduced functionality?

I believe what I am trying to object to is this weird process of
getting to a state where you can get to UEFI, and why anyone would
bother gluing the existing Linux kernel image to the back of an
externally-built stub, only to do some really quite obnoxious tricks
to enable it to go into a decompressor and then through, kernel setup
head, that make a bunch of assumptions about the bootloader interface,
then to try and recover the information that got thrown away and THEN
attempt to reinstate some kind of UEFI functionality.

If your platform has UEFI, then your platform has UEFI - if you built
a multiplatform kernel that needs to boot on U-Boot, then you glued an
EFI stub to it to make it boot. At some point between the stub and the
runtime services driver, you're going through 10,000 lines of code
with the information that it *is* running on top of UEFI completely
lost to the boot process.

I believe I am also objecting to the idea that the way this is BEST
implemented is to take a stock zImage (decompressor+Image payload) and
glue a stub in front to resolve the interface issue when the
implication is extra complication to the boot process.

By not actually using it, nobody actually bothered to improve the
firmware or fix bugs in the places where it could have been used. This
ends up as a self-fulfilling prophecy of exhausting amounts of broken
and unoptimized firmware.

Nobody in firmware-land has any impetus to fix those bugs or add
useful optional features.

By "by not actually using it," I do mean the case where someone has
UEFI and somehow boots a plain zImage and a DTB modified to include
the System Table pointer. Because that door is completely wide open..

Personally I think having a well known environment at StartImage()
jumping to your EFI application entry point is a great place to
simplify the decompressor by integrating it into the stub.

At the point you then jump into kernel/head.S - you can still know
you're on UEFI, with data in r1 and r2 strongly implying this is UEFI,
you can branch to a much, MUCH simpler path for initialization where
quite a lot of the work it's trying to do may have already been
performed by the stub., and quite a lot of the bare-metalling doesn't
need to be done.

I am sure, even if modifying head.S for any reason than to fix a bug
or implement some architectural requirement is somehow frowned upon,
that comparing r1 to a known constant machine id and branching to a
uefi_start() (which, at that point, may as well be a C function, if
the stub saw fit to keep around/throw in an early stack) is not going
to cause anyone any problems (even if it does add 4 instructions to
the entry and slow everyone else down by a nanosecond or two).

Everybody keeps their absolutely fixed entry point to the image
proper, that way, so you can still glue your stub (with or without the
decompressor as part of the stub) to the front with no changes to the
build process for the image or the code path for non-UEFI.. one
conditional branch and you can gain a lot of much, much easier to
maintain boot process..

> We deal with a highly quirky set of requirements for calling
> SetVirtualAddressMap() in a clunky way - after which calls into UEFI
> are direct and cachable.

If the kernel boot process now has been derived from years upon years
of trial and error and engineering, then it does seem a shame to go do
things a different way, you would be right to say it would be a shame
not to promote code-reuse of the existing process by not touching the
zImage stuff or core kernel boot, and just working on the glue and
some not-so-early-init code.

But what it does is make the boot process *more* complicated than it's
already complicated implementation, in the face of a very nice
specification of the correct way to deal with booting something from a
UEFI implementation..

What might be a much better route to take could be to define a nice,
shiny new way of getting Linux to the point that it has full control
over it's own destiny which does a hell of a lot less, with a less
schizophrenic view of using UEFI or not.

Ta,
Matt Sealey <neko@bakuhatsu.net>
