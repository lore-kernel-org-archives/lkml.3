Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaBPQlP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 11:41:15 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:56312 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508AbaBPQlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 11:41:13 -0500
Date: Sun, 16 Feb 2014 08:41:06 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140216164106.GD4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
 <20140212182336.GD5496@localhost.localdomain>
 <20140212190241.GD4250@linux.vnet.ibm.com>
 <20140212192354.GC26809@htj.dyndns.org>
 <7hk3cx46rw.fsf@paris.lan>
 <1392449804.5517.45.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392449804.5517.45.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021616-0928-0000-0000-000006744D15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 15, 2014 at 08:36:44AM +0100, Mike Galbraith wrote:
> On Fri, 2014-02-14 at 15:24 -0800, Kevin Hilman wrote: 
> > Tejun Heo <tj@kernel.org> writes:
> > 
> > > Hello,
> > >
> > > On Wed, Feb 12, 2014 at 11:02:41AM -0800, Paul E. McKenney wrote:
> > >> +2.	Use the /sys/devices/virtual/workqueue/*/cpumask sysfs files
> > >> +	to force the WQ_SYSFS workqueues to run on the specified set
> > >> +	of CPUs.  The set of WQ_SYSFS workqueues can be displayed using
> > >> +	"ls sys/devices/virtual/workqueue".
> > >
> > > One thing to be careful about is that once published, it becomes part
> > > of userland visible interface.  Maybe adding some words warning
> > > against sprinkling WQ_SYSFS willy-nilly is a good idea?
> > 
> > In the NO_HZ_FULL case, it seems to me we'd always want all unbound
> > workqueues to have their affinity set to the housekeeping CPUs.
> > 
> > Is there any reason not to enable WQ_SYSFS whenever WQ_UNBOUND is set so
> > the affinity can be controlled?  I guess the main reason would be that 
> > all of these workqueue names would become permanent ABI.
> > 
> > At least for NO_HZ_FULL, maybe this should be automatic.  The cpumask of
> > unbound workqueues should default to !tick_nohz_full_mask?  Any WQ_SYSFS
> > workqueues could still be overridden from userspace, but at least the
> > default would be sane, and help keep full dyntics CPUs isolated.
> 
> What I'm thinking is that it should be automatic, but not necessarily
> based upon the nohz full mask, rather maybe based upon whether sched
> domains exist, or perhaps a generic exclusive cpuset property, though
> some really don't want anything to do with cpusets.
> 
> Why? Because there are jitter intolerant loads where nohz full isn't all
> that useful, because you'll be constantly restarting and stopping the
> tick, and eating the increased accounting overhead to no gain because
> there are frequently multiple realtime tasks running.  For these loads
> (I have a user with such a fairly hefty 80 core rt load), dynamically
> turning the tick _on_ is currently a better choice than nohz_full.
> Point being, control of where unbound workqueues are allowed to run
> isn't only desirable for single task HPC loads, other loads exist.
> 
> For my particular fairly critical 80 core load, workqueues aren't a real
> big hairy deal, because its jitter tolerance isn't _all_ that tight (30
> us max is easy enough to meet with room to spare).  The load can slice
> through workers well enough to meet requirements, but it would certainly
> be a win to be able to keep them at bay.  (gonna measure it, less jitter
> is better even if it's only a little bit better.. eventually somebody
> will demand what's currently impossible to deliver)

So if there is NO_HZ_FULL, you have no objection to binding workqueues to
the timekeeping CPUs, but that you would also like some form of automatic
binding in the !NO_HZ_FULL case.  Of course, if a common mechanism could
serve both cases, that would be good.  And yes, cpusets are frowned upon
for some workloads.

So maybe start with Kevin's patch, but augment with something else for
the !NO_HZ_FULL case?

							Thanx, Paul

