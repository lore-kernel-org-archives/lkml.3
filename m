Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3LFRUs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 12:20:48 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:38087 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120Ab3LFRUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 12:20:46 -0500
MIME-Version: 1.0
In-Reply-To: <20131204224447.GA19265@srcf.ucam.org>
References: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
	<1385656883-4420-2-git-send-email-leif.lindholm@linaro.org>
	<CAHCPf3t5dEzVWbYZ6DWcFCENNO2dbrx-YeZvKRk0MkEsJMTE3A@mail.gmail.com>
	<20131202210719.GQ24997@rocoto.smurfnet.nu>
	<CAHCPf3tsWdV+dJGm6mX6N4Ou5EQoGukdLyRvsRX6VQFjtKgxtg@mail.gmail.com>
	<20131204224447.GA19265@srcf.ucam.org>
Date: Fri, 6 Dec 2013 11:20:45 -0600
Message-ID: <CAHCPf3s_SXYXLRwvn7tzqTCQ-gB=emRMK_dXkEmw_HWigiD7Mw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] Documentation: arm: add UEFI support documentation
From: Matt Sealey <neko@bakuhatsu.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
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

On Wed, Dec 4, 2013 at 4:44 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Wed, Dec 04, 2013 at 03:06:47PM -0600, Matt Sealey wrote:
>
>> there's no guarantee that the kernel hasn't been decompressed over
>> some important UEFI feature or some memory hasn't been trashed. You
>> can't make that guarantee because by entering the plain zImage, you
>> forfeited that information.
>
> The stub is responsible for ensuring that the compressed kernel is
> loaded at a suitable address. Take a look at efi_relocate_kernel().

My objection is the suitable address is based on a restriction that
booting from UEFI doesn't have and information UEFI provides that
makes kernel features from head.S (both of them) easier to get around.
The kernel doesn't need to be within a particular range of the start
of memory, nor does the device tree or ramdisk require being in a
particular place. What the code before efi_relocate_kernel does is
allocate a maximum-sized-buffer to safely decompress in, which is just
a gross way to do it, then crosses it's fingers based on the way it
has historically worked - while you might want to assume that the
decompression process is quite well defined and reliable, I keep
seeing patches come in that stop it from doing weird unsavory behavior
- for example decompressing over it's own page table.

The decompressor - and the kernel head it jumps to after decompression
- *guess* all the information UEFI could have provided and completely
regenerate the environment for the decompressor itself (stacks, hacky
memory allocations, cache on, off, on, off, on... fudging locations of
page tables, zreladdr fixup, low level debug message output, in
context of UEFI - reimplementation of memcpy, memset). It forfeits a
more controlled and lean boot process to capitulate to a historical
legacy. Since you're taking over the decompressor head.S anyway, why
not take control of the decompression process?

It sets up a page table location the hard way (as above.. also patched
recently not to decompress over it's own page table). It doesn't need
to relocate itself past the end of the decompressed image. It doesn't
need to set up the C environment - UEFI did that for it. It makes
assumptions about the stack and hacks memory allocations for the
decompression.. it turns the cache on, decompresses, then turns it off
again... you can just walk through the code under the EFI stub in
compressed/head.S and see all this can just fall away.

There's one immediate advantage too, if it's actually implemented and
working, which is that for kernel images that are compressed using the
standard UEFI compression method no actual decompression code needs to
be added to the stub, and the functionality gets the exact length of
the required decompression buffer.. that doesn't reduce flexibility in
kernel compression as long as there is still the possibility of adding
additional compression code to the stub.

The second immediate advantage is that the EFI stub/decompressor can
actually verify that the *decompressed* image meets Secure Boot
requirements.

Once you get past the decompressor and into the kernel proper head.S,
creating the page tables (again) and turning the MMU on, pv table
patching.. if you still had the information around, that gets simpler
too.

Grant suggested I should propose some patches; sure, if I'm not otherwise busy.

Maybe the Linaro guys can recommend a platform (real or emulated) that
would be best to test it on with the available UEFI?

>> Most of the guessing is ideally not required to be a guess at all, the
>> restrictions are purely to deal with the lack of trust for the
>> bootloader environment. Why can't we trust UEFI? Or at least hold it
>> to a higher standard. If someone ships a broken UEFI, they screw a
>> feature or have a horrible bug and ship it, laud the fact Linux
>> doesn't boot on it and the fact that it's their fault - over their
>> head. It actually works these days, Linux actually has "market share,"
>> companies really go out of their way to rescue their "image" and
>> resolve the situation when someone blogs about a serious UEFI bug on
>> their $1300 laptops, or even $300 tablets.
>
> Yeah, that hasn't actually worked out too well for us.

Aside from Teething problems caused by a rush to market ;)

For the "ARM server market" rather than the "get the cheapest
tablet/ultrabook out of the door that runs Windows 8/RT" I am sure
this is going to get to be VERY important for vendors to take into
account. Imagine if Dell shipped a *server* where Linux would brick it
out of the box just for setting a variable.. however, if it works the
day they ship the server, and Linux gains better support for UEFI
booting which breaks the server in question, that's our fault for not
doing it in the right way in the first place, and Dell can be just as
angry at us as we would be at them. Vendors won't test code that
doesn't exist for obvious reasons.

This is what I was trying to get at about them not updating their
firmware support for the more firmware-aware method if it works with
the "ditch firmware early" method worked well for them (which means
the functionality in the firmware never gets stressed and the
self-fulfilling prophecy of untrustworthy firmware vendors persists).
That firmware quality assurance - if not the code itself - will
trickle down to consumer tablets and ARM thin laptop kind of devices.

Ta,
Matt Sealey <neko@bakuhatsu.net>
