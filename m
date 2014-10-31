Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222AbaJaP6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:58:30 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33265 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694AbaJaP62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:58:28 -0400
Date: Fri, 31 Oct 2014 11:58:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141031155806.GA18792@htj.dyndns.org>
References: <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
 <20141030131845.GI3337@twins.programming.kicks-ass.net>
 <20141030170331.GB378@htj.dyndns.org>
 <20141030214353.GB12706@worktop.programming.kicks-ass.net>
 <20141030222236.GD378@htj.dyndns.org>
 <20141031130738.GE12706@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031130738.GE12706@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Fri, Oct 31, 2014 at 02:07:38PM +0100, Peter Zijlstra wrote:
> I think we're talking past one another here. You said the problem was
> that failing migrate is that you've no clue which controller failed in
> the co-mount case. With isolated hierarchies you do know.

Yes, with co-mounting, the issue becomes worse but I think it's still
not ideal even without co-mounting because the error reporting ends up
conflating task organization operation and application of
configurations.  More on this later.

> But then you continue talk about cpuset and hotplug. Now the thing with
> that is, the only one doing hotplug is the admin (I know there's a few
> kernel side hotplug but they're BUGs and I even NAKed a few, which
> didn't stop them from being merged) -- the exception being suspend,
> suspend is special because 1) there's a guarantee the CPU will actually
> come back and 2) its unobservable, userspace never sees the CPUs go away
> and come back because its frozen.
> 
> The only real way to hotplug is if you do it your damn self, and its
> also you who setup the cpuset, so its fully on you if shit happens.
>
> No real magic there. Except now people seem to want to wrap it into
> magic and hide it all from the admin, pretend its not there and make it
> uncontrollable.

Hmmm... I think a difference is how we perceive userspace is composed
and interacts with the various aspects of kernel.  But even in the
presence of a competent admin that you're suggesting, interactions of
different aspects of a system are often compartmentalized.  e.g. an
admin configuring cpuset to accomodate a given set of persistent and
important workload isn't too likely to expect a memory unit soft
failure in several weeks and the need to hot-swap the memory module.
It just isn't cost-effective enough to lump those two planes of
planning into the same activity especially if the admin is
hand-crafting the configuration.  The issue that I see with the
current method is that a much rare exception condition ends up messing
up configurations which is on a different plane and that there's no
recourse once that happens.  If the said workload keeps forking,
there's no easy way to recover the previous configuration.

Both ways of handling the situation have components of surprise but as
I wrote before that surprise is inherent and comes from the fact that
the kernel can't afford tasks which aren't runnable.  As a policy of
handling the surprising situation, having explicit configured /
effective settings seems like a better option to me because 1. it
makes it explicit that the effective configuration may differ from the
requested one 2. it makes handling exception cases easier.  I think #1
is important because hard errors which rarely but do happen are very
difficult to deal with properly because it's usually nearly invisible.

> > Sure, "which" is easier w/o co-mounting.  Why can still be hard tho as
> > migration is an "apply all the configs" event.
> 
> Typically controllers don;'t control too many configs at once and the
> specific return error could be a good hint there.

Usually, yeah.  I still end up scratching my head with migration
rejections w/ cpuset or blkcg tho.

> > > Also, per the previous point, since you need a notification channel
> > > anyway, you might as well do the expected fail and report more details
> > > through that.
> > 
> > How do you match the failure to the specific migration attempt tho?  I
> > really can't think of a good and simple interface for that given the
> > interface that we have.  For most controllers, it is fairly straight
> > forward to avoid controller specific migration failures.  Sure, cpuset
> > is special but it has to be special one way or the other.
> 
> You can include in the msg with the pid that was just attempted in the
> pid namespace of the observer, if the pid is not available in that
> namespace discard the message since the observer could not possibly have
> done the deed.

I don't know.  Is that a good interface?  If a human admin is echoing
and dmesg'ing afterwards, it should work but scraping the log for an
unstructured plain text error usually isn't a very good interface to
build tools around.

For example, for CAT and its limit on the numbers of possible
configurations, it can technically be made to work by reporting errors
on mkdir or task migration; however, it is *far* better and clearer to
report, say, -ENOSPC when you're actually trying to change the
configuration.  The error is directly tied to the operation requested.
That's just how it should be whenever possible.

> > It really needs a proper programmable interface which guarantees self
> > access.  I don't know what the exact form should be.  It can be an
> > extension to sched_setattr(), a new syscall or a pseudo filesystem
> > scoped to the process.
> 
> That's an entirely separate issue; and I don't see that solving the task
> vs process issue at all.

