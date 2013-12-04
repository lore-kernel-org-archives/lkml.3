Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab3LDAsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 19:48:09 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38127 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab3LDAsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 19:48:05 -0500
Date: Tue, 3 Dec 2013 16:47:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH v2 RFC 1/3] documentation: Add needed ACCESS_ONCE() calls
 to memory-barriers.txt
Message-ID: <20131204004759.GA15111@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131121213055.GA6938@linux.vnet.ibm.com>
 <1385069489-7898-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20131122153908.GQ10022@twins.programming.kicks-ass.net>
 <20131122181313.GU4138@linux.vnet.ibm.com>
 <20131123090406.GL4971@laptop.programming.kicks-ass.net>
 <20131123171719.GN4138@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131123171719.GN4138@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120400-1344-0000-0000-000003C244EE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 09:17:19AM -0800, Paul E. McKenney wrote:
> On Sat, Nov 23, 2013 at 10:04:06AM +0100, Peter Zijlstra wrote:
> > On Fri, Nov 22, 2013 at 10:13:13AM -0800, Paul E. McKenney wrote:
> > > How about the following?
> > > 
> > > 							Thanx, Paul
> > > 
> > > ------------------------------------------------------------------------
> > > 
> > > COMPILER BARRIER
> > > ----------------
> > > 
> > > The Linux kernel has an explicit compiler barrier function that prevents the
> > > compiler from moving the memory accesses either side of it to the other side:
> > > 
> > >         barrier();
> > > 
> > > This is a general barrier -- there are no read-read or write-write variants
> > > of barrier().  Howevever, ACCESS_ONCE() can be thought of as a weak form
> > > for barrier() that affects only the specific accesses flagged by the
> > > ACCESS_ONCE().
> > > 
> > > The compiler barrier has no direct effect on the CPU, which may then reorder
> > > things however it wishes.
> > > 
> > 
> > Seems ok, however this also seems like the natural spot to put that
> > chunk about how a compiler can mis-transform stuff without either
> > barrier or ACCESS_ONC(); that currently seems spread out over the
> > document in some notes.
> > 
> > The biggest of which seems to have ended up in the GUARANTEES chapter.
> 
> Good point!  I believe that the spread-out stuff is still needed, so I
> will add a summary of that information here, perhaps based in part on
> Jon Corbet's ACCESS_ONCE() article (http://lwn.net/Articles/508991/).
> 
> Seem reasonable?

For example, how about the following?

							Thanx, Paul

------------------------------------------------------------------------

 b/Documentation/memory-barriers.txt |  253 +++++++++++++++++++++++++++++++-----
 1 file changed, 219 insertions(+), 34 deletions(-)

Documentation/memory-barriers.txt: Document ACCESS_ONCE()

The situations in which ACCESS_ONCE() is required are not well documented,
so this commit adds some verbiage to memory-barriers.txt.

Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 1a2e5079b7f8..27ad05f47d83 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -231,37 +231,8 @@ And there are a number of things that _must_ or _must_not_ be assumed:
  (*) It _must_not_ be assumed that the compiler will do what you want with
      memory references that are not protected by ACCESS_ONCE().  Without
      ACCESS_ONCE(), the compiler is within its rights to do all sorts
-     of "creative" transformations:
-
-     (-) Repeat the load, possibly getting a different value on the second
-         and subsequent loads.  This is especially prone to happen when
-	 register pressure is high.
-
-     (-) Merge adjacent loads and stores to the same location.  The most
-         familiar example is the transformation from:
-
-		while (a)
-			do_something();
-
-         to something like:
-
-		if (a)
-			for (;;)
-				do_something();
-
-         Using ACCESS_ONCE() as follows prevents this sort of optimization:
-
-		while (ACCESS_ONCE(a))
-			do_something();
-
-     (-) "Store tearing", where a single store in the source code is split
-         into smaller stores in the object code.  Note that gcc really
-	 will do this on some architectures when storing certain constants.
-	 It can be cheaper to do a series of immediate stores than to
-	 form the constant in a register and then to store that register.
-
-     (-) "Load tearing", which splits loads in a manner analogous to
-     	 store tearing.
+     of "creative" transformations, which are covered in the Compiler
+     Barrier section.
 
  (*) It _must_not_ be assumed that independent loads and stores will be issued
      in the order given.  This means that for:
