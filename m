Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaBRSVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 13:21:34 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45389 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaBRSVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:21:32 -0500
MIME-Version: 1.0
Reply-To: Peter.Sewell@cl.cam.ac.uk
In-Reply-To: <CA+55aFw=9iKadR-r5sdZdJ_7yDzSV4=+P=gZXXsrxU61wKHf5w@mail.gmail.com>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
	<CA+55aFw=9iKadR-r5sdZdJ_7yDzSV4=+P=gZXXsrxU61wKHf5w@mail.gmail.com>
Date: Tue, 18 Feb 2014 18:21:32 +0000
X-Google-Sender-Auth: lY6DeEUwBkuMBrq5Fd5rEQFdAEc
Message-ID: <CAHWkzRQp3x4Wsnr6ZRdxfk04MuWT3bANnL8=VbCVEZ6+ifiqYA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 February 2014 17:38, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, Feb 18, 2014 at 4:12 AM, Peter Sewell <Peter.Sewell@cl.cam.ac.uk> wrote:
>>
>> For example, suppose we have, in one compilation unit:
>>
>>     void f(int ra, int*rb) {
>>       if (ra==42)
>>         *rb=42;
>>       else
>>         *rb=42;
>>     }
>
> So this is a great example, and in general I really like your page at:
>
>> For more context, this example is taken from a summary of the thin-air
>> problem by Mark Batty and myself,
>> <www.cl.cam.ac.uk/~pes20/cpp/notes42.html>, and the problem with
>> dependencies via other compilation units was AFAIK first pointed out
>> by Hans Boehm.
>
> and the reason I like your page is that it really talks about the
> problem by pointing to the "unoptimized" code, and what hardware would
> do.

Thanks.  It's certainly necessary to separately understand what compiler
optimisation and the hardware might do, to get anywhere here.   But...

> As mentioned, I think that's actually the *correct* way to think about
> the problem space, because it allows the programmer to take hardware
> characteristics into account, without having to try to "describe" them
> at a source level.

...to be clear, I am ultimately after a decent source-level description of what
programmers can depend on, and we (Mark and I) view that page as
identifying constraints on what that description can say.  There are too
many compiler optimisations for people to reason directly in terms of
the set of all transformations that they do, so we need some more
concise and comprehensible envelope identifying what is allowed,
as an interface between compiler writers and users.  AIUI that's basically
what Torvald is arguing.

The C11 spec in its current form is not yet fully up to that task, for one thing
because it doesn't attempt to cover all the h/w interactions that you and
Paul list, but that is where we're trying to go with our formalisation work.

> As to your example of
>
>    if (ra)
>        atomic_write(rb, A);
>    else
>        atomic_write(rb, B);
>
> I really think that it is ok to combine that into
>
>     atomic_write(rb, ra ? A:B);
>
> (by virtue of "exact same behavior on actual hardware"), and then the
> only remaining question is whether the "ra?A:B" can be optimized to
> remove the conditional if A==B as in your example where both are "42".
> Agreed?

y

> Now, I would argue that the "naive" translation of that is
> unambiguous, and since "ra" is not volatile or magic in any way, then
> "ra?42:42" can obviously be optimized into just 42 - by the exact same
> rule that says "the compiler can do any transformation that is
> equivalent in the hardware". The compiler can *locally* decide that
> that is the right thing to do, and any programmer that complains about
> that decision is just crazy.
>
> So my "local machine behavior equivalency" rule means that that
> function can be optimized into a single "store 42 atomically into rb".

This is a bit more subtle, because (on ARM and POWER) removing the
dependency and conditional branch is actually in general *not* equivalent
in the hardware, in a concurrent context.

That notwithstanding, I tend to agree that preventing that optimisation for
non-atomics would be prohibitively costly (though I'd like real data).

It's tempting then to permit more-or-less any optimisation for thread-local
accesses but rule out value-range analysis and suchlike for shared-memory
accesses.  Whether that would be viable from a compiler point of view, I don't
know.   In C, one will at best only be able to get an approximate analysis
of which is which, just for a start.


> Now, if it's *not* compiled locally, and is instead implemented as a
> macro (or inline function), there are obviously situations where "ra ?
> A : B" ends up having to do other things. In particular, X may be
> volatile or an atomic read that has ordering semantics, and then that
> expression doesn't become just "42", but that's a separate issue. It's
> not all that dissimilar to "function calls are sequence points",
> though, and obviously if the source of "ra" has semantic meaning, you
> have to honor that semantic meaning.

separate point, indeed

Peter