Hmm... I don't see it that way tho.  In-process configuration is
primarily something to be done by the process while cgroup management
is to be done by external adminy entity.  They are on different
planes.  Individual binaries accessing their own cgroups doesn't make
a lot of sense and is actually broken.  Likewise, external management
entity meddling with individual threads of a process is at best
cumbersome.  It can be allowed but that's often not how it's useful.
I really don't see why cgroup would be involved with per-thread
settings.

> Automation is nice and all, but RT is about providing determinism and
> guarantees. Unless you morph into a full blown RT aware muddleware and
> have all your RT apps communicate their requirements to it (ie. rewrite
> them all) to it, this is a non starter.
> 
> Given that the RR/FIFO APIs are not communicating enough and we need to
> support them anyhow, human intervention it is.

Yeah, I fully agree with you there.  The issue is not that RT/FIFO
requires explicit actions from userland but that they're currently
tied to BE scheduling.  Conceptually, they don't have to be but
they're in practice and that ends up requiring whoever, be that an
admin or automated tool, is managing the BE grouping to also manage
RT/FIFO slices, which isn't ideal but should be workable.  I was
mostly curious whether they can be separated with a reasonable amount
of effort.  That's a no, right?

> > Oh, seriously, if I could build this thing from ground up, I'd just
> > tie it to process hierarchy and make the associations static.
> 
> This thing being cgroups? I'm not sure static associations cater for the
> various use cases that people have.

Sure, we have no chance of changing it at this point, but I'm pretty
sure if we started by tying it to the process hierarchy, we and the
userland would have been able to achieve about the same set of
functionalities without all these migration business.

> > It's
> > just that we can't do that at this point and I'm trying to find a
> > behaviorally simple and acceptable way to deal with task migrations so
> > that neither kernel or userland has to be too complex.
> 
> Sure simple and consistent is all good, but we should also not make it
> too simple and thereby exclude useful things.

What are we excluding tho?  Previously, cgroup didn't have rules,
policies or conventions.  It just had this skeletal features to group
tasks and every controller did its own thing diverging the way they
treat hierarchies, errors, migrations, configurations, notifications
and so on.  It didn't put in the effort to actually identify the
required functionalities or characterize what belongs where.  Every
controller was doing its own brownian motion in the design space.

Most of the properties being identified and policies being set up are
actually fundamental and inherent.  e.g. Creating a subhierarchy and
organizing the children in them is fundamentally a task
sub-categorizing operation.  Conceptually, doing so shouldn't be
impeded by or affect the resource configured for the parent of that
sub hierarchy and for most controllers this can be achieved in a
straight-forward manner by making children not putting further
restrictions on the resources from its parent on creation.  This is a
rule which should be inherent and this type of conventions ultimately
lead to better designs and implementations.

I think this is evident for the controller in question being discussed
on this thread.  Task organization - creating cgroups and moving tasks
around tasks between them - is an inherently different operation from
configuring each controller.  They shouldn't be conflated.  It doesn't
make any sense to fail creation of a cgroup or failing task migration
later because controller can't be configured certain way.  They should
be orthogonal as much as possible.  If there's restriction on
controller configuration, that should be enforced on controller
configuration.

> > So, behaviors
> > which blow configs across migrations and consider them as "fresh" is
> > completely fine by me.
> 
> Its not by me, its completely surprising and counter intuitive.

I don't get it.  This is one of few cases where controller is
distributing hard-walled resources and as you said userland
intervention is a must in facilitating such distribution.  Isn't this
pretty well in line with what you've been saying?  The admin is moving
a RT / deadline task into a different scheduling domain and if such
operation always requires setting scheduling policies again, what's
surprising about it?

It makes conceptual sense - the task is moving across two scheduling
domains with different set of hard resources.  It'd work well and
reliably too in practice and userland only has one less vector of
failure while achieving the same thing.

> > I mostly wanna avoid requiring complicated
> > failure handling from the users which most likely won't be tested a
> > lot and crap out when something exceptional happens. 
> 
> Smells like you just want to pretend nothing bad happens when you do
> stupid. I prefer to fail early and fail hard over pretend happy and
> surprise behaviour any day.

But where am I losing anything?  I'm not saying everything is always
better this way but if I look at the overall compromises, it seems
like a clear win to me.

> > This whole thing is really about having consistent behavior patterns
> > which avoid obscure failure modes whenever possible.  Unified
> > hierarchy does build on top of those but we do want these
> > consistencies regardless of that.
> 
> I'm all for consistency, but I abhor make believe. And while I like the
> unified hierarchy thing conceptually, I'm by now fairly sure reality is
> about to ruin it.

Hmm... I get exactly the opposite feeling.  A lot of fundamental
properties are being identified and things mostly fall into places.

Thanks.

-- 
tejun
