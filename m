Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaBUTNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 14:13:25 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51072 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaBUTNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 14:13:23 -0500
Date: Fri, 21 Feb 2014 11:13:18 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Matz <matz@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
Message-ID: <20140221191318.GK4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
 <20140220083032.GN4250@linux.vnet.ibm.com>
 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
 <20140220181116.GT4250@linux.vnet.ibm.com>
 <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com>
 <20140220185608.GX4250@linux.vnet.ibm.com>
 <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com>
 <20140220221027.GC4250@linux.vnet.ibm.com>
 <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
 <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022119-9332-0000-0000-0000033028E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 07:35:37PM +0100, Michael Matz wrote:
> Hi,
> 
> On Thu, 20 Feb 2014, Linus Torvalds wrote:
> 
> > But I'm pretty sure that any compiler guy must *hate* that current odd
> > dependency-generation part, and if I was a gcc person, seeing that
> > bugzilla entry Torvald pointed at, I would personally want to
> > dismember somebody with a rusty spoon..
> 
> Yes.  Defining dependency chains in the way the standard currently seems 
> to do must come from people not writing compilers.  There's simply no 
> sensible way to implement it without being really conservative, because 
> the depchains can contain arbitrary constructs including stores, 
> loads and function calls but must still be observed.  
> 
> And with conservative I mean "everything is a source of a dependency, and 
> hence can't be removed, reordered or otherwise fiddled with", and that 
> includes code sequences where no atomic objects are anywhere in sight [1].
> In the light of that the only realistic way (meaning to not have to 
> disable optimization everywhere) to implement consume as currently 
> specified is to map it to acquire.  At which point it becomes pointless.

No, only memory_order_consume loads and [[carries_dependency]]
function arguments are sources of dependency chains.

> > So I suspect there are a number of people who would be *more* than
> > happy with a change to those odd dependency rules.
> 
> I can't say much about your actual discussion related to semantics of 
> atomics, not my turf.  But the "carries a dependency" relation is not 
> usefully implementable.
> 
> 
> Ciao,
> Michael.
> [1] Simple example of what type of transformations would be disallowed:
> 
> int getzero (int i) { return i - i; }

This needs to be as follows:

[[carries_dependency]] int getzero(int i [[carries_dependency]])
{
	return i - i;
}

Otherwise dependencies won't get carried through it.

> Should be optimizable to "return 0;", right?  Not with carries a 
> dependency in place:
> 
> int jeez (int idx) {
>   int i = atomic_load(idx, memory_order_consume); // A
>   int j = getzero (i);                            // B
>   return array[j];                                // C
> }
> 
> As I read "carries a dependency" there's a dependency from A to C. 
> Now suppose we would optimize getzero in the obvious way, then inline, and 
> boom, dependency gone.  So we wouldn't be able to optimize any function 
> when we don't control all its users, for fear that it _might_ be used in 
> some dependency chain where it then matters that we possibly removed some 
> chain elements due to the transformation.  We would have to retain 'i-i' 
> before inlining, and if the function then is inlined into a context where 
> depchains don't matter, could _then_ optmize it to zero.  But that's 
> insane, especially considering that it's hard to detect if a given context 
> doesn't care for depchains, after all the depchain relation is constructed 
> exactly so that it bleeds into nearly everywhere.  So we would most of 
> the time have to assume that the ultimate context will be depchain-aware 
> and therefore disable many transformations.

Any function that does not contain a memory_order_consume load and that
doesn't have any arguments marked [[carries_dependency]] can be optimized
just as before.

> There'd be one solution to the above, we would have to invent some special 
> operands and markers that explicitely model "carries-a-dep", ala this:
> 
> int getzero (int i) {
>   #RETURN.dep = i.dep
>   return 0;
> }

The above is already handled by the [[carries_dependency]] attribute,
see above.

> int jeez (int idx) {
>   # i.dep = idx.dep
>   int i = atomic_load(idx, memory_order_consume); // A
>   # j.dep = i.dep
>   int j = getzero (i);                            // B
>   # RETURN.dep = j.dep + array.dep
>   return array[j];                                // C
> }
> 
> Then inlining getzero would merely add another "# j.dep = i.dep" relation, 
> so depchains are still there but the value optimization can happen before 
> inlining.  Having to do something like that I'd find disgusting, and 
> rather rewrite consume into acquire :)  Or make the depchain relation 
> somehow realistically implementable.

I was actually OK with arithmetic cancellation breaking the dependency
chains.  Others on the committee felt otherwise, and I figured that
(1) I wouldn't be writing that kind of function anyway and (2) they
knew more about writing compilers than I.  I would still be OK saying
that things like "i-i", "i*0", "i%1", "i&0", "i|~0" and so on just
break the dependency chain.

							Thanx, Paul

