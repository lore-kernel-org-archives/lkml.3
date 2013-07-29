Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab3G2IyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 04:54:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:38952 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3G2IyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 04:54:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Hocko <mhocko@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
References: <20130723174711.GE21100@mtj.dyndns.org>
	<8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz>
Date: Mon, 29 Jul 2013 01:54:01 -0700
In-Reply-To: <20130729075939.GA4678@dhcp22.suse.cz> (Michal Hocko's message of
	"Mon, 29 Jul 2013 09:59:39 +0200")
Message-ID: <87ehahg312.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/TAjoR52TnfctFqXZYpZiH+aK33dPNJOQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 T_FRT_BELOW2 BODY: ReplaceTags: Below (2)
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3327]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michal Hocko <mhocko@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.2-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Sun 28-07-13 17:42:28, Eric W. Biederman wrote:
>> Tejun Heo <tj@kernel.org> writes:
>> 
>> > Hello, Linus.
>> >
>> > This pull request contains two patches, both of which aren't fixes
>> > per-se but I think it'd be better to fast-track them.
>> >
>> Darn.  I was hoping to see a fix for the bug I just tripped over,
>> that results in a process stuck in short term disk wait.
>> 
>> Using the memory control group for it's designed function aka killing
>> processes that eats too much memory I just would up with an unkillable
>> process in 3.11-rc2.
>
> How many processes are in that group? Could you post stacks for all of
> them? Is the stack bellow stable?

Just this one, and yes the stack is stable.
And there was a pending sigkill.  Which is what is so bizarre.

> Could you post dmesg output?

Nothing interesting was in dmesg.

I lost the original hang but I seem to be able to reproduce it fairly
easily.

echo 0 > memory.oom_control is enough to unstick it.  But that does not
explain why the process does not die when SIGKILL is sent.

> You seem to have CONFIG_MEMCG_KMEM enabled. Have you set up kmem
> limit?

No kmem limits set.

>> I am really not certain what is going on although I haven't rebooted the
>> machine yet so I can look a bit further if someone has a good idea.
>> 
>> On the unkillable task I see.
>> 
>> /proc/<pid>/stack:
>> 
>> [<ffffffff8110342c>] mem_cgroup_iter+0x1e/0x1d2
>> [<ffffffff81105630>] __mem_cgroup_try_charge+0x779/0x8f9
>> [<ffffffff81070d46>] ktime_get_ts+0x36/0x74
>> [<ffffffff81104d84>] memcg_oom_wake_function+0x0/0x5a
>> [<ffffffff8110620c>] __mem_cgroup_try_charge_swapin+0x6c/0xac
>
> Hmm, mem_cgroup_handle_oom should be setting up the task for wait queue
> so the above is a bit confusing.

The mem_cgroup_iter looks like it is somethine stale on the stack.
The __mem_cgroup_try_charge is immediately after the schedule in
mem_cgroup_handle_oom.

I have played with it a little bit and added
	if (!fatal_signal_pending(current))
		schedule();

On the off chance that it was an ordering thing that was triggering
this.  And that does not seem to be the problem in this instance.
The missing test before the schedule still looks wrong.

> Anyway your group seems to be under OOM and the task is in the middle of
> mem_cgroup_handle_oom which tries to kill something. That something is
> probably not willing to die so this task will loop trying to charge the
> memory until something releases a charge or the limit for the group is
> increased.

And it is configured so that the manager process needs to send SIGKILL
instead of having the kernel pick a random process.

> It would be interesting to see what other tasks are doing. We are aware
> of certain deadlock situations where memcg OOM killer tries to kill a
> task which is blocked on a lock (e.g. i_mutex) which is held by a task
> which is trying to charge but failing due to oom.

The only other weird thing that I see going on is the manager process
tries to freeze the entire cgroup, kill the processes, and the unfreeze
the cgroup and the freeze is failing.  But looking at /proc/<pid>/status
there was a SIGKILL pending.

Given how easy it was to wake up the process when I reproduced this
I don't think there is anything particularly subtle going on.  But
somehow we are going to sleep having SIGKILL delivered and not waking
up.  The not waking up bugs me.

> Johannes (added to CC) has a patchset which deals with this long term
> issue http://www.kernelhub.org/?p=2&msg=300518

That does look interesting.

Eric
