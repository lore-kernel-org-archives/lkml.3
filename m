Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3G3IUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:20:35 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:47043 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3G3IUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:20:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <cgroups@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <kent.overstreet@gmail.com>,
        Glauber Costa <glommer@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <51F71DE2.4020102@huawei.com> (Li Zefan's message of "Tue, 30 Jul
	2013 09:58:58 +0800")
References: <20130723174711.GE21100@mtj.dyndns.org>
	<8761vui4cr.fsf@xmission.com> <20130729075939.GA4678@dhcp22.suse.cz>
	<87ehahg312.fsf@xmission.com> <20130729095109.GB4678@dhcp22.suse.cz>
	<20130729161026.GD22605@mtj.dyndns.org> <87r4eh70yg.fsf@xmission.com>
	<51F71DE2.4020102@huawei.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Tue, 30 Jul 2013 01:19:31 -0700
Message-ID: <87ppu0a298.fsf_-_@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+cm7v7jioJZwmvkIMfeL07eI6TK74RDHk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4991]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Li Zefan <lizefan@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: memcg creates an unkillable task in 3.11-rc2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan <lizefan@huawei.com> writes:

>> I am also seeing what looks like a leak somewhere in the cgroup code as
>> well.  After some runs of the same reproducer I get into a state where
>> after everything is clean up.  All of the control groups have been
>> removed and the cgroup filesystem is unmounted, I can mount a cgroup
>> filesystem with that same combindation of subsystems, but I can't mount
>> a cgroup filesystem with any of those subsystems in any other
>> combination.  So I am guessing that the superblock is from the original
>> mounting is still lingering for some reason.
>> 
>
> If this happens again, you can check /proc/cgroups, 
>
> #subsys_name    hierarchy       num_cgroups     enabled
> cpuset  0       1       1
> debug   0       1       1
> cpu     0       1       1
> cpuacct 0       1       1
> memory  0       1       1
> devices 0       1       1
> freezer 0       1       1
> blkio   0       1       1
>
> If "hierachy" is not 0, then it didn't really unmounted. If "num_cgroups"
> is not 1, then there're some cgroups not really destroyed though they've
> been rmdired.

Interesting.  It looks at some point I had some cpu and cpuacct
hierarchies that never really unmounted.

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  0       1       1
cpu     89      1       1
cpuacct 89      1       1
memory  0       1       1
devices 0       1       1
freezer 0       1       1
net_cls 0       1       1
blkio   0       1       1
perf_event      0       1       1
hugetlb 0       1       1

And playing a little more I get the leak scenario.

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  0       1       1
cpu     90      3       1
cpuacct 90      3       1
memory  90      3       1
devices 0       1       1
freezer 90      3       1
net_cls 0       1       1
blkio   0       1       1
perf_event      0       1       1
hugetlb 0       1       1

So it definitely did not unmount.

After echo 3 > /proc/sys/vm/drop_caches

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  0       1       1
cpu     90      1       1
cpuacct 90      1       1
memory  90      1       1
devices 0       1       1
freezer 90      1       1
net_cls 0       1       1
blkio   0       1       1
perf_event      0       1       1
hugetlb 0       1       1

Hmm.  But after some time passes I have

#subsys_name    hierarchy       num_cgroups     enabled
cpuset  0       1       1
cpu     0       1       1
cpuacct 0       1       1
memory  0       1       1
devices 0       1       1
freezer 0       1       1
net_cls 0       1       1
blkio   0       1       1
perf_event      0       1       1
hugetlb 0       1       1

Hmm. Looking farther I see what is going on. And it has nothing to do
with the freezer. (I have commented out that code and reproduced it
without the freezer to be doubly certain).


On the exit path exit_robust_list is triggering a page fault to fault a
page back in.  Which since we have no memory causes the exit path
to get stuck in mem_cgroup_handle_oom.

Which means the following change should fix the hang.  I will test it in just
a second.

The problem is that we only handled pending fatal signals and exiting
processes when the OOM logic was enabled. Sigh.

Eric

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 00a7a66..5998a57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1792,16 +1792,6 @@ static void mem_cgroup_out_of_memory(struct mem_cgroup *memcg, gfp_t gfp_mask,
        unsigned int points = 0;
        struct task_struct *chosen = NULL;
 
-       /*
-        * If current has a pending SIGKILL or is exiting, then automatically
-        * select it.  The goal is to allow it to allocate so that it may
-        * quickly exit and free its memory.
-        */
-       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
-               set_thread_flag(TIF_MEMDIE);
-               return;
-       }
-
        check_panic_on_oom(CONSTRAINT_MEMCG, gfp_mask, order, NULL);
        totalpages = mem_cgroup_get_limit(memcg) >> PAGE_SHIFT ? : 1;
        for_each_mem_cgroup_tree(iter, memcg) {
@@ -2220,7 +2210,15 @@ static bool mem_cgroup_handle_oom(struct mem_cgroup *memcg, gfp_t mask,
                mem_cgroup_oom_notify(memcg);
        spin_unlock(&memcg_oom_lock);
 
-       if (need_to_kill) {
+       /*
+        * If current has a pending SIGKILL or is exiting, then automatically
+        * select it.  The goal is to allow it to allocate so that it may
+        * quickly exit and free its memory.
+        */
+       if (fatal_signal_pending(current) || current->flags & PF_EXITING) {
+               set_thread_flag(TIF_MEMDIE);
+               finish_wait(&memcg_oom_waitq, &owait.wait);
+       } else if (need_to_kill) {
                finish_wait(&memcg_oom_waitq, &owait.wait);
                mem_cgroup_out_of_memory(memcg, mask, order);
        } else {
