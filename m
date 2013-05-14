Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab3ENQDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:03:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49140 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab3ENQD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:03:27 -0400
Date: Tue, 14 May 2013 09:02:13 -0700
From: tip-bot for Tirupathi Reddy <tipbot@zytor.com>
Message-ID: <tip-42a5cf46cd56f46267d2a9fcf2655f4078cd3042@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tirupath@codeaurora.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tirupath@codeaurora.org, tglx@linutronix.de
In-Reply-To: <1368520142-4136-1-git-send-email-tirupath@codeaurora.org>
References: <1368520142-4136-1-git-send-email-tirupath@codeaurora.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timer: Don'
 t reinitialize the cpu base lock during CPU_UP_PREPARE
Git-Commit-ID: 42a5cf46cd56f46267d2a9fcf2655f4078cd3042
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

Commit-ID:  42a5cf46cd56f46267d2a9fcf2655f4078cd3042
Gitweb:     http://git.kernel.org/tip/42a5cf46cd56f46267d2a9fcf2655f4078cd3042
Author:     Tirupathi Reddy <tirupath@codeaurora.org>
AuthorDate: Tue, 14 May 2013 13:59:02 +0530
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 14 May 2013 17:59:18 +0200

timer: Don't reinitialize the cpu base lock during CPU_UP_PREPARE

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
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1368520142-4136-1-git-send-email-tirupath@codeaurora.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 09bca8c..7376589 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1539,12 +1539,12 @@ static int __cpuinit init_timers_cpu(int cpu)
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
