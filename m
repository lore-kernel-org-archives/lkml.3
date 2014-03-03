Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaCCPgy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 10:36:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbaCCPgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 10:36:49 -0500
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
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>,
        Peter Sewell <Peter.Sewell@cl.cam.ac.uk>
In-Reply-To: <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
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
	 <1393515453.28840.9961.camel@triegel.csb>
	 <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Mar 2014 16:36:01 +0100
Message-ID: <1393860961.28840.11426.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 09:01 -0800, Linus Torvalds wrote:
> On Thu, Feb 27, 2014 at 7:37 AM, Torvald Riegel <triegel@redhat.com> wrote:
> > Regarding the latter, we make a fresh start at each mo_consume load (ie,
> > we assume we know nothing -- L could have returned any possible value);
> > I believe this is easier to reason about than other scopes like function
> > granularities (what happens on inlining?), or translation units.  It
> > should also be simple to implement for compilers, and would hopefully
> > not constrain optimization too much.
> >
> > [...]
> >
> > Paul's litmus test would work, because we guarantee to the programmer
> > that it can assume that the mo_consume load would return any value
> > allowed by the type; effectively, this forbids the compiler analysis
> > Paul thought about:
> 
> So realistically, since with the new wording we can ignore the silly
> cases (ie "p-p") and we can ignore the trivial-to-optimize compiler
> cases ("if (p == &variable) .. use p"), and you would forbid the
> "global value range optimization case" that Paul bright up, what
> remains would seem to be just really subtle compiler transformations
> of data dependencies to control dependencies.
> 
> And the only such thing I can think of is basically compiler-initiated
> value-prediction, presumably directed by PGO (since now if the value
> prediction is in the source code, it's considered to break the value
> chain).

The other example that comes to mind would be feedback-directed JIT
compilation.  I don't think that's widely used today, and it might never
be for the kernel -- but *in the standard*, we at least have to consider
what the future might bring.

> The good thing is that afaik, value-prediction is largely not used in
> real life, afaik. There are lots of papers on it, but I don't think
> anybody actually does it (although I can easily see some
> specint-specific optimization pattern that is build up around it).
> 
> And even value prediction is actually fine, as long as the compiler
> can see the memory *source* of the value prediction (and it isn't a
> mo_consume). So it really ends up limiting your value prediction in
> very simple ways: you cannot do it to function arguments if they are
> registers. But you can still do value prediction on values you loaded
> from memory, if you can actually *see* that memory op.

I think one would need to show that the source is *not even indirectly*
a mo_consume load.  With the wording I proposed, value dependencies
don't break when storing to / loading from memory locations.

Thus, if a compiler ends up at a memory load after waling SSA, it needs
to prove that the load cannot read a value that (1) was produced by a
store sequenced-before the load and (2) might carry a value dependency
(e.g., by being a mo_consume load) that the value prediction in question
would break.  This, in general, requires alias analysis.
Deciding whether a prediction would break a value dependency has to
consider what later stages in a compiler would be doing, including LTO
or further rounds of inlining/optimizations.  OTOH, if the compiler can
treat an mo_consume load as returning all possible values (eg, by
ignoring all knowledge about it), then it can certainly do so with other
memory loads too.

So, I think that the constraints due to value dependencies can matter in
practice.  However, the impact on optimizations on
non-mo_consume-related code are hard to estimate -- I don't see a huge
amount of impact right now, but I also wouldn't want to predict that
this can't change in the future.

> Of course, on more strongly ordered CPU's, even that "register
> argument" limitation goes away.
> 
> So I agree that there is basically no real optimization constraint.
> Value-prediction is of dubious value to begin with, and the actual
> constraint on its use if some compiler writer really wants to is not
> onerous.
> 
> > What I have in mind is roughly the following (totally made-up syntax --
> > suggestions for how to do this properly are very welcome):
> > * Have a type modifier (eg, like restrict), that specifies that
> > operations on data of this type are preserving value dependencies:
> 
> So I'm not violently opposed, but I think the upsides are not great.
> Note that my earlier suggestion to use "restrict" wasn't because I
> believed the annotation itself would be visible, but basically just as
> a legalistic promise to the compiler that *if* it found an alias, then
> it didn't need to worry about ordering. So to me, that type modifier
> was about conceptual guarantees, not about actual value chains.
> 
> Anyway, the reason I don't believe any type modifier (and
> "[[carries_dependency]]" is basically just that) is worth it is simply
> that it adds a real burden on the programmer, without actually giving
> the programmer any real upside:
> 
> Within a single function, the compiler already sees that mo_consume
> source, and so doing a type-based restriction doesn't really help. The
> information is already there, without any burden on the programmer.

