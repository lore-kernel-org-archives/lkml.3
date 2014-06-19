Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbaFSC1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 22:27:18 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55903 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155AbaFSC1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 22:27:17 -0400
Date: Wed, 18 Jun 2014 19:27:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, cl@linux-foundation.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] percpu-refcount: implement percpu_ref_reinit() and
 percpu_ref_is_zero()
Message-ID: <20140619022708.GB4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <53A1097F.3060400@cn.fujitsu.com>
 <20140618153222.GA11042@htj.dyndns.org>
 <53A243B8.4010501@cn.fujitsu.com>
 <20140619020727.GC20100@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619020727.GC20100@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061902-0928-0000-0000-000002C00F27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 10:07:27PM -0400, Tejun Heo wrote:
> On Thu, Jun 19, 2014 at 09:58:16AM +0800, Lai Jiangshan wrote:
> > On 06/18/2014 11:32 PM, Tejun Heo wrote:
> > > On Wed, Jun 18, 2014 at 11:37:35AM +0800, Lai Jiangshan wrote:
> > >>> @@ -97,7 +98,10 @@ static inline void percpu_ref_kill(struct percpu_ref *ref)
> > >>>  static inline bool __pcpu_ref_alive(struct percpu_ref *ref,
> > >>>  				    unsigned __percpu **pcpu_countp)
> > >>>  {
> > >>> -	unsigned long pcpu_ptr = ACCESS_ONCE(ref->pcpu_count_ptr);
> > >>> +	unsigned long pcpu_ptr;
> > >>> +
> > >>> +	/* paired with smp_store_release() in percpu_ref_reinit() */
> > >>> +	pcpu_ptr = smp_load_acquire(&ref->pcpu_count_ptr);
> > >>
> > >>
> > >> Does "smp_load_acquire()" hurts the performance of percpu_ref_get/put()
> > >> in non-x86 system?
> > > 
> > > It's equivalent to data dependency barrier.  The only arch which needs
> > > something more than barrier() is alpha.  It isn't an issue.
> > 
> > But I searched from the source, smp_load_acquire() is just barrier() in
> > x86, arm64, ia64, s390, sparc, but it includes memory barrier 
> > instruction in other archs.
> 
> Hmmm, right, it's a stronger guarantee than the data dependency
> barrier.  This should probably use smp_wmb() and
> smp_read_barrier_depends().  That's all it needs anyway.

Yep, smp_load_acquire() orders its load against later loads and stores,
so it really does need a memory barrier on weakly ordered systems.

This is the "publish" operation for dynamically allocated per-CPU
references?  If so, agreed, you should be able to rely on dependency
ordering.  Make sure to comment the smp_read_barrier_depends().  ;-)

							Thanx, Paul

> Thanks.
> 
> -- 
> tejun
> 

