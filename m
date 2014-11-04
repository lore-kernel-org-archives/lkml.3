Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaKDNOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:14:05 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48502 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaKDNOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:14:00 -0500
Date: Tue, 4 Nov 2014 14:13:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141104131350.GQ3219@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <20141030131845.GI3337@twins.programming.kicks-ass.net>
 <20141030170331.GB378@htj.dyndns.org>
 <20141030214353.GB12706@worktop.programming.kicks-ass.net>
 <20141030222236.GD378@htj.dyndns.org>
 <20141031130738.GE12706@worktop.programming.kicks-ass.net>
 <20141031155806.GA18792@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031155806.GA18792@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 11:58:06AM -0400, Tejun Heo wrote:
> > No real magic there. Except now people seem to want to wrap it into
> > magic and hide it all from the admin, pretend its not there and make it
> > uncontrollable.
> 
> Hmmm... I think a difference is how we perceive userspace is composed
> and interacts with the various aspects of kernel.  But even in the
> presence of a competent admin that you're suggesting, interactions of
> different aspects of a system are often compartmentalized.  e.g. an
> admin configuring cpuset to accomodate a given set of persistent and
> important workload isn't too likely to expect a memory unit soft
> failure in several weeks and the need to hot-swap the memory module.
> It just isn't cost-effective enough to lump those two planes of
> planning into the same activity especially if the admin is
> hand-crafting the configuration.  The issue that I see with the
> current method is that a much rare exception condition ends up messing
> up configurations which is on a different plane and that there's no
> recourse once that happens.  If the said workload keeps forking,
> there's no easy way to recover the previous configuration.
> 
> Both ways of handling the situation have components of surprise but as
> I wrote before that surprise is inherent and comes from the fact that
> the kernel can't afford tasks which aren't runnable.  As a policy of
> handling the surprising situation, having explicit configured /
> effective settings seems like a better option to me because 1. it
> makes it explicit that the effective configuration may differ from the
> requested one 2. it makes handling exception cases easier.  I think #1
> is important because hard errors which rarely but do happen are very
> difficult to deal with properly because it's usually nearly invisible.

So there are scenarios where you want to hard fail the machine if the
constraints are not met. Its better to just give up than to pretend.

This effective/requested split is policy, a hardcoded kernel policy. One
that doesn't work for a number of cases. Fail and let userspace sort it
out is a much safer option.

Some people want hard guarantees, if you're not willing to cater to them
with cgroups they'll go off and invent yet more muck :/

Do you want to shut down the saw, or pretend its still controlled and
loose your fingers because it missed a deadline?

Even HPC might not want to pretend continue, they might want to notify
the jobs scheduler and get a different job split, rather than continue
half-arsed. A persistent delay on the job completion barrier is way bad
for them.

> > Typically controllers don;'t control too many configs at once and the
> > specific return error could be a good hint there.
> 
> Usually, yeah.  I still end up scratching my head with migration
> rejections w/ cpuset or blkcg tho.

This means you already need to deal with this, so how about we try and
make that work instead of saying we cannot fail migration.

> > You can include in the msg with the pid that was just attempted in the
> > pid namespace of the observer, if the pid is not available in that
> > namespace discard the message since the observer could not possibly have
> > done the deed.
> 
> I don't know.  Is that a good interface?  If a human admin is echoing
> and dmesg'ing afterwards, it should work but scraping the log for an
> unstructured plain text error usually isn't a very good interface to
> build tools around.
> 
> For example, for CAT and its limit on the numbers of possible
> configurations, it can technically be made to work by reporting errors
> on mkdir or task migration; however, it is *far* better and clearer to
> report, say, -ENOSPC when you're actually trying to change the
> configuration.  The error is directly tied to the operation requested.
> That's just how it should be whenever possible.

I never suggested dmesg, I was thinking of a cgroup.notifier file that
reports all 'events' for that cgroup.

If you listen to it while performing your operation, you get the msgs:

$ cat cgroup.notifier & echo $pid > tasks ; kill -INT $!

Or something like that. Seeing how the entire cgroup thing is text
based, this would end up spewing text like:

$cgroup-path failed attach $pid: $reason

Where everything is in the namespace of the observer; and if there is
no namespace translation possible, drop the event, because you can't
have seen or done anything anyhow.

> > That's an entirely separate issue; and I don't see that solving the task
> > vs process issue at all.
> 
> Hmm... I don't see it that way tho.  In-process configuration is
> primarily something to be done by the process while cgroup management
> is to be done by external adminy entity.  They are on different
> planes.  Individual binaries accessing their own cgroups doesn't make
> a lot of sense and is actually broken.  Likewise, external management
> entity meddling with individual threads of a process is at best
> cumbersome.  It can be allowed but that's often not how it's useful.
> I really don't see why cgroup would be involved with per-thread
> settings.

Well, people are doing it now. And it 'works' if you assume nobody is
going to do 'crazy' things behind your back, which is a fair assumption
(most of the time).

Its just that some people seem hell bend on doing crazy things behind
your back in the name of progress or whatnot ;-) Take one would be
making sure this background crap can be shot in the head.

