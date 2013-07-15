Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab3GOXYp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 19:24:45 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:58605 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233Ab3GOXYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 19:24:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130715232053.GB2649@leaf>
References: <CAOULuOY5VMiiuYmesaGxVWWKtby4Cj9Pc9ctQZeOKfoUzV46dA@mail.gmail.com>
 <CALCETrVk=ovYjHwALtzB3E3nP4TMivhppM42yw7rMRpzA68cbw@mail.gmail.com>
 <20130715230418.GA2649@leaf> <CALCETrX_Qjmdo5JtRPzhW6kBaNgwAstG1g8p8pKNy4e+kPYdMQ@mail.gmail.com>
 <20130715232053.GB2649@leaf>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 15 Jul 2013 16:24:23 -0700
Message-ID: <CALCETrUMrztJ1aTfvfMZyOSRFhDM52Fa3pSS8EuW3ByYGMNMpg@mail.gmail.com>
Subject: Re: BGRT Pointer in System RAM
To: Josh Triplett <josh@joshtriplett.org>
Cc: Parag Warudkar <parag.lkml@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 4:20 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> On Mon, Jul 15, 2013 at 04:08:13PM -0700, Andy Lutomirski wrote:
>> On Mon, Jul 15, 2013 at 4:04 PM, Josh Triplett <josh@joshtriplett.org> wrote:
>> > On Mon, Jul 15, 2013 at 01:28:36PM -0700, Andy Lutomirski wrote:
>> >>
>> >> Interesting.  My BGRT says:
>> >>
>> >> [028h 0040   8]                Image Address : 0D06801800000001
>> >>
>> >> If I reverse the high and low 32-bit dwords, then I get an address in
>> >> system RAM.
>> >
>> > Does that address in RAM start with a BMP header?
>>
>> No idea.  I'd presumably have to modify the driver to find out --
>> otherwise something else will overwrite it.
>
> You could boot with a mem= command-line argument that reserves that
> memory.

I'll see what I can do.

>
>> > Because that would be *special*.  I don't think it's worth trying to
>> > cope with that bug; better to just write off the BGRT as invalid if the
>> > BIOS can't get endianness right.
>> >
>> > In theory we could guess at that bug if the unmangled address points to
>> > a location in RAM starting with a BMP header.  In practice, let's not; a
>> > missing BGRT is a purely cosmetic issue, and BIOS vendors can learn to
>> > get that one right if they want to see their logo during Linux boot.
>> > This won't break fastboot support, it just breaks fancy crossfades from
>> > the BIOS logo to a Linux desktop or splash.
>>
>> FWIW, the address that my BIOS gives is non-canonical.  Maybe that's
>> good enough.
>
> What do you mean by "non-canonical".

Brainfart.  I'm confusing physical and virtual addresses.  More
usefully, the bogus address from my BIOS is too large -- it's way
above the highest e820 spot (and I'm pretty sure it exceeds the
maximum address that my CPU can address).  Maybe that would be a
decent heuristic to use to avoid trying to follow the pointer.

>
>> > So, a "firmware bug" message in dmesg seems sufficent for that case.  We
>> > do need to handle the case of a valid pointer into memory that e820
>> > calls system RAM, as well as the case of a valid pointer into memory
>> > reserved for the BIOS or similar, but not the case of an invalid
>> > pointer.
>>
>> Is the efi_bgrt code called early enough that data in system RAM will
>> still be there?
>
> In theory, it should always point to data in EFI's "reserved until after
> boot time" memory.
>
> - Josh Triplett
