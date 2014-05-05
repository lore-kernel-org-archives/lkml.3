Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaEEPrp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 11:47:45 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:45997 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801AbaEEPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 11:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <53656B7A.8050606@zytor.com>
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
 <53646A7E.8010400@zytor.com> <20140503072428.54f89688@gandalf.local.home> <53656B7A.8050606@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 5 May 2014 08:47:22 -0700
Message-ID: <CALCETrUO3EBD=W8_8=uB-JVhdh8kswd6=rwNCT_OTnCsKP_o1w@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 3, 2014 3:19 PM, "H. Peter Anvin" <hpa@zytor.com> wrote:
>
> On 05/03/2014 04:24 AM, Steven Rostedt wrote:
> > On Fri, 02 May 2014 21:03:10 -0700
> > "H. Peter Anvin" <hpa@zytor.com> wrote:
> >
> >>
> >> I'd really like to see a workload which would genuinely benefit before
> >> adding more complexity.  Now... if we can determine that it doesn't harm
> >> anything and would solve the NMI nesting problem cleaner than the
> >> current solution, that would justify things, too...
> >>
> >
> > As I stated before. It doesn't solve the NMI nesting problem. It only
> > handles page faults. We would have to implement this for breakpoint
> > return paths too. Is that a plan as well?
> >
>
> I would assume we would do it for *ALL* the IRETs.  There are only three
> IRETs in the kernel last I checked...
>

I think that doing this for all the non-NMI IRETs may be an enormous
mess because of syscall.  syscall immediates followed by #MC or #DB
will explode using a ret trampoline, since the return RSP value will
be bogus.

This isn't a problem for non-IST IRETs, since they only happen when
the return stack is valid.

We could maybe do an iretless return only when we're on usergs, but
this may still not fix the problem, and it doesn't fix NMI nesting:
#NM followed by #MC or #DB before swapgs will still do IRET.  Also,
Andi's FSGSBASE patches are about to remove the ability to distinguish
user vs kernel gs during IST interrupt processing.

We could check the return RIP and do a nasty fixup (i.e. emulate the
stack switch and possible swapgs prior to return), but this will be
really messy, and Andi's patches will just make it worse.  I don't
really want to do this.

So this might be non-IST only unless anyone has a better idea.

This may mean that the iretless return path should only happen when CS
is the normal kernel value (sorry, Xen) and the saved IF is 1.  That
gets rid of the annoying branch to deal with IF.

Grr.  I want a way to do this without a trampoline on the stack.  The
new instruction I want is:

FASTRET - fast return to kernel or user space

FASTRET pops RIP, CS, EFLAGS, RSP, and SS.  It does not unmask NMI.
It, like SYSCALL and SYSRET, completely ignores the GDT; it restores
the selector values for CS and SS but fills the rest of the processor
state with default 64-bit values.  It does, however, set CPL to match
whatever was on the stack.

Then the kernel code is straightforward: if (!NMI && (CS == kernelcs64
&& SS == kernelss) || (CS == usercs64 && SS == userss) FASTRET else
IRET.

BTW, what, if anything, prevents #MC from nesting?  I suspect that we
are completely screwed if #MC nests.  Maybe the answer is that a
machine-check-worthy error that happens during #MC handling is more or
less fatal anyway.

--Andy

This requires an IRET-style s

>         -hpa
>
>
