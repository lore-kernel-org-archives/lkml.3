Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbaJ3NSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:18:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46818 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759887AbaJ3NSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:18:52 -0400
Date: Thu, 30 Oct 2014 14:18:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141030131845.GI3337@twins.programming.kicks-ass.net>
References: <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030124333.GA29540@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 08:43:33AM -0400, Tejun Heo wrote:
> Hello, Peter.
> 
> On Thu, Oct 30, 2014 at 08:07:25AM +0100, Peter Zijlstra wrote:
> > If this means echo $tid > tasks, then sorry we can't do. There is a
> > limited number of hardware resources backing this thing. At some point
> > they're consumed and something must give.
> 
> And that something shouldn't be disallowing task migration across
> cgroups.  This simply doesn't work with co-mounting or unified
> hierarchy.  cpuset automatically takes on the nearest ancestor's
> configuration which has enough execution resources.  Maybe that can be
> an option for this too?

It will give very random and nondeterministic behaviour and basically
destroy the entire purpose of the controller (which are the very same
reasons I detest that 'new' behaviour in cpusets).

> One of the problems is that we generally assume that a task can run
> some point in time in a lot of places in the kernel and can't just not
> run a task indefinitely because it's in a cgroup configured certain
> way.

Refusing tasks into a previously empty cgroup creates no such problems.
Its already in a cgroup (wherever its parent was) and it can run there,
failing to move it to another does not affect things.

> > So either we fail mkdir, but that means allocating CLOS IDs for possibly
> > empty cgroups, or we allocate on demand which means failing task
> > assignment.
> 
> Can't fail mkdir or css enabling either.  Again, co-mounting and
> unified hierarchy.  Also, the behavior is just horrible to use from
> userland.

In order to fix the co-mounting and unified hierarchy I still need to
hear a proposal for that tasks vs processes thing.

Traditionally the cgroups were task based, but many controllers are
process based (simply because what they control is process wide, not per
task), and there was talk (2-3 years ago or so) about making the entire
cgroup thing per process, which obviously fails for all scheduler
related cgroups.

> > The same -- albeit for a different reason -- is true of the RT sched
> > groups, we simply cannot instantiate them such that tasks can join,
> > sysads _have_ to configure them before we can add tasks to them.
> 
> Yeah, RT is one of the main items which is problematic, more so
> because it's currently coupled with the normal sched controller and
> the default config doesn't have any RT slice. 

Simply because you cannot give a slice on creation; or if you did that
would mean failing mkdir when a new cgroup would exceed the available
time.

Also any !0 slice is wrong because it will not match the requirements of
the proposed workload, the administrator will have to set it to match
the workload.

Therefore 0.

> Do we completely block RT task w/o slice?  Is that okay?

We will not allow an RT task in, the write to the tasks file will fail.

The same will be true for deadline tasks, we'll fail entry into a cgroup
when the combined requirements of the tasks exceed the provisions of the
group.

There is just no way around that and still provide sane semantics.
