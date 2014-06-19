Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720AbaFSRNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 13:13:21 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49564 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932894AbaFSRNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 13:13:20 -0400
Date: Thu, 19 Jun 2014 10:03:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, cl@linux-foundation.org,
        kmo@daterainc.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] percpu-refcount: implement percpu_ref_reinit()
 and percpu_ref_is_zero()
Message-ID: <20140619170305.GA8723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1403053685-28240-1-git-send-email-tj@kernel.org>
 <1403053685-28240-7-git-send-email-tj@kernel.org>
 <20140619022055.GD20100@mtj.dyndns.org>
 <53A25286.1030003@cn.fujitsu.com>
 <20140619133104.GH11042@htj.dyndns.org>
 <20140619165501.GB4904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619165501.GB4904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061917-9332-0000-0000-00000124A65B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:55:02AM -0700, Paul E. McKenney wrote:
> On Thu, Jun 19, 2014 at 09:31:04AM -0400, Tejun Heo wrote:
> > On Thu, Jun 19, 2014 at 11:01:26AM +0800, Lai Jiangshan wrote:
> > > > +	/*
> > > > +	 * Restore per-cpu operation.  smp_store_release() is paired with
> > > > +	 * smp_load_acquire() in __pcpu_ref_alive() and guarantees that the
> > > 
> > > s/smp_load_acquire()/smp_read_barrier_depends()/
> > 
> > Will update.
> > 
> > > s/smp_store_release()/smp_mb()/  if you accept my next comment.
> > >
> > > > +	 * zeroing is visible to all percpu accesses which can see the
> > > > +	 * following PCPU_REF_DEAD clearing.
> > > > +	 */
> > > > +	for_each_possible_cpu(cpu)
> > > > +		*per_cpu_ptr(pcpu_count, cpu) = 0;
> > > > +
> > > > +	smp_store_release(&ref->pcpu_count_ptr,
> > > > +			  ref->pcpu_count_ptr & ~PCPU_REF_DEAD);
> > > 
> > > I think it would be better if smp_mb() is used.
> > 
> > smp_wmb() would be better here.  We don't need the reader side.
> > 
> > > it is documented that smp_read_barrier_depends() and smp_mb() are paired.
> > > Not smp_read_barrier_depends() and smp_store_release().
> 
> Well, sounds like the documentation needs an update, then.  ;-)
> 
> For example, current rcu_assign_pointer() is a wrapper around
> smp_store_release().
> 
> > I don't know.  I thought about doing that but the RCU accessors are
> > pairing store_release with read_barrier_depends, so I don't think the
> > particular paring is problematic and store_release is better at
> > documenting what's being barriered.
> 
> Which Tejun noted as well.

And here is a patch to update the documentation.  Thoughts?

							Thanx, Paul

------------------------------------------------------------------------

documentation: Add acquire/release barriers to pairing rules

It is possible to pair acquire and release barriers with other barriers,
so this commit adds them to the list in the SMP barrier pairing section.

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index a6ca533a73fc..2a7c3c4fb53f 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -757,10 +757,12 @@ SMP BARRIER PAIRING
 When dealing with CPU-CPU interactions, certain types of memory barrier should
 always be paired.  A lack of appropriate pairing is almost certainly an error.
 
-A write barrier should always be paired with a data dependency barrier or read
-barrier, though a general barrier would also be viable.  Similarly a read
-barrier or a data dependency barrier should always be paired with at least an
-write barrier, though, again, a general barrier is viable:
+A write barrier should always be paired with a data dependency barrier,
+acquire barrier, release barrier, or read barrier, though a general
+barrier would also be viable.  Similarly a read barrier or a data
+dependency barrier should always be paired with at least a write barrier,
+an acquire barrier, or a release barrier, though, again, a general
+barrier is viable:
 
 	CPU 1		      CPU 2
 	===============	      ===============

