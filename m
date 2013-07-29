Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab3G2SGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:06:41 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57361 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3G2SGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:06:39 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
References: <20130723174711.GE21100@mtj.dyndns.org>
	<8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz>
	<87ehahg312.fsf@xmission.com> <20130729095109.GB4678@dhcp22.suse.cz>
	<20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
	<20130729172046.GI22605@mtj.dyndns.org>
Date: Mon, 29 Jul 2013 11:06:24 -0700
In-Reply-To: <20130729172046.GI22605@mtj.dyndns.org> (Tejun Heo's message of
	"Mon, 29 Jul 2013 13:20:46 -0400")
Message-ID: <8738qx1brz.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1840ThKGC7LHvvryh80EA0Jq0rizPRihT0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4938]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.2-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hey, Eric.
>
> On Mon, Jul 29, 2013 at 10:03:35AM -0700, Eric W. Biederman wrote:
>> So this is not a simple matter of a frozen task not dying when SIGKILL
>> is received.  For the most part not dying when SIGKILL is received seems
>> like correct behavior for a frozne task.  Certainly it is correct
>> behavior for any other signal.
>> 
>> The issue is that the tasks don't freeze or that when thawed the SIGKILL
>> is still ignored.  It seems a wake up is being missed in there somewhere.
>
> That's actually interesting and shouldn't be happening.  Can you
> please provide more data as to what's going on while freezing?  It's
> likely that the problem is not caused by freezer per-se, the task
> might be stuck elsewhere and just fails to reach the freezing point.

Barring some infrastructure noise what is happening is:

- Setup a hierarchy with memory and the freezer
  (disable kernel oom and have a process watch for oom).
- In that memory cgroup add a process with one thread per cpu.
- In one thread slowly allocate once persecond I think it is 16M of ram
  and mlock and dirty it (just to force the pages into ram and stay there).
- When oom is achieved loop:
  * attempt to freeze all of the tasks.
  * if frozen send every task SIGKILL, unfreeze, remove the directory in cgroupfs.

The log message I am seeing says that the freezing fails.

So I don't actually know what is delivering SIGKILL.  It may be the oom
situation is triguring it while we are attempting to freeze the tasks.

> Would it be possible for memcg and freezer to deadlock?  Note that
> while freezing is in progress, some tasks will enter freezer earlier
> than others (of course) and won't respond to anything.  If memcg adds
> wait dependency among the tasks being frozen, it'll surely deadlock.

There may be a livelock.  But I have been able to unstick the processes
by simply echo 0 > memory.oom_control.

There may be a race where a we haven't hit whatever is causing the
freezer to fail and a task is frozen SIGKILL is delivered.  The wakup is
ignored and then the unfreezing doesn't deliver it?

I need to explore some more.

>> A single unified hierarchy is a really nasty idea for the same set of
>> reasons. You have to recompile to disable a controller to see if it that
>> controller's bugs are what are causing problems on your production
>> system.  Compiles or even just a reboot is a very heavy hammer to ask
>> people to use when they are triaging a problem.
>
> For Nth time, unified hierarchy doesn't mean all controllers are
> enabled on all hierarchies or that controllers can't be bound and
> unbound dynamically.  Except for the removal of orthogonal
> hierarchies, things actually become a lot more dynamic.

Interesting.  So by unified hierarchy you just mean that the same
directory structure must exist for all mounts of cgroupfs?
If that is not it we can wait until Plumbers and hash it out in person.

All I am really concerned about right now is the ability to easily toss
out questionable controllers/subsystems without having to recompile or
reboot.

>> I am also seeing what looks like a leak somewhere in the cgroup code as
>> well.  After some runs of the same reproducer I get into a state where
>> after everything is clean up.  All of the control groups have been
>> removed and the cgroup filesystem is unmounted, I can mount a cgroup
>> filesystem with that same combindation of subsystems, but I can't mount
>> a cgroup filesystem with any of those subsystems in any other
>> combination.  So I am guessing that the superblock is from the original
>> mounting is still lingering for some reason.
>
> Hmmm... yeah, if there are cgroups with refs remaining, that'd happen.
> Note that AFAIU memcg keeps the cgroups hangling around until all the
> pages are gone from it, so it could just be that it's still draining
> which may take a long time.  Maybe dropping cache would work?

Good suggestion.  I will have to play with that.

I also saw one case where someone how the directory that described one
of these weird blocking tasks was removed.

Eric
