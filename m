Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3GCOGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:06:50 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49916 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932815Ab3GCOES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:04:18 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>, <nm@ti.com>
Subject: [PATCH v3 2/8] wlcore: set irq_flags in the board files instead of hiding behind a quirk
Date: Wed, 3 Jul 2013 17:03:23 +0300
Message-ID: <1372860209-3504-3-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372860209-3504-1-git-send-email-coelho@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_quirk element in the platform data was used to change the
way the IRQ is triggered.  When set, the EDGE_IRQ quirk would change
the irqflags used and treat edge trigger differently from the rest.

Instead of hiding this irq flag setting behind the quirk, have the
board files set the flags during initialization.  This will be more
meaningful than driver-specific quirks when we switch to DT.

Additionally, fix missing gpio_request() calls in the boarding files
(so that setting the flags actually works).

Cc: Tony Lindgren <tony@atomide.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c      |    8 +++++-
 arch/arm/mach-omap2/board-4430sdp.c          |   18 +++++++++++++
 arch/arm/mach-omap2/board-omap3evm.c         |   19 ++++++++++++++
 arch/arm/mach-omap2/board-omap4panda.c       |   36 +++++++++++++++++++++-----
 arch/arm/mach-omap2/board-zoom-peripherals.c |   30 ++++++++++++++++++---
 drivers/net/wireless/ti/wlcore/debugfs.c     |    2 +-
 drivers/net/wireless/ti/wlcore/main.c        |   24 ++++++++++-------
 drivers/net/wireless/ti/wlcore/wlcore.h      |    5 ++--
 include/linux/wl12xx.h                       |    4 ---
 9 files changed, 118 insertions(+), 28 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 8a24b6c..544b6fa 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1378,7 +1378,6 @@ static const short da850_wl12xx_pins[] __initconst = {
 static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata = {
 	.irq			= -1,
 	.board_ref_clock	= WL12XX_REFCLOCK_38,
-	.platform_quirks	= WL12XX_PLATFORM_QUIRK_EDGE_IRQ,
 };
 
 static __init int da850_wl12xx_init(void)
@@ -1409,6 +1408,13 @@ static __init int da850_wl12xx_init(void)
 		goto free_wlan_en;
 	}
 
+	ret = irq_set_irq_type(gpio_to_irq(DA850_WLAN_IRQ),
+			       IRQ_TYPE_EDGE_RISING);
+	if (ret) {
+		pr_err("Could not set wl12xx irq type: %d\n", ret);
+		goto free;
+	}
+
 	da850_wl12xx_wlan_data.irq = gpio_to_irq(DA850_WLAN_IRQ);
 
 	ret = wl12xx_set_platform_data(&da850_wl12xx_wlan_data);
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 56a9a4f..953f620 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -703,12 +703,30 @@ static void __init omap4_sdp4430_wifi_init(void)
 
 	omap4_sdp4430_wifi_mux_init();
 	omap4_sdp4430_wlan_data.irq = gpio_to_irq(GPIO_WIFI_IRQ);
+
+	ret = gpio_request_one(GPIO_WIFI_IRQ, GPIOF_IN, "GPIO_WIFI_IRQ");
+	if (ret) {
+		pr_err("error requesting wl12xx gpio: %d\n", ret);
+		goto out;
+	}
+
+	ret = irq_set_irq_type(gpio_to_irq(GPIO_WIFI_IRQ), IRQ_TYPE_LEVEL_HIGH);
+	if (ret) {
+		pr_err("error setting wl12xx irq type: %d\n", ret);
+		goto free;
+	}
+
 	ret = wl12xx_set_platform_data(&omap4_sdp4430_wlan_data);
 	if (ret)
 		pr_err("Error setting wl12xx data: %d\n", ret);
+
 	ret = platform_device_register(&omap_vwlan_device);
 	if (ret)
 		pr_err("Error registering wl12xx device: %d\n", ret);
+out:
+	return;
+free:
+	gpio_free(GPIO_WIFI_IRQ);
 }
 
 static void __init omap_4430sdp_init(void)
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index f76d0de..8abce3cd 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -612,12 +612,31 @@ static void __init omap3_evm_wl12xx_init(void)
 
 	/* WL12xx WLAN Init */
 	omap3evm_wlan_data.irq = gpio_to_irq(OMAP3EVM_WLAN_IRQ_GPIO);
