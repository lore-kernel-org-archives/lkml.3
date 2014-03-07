Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963AbaCGE6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 23:58:39 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:58548 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751531AbaCGE6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:58:34 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH 6/9] powerpc/85xx: support sleep feature on QorIQ SoCs with RCPM
Date: Fri, 7 Mar 2014 12:58:02 +0800
Message-ID: <1394168285-32275-6-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sleep mode, the clocks of e500 cores and unused IP blocks is
turned off. The IP blocks which are allowed to wake up the processor
are still running.

The sleep mode is equal to the Standby state in Linux. Use the
command to enter sleep mode:
  echo standby > /sys/power/state

Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
---
 arch/powerpc/Kconfig                   |    4 +-
 arch/powerpc/platforms/85xx/Makefile   |    3 +
 arch/powerpc/platforms/85xx/qoriq_pm.c |   78 ++++++++++++++++++++++++++++++++
 3 files changed, 83 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/platforms/85xx/qoriq_pm.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 05f6323..e1d6510 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -222,7 +222,7 @@ config ARCH_HIBERNATION_POSSIBLE
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 	depends on ADB_PMU || PPC_EFIKA || PPC_LITE5200 || PPC_83xx || \
-		   (PPC_85xx && !PPC_E500MC) || PPC_86xx || PPC_PSERIES \
+		   FSL_SOC_BOOKE || PPC_86xx || PPC_PSERIES \
 		   || 44x || 40x
 
 config PPC_DCR_NATIVE
@@ -709,7 +709,7 @@ config FSL_PCI
 config FSL_PMC
 	bool
 	default y
-	depends on SUSPEND && (PPC_85xx || PPC_86xx)
+	depends on SUSPEND && (PPC_85xx && !PPC_E500MC || PPC_86xx)
 	help
 	  Freescale MPC85xx/MPC86xx power management controller support
 	  (suspend/resume). For MPC83xx see platforms/83xx/suspend.c
diff --git a/arch/powerpc/platforms/85xx/Makefile b/arch/powerpc/platforms/85xx/Makefile
index 25cebe7..7fae817 100644
--- a/arch/powerpc/platforms/85xx/Makefile
+++ b/arch/powerpc/platforms/85xx/Makefile
@@ -2,6 +2,9 @@
 # Makefile for the PowerPC 85xx linux kernel.
 #
 obj-$(CONFIG_SMP) += smp.o
+ifeq ($(CONFIG_FSL_CORENET_RCPM), y)
+obj-$(CONFIG_SUSPEND)	+= qoriq_pm.o
+endif
 
 obj-y += common.o
 
diff --git a/arch/powerpc/platforms/85xx/qoriq_pm.c b/arch/powerpc/platforms/85xx/qoriq_pm.c
new file mode 100644
index 0000000..915b13b
--- /dev/null
+++ b/arch/powerpc/platforms/85xx/qoriq_pm.c
@@ -0,0 +1,78 @@
+/*
+ * Support Power Management feature
+ *
+ * Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * Author: Chenhui Zhao <chenhui.zhao@freescale.com>
+ *
+ * This program is free software; you can redistribute	it and/or modify it
+ * under  the terms of	the GNU General	 Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/suspend.h>
+#include <linux/of_platform.h>
+
+#include <sysdev/fsl_soc.h>
+
+#define FSL_SLEEP		0x1
+#define FSL_DEEP_SLEEP		0x2
+
+/* specify the sleep state of the present platform */
+int sleep_pm_state;
+/* supported sleep modes by the present platform */
+static unsigned int sleep_modes;
+
+static int qoriq_suspend_enter(suspend_state_t state)
+{
+	int ret = 0;
+
+	switch (state) {
+	case PM_SUSPEND_STANDBY:
+
+		if (cur_cpu_spec->cpu_flush_caches)
+			cur_cpu_spec->cpu_flush_caches();
+
+		ret = qoriq_pm_ops->plat_enter_state(sleep_pm_state);
+
+		break;
+
+	default:
+		ret = -EINVAL;
+
+	}
+
+	return ret;
+}
+
+static int qoriq_suspend_valid(suspend_state_t state)
+{
+	if (state == PM_SUSPEND_STANDBY && (sleep_modes & FSL_SLEEP))
+		return 1;
+
+	return 0;
+}
+
+static const struct platform_suspend_ops qoriq_suspend_ops = {
+	.valid = qoriq_suspend_valid,
+	.enter = qoriq_suspend_enter,
+};
+
+static int __init qoriq_suspend_init(void)
+{
+	struct device_node *np;
+
+	sleep_modes = FSL_SLEEP;
+	sleep_pm_state = PLAT_PM_SLEEP;
+
+	np = of_find_compatible_node(NULL, NULL, "fsl,qoriq-rcpm-2.0");
+	if (np)
+		sleep_pm_state = PLAT_PM_LPM20;
+
+	suspend_set_ops(&qoriq_suspend_ops);
+
+	return 0;
+}
+arch_initcall(qoriq_suspend_init);
-- 
1.7.3


