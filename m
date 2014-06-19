Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933764AbaFSQw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:52:56 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:60997 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775AbaFSQwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:52:55 -0400
Date: Thu, 19 Jun 2014 09:52:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140619165247.GA4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061916-8236-0000-0000-000003393AC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 10:03:04AM -0500, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Sasha Levin wrote:
> 
> > [  690.770137] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> > [  690.770137] __slab_alloc (mm/slub.c:1732 mm/slub.c:2205 mm/slub.c:2369)
> > [  690.770137] ? __lock_acquire (kernel/locking/lockdep.c:3189)
> > [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> > [  690.770137] kmem_cache_alloc (mm/slub.c:2442 mm/slub.c:2484 mm/slub.c:2489)
> > [  690.770137] ? __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> > [  690.770137] ? debug_object_activate (lib/debugobjects.c:439)
> > [  690.770137] __debug_object_init (lib/debugobjects.c:100 lib/debugobjects.c:312)
> > [  690.770137] debug_object_init (lib/debugobjects.c:365)
> > [  690.770137] rcuhead_fixup_activate (kernel/rcu/update.c:231)
> > [  690.770137] debug_object_activate (lib/debugobjects.c:280 lib/debugobjects.c:439)
> > [  690.770137] ? discard_slab (mm/slub.c:1486)
> > [  690.770137] __call_rcu (kernel/rcu/rcu.h:76 (discriminator 2) kernel/rcu/tree.c:2585 (discriminator 2))
> 
> __call_rcu does a slab allocation? This means __call_rcu can no longer be
> used in slab allocators? What happened?

My guess is that the root cause is a double call_rcu(), call_rcu_sched(),
call_rcu_bh(), or call_srcu().

Perhaps the DEBUG_OBJECTS code now allocates memory to report errors?
That would be unfortunate...

							Thanx, Paul

