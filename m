Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaBQXSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 18:18:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687AbaBQXSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 18:18:08 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <CA+55aFz-gaNKxRGU-YPw3xu=T8ZxFv0v22i+R7vWoeQT0i+8Mw@mail.gmail.com>
References: <20140207180216.GP4250@linux.vnet.ibm.com>
	 <1391992071.18779.99.camel@triegel.csb>
	 <CA+55aFwTwCPMpYTL_vCgNNP0hE8s2sgB0iw-79=xoj99V0JUNA@mail.gmail.com>
	 <1392183564.18779.2187.camel@triegel.csb>
	 <20140212180739.GB4250@linux.vnet.ibm.com>
	 <CA+55aFw3S82GYdtnV2nJCvBGcuZf6kXdF5b7Vp9yb21QKr49Jw@mail.gmail.com>
	 <20140213002355.GI4250@linux.vnet.ibm.com>
	 <1392321837.18779.3249.camel@triegel.csb>
	 <20140214020144.GO4250@linux.vnet.ibm.com>
	 <1392352981.18779.3800.camel@triegel.csb>
	 <20140214172920.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFx9CbgrfK4rBVYD75y2KoWiO90dSYsAW83O-tYVLK-gkg@mail.gmail.com>
	 <1392485428.18779.6387.camel@triegel.csb>
	 <CA+55aFw5v8Zc818YoxazFhP0btN1faofNbED=qrpi3VrtRA39w@mail.gmail.com>
	 <1392674986.18779.7038.camel@triegel.csb>
	 <CA+55aFz-gaNKxRGU-YPw3xu=T8ZxFv0v22i+R7vWoeQT0i+8Mw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Feb 2014 00:17:28 +0100
Message-ID: <1392679048.18779.7168.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-17 at 14:32 -0800, Linus Torvalds wrote:
> On Mon, Feb 17, 2014 at 2:09 PM, Torvald Riegel <triegel@redhat.com> wrote:
> > On Sat, 2014-02-15 at 11:15 -0800, Linus Torvalds wrote:
> >> >
> >> > if (atomic_load(&x, mo_relaxed) == 1)
> >> >   atomic_store(&y, 3, mo_relaxed));
> >>
> >> No, please don't use this idiotic example. It is wrong.
> >
> > It won't be useful in practice in a lot of cases, but that doesn't mean
> > it's wrong.  It's clearly not illegal code.  It also serves a purpose: a
> > simple example to reason about a few aspects of the memory model.
> 
> It's not illegal code, but i you claim that you can make that store
> unconditional, it's a pointless and wrong example.
> 
> >> The fact is, if a compiler generates anything but the obvious sequence
> >> (read/cmp/branch/store - where branch/store might obviously be done
> >> with some other machine conditional like a predicate), the compiler is
> >> wrong.
> >
> > Why?  I've reasoned why (1) to (3) above allow in certain cases (i.e.,
> > the first load always returning 1) for the branch (or other machine
> > conditional) to not be emitted.  So please either poke holes into this
> > reasoning, or clarify that you don't in fact, contrary to what you wrote
> > above, agree with (1) to (3).
> 
> The thing is, the first load DOES NOT RETURN 1. It returns whatever
> that memory location contains. End of story.

The memory location is just an abstraction for state, if it's not
volatile.

> Stop claiming it "can return 1".. It *never* returns 1 unless you do
> the load and *verify* it, or unless the load itself can be made to go
> away. And with the code sequence given, that just doesn't happen. END
> OF STORY.

void foo();
{
  atomic<int> x = 1;
  if (atomic_load(&x, mo_relaxed) == 1)
    atomic_store(&y, 3, mo_relaxed));
}

This is a counter example to your claim, and yes, the compiler has proof
that x is 1.  It's deliberately simple, but I can replace this with
other more advanced situations.  For example, if x comes out of malloc
(or, on the kernel side, something else that returns non-aliasing
memory) and hasn't provably escaped to other threads yet.

I haven't posted this full example, but I've *clearly* said that *if*
the compiler can prove that the load would always return 1, it can
remove it.  And it's simple to see why that's the case: If this holds,
then in all allowed executions it would load from a know store, the
relaxed_mo gives no further ordering guarantees so we can just take the
value, and we're good.

