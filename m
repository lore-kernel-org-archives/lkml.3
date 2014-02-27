Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaB0PIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:08:52 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:34761 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaB0PIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:08:50 -0500
Date: Thu, 27 Feb 2014 16:08:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140227150843.GB19580@localhost.localdomain>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
 <20140212182336.GD5496@localhost.localdomain>
 <20140212190241.GD4250@linux.vnet.ibm.com>
 <20140212192354.GC26809@htj.dyndns.org>
 <7hk3cx46rw.fsf@paris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hk3cx46rw.fsf@paris.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 03:24:35PM -0800, Kevin Hilman wrote:
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

Right. It's a legitimate worry but couldn't we consider workqueue names
just like kernel threads names? Ie: something that can be renamed or
disappear anytime from a kernel version to another?

Or sysfs has real strict rules about that and I'm just daydreaming?

I've been thinking we could also have a pseudo-workqueue directory in
/sys/devices/virtual/workqueue/unbounds with only cpumask as a file.

Writing to it would set all unbound workqueue affinity, at least those
that don't have WQ_SYSFS.

This would solve the ABI issue and keep a single consistent interface
for workqueue affinity.

> 
> At least for NO_HZ_FULL, maybe this should be automatic.  The cpumask of
> unbound workqueues should default to !tick_nohz_full_mask?  Any WQ_SYSFS
> workqueues could still be overridden from userspace, but at least the
> default would be sane, and help keep full dyntics CPUs isolated.
> 
> Example patch below, only boot tested on 4-CPU ARM system with
> CONFIG_NO_HZ_FULL_ALL=y and verified that 'cat
> /sys/devices/virtual/workqueue/writeback/cpumask' looked sane.  If this
> looks OK, I can maybe clean it up a bit and make it runtime check
> instead of a compile time check.

It can work too yeah. Maybe I prefer the idea of keeping a sysfs interface
for all workqueues (whether we use a pseudo "unbounds" dir or not) because then
the workqueue core stays unaware of dynticks details and it doesn't end up
fiddling with timers core internals like the full dynticks cpumask. The result
is more interdependency and possible headaches between timers and workqueue init
ordering.

And moreover people may forget to change WQ_SYSFS workqueues if all other UNBOUND
workqueues are known to be automatically handled. Or we handle WQ_SYSFS as well
along the way? But still WQ_SYSFS cpumask may be modified by other user programms
so it's still a round of set that must be done before doing any isolation work.

So I have mixed feelings between code complexity, simplicity for users, etc...

What do you guys think?
