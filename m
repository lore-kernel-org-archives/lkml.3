Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161296Ab3BOGxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:53:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:43184 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161118Ab3BOGw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:52:59 -0500
Message-ID: <1360910894.22260.68.camel@pasglop>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Date: Fri, 15 Feb 2013 17:48:14 +1100
In-Reply-To: <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
	 <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
	 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
	 <CA+55aFwZ2wN=9qTNNmqjPfK=ZwS=kx6HAAFj_cWLnJDbK1M0_Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 10:30 -0800, Linus Torvalds wrote:
> On Wed, Feb 13, 2013 at 8:20 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Adding an external function call is *horrible*, and you might almost
> > as well just uninline the spinlock entirely if you do this. It means
> > that all the small callers now have their registers trashed, whether
> > the unlikely function call is taken or not, and now leaf functions
> > aren't leaves any more.
> 
> Btw, we've had things like this before, and I wonder if we could
> perhaps introduce the notion of a "light-weight call" for fastpath
> code that calls unlikely slow-path code..
> 
> In particular, see the out-of-line code used by the rwlocks etc (see
> "arch_read_lock()" for an example in arch/x86/include/asm/spinlock.h
> and arch/x86/lib/rwlock.S), where we end up calling things from inline
> asm, with one big reason being exactly the fact that a "normal" C call
> has such horribly detrimental effects on the caller.

This would be nice. I've been wanting to do something like that for a
while in fact... On archs like powerpc, we lose 11 GPRs on a function
call, that ends up being a lot of stupid stack spills for cases that are
often corner cases (error cases etc... in inlines).

> Sadly, gcc doesn't seem to allow specifying which registers are
> clobbered any easy way, which means that both the caller and the
> callee *both* tend to need to have some asm interface. So we bothered
> to do this for __read_lock_failed, but we have *not* bothered to do
> the same for the otherwise very similar __mutex_fastpath_lock() case,
> for example.
>
> So for rwlocks, we actually get very nice code generation with small
> leaf functions not necessarily needing stack frames, but for mutexes
> we mark a lot of registers "unnecessarily" clobbered in the caller,
> exactly because we do *not* do that asm interface for the callee. So
> we have to clobber all the standard callee-clobbered registers, which
> is really sad, and callers almost always need a stack frame, because
> if they have any data live at all across the mutex, they have to save
> it in some register that is callee-saved - which basically means that
> the function has to have that stack frame in order to save its *own*
> callee-saved registers.
> 
> So it means that we penalize the fastpath because the slow-path can't
> be bothered to do the extra register saving, unless we go to the
> lengths we went to for the rwlocks, and build a wrapper in asm to save
> the extra registers in the cold path.
> 
> Maybe we could introduce some helpers to create these kinds of asm
> wrappers to do this? Something that would allow us to say: "this
> function only clobbers a minimal set of registers and you can call it
> from asm and only mark %rax/rcx/rdx clobbered" and that allows leaf
> functions to look like leaf functions for the fastpath?

We could so something like:

	define_fastcall(func [.. figure out how to deal with args ... ])

Which spits out both a trampoline for saving the nasty stuff and calling
the real func() and a call_func() inline asm for the call site.

At least on archs with register-passing conventions, especially if we
make mandatory to stick to register args only and forbid stack spills
(ie, only a handful of args), it's fairly easy to do.

For stack based archs, it gets nastier as you have to dig out the args,
save stuff, and pile them again.

But since we also don't want to lose strong typing, we probably want to
express the args in that macro, maybe like we do for the syscall
defines. A bit ugly, but that would allow to have a strongly typed
call_func() *and* allow the trampoline to know what to do about the args
for stack based calling conventions.

About to go & travel so I don't have time to actually write something,
at least not for a couple of weeks though...

Ben.

> Hmm? That would make my dislike of uninlining the slow case largely go
> away. I still think that back-off tends to be a mistake (and is often
> horrible for virtualization etc), but as long as the fastpath stays
> close to optimal, I don't care *too* much.
> 
>                      Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


