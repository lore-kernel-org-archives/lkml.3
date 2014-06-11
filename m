Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932780AbaFKJHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 05:07:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56341 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaFKI6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:35 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 22/36] ARM: OMAP2+: gmpc: add gpmc_generic_init()
Date: Wed, 11 Jun 2014 11:56:27 +0300
Message-ID: <1402477001-31132-23-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function populates platform data for the specified Chip Select.
It should be called by board init code.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/gpmc.h |  6 ++++
 2 files changed, 85 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index ee030cd..d3a64ed 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -30,6 +30,7 @@
 #include <linux/of_mtd.h>
 #include <linux/of_device.h>
 #include <linux/pm_runtime.h>
+#include <linux/slab.h>
 
 #include <linux/platform_data/mtd-nand-omap2.h>
 
@@ -108,6 +109,8 @@
 
 #define GPMC_NR_WAITPINS		4
 
+static struct gpmc_omap_platform_data gpmc_pdata;
+
 /* Structure to save gpmc cs context */
 struct gpmc_cs_config {
 	u32 config1;
@@ -1510,6 +1513,82 @@ static int __init omap_gpmc_init(void)
 omap_postcore_initcall(omap_gpmc_init);
 
 /**
+ * gpmc_generic_init - Initialize platform data for a Chip Select
+ *
+ * @cs		chip select number
+ * @is_nand	true if device is NAND flash.
+ * @settings	GPMC settings
+ * @device_timings	device timings for device on this CS
+ * @gpmc_timings	GPMC timings
+ * @pdev	platform device for the device on this CS
+ * @pdata_size	platform data size for the platform device
+ */
+int gpmc_generic_init(int cs, bool is_nand,
+		      struct gpmc_settings *settings,
+		      struct gpmc_device_timings *device_timings,
+		      struct gpmc_timings *gpmc_timings,
+		      struct platform_device *pdev, unsigned pdata_size)
+{
+	struct gpmc_settings *gpmc_s = NULL;
+	struct gpmc_device_timings *gpmc_dev_t = NULL;
+	struct gpmc_timings *gpmc_t;
+
+	if (cs >= GPMC_CS_NUM) {
+		pr_err("%s: Invalid cs specified. Max CS = %d\n",
+		       __func__, GPMC_CS_NUM);
+		return -EINVAL;
+	}
+
+	if (gpmc_pdata.cs[cs].valid) {
+		pr_err("%s: cs %d already requested, ignoring new request\n",
+		       __func__, cs);
+		return -EINVAL;
+	}
+
+	if (settings) {
+		gpmc_s = kmemdup(settings, sizeof(*settings), GFP_KERNEL);
+		if (!gpmc_s)
+			return -ENOMEM;
+
+		gpmc_pdata.cs[cs].settings = gpmc_s;
+	}
+
+	if (device_timings) {
+		gpmc_dev_t = kmemdup(device_timings, sizeof(*device_timings),
+				     GFP_KERNEL);
+		if (!gpmc_dev_t)
+			goto dev_t_fail;
+
+		gpmc_pdata.cs[cs].device_timings = gpmc_dev_t;
+	}
+
+	if (gpmc_timings) {
+		gpmc_t = kmemdup(gpmc_timings, sizeof(*gpmc_timings),
+				 GFP_KERNEL);
+		if (!gpmc_t)
+			goto gpmc_t_fail;
+
+		gpmc_pdata.cs[cs].gpmc_timings = gpmc_t;
+	}
+
+	gpmc_pdata.cs[cs].is_nand = is_nand;
+	gpmc_pdata.cs[cs].pdev = pdev;
+	gpmc_pdata.cs[cs].pdata_size = pdata_size;
+	gpmc_pdata.cs[cs].valid = true;
+
+	return 0;
+
+gpmc_t_fail:
+	if (device_timings)
+		kfree(gpmc_dev_t);
+dev_t_fail:
+	if (settings)
+		kfree(gpmc_s);
+
+	return -ENOMEM;
+}
+
+/**
  * omap_gpmc_retime - Reconfigre GPMC timings for the device
  *
  * @cs		Chip select number
diff --git a/arch/arm/mach-omap2/gpmc.h b/arch/arm/mach-omap2/gpmc.h
index 6204913..301bc66 100644
--- a/arch/arm/mach-omap2/gpmc.h
+++ b/arch/arm/mach-omap2/gpmc.h
@@ -77,5 +77,11 @@ extern void omap3_gpmc_save_context(void);
 extern void omap3_gpmc_restore_context(void);
 extern void gpmc_read_settings_dt(struct device_node *np,
 				  struct gpmc_settings *p);
+int gpmc_generic_init(int cs, bool is_nand,
+		      struct gpmc_settings *settings,
+		      struct gpmc_device_timings *device_timings,
+		      struct gpmc_timings *gpmc_timings,
+		      struct platform_device *pdev,
+		      unsigned pdata_size);
 
 #endif
-- 
1.8.3.2

