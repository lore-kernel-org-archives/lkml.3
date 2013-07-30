Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab3G3QjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:39:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58918 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab3G3QjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:39:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
References: <20130723174711.GE21100@mtj.dyndns.org>
	<8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz>
	<87ehahg312.fsf@xmission.com> <20130729095109.GB4678@dhcp22.suse.cz>
	<20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
	<51F71DE2.4020102@huawei.com>
	<87ppu0a298.fsf_-_@tw-ebiederman.twitter.com>
	<20130730123120.GA15847@dhcp22.suse.cz>
Date: Tue, 30 Jul 2013 09:37:46 -0700
In-Reply-To: <20130730123120.GA15847@dhcp22.suse.cz> (Michal Hocko's message
	of "Tue, 30 Jul 2013 14:31:20 +0200")
Message-ID: <874nbc3sx1.fsf@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX195CzGXseOA53XKJqJkvZdNb8MLlNNPDYs=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: memcg creates an unkillable task in 3.11-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko <mhocko@suse.cz> writes:

> On Tue 30-07-13 01:19:31, Eric W. Biederman wrote:
> [...]
>> Hmm. Looking farther I see what is going on. And it has nothing to do
>> with the freezer. (I have commented out that code and reproduced it
>> without the freezer to be doubly certain).
>> 
>> 
>> On the exit path exit_robust_list is triggering a page fault to fault a
>> page back in.  Which since we have no memory causes the exit path
>> to get stuck in mem_cgroup_handle_oom.
>
> Hmm, interesting. I assume the exit is caused by the SIGKILL, right?
> If yes, then why it hasn't coughed early in __mem_cgroup_try_charge

Interesting question.  This isn't the primary thread but we do send
SIGKILL to the secondary threads as well.

We definitely need those checks on both paths making my change valid.

Oh. Duh!  This is after we act on SIGKILL so SIGKILL is no longer
pending.

That is how it makes it through __mem_cgroup_try_charge.


>> Which means the following change should fix the hang.  I will test it in just
>> a second.
>> 
>> The problem is that we only handled pending fatal signals and exiting
>> processes when the OOM logic was enabled. Sigh.
>
> If this is about PF_EXITING then we should handle that earlier in the
> code chain (__mem_cgroup_try_charge sounds like a proper place). Let me
> think about that.

We also need to test for fatal signals before we sleep in both boths of
mem_cgroup_out_of_memory.  But yes testing for this condition earlier
so we don't have to do a lot of work before we get out would not be a
bad thing.

Eric


>
> Thanks for debugging this!
>
>> Eric
>> 
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 00a7a66..5998a57 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -1792,16 +1792,6 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>         unsigned int points = 0;
>>         struct task_struct *chosen = NULL;
>>  
>> -       /*
>> -        * If current has a pending SIGKILL or is exiting, then automatically
>> -        * select it.  The goal is to allow it to allocate so that it may
>> -        * quickly exit and free its memory.
>> -        */
>> -       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
>> -               set_thread_flag(TIF_MEMDIE);
>> -               return;
>> -       }
>> -
>>         check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
>>         totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
>>         for_each_mem_cgroup_tree(iter, memcg) {
>> @@ -2220,7 +2210,15 @@ static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
>>                 mem_cgroup_oom_notify(memcg);
>>         spin_unlock(&memcg_oom_lock);
>>  
>> -       if (need_to_kill) {
>> +       /*
>> +        * If current has a pending SIGKILL or is exiting, then automatically
>> +        * select it.  The goal is to allow it to allocate so that it may
>> +        * quickly exit and free its memory.
>> +        */
>> +       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
>> +               set_thread_flag(TIF_MEMDIE);
>> +               finish_wait(&memcg_oom_waitq, &owait.wait);
>> +       } else if (need_to_kill) {
>>                 finish_wait(&memcg_oom_waitq, &owait.wait);
>>                 mem_cgroup_out_of_memory(memcg, mask, order);
>>         } else {
