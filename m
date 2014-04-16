Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431AbaDPSsD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:48:03 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:33542 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352AbaDPSr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:47:59 -0400
Date: Wed, 16 Apr 2014 11:47:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
Message-ID: <20140416184755.GY4496@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140415221755.GA27188@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404161007080.9945@gentwo.org>
 <20140416160621.GX4496@linux.vnet.ibm.com>
 <20140416171230.GA8788@linux.vnet.ibm.com>
 <alpine.DEB.2.10.1404161328410.21030@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1404161328410.21030@gentwo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041618-1542-0000-0000-00000122EAFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 01:29:21PM -0500, Christoph Lameter wrote:
> On Wed, 16 Apr 2014, Paul E. McKenney wrote:
> 
> > On Wed, Apr 16, 2014 at 09:06:21AM -0700, Paul E. McKenney wrote:
> > > On Wed, Apr 16, 2014 at 10:08:03AM -0500, Christoph Lameter wrote:
> > > > On Tue, 15 Apr 2014, Paul E. McKenney wrote:
> > > >
> > > > > Hello, Christoph,
> > > > >
> > > > > I have a patch that currently uses __this_cpu_inc_return() to increment a
> > > > > per-CPU variable, but without preemption disabled.  Of course, given that
> > > > > preemption is enabled, it might well end up picking up one CPU's counter,
> > > > > adding one to it, then storing the result into some other CPU's counter.
> > > > > But this is OK, the test can be probabilistic.  And when I run this
> > > > > against v3.14 and earlier, it works fine.
> > > >
> > > > We introduced raw_cpu_inc_return to squish these warnings.
> > >
> > > Cool, this is a good short-term fix.
> >
> > Or at least it is given the following patch.  Was this the intent?
> 
> Correct. Thanks for the fix.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Queued, thank you.  I don't need this until 3.16, but I am tempted
to push it in this cycle in case others need it.  Any objections?

 							Thanx, Paul

> > ------------------------------------------------------------------------
> >
> > percpu: Fix raw_cpu_inc_return()
> >
> > The definition for raw_cpu_add_return() uses the operation prefix
> > "raw_add_return_", but the definitions in the various percpu.h files
> > expect "raw_cpu_add_return_".  This commit therefore appropriately
> > adjusts the definition of raw_cpu_add_return().
> >
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Christoph Lameter <cl@linux.com>
> >
> > diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> > index e7a0b95ed527..495c6543a8f2 100644
> > --- a/include/linux/percpu.h
> > +++ b/include/linux/percpu.h
> > @@ -639,7 +639,7 @@ do {									\
> >  #  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
> >  # endif
> >  # define raw_cpu_add_return(pcp, val)	\
> > -	__pcpu_size_call_return2(raw_add_return_, pcp, val)
> > +	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
> >  #endif
> >
> >  #define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
> >
> 

