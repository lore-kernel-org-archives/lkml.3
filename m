Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab3KMDLa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:11:30 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38717 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758110Ab3KMDLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:11:04 -0500
Message-ID: <5282EDC0.6060003@linux.vnet.ibm.com>
Date: Wed, 13 Nov 2013 11:10:56 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sched: fix the endless sync_sched/rcu() inside _cpu_down()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111303-2674-0000-0000-00000B77D561
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 6acce3ef8:

	sched: Remove get_online_cpus() usage

try to do sync_sched/rcu() inside _cpu_down() but trigger:

	INFO: task swapper/0:1 blocked for more than 120 seconds.
	...
	[<ffffffff811263dc>] synchronize_rcu+0x2c/0x30
	[<ffffffff81d1bd82>] _cpu_down+0x2b2/0x340
	...

It was caused by that in rcu boost case, we rely on smpboot thread to
finish the rcu callback, which has already parked before sync in here
and lead to the endless sync_sched/rcu().

This patch exchange the sequence of smpboot_park_threads() and
sync_sched/rcu() to fix the BUG.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 kernel/cpu.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 63aa50d..2227b58 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -306,7 +306,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 				__func__, cpu);
 		goto out_release;
 	}
-	smpboot_park_threads(cpu);
 
 	/*
 	 * By now we've cleared cpu_active_mask, wait for all preempt-disabled
@@ -315,12 +314,16 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	 *
 	 * For CONFIG_PREEMPT we have preemptible RCU and its sync_rcu() might
 	 * not imply sync_sched(), so explicitly call both.
+	 *
+	 * Do sync before park smpboot threads to take care the rcu boost case.
 	 */
 #ifdef CONFIG_PREEMPT
 	synchronize_sched();
 #endif
 	synchronize_rcu();
 
+	smpboot_park_threads(cpu);
+
 	/*
 	 * So now all preempt/rcu users must observe !cpu_active().
 	 */
-- 
1.7.9.5

