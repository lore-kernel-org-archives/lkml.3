Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbaBRMML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 07:12:11 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:45309 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaBRMMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 07:12:07 -0500
MIME-Version: 1.0
Reply-To: Peter.Sewell@cl.cam.ac.uk
Date: Tue, 18 Feb 2014 12:12:06 +0000
X-Google-Sender-Auth: fEaRQeRDUor0Eviuq1ESMt9y3XA
Message-ID: <CAHWkzRQSaKOM23yg1LbCO=uWremNzwnXUCUJF2H-+z_Xhmp79g@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
To: Peter Sewell <Peter.Sewell@cl.cam.ac.uk>,
        "mark.batty@cl.cam.ac.uk" <Mark.Batty@cl.cam.ac.uk>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, peterz@infradead.org,
        Torvald Riegel <triegel@redhat.com>, torvalds@linux-foundation.org,
        Will Deacon <will.deacon@arm.com>, Ramana.Radhakrishnan@arm.com,
        dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@kernel.org, gcc@gcc.gnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several of you have said that the standard and compiler should not
permit speculative writes of atomics, or (effectively) that the
compiler should preserve dependencies.  In simple examples it's easy
to see what that means, but in general it's not so clear what the
language should guarantee, because dependencies may go via non-atomic
code in other compilation units, and we have to consider the extent to
which it's desirable to limit optimisation there.

For example, suppose we have, in one compilation unit:

    void f(int ra, int*rb) {
      if (ra==42)
        *rb=42;
      else
        *rb=42;
    }

and in another compilation unit the bodies of two threads:

    // Thread 0
    r1 = x;
    f(r1,&r2);
    y = r2;

    // Thread 1
    r3 = y;
    f(r3,&r4);
    x = r4;

where accesses to x and y are annotated C11 atomic
memory_order_relaxed or Linux ACCESS_ONCE(), accesses to
r1,r2,r3,r4,ra,rb are not annotated, and x and y initially hold 0.

(Of course, this is an artificial example, to make the point below as
simply as possible - in real code the branches of the conditional
might not be syntactically identical, just equivalent after macro
expansion and other optimisation.)

In the source program there's a dependency from the read of x to the
write of y in Thread 0, and from the read of y to the write of x on
Thread 1.  Dependency-respecting compilation would preserve those and
the ARM and POWER architectures both respect them, so the reads of x
and y could not give 42.

But a compiler might well optimise the (non-atomic) body of f() to
just *rb=42, making the threads effectively

    // Thread 0
    r1 = x;
    y = 42;

    // Thread 1
    r3 = y;
    x = 42;

(GCC does this at O1, O2, and O3) and the ARM and POWER architectures
permit those two reads to see 42. That is moreover actually observable
on current ARM hardware.

So as far as we can see, either:

1) if you can accept the latter behaviour (if the Linux codebase does
   not rely on its absence), the language definition should permit it,
   and current compiler optimisations can be used,

or

2) otherwise, the language definition should prohibit it but the
   compiler would have to preserve dependencies even in compilation
   units that have no mention of atomics.  It's unclear what the
   (runtime and compiler development) cost of that would be in
   practice - perhaps Torvald could comment?


For more context, this example is taken from a summary of the thin-air
problem by Mark Batty and myself,
<www.cl.cam.ac.uk/~pes20/cpp/notes42.html>, and the problem with
dependencies via other compilation units was AFAIK first pointed out
by Hans Boehm.

Peter