I think it's not just a question of whether we're talking a single
function or across functions, but to which extent other code can detect
whether it might have to consider value dependencies.  The store/load
case above is an example that complicates the detection for a compiler.

In cases in which the mo_consume load is used directly, we don't need to
use any annotations on the type:
  int val = atomic_load_explicit(ptr, mo_consume)->value;

However, if we need to use the load's result more than once (which I
think will happen often), then we do need the type annotation:
  s value_dep_preserving *ptr = atomic_load_explicit(ptr, mo_consume);
  if (ptr != 0)
    int val = ptr->value;

If we want to avoid the annotation in this case, and still want to avoid
the store/load vs. alias analysis problem mentioned above, we'd need to
require that ptr isn't a variable that's visible to other code not
related to this mo_consume load.  But I believe that such a requirement
would be awkward, and also hard to specify.

I hope that Paul's look at rcu_derefence() usage could provide some
indication of how much annotation overhead there actually would be for a
programmer.

> 
> And across functions, the compiler has already - by definition -
> mostly lost sight of all the things it could use to reduce the value
> space.

I don't think that I agree here.  

Assume we have two separate functions bar and foo, and one temporary
variable t of a type int012 that holds values 0,1,2 (excuse the somewhat
artificial example):

int012 t;
int arr[20];

int bar(int a)
{
  bar_stuff(a);  // compiler knows this is noop with arguments 0 or 1
                 // and this will *never* touch t nor arr
  return a;
}

int foo(int a)
{
  foo_stuff(a); // compiler knows this is noop with arguments 1 or 2
                // and this will *never* touch t nor arr
  return a;
}

void main() {
  t = atomic_load_explicit(&source, mo_consume);
  x = arr[bar(foo(t))];  // value-dependent?
}

If a compiler looks at foo() and bar() separately, I think it might want
to optimize bar() to the following:

int bar_opt(int a)
{
  if (a != 2) return a;
  bar_stuff(a);
  return a;
}

int foo_opt(int a)
{
  if (a != 0) return a;
  foo_stuff(a);
  return a;
}

I think that those could be valuable optimizations for general-purpose
code.

What happens if the compiler does LTO afterwards and combines the foo
and bar calls?:

int bar_opt_foo_opt(int a)
{
  if (a == 1) return a;
  if (a == 0) foo_stuff(a);
  else bar_stuff(a);
  return a;
}

This still looks like a good thing to do for general-purpose code, and
it doesn't do any value prediction.

If we inline this into main, it becomes kind of difficult for the
compiler because it cannot just weave in bar_opt_foo_opt, or it might
get:

  t = atomic_load_explicit(&source, mo_consume);
  if (t == 1) goto next;
  if (t == 0) foo_stuff(t);
  else bar_stuff(t);
access:
  x = arr[t];  // value-dependent?

Would this be still value-dependent for the hardware, or would the
branch prediction interfere?

Even if this would still be okay from the hardware POV, other compiler
transformations now need to pay attention to where the value comes from.
In particular, we can't specialize this into the following (which
doesn't predict any values):

  t = atomic_load_explicit(&source, mo_consume);
  if (t == 1) x = arr[1];
  else {
    if (t == 0) foo_stuff(t);
    else bar_stuff(t);
    x = arr[t];
  }

We could argue that this wouldn't be allowed because t is coming from an
mo_consume load, but then we also need to say that this can in fact
affect compiler transformations other than just value prediction.

At least in this example, introducing the value_dep_preserving type
modifier would have made this easier because it would have allowed the
compiler to avoid the initial value prediction.

However, I think that we might get a few interesting issues even with
value_dep_preserving, so this needs further investigation.  Nonetheless,
my gut feeling is that having value_dep_preserving makes this all a lot
easier because if unsure, the compiler can just use a bigger hammer for
value_dep_preserving without having to worry about preventing
optimizations on unrelated code.

> Even Paul's example doesn't really work if the use of the
> "mo_consume" value has been passed to another function, because inside
> a separate function, the compiler couldn't see that the value it uses
> comes from only two possible values.
> 
> And as mentioned, even *if* the compiler wants to do value prediction
> that turns a data dependency into a control dependency, the limitation
> to say "no, you can't do it unless you saw where the value got loaded"
> really isn't that onerous.
> 
> I bet that if you ask actual production compiler people (as opposed to
> perhaps academia), none of them actually really believe in value
> prediction to begin with.

What about keeping whether we really need value_dep_preserving as an
open question for now, and try to get more feeback by compiler
implementers on what the consequences of not having it would be?  This
should help us assess the current implementation perspective.  We would
still need to extrapolate what future compilers might want to do,
though; thus, deciding to not use it will remain somewhat risky for
future optimizations.