+
+	ret = gpio_request_one(OMAP3EVM_WLAN_IRQ_GPIO, GPIOF_IN,
+			       "OMAP3EVM_WLAN_IRQ_GPIO");
+	if (ret) {
+		pr_err("error requesting wl12xx gpio: %d\n", ret);
+		goto out;
+	}
+
+	ret = irq_set_irq_type(gpio_to_irq(OMAP3EVM_WLAN_IRQ_GPIO),
+			       IRQ_TYPE_LEVEL_HIGH);
+	if (ret) {
+		pr_err("error setting wl12xx irq type: %d\n", ret);
+		goto free;
+	}
+
 	ret = wl12xx_set_platform_data(&omap3evm_wlan_data);
 	if (ret)
 		pr_err("error setting wl12xx data: %d\n", ret);
 	ret = platform_device_register(&omap3evm_wlan_regulator);
 	if (ret)
 		pr_err("error registering wl12xx device: %d\n", ret);
+out:
+	return;
+free:
+	gpio_free(OMAP3EVM_WLAN_IRQ_GPIO);
 #endif
 }
 
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 1e2c75e..5b33626 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -413,20 +413,44 @@ static void omap4_panda_init_rev(void)
 	}
 }
 
+static void __init omap4_panda_wilink_init(void)
+{
+	int ret;
+
+	omap_panda_wlan_data.irq = gpio_to_irq(GPIO_WIFI_IRQ);
+
+	ret = gpio_request_one(GPIO_WIFI_IRQ, GPIOF_IN, "GPIO_WIFI_IRQ");
+	if (ret) {
+		pr_err("error requesting wl12xx gpio: %d\n", ret);
+		goto out;
+	}
+
+	ret = irq_set_irq_type(gpio_to_irq(GPIO_WIFI_IRQ), IRQ_TYPE_LEVEL_HIGH);
+	if (ret) {
+		pr_err("error setting wl12xx irq type: %d\n", ret);
+		goto free;
+	}
+
+	ret = wl12xx_set_platform_data(&omap_panda_wlan_data);
+	if (ret) {
+		pr_err("error setting wl12xx data: %d\n", ret);
+		goto free;
+	}
+out:
+	return;
+free:
+	gpio_free(GPIO_WIFI_IRQ);
+}
+
 static void __init omap4_panda_init(void)
 {
 	int package = OMAP_PACKAGE_CBS;
-	int ret;
 
 	if (omap_rev() == OMAP4430_REV_ES1_0)
 		package = OMAP_PACKAGE_CBL;
 	omap4_mux_init(board_mux, NULL, package);
 
-	omap_panda_wlan_data.irq = gpio_to_irq(GPIO_WIFI_IRQ);
-	ret = wl12xx_set_platform_data(&omap_panda_wlan_data);
-	if (ret)
-		pr_err("error setting wl12xx data: %d\n", ret);
-
+	omap4_panda_wilink_init();
 	omap4_panda_init_rev();
 	omap4_panda_i2c_init();
 	platform_add_devices(panda_devices, ARRAY_SIZE(panda_devices));
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index a90375d..4f84cf9 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -339,16 +339,40 @@ static void enable_board_wakeup_source(void)
 		OMAP_WAKEUP_EN | OMAP_PIN_INPUT_PULLUP);
 }
 
-void __init zoom_peripherals_init(void)
+static void __init zoom_wilink_init(void)
 {
 	int ret;
 
 	omap_zoom_wlan_data.irq = gpio_to_irq(OMAP_ZOOM_WLAN_IRQ_GPIO);
-	ret = wl12xx_set_platform_data(&omap_zoom_wlan_data);
 
-	if (ret)
+	ret = gpio_request_one(OMAP_ZOOM_WLAN_IRQ_GPIO, GPIOF_IN,
+			       "OMAP_ZOOM_WLAN_IRQ_GPIO");
+	if (ret) {
+		pr_err("error requesting wl12xx gpio: %d\n", ret);
+		goto out;
+	}
+
+	ret = irq_set_irq_type(gpio_to_irq(OMAP_ZOOM_WLAN_IRQ_GPIO),
+			       IRQ_TYPE_LEVEL_HIGH);
+	if (ret) {
+		pr_err("error setting wl12xx irq type: %d\n", ret);
+		goto free;
+	}
+
+	ret = wl12xx_set_platform_data(&omap_zoom_wlan_data);
+	if (ret) {
 		pr_err("error setting wl12xx data: %d\n", ret);
+		goto free;
+	}
+out:
+	return;
+free:
+	gpio_free(OMAP_ZOOM_WLAN_IRQ_GPIO);
+}
 
