Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936032Ab3DJVIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:08:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6070 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760111Ab3DJVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:08:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="37345525"
From: Michael Bohan <mbohan@codeaurora.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/2] hrtimer: Consider preemption when migrating hrtimer cpu_bases
Date: Wed, 10 Apr 2013 14:07:47 -0700
Message-Id: <1365628068-32738-2-git-send-email-mbohan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org>
References: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching to a new cpu_base in switch_hrtimer_base(), we
briefly enable preemption by unlocking the cpu_base lock in two
places. During this interval it's possible for the running thread
to be swapped to a different CPU.

Consider the following example:

CPU #0                                 CPU #1
----                                   ----
hrtimer_start()                        ...
 lock_hrtimer_base()
 switch_hrtimer_base()
  this_cpu = 0;
  target_cpu_base = 0;
  raw_spin_unlock(&cpu_base->lock)
<migrate to CPU 1>
...                                    this_cpu == 0
                                       cpu == this_cpu
                                       timer->base = CPU #0
                                       timer->base != LOCAL_CPU

Since the cached this_cpu is no longer accurate, we'll skip the
hrtimer_check_target() check. Once we eventually go to program
the hardware, we'll decide not to do so since it knows the real
CPU that we're running on is not the same as the chosen base. As
a consequence, we may end up missing the hrtimer's deadline.

Fix this by updating the local CPU number each time we retake a
cpu_base lock in switch_hrtimer_base().

Another possibility is to disable preemption across the whole of
switch_hrtimer_base. This looks suboptimal since preemption
would be disabled while waiting for lock(s).

Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
---
 kernel/hrtimer.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index cc47812..3f0bce9 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -225,10 +225,12 @@ again:
 		raw_spin_unlock(&base->cpu_base->lock);
 		raw_spin_lock(&new_base->cpu_base->lock);
 
+		this_cpu = smp_processor_id();
+
 		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
-			cpu = this_cpu;
 			raw_spin_unlock(&new_base->cpu_base->lock);
 			raw_spin_lock(&base->cpu_base->lock);
+			cpu = smp_processor_id();
 			timer->base = base;
 			goto again;
 		}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