I'm not arguing against an atomic interface, I'm just saying its not
required for useful things.

> > Automation is nice and all, but RT is about providing determinism and
> > guarantees. Unless you morph into a full blown RT aware muddleware and
> > have all your RT apps communicate their requirements to it (ie. rewrite
> > them all) to it, this is a non starter.
> > 
> > Given that the RR/FIFO APIs are not communicating enough and we need to
> > support them anyhow, human intervention it is.
> 
> Yeah, I fully agree with you there.  The issue is not that RT/FIFO
> requires explicit actions from userland but that they're currently
> tied to BE scheduling.  Conceptually, they don't have to be but
> they're in practice and that ends up requiring whoever, be that an
> admin or automated tool, is managing the BE grouping to also manage
> RT/FIFO slices, which isn't ideal but should be workable.  I was
> mostly curious whether they can be separated with a reasonable amount
> of effort.  That's a no, right?

What's a BE? Separating them is technically possible (painful maybe),
but doesn't make any kind of sense to me.

> > > Oh, seriously, if I could build this thing from ground up, I'd just
> > > tie it to process hierarchy and make the associations static.
> > 
> > This thing being cgroups? I'm not sure static associations cater for the
> > various use cases that people have.
> 
> Sure, we have no chance of changing it at this point, but I'm pretty
> sure if we started by tying it to the process hierarchy, we and the
> userland would have been able to achieve about the same set of
> functionalities without all these migration business.

How would we do things like per-cgroup workqueues? We'd need to somehow
spawn kthreads outside of the normal kthreadd hierarchy.

(this btw is something we need to sort, but lets not have that
discussion here -- this email is getting too big as is).

> > Sure simple and consistent is all good, but we should also not make it
> > too simple and thereby exclude useful things.
> 
> What are we excluding tho?

Hard guarantees it seems.

> Previously, cgroup didn't have rules,
> policies or conventions.  It just had this skeletal features to group
> tasks and every controller did its own thing diverging the way they
> treat hierarchies, errors, migrations, configurations, notifications
> and so on.  It didn't put in the effort to actually identify the
> required functionalities or characterize what belongs where.  Every
> controller was doing its own brownian motion in the design space.

Sure, agreed, we need more sanity there. I do however think we need to
put in the effort to map out all use cases.

> Most of the properties being identified and policies being set up are
> actually fundamental and inherent.  e.g. Creating a subhierarchy and
> organizing the children in them is fundamentally a task
> sub-categorizing operation. 

> Conceptually, doing so shouldn't be
> impeded by or affect the resource configured for the parent of that
> sub hierarchy

Uh what? No you want exactly that in a hierarchy. You want children to
submit to the configuration of the parent.

> and for most controllers this can be achieved in a
> straight-forward manner by making children not putting further
> restrictions on the resources from its parent on creation.

The other way around, children can only put further restrictions on,
they cannot relax restrictions from the parent.

> I think this is evident for the controller in question being discussed
> on this thread.  Task organization - creating cgroups and moving tasks
> around tasks between them - is an inherently different operation from
> configuring each controller.  They shouldn't be conflated.  It doesn't
> make any sense to fail creation of a cgroup or failing task migration
> later because controller can't be configured certain way.  They should
> be orthogonal as much as possible.  If there's restriction on
> controller configuration, that should be enforced on controller
> configuration.

I'd mostly agree with that, but note how you put it in relative terms
:-)

I did give one (probably strained) example where putting the fail on the
config side was more constrained than placing it at the migrate.

> > > So, behaviors
> > > which blow configs across migrations and consider them as "fresh" is
> > > completely fine by me.
> > 
> > Its not by me, its completely surprising and counter intuitive.
> 
> I don't get it.  This is one of few cases where controller is
> distributing hard-walled resources and as you said userland
> intervention is a must in facilitating such distribution.  Isn't this
> pretty well in line with what you've been saying?  The admin is moving
> a RT / deadline task into a different scheduling domain and if such
> operation always requires setting scheduling policies again, what's
> surprising about it?

It would make cgroups useless. It would break running applications.
You might as well not allow migration at all.

But the very fact that migration would destroy configuration of an
existing task would surprise me, I would -- like stated before -- much
rather refuse the migration than destroy existing state.

> It makes conceptual sense - the task is moving across two scheduling
> domains with different set of hard resources.  It'd work well and
> reliably too in practice and userland only has one less vector of
> failure while achieving the same thing.

No its absolutely certified insane is what. It introduces a massive ton
of fail. Tasks that were running fine and predictable are then all of a
sudden a complete trainwreck.

> > Smells like you just want to pretend nothing bad happens when you do
> > stupid. I prefer to fail early and fail hard over pretend happy and
> > surprise behaviour any day.
> 
> But where am I losing anything?  I'm not saying everything is always
> better this way but if I look at the overall compromises, it seems
> like a clear win to me.

You allow the creation of fail and want to mop up the pieces afterwards
-- if at all possible. I want to avoid the creation of fail.

By allowing an effective config different from the requested -- be it
either using less CPUs than specified, or a different scheduling policy
or the forced use of remote memory, you could have lost your finger
before you can fix up.

Would it not be better to keep your finger?
