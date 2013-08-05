Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699Ab3HETQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:16:49 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62492 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649Ab3HETQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:16:46 -0400
Date: Mon, 5 Aug 2013 21:16:41 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, bsingharora@gmail.com,
        kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET cgroup/for-3.12] cgroup: make cgroup_event specific to
 memcg
Message-ID: <20130805191641.GA24003@dhcp22.suse.cz>
References: <1375632446-2581-1-git-send-email-tj@kernel.org>
 <20130805160107.GM10146@dhcp22.suse.cz>
 <20130805162958.GF19631@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805162958.GF19631@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 05-08-13 12:29:58, Tejun Heo wrote:
> Hello, Michal.
> 
> On Mon, Aug 05, 2013 at 06:01:07PM +0200, Michal Hocko wrote:
> > Could you be more specific about what is so "overboard" about this
> > interface? I am not familiar with internals much, so I cannot judge the
> > complexity part, but I thought that eventfd was intended for this kind
> > of kernel->userspace notifications.
> 
> It's just way over-engineered like many other things in cgroup, most
> likely misguided by the appearance that cgroup could be delegated and
> accessed by multiple actors concurrently.

I keep hearing that over and over. And I also keep hearing that there
are users who do not like many simplifications because they are breaking
their usecases. Users are those who matter to me. Hey some of them are
even sane...

> The most clear example would be the vmpressure event.  When it could
> have just called fsnotify_modify() unconditionally when the state
> changes, now it involves parsing, dynamic list of events and so on
> without actually adding any benefits.

I am neither author nor user of this interface but my understanding is
that there are different requirements from different usecases and it
would be hard to satisfy them without having a way for userspace
to tell the kernel what it is interested in. There was a discussion
about edge vs. all-events triggered signaling recently for example.

Besides that, is fsnotify really an interface to be used under memory
pressure? I might be wrong but from a quick look fsnotify depends on
GFP_KERNEL allocation which would be no-go for oom_control at least.
How does the reclaim context gets to struct file to notify? I am pretty
sure we would get to more and more questions when digging further.

I am all for simplifications, but removing interfaces just because you
feel they are "over-done" is not a way to go IMHO. In this particular
case you are removing an interface from cgroup core which has users,
and will have to support them for very long time. "It is just memcg
so move it there" is not a way that different subsystems should work
together and I am _not_ going to ack such a move. All the flexibility that
you are so complaining about is hidden from the cgroup core in register
callbacks and the rest is only the core infrastructure (registration and
unregistration).

And btw. a common notification interface at least makes things
consistent and prevents controllers to invent their one purpose
solutions.

So I am really skeptical about this patch set. It doesn't give anything.
It just moves a code which you do not like out of your sight hoping that
something will change.

There were mistakes done in the past. And some interfaces are really too
flexible but that doesn't mean we should be militant about everything.

> For the usage ones, configurability makes some sense but even then
> just giving it a single array of event points of limited size would be
> sufficient.

This would be a question for users. I am not one of those so I cannot
tell you but I certainly cannot claim that something more coarse would
be sufficient either.

> It's just way over-done.

> > So you think that vmpressure, oom notification or thresholds are
> > an abuse of this interface? What would you consider a reasonable
> > replacement for those notifications?  Or do you think that controller
> > shouldn't be signaling any conditions to the userspace at all?
> 
> I don't think the ability to generate events are an abuse, just that
> the facility itself is way over-engineered.  Just generate a file
> changed event unconditionally for vmpressure and oom and maybe
> implement configureable cadence or single set of threshold array for
> threshold events.  These are things which can and should be done in a
> a few tens of lines of code with far simpler interface. 

These are strong words without any justification.

[...]
-- 
Michal Hocko
SUSE Labs
