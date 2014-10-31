Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759514AbaJaNIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 09:08:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:33554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbaJaNIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 09:08:02 -0400
Date: Fri, 31 Oct 2014 14:07:38 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141031130738.GE12706@worktop.programming.kicks-ass.net>
References: <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <20141030131845.GI3337@twins.programming.kicks-ass.net>
 <20141030170331.GB378@htj.dyndns.org>
 <20141030214353.GB12706@worktop.programming.kicks-ass.net>
 <20141030222236.GD378@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030222236.GD378@htj.dyndns.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 06:22:36PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Oct 30, 2014 at 10:43:53PM +0100, Peter Zijlstra wrote:
> > If a cpu bounces (by accident or whatever) then there is no trace left
> > behind that the system didn't in fact observe/obey its constraints. It
> > should have provided an error or failed the hotplug. But we digress,
> > lets not have this discussion (again :) and focus on the new thing.
> 
> Oh, we sure can have notifications / persistent markers to track
> deviation from the configuration.  It's not like the old scheme did
> much better in this respect.  It just wrecked the configuration
> without telling anyone.  If this matters enough, we need error
> recording / reporting no matter which way we choose.  I'm not against
> that at all.

True; then again, hotplug isn't a magical thing, you do it yourself --
with the suspend case being special, I'll grant you that.

> > > So, the inherent problem is always there no matter what we do and the
> > > question is that of a policy to deal with it.  One of the main issues
> > > I see with failing cgroup-level operations for controller specific
> > > reasons is lack of visibility.  All you can get out of a failed
> > > operation is a single error return and there's no good way to
> > > communicate why something isn't working, well not even who's the
> > > culprit.  Having "effective" vs "configured" makes it explicit that
> > > the kernel isn't capable of honoring all configurations and make the
> > > details of the situation visible.
> > 
> > Right, so that is a short coming of the co-mount idea. Your effective vs
> > configured thing is misleading and surprising though. Operations might
> > 'succeed' and still have failed, without any clear
> > indication/notification of change.
> 
> Hmmm... it gets more pronounced w/ co-mounting but it's also problem
> with isolated hierarchies too.  How is changing configuration
> irreversibly without any notificaiton any less surprising?  It's the
> same end result.  The only difference is that there's no way to go
> back when the resource which went offline comes back.  I really don't
> think configuration being silently changed counts as a valid
> notification mechanism to userland.

I think we're talking past one another here. You said the problem was
that failing migrate is that you've no clue which controller failed in
the co-mount case. With isolated hierarchies you do know.

But then you continue talk about cpuset and hotplug. Now the thing with
that is, the only one doing hotplug is the admin (I know there's a few
kernel side hotplug but they're BUGs and I even NAKed a few, which
didn't stop them from being merged) -- the exception being suspend,
suspend is special because 1) there's a guarantee the CPU will actually
come back and 2) its unobservable, userspace never sees the CPUs go away
and come back because its frozen.

The only real way to hotplug is if you do it your damn self, and its
also you who setup the cpuset, so its fully on you if shit happens.

No real magic there. Except now people seem to want to wrap it into
magic and hide it all from the admin, pretend its not there and make it
uncontrollable.

Kernel side hotplug is broken for a myriad of reasons, but lets not
diverge too far here.

> > > Another part is inconsistencies across controllers.  This sure is
> > > worse when there are multiple controllers involved but inconsistent
> > > behaviors across different hierarchies are annoying all the same with
> > > single controller multiple hierarchies.  Userland often manages some
> > > of those hierarchies together and it can get horribly confusing.  No
> > > matter what, we need to settle on a single policy and having effective
> > > configuration seems like the better one.
> > 
> > I'm not entirely sure I follow. Without co-mounting its entirely obvious
> > which one is failing.
> 
> Sure, "which" is easier w/o co-mounting.  Why can still be hard tho as
> migration is an "apply all the configs" event.

Typically controllers don;'t control too many configs at once and the
specific return error could be a good hint there.