> So your argument is *shit*. Why do you continue to argue it?

Maybe because it isn't?  Maybe you should try to at least trust that my
intentions are good, even if distrusting my ability to reason.

> I told you how that load can go away, and you agreed. But IT CANNOT GO
> AWAY any other way. You cannot claim "the compiler knows". The
> compiler doesn't know. It's that simple.

Oh yes it can.  Because of the same rules that allow you to perform the
other transformations.  Please try to see the similarities here.  You
previously said you don't want to mix volatile semantics and atomics.
This is something that's being applied in this example.

> >> So why do I say you are wrong, after I just gave you an example of how
> >> it happens? Because my example went back to the *real* issue, and
> >> there are actual real semantically meaningful details with doing
> >> things like load merging.
> >>
> >> To give an example, let's rewrite things a bit more to use an extra variable:
> >>
> >>     atomic_store(&x, 1, mo_relaxed);
> >>     a = atomic_load(&1, mo_relaxed);
> >>     if (a == 1)
> >>         atomic_store(&y, 3, mo_relaxed);
> >>
> >> which looks exactly the same.
> >
> > I'm confused.  Is this a new example?
> 
> That is a new example. The important part is that it has left a
> "trace" for the programmer: because 'a' contains the value, the
> programmer can now look at the value later and say "oh, we know we did
> a store iff a was 1"
> 
> >> This sequence:
> >>
> >>     atomic_store(&x, 1, mo_relaxed);
> >>     a = atomic_load(&x, mo_relaxed);
> >>     atomic_store(&y, 3, mo_relaxed);
> >>
> >> is actually - and very seriously - buggy.
> >>
> >> Why? Because you have effectively split the atomic_load into two loads
> >> - one for the value of 'a', and one for your 'proof' that the store is
> >> unconditional.
> >
> > I can't follow that, because it isn't clear to me which code sequences
> > are meant to belong together, and which transformations the compiler is
> > supposed to make.  If you would clarify that, then I can reply to this
> > part.
> 
> Basically, if the compiler allows the condition of "I wrote 3 to the
> y, but the programmer sees 'a' has another value than 1 later" then
> the compiler is one buggy pile of shit. It fundamentally broke the
> whole concept of atomic accesses. Basically the "atomic" access to 'x'
> turned into two different accesses: the one that "proved" that x had
> the value 1 (and caused the value 3 to be written), and the other load
> that then write that other value into 'a'.
> 
> It's really not that complicated.

Yes that's not complicated, but I assumed this to be obvious and wasn't
aware that this is contentious.

> And this is why descriptions like this should ABSOLUTELY NOT BE
> WRITTEN as "if the compiler can prove that 'x' had the value 1, it can
> remove the branch". Because that IS NOT SUFFICIENT. That was not a
> valid transformation of the atomic load.

Now I see where the confusion was.  Sorry if I didn't point this out
explicitly, but if proving that x had the value 1, the first thing a
compiler would naturally do is to replace *the load* by 1, and
*afterwards* remove the branch because it sees 1 == 1.

Nonetheless, if being picky about it, keeping the load is correct if the
proof that x will always have the value 1 is correct (it might prevent
some optimizations though; in foo() above, keeping the load would also
prevent removing the variable on the stack).  In a correct compiler,
this will of course lead to the memory location actually existing and
having the value 1 in a compiled program.

> The only valid transformation was the one I stated, namely to remove
> the load entirely and replace it with the value written earlier in the
> same execution context.

No, your transformation is similar but has a different reasoning behind
it.  What the compiler (easily) proves in your example is that *this
thread* is always allowed to observe it's prior store to x.  That's a
different assumption than that x will always be of value 1 when this
code sequence is executed.  Therefore, the results for the compilation
are also slightly different.

> Really, why is so hard to understand?

It's not hard to understand, we've just been talking past each other.
(But that's something we both participated in, I'd like to point out.)

I think it also shows that reasoning about executions starting with what
the compiler and HW can do to the code is more complex than reasoning
about allowed executions of the abstract machine.  If using the latter,
and you would have formulated the proof the compiler does about the
executions, we might have been able to see the misunderstanding earlier.

