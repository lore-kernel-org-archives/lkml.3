Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaFYTnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 15:43:03 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34591 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753122AbaFYTnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 15:43:01 -0400
Message-ID: <53AB2643.8050901@codeaurora.org>
Date: Wed, 25 Jun 2014 12:42:59 -0700
From: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: tglx@linutronix.de
Subject: [PATCH] kthread: Fix the race condition when kthread is parked
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While stressing the CPU hotplug path, sometimes we hit a problem
as shown below.

[57056.416774] ------------[ cut here ]------------
[57056.489232] ksoftirqd/1 (14): undefined instruction: pc=c01931e8
[57056.489245] Code: e594a000 eb085236 e15a0000 0a000000 (e7f001f2)
[57056.489259] ------------[ cut here ]------------
[57056.492840] kernel BUG at kernel/kernel/smpboot.c:134!
[57056.513236] Internal error: Oops - BUG: 0 [#1] PREEMPT SMP ARM
[57056.519055] Modules linked in: wlan(O) mhi(O)
[57056.523394] CPU: 0 PID: 14 Comm: ksoftirqd/1 Tainted: G        W O 
3.10.0-g3677c61-00008-g180c060 #1
[57056.532595] task: f0c8b000 ti: f0e78000 task.ti: f0e78000
[57056.537991] PC is at smpboot_thread_fn+0x124/0x218
[57056.542750] LR is at smpboot_thread_fn+0x11c/0x218
[57056.547528] pc : [<c01931e8>]    lr : [<c01931e0>] psr: 200f0013
[57056.547528] sp : f0e79f30  ip : 00000000  fp : 00000000
[57056.558983] r10: 00000001  r9 : 00000000  r8 : f0e78000
[57056.564192] r7 : 00000001  r6 : c1195758  r5 : f0e78000  r4 : f0e5fd00
[57056.570701] r3 : 00000001  r2 : f0e79f20  r1 : 00000000  r0 : 00000000

This issue was always seen in the context of "ksoftirqd". It seems to
be happening because of a potential race condition in __kthread_parkme
where just after completing the parked completion, before the
ksoftirqd task has been scheduled again, it can go into running state.

Fix this by waiting for the task state to parked after waiting for the
parked completion.

Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
---
  kernel/kthread.c | 2 ++
  1 file changed, 2 insertions(+)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 760e86d..c56c6f8 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -398,6 +398,8 @@ int kthread_park(struct task_struct *k)
              if (k != current) {
                  wake_up_process(k);
                  wait_for_completion(&kthread->parked);
+                while (k->state != TASK_PARKED)
+                    cond_resched();
              }
          }
          ret = 0;
-- 
1.8.2.1

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

