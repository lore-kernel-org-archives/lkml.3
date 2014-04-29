Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaD2WzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 18:55:05 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:58042 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432AbaD2WzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 18:55:03 -0400
Message-ID: <53602DC6.2060101@gmail.com>
Date: Tue, 29 Apr 2014 17:55:02 -0500
From: Stuart Hayes <stuart.w.hayes@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: [PATCH] hrtimer: invalid timeout set after hang_detected
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make hrtimer_force_reprogram() not reprogram the clock event device if hang_detected has been set in hrtimer_interrupt().

Otherwise, if an active hrtimer is changed by calling hrtimer_start() (for example) while hang_detected is set, the clock event device can be programmed with the wrong value, which can result in the clock event device interrupt occurring much later than expected, and timer functions being run very late.

This can occur, for instance, if a CPU goes idle and calls tick_nohz_stop_sched_tick() after hang_detected is set.  The function tick_nohz_stop_sched_tick() will call hrtimer_start() to reprogram the sched_timer to a longer timeout.  hrtimer_start() will call __hrtimer_start_range_ns(), which first calls remove_hrtimer() to remove sched_timer, then hrtimer_enqueue_reprogram() to add it with its new timeout.  The problem is that remove_hrtimer() calls __remove_hrtimer(), which calls hrtimer_force_reprogram(), and hrtimer_force_reprogram() ignores hang_detected and will reprogram the clock event device to the next soonest hrtimer expiry, which could be, say, 11 seconds away.  This overwrites the value that was programmed into the clock event device when hang_detected was set (which was no more than 100ms).  Then hrtimer_enqueue_reprogram() calls hrtimer_reprogram(), which observes hang_detected and does not reprogram the clock event device, so the device remains set to the val
ue of, in this example, 11 seconds, during which time no clock event device interrupts occur and no timer expiration functions are run.


Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
---

--- linux-3.15-rc3/kernel_orig/hrtimer.c	2014-04-29 13:10:58.087832963 -0400
+++ linux-3.15-rc3/kernel/hrtimer.c	2014-04-29 15:42:49.581084736 -0400
@@ -569,6 +569,15 @@ hrtimer_force_reprogram(struct hrtimer_c
 
 	cpu_base->expires_next.tv64 = expires_next.tv64;
 
+	/*
+	 * If a hang was detected in the last timer interrupt then we
+	 * do not schedule a timer which is earlier than the expiry
+	 * which we enforced in the hang detection. We want the system
+	 * to make progress.
+	 */
+	if (cpu_base->hang_detected)
+		return;
+
 	if (cpu_base->expires_next.tv64 != KTIME_MAX)
 		tick_program_event(cpu_base->expires_next, 1);
 }
