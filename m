Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbaDXWYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:24:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:3849 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaDXWYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:24:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,922,1389772800"; 
   d="scan'208";a="526899244"
Message-ID: <53598F2F.1030306@linux.intel.com>
Date: Thu, 24 Apr 2014 15:24:47 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Lutomirski <amluto@gmail.com>, comex <comexk@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com> <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com>
In-Reply-To: <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 09:53 PM, Andrew Lutomirski wrote:
>>
>> - The user can put arbitrary data in registers before returning to the
>> LDT in order to get it saved at a known address accessible from the
>> kernel.  With SMAP and KASLR this might otherwise be difficult.
> 
> For one thing, this only matters on Haswell.  Otherwise the user can
> put arbitrary data in userspace.
> 
> On Haswell, the HPET fixmap is currently a much simpler vector that
> can do much the same thing, as long as you're willing to wait for the
> HPET counter to contain some particular value.  I have patches that
> will fix that as a side effect.
> 
> Would it pay to randomize the location of the espfix area?  Another
> somewhat silly idea is to add some random offset to the CPU number mod
> NR_CPUS so that at attacker won't know which ministack is which.

Since we store the espfix stack location explicitly, as long as the
scrambling happens in the initialization code that's fine.  However, we
don't want to reduce locality lest we massively blow up the memory
requirements.

We could XOR with a random constant with no penalty at all.  Only
problem is that this happens early, so the entropy system is not yet
available.  Fine if we have RDRAND, but...

>> - If the iret faults, kernel addresses will get stored there (and not
>> cleared).  If a vulnerability could return data from an arbitrary
>> specified address to the user, this would be harmful.
> 
> Can this be fixed by clearing the ministack in bad_iret?  There will
> still be a window in which the kernel address is in there, but it'll
> be short.

We could, if anyone thinks this is actually beneficial.

I'm trying to dig into some of the deeper semantics of IRET to figure
out another issue (a much bigger potential problem), this would affect
that as well.  My current belief is that we don't actually have a
problem here.

>> - If a vulnerability allowed overwriting data at an arbitrary
>> specified address, the exception frame could get overwritten at
>> exactly the right moment between the copy and iret (or right after the
>> iret to mess up fixup_exception)?  You probably know better than I
>> whether or not caches prevent this from actually being possible.
> 
> To attack this, you'd change the saved CS value.  I don't think caches
> would make a difference.
> 
> This particular vector hurts: you can safely keep trying until it works.
> 
> This just gave me an evil idea: what if we make the whole espfix area
> read-only?  This has some weird effects.  To switch to the espfix
> stack, you have to write to an alias.  That's a little strange but
> harmless and barely complicates the implementation.  If the iret
> faults, though, I think the result will be a #DF.  This may actually
> be a good thing: if the #DF handler detects that the cause was a bad
> espfix iret, it could just return directly to bad_iret or send the
> signal itself the same way that do_stack_segment does.  This could
> even be written in C :)
>
> Peter, is this idea completely nuts?  The only exceptions that can
> happen there are NMI, MCE, #DB, #SS, and #GP.  The first four use IST,
> so they won't double-fault.

It is completely nuts, but sometimes completely nuts is actually useful.
 It is more complexity, to be sure, but it doesn't seem completely out
of the realm of reason, and avoids having to unwind the ministack except
in the normally-fatal #DF handler.  #DFs are documented as not
recoverable, but we might be able to do something here.

The only real disadvantage I see is the need for more bookkeeping
metadata.  Basically the bitmask in espfix_64.c now needs to turn into
an array, plus we need a second percpu variable.  Given that if
CONFIG_NR_CPUS=8192 the array has 128 entries I think we can survive that.

	-hpa

