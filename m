Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaB0RBq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 12:01:46 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:49785 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaB0RBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 12:01:42 -0500
MIME-Version: 1.0
In-Reply-To: <1393515453.28840.9961.camel@triegel.csb>
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
Date: Thu, 27 Feb 2014 09:01:40 -0800
X-Google-Sender-Auth: k4_L7I0TC5Nv1c9OramJOnNp-Vk
Message-ID: <CA+55aFyE58NokYdoU+-feHTXv+5snByu+vCyMtg2fNc7npMbDg@mail.gmail.com>
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

On Thu, Feb 27, 2014 at 7:37 AM, Torvald Riegel <triegel@redhat.com> wrote:
>
> I agree that just considering syntactic properties of the program seems
> to be insufficient.  Making it instead depend on whether there is a
> "semantic" dependency due to a value being "necessary" to compute a
> result seems better.  However, whether a value is "necessary" might not
> be obvious, and I understand Paul's argument that he does not want to
> have to reason about all potential compiler optimizations.  Thus, I
> believe we need to specify when a value is "necessary".

I suspect it's hard to really strictly define, but at the same time I
actually think that compiler writers (and users, for that matter) have
little problem understanding the concept and intent.

I do think that listing operations might be useful to give good
examples of what is a "necessary" value, and - perhaps more
importantly - what can break the value from being "necessary".
Especially the gotchas.

> I have a suggestion for a somewhat different formulation of the feature
> that you seem to have in mind, which I'll discuss below.  Excuse the
> verbosity of the following, but I'd rather like to avoid
> misunderstandings than save a few words.

Ok, I'm going to cut most of the verbiage since it's long and I'm not
commenting on most of it.

But

> Based on these thoughts, we could specify the new mo_consume guarantees
> roughly as follows:
>
>         An evaluation E (in an execution) has a value dependency to an
>         atomic and mo_consume load L (in an execution) iff:
>         * L's type holds more than one value (ruling out constants
>         etc.),
>         * L is sequenced-before E,
>         * L's result is used by the abstract machine to compute E,
>         * E is value-dependency-preserving code (defined below), and
>         * at the time of execution of E, L can possibly have returned at
>         least two different values under the assumption that L itself
>         could have returned any value allowed by L's type.
>
>         If a memory access A's targeted memory location has a value
>         dependency on a mo_consume load L, and an action X
>         inter-thread-happens-before L, then X happens-before A.

I think this mostly works.

> Regarding the latter, we make a fresh start at each mo_consume load (ie,
> we assume we know nothing -- L could have returned any possible value);
> I believe this is easier to reason about than other scopes like function
> granularities (what happens on inlining?), or translation units.  It
> should also be simple to implement for compilers, and would hopefully
> not constrain optimization too much.
>
> [...]
>
> Paul's litmus test would work, because we guarantee to the programmer
> that it can assume that the mo_consume load would return any value
> allowed by the type; effectively, this forbids the compiler analysis
> Paul thought about:

So realistically, since with the new wording we can ignore the silly
cases (ie "p-p") and we can ignore the trivial-to-optimize compiler
cases ("if (p == &variable) .. use p"), and you would forbid the
"global value range optimization case" that Paul bright up, what
remains would seem to be just really subtle compiler transformations
of data dependencies to control dependencies.

And the only such thing I can think of is basically compiler-initiated
value-prediction, presumably directed by PGO (since now if the value
prediction is in the source code, it's considered to break the value
chain).

The good thing is that afaik, value-prediction is largely not used in
real life, afaik. There are lots of papers on it, but I don't think
anybody actually does it (although I can easily see some
specint-specific optimization pattern that is build up around it).

And even value prediction is actually fine, as long as the compiler
can see the memory *source* of the value prediction (and it isn't a
mo_consume). So it really ends up limiting your value prediction in
very simple ways: you cannot do it to function arguments if they are
registers. But you can still do value prediction on values you loaded
from memory, if you can actually *see* that memory op.

Of course, on more strongly ordered CPU's, even that "register
argument" limitation goes away.

So I agree that there is basically no real optimization constraint.
Value-prediction is of dubious value to begin with, and the actual
constraint on its use if some compiler writer really wants to is not
onerous.

> What I have in mind is roughly the following (totally made-up syntax --
> suggestions for how to do this properly are very welcome):
> * Have a type modifier (eg, like restrict), that specifies that
> operations on data of this type are preserving value dependencies:

So I'm not violently opposed, but I think the upsides are not great.
Note that my earlier suggestion to use "restrict" wasn't because I
believed the annotation itself would be visible, but basically just as
a legalistic promise to the compiler that *if* it found an alias, then
it didn't need to worry about ordering. So to me, that type modifier
was about conceptual guarantees, not about actual value chains.

Anyway, the reason I don't believe any type modifier (and
"[[carries_dependency]]" is basically just that) is worth it is simply
that it adds a real burden on the programmer, without actually giving
the programmer any real upside:

Within a single function, the compiler already sees that mo_consume
source, and so doing a type-based restriction doesn't really help. The
information is already there, without any burden on the programmer.

And across functions, the compiler has already - by definition -
mostly lost sight of all the things it could use to reduce the value
space. Even Paul's example doesn't really work if the use of the
"mo_consume" value has been passed to another function, because inside
a separate function, the compiler couldn't see that the value it uses
comes from only two possible values.

And as mentioned, even *if* the compiler wants to do value prediction
that turns a data dependency into a control dependency, the limitation
to say "no, you can't do it unless you saw where the value got loaded"
really isn't that onerous.

I bet that if you ask actual production compiler people (as opposed to
perhaps academia), none of them actually really believe in value
prediction to begin with.

> What do you think?
>
> Is this meaningful regarding what current hardware offers, or will it do
> (or might do in the future) value prediction on it's own?

I can pretty much guarantee that when/if hardware does value
prediction on its own, it will do so without exposing it as breaking
the data dependency.

The thing is, a CPU is actually *much* better situated at doing
speculative memory accesses, because a CPU already has all the
infrastructure to do speculation in general.

And for a CPU, once you do value speculation, guaranteeing the memory
ordering is *trivial*: all you need to do is to track the "speculated"
memory instruction until you check the value (which you obviously have
to do anyway, otherwise you're not doing value _prediction_, you're
just doing "value wild guessing" ;^), and when you check the value you
also check that the cacheline hasn't been evicted out-of-order.

This is all stuff that CPU people already do. If you have
transactional memory, you already have all the resources to do this.
Or, even without transactional memory, if like Intel you have a memory
model that says "loads are done in order" but you actually wildly
speculate loads and just check before retiring instructions that the
cachelines didn't get evicted out of order, you already have all the
hardware to do value prediction *without* making it visible in the
memory order.

This, btw, is one reason why people who think that compilers should be
overly smart and do fancy tricks are incompetent. People who thought
that Itanium was a great idea ("Let's put the complexity in the
compiler, and make a simple CPU") are simply objectively *wrong*.
People who think that value prediction by a compiler is a good idea
are not people you should really care about.

                         Linus
