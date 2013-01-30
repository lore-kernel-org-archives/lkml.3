Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671Ab3A3VTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:19:53 -0500
Received: from www.linutronix.de ([62.245.132.108]:52982 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab3A3VTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:19:48 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC 1/2] cpuidle: trace state of the CPU
Date: Wed, 30 Jan 2013 22:19:16 +0100
Message-Id: <1359580757-4121-2-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an interface to cpuidle in order to retrieve the current
idle state of a given CPU. Zero means the CPU is not in an idle state. Either
because a cpuidle driver is not available or because the CPU is busy
executing code. Values greater than zero the CPU indicate that the CPU
is in some kind of idle state. The larger the value, the deeper the idle
state.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/cpuidle/cpuidle.c |   13 ++++++++++++-
 include/linux/cpuidle.h   |    2 ++
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index e1f6860..3594e0c 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -23,6 +23,7 @@
 #include "cpuidle.h"
 
 DEFINE_PER_CPU(struct cpuidle_device *, cpuidle_devices);
+static DEFINE_PER_CPU(unsigned int, cpu_state);
 
 DEFINE_MUTEX(cpuidle_lock);
 LIST_HEAD(cpuidle_detected_devices);
@@ -40,13 +41,23 @@ void disable_cpuidle(void)
 	off = 1;
 }
 
+int cpuidle_get_state(int cpu)
+{
+	return per_cpu(cpu_state, cpu);
+}
+
 static int __cpuidle_register_device(struct cpuidle_device *dev);
 
 static inline int cpuidle_enter(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv, int index)
 {
 	struct cpuidle_state *target_state = &drv->states[index];
-	return target_state->enter(dev, drv, index);
+	int ret;
+
+	per_cpu(cpu_state, smp_processor_id()) = index + 1;
+	ret = target_state->enter(dev, drv, index);
+	per_cpu(cpu_state, smp_processor_id()) = 0;
+	return ret;
 }
 
 static inline int cpuidle_enter_tk(struct cpuidle_device *dev,
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index 24cd1037..256baeb 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -155,6 +155,7 @@ extern int cpuidle_wrap_enter(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv, int index,
 				int (*enter)(struct cpuidle_device *dev,
 					struct cpuidle_driver *drv, int index));
+extern int cpuidle_get_state(int cpu);
 extern int cpuidle_play_dead(void);
 
 extern struct cpuidle_driver *cpuidle_get_cpu_driver(struct cpuidle_device *dev);
@@ -186,6 +187,7 @@ static inline int cpuidle_wrap_enter(struct cpuidle_device *dev,
 				int (*enter)(struct cpuidle_device *dev,
 					struct cpuidle_driver *drv, int index))
 { return -ENODEV; }
+static inline int cpuidle_get_state(int cpu) {return 0; }
 static inline int cpuidle_play_dead(void) {return -ENODEV; }
 #endif
 
-- 
1.7.10.4

