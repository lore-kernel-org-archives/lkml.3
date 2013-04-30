Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3D3GbK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:31:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab3D3GbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:31:06 -0400
Date: Mon, 29 Apr 2013 23:30:30 -0700
From: tip-bot for Li Zhong <tipbot@zytor.com>
Message-ID: <tip-6296ace467c8640317414ba589b124323806f7ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, zhong@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, zhong@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1367119558.6391.34.camel@ThinkPad-T5421.cn.ibm.com>
References: <1367119558.6391.34.camel@ThinkPad-T5421.cn.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/nohz] nohz: Protect smp_processor_id()
  in tick_nohz_task_switch()
Git-Commit-ID: 6296ace467c8640317414ba589b124323806f7ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6296ace467c8640317414ba589b124323806f7ce
Gitweb:     http://git.kernel.org/tip/6296ace467c8640317414ba589b124323806f7ce
Author:     Li Zhong <zhong@linux.vnet.ibm.com>
AuthorDate: Sun, 28 Apr 2013 11:25:58 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 29 Apr 2013 13:17:33 +0200

nohz: Protect smp_processor_id() in tick_nohz_task_switch()

I saw following error when testing the latest nohz code on
Power:

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

The code below moves the test into local_irq_save/restore
section to avoid the above complaint.

Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1367119558.6391.34.camel@ThinkPad-T5421.cn.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/tick-sched.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

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
 
