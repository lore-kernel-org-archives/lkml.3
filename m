Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbaJVN7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:59:16 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62566 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbaJVN6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:12 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 07/10] cpuidle: Add a simple select governor
Date: Wed, 22 Oct 2014 15:57:50 +0200
Message-Id: <1413986273-28522-8-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This simple governor takes into account the predictable events: the timer sleep
duration and the next expected IO sleep duration. By mixing both it deduced
what idle state fits better. This governor must be extended to a statistical
approach to predict all the other events.

The main purpose of this governor is to handle the guessed next events in a
categorized way:
	1. deterministic events : timers
	2. guessed events : IOs
	3. predictable events : keystroke, incoming network packet, ...

This governor is aimed to be moved later near the scheduler, so this one
can inspect/inject more informations and act proactively rather than
reactively.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/Kconfig            |  4 +++
 drivers/cpuidle/governors/Makefile |  1 +
 drivers/cpuidle/governors/select.c | 55 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+)
 create mode 100644 drivers/cpuidle/governors/select.c

diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 32748c3..11e9781 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -25,6 +25,10 @@ config CPU_IDLE_GOV_MENU
 	bool "Menu governor (for tickless system)"
 	default y
 
+config CPU_IDLE_GOV_SELECT
+	bool "Select governor (for tickless system)"
+	default y
+
 menu "ARM CPU Idle Drivers"
 depends on ARM
 source "drivers/cpuidle/Kconfig.arm"
diff --git a/drivers/cpuidle/governors/Makefile b/drivers/cpuidle/governors/Makefile
index 1b51272..fa45520 100644
--- a/drivers/cpuidle/governors/Makefile
+++ b/drivers/cpuidle/governors/Makefile
@@ -4,3 +4,4 @@
 
 obj-$(CONFIG_CPU_IDLE_GOV_LADDER) += ladder.o
 obj-$(CONFIG_CPU_IDLE_GOV_MENU) += menu.o
+obj-$(CONFIG_CPU_IDLE_GOV_SELECT) += select.o
diff --git a/drivers/cpuidle/governors/select.c b/drivers/cpuidle/governors/select.c
new file mode 100644
index 0000000..0de7095
--- /dev/null
+++ b/drivers/cpuidle/governors/select.c
@@ -0,0 +1,55 @@
+/*
+ * select.c - the select governor
+ *
+ * Copyright (C) 2014 Daniel Lezcano <daniel.lezcano@linaro.org>
+ *
+*/
+
+#include <linux/cpuidle.h>
+
+static int select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
+		  struct cpuidle_times *times)
+{
+	int i, index = 0, latency_req = times->latency_req;
+	unsigned int next_event;
+
+	/*
+	 * If the guessed IO next event is zero, that means there is no IO
+	 * pending, so we ignore it in the equation
+	 */
+	next_event = times->next_io_event ? 
+		min(times->next_io_event, times->next_timer_event) :
+		times->next_timer_event;
+
+	for (i = 0; i < drv->state_count; i++) {
+
+		struct cpuidle_state *s = &drv->states[i];
+		struct cpuidle_state_usage *su = &dev->states_usage[i];
+
+		if (s->disabled || su->disable)
+			continue;
+		if (s->target_residency > next_event)
+			continue;
+		if (s->exit_latency > latency_req)
+			continue;
+
+		index = i;
+	}
+
+	return index;
+}
+
+static struct cpuidle_governor select_governor = {
+	.name   = "select",
+	.rating = 10,
+	.select = select,
+	.owner  = THIS_MODULE,
+};
+
+static int __init select_init(void)
+{
+	return cpuidle_register_governor(&select_governor);
+}
+
+postcore_initcall(select_init);
+
-- 
1.9.1

