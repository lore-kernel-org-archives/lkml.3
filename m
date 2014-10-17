Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbaJQRAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 13:00:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbaJQRAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 13:00:08 -0400
From: Ulrich Obergfell <uobergfe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: dzickus@redhat.com, uobergfe@redhat.com
Subject: [PATCH v2 6/9] watchdog: implement error handling for failure to set up hardware perf events
Date: Fri, 17 Oct 2014 19:06:25 +0200
Message-Id: <1413565588-4144-7-git-send-email-uobergfe@redhat.com>
In-Reply-To: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
References: <1413565588-4144-1-git-send-email-uobergfe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If watchdog_nmi_enable() fails to set up the hardware perf event
of one CPU, the entire hard lockup detector is deemed unreliable.
Hence, disable the hard lockup detector and shut down the hardware
perf events on all CPUs.

Signed-off-by: Ulrich Obergfell <uobergfe@redhat.com>
---
 kernel/watchdog.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 3de09ca..22aea74 100644
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
1.7.11.7

