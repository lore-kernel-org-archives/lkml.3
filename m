Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3E3NgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:36:14 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10603 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476Ab3E3Nf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:35:27 -0400
X-IronPort-AV: E=Sophos;i="4.87,770,1363132800"; 
   d="scan'208";a="28237210"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>,
        "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        <nico@linaro.org>, <cov@codeaurora.org>
Subject: [PATCH v5 3/4] arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
Date: Thu, 30 May 2013 14:35:01 +0100
Message-ID: <1369920902-3546-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305301426520.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301426520.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM.

The only paravirt interface supported is pv_time_ops.steal_clock, so no
runtime pvops patching needed.

This allows us to make use of steal_account_process_tick for stolen
ticks accounting.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Christopher Covington <cov@codeaurora.org>
CC: linux@arm.linux.org.uk
CC: will.deacon@arm.com
CC: nico@linaro.org
CC: marc.zyngier@arm.com
CC: cov@codeaurora.org
CC: arnd@arndb.de
CC: olof@lixom.net

Changes in v3:
- improve commit description and Kconfig help text;
- no need to initialize pv_time_ops;
- add PARAVIRT_TIME_ACCOUNTING.
---
 arch/arm/Kconfig                |   20 ++++++++++++++++++++
 arch/arm/include/asm/paravirt.h |   19 +++++++++++++++++++
 arch/arm/kernel/Makefile        |    1 +
 arch/arm/kernel/paravirt.c      |   25 +++++++++++++++++++++++++
 4 files changed, 65 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/include/asm/paravirt.h
 create mode 100644 arch/arm/kernel/paravirt.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 49d993c..5621a02 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1786,12 +1786,32 @@ config XEN_DOM0
 	def_bool y
 	depends on XEN
 
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
 config XEN
 	bool "Xen guest support on ARM (EXPERIMENTAL)"
 	depends on ARM && AEABI && OF
 	depends on CPU_V7 && !CPU_V6
 	depends on !GENERIC_ATOMIC64
 	select ARM_PSCI
+	select PARAVIRT
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
diff --git a/arch/arm/include/asm/paravirt.h b/arch/arm/include/asm/paravirt.h
new file mode 100644
index 0000000..3b95bc6
--- /dev/null
+++ b/arch/arm/include/asm/paravirt.h
@@ -0,0 +1,19 @@
+#ifndef _ASM_ARM_PARAVIRT_H
+#define _ASM_ARM_PARAVIRT_H
+
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
+
+
+#endif
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 5f3338e..d911db6 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
 ifneq ($(CONFIG_ARCH_EBSA110),y)
   obj-y		+= io.o
 endif
+obj-$(CONFIG_PARAVIRT)	+= paravirt.o
 
 head-y			:= head$(MMUEXT).o
 obj-$(CONFIG_DEBUG_LL)	+= debug.o
diff --git a/arch/arm/kernel/paravirt.c b/arch/arm/kernel/paravirt.c
new file mode 100644
index 0000000..53f371e
--- /dev/null
+++ b/arch/arm/kernel/paravirt.c
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

