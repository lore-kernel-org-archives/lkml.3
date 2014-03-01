Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaCAAu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:50:58 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56471 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417AbaCAAuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:50:54 -0500
Date: Fri, 28 Feb 2014 16:50:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140301005047.GA14777@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <20140224172110.GO8264@linux.vnet.ibm.com>
 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
 <20140224185341.GU8264@linux.vnet.ibm.com>
 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
 <1393515453.28840.9961.camel@triegel.csb>
 <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
 <20140227190611.GU8264@linux.vnet.ibm.com>
 <CA+55aFzav_2ayvEgbgeAzQohJ7EQH0tgUU0WcSyvUA6hgOo_Ow@mail.gmail.com>
 <20140227205312.GX8264@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140227205312.GX8264@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030100-0928-0000-0000-000000125A3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:53:12PM -0800, Paul E. McKenney wrote:
> On Thu, Feb 27, 2014 at 11:47:08AM -0800, Linus Torvalds wrote:
> > On Thu, Feb 27, 2014 at 11:06 AM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > >
> > > 3.      The comparison was against another RCU-protected pointer,
> > >         where that other pointer was properly fetched using one
> > >         of the RCU primitives.  Here it doesn't matter which pointer
> > >         you use.  At least as long as the rcu_assign_pointer() for
> > >         that other pointer happened after the last update to the
> > >         pointed-to structure.
> > >
> > > I am a bit nervous about #3.  Any thoughts on it?
> > 
> > I think that it might be worth pointing out as an example, and saying
> > that code like
> > 
> >    p = atomic_read(consume);
> >    X;
> >    q = atomic_read(consume);
> >    Y;
> >    if (p == q)
> >         data = p->val;
> > 
> > then the access of "p->val" is constrained to be data-dependent on
> > *either* p or q, but you can't really tell which, since the compiler
> > can decide that the values are interchangeable.
> > 
> > I cannot for the life of me come up with a situation where this would
> > matter, though. If "X" contains a fence, then that fence will be a
> > stronger ordering than anything the consume through "p" would
> > guarantee anyway. And if "X" does *not* contain a fence, then the
> > atomic reads of p and q are unordered *anyway*, so then whether the
> > ordering to the access through "p" is through p or q is kind of
> > irrelevant. No?
> 
> I can make a contrived litmus test for it, but you are right, the only
> time you can see it happen is when X has no barriers, in which case
> you don't have any ordering anyway -- both the compiler and the CPU can
> reorder the loads into p and q, and the read from p->val can, as you say,
> come from either pointer.
> 
> For whatever it is worth, hear is the litmus test:
> 
> T1:	p = kmalloc(...);
> 	if (p == NULL)
> 		deal_with_it();
> 	p->a = 42;  /* Each field in its own cache line. */
> 	p->b = 43;
> 	p->c = 44;
> 	atomic_store_explicit(&gp1, p, memory_order_release);
> 	p->b = 143;
> 	p->c = 144;
> 	atomic_store_explicit(&gp2, p, memory_order_release);
> 
> T2:	p = atomic_load_explicit(&gp2, memory_order_consume);
> 	r1 = p->b;  /* Guaranteed to get 143. */
> 	q = atomic_load_explicit(&gp1, memory_order_consume);
> 	if (p == q) {
> 		/* The compiler decides that q->c is same as p->c. */
> 		r2 = p->c; /* Could get 44 on weakly order system. */
> 	}
> 
> The loads from gp1 and gp2 are, as you say, unordered, so you get what
> you get.
> 
> And publishing a structure via one RCU-protected pointer, updating it,
> then publishing it via another pointer seems to me to be asking for
> trouble anyway.  If you really want to do something like that and still
> see consistency across all the fields in the structure, please put a lock
> in the structure and use it to guard updates and accesses to those fields.

