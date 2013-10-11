Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3JKRVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:21:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48526 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab3JKRTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:19:30 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: pjt@google.com, arjan@linux.intel.com, rjw@sisk.pl,
        dirk.j.brandewie@intel.com, vincent.guittot@linaro.org,
        alex.shi@linaro.org, preeti@linux.vnet.ibm.com, efault@gmx.de,
        corbet@lwn.net, tglx@linutronix.de, catalin.marinas@arm.com,
        morten.rasmussen@arm.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Subject: [RFC][PATCH 1/7] Initial power driver interface infrastructure
Date: Fri, 11 Oct 2013 18:19:11 +0100
Message-Id: <1381511957-29776-2-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
References: <1381511957-29776-1-git-send-email-morten.rasmussen@arm.com>
X-OriginalArrivalTime: 11 Oct 2013 17:19:25.0661 (UTC) FILETIME=[08E7E8D0:01CEC6A6]
X-MC-Unique: 113101118192806201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r9BHLQO0031593

Infrastructure for power driver registration and defines three initial
power driver interface calls: go_faster(), go_slower(), and
at_max_capacity(). The intention is to use these to guide scheduling
decisions and frequency state selection in the power driver.

Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
---
 arch/arm/Kconfig            |    4 +++
 include/linux/sched/power.h |   32 ++++++++++++++++++++++++
 kernel/sched/Makefile       |    1 +
 kernel/sched/power.c        |   58 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+)
 create mode 100644 include/linux/sched/power.h
 create mode 100644 kernel/sched/power.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 43594d5..763d147 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1844,6 +1844,10 @@ config XEN
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
+config SCHED_POWER
+	bool "(EXPERIMENTAL) Power aware scheduling"
+	default n
+
 endmenu
 
 menu "Boot options"
diff --git a/include/linux/sched/power.h b/include/linux/sched/power.h
new file mode 100644
index 0000000..cb2cf37
--- /dev/null
+++ b/include/linux/sched/power.h
@@ -0,0 +1,32 @@
+/*
+ * include/linux/sched/power.h
+ *
+ * Copyright (C) 2013 ARM Limited.
+ * Author: Morten Rasmussen <morten.rasmussen@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef _LINUX_SCHED_POWER_H
+#define _LINUX_SCHED_POWER_H
+
+struct power_driver {
+
+	/*
+	 * Power driver calls may happen from scheduler context with irq
+	 * disabled and rq locks held. This must be taken into account in the
+	 * power driver.
+	 */
+
+	/* cpu already at max capacity? */
+	int (*at_max_capacity)	(int cpu);
+	/* Increase cpu capacity hint */
+	int (*go_faster)	(int cpu, int hint);
+	/* Decrease cpu capacity hint */
+	int (*go_slower)	(int cpu, int hint);
+};
+
+int power_driver_register(struct power_driver *driver);
+int power_driver_unregister(struct power_driver *driver);
+#endif
diff --git a/kernel/sched/Makefile b/kernel/sched/Makefile
index 54adcf3..55727b4 100644
--- a/kernel/sched/Makefile
+++ b/kernel/sched/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHEDSTATS) += stats.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
 obj-$(CONFIG_CGROUP_CPUACCT) += cpuacct.o
+obj-$(CONFIG_SCHED_POWER) += power.o
diff --git a/kernel/sched/power.c b/kernel/sched/power.c
new file mode 100644
index 0000000..b82965a
--- /dev/null
+++ b/kernel/sched/power.c
@@ -0,0 +1,58 @@
+/*
+ * kernel/sched/power.c
+ *
+ * Copyright (C) 2013 ARM Limited.
+ * Author: Morten Rasmussen <morten.rasmussen@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/sched/power.h>
+
+static struct power_driver *power_driver;
+
+int power_driver_register(struct power_driver *driver)
+{
+	power_driver = driver;
+
+	return 1;
+}
+
+int power_driver_unregister(struct power_driver *driver)
+{
+	power_driver = NULL;
+
+	return 1;
+}
+
+int at_max_capacity(int cpu)
+{
+	/* Assume no performance scaling when no driver */
+	if (!power_driver)
+		return 1;
+
+	return power_driver->at_max_capacity(cpu);
+}
+
+int go_faster(int cpu, int hint)
+{
+	/* Assume no performance scaling when no driver */
+	if (!power_driver)
+		return 0;
+
+	return power_driver->go_faster(cpu, hint);
+}
+
+int go_slower(int cpu, int hint)
+{
+	/* Assume no performance scaling when no driver */
+	if (!power_driver)
+		return 0;
+
+	return power_driver->go_slower(cpu, hint);
+}
+
-- 
1.7.9.5


