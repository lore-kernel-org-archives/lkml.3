Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821Ab3GaWJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 18:09:33 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:33464 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab3GaWJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 18:09:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Rientjes <rientjes@google.com>
References: <8761vui4cr.fsf@xmission.com>
	<20130729075939.GA4678@dhcp22.suse.cz> <87ehahg312.fsf@xmission.com>
	<20130729095109.GB4678@dhcp22.suse.cz>
	<20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
	<51F71DE2.4020102@huawei.com>
	<87ppu0a298.fsf_-_@tw-ebiederman.twitter.com>
	<20130730123120.GA15847@dhcp22.suse.cz>
	<874nbc3sx1.fsf@tw-ebiederman.twitter.com>
	<20130731073726.GC30514@dhcp22.suse.cz>
Date: Wed, 31 Jul 2013 15:09:16 -0700
In-Reply-To: <20130731073726.GC30514@dhcp22.suse.cz> (Michal Hocko's message
	of "Wed, 31 Jul 2013 09:37:26 +0200")
Message-ID: <87zjt2tm9f.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18u2QZaRa/SK4n5A230u0NjEHwfrRPxNFA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1191]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Michal Hocko <mhocko@suse.cz>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.11-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> [I am CCing David here as well]
>
> On Tue 30-07-13 09:37:46, Eric W. Biederman wrote:
>> Michal Hocko <mhocko@suse.cz> writes:
>> 
>> > On Tue 30-07-13 01:19:31, Eric W. Biederman wrote:
>> > [...]
>> >> Hmm. Looking farther I see what is going on. And it has nothing to do
>> >> with the freezer. (I have commented out that code and reproduced it
>> >> without the freezer to be doubly certain).
>> >> 
>> >> 
>> >> On the exit path exit_robust_list is triggering a page fault to fault a
>> >> page back in.  Which since we have no memory causes the exit path
>> >> to get stuck in mem_cgroup_handle_oom.
>> >
>> > Hmm, interesting. I assume the exit is caused by the SIGKILL, right?
>> > If yes, then why it hasn't coughed early in __mem_cgroup_try_charge
>> 
>> Interesting question.  This isn't the primary thread but we do send
>> SIGKILL to the secondary threads as well.
>> 
>> We definitely need those checks on both paths making my change valid.
>> 
>> Oh. Duh!  This is after we act on SIGKILL so SIGKILL is no longer
>> pending.
>
> Very well spotted Eric! What do you think about the following patch?
> I would have to check since when the exit path could trigger the fault
> but I guess this is worth stable backport.

It doesn't have a prayer of working.

You leave open the race of a fatal signal being received before we go to
sleep.

You don't handle a task that has processed the fatal signal and is in
PF_EXITING.  Which is what I experienced.

>From earlier comments about my code not being early enough I thought I
was going to see a patch in __mem_cgroup_try_change so that the bypass
case will kick in also for tasks in PF_EXITING.  You change actually
addresses things later in the code path than mine does.

I do like your summary of the problem.

Eric

> ---
> From 411408558f2858328ea25e69567e9a53a8314032 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Wed, 31 Jul 2013 08:48:54 +0200
> Subject: [PATCH] memcg: Do not hang on OOM when killed by userspace OOM
>
> Eric has reported that he can see task(s) stuck in memcg OOM handler
> regularly. The only way out is to
> 	echo 0 > $GROUP/memory.oom_controll
>
> His usecase is:
> - Setup a hierarchy with memory and the freezer
>   (disable kernel oom and have a process watch for oom).
> - In that memory cgroup add a process with one thread per cpu.
> - In one thread slowly allocate once per second I think it is 16M of ram
>   and mlock and dirty it (just to force the pages into ram and stay there).
> - When oom is achieved loop:
>   * attempt to freeze all of the tasks.
>   * if frozen send every task SIGKILL, unfreeze, remove the directory in
>     cgroupfs.
>
> Eric has then pinpointed the issue to be memcg specific.
>
> All tasks are sitting on the memcg_oom_waitq when memcg oom is disabled.
> Those that have received fatal signal will bypass the charge and should
> continue on their way out. The tricky part is that that exit path might
> trigger a page fault (e.g. exit_robust_list) thus the memcg charge
> while its memcg is still under OOM because nobody has released any
> charges. Unlike with the in-kernel OOM handler the exiting task doesn't
> get TIF_MEMDIE set so it doesn't shortcut charges and falls to the
> memcg OOM again without any way out of it as there are no fatal signals
> pending anymore.
>
> This patch sets the TIF_MEMDIE flag pro actively in mem_cgroup_handle_oom
> if the memcg is disabled after the task is woken up with fatal signal
> pending. This means that any further charges will be bypassed early in
> __mem_cgroup_try_charge and the task will have chance to exit finally.
>
> Strictly speaking we might mark also a task which hasn't been killed by
> userspace OOM handler but this is not harmful as the task is going away
> anyway and under-oom group would like to see it go as soon as possible.
>
> Reported-by: Eric W. Biederman <ebiederm@xmission.com>
> Debugged-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  mm/memcontrol.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d12ca6f..d4103b0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2235,8 +2235,19 @@ static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
>  
>  	mem_cgroup_unmark_under_oom(memcg);
>  
> -	if (test_thread_flag(TIF_MEMDIE) || fatal_signal_pending(current))
> +	if (test_thread_flag(TIF_MEMDIE))
>  		return false;
> +
> +	/*
> +	 * Userspace OOM killer might have killed this task but
> +	 * there is no way it could have set TIF_MEMDIE as well
> +	 * so we have to set it manually.
> +	 */
> +	if (fatal_signal_pending(current)) {
> +		if (memcg->oom_kill_disable)
> +			set_thread_flag(TIF_MEMDIE);
> +		return false;
> +	}
>  	/* Give chance to dying process */
>  	schedule_timeout_uninterruptible(1);
>  	return true;
> -- 
> 1.8.3.2