+void __init zoom_peripherals_init(void)
+{
+	zoom_wilink_init();
 	omap_hsmmc_init(mmc);
 	omap_i2c_init();
 	pwm_add_table(zoom_pwm_lookup, ARRAY_SIZE(zoom_pwm_lookup));
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index c3e1f79..5eff663 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -486,7 +486,7 @@ static ssize_t driver_state_read(struct file *file, char __user *user_buf,
 	DRIVER_STATE_PRINT_HEX(irq);
 	/* TODO: ref_clock and tcxo_clock were moved to wl12xx priv */
 	DRIVER_STATE_PRINT_HEX(hw_pg_ver);
-	DRIVER_STATE_PRINT_HEX(platform_quirks);
+	DRIVER_STATE_PRINT_HEX(irq_flags);
 	DRIVER_STATE_PRINT_HEX(chip.id);
 	DRIVER_STATE_PRINT_STR(chip.fw_ver_str);
 	DRIVER_STATE_PRINT_STR(chip.phy_fw_ver_str);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index b8db55c..7b5d0cc 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -27,6 +27,7 @@
 #include <linux/vmalloc.h>
 #include <linux/wl12xx.h>
 #include <linux/interrupt.h>
+#include <linux/irq.h>
 
 #include "wlcore.h"
 #include "debug.h"
@@ -516,7 +517,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 	 * In case edge triggered interrupt must be used, we cannot iterate
 	 * more than once without introducing race conditions with the hardirq.
 	 */
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+	if (wl->irq_flags & IRQF_TRIGGER_RISING)
 		loopcount = 1;
 
 	wl1271_debug(DEBUG_IRQ, "IRQ work");
@@ -5765,7 +5766,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
-	wl->platform_quirks = 0;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
 	wl->active_link_count = 0;
@@ -5900,8 +5900,7 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	struct wl1271 *wl = context;
 	struct platform_device *pdev = wl->pdev;
 	struct wlcore_platdev_data *pdev_data = pdev->dev.platform_data;
-	struct wl12xx_platform_data *pdata = pdev_data->pdata;
-	unsigned long irqflags;
+	struct irq_data *irq_data;
 	int ret;
 
 	if (fw) {
@@ -5928,16 +5927,21 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	wlcore_adjust_conf(wl);
 
 	wl->irq = platform_get_irq(pdev, 0);
-	wl->platform_quirks = pdata->platform_quirks;
 	wl->if_ops = pdev_data->if_ops;
 
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
-		irqflags = IRQF_TRIGGER_RISING;
-	else
-		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
+	irq_data = irq_get_irq_data(wl->irq);
+	if (!irq_data) {
+		wl1271_error("couldn't get irq data for irq %d\n", wl->irq);
+		ret = -EINVAL;
+		goto out_free_nvs;
+	}
+
+	wl->irq_flags = irqd_get_trigger_type(irq_data);
+	/* Since we don't use the primary handler, we must set ONESHOT */
+	wl->irq_flags |= IRQF_ONESHOT;
 
 	ret = request_threaded_irq(wl->irq, NULL, wlcore_irq,
-				   irqflags, pdev->name, wl);
+				   wl->irq_flags, pdev->name, wl);
 	if (ret < 0) {
 		wl1271_error("request_irq() failed: %d", ret);
 		goto out_free_nvs;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0034979..8306bde 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -185,6 +185,8 @@ struct wl1271 {
 
 	int irq;
 
+	int irq_flags;
+
 	spinlock_t wl_lock;
 
 	enum wlcore_state state;
@@ -384,9 +386,6 @@ struct wl1271 {
 	/* Quirks of specific hardware revisions */
 	unsigned int quirks;
 
-	/* Platform limitations */
-	unsigned int platform_quirks;
-
 	/* number of currently active RX BA sessions */
 	int ba_rx_session_count;
 
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index b516b4f..1bfcd19 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -59,13 +59,9 @@ struct wl12xx_platform_data {
 	int irq;
 	int board_ref_clock;
 	int board_tcxo_clock;
-	unsigned long platform_quirks;
 	bool pwr_in_suspend;
 };
 
-/* Platform does not support level trigger interrupts */
-#define WL12XX_PLATFORM_QUIRK_EDGE_IRQ	BIT(0)
-
 #ifdef CONFIG_WILINK_PLATFORM_DATA
 
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
-- 
1.7.10.4

