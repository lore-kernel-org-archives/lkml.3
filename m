Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934631AbaFSVDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 17:03:37 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:46179 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaFSVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 17:03:36 -0400
Date: Thu, 19 Jun 2014 13:53:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Lameter <cl@gentwo.org>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140619205307.GL4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
 <20140619165247.GA4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192127100.5170@nanos>
 <20140619202928.GG4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192230390.5170@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1406192230390.5170@nanos>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061920-0928-0000-0000-000002D0F915
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:37:17PM +0200, Thomas Gleixner wrote:
> On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > On Thu, Jun 19, 2014 at 09:29:08PM +0200, Thomas Gleixner wrote:
> > > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> > > Well, no. Look at the callchain:
> > > 
> > > __call_rcu
> > >     debug_object_activate
> > >        rcuhead_fixup_activate
> > >           debug_object_init
> > >               kmem_cache_alloc
> > > 
> > > So call rcu activates the object, but the object has no reference in
> > > the debug objects code so the fixup code is called which inits the
> > > object and allocates a reference ....
> > 
> > OK, got it.  And you are right, call_rcu() has done this for a very
> > long time, so not sure what changed.  But it seems like the right
> > approach is to provide a debug-object-free call_rcu_alloc() for use
> > by the memory allocators.
> > 
> > Seem reasonable?  If so, please see the following patch.
> 
> Not really, you're torpedoing the whole purpose of debugobjects :)
> 
> So, why can't we just init the rcu head when the stuff is created?

That would allow me to keep my code unchanged, so I am in favor.  ;-)

							Thanx, Paul

> If that's impossible due to other memory allocator constraints, then
> instead of inventing a whole new API we can simply flag the relevent
> data in the memory allocator as we do with the debug objects mem cache
> itself (SLAB_DEBUG_OBJECTS).
> 
> Thanks,
> 
> 	tglx
> 

