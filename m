Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbaJ3RDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:03:37 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:61731 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594AbaJ3RDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:03:35 -0400
Date: Thu, 30 Oct 2014 13:03:31 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141030170331.GB378@htj.dyndns.org>
References: <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <20141030131845.GI3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030131845.GI3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Peter.

On Thu, Oct 30, 2014 at 02:18:45PM +0100, Peter Zijlstra wrote:
> On Thu, Oct 30, 2014 at 08:43:33AM -0400, Tejun Heo wrote:
> > And that something shouldn't be disallowing task migration across
> > cgroups.  This simply doesn't work with co-mounting or unified
> > hierarchy.  cpuset automatically takes on the nearest ancestor's
> > configuration which has enough execution resources.  Maybe that can be
> > an option for this too?
> 
> It will give very random and nondeterministic behaviour and basically
> destroy the entire purpose of the controller (which are the very same
> reasons I detest that 'new' behaviour in cpusets).

I agree with you that this is a corner case behavior which deviates
from the usual behavior; however, the deviation is inherent.  This
stems from the fact that the kernel in general doesn't allow tasks
which cannot be run.  You say that you detest the new behaviors of
cpuset; however, the old behaviors were just as sucky - bouncing tasks
to an ancestor cgroup forcifully and without any indication or way to
restore the previous configuration.  What's different with the new
behavior is that it explicitly distinguishes between the configured
and effective configurations as the kernel isn't capable for actually
enforcing certain subset of configurations.

So, the inherent problem is always there no matter what we do and the
question is that of a policy to deal with it.  One of the main issues
I see with failing cgroup-level operations for controller specific
reasons is lack of visibility.  All you can get out of a failed
operation is a single error return and there's no good way to
communicate why something isn't working, well not even who's the
culprit.  Having "effective" vs "configured" makes it explicit that
the kernel isn't capable of honoring all configurations and make the
details of the situation visible.

Another part is inconsistencies across controllers.  This sure is
worse when there are multiple controllers involved but inconsistent
behaviors across different hierarchies are annoying all the same with
single controller multiple hierarchies.  Userland often manages some
of those hierarchies together and it can get horribly confusing.  No
matter what, we need to settle on a single policy and having effective
configuration seems like the better one.

> > One of the problems is that we generally assume that a task can run
> > some point in time in a lot of places in the kernel and can't just not
> > run a task indefinitely because it's in a cgroup configured certain
> > way.
> 
> Refusing tasks into a previously empty cgroup creates no such problems.
> Its already in a cgroup (wherever its parent was) and it can run there,
> failing to move it to another does not affect things.

Yeah, sure, hard failing can work too.  It didn't work well for cpuset
because a runnable configuration may become not so if the system
config changes afterwards but this probably doesn't have an issue like
that.  I'm not saying something like the above won't work.  It'd but I
don't think that's the right place to fail.

This controller might not even require the distinction between
configured and effective tho?  Can't a new child just inherit the
parent's configuration and never allow the config to become completely
empty?  The problem cpuset faces is that of underlying hardware
configuration changing.  This one doesn't have that.

> > > So either we fail mkdir, but that means allocating CLOS IDs for possibly
> > > empty cgroups, or we allocate on demand which means failing task
> > > assignment.
> > 
> > Can't fail mkdir or css enabling either.  Again, co-mounting and
> > unified hierarchy.  Also, the behavior is just horrible to use from
> > userland.
> 
> In order to fix the co-mounting and unified hierarchy I still need to
> hear a proposal for that tasks vs processes thing.
> 
> Traditionally the cgroups were task based, but many controllers are
> process based (simply because what they control is process wide, not per
> task), and there was talk (2-3 years ago or so) about making the entire
> cgroup thing per process, which obviously fails for all scheduler
> related cgroups.

Yeah, it needs to be a separate interface where a given userland task
can access its own knobs in a race-free way (cgroup interface can't
even do that) whether that's a pseudo filesystem, say,
/proc/self/BLAHBLAH or new syscalls.  This one is necessary regardless
of what happens with cgroup.  cgroup simply isn't a suitable mechanism
to expose these types of knobs to individual userland threads.

> > Yeah, RT is one of the main items which is problematic, more so
> > because it's currently coupled with the normal sched controller and
> > the default config doesn't have any RT slice. 
> 
> Simply because you cannot give a slice on creation; or if you did that
> would mean failing mkdir when a new cgroup would exceed the available
> time.
> 
> Also any !0 slice is wrong because it will not match the requirements of
> the proposed workload, the administrator will have to set it to match
> the workload.
> 
> Therefore 0.

As long as RT is separate from normal sched controller, this *could*
be fine.  The main problem now is that userland which wants to use the
cpu controller but doesn't want to fully manage RT slices end up
disabling RT slices.  It might work if a new child can share the
parent's slice till explicitly configured.  Another problem is when
you wanna change the configuration after the hierarchy is already
populated.  I don't know.  I'd even be happy with cgroup not having
anything to do with RT slice distribution.  Do you have any ideas
which can make RT slice distribution more palatable?  If we can't
decouple the two, we'd be effectively requiring whoever is managing
the cpu controller to also become a full-fledged RT slice arbitrator,
which might actually work too.

> > Do we completely block RT task w/o slice?  Is that okay?
> 
> We will not allow an RT task in, the write to the tasks file will fail.
> 
> The same will be true for deadline tasks, we'll fail entry into a cgroup
> when the combined requirements of the tasks exceed the provisions of the
> group.
> 
> There is just no way around that and still provide sane semantics.

Can't a task just lose RT / deadline properties when migrating into a
different RT / deadline domain?  We already modify task properties on
migration for cpuset after all.  It'd be far simpler that way.

Thanks.

-- 
tejun
