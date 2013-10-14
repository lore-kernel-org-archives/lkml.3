Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab3JNVDA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:03:00 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:36881 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab3JNVC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:02:56 -0400
From: Marek Belisko <marek@goldelico.com>
To: tony@atomide.com, linux@arm.linux.org.uk, tomi.valkeinen@ti.com,
        plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        neilb@suse.de, hns@goldelico.com, Marek Belisko <marek@goldelico.com>
Subject: [PATCH 1/3] arm: omap2: Export devconf1 bypass and acbias.
Date: Mon, 14 Oct 2013 23:02:33 +0200
Message-Id: <1381784555-18344-2-git-send-email-marek@goldelico.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381784555-18344-1-git-send-email-marek@goldelico.com>
References: <1381784555-18344-1-git-send-email-marek@goldelico.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devconf1 reg access is localized only in mach-omap2 and we need to export
updating of devconf1 from omapdss venc driver (bypass and acbias bits).
Add simple api call which update only necessary bits.

Signed-off-by: Marek Belisko <marek@goldelico.com>
---
 arch/arm/mach-omap2/Makefile      |  2 ++
 arch/arm/mach-omap2/control.h     |  2 ++
 arch/arm/mach-omap2/omap3-tvout.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/omap-tvout.h        | 14 ++++++++++++++
 4 files changed, 54 insertions(+)
 create mode 100644 arch/arm/mach-omap2/omap3-tvout.c
 create mode 100644 include/linux/omap-tvout.h

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index afb457c..15e0f28 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -306,3 +306,5 @@ emac-$(CONFIG_TI_DAVINCI_EMAC)		:= am35xx-emac.o
 obj-y					+= $(emac-m) $(emac-y)
 
 obj-y					+= common-board-devices.o twl-common.o dss-common.o
+
+obj-$(CONFIG_ARCH_OMAP3)		+= omap3-tvout.o
diff --git a/arch/arm/mach-omap2/control.h b/arch/arm/mach-omap2/control.h
index f7d7c2e..65277f1 100644
--- a/arch/arm/mach-omap2/control.h
+++ b/arch/arm/mach-omap2/control.h
@@ -279,6 +279,8 @@
 
 /* CONTROL_DEVCONF1 bits */
 #define OMAP243X_MMC1_ACTIVE_OVERWRITE	(1 << 31)
+#define OMAP2_TVOUTBYPASS		(1 << 18)
+#define OMAP2_TVACEN			(1 << 11)
 #define OMAP2_MMCSDIO2ADPCLKISEL	(1 << 6) /* MMC2 loop back clock */
 #define OMAP2_MCBSP5_CLKS_MASK		(1 << 4) /* > 242x */
 #define OMAP2_MCBSP4_CLKS_MASK		(1 << 2) /* > 242x */
diff --git a/arch/arm/mach-omap2/omap3-tvout.c b/arch/arm/mach-omap2/omap3-tvout.c
new file mode 100644
index 0000000..eaed225
--- /dev/null
+++ b/arch/arm/mach-omap2/omap3-tvout.c
@@ -0,0 +1,36 @@
+/*
+ * linux/arch/arm/mach-omap2/omap3-tvout.c
+ *
+ * Copyright (C) 2013 Golden Delicious Computers
+ * Author: Marek Belisko <marek@goldelico.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/omap-tvout.h>
+
+#include "soc.h"
+#include "control.h"
+
+void update_bypass_acbias(bool bypass, bool acbias)
+{
+#ifdef CONFIG_ARCH_OMAP3
+	int val = omap_ctrl_readl(OMAP343X_CONTROL_DEVCONF1);
+
+	if (bypass)
+		val |= OMAP2_TVOUTBYPASS;
+	else
+		val &= ~OMAP2_TVOUTBYPASS;
+
+	if (acbias)
+		val |= OMAP2_TVACEN;
+	else
+		val &= ~OMAP2_TVACEN;
+
+	omap_ctrl_writel(val, OMAP343X_CONTROL_DEVCONF1);
+#endif
+}
+
diff --git a/include/linux/omap-tvout.h b/include/linux/omap-tvout.h
new file mode 100644
index 0000000..25f676d
--- /dev/null
+++ b/include/linux/omap-tvout.h
@@ -0,0 +1,14 @@
+/*
+ * OMAP TV-out support
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#ifndef __LINUX_OMAP_TVOUT_H
+#define __LINUX_OMAP_TVOUT_H
+
+extern void update_bypass_acbias(bool bypass, bool acbias);
+
+#endif
+
-- 
1.8.1.2

