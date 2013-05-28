Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab3E1VZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:25:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59808 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933534Ab3E1VZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:25:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tirupathi Reddy <tirupath@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 47/78] timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE
Date: Tue, 28 May 2013 14:19:56 -0700
Message-Id: <1369776027-17859-48-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tirupathi Reddy <tirupath@codeaurora.org>

commit 42a5cf46cd56f46267d2a9fcf2655f4078cd3042 upstream.

An inactive timer's base can refer to a offline cpu's base.

In the current code, cpu_base's lock is blindly reinitialized each
time a CPU is brought up. If a CPU is brought online during the period
that another thread is trying to modify an inactive timer on that CPU
with holding its timer base lock, then the lock will be reinitialized
under its feet. This leads to following SPIN_BUG().

<0> BUG: spinlock already unlocked on CPU#3, kworker/u:3/1466
<0> lock: 0xe3ebe000, .magic: dead4ead, .owner: kworker/u:3/1466, .owner_cpu: 1
<4> [<c0013dc4>] (unwind_backtrace+0x0/0x11c) from [<c026e794>] (do_raw_spin_unlock+0x40/0xcc)
<4> [<c026e794>] (do_raw_spin_unlock+0x40/0xcc) from [<c076c160>] (_raw_spin_unlock+0x8/0x30)
<4> [<c076c160>] (_raw_spin_unlock+0x8/0x30) from [<c009b858>] (mod_timer+0x294/0x310)
<4> [<c009b858>] (mod_timer+0x294/0x310) from [<c00a5e04>] (queue_delayed_work_on+0x104/0x120)
<4> [<c00a5e04>] (queue_delayed_work_on+0x104/0x120) from [<c04eae00>] (sdhci_msm_bus_voting+0x88/0x9c)
<4> [<c04eae00>] (sdhci_msm_bus_voting+0x88/0x9c) from [<c04d8780>] (sdhci_disable+0x40/0x48)
<4> [<c04d8780>] (sdhci_disable+0x40/0x48) from [<c04bf300>] (mmc_release_host+0x4c/0xb0)
<4> [<c04bf300>] (mmc_release_host+0x4c/0xb0) from [<c04c7aac>] (mmc_sd_detect+0x90/0xfc)
<4> [<c04c7aac>] (mmc_sd_detect+0x90/0xfc) from [<c04c2504>] (mmc_rescan+0x7c/0x2c4)
<4> [<c04c2504>] (mmc_rescan+0x7c/0x2c4) from [<c00a6a7c>] (process_one_work+0x27c/0x484)
<4> [<c00a6a7c>] (process_one_work+0x27c/0x484) from [<c00a6e94>] (worker_thread+0x210/0x3b0)
<4> [<c00a6e94>] (worker_thread+0x210/0x3b0) from [<c00aad9c>] (kthread+0x80/0x8c)
<4> [<c00aad9c>] (kthread+0x80/0x8c) from [<c000ea80>] (kernel_thread_exit+0x0/0x8)

As an example, this particular crash occurred when CPU #3 is executing
mod_timer() on an inactive timer whose base is refered to offlined CPU
#2.  The code locked the timer_base corresponding to CPU #2. Before it
could proceed, CPU #2 came online and reinitialized the spinlock
corresponding to its base. Thus now CPU #3 held a lock which was
reinitialized. When CPU #3 finally ended up unlocking the old cpu_base
corresponding to CPU #2, we hit the above SPIN_BUG().

CPU #0		CPU #3				       CPU #2
------		-------				       -------
.....		 ......				      <Offline>
		mod_timer()
		 lock_timer_base
		   spin_lock_irqsave(&base->lock)

cpu_up(2)	 .....				        ......
							init_timers_cpu()
....		 .....				    	spin_lock_init(&base->lock)
.....		   spin_unlock_irqrestore(&base->lock)  ......
		   <spin_bug>

Allocation of per_cpu timer vector bases is done only once under
"tvec_base_done[]" check. In the current code, spinlock_initialization
of base->lock isn't under this check. When a CPU is up each time the
base lock is reinitialized. Move base spinlock initialization under
the check.

Signed-off-by: Tirupathi Reddy <tirupath@codeaurora.org>
Link: http://lkml.kernel.org/r/1368520142-4136-1-git-send-email-tirupath@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 367d008..18f6b85 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1678,12 +1678,12 @@ static int __cpuinit init_timers_cpu(int cpu)
 			boot_done = 1;
 			base = &boot_tvec_bases;
 		}
+		spin_lock_init(&base->lock);
 		tvec_base_done[cpu] = 1;
 	} else {
 		base = per_cpu(tvec_bases, cpu);
 	}
 
-	spin_lock_init(&base->lock);
 
 	for (j = 0; j < TVN_SIZE; j++) {
 		INIT_LIST_HEAD(base->tv5.vec + j);
-- 
1.8.1.2

