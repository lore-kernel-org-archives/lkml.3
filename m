Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbaLVXYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 18:24:54 -0500
Received: from smtpsal1.cc.upv.es ([158.42.249.61]:36504 "EHLO smtpsalv.upv.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751543AbaLVXYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 18:24:52 -0500
Message-ID: <20141223002347.18271w0cdr8gba4j@webmail.upv.es>
Date: Tue, 23 Dec 2014 00:23:47 +0100
From: Hector Marco Gisbert <hecmargi@upv.es>
To: Andy Lutomirski <luto@amacapital.net>
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
        Hanno =?iso-8859-1?b?QvZjaw==?= <hanno@hboeck.de>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kees Cook <keescook@chromium.org>, Reno Robert <renorobert@gmail.com>
Subject: Re: [PATCH] ASLRv3: randomize_va_space=3 preventing offset2lib
 attack
References: <5489E6D2.2060200@upv.es> <5489FAAD.7000606@upv.es>
 <20141211221158.GS18807@outflux.net> <548B18AC.9@upv.es>
 <CALCETrVAaDDvAttVkJ+1ygymE_uEZOCLtGHHN15v_VDf1PVsmA@mail.gmail.com>
 <5494A0DF.10905@upv.es>
 <CALCETrWB_T9ui=_JSQRLrtbNDx=sJ22im1XujhxptfZRtedeeg@mail.gmail.com>
 <CALCETrWtAM5VGokNkw0tHLXRnRsORND7YY6ehYArtvEtt19COA@mail.gmail.com>
 <20141222183615.4193722q3opf4uj3@webmail.upv.es>
 <CALCETrWUXbzb_MMEugWNzuY-gebkUbzLW6Z=gmCfau7oBRUdJg@mail.gmail.com>
In-Reply-To: <CALCETrWUXbzb_MMEugWNzuY-gebkUbzLW6Z=gmCfau7oBRUdJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Dynamic Internet Messaging Program (DIMP) H3 (1.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Before I even *consider* the code, I want to know two things:
  >
  > 1. Is there actually a problem in the first place?  The vdso
  > randomization in all released kernels is blatantly buggy, but it's
  > fixed in -tip, so it should be fixed by the time that 3.19-rc2 comes
  > out, and the fix is marked for -stable.  Can you try a fixed kernel:
  >
  >
https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=x86/urgent&id=fbe1bf140671619508dfa575d74a185ae53c5dbb


Well if it is already fixed, then great!.

But since the vdso is something like a library (cause it contains code,
and no data), it shall be handled as a library and so it shall be
located jointly with the other libraries rather than close to the stack.
Later I'll talk about randomizing libraries among them.

I think that the core idea of the current ASLR implementation is that
all the areas that share similar content (libraries, stack, heap,
application) shall be placed together. Following more or less the MILS
division. This way, a memory leak of an address of the stack is not very
useful for building a ROP on the libraries.

Another issue is the page table locality. The implementation tries to
allocate the vdso "close" to the stack so that is fits into the PMD of
the stack (and so, use less pages for the pagetables). Well, placing the
vdso in the mmap area would solve the problem at once.

Unfortunately, with your path the VDSO entropy has 18 entropy bits. But
this is not true. The real entropy is masked with the entropy of the
stack. In other words, if an attacker guesses where the stack is placed
they have to do negligible work to guess where the VDSO is located.
Note that, a memory leak from a data area (which is of little help to
the attacker) can be used to locate the VDSO (which is of great interest
because it is executable and contains nice stuff).

Using my solution, the VDSO will have the same 28 bits of randomness
than the libraries (but all will be together).

After after 10000 executions I have found 76 repeated addresses (still
low entropy, but much better than before). But with my patch, there was
no repetition (much better entropy).


  > 2. I'm not sure your patch helpes.  The currently exciting articles on
  > ASLR weaknesses seem to focus on two narrow issues:
  >
  > a. With PIE executables, the offset from the executable to the
  > libraries is constant.  This is unfortunate when your threat model
  > allows you to learn the executable base address and all your gadgets
  > are in shared libraries.

Regardes the offset2lib... The core idea is that we shall consider the
application code and libraries as two slightly different things (or two
different security regions). Since applications are in general more
prone to have bugs than libraries, it seems that this is the way to do
it from the security point of view.  Obviously, stack and libraries are
clearly apart (you can even assign different access permissions).
Application code and libraries are not that different, but it would be
better of they are not together.... and sincerely, I think that the cost
of allocate them apart is so small that it worth the code.

If the extra cost of (One or two pages) per process required to place
the application code to another area is too high, then may be it can be
implemented as another level of ASLR randomize_va_space=3 (if any).


  > b. The VDSO base address is pathetically low on min entropy.  This
  > will be dramatically improved shortly.
  >
  > The pax tests seem to completely ignore the joint distribution of the
  > relevant addresses.  My crystal ball predicts that, if I apply your
  > patch, someone will write an article observing that the libc-to-vdso
  > offset is constant or, OMG!, the PIE-executable-to-vdso offset is
  > constant.
  >
  > So... is there a problem in the first place, and is the situation
  > really improved with your patch?
  >
  > --Andy

Absolutely agree.

The offset2x shall be considered now. And rather than moving objects
like the vdso, vvar stack, heap... etc.. etc.. we shall consider
seriously the cost of a full (all maps) to be real random. That is
inter-mmap ASLR.

Current implementation is not that bad, except that the application was
considered in the same "category" than libraries. But I guess that it
deserves a region for its own. Also, I think that executable code shall
be apart from data.. which supports the idea of inter-mmap randomization.

Sorry if I'm mixing VDSO, and offset2lib issues, but they share a
similar core problem.


--Hector Marco.



