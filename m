Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab3LISKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 13:10:46 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33511 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753885Ab3LISKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 13:10:44 -0500
Date: Mon, 9 Dec 2013 18:10:42 +0000
From: Hedi Berriche <hedi@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, srikar@linux.vnet.ibm.com
Subject: [Regression] sched: division by zero in find_busiest_group()
Message-ID: <20131209181042.GA6771@dangermouse.emea.sgi.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, peterz@infradead.org,
	srikar@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

The following panic occurs *early* at boot time on high *enough* CPU count
machines:

divide error: 0000 [#1] SMP 
Modules linked in:
CPU: 22 PID: 1146 Comm: kworker/22:0 Not tainted 3.13.0-rc2-00122-gdea4f48 #8
Hardware name: Intel Corp. Stoutland Platform, BIOS 2.20 UEFI2.10 PI1.0 X64 2013-09-20
task: ffff8827d49f31c0 ti: ffff8827d4a18000 task.ti: ffff8827d4a18000
RIP: 0010:[<ffffffff810a345b>]  [<ffffffff810a345b>] find_busiest_group+0x26b/0x890
RSP: 0000:ffff8827d4a19b68  EFLAGS: 00010006
RAX: 0000000000007fff RBX: 0000000000008000 RCX: 0000000000000200
RDX: 0000000000000000 RSI: 0000000000008000 RDI: 0000000000000020
RBP: ffff8827d4a19cc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff8827d4a19d28 R14: ffff8827d4a19b98 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8827dfd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00000000000000b8 CR3: 00000000018da000 CR4: 00000000000007e0
Stack:
ffff8827d4b35800 0000000000000000 0000000000014600 0000000000014600
0000000000000000 ffff8827d4b35818 0000000000000000 0000000000000000
0000000000000000 0000000000000000 0000000000008000 0000000000000000
Call Trace:
[<ffffffff810a3be6>] load_balance+0x166/0x7f0
[<ffffffff810a477e>] idle_balance+0x10e/0x1b0
[<ffffffff815d83d3>] __schedule+0x723/0x780
[<ffffffff815d8459>] schedule+0x29/0x70
[<ffffffff810818b9>] worker_thread+0x1c9/0x400
[<ffffffff810816f0>] ? rescuer_thread+0x3e0/0x3e0
[<ffffffff81088562>] kthread+0xd2/0xf0
[<ffffffff81088490>] ? kthread_create_on_node+0x180/0x180
[<ffffffff815e437c>] ret_from_fork+0x7c/0xb0
[<ffffffff81088490>] ? kthread_create_on_node+0x180/0x180

Bisection points to

	9abf24d sched: Check sched_domain before computing group power

but without it (as clearly indicated in the changelog) the kernel panics thus:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
IP: [<ffffffff810a3542>] update_group_power+0xa2/0x250
PGD 0 
Oops: 0000 [#1] SMP 
Modules linked in: 
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00122-gdea4f48 #10 
Hardware name: Intel Corp. Stoutland Platform, BIOS 2.20 UEFI2.10 PI1.0 X64 2013-09-20
task: ffff881054528000 ti: ffff881054530000 task.ti: ffff881054530000
RIP: 0010:[<ffffffff810a3542>]  [<ffffffff810a3542>] update_group_power+0xa2/0x250
RSP: 0000:ffff881054531d48  EFLAGS: 00010287
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 00000000000000f0 RSI: 0000000000000100 RDI: 00000000000000c0
RBP: ffff881054531d70 R08: ffff89e7d4ae6018 R09: 0000000000000004
R10: ffff89e7d4ae6818 R11: ffffffff81098d5d R12: 0000000000000000
R13: 00000000000146c0 R14: ffff89e7d4ae6000 R15: ffff89e7d4ae6018
FS:  0000000000000000(0000) GS:ffff88105fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000010 CR3: 00000000018c2000 CR4: 00000000000007f0
Stack:
ffff89e7d4ae6000 ffff89e7d4ac0000 00000000000000f0 00000000000000f0
ffff898fd3a68c00 ffff881054531e30 ffffffff8109933f 0000000000000100
00000000000000ff 0000000000010448 00000000000000ff 0000010000000100
Call Trace:
[<ffffffff8109933f>] build_sched_domains+0xbff/0xc80
[<ffffffff81a3c89e>] sched_init_smp+0x3ad/0x469
[<ffffffff81a1c00c>] kernel_init_freeable+0xfa/0x207
[<ffffffff815b3ea0>] ? rest_init+0x80/0x80
[<ffffffff815b3eae>] kernel_init+0xe/0x120
[<ffffffff815d547c>] ret_from_fork+0x7c/0xb0
[<ffffffff815b3ea0>] ? rest_init+0x80/0x80

and this is because of:

	863bffc sched/fair: Fix group power_orig computation

IOW, 9abf24d can't be blamed for it all, and this is not a case of a
straightforward revert of a single commit.

Back to the division by zero itself, it's taking place in the inlined sg_capacity():

find_busiest_group
  update_sd_lb_stats
    update_sg_lb_stats
      sg_capacity

5492 static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
5493 {
5494         unsigned int capacity, smt, cpus;
5495         unsigned int power, power_orig;
5496 
5497         power = group->sgp->power;
5498         power_orig = group->sgp->power_orig;
5499         cpus = group->group_weight;
5500 
5501         /* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
5502         smt = DIV_ROUND_UP(SCHED_POWER_SCALE * cpus, power_orig);      <-- HERE

so we're arriving here with group->sgp->power_orig == 0.

Cheers,
Hedi.

P.S. 

The following *works* around the panic:

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e85cda2..48c8d0b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5735,6 +5735,9 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			if (!sgp)
 				return -ENOMEM;
 
+			/* WAR: avoid a divison by zero in sg_capacity() */
+			sgp->power_orig = 1;
+
 			*per_cpu_ptr(sdd->sgp, j) = sgp;
 		}
 	}

and I wonder whether the following --on its own-- would make sense as a fix:

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index fd773ad..57578b3 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5495,7 +5495,7 @@ static inline int sg_capacity(struct lb_env *env, struct sched_group *group)
 	unsigned int power, power_orig;
 
 	power = group->sgp->power;
-	power_orig = group->sgp->power_orig;
+	power_orig = max_t(unsigned, group->sgp->power_orig, 1);
 	cpus = group->group_weight;
 
 	/* smt := ceil(cpus / power), assumes: 1 < smt_power < 2 */
-- 
Be careful of reading health books, you might die of a misprint.
	-- Mark Twain
