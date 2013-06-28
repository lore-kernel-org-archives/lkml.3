Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3F1LV1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 07:21:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25721 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627Ab3F1LVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 07:21:12 -0400
X-IronPort-AV: E=Sophos;i="4.87,958,1363132800"; 
   d="scan'208";a="34056485"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <nico@linaro.org>, <cov@codeaurora.org>, <Catalin.Marinas@arm.com>
Subject: [PATCH v7 4/6] arm64: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
Date: Fri, 28 Jun 2013 12:20:45 +0100
Message-ID: <1372418447-24066-4-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306271614260.4782@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306271614260.4782@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM64.
Necessary duplication of paravirt.h and paravirt.c with ARM.

The only paravirt interface supported is pv_time_ops.steal_clock, so no
runtime pvops patching needed.

This allows us to make use of steal_account_process_tick for stolen
ticks accounting.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: will.deacon@arm.com
CC: nico@linaro.org
CC: marc.zyngier@arm.com
CC: cov@codeaurora.org
CC: arnd@arndb.de
CC: olof@lixom.net
CC: Catalin.Marinas@arm.com

---
Changes in v7:
- ifdef CONFIG_PARAVIRT the content of paravirt.h.
---
 arch/arm64/Kconfig                |   20 ++++++++++++++++++++
 arch/arm64/include/asm/paravirt.h |   20 ++++++++++++++++++++
 arch/arm64/kernel/Makefile        |    1 +
 arch/arm64/kernel/paravirt.c      |   25 +++++++++++++++++++++++++
 4 files changed, 66 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/paravirt.h
 create mode 100644 arch/arm64/kernel/paravirt.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1fac4e5..4c4f213 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -190,6 +190,25 @@ config HW_PERF_EVENTS
 
 source "mm/Kconfig"
 
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	---help---
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.
+
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	select PARAVIRT
+	default n
+	---help---
+	  Select this option to enable fine granularity task steal time
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
 config XEN_DOM0
 	def_bool y
 	depends on XEN
@@ -197,6 +216,7 @@ config XEN_DOM0
 config XEN
 	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
 	depends on ARM64 && OF
+	select PARAVIRT
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM64.
 
diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
new file mode 100644
index 0000000..fd5f428
--- /dev/null
+++ b/arch/arm64/include/asm/paravirt.h
@@ -0,0 +1,20 @@
+#ifndef _ASM_ARM64_PARAVIRT_H
+#define _ASM_ARM64_PARAVIRT_H
+
+#ifdef CONFIG_PARAVIRT
+struct static_key;
+extern struct static_key paravirt_steal_enabled;
+extern struct static_key paravirt_steal_rq_enabled;
+
+struct pv_time_ops {
+	unsigned long long (*steal_clock)(int cpu);
+};
+extern struct pv_time_ops pv_time_ops;
+
+static inline u64 paravirt_steal_clock(int cpu)
+{
+	return pv_time_ops.steal_clock(cpu);
+}
+#endif
+
+#endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 7b4b564..17613ad 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -18,6 +18,7 @@ arm64-obj-$(CONFIG_SMP)			+= smp.o smp_spin_table.o smp_psci.o
 arm64-obj-$(CONFIG_HW_PERF_EVENTS)	+= perf_event.o
 arm64-obj-$(CONFIG_HAVE_HW_BREAKPOINT)+= hw_breakpoint.o
 arm64-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+arm64-obj-$(CONFIG_PARAVIRT)		+= paravirt.o
 
 obj-y					+= $(arm64-obj-y) vdso/
 obj-m					+= $(arm64-obj-m)
diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
new file mode 100644
index 0000000..53f371e
--- /dev/null
+++ b/arch/arm64/kernel/paravirt.c
@@ -0,0 +1,25 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Copyright (C) 2013 Citrix Systems
+ *
+ * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
+ */
+
+#include <linux/export.h>
+#include <linux/jump_label.h>
+#include <linux/types.h>
+#include <asm/paravirt.h>
+
+struct static_key paravirt_steal_enabled;
+struct static_key paravirt_steal_rq_enabled;
+
+struct pv_time_ops pv_time_ops;
+EXPORT_SYMBOL_GPL(pv_time_ops);
-- 
1.7.2.5

