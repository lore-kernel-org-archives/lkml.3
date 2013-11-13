Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652Ab3KMR0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:26:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52905 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3KMR0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:26:00 -0500
Date: Wed, 13 Nov 2013 09:25:13 -0800
From: tip-bot for Michael wang <tipbot@zytor.com>
Message-ID: <tip-106dd5afde3cd10db7e1370b6ddc77f0b2496a75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, wangyun@linux.vnet.ibm.com, tglx@linutronix.de,
        fengguang.wu@intel.com
In-Reply-To: <5282EDC0.6060003@linux.vnet.ibm.com>
References: <5282EDC0.6060003@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix endless sync_sched/rcu()
  loop inside _cpu_down()
Git-Commit-ID: 106dd5afde3cd10db7e1370b6ddc77f0b2496a75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 09:25:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  106dd5afde3cd10db7e1370b6ddc77f0b2496a75
Gitweb:     http://git.kernel.org/tip/106dd5afde3cd10db7e1370b6ddc77f0b2496a75
Author:     Michael wang <wangyun@linux.vnet.ibm.com>
AuthorDate: Wed, 13 Nov 2013 11:10:56 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Nov 2013 13:33:50 +0100

sched: Fix endless sync_sched/rcu() loop inside _cpu_down()

Commit 6acce3ef8:

	sched: Remove get_online_cpus() usage

tries to do sync_sched/rcu() inside _cpu_down() but triggers:

	INFO: task swapper/0:1 blocked for more than 120 seconds.
	...
	[<ffffffff811263dc>] synchronize_rcu+0x2c/0x30
	[<ffffffff81d1bd82>] _cpu_down+0x2b2/0x340
	...

It was caused by that in the rcu boost case we rely on smpboot thread to
finish the rcu callback, which has already been parked before sync in here
and leads to the endless sync_sched/rcu().

This patch exchanges the sequence of smpboot_park_threads() and
sync_sched/rcu() to fix the bug.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5282EDC0.6060003@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/cpu.c | 5 ++++-
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
