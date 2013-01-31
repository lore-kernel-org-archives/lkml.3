Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3AaTZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:25:07 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:45705 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab3AaTY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:24:58 -0500
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: OMAP2+: Export SoC information to userspace
Date: Thu, 31 Jan 2013 21:24:44 +0200
Message-Id: <1359660284-5225-3-git-send-email-ruslan.bilovol@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359660284-5225-1-git-send-email-ruslan.bilovol@ti.com>
References: <1359660284-5225-1-git-send-email-ruslan.bilovol@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some situations it is useful for userspace to
know some SoC-specific information. For example,
this may be used for deciding what kernel module to
use or how to better configure some settings etc.
This patch exports OMAP SoC information to userspace
using existing in Linux kernel SoC infrastructure.

This information can be read under
/sys/devices/socX directory

Signed-off-by: Ruslan Bilovol <ruslan.bilovol@ti.com>
---
 arch/arm/mach-omap2/Kconfig  |    1 +
 arch/arm/mach-omap2/common.h |    8 ++++++
 arch/arm/mach-omap2/id.c     |   65 ++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/io.c     |    1 +
 4 files changed, 75 insertions(+)

diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index fe926e0..47da0bd 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -17,6 +17,7 @@ config ARCH_OMAP2PLUS
 	select PROC_DEVICETREE if PROC_FS
 	select SPARSE_IRQ
 	select USE_OF
+	select SOC_BUS
 	help
 	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
 
diff --git a/arch/arm/mach-omap2/common.h b/arch/arm/mach-omap2/common.h
index 948bcaa..2a6f866 100644
--- a/arch/arm/mach-omap2/common.h
+++ b/arch/arm/mach-omap2/common.h
@@ -111,6 +111,14 @@ void ti81xx_init_late(void);
 void omap4430_init_late(void);
 int omap2_common_pm_late_init(void);
 
+#ifdef CONFIG_SOC_BUS
+void omap_soc_device_init(void);
+#else
+static inline void omap_soc_device_init(void)
+{
+}
+#endif
+
 #if defined(CONFIG_SOC_OMAP2420) || defined(CONFIG_SOC_OMAP2430)
 void omap2xxx_restart(char mode, const char *cmd);
 #else
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index 436fcf9..5724ee8 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -18,6 +18,11 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/io.h>
+#include <linux/slab.h>
+
+#ifdef CONFIG_SOC_BUS
+#include <linux/sys_soc.h>
+#endif
 
 #include <asm/cputype.h>
 
@@ -572,3 +577,63 @@ void __init omap2_set_globals_tap(u32 class, void __iomem *tap)
 	else
 		tap_prod_id = 0x0208;
 }
+
+#ifdef CONFIG_SOC_BUS
+
+static const char const *omap_types[] = {
+	[OMAP2_DEVICE_TYPE_TEST]	= "TST",
+	[OMAP2_DEVICE_TYPE_EMU]		= "EMU",
+	[OMAP2_DEVICE_TYPE_SEC]		= "HS",
+	[OMAP2_DEVICE_TYPE_GP]		= "GP",
+	[OMAP2_DEVICE_TYPE_BAD]		= "BAD",
+};
+
+static const char * __init omap_get_family(void)
+{
+	if (cpu_is_omap24xx())
+		return kasprintf(GFP_KERNEL, "OMAP2");
+	else if (cpu_is_omap34xx())
+		return kasprintf(GFP_KERNEL, "OMAP3");
+	else if (cpu_is_omap44xx())
+		return kasprintf(GFP_KERNEL, "OMAP4");
+	else if (soc_is_omap54xx())
+		return kasprintf(GFP_KERNEL, "OMAP5");
+	else
+		return kasprintf(GFP_KERNEL, "Unknown");
+}
+
+static ssize_t omap_get_type(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "%s\n", omap_types[omap_type()]);
+}
+
+static struct device_attribute omap_soc_attr =
+	__ATTR(type,  S_IRUGO, omap_get_type,  NULL);
+
+void __init omap_soc_device_init(void)
+{
+	struct device *parent;
+	struct soc_device *soc_dev;
+	struct soc_device_attribute *soc_dev_attr;
+
+	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	if (!soc_dev_attr)
+		return;
+
+	soc_dev_attr->machine  = cpu_name;
+	soc_dev_attr->family   = omap_get_family();
+	soc_dev_attr->revision = cpu_rev;
+
+	soc_dev = soc_device_register(soc_dev_attr);
+	if (IS_ERR_OR_NULL(soc_dev)) {
+		kfree(soc_dev_attr);
+		return;
+	}
+
+	parent = soc_device_to_device(soc_dev);
+	if (!IS_ERR_OR_NULL(parent))
+		device_create_file(parent, &omap_soc_attr);
+}
+#endif /* CONFIG_SOC_BUS */
diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 2c3fdd6..08003c1 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -602,6 +602,7 @@ void __init omap4430_init_late(void)
 	omap2_common_pm_late_init();
 	omap4_pm_init();
 	omap2_clk_enable_autoidle_all();
+	omap_soc_device_init();
 }
 #endif
 
-- 
1.7.9.5

