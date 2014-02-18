Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbaBRPEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 10:04:38 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:53999 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbaBRO5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:57:02 -0500
Date: Tue, 18 Feb 2014 06:56:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
Cc: "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>, peterz@infradead.org,
        Torvald Riegel <triegel@redhat.com>, torvalds@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>, Ramana.Radhakrishnan@arm.com,
        dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@kernel.org, gcc@gcc.gnu.org
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140218145645.GK4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021814-7164-0000-0000-0000062D2AEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 12:12:06PM +0000, Peter Sewell wrote:
> Several of you have said that the standard and compiler should not
> permit speculative writes of atomics, or (effectively) that the
> compiler should preserve dependencies.  In simple examples it's easy
> to see what that means, but in general it's not so clear what the
> language should guarantee, because dependencies may go via non-atomic
> code in other compilation units, and we have to consider the extent to
> which it's desirable to limit optimisation there.
> 
> For example, suppose we have, in one compilation unit:
> 
>     void f(int ra, int*rb) {
>       if (ra==42)
>         *rb=42;
>       else
>         *rb=42;
>     }

Hello, Peter!

Nice example!

The relevant portion of Documentation/memory-barriers.txt in my -rcu tree
says the following about the control dependency in the above construct:

------------------------------------------------------------------------

	q = ACCESS_ONCE(a);
	if (q) {
		barrier();
		ACCESS_ONCE(b) = p;
		do_something();
	} else {
		barrier();
		ACCESS_ONCE(b) = p;
		do_something_else();
	}

The initial ACCESS_ONCE() is required to prevent the compiler from
proving the value of 'a', and the pair of barrier() invocations are
required to prevent the compiler from pulling the two identical stores
to 'b' out from the legs of the "if" statement.

------------------------------------------------------------------------

So yes, current compilers need significant help if it is necessary to
maintain dependencies in that sort of code.

Similar examples came up in the data-dependency discussions in the
standards committee, which led to the [[carries_dependency]] attribute for
C11 and C++11.  Of course, current compilers don't have this attribute,
and the current Linux kernel code doesn't have any other marking for
data dependencies passing across function boundaries.  (Maybe some time
as an assist for detecting pointer leaks out of RCU read-side critical
sections, but efforts along those lines are a bit stalled at the moment.)

More on data dependencies below...

> and in another compilation unit the bodies of two threads:
> 
>     // Thread 0
>     r1 = x;
>     f(r1,&r2);
>     y = r2;
> 
>     // Thread 1
>     r3 = y;
>     f(r3,&r4);
>     x = r4;
> 
> where accesses to x and y are annotated C11 atomic
> memory_order_relaxed or Linux ACCESS_ONCE(), accesses to
> r1,r2,r3,r4,ra,rb are not annotated, and x and y initially hold 0.
> 
> (Of course, this is an artificial example, to make the point below as
> simply as possible - in real code the branches of the conditional
> might not be syntactically identical, just equivalent after macro
> expansion and other optimisation.)
> 
> In the source program there's a dependency from the read of x to the
> write of y in Thread 0, and from the read of y to the write of x on
> Thread 1.  Dependency-respecting compilation would preserve those and
> the ARM and POWER architectures both respect them, so the reads of x
> and y could not give 42.
> 
> But a compiler might well optimise the (non-atomic) body of f() to
> just *rb=42, making the threads effectively
> 
>     // Thread 0
>     r1 = x;
>     y = 42;
> 
>     // Thread 1
>     r3 = y;
>     x = 42;
> 
> (GCC does this at O1, O2, and O3) and the ARM and POWER architectures
> permit those two reads to see 42. That is moreover actually observable
> on current ARM hardware.

I do agree that this could happen on current compilers and hardware.

Agreed, but as Peter Zijlstra noted in this thread, this optimization
is to a control dependency, not a data dependency.

> So as far as we can see, either:
> 
> 1) if you can accept the latter behaviour (if the Linux codebase does
>    not rely on its absence), the language definition should permit it,
>    and current compiler optimisations can be used,
> 
> or
> 
> 2) otherwise, the language definition should prohibit it but the
>    compiler would have to preserve dependencies even in compilation
>    units that have no mention of atomics.  It's unclear what the
>    (runtime and compiler development) cost of that would be in
>    practice - perhaps Torvald could comment?

For current compilers, we have to rely on coding conventions within
the Linux kernel in combination with non-standard extentions to gcc
and specified compiler flags to disable undesirable behavior.  I have a
start on specifying this in a document I am preparing for the standards
committee, a very early draft of which may be found here:

http://www2.rdrop.com/users/paulmck/scalability/paper/consume.2014.02.16c.pdf

Section 3 shows the results of a manual scan through the Linux kernel's
dependency chains, and Section 4.1 lists a probably incomplete (and no
doubt erroneous) list of coding standards required to make dependency
chains work on current compilers.  Any comments and suggestions are more
than welcome!

> For more context, this example is taken from a summary of the thin-air
> problem by Mark Batty and myself,
> <www.cl.cam.ac.uk/~pes20/cpp/notes42.html>, and the problem with
> dependencies via other compilation units was AFAIK first pointed out
> by Hans Boehm.

Nice document!

One point of confusion for me...  Example 4 says "language must allow".
Shouldn't that be "language is permitted to allow"?  Seems like an
implementation is always within its rights to avoid an optimization if
its implementation prevents it from safely detecting the oppportunity
for that optimization.  Or am I missing something here?

							Thanx, Paul

