Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaBXQz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:55:56 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34835 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbaBXQzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:55:52 -0500
Date: Mon, 24 Feb 2014 17:55:50 +0100 (CET)
From: Michael Matz <matz@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Richard Biener <richard.guenther@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
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
In-Reply-To: <CA+55aFyYtMm1_UsPVw8mi7o2iH_--1wLvxPUt5Z9mAEOGMgXdQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1402241745100.7694@wotan.suse.de>
References: <20140220083032.GN4250@linux.vnet.ibm.com> <CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com> <20140220181116.GT4250@linux.vnet.ibm.com> <CA+55aFwn9gXWVq_GL=tPPP63vsqs-9QB4ii4s06xqG4UscCV5w@mail.gmail.com> <1392922421.28840.36.camel@triegel.csb>
 <CA+55aFwos2Gwd2LEvht4ymVxHb6GRVjtZ9wwJSaj1p--FqNUWw@mail.gmail.com> <1393095223.28840.4914.camel@triegel.csb> <CA+55aFz9=RQoMO2ipyZgNPNzWGVXi_R9Ar5=o9VBWwXzDDz6jg@mail.gmail.com> <20140223003933.GQ4250@linux.vnet.ibm.com>
 <CA+55aFyjzR_Ga_HOKnBXpKYbuesqovj1-sFTVisD9UwA6JuJtw@mail.gmail.com> <20140223063426.GT4250@linux.vnet.ibm.com> <CA+55aFxMJvaQhoEwqgN=XA6gDOdZwoZQHdcAnB-FhAri_hK-6Q@mail.gmail.com> <CA+55aFw5tdjmNyHCdcyZ8NPpd1wCgOjLRzstRhp0Njs9azpi8Q@mail.gmail.com>
 <CAFiYyc08cusFTsydD2C4rEZB-k38NnorzEXzKvqab0m3R+qn8w@mail.gmail.com> <CA+55aFyYtMm1_UsPVw8mi7o2iH_--1wLvxPUt5Z9mAEOGMgXdQ@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 24 Feb 2014, Linus Torvalds wrote:

> > To me that reads like
> >
> >   int i;
> >   int *q = &i;
> >   int **p = &q;
> >
> >   atomic_XXX (p, CONSUME);
> >
> > orders against accesses '*p', '**p', '*q' and 'i'.  Thus it seems they
> > want to say that it orders against aliased storage - but then go further
> > and include "indirectly through a chain of pointers"?!  Thus an
> > atomic read of a int * orders against any 'int' memory operation but
> > not against 'float' memory operations?
> 
> No, it's not about type at all, and the "chain of pointers" can be
> much more complex than that, since the "int *" can point to within an
> object that contains other things than just that "int" (the "int" can
> be part of a structure that then has pointers to other structures
> etc).

So, let me try to poke holes into your definition or increase my 
understanding :) .  You said "chain of pointers"(dereferences I assume), 
e.g. if p is result of consume load, then access to 
p->here->there->next->prev->stuff is supposed to be ordered with that load 
(or only when that last load/store itself is also an atomic load or 
store?).

So, what happens if the pointer deref chain is partly hidden in some 
functions:

A * adjustptr (B *ptr) { return &ptr->here->there->next; }
B * p = atomic_XXX (&somewhere, consume);
adjustptr(p)->prev->stuff = bla;

As far as I understood you, this whole ptrderef chain business would be 
only an optimization opportunity, right?  So if the compiler can't be sure 
how p is actually used (as in my function-using case, assume adjustptr is 
defined in another unit), then the consume load would simply be 
transformed into an acquire (or whatever, with some barrier I mean)?  Only 
_if_ the compiler sees all obvious uses of p (indirectly through pointer 
derefs) can it, yeah, do what with the consume load?


Ciao,
Michael.
