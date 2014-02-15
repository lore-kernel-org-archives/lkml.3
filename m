Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825AbaBOTQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 14:16:03 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64111 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753802AbaBOTQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 14:16:00 -0500
MIME-Version: 1.0
In-Reply-To: <1392485428.18779.6387.camel@triegel.csb>
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
Date: Sat, 15 Feb 2014 11:15:59 -0800
X-Google-Sender-Auth: z7A6iYI21Op3UB6t1-1GqvYsAAI
Message-ID: <CA+55aFw5v8Zc818YoxazFhP0btN1faofNbED=qrpi3VrtRA39w@mail.gmail.com>
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

On Sat, Feb 15, 2014 at 9:30 AM, Torvald Riegel <triegel@redhat.com> wrote:
>
> I think the example is easy to misunderstand, because the context isn't
> clear.  Therefore, let me first try to clarify the background.
>
> (1) The abstract machine does not write speculatively.
> (2) Emitting a branch instruction and executing a branch at runtime is
> not part of the specified behavior of the abstract machine.  Of course,
> the abstract machine performs conditional execution, but that just
> specifies the output / side effects that it must produce (e.g., volatile
> stores) -- not with which hardware instructions it is producing this.
> (3) A compiled program must produce the same output as if executed by
> the abstract machine.

Ok, I'm fine with that.

> Thus, we need to be careful what "speculative store" is meant to refer
> to.  A few examples:
>
> if (atomic_load(&x, mo_relaxed) == 1)
>   atomic_store(&y, 3, mo_relaxed));

No, please don't use this idiotic example. It is wrong.

The fact is, if a compiler generates anything but the obvious sequence
(read/cmp/branch/store - where branch/store might obviously be done
with some other machine conditional like a predicate), the compiler is
wrong.

Anybody who argues anything else is wrong, or confused, or confusing.

Instead, argue about *other* sequences where the compiler can do something.

For example, this sequence:

   atomic_store(&x, a, mo_relaxed);
   b = atomic_load(&x, mo_relaxed);

can validly be transformed to

   atomic_store(&x, a, mo_relaxed);
   b = (typeof(x)) a;

and I think everybody agrees about that. In fact, that optimization
can be done even for mo_strict.

But even that "obvious" optimization has subtle cases. What if the
store is relaxed, but the load is strict? You can't do the
optimization without a lot of though, because dropping the strict load
would drop an ordering point. So even the "store followed by exact
same load" case has subtle issues.

With similar caveats, it is perfectly valid to merge two consecutive
loads, and to merge two consecutive stores.

Now that means that the sequence

    atomic_store(&x, 1, mo_relaxed);
    if (atomic_load(&x, mo_relaxed) == 1)
        atomic_store(&y, 3, mo_relaxed);

can first be optimized to

    atomic_store(&x, 1, mo_relaxed);
    if (1 == 1)
        atomic_store(&y, 3, mo_relaxed);

and then you get the end result that you wanted in the first place
(including the ability to re-order the two stores due to the relaxed
ordering, assuming they can be proven to not alias - and please don't
use the idiotic type-based aliasing rules).

Bringing up your first example is pure and utter confusion. Don't do
it. Instead, show what are obvious and valid transformations, and then
you can bring up these kinds of combinations as "look, this is
obviously also correct".

Now, the reason I want to make it clear that the code example you
point to is a crap example is that because it doesn't talk about the
*real* issue, it also misses a lot of really important details.

For example, when you say "if the compiler can prove that the
conditional is always true" then YOU ARE TOTALLY WRONG.

So why do I say you are wrong, after I just gave you an example of how
it happens? Because my example went back to the *real* issue, and
there are actual real semantically meaningful details with doing
things like load merging.

To give an example, let's rewrite things a bit more to use an extra variable:

    atomic_store(&x, 1, mo_relaxed);
    a = atomic_load(&1, mo_relaxed);
    if (a == 1)
        atomic_store(&y, 3, mo_relaxed);

which looks exactly the same. If you now say "if you can prove the
conditional is always true, you can make the store unconditional", YOU
ARE WRONG.

Why?

This sequence:

    atomic_store(&x, 1, mo_relaxed);
    a = atomic_load(&x, mo_relaxed);
    atomic_store(&y, 3, mo_relaxed);

is actually - and very seriously - buggy.

Why? Because you have effectively split the atomic_load into two loads
- one for the value of 'a', and one for your 'proof' that the store is
unconditional.

Maybe you go "Nobody sane would do that", and you'd be right. But
compilers aren't "sane" (and compiler _writers_ I have some serious
doubts about), and how you describe the problem really does affect the
solution.

My description ("you can combine two subsequent atomic accesses, if
you are careful about still having the same ordering points") doesn't
have the confusion. It makes it clear that no, you can't speculate
writes, but yes, obviously you can combine certain things (think
"write buffers" and "memory caches"), and that may make you able to
remove the conditional. Which is very different from speculating
writes.

But my description also makes it clear that the transformation above
was buggy, but that rewriting it as

    a = 1;
    atomic_store(&y, 3, mo_relaxed);
    atomic_store(&x, a, mo_relaxed);

is fine (doing the re-ordering here just to make a point).

So I suspect we actually agree, I just think that the "example" that
has been floating around, and the explanation for it, has been
actively bad and misleading.

             Linus
