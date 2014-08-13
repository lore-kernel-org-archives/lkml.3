Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaHMWon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:44:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38286 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbaHMWol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:44:41 -0400
Date: Wed, 13 Aug 2014 15:44:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <pranith@gatech.edu>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Question regarding "Control Dependencies" in memory-barriers.txt
Message-ID: <20140813224436.GA4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAJhHMCADiEsUC7GsYF7=qMNEyRJerfhC5zh7WQPgkQ0gJn5=5A@mail.gmail.com>
 <20140804185226.GQ8101@linux.vnet.ibm.com>
 <CAJhHMCBEprK9hp786cwguJR=JW7Xxgt4GKX5=E0vikO-D4qmZg@mail.gmail.com>
 <20140805073237.GX3935@laptop>
 <CAJhHMCBjub+_Gg_wC2EoR5OgzwT7JTHr-wzoGp_dePUBVwEG8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCBjub+_Gg_wC2EoR5OgzwT7JTHr-wzoGp_dePUBVwEG8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081322-6688-0000-0000-000003FE68D5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2014 at 08:13:54AM -0400, Pranith Kumar wrote:
> On Tue, Aug 5, 2014 at 3:32 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >>
> >> 685 This transformation loses the ordering between the load from variable 'a'
> >> 686 and the store to variable 'b'.  If you are relying on this ordering, you
> >> 687 should do something like the following:
> >> 688
> >> 689         q = ACCESS_ONCE(a);
> >> 690         BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
> >> 691         if (q % MAX) {
> >> 692                 ACCESS_ONCE(b) = p;
> >> 693                 do_something();
> >> 694         } else {
> >> 695                 ACCESS_ONCE(b) = p;
> >> 696                 do_something_else();
> >> 697         }
> >> 698
> >>
> >> How is the BUILD_BUG_ON(MAX <= 1) guaranteeing the ordering w.r.t 'a'
> >> and 'b'. Shouldn't it have barrier() in both the legs of the if()
> >> statement like follows:
> >
> > The BUILD_BUG_ON guarantees that 'q % MAX' isn't a constant, and
> > therefore the compiler cannot take the conditional out.
> >
> > And no barrier() doesn't order anything except compiler output. The
> > ordering here happens by the conditional, CPUs do not do speculative
> > writes, this means it has to complete the load of q to compute the
> > branch before it can execute the store of b.
> >
> >
> 
> I don't think the write to 'b' here is speculative since it is
> happening in both the legs of the if() conditional. The write to b can
> be pulled out to before the conditional. Without the barrier(), isn't
> the following a valid transformation of the above?
> 
> BUILD_BUG_ON(MAX <= 1); /* this will be compiled out if MAX != 1*/
> q = ACCESS_ONCE(a);
> ACCESS_ONCE(b) = p; / *BUG: No ordering */
> if (q % MAX) {
>         do_something();
> } else {
>         do_something_else();
> }
> 
> I don't see how it is preserving the ordering.

Well, let's try it with a real compiler.  I am running gcc version 4.6.3
(yes, ancient).  Given the following:

	int a;
	int b;

	#define MAX 10
	#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
	#define barrier() __asm__ __volatile__("": : :"memory")

	void do_something(void);
	void do_something_else(void);

	void foo(void)
	{
		int q;

		q = ACCESS_ONCE(a);
		if (q % MAX) {
			ACCESS_ONCE(b) = q;
			do_something();
		} else {
			ACCESS_ONCE(b) = q;
			do_something_else();
		}
	}

cc -O3 -c controldep2.c gives the following:

		.file	"controldep2.c"
		.text
		.p2align 4,,15
		.globl	foo
		.type	foo, @function
	foo:
	.LFB0:
		.cfi_startproc
		movl	a, %ecx
		movl	$1717986919, %edx
		movl	%ecx, %eax
		imull	%edx
		movl	%ecx, %eax
		sarl	$31, %eax
		movl	%ecx, b
		sarl	$2, %edx
		subl	%eax, %edx
		leal	(%edx,%edx,4), %eax
		addl	%eax, %eax
		cmpl	%eax, %ecx
		jne	.L4
		jmp	do_something_else
		.p2align 4,,7
		.p2align 3
	.L4:
		jmp	do_something
		.cfi_endproc
	.LFE0:
		.size	foo, .-foo
		.comm	b,4,4
		.comm	a,4,4
		.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
		.section	.note.GNU-stack,"",@progbits

As you can see, the assignment to "b" has been hoisted above the "if".
And adding barrier() to each leg of the "if" statement doesn't help,
the store to "b" still gets hoisted.

So this whole "q % MAX" example is bogus...

In fact, if you have the same store on both legs of the "if" statement,
your ordering appears to be toast, at least at high optimization levels.

