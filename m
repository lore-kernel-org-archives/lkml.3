Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994Ab3G3Q3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:29:17 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35524 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3G3Q26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:28:58 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kent.overstreet@gmail.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <87ppu0a298.fsf_-_@tw-ebiederman.twitter.com> (Eric
	W. Biederman's message of "Tue, 30 Jul 2013 01:19:31 -0700")
References: <20130723174711.GE21100@mtj.dyndns.org>
	<8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz>
	<87ehahg312.fsf@xmission.com> <20130729095109.GB4678@dhcp22.suse.cz>
	<20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
	<51F71DE2.4020102@huawei.com>
	<87ppu0a298.fsf_-_@tw-ebiederman.twitter.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 30 Jul 2013 09:28:04 -0700
Message-ID: <87ppu03td7.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18rZJzh7ULLKY02PQZ0s/jJnwXlSmIyn6g=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2303]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Li Zefan <lizefan@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.11-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

Ok.  I have been trying for an hour and I have not been able to
reproduce the weird hang with the memcg, and it used to be something I
could reproduce trivially.  So it appears the patch below is the fix.

After I sleep I will see if I can turn it into a proper patch.

Eric

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 00a7a66..5998a57 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1792,16 +1792,6 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
>         unsigned int points = 0;
>         struct task_struct *chosen = NULL;
>  
> -       /*
> -        * If current has a pending SIGKILL or is exiting, then automatically
> -        * select it.  The goal is to allow it to allocate so that it may
> -        * quickly exit and free its memory.
> -        */
> -       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> -               set_thread_flag(TIF_MEMDIE);
> -               return;
> -       }
> -
>         check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
>         totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
>         for_each_mem_cgroup_tree(iter, memcg) {
> @@ -2220,7 +2210,15 @@ static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
>                 mem_cgroup_oom_notify(memcg);
>         spin_unlock(&memcg_oom_lock);
>  
> -       if (need_to_kill) {
> +       /*
> +        * If current has a pending SIGKILL or is exiting, then automatically
> +        * select it.  The goal is to allow it to allocate so that it may
> +        * quickly exit and free its memory.
> +        */
> +       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> +               set_thread_flag(TIF_MEMDIE);
> +               finish_wait(&memcg_oom_waitq, &owait.wait);
> +       } else if (need_to_kill) {
>                 finish_wait(&memcg_oom_waitq, &owait.wait);
>                 mem_cgroup_out_of_memory(memcg, mask, order);
>         } else {
