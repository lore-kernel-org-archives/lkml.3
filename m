Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbaBMAdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:33:20 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60410 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbaBMAdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:33:16 -0500
Date: Wed, 12 Feb 2014 16:33:11 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140213003311.GJ4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
 <20140212182336.GD5496@localhost.localdomain>
 <20140212190241.GD4250@linux.vnet.ibm.com>
 <20140212192354.GC26809@htj.dyndns.org>
 <20140212195922.GE4250@linux.vnet.ibm.com>
 <20140212230454.GA14383@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140212230454.GA14383@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021300-6688-0000-0000-0000066EE9EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 12:04:57AM +0100, Frederic Weisbecker wrote:
> On Wed, Feb 12, 2014 at 11:59:22AM -0800, Paul E. McKenney wrote:
> > On Wed, Feb 12, 2014 at 02:23:54PM -0500, Tejun Heo wrote:
> > > Hello,
> > > 
> > > On Wed, Feb 12, 2014 at 11:02:41AM -0800, Paul E. McKenney wrote:
> > > > +2.	Use the /sys/devices/virtual/workqueue/*/cpumask sysfs files
> > > > +	to force the WQ_SYSFS workqueues to run on the specified set
> > > > +	of CPUs.  The set of WQ_SYSFS workqueues can be displayed using
> > > > +	"ls sys/devices/virtual/workqueue".
> > > 
> > > One thing to be careful about is that once published, it becomes part
> > > of userland visible interface.  Maybe adding some words warning
> > > against sprinkling WQ_SYSFS willy-nilly is a good idea?
> > 
> > Good point!  How about the following?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > Documentation/kernel-per-CPU-kthreads.txt: Workqueue affinity
> > 
> > This commit documents the ability to apply CPU affinity to WQ_SYSFS
> > workqueues, thus offloading them from the desired worker CPUs.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > 
> > diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
> > index 827104fb9364..214da3a47a68 100644
> > --- a/Documentation/kernel-per-CPU-kthreads.txt
> > +++ b/Documentation/kernel-per-CPU-kthreads.txt
> > @@ -162,7 +162,16 @@ Purpose: Execute workqueue requests
> >  To reduce its OS jitter, do any of the following:
> >  1.	Run your workload at a real-time priority, which will allow
> >  	preempting the kworker daemons.
> > -2.	Do any of the following needed to avoid jitter that your
> > +2.	Use the /sys/devices/virtual/workqueue/*/cpumask sysfs files
> > +	to force the WQ_SYSFS workqueues to run on the specified set
> > +	of CPUs.  The set of WQ_SYSFS workqueues can be displayed using
> > +	"ls sys/devices/virtual/workqueue".  That said, the workqueues
> > +	maintainer would like to caution people against indiscriminately
> > +	sprinkling WQ_SYSFS across all the workqueues.  The reason for
> > +	caution is that it is easy to add WQ_SYSFS, but because sysfs
> > +	is part of the formal user/kernel API, it can be nearly impossible
> > +	to remove it, even if its addition was a mistake.
> > +3.	Do any of the following needed to avoid jitter that your
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> I just suggest we append a small explanation about what WQ_SYSFS is about.
> Like:

Fair point!  I wordsmithed it into the following.  Seem reasonable?

							Thanx, Paul

------------------------------------------------------------------------

Documentation/kernel-per-CPU-kthreads.txt: Workqueue affinity

This commit documents the ability to apply CPU affinity to WQ_SYSFS
workqueues, thus offloading them from the desired worker CPUs.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Tejun Heo <tj@kernel.org>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/Documentation/kernel-per-CPU-kthreads.txt b/Documentation/kernel-per-CPU-kthreads.txt
index 827104fb9364..f3cd299fcc41 100644
--- a/Documentation/kernel-per-CPU-kthreads.txt
+++ b/Documentation/kernel-per-CPU-kthreads.txt
@@ -162,7 +162,18 @@ Purpose: Execute workqueue requests
 To reduce its OS jitter, do any of the following:
 1.	Run your workload at a real-time priority, which will allow
 	preempting the kworker daemons.
-2.	Do any of the following needed to avoid jitter that your
+2.	A given workqueue can be made visible in the sysfs filesystem
+	by passing the WQ_SYSFS to that workqueue's alloc_workqueue().
+	Such a workqueue can be confined to a given subset of the
+	CPUs using the /sys/devices/virtual/workqueue/*/cpumask sysfs
+	files.	The set of WQ_SYSFS workqueues can be displayed using
+	"ls sys/devices/virtual/workqueue".  That said, the workqueues
+	maintainer would like to caution people against indiscriminately
+	sprinkling WQ_SYSFS across all the workqueues.	The reason for
+	caution is that it is easy to add WQ_SYSFS, but because sysfs is
+	part of the formal user/kernel API, it can be nearly impossible
+	to remove it, even if its addition was a mistake.
+3.	Do any of the following needed to avoid jitter that your
 	application cannot tolerate:
 	a.	Build your kernel with CONFIG_SLUB=y rather than
 		CONFIG_SLAB=y, thus avoiding the slab allocator's periodic

