Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaKLPiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:38:07 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52827 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaKLPiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:38:04 -0500
Date: Wed, 12 Nov 2014 16:37:40 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Duyck <alexander.h.duyck@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michael Neuling <mikey@neuling.org>, Tony Luck <tony.luck@intel.com>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] arch: Introduce read_acquire()
Message-ID: <20141112153740.GK29390@twins.programming.kicks-ass.net>
References: <20141111185510.2181.75347.stgit@ahduyck-workstation.home>
 <20141111194734.GL16265@arm.com>
 <54627BC0.4020705@redhat.com>
 <20141112101532.GJ29390@twins.programming.kicks-ass.net>
 <54637B6A.9070204@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54637B6A.9070204@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 07:23:22AM -0800, Alexander Duyck wrote:
> 
> On 11/12/2014 02:15 AM, Peter Zijlstra wrote:
> >On Tue, Nov 11, 2014 at 01:12:32PM -0800, Alexander Duyck wrote:
> >>>Minor nit on naming, but load_acquire would match what we do with barriers,
> >>>where you simply drop the smp_ prefix if you want the thing to work on UP
> >>>systems too.
> >>The problem is this is slightly different, load_acquire in my mind would use
> >>a mb() call, I only use a rmb().  That is why I chose read_acquire as the
> >>name.
> >acquire is not about rmb vs mb, do read up on
> >Documentation/memory-barriers.txt. Its a distinctly different semantic.
> >Some archs simply lack the means of implementing this semantics and have
> >to revert to mb (stronger is always allowed).
> >
> >Using the read vs load to wreck the acquire semantics is just insane.
> 
> Actually I have been reading up on it as I wasn't familiar with C11.  

C11 is _different_ although somewhat related.

> Most
> of what I was doing was actually based on the documentation in barriers.txt
> which was referring to memory operations not loads/stores when referring to
> the acquire/release so I assumed the full memory barrier was required.  I
> wasn't aware that smp_load_acquire was only supposed to be ordering loads,
> or that smp_ store_release only applied to stores.

It does not.. an ACQUIRE is a semi-permeable barrier that doesn't allow
LOADs nor STOREs that are issued _after_ it to appear to happen _before_.
The RELEASE is the opposite number, it ensures LOADs and STOREs that are
issued _before_ cannot happen _after_.

This typically matches locking, where a lock (mutex_lock, spin_lock
etc..) have ACQUIRE semantics and the unlock RELEASE. Such that:

	spin_lock();
	a = 1;
	b = x;
	spin_unlock();

guarantees all LOADs (x) and STORESs (a,b) happen _inside_ the lock
region. What they do not guarantee is:


	y = 1;
	spin_lock()
	a = 1;
	b = x;
	spin_unlock()
	z = 4;

An order between y and z, both are allowed _into_ the region and can
cross there like:

	spin_lock();
	...
	z = 4;
	y = 1;
	...
	spin_unlock();


The only 'open' issue at the moment is if RELEASE+ACQUIRE := MB.
Currently we say this is not so, but Will (and me) would very much like
this to be so -- PPC64 being the only arch that actually makes this
distinction.
