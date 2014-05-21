Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaEULWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 07:22:31 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53419 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbaEULW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 07:22:26 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <computersforpeace@gmail.com>
CC: <pekon@ti.com>, <ezequiel.garcia@free-electrons.com>,
        <robertcnelson@gmail.com>, <jg1.han@samsung.com>,
        <dwmw2@infradead.org>, <javier@dowhile0.org>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-mtd@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [RFC PATCH 03/16] ARM: OMAP2+: gmpc: add gpmc_generic_init()
Date: Wed, 21 May 2014 14:20:51 +0300
Message-ID: <1400671264-10702-4-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400671264-10702-1-git-send-email-rogerq@ti.com>
References: <1400671264-10702-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function populates platform data for the specified Chip Select.
It should be called by board init code.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++
 arch/arm/mach-omap2/gpmc.h |  6 ++++
 2 files changed, 75 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 9fe8c94..6b4a322 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -115,6 +115,8 @@
  */
 #define	GPMC_NR_IRQ		2
 
+static struct gpmc_omap_platform_data gpmc_pdata;
+
 struct gpmc_client_irq	{
 	unsigned		irq;
 	u32			bitmask;
@@ -1787,6 +1789,73 @@ static int __init omap_gpmc_init(void)
 }
 omap_postcore_initcall(omap_gpmc_init);
 
+/**
+ * gpmc_generic_init - Initialize platform data for a Chip Select
+ *
+ * @cs		chip select number
+ * @type	GPMC_OMAP_TYPE
+ * @settings	GPMC settings
+ * @device_timings	device timings for device on this CS
+ * @gpmc_timings	GPMC timings
+ * @pdev	platform device for the device on this CS
+ * @pdata_size	platform data size for the platform device
+ */
+int gpmc_generic_init(int cs, enum gpmc_omap_type type,
+		      struct gpmc_settings *settings,
+		      struct gpmc_device_timings *device_timings,
+		      struct gpmc_timings *gpmc_timings,
+		      struct platform_device *pdev, unsigned pdata_size)
+{
+	struct gpmc_settings *gpmc_s;
+	struct gpmc_device_timings *gpmc_dev_t;
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
+			return -ENOMEM;
+
+		gpmc_pdata.cs[cs].device_timings = gpmc_dev_t;
+	}
+
+	if (gpmc_timings) {
+		gpmc_t = kmemdup(gpmc_timings, sizeof(*gpmc_timings),
+				 GFP_KERNEL);
+		if (!gpmc_t)
+			return -ENOMEM;
+
+		gpmc_pdata.cs[cs].gpmc_timings = gpmc_t;
+	}
+
+	gpmc_pdata.cs[cs].type = type;
+	gpmc_pdata.cs[cs].pdev = pdev;
+	gpmc_pdata.cs[cs].pdata_size = pdata_size;
+	gpmc_pdata.cs[cs].valid = true;
+
+	return 0;
+}
+
 static irqreturn_t gpmc_handle_irq(int irq, void *dev)
 {
 	int i;
diff --git a/arch/arm/mach-omap2/gpmc.h b/arch/arm/mach-omap2/gpmc.h
index 681977f..c18b022 100644
--- a/arch/arm/mach-omap2/gpmc.h
+++ b/arch/arm/mach-omap2/gpmc.h
@@ -100,5 +100,11 @@ extern void omap3_gpmc_restore_context(void);
 extern int gpmc_configure(int cmd, int wval);
 extern void gpmc_read_settings_dt(struct device_node *np,
 				  struct gpmc_settings *p);
+extern int gpmc_generic_init(int cs, enum gpmc_omap_type type,
+			     struct gpmc_settings *settings,
+			     struct gpmc_device_timings *device_timings,
+			     struct gpmc_timings *gpmc_timings,
+			     struct platform_device *pdev,
+			     unsigned pdata_size);
 
 #endif
-- 
1.8.3.2

