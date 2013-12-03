Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3LCQxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:53:32 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:49243 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab3LCQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:53:30 -0500
MIME-Version: 1.0
In-Reply-To: <20131202152423.GA10878@redhat.com>
References: <20131202152423.GA10878@redhat.com>
From: William Dauchy <wdauchy@gmail.com>
Date: Tue, 3 Dec 2013 17:53:09 +0100
Message-ID: <CAJ75kXYu943GxQpKGkpfmAj87YKbr1aoPu60zozik1MCkK7gag@mail.gmail.com>
Subject: Re: [PATCH 0/2] initial while_each_thread() fixes
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sameer Nanda <snanda@chromium.org>, Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Oleg,

On Mon, Dec 2, 2013 at 4:24 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> This was reported several times, I believe the first report is
> http://marc.info/?l=linux-kernel&m=127688978121665. Hmm, 3 years
> ago. The lockless while_each_thread() is racy and broken, almost
> every user can loop forever.
>
> Recently people started to report they actually hit this problem in
> oom_kill.c. This doesn't really matter and I can be wrong, but in
> fact I do not think they really hit this race, it is very unlikely.
> Another problem with while_each_thread() is that it is very easy
> to use it wrongly, and oom_kill.c is the good example.
>
> I came to conclusion that it is practically impossible to send a
> single series which fixes all problems, too many different users.
>
> So 1/2 adds the new for_each_thread() interface, and 2/2 fixes oom
> kill as an example.
>
> We obviously need a lot more changes like 2/2 before we can kill
> while_each_thread() and task_struct->thread_group, but I hope they
> will be straighforward. And in fact I hope that task->thread_group
> can go away before we change all users of while_each_thread().
>
> David, et al, I din't actually test 2/2, I do not know how. Please
> review, although it looks simple.

I was wondering if this patch was also targeted for stable branch?
Before this patch, I was testing this one
https://lkml.org/lkml/2013/11/13/336 which is fixing my oom issues.

I applied the two patches on top of a 3.10.x and got some tasks
stalled after the first OOM:

php5-fpm invoked oom-killer: gfp_mask=0xd0, order=0, oom_score_adj=0
php5-fpm cpuset=VM_X mems_allowed=0-1
CPU: 21 PID: 28256 Comm: php5-fpm Not tainted 3.10.22 #1
Hardware name: Dell Inc. PowerEdge C8220/0TDN55, BIOS 1.1.17 01/09/2013
 ffffc9001e3c9000 ffff881fbacbfbe8 ffffffff81569220 ffff881fbacbfc88
 ffffffff815662f1 ffff882011bb4800 0000000000020000 ffff881fbacbfc28
 ffffffff8156d133 0000000000000206 0000000000000206 ffff881f00000000
Call Trace:
 [<ffffffff81569220>] dump_stack+0x19/0x21
 [<ffffffff815662f1>] dump_header+0x7a/0x26c
 [<ffffffff8156d133>] ? preempt_schedule+0x33/0x50
 [<ffffffff8156e597>] ? _raw_spin_unlock_irqrestore+0x67/0x70
 [<ffffffff8124b026>] ? ___ratelimit+0xa6/0x130
 [<ffffffff810cb2b0>] oom_kill_process+0x2a0/0x440
 [<ffffffff8104e0f0>] ? has_capability+0x20/0x20
 [<ffffffff8111c8bd>] mem_cgroup_oom_synchronize+0x59d/0x5c0
 [<ffffffff8111bbc0>] ? mem_cgroup_charge_common+0xa0/0xa0
 [<ffffffff810cbc03>] pagefault_out_of_memory+0x13/0x90
 [<ffffffff81564022>] mm_fault_error+0xb8/0x19b
 [<ffffffff8102b073>] __do_page_fault+0x543/0x5b0
 [<ffffffff8156c6ac>] ? __schedule+0x3dc/0xd90
 [<ffffffff8107c970>] ? hrtick_update+0x70/0x70
 [<ffffffff8109be27>] ? SyS_futex+0x97/0x2f0
 [<ffffffff8156f21a>] ? retint_swapgs_pax+0xd/0x12
 [<ffffffff81252621>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff8102b119>] do_page_fault+0x9/0x20
 [<ffffffff8156f4c8>] page_fault+0x38/0x40
Task in /lxc/VM_X killed as a result of limit of /lxc/VM_X
memory: usage 254644kB, limit 262144kB, failcnt 38594
memory+swap: usage 524288kB, limit 524288kB, failcnt 803
kmem: usage 0kB, limit 9007199254740991kB, failcnt 0
Memory cgroup stats for /lxc/VM_X: cache:196KB rss:252116KB
rss_huge:4096KB mapped_file:164KB swap:274236KB inactive_anon:124788KB
active_anon:124332KB inactive_file:0KB active_file:0KB unevictable:0KB
[ pid ]   uid  tgid total_vm      rss nr_ptes swapents oom_score_adj name
[16017]     0 16017     4444      336      14       94             0 paas-start
[18020]  5101 18020    64126     2113      57     4645         -1000 mysqld
[19162]  5000 19162    87663      463     122     1396             0 php5-fpm
[19216]  5001 19216    24156      473      51      444             0 apache2
[20257]  5001 20257   176880      656     122     2600             0 apache2
[20353]     0 20353     1023      108       8       21             0 sleep
[27746]  5000 27746    90454     1025     139     4316             0 php5-fpm
[28176]  5000 28176   348410    59568     547    53877             0 php5-fpm
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
t=15014 jiffies, g=65569, c=65568, q=6537)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
t=60019 jiffies, g=65569, c=65568, q=15632)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
t=105024 jiffies, g=65569, c=65568, q=32303)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
t=150029 jiffies, g=65569, c=65568, q=43552)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 5,
t=195034 jiffies, g=65569, c=65568, q=194557)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
t=240039 jiffies, g=65569, c=65568, q=205866)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
t=285044 jiffies, g=65569, c=65568, q=238233)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 21,
t=330049 jiffies, g=65569, c=65568, q=274925)
INFO: Stall ended before state dump start
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 5,
t=375054 jiffies, g=65569, c=65568, q=297436)
INFO: Stall ended before state dump start

-- 
William
