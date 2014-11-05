Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaKEUl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:41:27 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:42608 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaKEUlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:41:25 -0500
Date: Wed, 5 Nov 2014 15:41:21 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141105204121.GA1158@htj.dyndns.org>
References: <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <20141030131845.GI3337@twins.programming.kicks-ass.net>
 <20141030170331.GB378@htj.dyndns.org>
 <20141030214353.GB12706@worktop.programming.kicks-ass.net>
 <20141030222236.GD378@htj.dyndns.org>
 <20141031130738.GE12706@worktop.programming.kicks-ass.net>
 <20141031155806.GA18792@htj.dyndns.org>
 <20141104131350.GQ3219@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104131350.GQ3219@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Tue, Nov 04, 2014 at 02:13:50PM +0100, Peter Zijlstra wrote:
> So there are scenarios where you want to hard fail the machine if the
> constraints are not met. Its better to just give up than to pretend.
> 
> This effective/requested split is policy, a hardcoded kernel policy. One
> that doesn't work for a number of cases. Fail and let userspace sort it
> out is a much safer option.

cpuset simply never implemented hard failing.  the old policy wasn't a
hard fail.  It did the same thing as applying the effective setting.
The only difference is that the process was irreversible.  The kind of
hard fail you're talking about would be rejecting CPU down command if
downing a CPU would create a non-executable cpuset, which would be a
silly conflation of layers.

> Some people want hard guarantees, if you're not willing to cater to them
> with cgroups they'll go off and invent yet more muck :/
> 
> Do you want to shut down the saw, or pretend its still controlled and
> loose your fingers because it missed a deadline?
> 
> Even HPC might not want to pretend continue, they might want to notify
> the jobs scheduler and get a different job split, rather than continue
> half-arsed. A persistent delay on the job completion barrier is way bad
> for them.

Again, we never had hard failures for cpuset.  The old behavior was
*more* surprising than the new one in that it was all implicit and the
actions taken were out of ordinary (no other controller action moves
tasks to other cgroups) and irreversible.  I agree with your point
that things should be as little surprising as possible but the facts
you're using aren't in support of that point.

One thing which is debatable is whether to allow configuring cpumasks
which make the effective set empty.  I don't think we fail that now
but failing that is completely fine and doesn't create discrepancies
with having configured and effective settings.

> > > Typically controllers don;'t control too many configs at once and the
> > > specific return error could be a good hint there.
> > 
> > Usually, yeah.  I still end up scratching my head with migration
> > rejections w/ cpuset or blkcg tho.
> 
> This means you already need to deal with this, so how about we try and
> make that work instead of saying we cannot fail migration.

My point is that failing these types of things at configuration time
is a lot better approach.  Everything sure is a trade-off but the
benefits here seem pretty clear to me.

> I never suggested dmesg, I was thinking of a cgroup.notifier file that
> reports all 'events' for that cgroup.
> 
> If you listen to it while performing your operation, you get the msgs:
> 
> $ cat cgroup.notifier & echo $pid > tasks ; kill -INT $!
> 
> Or something like that. Seeing how the entire cgroup thing is text
> based, this would end up spewing text like:
> 
> $cgroup-path failed attach $pid: $reason
> 
> Where everything is in the namespace of the observer; and if there is
> no namespace translation possible, drop the event, because you can't
> have seen or done anything anyhow.

Techcinally, we can do that or any number of other complex schemes but
isn't it obviously better if we can confine controller configuration
failures to actual configuration attemps.  Simple -errno failures
would be enough.

> > Yeah, I fully agree with you there.  The issue is not that RT/FIFO
> > requires explicit actions from userland but that they're currently
> > tied to BE scheduling.  Conceptually, they don't have to be but
> > they're in practice and that ends up requiring whoever, be that an
> > admin or automated tool, is managing the BE grouping to also manage
> > RT/FIFO slices, which isn't ideal but should be workable.  I was
> > mostly curious whether they can be separated with a reasonable amount
> > of effort.  That's a no, right?
> 
> What's a BE? Separating them is technically possible (painful maybe),
> but doesn't make any kind of sense to me.

Oops, best effort.  I was using a term from io scheduling.  Sorry
about that.  I meant fair_sched_class.

At least conceptually, the hierarchies of different scheduling classes
are orthogonal, so I was wondering whether separating them out would
be possible.  If that's not practically feasible, I don't think it's a
big problem.  Userland would just have to adapt to it.

