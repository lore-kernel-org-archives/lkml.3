Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaBXR5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 12:57:17 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44957 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaBXR5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 12:57:15 -0500
Date: Mon, 24 Feb 2014 09:57:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Matz <matz@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Richard Biener <richard.guenther@gmail.com>,
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
Message-ID: <20140224175710.GA19983@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com>
 <20140223003933.GQ4250@linux.vnet.ibm.com>
 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com>
 <20140223063426.GT4250@linux.vnet.ibm.com>
 <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com>
 <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <CAFiYyc08cusFTsydD2C4rEZB-k38NnorzEXzKvqab0m3R+qn8w@mail.gmail.com>
 <CA+55aFyYtMm1_UsPVw8mi7o2iH_--1wLvxPUt5Z9mAEOGMgXdQ@mail.gmail.com>
 <alpine.LNX.2.00.1402241745100.7694@wotan.suse.de>
 <20140224172856.GP8264@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224172856.GP8264@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022417-0928-0000-0000-000007065347
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 09:28:56AM -0800, Paul E. McKenney wrote:
> On Mon, Feb 24, 2014 at 05:55:50PM +0100, Michael Matz wrote:
> > Hi,
> > 
> > On Mon, 24 Feb 2014, Linus Torvalds wrote:
> > 
> > > > To me that reads like
> > > >
> > > >   int i;
> > > >   int *q = &i;
> > > >   int **p = &q;
> > > >
> > > >   atomic_XXX (p, CONSUME);
> > > >
> > > > orders against accesses '*p', '**p', '*q' and 'i'.  Thus it seems they
> > > > want to say that it orders against aliased storage - but then go further
> > > > and include "indirectly through a chain of pointers"?!  Thus an
> > > > atomic read of a int * orders against any 'int' memory operation but
> > > > not against 'float' memory operations?
> > > 
> > > No, it's not about type at all, and the "chain of pointers" can be
> > > much more complex than that, since the "int *" can point to within an
> > > object that contains other things than just that "int" (the "int" can
> > > be part of a structure that then has pointers to other structures
> > > etc).
> > 
> > So, let me try to poke holes into your definition or increase my 
> > understanding :) .  You said "chain of pointers"(dereferences I assume), 
> > e.g. if p is result of consume load, then access to 
> > p->here->there->next->prev->stuff is supposed to be ordered with that load 
> > (or only when that last load/store itself is also an atomic load or 
> > store?).
> > 
> > So, what happens if the pointer deref chain is partly hidden in some 
> > functions:
> > 
> > A * adjustptr (B *ptr) { return &ptr->here->there->next; }
> > B * p = atomic_XXX (&somewhere, consume);
> > adjustptr(p)->prev->stuff = bla;
> > 
> > As far as I understood you, this whole ptrderef chain business would be 
> > only an optimization opportunity, right?  So if the compiler can't be sure 
> > how p is actually used (as in my function-using case, assume adjustptr is 
> > defined in another unit), then the consume load would simply be 
> > transformed into an acquire (or whatever, with some barrier I mean)?  Only 
> > _if_ the compiler sees all obvious uses of p (indirectly through pointer 
> > derefs) can it, yeah, do what with the consume load?
> 
> Good point, I left that out of my list.  Adding it:
> 
> 13.	By default, pointer chains do not propagate into or out of functions.
> 	In implementations having attributes, a [[carries_dependency]]
> 	may be used to mark a function argument or return as passing
> 	a pointer chain into or out of that function.
> 
> 	If a function does not contain memory_order_consume loads and
> 	also does not contain [[carries_dependency]] attributes, then
> 	that function may be compiled using any desired dependency-breaking
> 	optimizations.
> 
> 	The ordering effects are implementation defined when a given
> 	pointer chain passes into or out of a function through a parameter
> 	or return not marked with a [[carries_dependency]] attributed.
> 
> Note that this last paragraph differs from the current standard, which
> would require ordering regardless.

And there is also kill_dependency(), which needs to be added to the list
in #8 of operators that take a chained pointer and return something that
is not a chained pointer.

							Thanx, Paul

