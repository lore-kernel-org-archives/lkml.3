Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934497AbaFSUhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:37:09 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:49283 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933503AbaFSUhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:37:07 -0400
Date: Thu, 19 Jun 2014 13:36:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Sasha Levin <sasha.levin@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: slub/debugobjects: lockup when freeing memory
Message-ID: <20140619203659.GH4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A2F406.4010109@oracle.com>
 <alpine.DEB.2.11.1406191001090.2785@gentwo.org>
 <20140619165247.GA4904@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1406192127100.5170@nanos>
 <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1406191519090.4002@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061920-1344-0000-0000-0000024F1CBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 03:19:39PM -0500, Christoph Lameter wrote:
> On Thu, 19 Jun 2014, Thomas Gleixner wrote:
> 
> > Well, no. Look at the callchain:
> >
> > __call_rcu
> >     debug_object_activate
> >        rcuhead_fixup_activate
> >           debug_object_init
> >               kmem_cache_alloc
> >
> > So call rcu activates the object, but the object has no reference in
> > the debug objects code so the fixup code is called which inits the
> > object and allocates a reference ....
> 
> So we need to init the object in the page struct before the __call_rcu?

Good point.  The patch I just sent will complain at callback-invocation
time because the debug-object information won't be present.

One way to handle this would be for rcu_do_batch() to avoid complaining
if it gets a callback that has not been through call_rcu()'s
debug_rcu_head_queue().  One way to do that would be to have an
alternative to debug_object_deactivate() that does not complain
if it is handed an unactivated object.

Another way to handle this would be for me to put the definition of
debug_rcu_head_queue() somewhere where the sl*b allocator could get
at it, and have the sl*b allocators invoke it some at initialization
and within the RCU callback.

Other thoughts?

							Thanx, Paul

