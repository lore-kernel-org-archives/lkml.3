Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbaB0Pjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:39:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaB0PjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:39:11 -0500
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
In-Reply-To: <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
References: <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com>
	 <1393095223.28840.4914.camel@triegel.csb>
	 <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
	 <20140223003933.GQ4250@linux.vnet.ibm.com>
	 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
	 <20140223063426.GT4250@linux.vnet.ibm.com>
	 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
	 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
	 <20140224172110.GO8264@linux.vnet.ibm.com>
	 <CA+55aFyi45f7oaG4MYP41TOc=E8Ze8Om88dV2Lq4F=qebhxt4A@mail.gmail.com>
	 <20140224185341.GU8264@linux.vnet.ibm.com>
	 <CA+55aFzXyob0aKnv1u7Stbu0rH5Aq2jaA1rHb=TvQe9c1KY0oQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Feb 2014 16:37:33 +0100
Message-ID: <1393515453.28840.9961.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-24 at 11:54 -0800, Linus Torvalds wrote:
> On Mon, Feb 24, 2014 at 10:53 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Good points.  How about the following replacements?
> >
> > 3.      Adding or subtracting an integer to/from a chained pointer
> >         results in another chained pointer in that same pointer chain.
> >         The results of addition and subtraction operations that cancel
> >         the chained pointer's value (for example, "p-(long)p" where "p"
> >         is a pointer to char) are implementation defined.
> >
> > 4.      Bitwise operators ("&", "|", "^", and I suppose also "~")
> >         applied to a chained pointer and an integer for the purposes
> >         of alignment and pointer translation results in another
> >         chained pointer in that same pointer chain.  Other uses
> >         of bitwise operators on chained pointers (for example,
> >         "p|~0") are implementation defined.
> 
> Quite frankly, I think all of this language that is about the actual
> operations is irrelevant and wrong.
> 
> It's not going to help compiler writers, and it sure isn't going to
> help users that read this.
> 
> Why not just talk about "value chains" and that any operations that
> restrict the value range severely end up breaking the chain. There is
> no point in listing the operations individually, because every single
> operation *can* restrict things. Listing individual operations and
> depdendencies is just fundamentally wrong.

[...]

> The *only* thing that matters for all of them is whether they are
> "value-preserving", or whether they drop so much information that the
> compiler might decide to use a control dependency instead. That's true
> for every single one of them.
> 
> Similarly, actual true control dependencies that limit the problem
> space sufficiently that the actual pointer value no longer has
> significant information in it (see the above example) are also things
> that remove information to the point that only a control dependency
> remains. Even when the value itself is not modified in any way at all.

I agree that just considering syntactic properties of the program seems
to be insufficient.  Making it instead depend on whether there is a
"semantic" dependency due to a value being "necessary" to compute a
result seems better.  However, whether a value is "necessary" might not
be obvious, and I understand Paul's argument that he does not want to
have to reason about all potential compiler optimizations.  Thus, I
believe we need to specify when a value is "necessary".

I have a suggestion for a somewhat different formulation of the feature
that you seem to have in mind, which I'll discuss below.  Excuse the
verbosity of the following, but I'd rather like to avoid
misunderstandings than save a few words.


What we'd like to capture is that a value originating from a mo_consume
load is "necessary" for a computation (e.g., it "cannot" be replaced
with value predictions and/or control dependencies); if that's the case
in the program, we can reasonably assume that a compiler implementation
will transform this into a data dependency, which will then lead to
ordering guarantees by the HW.

However, we need to specify when a value is "necessary".  We could say
that this is implementation-defined, and use a set of litmus tests
(e.g., like those discussed in the thread) to roughly carve out what a
programmer could expect.  This may even be practical for a project like
the Linux kernel that follows strict project-internal rules and pays a
lot of attention to what the particular implementations of compilers
expected to compile the kernel are doing.  However, I think this
approach would be too vague for the standard and for many other
programs/projects.


One way to understand "necessary" would be to say that if a mo_consume
load can result in more than V different values, then the actual value
is "unknown", and thus "necessary" to compute anything based on it.
(But this is flawed, as discussed below.)

