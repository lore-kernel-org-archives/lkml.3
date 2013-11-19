Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3KSXgT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 18:36:19 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:55984 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3KSXgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 18:36:14 -0500
MIME-Version: 1.0
In-Reply-To: <tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
References: <20131113151718.GN21461@twins.programming.kicks-ass.net>
	<tip-9abf24d465180f5f2eb26a43545348262f16b771@git.kernel.org>
Date: Tue, 19 Nov 2013 15:36:12 -0800
X-Google-Sender-Auth: IUbfrTHO5iJLaNbGBELYN8k0ARk
Message-ID: <CAE9FiQUk2Mr+4WypL41tCp3+54Aa+CT-17ga9+RffscUxwWAAg@mail.gmail.com>
Subject: Re: [tip:sched/urgent] sched: Check sched_domain before computing
 group power
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        srikar@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 11:15 AM, tip-bot for Srikar Dronamraju
<tipbot@zytor.com> wrote:
> Commit-ID:  9abf24d465180f5f2eb26a43545348262f16b771
> Gitweb:     http://git.kernel.org/tip/9abf24d465180f5f2eb26a43545348262f16b771
> Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> AuthorDate: Tue, 12 Nov 2013 22:11:26 +0530
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 19 Nov 2013 17:01:15 +0100
>
> sched: Check sched_domain before computing group power
>
> After commit 863bffc80898 ("sched/fair: Fix group power_orig
> computation"), we can dereference rq->sd before it is set.
>
> Fix this by falling back to power_of() in this case and add a comment
> explaining things.
>
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> [ Added comment and tweaked patch. ]
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Cc: mikey@neuling.org
> Link: http://lkml.kernel.org/r/20131113151718.GN21461@twins.programming.kicks-ass.net
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/fair.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e8b652e..fd773ad 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5379,10 +5379,31 @@ void update_group_power(struct sched_domain *sd, int cpu)
>                  */
>
>                 for_each_cpu(cpu, sched_group_cpus(sdg)) {
> -                       struct sched_group *sg = cpu_rq(cpu)->sd->groups;
> +                       struct sched_group_power *sgp;
> +                       struct rq *rq = cpu_rq(cpu);
>
> -                       power_orig += sg->sgp->power_orig;
> -                       power += sg->sgp->power;
> +                       /*
> +                        * build_sched_domains() -> init_sched_groups_power()
> +                        * gets here before we've attached the domains to the
> +                        * runqueues.
> +                        *
> +                        * Use power_of(), which is set irrespective of domains
> +                        * in update_cpu_power().
> +                        *
> +                        * This avoids power/power_orig from being 0 and
> +                        * causing divide-by-zero issues on boot.
> +                        *
> +                        * Runtime updates will correct power_orig.
> +                        */
> +                       if (unlikely(!rq->sd)) {
> +                               power_orig += power_of(cpu);
> +                               power += power_of(cpu);
> +                               continue;
> +                       }
> +
> +                       sgp = rq->sd->groups->sgp;
> +                       power_orig += sgp->power_orig;
> +                       power += sgp->power;
>                 }
>         } else  {
>                 /*

This one seems fix NULL reference in compute_group_power.

but get following on current Linus tree plus tip/sched/urgent.

divide error: 0000 [#1]  SMP
[   28.190477] Modules linked in:
[   28.192012] CPU: 11 PID: 484 Comm: kworker/u324:0 Not tainted
3.12.0-yh-10487-g4b94e59-dirty #2044
[   28.210488] Hardware name: Oracle Corporation  Sun Fire
[   28.229877] task: ffff88ff25205140 ti: ffff88ff2520a000 task.ti:
ffff88ff2520a000
[   28.236139] RIP: 0010:[<ffffffff810d9ff4>]  [<ffffffff810d9ff4>]
find_busiest_group+0x2b4/0x8a0
[   28.252075] RSP: 0000:ffff88ff2520b9a8  EFLAGS: 00010046
[   28.269591] RAX: 0000000000013fff RBX: 00000000ffffffff RCX: 00000000000000a0
[   28.272977] RDX: 0000000000000000 RSI: 0000000000014000 RDI: 0000000000000050
[   28.291968] RBP: ffff88ff2520bb08 R08: 00000000000003b6 R09: 0000000000000000
[   28.309327] R10: 0000000000000000 R11: 0000000000000002 R12: ffff88ff2520ba90
[   28.314222] R13: ffff887f2491c000 R14: 0000000000014000 R15: ffff88ff2520bba0
[   28.331408] FS:  0000000000000000(0000) GS:ffff887f7d800000(0000)
knlGS:0000000000000000
[   28.349333] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   28.351524] CR2: 0000000000000168 CR3: 0000000002c14000 CR4: 00000000000007e0
[   28.370245] Stack:
[   28.371466]  000000002520b9b8 000000000000000b 0000000000000048
0000000000000000
[   28.389951]  ffff887f2491c018 ffff88ff2520ba20 000000000000003c
00000000000002b6
[   28.395085]  00000000000002b6 00000000000002b6 0000000000002df0
0000000100000001
[   28.412079] Call Trace:
[   28.413617]  [<ffffffff810da798>] load_balance+0x1b8/0x8c0
[   28.429692]  [<ffffffff810ec67b>] ? __lock_acquire+0xadb/0xce0
[   28.433037]  [<ffffffff810db3c1>] idle_balance+0x101/0x1c0
[   28.450328]  [<ffffffff810db304>] ? idle_balance+0x44/0x1c0
[   28.453420]  [<ffffffff8214a13b>] __schedule+0x2cb/0xa10
[   28.469847]  [<ffffffff810e66d8>] ? trace_hardirqs_off_caller+0x28/0x160
[   28.473782]  [<ffffffff810e681d>] ? trace_hardirqs_off+0xd/0x10
[   28.490654]  [<ffffffff810d1c14>] ? local_clock+0x34/0x60
[   28.493723]  [<ffffffff810b837b>] ? worker_thread+0x2db/0x370
[   28.510363]  [<ffffffff8214f450>] ? _raw_spin_unlock_irq+0x30/0x40
[   28.514002]  [<ffffffff8214a935>] schedule+0x65/0x70
[   28.530380]  [<ffffffff810b8380>] worker_thread+0x2e0/0x370
[   28.533450]  [<ffffffff810ea19d>] ? trace_hardirqs_on+0xd/0x10
[   28.550976]  [<ffffffff810b80a0>] ? manage_workers.isra.17+0x330/0x330
[   28.554356]  [<ffffffff810bf598>] kthread+0x108/0x110
[   28.571857]  [<ffffffff810bf490>] ? __init_kthread_worker+0x70/0x70
[   28.588961]  [<ffffffff82157cec>] ret_from_fork+0x7c/0xb0
[   28.592017]  [<ffffffff810bf490>] ? __init_kthread_worker+0x70/0x70
[   28.609904] Code: 89 85 b8 fe ff ff 49 8b 45 10 41 8b 7d 0c 44 8b
50 08 44 8b 70 04 89 f8 48 c1 e0 0a 45 89 d1 49 8d 44 01 ff 48 89 c2
48 c1 fa 3f <49> f7 f9 31 d2 49 89 c1 89 f8 44 89 f7 41 f7 f1 48 81 c7
00 02
[   28.641210] RIP  [<ffffffff810d9ff4>] find_busiest_group+0x2b4/0x8a0
[   28.650476]  RSP <ffff88ff2520b9a8>
[   28.651754] divide error: 0000 [#2] [   28.651762] ---[ end trace
bcaaa28065586d41 ]---
