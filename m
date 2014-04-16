Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948AbaDPS30 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:29:26 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:38835
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbaDPS3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:29:24 -0400
Date: Wed, 16 Apr 2014 13:29:21 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@kernel.org, tj@kernel.org,
        grygorii.strashko@ti.com, peterz@infradead.org
Subject: Re: How do I increment a per-CPU variable without warning?
In-Reply-To: <20140416171230.GA8788@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.10.1404161328410.21030@gentwo.org>
References: <20140415221755.GA27188@linux.vnet.ibm.com> <alpine.DEB.2.10.1404161007080.9945@gentwo.org> <20140416160621.GX4496@linux.vnet.ibm.com> <20140416171230.GA8788@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014, Paul E. McKenney wrote:

> On Wed, Apr 16, 2014 at 09:06:21AM -0700, Paul E. McKenney wrote:
> > On Wed, Apr 16, 2014 at 10:08:03AM -0500, Christoph Lameter wrote:
> > > On Tue, 15 Apr 2014, Paul E. McKenney wrote:
> > >
> > > > Hello, Christoph,
> > > >
> > > > I have a patch that currently uses __this_cpu_inc_return() to increment a
> > > > per-CPU variable, but without preemption disabled.  Of course, given that
> > > > preemption is enabled, it might well end up picking up one CPU's counter,
> > > > adding one to it, then storing the result into some other CPU's counter.
> > > > But this is OK, the test can be probabilistic.  And when I run this
> > > > against v3.14 and earlier, it works fine.
> > >
> > > We introduced raw_cpu_inc_return to squish these warnings.
> >
> > Cool, this is a good short-term fix.
>
> Or at least it is given the following patch.  Was this the intent?

Correct. Thanks for the fix.

Acked-by: Christoph Lameter <cl@linux.com>


> 							Thanx, Paul
>
> ------------------------------------------------------------------------
>
> percpu: Fix raw_cpu_inc_return()
>
> The definition for raw_cpu_add_return() uses the operation prefix
> "raw_add_return_", but the definitions in the various percpu.h files
> expect "raw_cpu_add_return_".  This commit therefore appropriately
> adjusts the definition of raw_cpu_add_return().
>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Christoph Lameter <cl@linux.com>
>
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index e7a0b95ed527..495c6543a8f2 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -639,7 +639,7 @@ do {									\
>  #  define raw_cpu_add_return_8(pcp, val)	raw_cpu_generic_add_return(pcp, val)
>  # endif
>  # define raw_cpu_add_return(pcp, val)	\
> -	__pcpu_size_call_return2(raw_add_return_, pcp, val)
> +	__pcpu_size_call_return2(raw_cpu_add_return_, pcp, val)
>  #endif
>
>  #define raw_cpu_sub_return(pcp, val)	raw_cpu_add_return(pcp, -(typeof(pcp))(val))
>
