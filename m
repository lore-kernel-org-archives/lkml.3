Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239AbaGYL4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:56:54 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:42223 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaGYL4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:56:52 -0400
From: Kaushal Kumar <kaushalk@codeaurora.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Arun Bharadwaj <abharadw@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Kaushal Kumar <kaushalk@codeaurora.org>
Subject: [PATCH] sched: Remove synchronize rcu/sched calls from _cpu_down
Date: Fri, 25 Jul 2014 17:26:08 +0530
Message-Id: <1406289368-11332-1-git-send-email-kaushalk@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synchronize_rcu calls fail hot-unplug latency tests since
wait_rcu_gp can have very high latency, at times up to few
hundred of millisecs.

These calls were earlier removed for the same reason by the
commit 9ee349ad6d326df3633d43f54202427295999c47, but got added
back as part of commit c4575f83b9fe87bb57b737bc8a667f746a20320a.

Moreover there should be no need for sync_sched() in _cpu_down
as stop_machine() provides that barrier implicitly.

Signed-off-by: Kaushal Kumar <kaushalk@codeaurora.org>
---
 kernel/cpu.c | 20 --------------------
 1 file changed, 20 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 887eb32..93e526c 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -311,28 +311,8 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 				__func__, cpu);
 		goto out_release;
 	}
-
-	/*
-	 * By now we've cleared cpu_active_mask, wait for all preempt-disabled
-	 * and RCU users of this state to go away such that all new such users
-	 * will observe it.
-	 *
-	 * For CONFIG_PREEMPT we have preemptible RCU and its sync_rcu() might
-	 * not imply sync_sched(), so explicitly call both.
-	 *
-	 * Do sync before park smpboot threads to take care the rcu boost case.
-	 */
-#ifdef CONFIG_PREEMPT
-	synchronize_sched();
-#endif
-	synchronize_rcu();
-
 	smpboot_park_threads(cpu);

-	/*
-	 * So now all preempt/rcu users must observe !cpu_active().
-	 */
-
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		/* CPU didn't die: tell everyone.  Can't complain. */
--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