> > Sure, we have no chance of changing it at this point, but I'm pretty
> > sure if we started by tying it to the process hierarchy, we and the
> > userland would have been able to achieve about the same set of
> > functionalities without all these migration business.
> 
> How would we do things like per-cgroup workqueues? We'd need to somehow
> spawn kthreads outside of the normal kthreadd hierarchy.

We can either have proxy kthreadd's or just reparent tasks once
they're created.  We already reparent after all.

> (this btw is something we need to sort, but lets not have that
> discussion here -- this email is getting too big as is).

I don't think discussing this is meaningful.  This train has left a
long time ago and I don't see any realistic chance of backtracking to
this route.

> Sure, agreed, we need more sanity there. I do however think we need to
> put in the effort to map out all use cases.

I've been doing that for over a year now.  I haven't mapped out *all*
use cases but I do have pretty clear ideas on what matters in
achieving the core functionalities.

> > Conceptually, doing so shouldn't be
> > impeded by or affect the resource configured for the parent of that
> > sub hierarchy
> 
> Uh what? No you want exactly that in a hierarchy. You want children to
> submit to the configuration of the parent.

You misunderstood.  Yes, children should submit to the configuration
of the parent but the act of merely creating a new child or moving
tasks there shouldn't deviate the configuration from what the parent
has.  Using CAT as an example, creating a child shouldn't create a new
configuration.  It should in effect have the same configuration as its
parent.  As such, moving tasks in there shouldn't fail as long as
tasks can be moved to the parent, which is a property we want to
maintain.  This is really fundamental - the operation of
sub-categorazation shouldn't affect controller configuration.  They
should and can remain orthogonal.

> > and for most controllers this can be achieved in a
> > straight-forward manner by making children not putting further
> > restrictions on the resources from its parent on creation.
> 
> The other way around, children can only put further restrictions on,
> they cannot relax restrictions from the parent.

I meant on creation.  Putting further restrictions is the only thing a
child can do but on creation it should have the same effective
configuration as its parent.

> > I think this is evident for the controller in question being discussed
> > on this thread.  Task organization - creating cgroups and moving tasks
> > around tasks between them - is an inherently different operation from
> > configuring each controller.  They shouldn't be conflated.  It doesn't
> > make any sense to fail creation of a cgroup or failing task migration
> > later because controller can't be configured certain way.  They should
> > be orthogonal as much as possible.  If there's restriction on
> > controller configuration, that should be enforced on controller
> > configuration.
> 
> I'd mostly agree with that, but note how you put it in relative terms
> :-)

But everything is relative.  At the moment we lose sight of that, we
lose the ability to make sensible and healthy trade-offs.  I could
have written the above in absolutes but I actively avoid that whenever
possible.
 
> I did give one (probably strained) example where putting the fail on the
> config side was more constrained than placing it at the migrate.

If you're referring to cpuset, it wasn't a good example.

> > I don't get it.  This is one of few cases where controller is
> > distributing hard-walled resources and as you said userland
> > intervention is a must in facilitating such distribution.  Isn't this
> > pretty well in line with what you've been saying?  The admin is moving
> > a RT / deadline task into a different scheduling domain and if such
> > operation always requires setting scheduling policies again, what's
> > surprising about it?
> 
> It would make cgroups useless. It would break running applications.
> You might as well not allow migration at all.

Task migrations will be a low-priority manegerial operation.  It's
mostly used to set up the initial hierarchy.  Tasks should be put in a
logical structure on startup and resource control changes should
happen through specific controller enable/disable and configuration
changes.  This is inherent in the unified hierarchy design and the
reason why controllers are individually enabled and disabled at each
level.  Task categorization is an orthogonal operation to resource
restriction.  Tasks are logically organized and resource controls are
dynamically configured over the logical structure.

So, yes, the role of migration is diminished in the unified hierarchy
and that's by design.  We can't go full static process hierarchy at
this point but this way we can get reasonably close while accomodating
gradual transition.

> But the very fact that migration would destroy configuration of an
> existing task would surprise me, I would -- like stated before -- much
> rather refuse the migration than destroy existing state.

I suppose this depends on the perspective but if the RT config is
reliably reset on migration, I don't see why it'd be surprising.  It's
a well-defined behavior which happens without exception and we already
have a precedence in changing per-task settings according to a task's
cgroup membership - cpuset overrides the cpu and node masks on
migration.

> By allowing an effective config different from the requested -- be it
> either using less CPUs than specified, or a different scheduling policy
> or the forced use of remote memory, you could have lost your finger
> before you can fix up.

I don't get why you're lumping the cpuset and cpu situations together.
They're different and cpu doesn't deal with any "effective" settings.

Thanks.

-- 
tejun
