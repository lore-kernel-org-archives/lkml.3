Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804Ab3FVXOG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 19:14:06 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:58987 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3FVXOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 19:14:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
References: <20130406012159.GA17159@mtj.dyndns.org> <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org> <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
From: Tim Hockin <thockin@hockin.org>
Date: Sat, 22 Jun 2013 16:13:41 -0700
X-Google-Sender-Auth: b8cRk9J6tnWEY3HPtMffwRbloQw
Message-ID: <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
Subject: Re: cgroup: status-quo and userland efforts
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>, bsingharora <bsingharora@gmail.com>,
        "dhaval.giani" <dhaval.giani@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, jpoimboe <jpoimboe@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        lpoetter <lpoetter@redhat.com>,
        workman-devel <workman-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm very sorry I let this fall off my plate.  I was pointed at a
systemd-devel message indicating that this is done.  Is it so?  It
seems so completely ass-backwards to me. Below is one of our use-cases
that I just don't see how we can reproduce in a single-heierarchy.
We're also long into the model that users can control their own
sub-cgroups (moderated by permissions decided by admin SW up front).

We have classes of jobs which can run together on shared machines.  This is
VERY important to us, and is a key part of how we run things.  Over the years
we have evolved from very little isolation to fairly strong isolation, and
cgroups are a large part of that.

We have experienced and adapted to a number of problems around isolation over
time.  I won't go into the history of all of these, because it's not so
relevant, but here is how we set things up today.

>From a CPU perspective, we have two classes of jobs: production and batch.
Production jobs can (but don't always) ask for exclusive cores, which ensures
that no batch work runs on those CPUs.  We manage this with the cpuset cgroup.
Batch jobs are relegated to the set of CPUs that are "left-over" after
exclusivity rules are applied.  This is implemented with a shared subdirectory
of the cpuset cgroup called "batch".  Production jobs get their own
subdirectories under cpuset.

>From an IO perspective we also have two classes of jobs: normal and
DTF-approved.  Normal jobs do not get strong isolation for IO, whereas
DTF-enabled jobs do.  The vast majority of jobs are NOT DTF-enabled, and they
share a nominal amount of IO bandwidth.  This is implemented with a shared
subdirectory of the io cgroup called "default".  Jobs that are DTF-enabled get
their own subdirectories under IO.

This gives us 4 combinations:
  1) { production, DTF }
  2) { production, non-DTF }
  3) { batch, DTF }
  4) { batch non-DTF }

Of these, (3) is sort of nonsense, but the others are actually used
and needed.  This is only
possible because of split hierarchies.  In fact, we undertook a very painful
process to move from a unified cgroup hierarchy to split hierarchies in large
part _because of_ these examples.

And for more fun, I am simplifying this all. Batch jobs are actually bound to
NUMA-node specific cpuset cgroups when possible.  And we have a similar
concept for the cpu cgroup as for cpuset.  And we have a third tier of IO
jobs.  We don't do all of this for fun - it is in direct response to REAL
problems we have experienced.

Making cgroups composable allows us to build a higher level abstraction that
is very powerful and flexible.  Moving back to unified hierarchies goes
against everything that we're doing here, and will cause us REAL pain.


On Mon, Apr 22, 2013 at 3:33 PM, Tim Hockin <thockin@hockin.org> wrote:
> On Mon, Apr 22, 2013 at 11:41 PM, Tejun Heo <tj@kernel.org> wrote:
>> Hello, Tim.
>>
>> On Mon, Apr 22, 2013 at 11:26:48PM +0200, Tim Hockin wrote:
>>> We absolutely depend on the ability to split cgroup hierarchies.  It
>>> pretty much saved our fleet from imploding, in a way that a unified
>>> hierarchy just could not do.  A mandated unified hierarchy is madness.
>>>  Please step away from the ledge.
>>
>> You need to be a lot more specific about why unified hierarchy can't
>> be implemented.  The last time I asked around blk/memcg people in
>> google, while they said that they'll need different levels of
>> granularities for different controllers, google's use of cgroup
>> doesn't require multiple orthogonal classifications of the same group
>> of tasks.
>
> I'll pull some concrete examples together.  I don't have them on hand,
> and I am out of country this week.  I have looped in the gang at work
> (though some are here with me).
>
>> Also, cgroup isn't dropping multiple hierarchy support over-night.
>> What has been working till now will continue to work for very long
>> time.  If there is no fundamental conflict with the future changes,
>> there should be enough time to migrate gradually as desired.
>>
>>> More, going towards a unified hierarchy really limits what we can
>>> delegate, and that is the word of the day.  We've got a central
>>> authority agent running which manages cgroups, and we want out of this
>>> business.  At least, we want to be able to grant users a set of
>>> constraints, and then let them run wild within those constraints.
>>> Forcing all such work to go through a daemon has proven to be very
>>> problematic, and it has been great now that users can have DIY
>>> sub-cgroups.
>>
>> Sorry, but that doesn't work properly now.  It gives you the illusion
>> of proper delegation but it's inherently dangerous.  If that sort of
>> illusion has been / is good enough for your setup, fine.  Delegate at
>> your own risks, but cgroup in itself doesn't support delegation to
>> lesser security domains and it won't in the foreseeable future.
>
> We've had great success letting users create sub-cgroups in a few
> specific controller types (cpu, cpuacct, memory).  This is, of course,
> with some restrictions.  We do not just give them blanket access to
> all knobs.  We don't need ALL cgroups, just the important ones.
>
> For a simple example, letting users create sub-groups in freezer or
> job (we have a job group that we've been carrying) lets them launch
> sub-tasks and manage them in a very clean way.
>
> We've been doing a LOT of development internally to make user-defined
> sub-memcgs work in our cluster scheduling system, and it's made some
> of our biggest, more insane users very happy.
>
> And for some cgroups, like cpuset, hierarchy just doesn't really make
> sense to me.  I just don't care if that never works, though I have no
> problem with others wanting it. :)   Aside: if the last CPU in your
> cpuset goes offline, you should go into a state akin to freezer.
> Running on any other CPU is an overt violation of policy that the
> user, or worse - the admin, set up.  Just my 2cents.
>
>>> Strong disagreement, here.  We use split hierarchies to great effect.
>>> Containment should be composable.  If your users or abstractions can't
>>> handle it, please feel free to co-mount the universe, but please
>>> PLEASE don't force us to.
>>>
>>> I'm happy to talk more about what we do and why.
>>
>> Please do so.  Why do you need multiple orthogonal hierarchies?
>
> Look for this in the next few days/weeks.  From our point of view,
> cgroups are the ideal match for how we want to manage things (no
> surprise, really, since Mr. Menage worked on both).
>
> Tim
