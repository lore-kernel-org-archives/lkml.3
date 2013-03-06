Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757617Ab3CFLSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:18:48 -0500
Received: from www.linutronix.de ([62.245.132.108]:42514 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472Ab3CFLSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:18:37 -0500
Message-Id: <20130306111537.565418308@linutronix.de>
User-Agent: quilt/0.48-1
Date: Wed, 06 Mar 2013 11:18:36 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Arjan van de Veen <arjan@infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Jason Liu <liu.h.jason@gmail.com>
Subject: [patch 5/7] tick: Provide a check for a forced broadcast pending
References: <20130306111351.883117670@linutronix.de>
Content-Disposition: inline;
 filename=tick-provide-check-for-forced-broadcast-pending.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the CPU which gets woken along with the target CPU of the broadcast
the following happens:

  deep_idle()
			<-- spurious wakeup
  broadcast_exit()
    set forced bit
  
  enable interrupts
    
			<-- Nothing happens

  disable interrupts

  broadcast_enter()
			<-- Here we observe the forced bit is set
  deep_idle()

Now after that the target CPU of the broadcast runs the broadcast
handler and finds the other CPU in both the broadcast and the forced
mask, sends the IPI and stuff gets back to normal.

So it's not actually harmful, just more evidence for the theory, that
hardware designers have access to very special drug supplies.

Now there is no point in going back to deep idle just to wake up again
right away via an IPI. Provide a check which allows the idle code to
avoid the deep idle transition.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/clockchips.h   |    6 ++++++
 kernel/time/tick-broadcast.c |   12 ++++++++++++
 2 files changed, 18 insertions(+)

Index: tip/include/linux/clockchips.h
===================================================================
--- tip.orig/include/linux/clockchips.h
+++ tip/include/linux/clockchips.h
@@ -170,6 +170,12 @@ extern void tick_broadcast(const struct 
 extern int tick_receive_broadcast(void);
 #endif
 
+#if defined(CONFIG_GENERIC_CLOCKEVENTS_BROADCAST) && defined(CONFIG_TICK_ONESHOT)
+extern int tick_check_broadcast_expired(void);
+#else
+static inline int tick_check_broadcast_expired(void) { return 0; }
+#endif
+
 #ifdef CONFIG_GENERIC_CLOCKEVENTS
 extern void clockevents_notify(unsigned long reason, void *arg);
 #else
Index: tip/kernel/time/tick-broadcast.c
===================================================================
--- tip.orig/kernel/time/tick-broadcast.c
+++ tip/kernel/time/tick-broadcast.c
@@ -413,6 +413,18 @@ static int tick_broadcast_set_event(ktim
 	return clockevents_program_event(bc, expires, force);
 }
 
+/*
+ * Called before going idle with interrupts disabled. Checks whether a
+ * broadcast event from the other core is about to happen. We detected
+ * that in tick_broadcast_oneshot_control(). The callsite can use this
+ * to avoid a deep idle transition as we are about to get the
+ * broadcast IPI right away.
+ */
+int tick_check_broadcast_expired(void)
+{
+	return cpumask_test_cpu(smp_processor_id(), tick_broadcast_force_mask);
+}
+
 int tick_resume_broadcast_oneshot(struct clock_event_device *bc)
 {
 	clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);


