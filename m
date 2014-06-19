Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964956AbaFSUm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:42:29 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:59185 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbaFSUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:42:28 -0400
Date: Thu, 19 Jun 2014 13:39:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@gentwo.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140619203909.GI4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
 <20140619165247.GA4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192127100.5170@nanos>
 <20140619202928.GG4904@linux.vnet.ibm.com>
 <53A348E6.3050404@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A348E6.3050404@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061920-6688-0000-0000-000002AF0E62
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 04:32:38PM -0400, Sasha Levin wrote:
> On 06/19/2014 04:29 PM, Paul E. McKenney wrote:
> > On Thu, Jun 19, 2014 at 09:29:08PM +0200, Thomas Gleixner wrote:
> >> > On Thu, 19 Jun 2014, Paul E. McKenney wrote:
> >> > 
> >>> > > On Thu, Jun 19, 2014 at 10:03:04AM -0500, Christoph Lameter wrote:
> >>>> > > > On Thu, 19 Jun 2014, Sasha Levin wrote:
> >>>> > > > 
> >>>>> > > > > [  690.770137] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> >>>>> > > > > [  690.770137] __slab_alloc (mm/slub.c:1732 mm/slub.c:2205 mm/slub.c:2369)
> >>>>> > > > > [  690.770137] ? __lock_acquire (kernel/locking/lockdep.c:3189)
> >>>>> > > > > [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> >>>>> > > > > [  690.770137] kmem_cache_alloc (mm/slub.c:2442 mm/slub.c:2484 mm/slub.c:2489)
> >>>>> > > > > [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> >>>>> > > > > [  690.770137] ? debug_object_activate (lib/debugobjects.c:439)
> >>>>> > > > > [  690.770137] __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> >>>>> > > > > [  690.770137] debug_object_init (lib/debugobjects.c:365)
> >>>>> > > > > [  690.770137] rcuhead_fixup_activate (kernel/rcu/update.c:231)
> >>>>> > > > > [  690.770137] debug_object_activate (lib/debugobjects.c:280 lib/debugobjects.c:439)
> >>>>> > > > > [  690.770137] ? discard_slab (mm/slub.c:1486)
> >>>>> > > > > [  690.770137] __call_rcu (kernel/rcu/rcu.h:76 (discriminator 2) kernel/rcu/tree.c:2585 (discriminator 2))
> >>>> > > > 
> >>>> > > > __call_rcu does a slab allocation? This means __call_rcu can no longer be
> >>>> > > > used in slab allocators? What happened?
> >>> > > 
> >>> > > My guess is that the root cause is a double call_rcu(), call_rcu_sched(),
> >>> > > call_rcu_bh(), or call_srcu().
> >>> > > 
> >>> > > Perhaps the DEBUG_OBJECTS code now allocates memory to report errors?
> >>> > > That would be unfortunate...
> >> > 
> >> > Well, no. Look at the callchain:
> >> > 
> >> > __call_rcu
> >> >     debug_object_activate
> >> >        rcuhead_fixup_activate
> >> >           debug_object_init
> >> >               kmem_cache_alloc
> >> > 
> >> > So call rcu activates the object, but the object has no reference in
> >> > the debug objects code so the fixup code is called which inits the
> >> > object and allocates a reference ....
> > OK, got it.  And you are right, call_rcu() has done this for a very
> > long time, so not sure what changed.
> 
> It's probable my fault. I've introduced clone() and unshare() fuzzing.
> 
> Those two are full with issues and I've been waiting with enabling those
> until the rest of the kernel could survive trinity for more than an hour.

Well, that might explain why I haven't seen it in my testing.  ;-)

							Thanx, Paul

