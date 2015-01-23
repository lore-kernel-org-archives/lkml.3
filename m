Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbbAWGNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:13:17 -0500
Received: from fgwmail8.fujitsu.co.jp ([192.51.44.38]:45079 "EHLO
	fgwmail8.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbAWGNO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:13:14 -0500
From: "Izumi, Taku" <izumi.taku@jp.fujitsu.com>
To: "Lai, Jiangshan" <laijs@cn.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Lai, Jiangshan" <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        "Ishimatsu, Yasuaki" <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        "Tang, Chen" <tangchen@cn.fujitsu.com>,
        "Kamezawa, Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: RE: [RFC PATCH 0/2 shit_A shit_B] workqueue: fix wq_numa bug
Thread-Topic: [RFC PATCH 0/2 shit_A shit_B] workqueue: fix wq_numa bug
Thread-Index: AQHQL9gTKmnvINLs+kqM8mDDt0qofJzNRGOg
Date: Fri, 23 Jan 2015 06:13:07 +0000
Message-ID: <E86EADE93E2D054CBCD4E708C38D364A54134B14@G01JPEXMBYT01>
References: <54B5D8B4.7010708@cn.fujitsu.com>
 <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
In-Reply-To: <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-securitypolicycheck: OK by SHieldMailChecker v1.7.4
x-originating-ip: [10.124.102.50]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0N6DMMl031835


> This patches are un-changloged, un-compiled, un-booted, un-tested,
> they are just shits, I even hope them un-sent or blocked.
> 
> The patches include two -solutions-:
> 
> Shit_A:
>   workqueue: reset pool->node and unhash the pool when the node is
>     offline
>   update wq_numa when cpu_present_mask changed
> 
>  kernel/workqueue.c | 107 +++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 84 insertions(+), 23 deletions(-)
> 
> 
> Shit_B:
>   workqueue: reset pool->node and unhash the pool when the node is
>     offline
>   workqueue: remove wq_numa_possible_cpumask
>   workqueue: directly update attrs of pools when cpu hot[un]plug
> 
>  kernel/workqueue.c | 135 +++++++++++++++++++++++++++++++++++++++--------------
>  1 file changed, 101 insertions(+), 34 deletions(-)
> 

  I tried your patchsets.
  linux-3.18.3 + Shit_A:

    Build OK. 
    I tried to reproduce the problem that Ishimatsu had reported, but it doesn't occur.
    It seems that your patch fixes this problem.

  linux-3.18.3  + Shit_B: 

    Build OK, but I encountered kernel panic at boot time.

[    0.189000] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[    0.189000] IP: [<ffffffff8131ef96>] __list_add+0x16/0xc0
[    0.189000] PGD 0 
[    0.189000] Oops: 0000 [#1] SMP 
[    0.189000] Modules linked in:
[    0.189000] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.18.3+ #3
[    0.189000] Hardware name: FUJITSU PRIMEQUEST2800E/SB, BIOS PRIMEQUEST 2000 Series BIOS Version 01.81 12/03/2014
[    0.189000] task: ffff880869678000 ti: ffff880869664000 task.ti: ffff880869664000
[    0.189000] RIP: 0010:[<ffffffff8131ef96>]  [<ffffffff8131ef96>] __list_add+0x16/0xc0
[    0.189000] RSP: 0000:ffff880869667be8  EFLAGS: 00010296
[    0.189000] RAX: ffff88087f83cda8 RBX: ffff88087f83cd80 RCX: 0000000000000000
[    0.189000] RDX: 0000000000000000 RSI: ffff88086912bb98 RDI: ffff88087f83cd80
[    0.189000] RBP: ffff880869667c08 R08: 0000000000000000 R09: ffff88087f807480
[    0.189000] R10: ffffffff810911b6 R11: ffffffff810956ac R12: 0000000000000000
[    0.189000] R13: ffff88086912bb98 R14: 0000000000000400 R15: 0000000000000400
[    0.189000] FS:  0000000000000000(0000) GS:ffff88087fc00000(0000) knlGS:0000000000000000
[    0.189000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.189000] CR2: 0000000000000008 CR3: 0000000001998000 CR4: 00000000001407f0
[    0.189000] Stack:
[    0.189000]  000000000000000a ffff88086912b800 ffff88087f83cd00 ffff88087f80c000
[    0.189000]  ffff880869667c48 ffffffff810912c8 ffff880869667c28 ffff88087f803f00
[    0.189000]  00000000fffffff4 ffff88086964b760 ffff88086964b6a0 ffff88086964b740
[    0.189000] Call Trace:
[    0.189000]  [<ffffffff810912c8>] alloc_unbound_pwq+0x298/0x3b0
[    0.189000]  [<ffffffff81091ce8>] apply_workqueue_attrs+0x158/0x4c0
[    0.189000]  [<ffffffff81092424>] __alloc_workqueue_key+0x174/0x5b0
[    0.189000]  [<ffffffff813052a6>] ? alloc_cpumask_var_node+0x56/0x80
[    0.189000]  [<ffffffff81b21573>] init_workqueues+0x33d/0x40f
[    0.189000]  [<ffffffff81b21236>] ? ftrace_define_fields_workqueue_execute_start+0x6a/0x6a
[    0.189000]  [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[    0.189000]  [<ffffffff81b12f4d>] ? native_smp_prepare_cpus+0x34d/0x352
[    0.189000]  [<ffffffff81b0026d>] kernel_init_freeable+0xf5/0x23c
[    0.189000]  [<ffffffff81653370>] ? rest_init+0x80/0x80
[    0.189000]  [<ffffffff8165337e>] kernel_init+0xe/0xf0
[    0.189000]  [<ffffffff8166bcfc>] ret_from_fork+0x7c/0xb0
[    0.189000]  [<ffffffff81653370>] ? rest_init+0x80/0x80
[    0.189000] Code: ff b8 f4 ff ff ff e9 3b ff ff ff b8 f4 ff ff ff e9 31 ff ff ff 55 48 89 e5 41 55 49 89 f5 41 54 49 89 d4 53 48 89 fb 48 83 ec 08 <4c> 8b 42 08 49 39 f0 75 2e 4d 8b 45 00 4d 39 c4 75 6c 4c 39 e3 
[    0.189000] RIP  [<ffffffff8131ef96>] __list_add+0x16/0xc0
[    0.189000]  RSP <ffff880869667be8>
[    0.189000] CR2: 0000000000000008
[    0.189000] ---[ end trace 58feee6875cf67cf ]---
[    0.189000] Kernel panic - not syncing: Fatal exception
[    0.189000] ---[ end Kernel panic - not syncing: Fatal exception

   
  Sincerely,
  Taku Izumi


> Both patch1 of the both solutions are: reset pool->node and unhash the pool,
> it is suggested by TJ, I found it is a good leading-step for fixing the bug.
> 
> The other patches are handling wq_numa_possible_cpumask where the solutions
> diverge.
> 
> Solution_A uses present_mask rather than possible_cpumask. It adds
> wq_numa_notify_cpu_present_set/cleared() for notifications of
> the changes of cpu_present_mask.  But the notifications are un-existed
> right now, so I fake one (wq_numa_check_present_cpumask_changes())
> to imitate them.  I hope the memory people add a real one.
> 
> Solution_B uses online_mask rather than possible_cpumask.
> this solution remove more coupling between numa_code and workqueue,
> it just depends on cpumask_of_node(node).
> 
> Patch2_of_Solution_B removes the wq_numa_possible_cpumask and add
> overhead when cpu hot[un]plug, Patch3 reduce this overhead.
> 
> Thanks,
> Lai
> 
> 
> Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
> Cc: tangchen <tangchen@cn.fujitsu.com>
> Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
> --
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
