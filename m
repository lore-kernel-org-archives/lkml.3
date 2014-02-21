Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbaBUSfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 13:35:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53982 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbaBUSfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 13:35:39 -0500
Date: Fri, 21 Feb 2014 19:35:37 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
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
In-Reply-To: <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1402211847290.7694@wotan.suse.de>
References: <1392752867.18779.8120.camel@triegel.csb> <CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com> <20140220040102.GM4250@linux.vnet.ibm.com> <CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com> <20140220083032.GN4250@linux.vnet.ibm.com>
 <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com> <20140220181116.GT4250@linux.vnet.ibm.com> <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com> <20140220185608.GX4250@linux.vnet.ibm.com>
 <CA+55aFw4inow5B-JAg-NtZigJ90yDbksddr00RoMKytzDAEa8A@mail.gmail.com> <20140220221027.GC4250@linux.vnet.ibm.com> <CA+55aFxp7U67R0PARaUfj94y5dJ8q6_HQ2pnbQ6=JD=XR-bTOw@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 20 Feb 2014, Linus Torvalds wrote:

> But I'm pretty sure that any compiler guy must *hate* that current odd
> dependency-generation part, and if I was a gcc person, seeing that
> bugzilla entry Torvald pointed at, I would personally want to
> dismember somebody with a rusty spoon..

Yes.  Defining dependency chains in the way the standard currently seems 
to do must come from people not writing compilers.  There's simply no 
sensible way to implement it without being really conservative, because 
the depchains can contain arbitrary constructs including stores, 
loads and function calls but must still be observed.  

And with conservative I mean "everything is a source of a dependency, and 
hence can't be removed, reordered or otherwise fiddled with", and that 
includes code sequences where no atomic objects are anywhere in sight [1].
In the light of that the only realistic way (meaning to not have to 
disable optimization everywhere) to implement consume as currently 
specified is to map it to acquire.  At which point it becomes pointless.

> So I suspect there are a number of people who would be *more* than
> happy with a change to those odd dependency rules.

I can't say much about your actual discussion related to semantics of 
atomics, not my turf.  But the "carries a dependency" relation is not 
usefully implementable.


Ciao,
Michael.
[1] Simple example of what type of transformations would be disallowed:

int getzero (int i) { return i - i; }

Should be optimizable to "return 0;", right?  Not with carries a 
dependency in place:

int jeez (int idx) {
  int i = atomic_load(idx, memory_order_consume); // A
  int j = getzero (i);                            // B
  return array[j];                                // C
}

As I read "carries a dependency" there's a dependency from A to C. 
Now suppose we would optimize getzero in the obvious way, then inline, and 
boom, dependency gone.  So we wouldn't be able to optimize any function 
when we don't control all its users, for fear that it _might_ be used in 
some dependency chain where it then matters that we possibly removed some 
chain elements due to the transformation.  We would have to retain 'i-i' 
before inlining, and if the function then is inlined into a context where 
depchains don't matter, could _then_ optmize it to zero.  But that's 
insane, especially considering that it's hard to detect if a given context 
doesn't care for depchains, after all the depchain relation is constructed 
exactly so that it bleeds into nearly everywhere.  So we would most of 
the time have to assume that the ultimate context will be depchain-aware 
and therefore disable many transformations.

There'd be one solution to the above, we would have to invent some special 
operands and markers that explicitely model "carries-a-dep", ala this:

int getzero (int i) {
  #RETURN.dep = i.dep
  return 0;
}

int jeez (int idx) {
  # i.dep = idx.dep
  int i = atomic_load(idx, memory_order_consume); // A
  # j.dep = i.dep
  int j = getzero (i);                            // B
  # RETURN.dep = j.dep + array.dep
  return array[j];                                // C
}

Then inlining getzero would merely add another "# j.dep = i.dep" relation, 
so depchains are still there but the value optimization can happen before 
inlining.  Having to do something like that I'd find disgusting, and 
rather rewrite consume into acquire :)  Or make the depchain relation 
somehow realistically implementable.
