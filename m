Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbaBTSZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:25:47 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:46630 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333AbaBTSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:25:45 -0500
MIME-Version: 1.0
In-Reply-To: <1392918576.18779.10198.camel@triegel.csb>
References: <CA+55aFwTrt_6m1inNHQkk74i7uPkHNnacwHiBgioZSXieAs5Sw@mail.gmail.com>
	<1392666947.18779.6838.camel@triegel.csb>
	<CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<1392918576.18779.10198.camel@triegel.csb>
Date: Thu, 20 Feb 2014 10:25:44 -0800
X-Google-Sender-Auth: nXBMrSztbnotnJXZ1ED4Vet3neQ
Message-ID: <CA+55aFwV3pH+CP7Anv_YXzChL5V3_zre0+Ry-a1tJGYsbn-3iQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Torvald Riegel <triegel@redhat.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 9:49 AM, Torvald Riegel <triegel@redhat.com> wrote:
>
> Yes, mo_consume is more tricky than mo_acquire.
>
> However, that has an advantage because you can avoid getting stronger
> barriers if you don't need them (ie, you can avoid the "auto-update to
> acquire" you seem to have in mind).

Oh, I agree about that part - I very much understand the reason for
"consume", and I can see how it is more relaxed than "acquire" under
many circumstances.

I just think that you actually *do* want to have "consume" even for
flag values, exactly *because* it is potentially cheaper than acquire.

In fact, I'd argue that making consume reliable in the face of control
dependencies is actually a *good* thing. It may not matter for
something like x86, where consume and acquire end up with the same
simple load, but even there it might relax instruction scheduling a
bit, since a 'consume' would have a barrier just to the *users* of the
value loaded, while 'acquire' would still have a scheduling barrier to
any subsequent operations.

So I claim that for a sequence like my example, where the reader
basically does something like

   load_atomic(&initialized, consume) ? value : -1;

the "consume" version can actually generate better code than "acquire"
- if "consume" is specified the way *I* specified it.

The way the C standard specifies it, the above code is *buggy*.
Agreed? It's really really subtly buggy, and I think that bug is not
only a real danger, I think it is logically hard to understand why.
The bug only makes sense to people who understand how memory ordering
and branch prediction interacts.

The way *I* suggested "consume" be implemented, the above not only
works and is sensible, it actually generates possibly better code than
forcing the programmer to use the (illogical) "acquire" operation.

Why? Let me give you another - completely realistic, even if obviously
a bit made up - example:

   int return_expensive_system_value(void)
   {
        static atomic_t initialized;
        static int calculated;

        if (atomic_read(&initialized, mo_consume))
            return calculated;

        //let's say that this code opens /proc/cpuinfo and counts
number of CPU's or whatever ...
        calculated = read_value_from_system_files();
        atomic_write(&initialized, 1, mo_release);
        return calculated;
    }

and let's all agree that this is a somewhat realistic example, and we
can imagine why/how somebody would write code like this. It's
basically a very common lazy initialization pattern, you'll find this
in libraries, in kernels, in application code yadda yadda. No
argument?

Now, let's assume that it turns out that this value ends up being
really performance-critical, so the programmer makes the fast-path an
inline function, tells the compiler that "initialized" read is likely,
and generally wants the compiler to optimize it to hell and back.
Still sounds reasonable and realistic?

In other words, the *expected* code sequence for this is (on x86,
which doesn't need any barriers):

    cmpl $0, initialized
    je unlikely_out_of_line_case
    movl calculated, eax

and on ARM/power you'd see a 'sync' instruction or whatever.

So far 'acquire' and 'consume' have exacly the same code generation on
power of x86, so your argument can be: "Ok, so let's just use the
inconvenient and hard-to-understand 'consume' semantics that the
current standard has, and tell the programmer that he should use
'acquire' and not worry his little head about the difference because
he will never understand it anyway".

Sure, that would be an inconvencience for programmers, but hey,
they're programming in C or C++, so they are *expected* to be manly
men or womanly women, and a little illogical inconvenience never hurt
anybody. After all, compared to the aliasing rules, that "use acquire,
not consume" rule is positively *simple*, no?

Are we all in agreement so far?

But no, the "consume" thing can actually generate better code. Trivial example:

    int my_threads_value;
    extern int magic_system_multiplier;

    my_thread_value = return_expensive_system_value();
    my_thread_value *= magic_system_multiplier;

and in the "acquire" model, the "acquire" itself means that the load
from magic_system_multiplier is now constrained by the acquire memory
ordering on "initialized".

While in my *sane* model, where you can consume things even if they
then result in control dependencies, there will still eventually be a
"sync" instruction on powerpc (because you really need one between the
load of 'initialized' and the load of 'calculated'), but the compiler
would be free to schedule the load of 'magic_system_multiplier'
earlier.

So as far as I can tell, we want the 'consume' memory ordering to
honor *all* dependencies, because
 - it's simpler
 - it's more logical
 - it's less error-prone
 - and it allows better code generation

Hmm?

              Linus
