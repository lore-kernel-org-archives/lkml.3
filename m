Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaBRRif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:38:35 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:50880 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaBRRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:38:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
Date: Tue, 18 Feb 2014 09:38:32 -0800
X-Google-Sender-Auth: qRGfqhgSOI5-D30CRVl8jUlOG_c
Message-ID: <CA+55aFw=9iKadR-r5sdZdJ_7yDzSV4=+P=gZXXsrxU61wKHf5w@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter.Sewell@cl.cam.ac.uk
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 4:12 AM, Peter Sewell <Peter.Sewell@cl.cam.ac.uk> wrote:
>
> For example, suppose we have, in one compilation unit:
>
>     void f(int ra, int*rb) {
>       if (ra==42)
>         *rb=42;
>       else
>         *rb=42;
>     }

So this is a great example, and in general I really like your page at:

> For more context, this example is taken from a summary of the thin-air
> problem by Mark Batty and myself,
> <www.cl.cam.ac.uk/~pes20/cpp/notes42.html>, and the problem with
> dependencies via other compilation units was AFAIK first pointed out
> by Hans Boehm.

and the reason I like your page is that it really talks about the
problem by pointing to the "unoptimized" code, and what hardware would
do.

As mentioned, I think that's actually the *correct* way to think about
the problem space, because it allows the programmer to take hardware
characteristics into account, without having to try to "describe" them
at a source level.

As to your example of

   if (ra)
       atomic_write(rb, A);
   else
       atomic_write(rb, B);

I really think that it is ok to combine that into

    atomic_write(rb, ra ? A:B);

(by virtue of "exact same behavior on actual hardware"), and then the
only remaining question is whether the "ra?A:B" can be optimized to
remove the conditional if A==B as in your example where both are "42".
Agreed?

Now, I would argue that the "naive" translation of that is
unambiguous, and since "ra" is not volatile or magic in any way, then
"ra?42:42" can obviously be optimized into just 42 - by the exact same
rule that says "the compiler can do any transformation that is
equivalent in the hardware". The compiler can *locally* decide that
that is the right thing to do, and any programmer that complains about
that decision is just crazy.

So my "local machine behavior equivalency" rule means that that
function can be optimized into a single "store 42 atomically into rb".

Now, if it's *not* compiled locally, and is instead implemented as a
macro (or inline function), there are obviously situations where "ra ?
A : B" ends up having to do other things. In particular, X may be
volatile or an atomic read that has ordering semantics, and then that
expression doesn't become just "42", but that's a separate issue. It's
not all that dissimilar to "function calls are sequence points",
though, and obviously if the source of "ra" has semantic meaning, you
have to honor that semantic meaning.

Agreed?

                  Linus
