Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878Ab3BDKcM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:32:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3BDKcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:32:10 -0500
Date: Mon, 4 Feb 2013 02:31:38 -0800
From: tip-bot for Mark Rutland <mark.rutland@arm.com>
Message-ID: <tip-12ad10004645d38356b14d1fbba379c523a61916@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        santosh.shilimkar@ti.com, mark.rutland@arm.com, tglx@linutronix.de,
        sboyd@codeaurora.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        santosh.shilimkar@ti.com, tglx@linutronix.de, mark.rutland@arm.com,
        sboyd@codeaurora.org
In-Reply-To: <1358183124-28461-3-git-send-email-mark.rutland@arm.com>
References: <1358183124-28461-3-git-send-email-mark.rutland@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clockevents:
  Add generic timer broadcast function
Git-Commit-ID: 12ad10004645d38356b14d1fbba379c523a61916
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 02:31:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12ad10004645d38356b14d1fbba379c523a61916
Gitweb:     http://git.kernel.org/tip/12ad10004645d38356b14d1fbba379c523a61916
Author:     Mark Rutland <mark.rutland@arm.com>
AuthorDate: Mon, 14 Jan 2013 17:05:22 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 31 Jan 2013 22:15:36 +0100

clockevents: Add generic timer broadcast function

Currently, the timer broadcast mechanism is defined by a function
pointer on struct clock_event_device. As the fundamental mechanism for
broadcast is architecture-specific, this means that clock_event_device
drivers cannot be shared across multiple architectures.

This patch adds an (optional) architecture-specific function for timer
tick broadcast, allowing drivers which may require broadcast
functionality to be shared across multiple architectures.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: nico@linaro.org
Cc: Will.Deacon@arm.com
Cc: Marc.Zyngier@arm.com
Cc: john.stultz@linaro.org
Link: http://lkml.kernel.org/r/1358183124-28461-3-git-send-email-mark.rutland@arm.com
Tested-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/clockchips.h   |  5 +++++
 kernel/time/Kconfig          |  4 ++++
 kernel/time/tick-broadcast.c | 13 +++++++++++++
 3 files changed, 22 insertions(+)

diff --git a/include/linux/clockchips.h b/include/linux/clockchips.h
index e1089aa..6634652 100644
--- a/include/linux/clockchips.h
+++ b/include/linux/clockchips.h
@@ -162,6 +162,11 @@ extern void clockevents_suspend(void);
 extern void clockevents_resume(void);
 
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
+#ifdef CONFIG_ARCH_HAS_TICK_BROADCAST
+extern void tick_broadcast(const struct cpumask *mask);
+#else
+#define tick_broadcast	NULL
+#endif
 extern int tick_receive_broadcast(void);
 #endif
 
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 8601f0d..b696922 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -38,6 +38,10 @@ config GENERIC_CLOCKEVENTS_BUILD
 	default y
 	depends on GENERIC_CLOCKEVENTS
 
+# Architecture can handle broadcast in a driver-agnostic way
+config ARCH_HAS_TICK_BROADCAST
+	bool
+
 # Clockevents broadcasting infrastructure
 config GENERIC_CLOCKEVENTS_BROADCAST
 	bool
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index 7cc81c5..f726537 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -18,6 +18,7 @@
 #include <linux/percpu.h>
 #include <linux/profile.h>
 #include <linux/sched.h>
+#include <linux/smp.h>
 
 #include "tick-internal.h"
 
@@ -86,6 +87,11 @@ int tick_is_broadcast_device(struct clock_event_device *dev)
 	return (dev && tick_broadcast_device.evtdev == dev);
 }
 
+static void err_broadcast(const struct cpumask *mask)
+{
+	pr_crit_once("Failed to broadcast timer tick. Some CPUs may be unresponsive.\n");
+}
+
 /*
  * Check, if the device is disfunctional and a place holder, which
  * needs to be handled by the broadcast device.
@@ -105,6 +111,13 @@ int tick_device_uses_broadcast(struct clock_event_device *dev, int cpu)
 	 */
 	if (!tick_device_is_functional(dev)) {
 		dev->event_handler = tick_handle_periodic;
+		if (!dev->broadcast)
+			dev->broadcast = tick_broadcast;
+		if (!dev->broadcast) {
+			pr_warn_once("%s depends on broadcast, but no broadcast function available\n",
+				     dev->name);
+			dev->broadcast = err_broadcast;
+		}
 		cpumask_set_cpu(cpu, tick_get_broadcast_mask());
 		tick_broadcast_start_periodic(tick_broadcast_device.evtdev);
 		ret = 1;
