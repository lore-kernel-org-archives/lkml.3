Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965813AbaFSVc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:32:58 -0400
Received: from www.linutronix.de ([62.245.132.108]:55645 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964833AbaFSVc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:32:56 -0400
Date: Thu, 19 Jun 2014 23:32:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
In-Reply-To: <20140619205307.GL4904@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1406192331250.5170@nanos>
References: <53A2F406.4010109@oracle.com> <alpine.DEB.2.11.1406191001090.2785@gentwo.org> <20140619165247.GA4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192127100.5170@nanos> <20140619202928.GG4904@linux.vnet.ibm.com> <alpine.DEB.2.10.1406192230390.5170@nanos>
 <20140619205307.GL4904@linux.vnet.ibm.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jun 2014, Paul E. McKenney wrote:

> On Thu, Jun 19, 2014 at 10:37:17PM +0200, Thomas Gleixner wrote:
> > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > > On Thu, Jun 19, 2014 at 09:29:08PM +0200, Thomas Gleixner wrote:
> > > > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > > > Well, no. Look at the callchain:
> > > > 
> > > > __call_rcu
> > > >     debug_object_activate
> > > >        rcuhead_fixup_activate
> > > >           debug_object_init
> > > >               kmem_cache_alloc
> > > > 
> > > > So call rcu activates the object, but the object has no reference in
> > > > the debug objects code so the fixup code is called which inits the
> > > > object and allocates a reference ....
> > > 
> > > OK, got it.  And you are right, call_rcu() has done this for a very
> > > long time, so not sure what changed.  But it seems like the right
> > > approach is to provide a debug-object-free call_rcu_alloc() for use
> > > by the memory allocators.
> > > 
> > > Seem reasonable?  If so, please see the following patch.
> > 
> > Not really, you're torpedoing the whole purpose of debugobjects :)
> > 
> > So, why can't we just init the rcu head when the stuff is created?
> 
> That would allow me to keep my code unchanged, so I am in favor.  ;-)

Almost unchanged. You need to provide a function to do so, i.e. make
use of

    debug_init_rcu_head()

Thanks,

	tglx