> > Also, per the previous point, since you need a notification channel
> > anyway, you might as well do the expected fail and report more details
> > through that.
> 
> How do you match the failure to the specific migration attempt tho?  I
> really can't think of a good and simple interface for that given the
> interface that we have.  For most controllers, it is fairly straight
> forward to avoid controller specific migration failures.  Sure, cpuset
> is special but it has to be special one way or the other.

You can include in the msg with the pid that was just attempted in the
pid namespace of the observer, if the pid is not available in that
namespace discard the message since the observer could not possibly have
done the deed.

> It doesn't have much to do with co-mounting.
> 
> The process itself often has to be involved in assigning different
> properties to its threads.  It requires intimiate knowledge of which
> one is doing what meaning that accessing self's knobs is the most
> common use case rather than an external entity reaching inside.  This
> means that this should be a programmable interface accessible from
> each binary.  cgroup is horrible for this.  A process has to read path
> from /proc/self/cgroups and then access the cgroup that it's in, which
> BTW could have changed inbetween.
> 
> It really needs a proper programmable interface which guarantees self
> access.  I don't know what the exact form should be.  It can be an
> extension to sched_setattr(), a new syscall or a pseudo filesystem
> scoped to the process.

That's an entirely separate issue; and I don't see that solving the task
vs process issue at all.

> > The admin you mean? He had better know what the heck he's doing if he's
> 
> Resource management is automated in a lot of cases and it's only gonna
> be more so in the future.  It's about having behaviors which are more
> palatable to that but please read on.
> 
> > running RT apps, great fail is otherwise fairly deterministic in his
> > future.
> > 
> > The thing is, you cannot arbiter this stuff, RR/FIFO are horrible pieces
> > of shit interfaces, they don't describe near enough. People need to be
> > involved.
> 
> So, I think it'd be best if RT/deadline stuff can be separated out so
> that grouping the usual BE scheduling doesn't affect them, but if
> that's not feasible, yeah, I agree the only thing which we can do is
> requiring the entity which is controlling the cpu hierarchy, which may
> be a human admin or whatever manager, to distribute them explicitly.
> There doesn't seem to be any way around it.

Automation is nice and all, but RT is about providing determinism and
guarantees. Unless you morph into a full blown RT aware muddleware and
have all your RT apps communicate their requirements to it (ie. rewrite
them all) to it, this is a non starter.

Given that the RR/FIFO APIs are not communicating enough and we need to
support them anyhow, human intervention it is.

> > > Can't a task just lose RT / deadline properties when migrating into a
> > > different RT / deadline domain?  We already modify task properties on
> > > migration for cpuset after all.  It'd be far simpler that way.
> > 
> > Again, why move it in the first place? This all sounds like whomever is
> > doing this is clueless. You don't move RT tasks about if you're not
> > intimately aware of them and their requirements.
> 
> Oh, seriously, if I could build this thing from ground up, I'd just
> tie it to process hierarchy and make the associations static.

This thing being cgroups? I'm not sure static associations cater for the
various use cases that people have.

> It's
> just that we can't do that at this point and I'm trying to find a
> behaviorally simple and acceptable way to deal with task migrations so
> that neither kernel or userland has to be too complex.

Sure simple and consistent is all good, but we should also not make it
too simple and thereby exclude useful things.

> So, behaviors
> which blow configs across migrations and consider them as "fresh" is
> completely fine by me.

Its not by me, its completely surprising and counter intuitive.

> I mostly wanna avoid requiring complicated
> failure handling from the users which most likely won't be tested a
> lot and crap out when something exceptional happens. 

Smells like you just want to pretend nothing bad happens when you do
stupid. I prefer to fail early and fail hard over pretend happy and
surprise behaviour any day.

> This whole thing is really about having consistent behavior patterns
> which avoid obscure failure modes whenever possible.  Unified
> hierarchy does build on top of those but we do want these
> consistencies regardless of that.

I'm all for consistency, but I abhor make believe. And while I like the
unified hierarchy thing conceptually, I'm by now fairly sure reality is
about to ruin it.
