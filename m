Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaBOHhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 02:37:19 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752AbaBOHgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 02:36:52 -0500
Message-ID: <1392449804.5517.45.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
From: Mike Galbraith <bitbucket@online.de>
To: Kevin Hilman <khilman@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Date: Sat, 15 Feb 2014 08:36:44 +0100
In-Reply-To: <7hk3cx46rw.fsf@paris.lan>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	 <52F8A51F.4090909@cn.fujitsu.com>
	 <20140210184729.GL4250@linux.vnet.ibm.com>
	 <20140212182336.GD5496@localhost.localdomain>
	 <20140212190241.GD4250@linux.vnet.ibm.com>
	 <20140212192354.GC26809@htj.dyndns.org> <7hk3cx46rw.fsf@paris.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:Muzew6O+kH2jlkkMuuiJ1bZ2E5pMXbDK5cgEDJNyJgR
 9CkL2BPctULE7mcIJawS/oPs+W2swDhlIwbf1dw/C9DUvqxKYE
 pLSBedePC9HCh+WSldjYJe2xAK6BJzZpC+GdxWXQQgGTdECnPG
 bd6c3ywfvr8V/CQNN5wdwKXwdysIqVaf/jPPnxdQoD2fcA1Dag
 Bia+j30o6bhZGQ8thnjmjPjTiibI+FlRF8UcjbLb3hbvx9SRrP
 L4IwyEuw9eZMetlcjM1KdUubRMGI072KRkkLcSejhv5OUWSla5
 x1bK/KnKLIlAMEsZGezZfaON+1ChatNhQWuLCl8tjqDJLzGm2N
 /cdltDr7P74tdhZ5xQ2dLNSrhaGm/ri8Jk2sgELceAQOhknSM7
 Vh948Ts1aTEzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-14 at 15:24 -0800, Kevin Hilman wrote: 
> Tejun Heo <tj@kernel.org> writes:
> 
> > Hello,
> >
> > On Wed, Feb 12, 2014 at 11:02:41AM -0800, Paul E. McKenney wrote:
> >> +2.	Use the /sys/devices/virtual/workqueue/*/cpumask sysfs files
> >> +	to force the WQ_SYSFS workqueues to run on the specified set
> >> +	of CPUs.  The set of WQ_SYSFS workqueues can be displayed using
> >> +	"ls sys/devices/virtual/workqueue".
> >
> > One thing to be careful about is that once published, it becomes part
> > of userland visible interface.  Maybe adding some words warning
> > against sprinkling WQ_SYSFS willy-nilly is a good idea?
> 
> In the NO_HZ_FULL case, it seems to me we'd always want all unbound
> workqueues to have their affinity set to the housekeeping CPUs.
> 
> Is there any reason not to enable WQ_SYSFS whenever WQ_UNBOUND is set so
> the affinity can be controlled?  I guess the main reason would be that 
> all of these workqueue names would become permanent ABI.
> 
> At least for NO_HZ_FULL, maybe this should be automatic.  The cpumask of
> unbound workqueues should default to !tick_nohz_full_mask?  Any WQ_SYSFS
> workqueues could still be overridden from userspace, but at least the
> default would be sane, and help keep full dyntics CPUs isolated.

What I'm thinking is that it should be automatic, but not necessarily
based upon the nohz full mask, rather maybe based upon whether sched
domains exist, or perhaps a generic exclusive cpuset property, though
some really don't want anything to do with cpusets.

Why? Because there are jitter intolerant loads where nohz full isn't all
that useful, because you'll be constantly restarting and stopping the
tick, and eating the increased accounting overhead to no gain because
there are frequently multiple realtime tasks running.  For these loads
(I have a user with such a fairly hefty 80 core rt load), dynamically
turning the tick _on_ is currently a better choice than nohz_full.
Point being, control of where unbound workqueues are allowed to run
isn't only desirable for single task HPC loads, other loads exist.

For my particular fairly critical 80 core load, workqueues aren't a real
big hairy deal, because its jitter tolerance isn't _all_ that tight (30
us max is easy enough to meet with room to spare).  The load can slice
through workers well enough to meet requirements, but it would certainly
be a win to be able to keep them at bay.  (gonna measure it, less jitter
is better even if it's only a little bit better.. eventually somebody
will demand what's currently impossible to deliver)

-Mike

