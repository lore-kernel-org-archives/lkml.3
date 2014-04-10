Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819AbaDJOEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:04:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbaDJOEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:04:34 -0400
Date: Thu, 10 Apr 2014 09:04:24 -0500
From: Serge Hallyn <serge.hallyn@ubuntu.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, gregkh@linuxfoundation.org,
        rlove@rlove.org, containers@lists.linux-foundation.org, kay@vrfy.org,
        linux-kernel@vger.kernel.org, lennart@poettering.net,
        cgroups@vger.kernel.org, eparis@parisplace.org, john@johnmccutchan.com
Subject: Re: [PATCH 3/3] cgroup: implement cgroup.subtree_populated for the
 default hierarchy
Message-ID: <20140410140424.GA4481@sergelap>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
 <1397056052-2829-4-git-send-email-tj@kernel.org>
 <20140410030855.GA29658@mail.hallyn.com>
 <20140410130831.GA25308@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410130831.GA25308@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Hey, Serge.
> 
> On Thu, Apr 10, 2014 at 05:08:55AM +0200, Serge E. Hallyn wrote:
> > Quoting Tejun Heo (tj@kernel.org):
> > > * It delivers events by forking and execing a userland binary
> > >   specified as the release_agent.  This is a long deprecated method of
> > >   notification delivery.  It's extremely heavy, slow and cumbersome to
> > >   integrate with larger infrastructure.
> > 
> > (Not seriously worried about this, but it's a point worth considering)
> > It does have one advantage though:  if the userspace agent goes bad,
> > cgroups can still be removed on empty.
> > 
> > Do you plan on keeping release-on-empty around?  I assume only for a
> > while?
> 
> The new mechanism is only for the unified hierarchy.  The old one will
> be kept around for other hierarchies.
> 
> > Do you think there is any value in having a simpler "remove-when-empty"
> > file?  Doesn't call out to userspace, just drops the cgroup when there
> > are no more tasks or sub-cgroups?
> 
> I don't think so.  Implementing such simplistic mechanism in userland
> is trivial and even independent failover mechanisms can be easily
> implemented from userland as multiple entities can set up watches.  I
> don't think there's much value in providing another mechanism from
> kernel side.  The only reason why release_agent thing got as complex
> as it is is because the mechanism is fundamentally flawed - clumsy
> delivery, no multiple watches, single watch point - so people tried to
> work around it by adding event filtering from kernel side, which is
> quite backwards IMHO.  With proper event mechanism, everything should
> be easily achievable from userland side.

Except for the keeping state.  If the userspace agent crashes when it
was meant to drop 100 cgroups when they become empty, then when it
restarts those 100 cgroups may never be freed.  Of course userspace
can do things about this, but it just seems like it would be so
trivial to handle this case in the kernel.  Like you say there is
no need for all the fancy agent spawning - just notice that the
cgroup became empty, that releaseonempty was true, and so unlink the
thing.  It'll be freed when anyone who has it held open closes it.

> > > * Events are filtered from the kernel side.  "notify_on_release" file
> > >   is used to subscribe to or suppres release event and events are not
> > >   generated if a cgroup becomes empty by moving the last task out of
> > >   it; however, event is generated if it becomes empty because the last
> > >   child cgroup is removed.  This is inconsistent, awkward and
> > 
> > Hm, maybe I'm misreading but this doesn't seem right.  If I move
> > a task into x1 and kill the task, x1 goes away.  Likewise if I
> > create x1/y1, and rmdir y1, x1 goes away.  I suspect I'm misunderstanding
> > the case in which you say it doesn't happen?
> 
> The case where you move a task out of x1/y1 to another cgroup doesn't
> generate an event.  One could say that that's unnecessary because the

Still confused.

If I create x1/y1 and x3/y3, set notify_on_release on x1 and x1/y1,
move a task into x1/y1, then move it to x3/y3, then x1/y1 and x1 both
do get removed.

> mover knows that the cgroup is becoming empty; however, it excludes
> any cases where there are more than one actors and the same can be
> said for cases when the actor is removing a child.
> 
> > > This patch implements interface file "cgroup.subtree_populated" which
> > > can be used to monitor whether the cgroup's subhierarchy has tasks in
> > > it or not.  Its value is 1 if there is no task in the cgroup and its
> > 
> > I think you meant this backward?  It's 1 if there is *any task in
> > the cgroup and its descendants, else 0?
> 
> Oops, yeap.  Will update.
> 
> Thanks!
> 
> -- 
> tejun
