Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaGKTzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:55:22 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51145 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaGKTzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:55:19 -0400
Date: Fri, 11 Jul 2014 21:55:07 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Christoph Lameter <cl@gentwo.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
Message-ID: <20140711195505.GM26045@localhost.localdomain>
References: <20140708152358.GF6571@localhost.localdomain>
 <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain>
 <alpine.DEB.2.11.1407111309150.4777@gentwo.org>
 <20140711182541.GF26045@localhost.localdomain>
 <20140711184528.GQ16041@linux.vnet.ibm.com>
 <20140711185731.GG26045@localhost.localdomain>
 <20140711190816.GR16041@linux.vnet.ibm.com>
 <20140711192612.GJ26045@localhost.localdomain>
 <20140711194314.GU16041@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711194314.GU16041@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 12:43:14PM -0700, Paul E. McKenney wrote:
> On Fri, Jul 11, 2014 at 09:26:14PM +0200, Frederic Weisbecker wrote:
> > On Fri, Jul 11, 2014 at 12:08:16PM -0700, Paul E. McKenney wrote:
> > > On Fri, Jul 11, 2014 at 08:57:33PM +0200, Frederic Weisbecker wrote:
> > > > On Fri, Jul 11, 2014 at 11:45:28AM -0700, Paul E. McKenney wrote:
> > > > > On Fri, Jul 11, 2014 at 08:25:43PM +0200, Frederic Weisbecker wrote:
> > > > > > On Fri, Jul 11, 2014 at 01:10:41PM -0500, Christoph Lameter wrote:
> > > > > > > On Tue, 8 Jul 2014, Frederic Weisbecker wrote:
> > > > > > > 
> > > > > > > > > I was figuring that a fair number of the kthreads might eventually
> > > > > > > > > be using this, not just for the grace-period kthreads.
> > > > > > > >
> > > > > > > > Ok makes sense. But can we just rename the cpumask to housekeeping_mask?
> > > > > > > 
> > > > > > > That would imply that all no-nohz processors are housekeeping? So all
> > > > > > > processors with a tick are housekeeping?
> > > > > > 
> > > > > > Well, now that I think about it again, I would really like to keep housekeeping
> > > > > > to CPU 0 when nohz_full= is passed.
> > > > > 
> > > > > When CONFIG_NO_HZ_FULL_SYSIDLE=y, then housekeeping kthreads are bound to
> > > > > CPU 0.  However, doing this causes significant slowdowns according to
> > > > > Fengguang's testing, so when CONFIG_NO_HZ_FULL_SYSIDLE=n, I bind the
> > > > > housekeeping kthreads to the set of non-nohz_full CPUs.
> > > > 
> > > > But did he see these slowdowns with nohz_full= parameter passed? I doubt he
> > > > tested that. And I'm not sure that people who need full dynticks will run
> > > > the usecases that trigger slowdowns with grace period kthreads.
> > > > 
> > > > I also doubt that people will often omit other CPUs than CPU 0 nohz_full=
> > > > range.
> > > 
> > > Agreed, this is only a problem when people run workloads for which
> > > NO_HZ_FULL is not well-suited.  Which is why I settled on designating
> > > the non-nohz_full= CPUs as the housekeeping CPUs -- people wanting to
> > > run general workloads not suited to NO_HZ_FULL probably won't specify
> > > nohz_full=.  If they don't, then any CPU can be a housekeeping CPU.
> > 
> > Right. So affining GP kthread to all non-nohz-full CPU works in all case. It's convenient
> > but it requires some plumbing:
> > 
> > * add a housekeeping cpumask and implement housekeeping_affine on top
> > * add kthread_bind_cpumask()
> 
> Yep.
> 
> > So what I propose is to skip these complications and just do:
> > 
> >         if (tick_nohz_full_enabled()) // means that somebody passed nohz_full= kernel parameter
> >             kthread_bind_cpu(GP kthread, 0)
> > 
> > Moreover Thomas didn't like the idea of extending housekeeping duty further CPU 0, arguing that
> > it's too early for that. He meant that for timekeeping but the idea is expandable.
> 
> Although I agree that we can get away with a single timekeeping CPU, I
> don't believe that we get away with having only a single housekeeping CPU.

Ok, well I won't insist too much. As long as the performance issue is fixed, I'm ok :)

Thanks.
