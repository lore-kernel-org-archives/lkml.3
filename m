Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab3KCXeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 18:34:03 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:50078 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3KCXeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 18:34:01 -0500
MIME-Version: 1.0
In-Reply-To: <20131103224242.GF3947@linux.vnet.ibm.com>
References: <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
	<20131030092725.GL4126@linux.vnet.ibm.com>
	<20131030112526.GI16117@laptop.programming.kicks-ass.net>
	<20131031064015.GV4126@linux.vnet.ibm.com>
	<20131101145634.GH19466@laptop.lan>
	<20131102173239.GB3947@linux.vnet.ibm.com>
	<20131103144017.GA25118@linux.vnet.ibm.com>
	<20131103151704.GJ19466@laptop.lan>
	<CA+55aFx_kuvR-0dwJtjvnhtha5QBc5XcLZPRH=WKT+hYVAKOrw@mail.gmail.com>
	<20131103200124.GK19466@laptop.lan>
	<20131103224242.GF3947@linux.vnet.ibm.com>
Date: Sun, 3 Nov 2013 15:34:00 -0800
X-Google-Sender-Auth: Ag_pZVIEfiqzmfVwysDR6VSMDZQ
Message-ID: <CA+55aFyD_kCkAHQwHCUBrumO-pH6LaZikTNvyWDW_tWsHdqk6Q@mail.gmail.com>
Subject: Re: [RFC] arch: Introduce new TSO memory barrier smp_tmb()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Victor Kaplansky <VICTORK@il.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 3, 2013 at 2:42 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>
> smp_storebuffer_mb() -- A barrier that enforces those orderings
>         that do not invalidate the hardware store-buffer optimization.

Ugh. Maybe. Can you guarantee that those are the correct semantics?
And why talk about the hardware semantics, when you really want
specific semantics for the *software*.

> smp_not_w_r_mb() -- A barrier that orders everything except prior
>         writes against subsequent reads.

Ok, that sounds more along the lines of "these are the semantics we
want", but I have to say, it also doesn't make me go "ahh, ok".

> smp_acqrel_mb() -- A barrier that combines C/C++ acquire and release
>         semantics.  (C/C++ "acquire" orders a specific load against
>         subsequent loads and stores, while C/C++ "release" orders
>         a specific store against prior loads and stores.)

I don't think this is true. acquire+release is much stronger than what
you're looking for - it doesn't allow subsequent reads to move past
the write (because that would violate the acquire part). On x86, for
example, you'd need to have a locked cycle for smp_acqrel_mb().

So again, what are the guarantees you actually want? Describe those.
And then make a name.

I _think_ the guarantees you want is:
 - SMP write barrier
 - *local* read barrier for reads preceding the write.

but the problem is that the "preceding reads" part is really
specifically about the write that you had. The barrier should really
be attached to the *particular* write operation, it cannot be a
standalone barrier.

So it would *kind* of act like a "smp_wmb() + smp_rmb()", but the
problem is that a "smp_rmb()" doesn't really "attach" to the preceding
write.

This is analogous to a "acquire" operation: you cannot make an
"acquire" barrier, because it's not a barrier *between* two ops, it's
associated with one particular op.

So what I *think* you actually really really want is a "store with
release consistency, followed by a write barrier".

In TSO, afaik all stores have release consistency, and all writes are
ordered, which is why this is a no-op in TSO. And x86 also has that
"all stores have release consistency, and all writes are ordered"
model, even if TSO doesn't really describe the x86 model.

But on ARM64, for example, I think you'd really want the store itself
to be done with "stlr" (store with release), and then follow up with a
"dsb st" after that.

And notice how that requires you to mark the store itself. There is no
actual barrier *after* the store that does the optimized model.

Of course, it's entirely possible that it's not worth worrying about
this on ARM64, and that just doing it as a "normal store followed by a
full memory barrier" is good enough. But at least in *theory* a
microarchitecture might make it much cheaper to do a "store with
release consistency" followed by "write barrier".

Anyway, having talked exhaustively about exactly what semantics you
are after, I *think* the best model would be to just have a

  #define smp_store_with_release_semantics(x, y) ...

and use that *and* a "smp_wmb()" for this (possibly a special
"smp_wmb_after_release()" if that allows people to avoid double
barriers). On x86 (and TSO systems), the
smp_store_with_release_semantics() would be just a regular store, and
the smp_wmb() is obviously a no-op. Other platforms would end up doing
other things.

Hmm?

         Linus
