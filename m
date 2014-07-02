Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbaGBTwe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:52:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:28983 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752632AbaGBTwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:52:32 -0400
Message-Id: <20140702195231.476379359@goodmis.org>
User-Agent: quilt/0.63-1
Date: Wed, 02 Jul 2014 15:52:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        stable-rt@vger.kernel.org
Subject: [PATCH RT 1/3] timer: do not spin_trylock() on UP
References: <20140702195220.872585955@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0001-timer-do-not-spin_trylock-on-UP.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10.44-rt46-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

This will void a warning comming from the spin-lock debugging code. The
lock avoiding idea is from Steven Rostedt.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/timer.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 26cca8b924e7..40cfa14131ca 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1461,6 +1461,19 @@ void run_local_timers(void)
 	 * the timer softirq.
 	 */
 #ifdef CONFIG_PREEMPT_RT_FULL
+
+#ifndef CONFIG_SMP
+	/*
+	 * The spin_do_trylock() later may fail as the lock may be hold before
+	 * the interrupt arrived. The spin-lock debugging code will raise a
+	 * warning if the try_lock fails on UP. Since this is only an
+	 * optimization for the FULL_NO_HZ case (not to run the timer softirq on
+	 * an nohz_full CPU) we don't really care and shedule the softirq.
+	 */
+	raise_softirq(TIMER_SOFTIRQ);
+	return;
+#endif
+
 	/* On RT, irq work runs from softirq */
 	if (irq_work_needs_cpu()) {
 		raise_softirq(TIMER_SOFTIRQ);
-- 
2.0.0


