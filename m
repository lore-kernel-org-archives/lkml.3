Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaLVXjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:39:00 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:34007 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaLVXi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:38:57 -0500
MIME-Version: 1.0
In-Reply-To: <20141223002347.18271w0cdr8gba4j@webmail.upv.es>
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es> <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
 <5494A0DF.10905@upv.es> <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
 <CALCETrWtAM5VGokNkw0tHLXRnRsORND7YY6ehYArtvEtt19COA@mail.gmail.com>
 <20141222183615.4193722q3opf4uj3@webmail.upv.es> <CALCETrWUXbzb_MMEugWNzuY-gebkUbzLW6Z=gmCfau7oBRUdJg@mail.gmail.com>
 <20141223002347.18271w0cdr8gba4j@webmail.upv.es>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 22 Dec 2014 15:38:35 -0800
Message-ID: <CALCETrU+NPQexUMDCxdram-gSFtGzrQOoyekfCaXwdwebcnxSg@mail.gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib attack
To: Hector Marco Gisbert <hecmargi@upv.es>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Anton Blanchard <anton@samba.org>, Jiri Kosina <jkosina@suse.cz>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arun Chandran <achandran@mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ismael Ripoll <iripoll@disca.upv.es>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Hanno_B=C3=B6ck?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, Reno Robert <renorobert@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 3:23 PM, Hector Marco Gisbert <hecmargi@upv.es> wrote:
>> Before I even *consider* the code, I want to know two things:
>
>  >
>  > 1. Is there actually a problem in the first place?  The vdso
>  > randomization in all released kernels is blatantly buggy, but it's
>  > fixed in -tip, so it should be fixed by the time that 3.19-rc2 comes
>  > out, and the fix is marked for -stable.  Can you try a fixed kernel:
>  >
>  >
> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=fbe1bf140671619508dfa575d74a185ae53c5dbb
>
>
> Well if it is already fixed, then great!.
>
> But since the vdso is something like a library (cause it contains code,
> and no data), it shall be handled as a library and so it shall be
> located jointly with the other libraries rather than close to the stack.
> Later I'll talk about randomizing libraries among them.
>
> I think that the core idea of the current ASLR implementation is that
> all the areas that share similar content (libraries, stack, heap,
> application) shall be placed together. Following more or less the MILS
> division. This way, a memory leak of an address of the stack is not very
> useful for building a ROP on the libraries.
>
> Another issue is the page table locality. The implementation tries to
> allocate the vdso "close" to the stack so that is fits into the PMD of
> the stack (and so, use less pages for the pagetables). Well, placing the
> vdso in the mmap area would solve the problem at once.
>
> Unfortunately, with your path the VDSO entropy has 18 entropy bits. But
> this is not true. The real entropy is masked with the entropy of the
> stack. In other words, if an attacker guesses where the stack is placed
> they have to do negligible work to guess where the VDSO is located.
> Note that, a memory leak from a data area (which is of little help to
> the attacker) can be used to locate the VDSO (which is of great interest
> because it is executable and contains nice stuff).

I'm not sure it's negligible.  It's 9 bits if the attacker can figure
out the stack alignment and 18 bits if the attacker can't.  This isn't
great, but it's far from nothing.

>
> Using my solution, the VDSO will have the same 28 bits of randomness
> than the libraries (but all will be together).
>
> After after 10000 executions I have found 76 repeated addresses (still
> low entropy, but much better than before). But with my patch, there was
> no repetition (much better entropy).
>
>
>  > 2. I'm not sure your patch helpes.  The currently exciting articles on
>  > ASLR weaknesses seem to focus on two narrow issues:
>  >
>  > a. With PIE executables, the offset from the executable to the
>  > libraries is constant.  This is unfortunate when your threat model
>  > allows you to learn the executable base address and all your gadgets
>  > are in shared libraries.
>
> Regardes the offset2lib... The core idea is that we shall consider the
> application code and libraries as two slightly different things (or two
> different security regions). Since applications are in general more
> prone to have bugs than libraries, it seems that this is the way to do
> it from the security point of view.  Obviously, stack and libraries are
> clearly apart (you can even assign different access permissions).
> Application code and libraries are not that different, but it would be
> better of they are not together.... and sincerely, I think that the cost
> of allocate them apart is so small that it worth the code.
>
> If the extra cost of (One or two pages) per process required to place
> the application code to another area is too high, then may be it can be
> implemented as another level of ASLR randomize_va_space=3 (if any).
>
>
>  > b. The VDSO base address is pathetically low on min entropy.  This
>  > will be dramatically improved shortly.
>  >
>  > The pax tests seem to completely ignore the joint distribution of the
>  > relevant addresses.  My crystal ball predicts that, if I apply your
>  > patch, someone will write an article observing that the libc-to-vdso
>  > offset is constant or, OMG!, the PIE-executable-to-vdso offset is
>  > constant.
>  >
>  > So... is there a problem in the first place, and is the situation
>  > really improved with your patch?
>  >
>  > --Andy
>
> Absolutely agree.
>
> The offset2x shall be considered now. And rather than moving objects
> like the vdso, vvar stack, heap... etc.. etc.. we shall consider
> seriously the cost of a full (all maps) to be real random. That is
> inter-mmap ASLR.
>
> Current implementation is not that bad, except that the application was
> considered in the same "category" than libraries. But I guess that it
> deserves a region for its own. Also, I think that executable code shall
> be apart from data.. which supports the idea of inter-mmap randomization.
>
> Sorry if I'm mixing VDSO, and offset2lib issues, but they share a
> similar core problem.
>

If I see a real argument that randomizing the vdso like a library is
better than randomizing it separately but weakly, I'll gladly consider
it.  But the references I've seen (and I haven't looked all that hard,
and I'm not an memory exploit writer) are unconvincing.

I'd really rather see a strong inter-mmap randomization scheme adopted.

--Andy

>
> --Hector Marco.
>
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
