Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934792Ab3DJVIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:08:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43668 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760264Ab3DJVIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:08:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,450,1363158000"; 
   d="scan'208";a="37515892"
From: Michael Bohan <mbohan@codeaurora.org>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH 2/2] hrtimer: Prevent enqueue of hrtimer on dead CPU
Date: Wed, 10 Apr 2013 14:07:48 -0700
Message-Id: <1365628068-32738-3-git-send-email-mbohan@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org>
References: <1365628068-32738-1-git-send-email-mbohan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When switching the hrtimer cpu_base, we briefly allow for
preemption to become enabled by unlocking the cpu_base lock.
During this time, the CPU corresponding to the new cpu_base
that was selected may in fact go offline. In this scenario, the
hrtimer is enqueued to a CPU that's not online, and therefore
it never fires.

As an example, consider this example:

CPU #0                          CPU #1
----                            ----
...                             hrtimer_start()
                                 lock_hrtimer_base()
                                 switch_hrtimer_base()
                                  cpu = hrtimer_get_target() -> 1
                                  spin_unlock(&cpu_base->lock)
                                <migrate thread to CPU #0>
                                <offline>
spin_lock(&new_base->lock)
this_cpu = 0
cpu != this_cpu
enqueue_hrtimer(cpu_base #1)

To prevent this scenario, verify that the CPU corresponding to
the new cpu_base is indeed online before selecting it in
hrtimer_switch_base(). If it's not online, fallback to using the
base of the current CPU.

Signed-off-by: Michael Bohan <mbohan@codeaurora.org>
---
 kernel/hrtimer.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 3f0bce9..54c5d98 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -227,7 +227,8 @@ again:
 
 		this_cpu = smp_processor_id();
 
-		if (cpu != this_cpu && hrtimer_check_target(timer, new_base)) {
+		if (cpu != this_cpu && (hrtimer_check_target(timer, new_base)
+			|| !cpu_online(cpu))) {
 			raw_spin_unlock(&new_base->cpu_base->lock);
 			raw_spin_lock(&base->cpu_base->lock);
 			cpu = smp_processor_id();
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

