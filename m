Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3IZXln (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:41:43 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51588 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IZXll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:41:41 -0400
MIME-Version: 1.0
In-Reply-To: <87ppu03td7.fsf@tw-ebiederman.twitter.com>
References: <20130723174711.GE21100@mtj.dyndns.org> <8761vui4cr.fsf@xmission.com>
 <20130729075939.GA4678@dhcp22.suse.cz> <87ehahg312.fsf@xmission.com>
 <20130729095109.GB4678@dhcp22.suse.cz> <20130729161026.GD22605@mtj.dyndns.org>
 <87r4eh70yg.fsf@xmission.com> <51F71DE2.4020102@huawei.com>
 <87ppu0a298.fsf_-_@tw-ebiederman.twitter.com> <87ppu03td7.fsf@tw-ebiederman.twitter.com>
From: Fabio Kung <fabio.kung@gmail.com>
Date: Thu, 26 Sep 2013 16:41:19 -0700
Message-ID: <CAHyO6Z33pUJ1_MjPO2OeUY_+ZRmc1niPiFm5DzGVDokm5vb4rw@mail.gmail.com>
Subject: Re: memcg creates an unkillable task in 3.11-rc2
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kent.overstreet@gmail.com,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 9:28 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> ebiederm@xmission.com (Eric W. Biederman) writes:
>
> Ok.  I have been trying for an hour and I have not been able to
> reproduce the weird hang with the memcg, and it used to be something I
> could reproduce trivially.  So it appears the patch below is the fix.
>
> After I sleep I will see if I can turn it into a proper patch.


Contributing with another data point: I am seeing similar issues with
un-killable tasks inside LXC containers on a vanilla 3.8.11 kernel.
The stack from zombie tasks look like this:

# cat /proc/12499/stack
[<ffffffff81186226>] __mem_cgroup_try_charge+0xa96/0xbf0
[<ffffffff8118670b>] __mem_cgroup_try_charge_swapin+0xab/0xd0
[<ffffffff8118678d>] mem_cgroup_try_charge_swapin+0x5d/0x70
[<ffffffff811524f5>] handle_pte_fault+0x315/0xac0
[<ffffffff81152f11>] handle_mm_fault+0x271/0x3d0
[<ffffffff815bbf3b>] __do_page_fault+0x20b/0x4c0
[<ffffffff815bc1fe>] do_page_fault+0xe/0x10
[<ffffffff815b8718>] page_fault+0x28/0x30
[<ffffffff81056327>] mm_release+0x127/0x140
[<ffffffff8105ece1>] do_exit+0x171/0xa70
[<ffffffff8105f635>] do_group_exit+0x55/0xd0
[<ffffffff8106fa8f>] get_signal_to_deliver+0x23f/0x5d0
[<ffffffff81014402>] do_signal+0x42/0x600
[<ffffffff81014a48>] do_notify_resume+0x88/0xc0
[<ffffffff815c0b92>] int_signal+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff

Same symptoms that Eric described: a race condition in memcg when
there is a page fault and the process is exiting.

I went ahead and reproduced the bug described earlier here on the same
3.8.11 kernel, also using the Mesos framework
(http://mesos.apache.org/) memory Ballooning tests. The call trace
from zombie tasks in this case look very similar:

# cat /proc/22827/stack
[<ffffffff81186280>] __mem_cgroup_try_charge+0xaf0/0xbf0
[<ffffffff8118670b>] __mem_cgroup_try_charge_swapin+0xab/0xd0
[<ffffffff8118678d>] mem_cgroup_try_charge_swapin+0x5d/0x70
[<ffffffff811524f5>] handle_pte_fault+0x315/0xac0
[<ffffffff81152f11>] handle_mm_fault+0x271/0x3d0
[<ffffffff815bbf3b>] __do_page_fault+0x20b/0x4c0
[<ffffffff815bc1fe>] do_page_fault+0xe/0x10
[<ffffffff815b8718>] page_fault+0x28/0x30
[<ffffffff81056327>] mm_release+0x127/0x140
[<ffffffff8105ece1>] do_exit+0x171/0xa70
[<ffffffff8105f635>] do_group_exit+0x55/0xd0
[<ffffffff8106fa8f>] get_signal_to_deliver+0x23f/0x5d0
[<ffffffff81014402>] do_signal+0x42/0x600
[<ffffffff81014a48>] do_notify_resume+0x88/0xc0
[<ffffffff815c0b92>] int_signal+0x12/0x17
[<ffffffffffffffff>] 0xffffffffffffffff

Then, I applied Eric's patch below, and I can't reproduce the problem
anymore. Before the patch, it was very easy to reproduce it with some
extra memory pressure from other processes in the instance (increasing
the probability of page faults when processes are exiting).

We also tried a vanilla 3.11.1 kernel, and we could reproduce the bug
on it pretty easily.

>
> Eric
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 00a7a66..5998a57 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -1792,16 +1792,6 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >         unsigned int points = 0;
> >         struct task_struct *chosen = NULL;
> >
> > -       /*
> > -        * If current has a pending SIGKILL or is exiting, then automatically
> > -        * select it.  The goal is to allow it to allocate so that it may
> > -        * quickly exit and free its memory.
> > -        */
> > -       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> > -               set_thread_flag(TIF_MEMDIE);
> > -               return;
> > -       }
> > -
> >         check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
> >         totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
> >         for_each_mem_cgroup_tree(iter, memcg) {
> > @@ -2220,7 +2210,15 @@ static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
> >                 mem_cgroup_oom_notify(memcg);
> >         spin_unlock(&memcg_oom_lock);
> >
> > -       if (need_to_kill) {
> > +       /*
> > +        * If current has a pending SIGKILL or is exiting, then automatically
> > +        * select it.  The goal is to allow it to allocate so that it may
> > +        * quickly exit and free its memory.
> > +        */
> > +       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
> > +               set_thread_flag(TIF_MEMDIE);
> > +               finish_wait(&memcg_oom_waitq, &owait.wait);
> > +       } else if (need_to_kill) {
> >                 finish_wait(&memcg_oom_waitq, &owait.wait);
> >                 mem_cgroup_out_of_memory(memcg, mask, order);
> >         } else {
> --
