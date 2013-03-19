Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3CSLjj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 07:39:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45584 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3CSLji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 07:39:38 -0400
Date: Tue, 19 Mar 2013 04:38:18 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-eaa907c546f76222227dfc41784b22588af1e3d7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        john.stultz@linaro.org, arjan@infradead.org, liu.h.jason@gmail.com,
        tglx@linutronix.de, lorenzo.pieralisi@arm.com
In-Reply-To: <20130306111537.565418308@linutronix.de>
References: <20130306111537.565418308@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick:
  Provide a check for a forced broadcast pending
Git-Commit-ID: eaa907c546f76222227dfc41784b22588af1e3d7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 19 Mar 2013 04:38:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eaa907c546f76222227dfc41784b22588af1e3d7
Gitweb:     http://git.kernel.org/tip/eaa907c546f76222227dfc41784b22588af1e3d7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 6 Mar 2013 11:18:36 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 13 Mar 2013 11:39:39 +0100

tick: Provide a check for a forced broadcast pending

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
Cc: LAK <linux-arm-kernel@lists.infradead.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Arjan van de Veen <arjan@infradead.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Jason Liu <liu.h.jason@gmail.com>
Link: http://lkml.kernel.org/r/20130306111537.565418308@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 include/linux/clockchips.h   |  6 ++++++
 kernel/time/tick-broadcast.c | 12 ++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index 494d33e..646aac1 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -175,6 +175,12 @@ extern void tick_broadcast(const struct cpumask *mask);
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
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 2100aad..d76d816 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -404,6 +404,18 @@ struct cpumask *tick_get_broadcast_oneshot_mask(void)
 }
 
 /*
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
+/*
  * Set broadcast interrupt affinity
  */
 static void tick_broadcast_set_affinity(struct clock_event_device *bc,
