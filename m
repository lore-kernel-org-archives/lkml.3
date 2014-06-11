Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbaFKI6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:58:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56302 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbaFKI6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:58:04 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <dwmw2@infradead.org>, <computersforpeace@gmail.com>
CC: <kyungmin.park@samsung.com>, <pekon@ti.com>,
        <ezequiel.garcia@free-electrons.com>, <javier@dowhile0.org>,
        <nsekhar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-mtd@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH 14/36] ARM: OMAP2+: gpmc: Allow drivers to reconfigure GPMC settings & timings
Date: Wed, 11 Jun 2014 11:56:19 +0300
Message-ID: <1402477001-31132-15-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402477001-31132-1-git-send-email-rogerq@ti.com>
References: <1402477001-31132-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices (e.g. TUSB6010, omap-onenand) need to reconfigure the GPMC
timings in order to operate with different peripheral clock frequencies.
Introduce omap_gpmc_retime() to allow them to do that. The driver
needs to pass the chips select number, GPMC settings and Device timings to
omap_gpmc_retime().

NOTE: Device tree and board code must still pass the most conservative
timings to GPMC so that the device can be probed by the respective driver.
e.g. Onenand must operate in asynchronous mode at bootup. The device driver
can then request for more optimal timings via omap_gpmc_retime().

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/mach-omap2/gpmc.c              | 36 +++++++++++++++++++++++++++++++++
 include/linux/platform_data/gpmc-omap.h | 12 +++++++++++
 2 files changed, 48 insertions(+)

diff --git a/arch/arm/mach-omap2/gpmc.c b/arch/arm/mach-omap2/gpmc.c
index 70cb6b0..90b7686 100644
--- a/arch/arm/mach-omap2/gpmc.c
+++ b/arch/arm/mach-omap2/gpmc.c
@@ -1542,6 +1542,42 @@ static int __init omap_gpmc_init(void)
 }
 omap_postcore_initcall(omap_gpmc_init);
 
+/**
+ * omap_gpmc_retime - Reconfigre GPMC timings for the device
+ *
+ * @cs		Chip select number
+ * @gpmc_s	GPMC settings
+ * @dev_t	New device timings to set
+ */
+int omap_gpmc_retime(int cs, struct gpmc_settings *gpmc_s,
+		     struct gpmc_device_timings *dev_t)
+{
+	struct gpmc_timings gpmc_t;
+	struct device *dev = gpmc_dev;
+
+	if (!gpmc_dev)
+		return -ENODEV;
+
+	if (cs < 0 || cs >= gpmc_cs_num) {
+		dev_err(dev, "%s: Invalid find Chip Select\n", __func__);
+		return cs;
+	}
+
+	if (gpmc_cs_program_settings(cs, gpmc_s)) {
+		dev_err(dev, "%s: Failed to set GPMC settings\n", __func__);
+		return -EINVAL;
+	}
+
+	gpmc_calc_timings(&gpmc_t, gpmc_s, dev_t);
+	if (gpmc_cs_set_timings(cs, &gpmc_t)) {
+		dev_err(dev, "%s: Failed to set GPMC timings\n", __func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(omap_gpmc_retime);
+
 static struct omap3_gpmc_regs gpmc_context;
 
 void omap3_gpmc_save_context(void)
diff --git a/include/linux/platform_data/gpmc-omap.h b/include/linux/platform_data/gpmc-omap.h
index e861112..0d40c2a 100644
--- a/include/linux/platform_data/gpmc-omap.h
+++ b/include/linux/platform_data/gpmc-omap.h
@@ -166,4 +166,16 @@ struct gpmc_omap_platform_data {
 	struct gpmc_omap_cs_data cs[GPMC_CS_NUM];
 };
 
+#ifdef CONFIG_ARCH_OMAP2PLUS
+int omap_gpmc_retime(int cs, struct gpmc_settings *gpmc_s,
+		     struct gpmc_device_timings *dev_t);
+#else
+static inline int omap_gpmc_retime(int cs,
+				   struct gpmc_settings *gpmc_s,
+				   struct gpmc_device_timings *dev_t)
+{
+	return 0;
+}
+#endif /* CONFIG_ARCH_OMAP2PLUS */
+
 #endif /* _GPMC_OMAP_H */
-- 
1.8.3.2

