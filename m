Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636Ab3G2SRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:17:18 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:43091 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3G2SRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:17:15 -0400
Date: Mon, 29 Jul 2013 20:17:11 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: memcg creates an unkillable task in 3.2-rc2
Message-ID: <20130729181711.GA6174@dhcp22.suse.cz>
References: <20130723174711.GE21100@mtj.dyndns.org>
 <8761vui4cr.fsf@xmission.com>
 <20130729075939.GA4678@dhcp22.suse.cz>
 <87ehahg312.fsf@xmission.com>
 <20130729095109.GB4678@dhcp22.suse.cz>
 <20130729161026.GD22605@mtj.dyndns.org>
 <87r4eh70yg.fsf@xmission.com>
 <20130729172046.GI22605@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729172046.GI22605@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 29-07-13 13:20:46, Tejun Heo wrote:
> Hey, Eric.
> 
> On Mon, Jul 29, 2013 at 10:03:35AM -0700, Eric W. Biederman wrote:
> > So this is not a simple matter of a frozen task not dying when SIGKILL
> > is received.  For the most part not dying when SIGKILL is received seems
> > like correct behavior for a frozne task.  Certainly it is correct
> > behavior for any other signal.
> > 
> > The issue is that the tasks don't freeze or that when thawed the SIGKILL
> > is still ignored.  It seems a wake up is being missed in there somewhere.
> 
> That's actually interesting and shouldn't be happening.  Can you
> please provide more data as to what's going on while freezing?  It's
> likely that the problem is not caused by freezer per-se, the task
> might be stuck elsewhere and just fails to reach the freezing point.
> 
> Would it be possible for memcg and freezer to deadlock?

Hmm, all that memcg cares about is to have only one task to call oom
handler and put other tasks on the wait queue. If the memcg oom is
disabled, and supposed to be handled from the userspace, then all of
them are sitting on the wait queue.
All the waiters are woken up when there is an uncharge and/or after
mem_cgroup_out_of_memory has been called.

> Note that while freezing is in progress, some tasks will enter freezer
> earlier than others (of course) and won't respond to anything.  If
> memcg adds wait dependency among the tasks being frozen, it'll surely
> deadlock.

If memcg oom is enabled and the killed task is frozen then we might end
up with one task looping there until the oom victim is unfrozen. There
is no entry point to the fridge from the charging path so I believe that
memcg under oom might be unfreezable under certain conditions.

If the memcg is disabled, like in this case, then there shouldn't be any
way to deadlock or prevent from freezing unless there is an issue with
freezer vs. wait queue.

[...]
> > I am also seeing what looks like a leak somewhere in the cgroup code as
> > well.  After some runs of the same reproducer I get into a state where
> > after everything is clean up.  All of the control groups have been
> > removed and the cgroup filesystem is unmounted, I can mount a cgroup
> > filesystem with that same combindation of subsystems, but I can't mount
> > a cgroup filesystem with any of those subsystems in any other
> > combination.  So I am guessing that the superblock is from the original
> > mounting is still lingering for some reason.
> 
> Hmmm... yeah, if there are cgroups with refs remaining, that'd happen.
> Note that AFAIU memcg keeps the cgroups hangling around until all the
> pages are gone from it, so it could just be that it's still draining
> which may take a long time.

If the KMEM accounting is not enabled then all the charges will be gone
during offlining. Otherwise yes, it might take really long until slab
page will be freed.

> Maybe dropping cache would work?

KMEM is not used here so I do not think this would help.

-- 
Michal Hocko
SUSE Labs
