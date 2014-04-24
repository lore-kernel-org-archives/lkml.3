Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750955AbaDXEx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 00:53:28 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42655 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbaDXEx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 00:53:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com>
 <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Wed, 23 Apr 2014 21:53:05 -0700
Message-ID: <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
To: comex <comexk@gmail.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 9:13 PM, comex <comexk@gmail.com> wrote:
> On Mon, Apr 21, 2014 at 6:47 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>> This is a prototype of espfix for the 64-bit kernel.  espfix is a
>> workaround for the architectural definition of IRET, which fails to
>> restore bits [31:16] of %esp when returning to a 16-bit stack
>> segment.  We have a workaround for the 32-bit kernel, but that
>> implementation doesn't work for 64 bits.
>
> Hi,
>
> A comment: The main purpose of espfix is to prevent attackers from
> learning sensitive addresses, right?  But as far as I can tell, this
> mini-stack becomes itself somewhat sensitive:
>
> - The user can put arbitrary data in registers before returning to the
> LDT in order to get it saved at a known address accessible from the
> kernel.  With SMAP and KASLR this might otherwise be difficult.

For one thing, this only matters on Haswell.  Otherwise the user can
put arbitrary data in userspace.

On Haswell, the HPET fixmap is currently a much simpler vector that
can do much the same thing, as long as you're willing to wait for the
HPET counter to contain some particular value.  I have patches that
will fix that as a side effect.

Would it pay to randomize the location of the espfix area?  Another
somewhat silly idea is to add some random offset to the CPU number mod
NR_CPUS so that at attacker won't know which ministack is which.

> - If the iret faults, kernel addresses will get stored there (and not
> cleared).  If a vulnerability could return data from an arbitrary
> specified address to the user, this would be harmful.

Can this be fixed by clearing the ministack in bad_iret?  There will
still be a window in which the kernel address is in there, but it'll
be short.

>
> I guess with the current KASLR implementation you could get the same
> effects via brute force anyway, by filling up and browsing memory,
> respectively, but ideally there wouldn't be any virtual addresses
> guaranteed not to fault.
>
> - If a vulnerability allowed overwriting data at an arbitrary
> specified address, the exception frame could get overwritten at
> exactly the right moment between the copy and iret (or right after the
> iret to mess up fixup_exception)?  You probably know better than I
> whether or not caches prevent this from actually being possible.

To attack this, you'd change the saved CS value.  I don't think caches
would make a difference.

This particular vector hurts: you can safely keep trying until it works.

This just gave me an evil idea: what if we make the whole espfix area
read-only?  This has some weird effects.  To switch to the espfix
stack, you have to write to an alias.  That's a little strange but
harmless and barely complicates the implementation.  If the iret
faults, though, I think the result will be a #DF.  This may actually
be a good thing: if the #DF handler detects that the cause was a bad
espfix iret, it could just return directly to bad_iret or send the
signal itself the same way that do_stack_segment does.  This could
even be written in C :)

Peter, is this idea completely nuts?  The only exceptions that can
happen there are NMI, MCE, #DB, #SS, and #GP.  The first four use IST,
so they won't double-fault.

--Andy
