Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3D1D0M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 23:26:12 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35436 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab3D1D0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 23:26:10 -0400
Message-ID: <1367119558.6391.34.camel@ThinkPad-T5421.cn.ibm.com>
Subject: [RFC PATCH v2]nohz: protect smp_processor_id() in
 tick_nohz_task_switch()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Date: Sun, 28 Apr 2013 11:25:58 +0800
In-Reply-To: <CAFTL4hwVXS9s7n=0Ji4+5cbOQSROk53OxMAWY3U=bzRPRijr9w@mail.gmail.com>
References: <1367056747.6391.15.camel@ThinkPad-T5421.cn.ibm.com>
	 <CAFTL4hwVXS9s7n=0Ji4+5cbOQSROk53OxMAWY3U=bzRPRijr9w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042803-9264-0000-0000-000003A0730C
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

The code below moves the test into local_irq_save/restore section to
avoid the above complaint.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
---
 kernel/time/tick-sched.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index da53c8f..1c9f53b 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -251,14 +251,15 @@ void tick_nohz_task_switch(struct task_struct *tsk)
 {
 	unsigned long flags;
 
-	if (!tick_nohz_full_cpu(smp_processor_id()))
-		return;
-
 	local_irq_save(flags);
 
+	if (!tick_nohz_full_cpu(smp_processor_id()))
+		goto out;
+
 	if (tick_nohz_tick_stopped() && !can_stop_full_tick())
 		tick_nohz_full_kick();
 
+out:
 	local_irq_restore(flags);
 }
 
-- 
1.7.1

