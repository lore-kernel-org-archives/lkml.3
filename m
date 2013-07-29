Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab3G2RDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:03:53 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:49454 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3G2RDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:03:49 -0400
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
	<20130729161026.GD22605@mtj.dyndns.org>
Date: Mon, 29 Jul 2013 10:03:35 -0700
In-Reply-To: <20130729161026.GD22605@mtj.dyndns.org> (Tejun Heo's message of
	"Mon, 29 Jul 2013 12:10:26 -0400")
Message-ID: <87r4eh70yg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/Xd6mgoqWsSVdJIFjp3WHzxQxhJaIPVr4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4991]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.2-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Mon, Jul 29, 2013 at 11:51:09AM +0200, Michal Hocko wrote:
>> Isn't this a bug in freezer then? I am not familiar with the freezer
>> much but memcg oom handling seems correct to me. The task is sleeping
>> KILLABLE and fatal_signal_pending in mem_cgroup_handle_oom will tell us
>> to bypass the charge and let the taks go away.
>
> Is the problem a frozen task not being killed even when SIGKILL is
> received?  If so, it is a known problem and a side-effect of
> cgroup_freezer (ab)using and making the existing power management
> freezer visible to userland without really thinking about the
> implications.  :(

Something like that.  I need to look at it in a little more detail.
The idiom someone adopted to atomically kill all of the tasks in a
cgroup is to.  Freeze all of the tasks.  Send them SIGKILL. unfreeze
all of the tasks.

The freezing actually fails in this case so I don't know what is
happening.

So this is not a simple matter of a frozen task not dying when SIGKILL
is received.  For the most part not dying when SIGKILL is received seems
like correct behavior for a frozne task.  Certainly it is correct
behavior for any other signal.

The issue is that the tasks don't freeze or that when thawed the SIGKILL
is still ignored.  It seems a wake up is being missed in there somewhere.

> So, yeah, if you use cgroup_freezer now, the tasks will get stuck in
> states which aren't well defined when visible from userland and will
> just stay there until unfrozen no matter what.  Yet another reason
> I'll be screaming like a banshee at anyone who says that cgroup is
> built to delegate subtree access rights to !root users.

Yes.  From the looks of the looks of it the cgroup implementation is
rather badly borked right now, and definitely not up to the standards of
the other core pieces of the kernel.  One of the reasons I was rather
apalled when systemd started using them.  Until the code actually works
reliably and the races are removed most people's systems would be much
better off with cgroups compiled out.

A single unified hierarchy is a really nasty idea for the same set of
reasons. You have to recompile to disable a controller to see if it that
controller's bugs are what are causing problems on your production
system.  Compiles or even just a reboot is a very heavy hammer to ask
people to use when they are triaging a problem.

That said semantically having more than single process controls for all
of user space are very desirable.  Until we have code that is safe to
use giving it any additional exposure seems like a bad idea.

> It's on the to-do list but a very long term one.  Right now, if you
> combine userland OOM handling with freezer and whatnot, it'd be pretty
> easy to get into trouble.

Thanks for the heads up.  Right now this is looking like a regression
but it might just be that my test machine has the right combination
of racying pixies to trigger a long standing bug.


I am also seeing what looks like a leak somewhere in the cgroup code as
well.  After some runs of the same reproducer I get into a state where
after everything is clean up.  All of the control groups have been
removed and the cgroup filesystem is unmounted, I can mount a cgroup
filesystem with that same combindation of subsystems, but I can't mount
a cgroup filesystem with any of those subsystems in any other
combination.  So I am guessing that the superblock is from the original
mounting is still lingering for some reason.

Eric
