Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaBKPBl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:01:41 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38203 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105AbaBKPBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:01:39 -0500
Date: Tue, 11 Feb 2014 07:01:13 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: Memory allocator semantics
Message-ID: <20140211150113.GS4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140102203320.GA27615@linux.vnet.ibm.com>
 <52F60699.8010204@iki.fi>
 <alpine.DEB.2.10.1402101304110.17517@nuc>
 <20140211121426.GQ4250@linux.vnet.ibm.com>
 <CAOJsxLET90NRnEKeFjWKWTgZm+otSSwfCkhFga2hGjhV12nz9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLET90NRnEKeFjWKWTgZm+otSSwfCkhFga2hGjhV12nz9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021115-8236-0000-0000-000006F7B511
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 03:20:01PM +0200, Pekka Enberg wrote:
> On Tue, Feb 11, 2014 at 2:14 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > In contrast, from kfree() to a kmalloc() returning some of the kfree()ed
> > memory, I believe the kfree()/kmalloc() implementation must do any needed
> > synchronization and ordering.  But that is a different set of examples,
> > for example, this one:
> >
> >         CPU 0                   CPU 1
> >         p->a = 42;              q = kmalloc(...); /* returning p */
> >         kfree(p);               q->a = 5;
> >                                 BUG_ON(q->a != 5);
> >
> > Unlike the situation with (A), (B), and (C), in this case I believe
> > that it is kfree()'s and kmalloc()'s responsibility to ensure that
> > the BUG_ON() never triggers.
> >
> > Make sense?
> 
> I'm not sure...
> 
> It's the caller's responsibility not to touch "p" after it's handed over to
> kfree() - otherwise that's a "use-after-free" error.  If there's some reordering
> going on here, I'm tempted to blame the caller for lack of locking.

But if the two callers are unrelated, what locking can they possibly use?

>From what I can see, the current implementation prevents the above
BUG_ON() from firing.  If the two CPUs are the same, the CPU will see its
own accesses in order, while if they are different, the implementation
will have had to push the memory through non-CPU-local data structures,
which must have had some heavyweight protection.

							Thanx, Paul