However, how big should V be?  If it's larger than 1, atomic bool cannot
be used with mo_consume, which seems weird.
If V is 1, then Linus' litmus tests work (but Paul's doesn't; see
below), but the compiler must not try to predict more than one value.
This holds for any choice of V, so there always is an *additional*
constraint on code generation for operations that are meant to take part
in such "value dependencies".  The bigger V might be, the less likely it
should be for this to actually constrain a particular compiler's
optimizations (e.g., while it might be meaningful to use value
prediction for two or three values, it's probably not for 1000s).
Nonetheless, if we don't want to predict the future, we need to specify
V.  Given that we always have some constraint for code generation
anyway, and given that V > 1 might be an arbitrary-looking constraint
and disallows use on atomic bool, I believe V should be 1.

Furthermore, there is a problem in saying "a load can result in more
than one value" because in a deterministic program/operation, it will
result in exactly one value.  Paul's (counter-)litmus test is a similar
example: the compiler saw all stores to a particular variable, so it was
able to show that a particular pointer variable actually just has two
possible values (ie, it's like a bool).
How do we avoid this problem?  And do we actually want to require
programmers to reason about this at all (ie, issues like Paul's
example)?  The only solution that I currently see is to specify the
allowed scope of the knowledge about the values a load can result in.

Based on these thoughts, we could specify the new mo_consume guarantees
roughly as follows:

        An evaluation E (in an execution) has a value dependency to an
        atomic and mo_consume load L (in an execution) iff:
        * L's type holds more than one value (ruling out constants
        etc.),
        * L is sequenced-before E,
        * L's result is used by the abstract machine to compute E,
        * E is value-dependency-preserving code (defined below), and
        * at the time of execution of E, L can possibly have returned at
        least two different values under the assumption that L itself
        could have returned any value allowed by L's type.
        
        If a memory access A's targeted memory location has a value
        dependency on a mo_consume load L, and an action X
        inter-thread-happens-before L, then X happens-before A.

While this attempt at a definition certainly needs work, I hope that at
least the first 3 requirements for value dependencies are clear.

The fifth requirement tries to capture both Linus' "value chains"
concept as well as the point that we need to specify the scope of
knowledge about values.
Regarding the latter, we make a fresh start at each mo_consume load (ie,
we assume we know nothing -- L could have returned any possible value);
I believe this is easier to reason about than other scopes like function
granularities (what happens on inlining?), or translation units.  It
should also be simple to implement for compilers, and would hopefully
not constrain optimization too much.
The rest of the requirement then forbids "breaking value chains". For
example (for now, let's ignore the fourth requirement in the examples):

  int *p = atomic_load(&pp, mo_consume);
  if (p == &myvariable)
    q = *p;  // (1)

When (1) is executed, the load can only have returned the value
&myvariable (otherwise, the branch wouldn't be executed), so this
evaluation of p is not value-dependent on the mo_consume load anymore.

OTOH, the following does work (ie, uses a value dependency for
ordering), because int* can have more than two values:

  int *p = atomic_load(&pp, mo_consume);
  if (p != &myvariable)
    q = *p;  // (1)

But it would not work using bool:

  bool b = atomic_load(&foo, mo_consume);
  if (b != false)
    q = arr[b];  // only one value ("true") is left for b

Paul's litmus test would work, because we guarantee to the programmer
that it can assume that the mo_consume load would return any value
allowed by the type; effectively, this forbids the compiler analysis
Paul thought about:

        static struct foo variable1;
        static struct foo variable2;
        static struct foo *pp = &variable1;

T1:     initialize_foo(&variable2);
        atomic_store_explicit(&pp, &variable2, memory_order_release);
        /* The above is the only store to pp in this translation unit,
         * and the address of pp is not exported in any way.
         */

T2:     int *p = atomic_load(&pp, mo_consume);
        if (p == &variable1)
                return p->val1; /* Must be variable1.val1.
                                   No value dependency. */
        else
                return p->val2; /* Will read variable2.val2, but value
                                   dependency is guaranteed. */


The fourth requirement (value-dependency-preserving code) might look as
if I'm re-introducing the problematic carries-a-dependency again, but
that's *not* the case.  We do need to demarcate
value-dependency-carrying code from other code so that the compiler
knows when it can do value prediction and similar transformations (see
above).  However, note that this fourth requirement is necessary but not
sufficient for a value dependency -- the fifth requirement (ie, that
there must be a "value chain") always has the last word, so to speak.
IOW, this does not try to define dependencies based on syntax.

I suggest to use data types to demarcate code that is actually meant to
preserve value dependencies.  The current standard tries to do it on the
granularity of functions (ie, using [[carries_dependency]]), and I
believe we agree that this isn't great.  For example, it's too
constraining for large functions, it requires annotations, calls from
non-annotated to annotated functions might result in further barriers,
function-pointers are problematic (can't put [[carries_dependency]] on a
function pointer type?), etc.

What I have in mind is roughly the following (totally made-up syntax --
suggestions for how to do this properly are very welcome):
* Have a type modifier (eg, like restrict), that specifies that
operations on data of this type are preserving value dependencies:
  int value_dep_preserving *foo;
  bool value_dep_preserving bar;
* mo_consume loads return value_dep_preserving types.
* One can cast from value_dep_preserving to the normal type, but not
vice-versa.
* Operations that take a value_dep_preserving-typed operand will usually
produce a value_dep_preserving type.  One can argue whether "?:" should
be an exception to this, at least if only the left/first operand is
value_dep_preserving.  Unlike in the current standard, this is *not*
critical here because in the end, it's all down to the fifth requirement
(see above).

This has a couple of drawbacks:
* The programmer needs to use the types.
* It extends the type system (but [[carries_dependency]] effectively
extends the type system as well, depending on how it's implemented).

This has a few advantages over function-granularity or just hoping that
the compiler gets it right by automatic analysis:
* The programmer can use it exactly for the variables that it needs
value-dep-preservation for.  This won't slow down other code.
* If an mo_consume load's result is used directly (or in C++ with auto),
no special type annotations / extra code are required.
* The compiler knows exactly which code has constraints on code
generation (e.g., no value prediction), due to the types.  No points-to
analysis necessary.
* Programmers could even use special macros that only load from
value_dep_preserving-typed addresses (based on type checks); this would
obviously not catch all errors, but many.  For example:
  int *foo, *bar;
  int value_dep_preserving *p = atomic_load(&pp, mo_consume);
  x = VALUE_DEF_DEREF(p != NULL ? &foo : &bar);  // Error!
  if (p == &myvariable)
    q = VALUE_DEP_DEREF(p);  // Wouldn't be guaranteed to be caught, but
                             // compiler might be able to emit warning.
* In C++, we might be able to provide this with just a special template:
std::value_dep_preserving<int *> p;
Suitably defined operators for this template should be able to take care
of the rest, and the implementation might use implementation-defined
mechanisms internally to constrain code generation.


What do you think?

Is this meaningful regarding what current hardware offers, or will it do
(or might do in the future) value prediction on it's own?