And here is a patch documenting the restrictions for the current Linux
kernel.  The rules change a bit due to rcu_dereference() acting a bit
differently than atomic_load_explicit(&p, memory_order_consume).

Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

documentation: Record rcu_dereference() value mishandling

Recent LKML discussings (see http://lwn.net/Articles/586838/ and
http://lwn.net/Articles/588300/ for the LWN writeups) brought out
some ways of misusing the return value from rcu_dereference() that
are not necessarily completely intuitive.  This commit therefore
documents what can and cannot safely be done with these values.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index fa57139f50bf..f773a264ae02 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -12,6 +12,8 @@ lockdep-splat.txt
 	- RCU Lockdep splats explained.
 NMI-RCU.txt
 	- Using RCU to Protect Dynamic NMI Handlers
+rcu_dereference.txt
+	- Proper care and feeding of return values from rcu_dereference()
 rcubarrier.txt
 	- RCU and Unloadable Modules
 rculist_nulls.txt
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 9d10d1db16a5..877947130ebe 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -114,12 +114,16 @@ over a rather long period of time, but improvements are always welcome!
 			http://www.openvms.compaq.com/wizard/wiz_2637.html
 
 		The rcu_dereference() primitive is also an excellent
-		documentation aid, letting the person reading the code
-		know exactly which pointers are protected by RCU.
+		documentation aid, letting the person reading the
+		code know exactly which pointers are protected by RCU.
 		Please note that compilers can also reorder code, and
 		they are becoming increasingly aggressive about doing
-		just that.  The rcu_dereference() primitive therefore
-		also prevents destructive compiler optimizations.
+		just that.  The rcu_dereference() primitive therefore also
+		prevents destructive compiler optimizations.  However,
+		with a bit of devious creativity, it is possible to
+		mishandle the return value from rcu_dereference().
+		Please see rcu_dereference.txt in this directory for
+		more information.
 
 		The rcu_dereference() primitive is used by the
 		various "_rcu()" list-traversal primitives, such
diff --git a/Documentation/RCU/rcu_dereference.txt b/Documentation/RCU/rcu_dereference.txt
new file mode 100644
index 000000000000..6e72cd8622df
--- /dev/null
+++ b/Documentation/RCU/rcu_dereference.txt
@@ -0,0 +1,365 @@
+PROPER CARE AND FEEDING OF RETURN VALUES FROM rcu_dereference()
+
+Most of the time, you can use values from rcu_dereference() or one of
+the similar primitives without worries.  Dereferencing (prefix "*"),
+field selection ("->"), assignment ("="), address-of ("&"), addition and
+subtraction of constants, and casts all work quite naturally and safely.
+
+It is nevertheless possible to get into trouble with other operations.
+Follow these rules to keep your RCU code working properly:
+
+o	You must use one of the rcu_dereference() family of primitives
+	to load an RCU-protected pointer, otherwise CONFIG_PROVE_RCU
+	will complain.  Worse yet, your code can see random memory-corruption
+	bugs due to games that compilers and DEC Alpha can play.
+	Without one of the rcu_dereference() primitives, compilers
+	can reload the value, and won't your code have fun with two
+	different values for a single pointer!  Without rcu_dereference(),
+	DEC Alpha can load a pointer, dereference that pointer, and
+	return data preceding initialization that preceded the store of
+	the pointer.
+
+	In addition, the volatile cast in rcu_dereference() prevents the
+	compiler from deducing the resulting pointer value.  Please see
+	the section entitled "EXAMPLE WHERE THE COMPILER KNOWS TOO MUCH"
+	for an example where the compiler can in fact deduce the exact
+	value of the pointer, and thus cause misordering.
+
+o	Do not use single-element RCU-protected arrays.  The compiler
+	is within its right to assume that the value of an index into
+	such an array must necessarily evaluate to zero.  The compiler
+	could then substitute the constant zero for the computation, so
+	that the array index no longer depended on the value returned
+	by rcu_dereference().  If the array index no longer depends
+	on rcu_dereference(), then both the compiler and the CPU
+	are within their rights to order the array access before the
+	rcu_dereference(), which can cause the array access to return
+	garbage.
+
+o	Avoid cancellation when using the "+" and "-" infix arithmetic
+	operators.  For example, for a given variable "x", avoid
+	"(x-x)".  There are similar arithmetic pitfalls from other
+	arithmetic operatiors, such as "(x*0)", "(x/(x+1))" or "(x%1)".
+	The compiler is within its rights to substitute zero for all of
+	these expressions, so that subsequent accesses no longer depend
+	on the rcu_dereference(), again possibly resulting in bugs due
+	to misordering.
+
+	Of course, if "p" is a pointer from rcu_dereference(), and "a"
+	and "b" are integers that happen to be equal, the expression
+	"p+a-b" is safe because its value still necessarily depends on
+	the rcu_dereference(), thus maintaining proper ordering.
+
+o	Avoid all-zero operands to the bitwise "&" operator, and
+	similarly avoid all-ones operands to the bitwise "|" operator.
+	If the compiler is able to deduce the value of such operands,
+	it is within its rights to substitute the corresponding constant
+	for the bitwise operation.  Once again, this causes subsequent
+	accesses to no longer depend on the rcu_dereference(), causing
+	bugs due to misordering.
+
+	Please note that single-bit operands to bitwise "&" can also
+	be dangerous.  At this point, the compiler knows that the
+	resulting value can only take on one of two possible values.
+	Therefore, a very small amount of additional information will
+	allow the compiler to deduce the exact value, which again can
+	result in misordering.
+
+o	If you are using RCU to protect JITed functions, so that the
+	"()" function-invocation operator is applied to a value obtained
+	(directly or indirectly) from rcu_dereference(), you may need to
+	interact directly with the hardware to flush instruction caches.
+	This issue arises on some systems when a newly JITed function is
+	using the same memory that was used by an earlier JITed function.
+
+o	Do not use the results from the boolean "&&" and "||" when
+	dereferencing.	For example, the following (rather improbable)
+	code is buggy:
+
+		int a[2];
+		int index;
+		int force_zero_index = 1;
+
+		...
+
+		r1 = rcu_dereference(i1)
+		r2 = a[r1 && force_zero_index];  /* BUGGY!!! */
+
+	The reason this is buggy is that "&&" and "||" are often compiled
+	using branches.  While weak-memory machines such as ARM or PowerPC
+	do order stores after such branches, they can speculate loads,
+	which can result in misordering bugs.
+
+o	Do not use the results from relational operators ("==", "!=",
+	">", ">=", "<", or "<=") when dereferencing.  For example,
+	the following (quite strange) code is buggy:
+
+		int a[2];
+		int index;
+		int flip_index = 0;
+
+		...
+
+		r1 = rcu_dereference(i1)
+		r2 = a[r1 != flip_index];  /* BUGGY!!! */
+
+	As before, the reason this is buggy is that relational operators
+	are often compiled using branches.  And as before, although
+	weak-memory machines such as ARM or PowerPC do order stores
+	after such branches, but can speculate loads, which can again
+	result in misordering bugs.
+
+o	Be very careful about comparing pointers obtained from
+	rcu_dereference() against non-NULL values.  As Linus Torvalds
+	explained, if the two pointers are equal, the compiler could
+	substitute the pointer you are comparing against for the pointer
+	obtained from rcu_dereference().  For example:
+
+		p = rcu_dereference(gp);
+		if (p == &default_struct)
+			do_default(p->a);
+
+	Because the compiler now knows that the value of "p" is exactly
+	the address of the variable "default_struct", it is free to
+	transform this code into the following:
+
+		p = rcu_dereference(gp);
+		if (p == &default_struct)
+			do_default(default_struct.a);
+
+	On ARM and Power hardware, the load from "default_struct.a"
+	can now be speculated, such that it might happen before the
+	rcu_dereference().  This could result in bugs due to misordering.
+
+	However, comparisons are OK in the following cases:
+
+	o	The comparison was against the NULL pointer.  If the
+		compiler knows that the pointer is NULL, you had better
+		not be dereferencing it anyway.  If the comparison is
+		non-equal, the compiler is none the wiser.  Therefore,
+		it is safe to compare pointers from rcu_dereference()
+		against NULL pointers.
+
+	o	The pointer is never dereferenced after being compared.
+		Since there are no subsequent dereferences, the compiler
+		cannot use anything it learned from the comparison
+		to reorder the non-existent subsequent dereferences.
+		This sort of comparison occurs frequently when scanning
+		RCU-protected circular linked lists.
+
+	o	The comparison is against a pointer pointer that
+		references memory that was initialized "a long time ago."
+		The reason this is safe is that even if misordering
+		occurs, the misordering will not affect the accesses
+		that follow the comparison.  So exactly how long ago is
+		"a long time ago"?  Here are some possibilities:
+
+		o	Compile time.
+
+		o	Boot time.
+
+		o	Module-init time for module code.
+
+		o	Prior to kthread creation for kthread code.
+
+		o	During some prior acquisition of the lock that
+			we now hold.
+
+		o	Before mod_timer() time for a timer handler.
+
+		There are many other possibilities involving the Linux
+		kernel's wide array of primitives that cause code to
+		be invoked at a later time.
+
+	o	The pointer being compared against also came from
+		rcu_dereference().  In this case, both pointers depend
+		on one rcu_dereference() or another, so you get proper
+		ordering either way.
+
+		That said, this situation can make certain RCU usage
+		bugs more likely to happen.  Which can be a good thing,
+		at least if they happen during testing.  An example
+		of such an RCU usage bug is shown in the section titled
+		"EXAMPLE OF AMPLIFIED RCU-USAGE BUG".
+
+	o	All of the accesses following the comparison are stores,
+		so that a control dependency preserves the needed ordering.
+		That said, it is easy to get control dependencies wrong.
+		Please see the "CONTROL DEPENDENCIES" section of
+		Documentation/memory-barriers.txt for more details.
+
+	o	The pointers compared not-equal -and- the compiler does
+		not have enough information to deduce the value of the
+		pointer.  Note that the volatile cast in rcu_dereference()
+		will normally prevent the compiler from knowing too much.
+
+o	Disable any value-speculation optimizations that your compiler
+	might provide, especially if you are making use of feedback-based
+	optimizations that take data collected from prior runs.  Such
+	value-speculation optimizations reorder operations by design.
+
+	There is one exception to this rule:  Value-speculation
+	optimizations that leverage the branch-prediction hardware are
+	safe on strongly ordered systems (such as x86), but not on weakly
+	ordered systems (such as ARM or Power).  Choose your compiler
+	command-line options wisely!
+
+
+EXAMPLE OF AMPLIFIED RCU-USAGE BUG
+
+Because updaters can run concurrently with RCU readers, RCU readers can
+see stale and/or inconsistent values.  If RCU readers need fresh or
+consistent values, which they sometimes do, they need to take proper
+precautions.  To see this, consider the following code fragment:
+
+	struct foo {
+		int a;
+		int b;
+		int c;
+	};
+	struct foo *gp1;
+	struct foo *gp2;
+
+	void updater(void)
+	{
+		struct foo *p;
+
+		p = kmalloc(...);
+		if (p == NULL)
+			deal_with_it();
+		p->a = 42;  /* Each field in its own cache line. */
+		p->b = 43;
+		p->c = 44;
+		rcu_assign_pointer(gp1, p);
+		p->b = 143;
+		p->c = 144;
+		rcu_assign_pointer(gp2, p);
+	}
+
+	void reader(void)
+	{
+		struct foo *p;
+		struct foo *q;
+		int r1, r2;
+
+		p = rcu_dereference(gp2);
+		r1 = p->b;  /* Guaranteed to get 143. */
+		q = rcu_dereference(gp1);
+		if (p == q) {
+			/* The compiler decides that q->c is same as p->c. */
+			r2 = p->c; /* Could get 44 on weakly order system. */
+		}
+	}
+
+You might be surprised that the outcome (r1 == 143 && r2 == 44) is possible,
+but you should not be.  After all, the updater might have been invoked
+a second time between the time reader() loaded into "r1" and the time
+that it loaded into "r2".  The fact that this same result can occur due
+to some reordering from the compiler and CPUs is beside the point.
+
+But suppose that the reader needs a consistent view?
+
+Then one approach is to use locking, for example, as follows:
+
+	struct foo {
+		int a;
+		int b;
+		int c;
+		spinlock_t lock;
+	};
+	struct foo *gp1;
+	struct foo *gp2;
+
+	void updater(void)
+	{
+		struct foo *p;
+
+		p = kmalloc(...);
+		if (p == NULL)
+			deal_with_it();
+		spin_lock(&p->lock);
+		p->a = 42;  /* Each field in its own cache line. */
+		p->b = 43;
+		p->c = 44;
+		spin_unlock(&p->lock);
+		rcu_assign_pointer(gp1, p);
+		spin_lock(&p->lock);
+		p->b = 143;
+		p->c = 144;
+		spin_unlock(&p->lock);
+		rcu_assign_pointer(gp2, p);
+	}
+
+	void reader(void)
+	{
+		struct foo *p;
+		struct foo *q;
+		int r1, r2;
+
+		p = rcu_dereference(gp2);
+		spin_lock(&p->lock);
+		r1 = p->b;  /* Guaranteed to get 143. */
+		q = rcu_dereference(gp1);
+		if (p == q) {
+			/* The compiler decides that q->c is same as p->c. */
+			r2 = p->c; /* Could get 44 on weakly order system. */
+		}
+		spin_unlock(&p->lock);
+	}
+
+As always, use the right tool for the job!
+
+
+EXAMPLE WHERE THE COMPILER KNOWS TOO MUCH
+
+If a pointer obtained from rcu_dereference() compares not-equal to some
+other pointer, the compiler normally has no clue what the value of the
+first pointer might be.  This lack of knowledge prevents the compiler
+from carrying out optimizations that otherwise might destroy the ordering
+guarantees that RCU depends on.  And the volatile cast in rcu_dereference()
+should prevent the compiler from guessing the value.
+
+But without rcu_dereference(), the compiler knows more than you might
+expect.  Consider the following code fragment:
+
+	struct foo {
+		int a;
+		int b;
+	};
+	static struct foo variable1;
+	static struct foo variable2;
+	static struct foo *gp = &variable1;
+
+	void updater(void)
+	{
+		initialize_foo(&variable2);
+		rcu_assign_pointer(gp, &variable2);
+		/*
+		 * The above is the only store to gp in this translation unit,
+		 * and the address of gp is not exported in any way.
+		 */
+	}
+
+	int reader(void)
+	{
+		struct foo *p;
+
+		p = gp;
+		barrier();
+		if (p == &variable1)
+			return p->a; /* Must be variable1.a. */
+		else
+			return p->b; /* Must be variable2.b. */
+	}
+
+Because the compiler can see all stores to "gp", it knows that the only
+possible values of "gp" are "variable1" on the one hand and "variable2"
+on the other.  The comparison in reader() therefore tells the compiler
+the exact value of "p" even in the not-equals case.  This allows the
+compiler to make the return values independent of the load from "gp",
+in turn destroying the ordering between this load and the loads of the
+return values.  This can result in "p->b" returning pre-initialization
+garbage values.
+
+In short, rcu_dereference() is -not- optional when you are going to
+dereference the resulting pointer.