@@ -748,7 +719,8 @@ In summary:
 
   (*) Control dependencies require that the compiler avoid reordering the
       dependency into nonexistence.  Careful use of ACCESS_ONCE() or
-      barrier() can help to preserve your control dependency.
+      barrier() can help to preserve your control dependency.  Please
+      see the Compiler Barrier section for more information.
 
   (*) Control dependencies do -not- provide transitivity.  If you
       need transitivity, use smp_mb().
@@ -1251,8 +1223,221 @@ of barrier().  Howevever, ACCESS_ONCE() can be thought of as a weak form
 for barrier() that affects only the specific accesses flagged by the
 ACCESS_ONCE().
 
-The compiler barrier has no direct effect on the CPU, which may then reorder
-things however it wishes.
+The barrier() function has the following effects:
+
+ (*) Prevents the compiler from reordering accesses following the
+     barrier() to precede any accesses preceding the barrier().
+     One example use for this property is to ease communication between
+     interrupt-handler code and the code that was interrupted.
+
+ (*) Within a loop, forces the compiler to load the variables used
+     in that loop's conditional on each pass through that loop.
+
+The ACCESS_ONCE() function can prevent any number of optimizations that,
+while perfectly safe in single-threaded code, can be fatal in concurrent
+code.  Here are some examples of these sorts of optimizations:
+
+ (*) The compiler is within its rights to merge successive loads from
+     the same variable.  Such merging can cause the compiler to "optimize"
+     the following code:
+
+	while (tmp = a)
+		do_something_with(tmp);
+
+     into the following code, which, although in some sense legitimate
+     for single-threaded code, is almost certainly not what the developer
+     intended:
+
+	if (tmp = a)
+		for (;;)
+			do_something_with(tmp);
+
+     Use ACCESS_ONCE() to prevent the compiler from doing this to you:
+
+	while (tmp = ACCESS_ONCE(a))
+		do_something_with(tmp);
+
+ (*) The compiler is within its rights to reload a variable, for example,
+     in cases where high register pressure prevents the compiler from
+     keeping all data of interest in registers.  The compiler might
+     therefore optimize the variable tmp out of our previous example:
+
+	while (tmp = a)
+		do_something_with(tmp);
+
+     This could result in the following code, which is perfectly safe in
+     single-threaded code, but can be fatal in concurrent code:
+
+	while (a)
+		do_something_with(a);
+
+     For example, the optimized version of this code could result in
+     passing a zero to do_something_with() in the case where the variable
+     a was modified by some other CPU between the "while" statement and
+     the call to do_something_with().
+
+     Again, use ACCESS_ONCE() to prevent the compiler from doing this:
+
+	while (tmp = ACCESS_ONCE(a))
+		do_something_with(tmp);
+
+     Note that if the compiler runs short of registers, it might save
+     tmp onto the stack.  The overhead of this saving and later restoring
+     is why compilers reload variables.  Doing so is perfectly safe for
+     single-threaded code, so you need to tell the compiler about cases
+     where it is not safe.
+
+ (*) The compiler is within its rights to omit a load entirely if it knows
+     what the value will be.  For example, if the compiler can prove that
+     the value of variable a is always zero, it can optimize this code:
+
+	while (tmp = a)
+		do_something_with(tmp);
+
+     Into this:
+
+     	do { } while (0);
+
+     This transformation is a win for single-threaded code because it gets
+     rid of a load and a branch.  The problem is that the compiler will
+     carry out its proof assuming that the current CPU is the only one
+     updating variable a.  If variable a is shared, then the compiler's
+     proof will be erroneous.  Use ACCESS_ONCE() to tell the compiler
+     that it doesn't know as much as it thinks it does:
+
+	while (tmp = ACCESS_ONCE(a))
+		do_something_with(tmp);
+
+     But please note that the compiler is also closely watching what you
+     do with the value after the ACCESS_ONCE().  For example, suppose you
+     do the following and MAX is a preprocessor macro with the value 1:
+
+	for ((tmp = ACCESS_ONCE(a)) % MAX)
+		do_something_with(tmp);
+
+     Then the compiler knows that the result of the "%" operator applied
+     to MAX will always be zero, again allowing the compiler to optimize
+     the code into near-nonexistence.  (It will still load from the
+     variable a.)
+
+ (*) Similarly, the compiler is within its rights to omit a store entirely
+     if it knows that the variable already has the value being stored.
+     Again, the compiler assumes that the current CPU is the only one
+     storing into the variable, which can cause the compiler to do the
+     wrong thing for shared variables.  For example, suppose you have
+     the following:
+
+	a = 0;
+	/* Code that does not store to variable a. */
+	a = 0;
+
+     The compiler sees that the value of variable a is already zero, so
+     it might well omit the second store.  This would come as a fatal
+     surprise if some other CPU might have stored to variable a in the
+     meantime.
+
+     Use ACCESS_ONCE() to prevent the compiler from making this sort of
+     wrong guess:
+
+	ACCESS_ONCE(a) = 0;
+	/* Code that does not store to variable a. */
+	ACCESS_ONCE(a) = 0;
+
+ (*) The compiler is within its rights to reorder memory accesses unless
+     you tell it not to.  For example, consider the following interaction
+     between process-level code and an interrupt handler:
+
+	void process_level(void)
+	{
+		msg = get_message();
+		flag = true;
+	}
+
+	void interrupt_handler(void)
+	{
+		if (flag)
+			process_message(msg);
+	}
+
+     There is nothing to prevent the the compiler from transforming
+     process_level() to the following, in fact, this might well be a
+     win for single-threaded code:
+
+	void process_level(void)
+	{
+		flag = true;
+		msg = get_message();
+	}
+
+     If the interrupt occurs between these two statement, then
+     interrupt_handler() might be passed a garbled msg.  Use ACCESS_ONCE()
+     to prevent this as follows:
+
+	void process_level(void)
+	{
+		ACCESS_ONCE(msg) = get_message();
+		ACCESS_ONCE(flag) = true;
+	}
+
+	void interrupt_handler(void)
+	{
+		if (ACCESS_ONCE(flag))
+			process_message(ACCESS_ONCE(msg));
+	}
+
+ (*) The compiler is within its rights to invent stores to a variable,
+     as in the following example:
+
+	if (a)
+		b = a;
+	else
+		b = 42;
+
+     The compiler might save a branch by optimizing this as follows:
+
+	b = 42;
+	if (a)
+		b = a;
+
+     In single-threaded code, this is not only safe, but also saves
+     a branch.  Unfortunately, in concurrent code, this optimization
+     could cause some other CPU to see a spurious value of 42 -- even
+     if variable a was never zero -- when loading variable b.
+     Use ACCESS_ONCE() to prevent this as follows:
+
+	if (a)
+		ACCESS_ONCE(b) = a;
+	else
+		ACCESS_ONCE(b) = 42;
+
+     The compiler can also invent loads.  These are usually less
+     damaging, but they can result in cache-line bouncing and thus in
+     poor performance and scalability.  Use ACCESS_ONCE() to prevent
+     invented loads.
+
+ (*) For aligned memory locations whose size allows them to be accessed
+     with a single memory-reference instruction, prevents "load tearing"
+     and "store tearing," in which a single large access is replaced by
+     multiple smaller accesses.  For example, given an architecture having
+     16-bit store instructions with 7-bit immediate fields, the compiler
+     might be tempted to use two 16-bit store-immediate instructions to
+     implement the following 32-bit store:
+
+	p = 0x00010002;
+
+     Please note that GCC really does use this sort of optimization,
+     which is not surprising given that it would likely take more
+     than two instructions to build the constant and then store it.
+     This optimization can therefore be a win in single-threaded code.
+     In fact, a recent bug (since fixed) caused GCC to incorrectly use
+     this optimization in a volatile store.  In the absence of such bugs,
+     use of ACCESS_ONCE() prevents store tearing:
+
+	ACCESS_ONCE(p) = 0x00010002;
+
+
+Please note that these compiler barriers have no direct effect on the CPU,
+which may then reorder things however it wishes.
 
 
 CPU MEMORY BARRIERS

