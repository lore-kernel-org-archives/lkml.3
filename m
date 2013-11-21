Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3KURCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:02:38 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:30518 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754554Ab3KURBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:01:18 -0500
Message-Id: <20131121170117.216396966@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 21 Nov 2013 11:59:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, Yang Shi <yang.shi@windriver.com>
Subject: [PATCH RT 5/7] mm/memcontrol: Dont call schedule_work_on in preemption disabled
 context
References: <20131121165948.354971355@goodmis.org>
Content-Disposition: inline; filename=0005-mm-memcontrol-Don-t-call-schedule_work_on-in-preempt.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13-rt25-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Yang Shi <yang.shi@windriver.com>

The following trace is triggered when running ltp oom test cases:

BUG: sleeping function called from invalid context at kernel/rtmutex.c:659
in_atomic(): 1, irqs_disabled(): 0, pid: 17188, name: oom03
Preemption disabled at:[<ffffffff8112ba70>] mem_cgroup_reclaim+0x90/0xe0

CPU: 2 PID: 17188 Comm: oom03 Not tainted 3.10.10-rt3 #2
Hardware name: Intel Corporation Calpella platform/MATXM-CORE-411-B, BIOS 4.6.3 08/18/2010
ffff88007684d730 ffff880070df9b58 ffffffff8169918d ffff880070df9b70
ffffffff8106db31 ffff88007688b4a0 ffff880070df9b88 ffffffff8169d9c0
ffff88007688b4a0 ffff880070df9bc8 ffffffff81059da1 0000000170df9bb0
Call Trace:
[<ffffffff8169918d>] dump_stack+0x19/0x1b
[<ffffffff8106db31>] __might_sleep+0xf1/0x170
[<ffffffff8169d9c0>] rt_spin_lock+0x20/0x50
[<ffffffff81059da1>] queue_work_on+0x61/0x100
[<ffffffff8112b361>] drain_all_stock+0xe1/0x1c0
[<ffffffff8112ba70>] mem_cgroup_reclaim+0x90/0xe0
[<ffffffff8112beda>] __mem_cgroup_try_charge+0x41a/0xc40
[<ffffffff810f1c91>] ? release_pages+0x1b1/0x1f0
[<ffffffff8106f200>] ? sched_exec+0x40/0xb0
[<ffffffff8112cc87>] mem_cgroup_charge_common+0x37/0x70
[<ffffffff8112e2c6>] mem_cgroup_newpage_charge+0x26/0x30
[<ffffffff8110af68>] handle_pte_fault+0x618/0x840
[<ffffffff8103ecf6>] ? unpin_current_cpu+0x16/0x70
[<ffffffff81070f94>] ? migrate_enable+0xd4/0x200
[<ffffffff8110cde5>] handle_mm_fault+0x145/0x1e0
[<ffffffff810301e1>] __do_page_fault+0x1a1/0x4c0
[<ffffffff8169c9eb>] ? preempt_schedule_irq+0x4b/0x70
[<ffffffff8169e3b7>] ? retint_kernel+0x37/0x40
[<ffffffff8103053e>] do_page_fault+0xe/0x10
[<ffffffff8169e4c2>] page_fault+0x22/0x30

So, to prevent schedule_work_on from being called in preempt disabled context,
replace the pair of get/put_cpu() to get/put_cpu_light().

Cc: stable-rt@vger.kernel.org
Signed-off-by: Yang Shi <yang.shi@windriver.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6b7ff19..1503ca3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2283,7 +2283,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 
 	/* Notify other cpus that system-wide "drain" is running */
 	get_online_cpus();
-	curcpu = get_cpu();
+	curcpu = get_cpu_light();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2300,7 +2300,7 @@ static void drain_all_stock(struct mem_cgroup *root_memcg, bool sync)
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-	put_cpu();
+	put_cpu_light();
 
 	if (!sync)
 		goto out;
-- 
1.8.4.rc3


