Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbaBZNFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 08:05:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbaBZNFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 08:05:16 -0500
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Torvald Riegel <triegel@redhat.com>
To: paulmck@linux.vnet.ibm.com
Cc: Michael Matz <matz@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
In-Reply-To: <20140221191318.GK4250@linux.vnet.ibm.com>
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
	 <20140221191318.GK4250@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Feb 2014 14:04:30 +0100
Message-ID: <1393419870.28840.8680.camel@triegel.csb>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 11:13 -0800, Paul E. McKenney wrote:
> On Fri, Feb 21, 2014 at 07:35:37PM +0100, Michael Matz wrote:
> > Hi,
> > 
> > On Thu, 20 Feb 2014, Linus Torvalds wrote:
> > 
> > > But I'm pretty sure that any compiler guy must *hate* that current odd
> > > dependency-generation part, and if I was a gcc person, seeing that
> > > bugzilla entry Torvald pointed at, I would personally want to
> > > dismember somebody with a rusty spoon..
> > 
> > Yes.  Defining dependency chains in the way the standard currently seems 
> > to do must come from people not writing compilers.  There's simply no 
> > sensible way to implement it without being really conservative, because 
> > the depchains can contain arbitrary constructs including stores, 
> > loads and function calls but must still be observed.  
> > 
> > And with conservative I mean "everything is a source of a dependency, and 
> > hence can't be removed, reordered or otherwise fiddled with", and that 
> > includes code sequences where no atomic objects are anywhere in sight [1].
> > In the light of that the only realistic way (meaning to not have to 
> > disable optimization everywhere) to implement consume as currently 
> > specified is to map it to acquire.  At which point it becomes pointless.
> 
> No, only memory_order_consume loads and [[carries_dependency]]
> function arguments are sources of dependency chains.

However, that is, given how the standard specifies things, just one of
the possible ways for how an implementation can handle this.  Treating
[[carries_dependency]] as a "necessary" annotation to make exploiting
mo_consume work in practice is possible, but it's not required by the
standard.

Also, dependencies are specified to flow through loads and stores
(restricted to scalar objects and bitfields), so any load that might
load from a dependency-carrying store can also be a source (and that
doesn't seem to be restricted by [[carries_dependency]]).