You would think that I would have tested with -O3 initially.  :-(

Patch below.

							Thanx, Paul

------------------------------------------------------------------------

memory-barriers: Fix description of 2-legged-if-based control dependencies

Sad to say, current compilers really will hoist identical stores from both
branches of an "if" statement to precede the conditional.  This commit
therefore updates the description of control dependencies to reflect this
ugly reality.

Reported-by: Pranith Kumar <bobby.prani@gmail.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 600b45c6e2ad..6062f175abc6 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -574,30 +574,14 @@ However, stores are not speculated.  This means that ordering -is- provided
 in the following example:
 
 	q = ACCESS_ONCE(a);
-	if (ACCESS_ONCE(q)) {
-		ACCESS_ONCE(b) = p;
-	}
-
-Please note that ACCESS_ONCE() is not optional!  Without the ACCESS_ONCE(),
-the compiler is within its rights to transform this example:
-
-	q = a;
 	if (q) {
-		b = p;  /* BUG: Compiler can reorder!!! */
-		do_something();
-	} else {
-		b = p;  /* BUG: Compiler can reorder!!! */
-		do_something_else();
+		ACCESS_ONCE(b) = p;
 	}
 
-into this, which of course defeats the ordering:
-
-	b = p;
-	q = a;
-	if (q)
-		do_something();
-	else
-		do_something_else();
+Please note that ACCESS_ONCE() is not optional!  Without the
+ACCESS_ONCE(), might combine the load from 'a' with other loads from
+'a', and the store to 'b' with other stores to 'b', with possible highly
+counterintuitive effects on ordering.
 
 Worse yet, if the compiler is able to prove (say) that the value of
 variable 'a' is always non-zero, it would be well within its rights
@@ -605,11 +589,12 @@ to optimize the original example by eliminating the "if" statement
 as follows:
 
 	q = a;
-	b = p;  /* BUG: Compiler can reorder!!! */
-	do_something();
+	b = p;  /* BUG: Compiler and CPU can both reorder!!! */
+
+So don't leave out the ACCESS_ONCE().
 
-The solution is again ACCESS_ONCE() and barrier(), which preserves the
-ordering between the load from variable 'a' and the store to variable 'b':
+It is tempting to try to enforce ordering on identical stores on both
+branches of the "if" statement as follows:
 
 	q = ACCESS_ONCE(a);
 	if (q) {
@@ -622,18 +607,11 @@ ordering between the load from variable 'a' and the store to variable 'b':
 		do_something_else();
 	}
 
-The initial ACCESS_ONCE() is required to prevent the compiler from
-proving the value of 'a', and the pair of barrier() invocations are
-required to prevent the compiler from pulling the two identical stores
-to 'b' out from the legs of the "if" statement.
-
-It is important to note that control dependencies absolutely require a
-a conditional.  For example, the following "optimized" version of
-the above example breaks ordering, which is why the barrier() invocations
-are absolutely required if you have identical stores in both legs of
-the "if" statement:
+Unfortunately, current compilers will transform this as follows at high
+optimization levels:
 
 	q = ACCESS_ONCE(a);
+	barrier();
 	ACCESS_ONCE(b) = p;  /* BUG: No ordering vs. load from a!!! */
 	if (q) {
 		/* ACCESS_ONCE(b) = p; -- moved up, BUG!!! */
@@ -643,21 +621,25 @@ the "if" statement:
 		do_something_else();
 	}
 
-It is of course legal for the prior load to be part of the conditional,
-for example, as follows:
+Now there is no conditional between the load from 'a' and the store to
+'b', which means that the CPU is within its rights to reorder them:
+The conditional is absolutely required, and must be present in the
+assembly code even after all compiler optimizations have been applied.
 
-	if (ACCESS_ONCE(a) > 0) {
-		barrier();
-		ACCESS_ONCE(b) = q / 2;
+So two-legged-if control ordering is guaranteed only when the stores
+differ, for example:
+
+	q = ACCESS_ONCE(a);
+	if (q) {
+		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
-		barrier();
-		ACCESS_ONCE(b) = q / 3;
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
-This will again ensure that the load from variable 'a' is ordered before the
-stores to variable 'b'.
+The initial ACCESS_ONCE() is still required to prevent the compiler from
+proving the value of 'a'.
 
 In addition, you need to be careful what you do with the local variable 'q',
 otherwise the compiler might be able to guess the value and again remove
@@ -665,12 +647,10 @@ the needed conditional.  For example:
 
 	q = ACCESS_ONCE(a);
 	if (q % MAX) {
-		barrier();
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
-		barrier();
-		ACCESS_ONCE(b) = p;
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
@@ -679,15 +659,15 @@ equal to zero, in which case the compiler is within its rights to
 transform the above code into the following:
 
 	q = ACCESS_ONCE(a);
-	barrier();
 	ACCESS_ONCE(b) = p;
 	do_something_else();
 
-This transformation fails to require that the CPU respect the ordering
-between the load from variable 'a' and the store to variable 'b'.
-Yes, the barrier() is still there, but it affects only the compiler,
-not the CPU.  Therefore, if you are relying on this ordering, you should
-do something like the following:
+Given this transformation, the CPU is not required to respect the ordering
+between the load from variable 'a' and the store to variable 'b'.  It is
+tempting to add a barrier(), but this does not help.  The conditional
+is gone, and the barrier won't bring it back.  Therefore, if you are
+relying on this ordering, you should make sure that MAX is greater than
+one, perhaps as follows:
 
 	q = ACCESS_ONCE(a);
 	BUILD_BUG_ON(MAX <= 1); /* Order load from a with store to b. */
@@ -695,10 +675,14 @@ do something like the following:
 		ACCESS_ONCE(b) = p;
 		do_something();
 	} else {
-		ACCESS_ONCE(b) = p;
+		ACCESS_ONCE(b) = r;
 		do_something_else();
 	}
 
+Please note once again that the stores to 'b' differ.  If they were
+identical, as noted earlier, the compiler could pull this store outside
+of the 'if' statement.
+
 Finally, control dependencies do -not- provide transitivity.  This is
 demonstrated by two related examples, with the initial values of
 x and y both being zero:

