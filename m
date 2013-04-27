Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3D0J7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 05:59:18 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54567 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3D0J7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 05:59:17 -0400
Message-ID: <1367056747.6391.15.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH]nohz: Use raw_smp_processor_id() in
 tick_nohz_task_switch()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Date: Sat, 27 Apr 2013 17:59:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042709-8256-0000-0000-0000073DAFAB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I saw following error when testing the latest nohz code on Power:

[   85.295384] BUG: using smp_processor_id() in preemptible [00000000] code: rsyslogd/3493
[   85.295396] caller is .tick_nohz_task_switch+0x1c/0xb8
[   85.295402] Call Trace:
[   85.295408] [c0000001fababab0] [c000000000012dc4] .show_stack+0x110/0x25c (unreliable)
[   85.295420] [c0000001fababba0] [c0000000007c4b54] .dump_stack+0x20/0x30
[   85.295430] [c0000001fababc10] [c00000000044eb74] .debug_smp_processor_id+0xf4/0x124
[   85.295438] [c0000001fababca0] [c0000000000d7594] .tick_nohz_task_switch+0x1c/0xb8
[   85.295447] [c0000001fababd20] [c0000000000b9748] .finish_task_switch+0x13c/0x160
[   85.295455] [c0000001fababdb0] [c0000000000bbe50] .schedule_tail+0x50/0x124
[   85.295463] [c0000001fababe30] [c000000000009dc8] .ret_from_fork+0x4/0x54

It seems to me that we could just use raw_smp_processor_id() here. Even
if the tick_nohz_full_cpu() check is done on a !nohz_full cpu, then the
task is moved to another nohz_full cpu, it seems the context switching
because of the task moving would call tick_nohz_task_switch() again to
evaluate the need for tick.

I don't know whether I missed something here.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index da53c8f..0aa575b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -251,7 +251,7 @@ void tick_nohz_task_switch(struct task_struct *tsk)
 {
 	unsigned long flags;
 
-	if (!tick_nohz_full_cpu(smp_processor_id()))
+	if (!tick_nohz_full_cpu(raw_smp_processor_id()))
 		return;
 
 	local_irq_save(flags);
-- 
1.7.1



