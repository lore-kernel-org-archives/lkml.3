Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaKDQWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:22:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631AbaKDQUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:20:50 -0500
From: Don Zickus <dzickus@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        uobergfe@redhat.com, Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/9] watchdog: implement error handling for failure to set up hardware perf events
Date: Tue,  4 Nov 2014 11:20:21 -0500
Message-Id: <1415118024-194247-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
References: <1415118024-194247-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulrich Obergfell <uobergfe@redhat.com>

If watchdog_nmi_enable() fails to set up the hardware perf event
of one CPU, the entire hard lockup detector is deemed unreliable.
Hence, disable the hard lockup detector and shut down the hardware
perf events on all CPUs.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 kernel/watchdog.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 2897a5e..86ba5e5 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -502,6 +502,15 @@ static void watchdog(unsigned int cpu)
 	__this_cpu_write(soft_lockup_hrtimer_cnt,
 			 __this_cpu_read(hrtimer_interrupts));
 	__touch_watchdog();
+
+	/*
+	 * watchdog_nmi_enable() clears the NMI_WATCHDOG_ENABLED bit in the
+	 * failure path. Check for failures that can occur asynchronously -
+	 * for example, when CPUs are on-lined - and shut down the hardware
+	 * perf event on each CPU accordingly.
+	 */
+	if (!(watchdog_enabled & NMI_WATCHDOG_ENABLED))
+		watchdog_nmi_disable(cpu);
 }
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
@@ -552,6 +561,15 @@ handle_err:
 		goto out_save;
 	}
 
+	/*
+	 * Disable the hard lockup detector if _any_ CPU fails to set up
+	 * set up the hardware perf event. The watchdog() function checks
+	 * the NMI_WATCHDOG_ENABLED bit periodically.
+	 */
+	smp_mb__before_atomic();
+	clear_bit(NMI_WATCHDOG_ENABLED_BIT, &watchdog_enabled);
+	smp_mb__after_atomic();
+
 	/* skip displaying the same error again */
 	if (cpu > 0 && (PTR_ERR(event) == cpu0_err))
 		return PTR_ERR(event);
-- 
1.7.1

