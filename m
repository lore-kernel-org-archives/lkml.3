Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3GBO4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:56:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46234 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268Ab3GBO4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:56:38 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>
Subject: [PATCH v2 2/9] wlcore: use irq_flags in pdata instead of hiding it behind a quirk
Date: Tue, 2 Jul 2013 17:55:41 +0300
Message-ID: <1372776948-24840-3-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372776948-24840-1-git-send-email-coelho@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform_quirk element in the platform data was used to change the
way the IRQ is triggered.  When set, the EDGE_IRQ quirk would change
the irqflags used and treat edge trigger differently from the rest.

Instead of hiding this irq flag setting behind the quirk, export the
whole irq_flags element and let the board file define what to use.
This will be more meaningful than driver-specific quirks when we
switch to DT.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Acked-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-davinci/board-da850-evm.c      |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c          |    1 +
 arch/arm/mach-omap2/board-omap3evm.c         |    1 +
 arch/arm/mach-omap2/board-omap4panda.c       |    1 +
 arch/arm/mach-omap2/board-zoom-peripherals.c |    1 +
 drivers/net/wireless/ti/wlcore/debugfs.c     |    2 +-
 drivers/net/wireless/ti/wlcore/main.c        |   13 +++----------
 drivers/net/wireless/ti/wlcore/wlcore.h      |    5 ++---
 include/linux/wl12xx.h                       |    5 +----
 9 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 8a24b6c..d2a2a98 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1377,8 +1377,8 @@ static const short da850_wl12xx_pins[] __initconst = {
 
 static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata = {
 	.irq			= -1,
+	.irq_flags		= IRQF_TRIGGER_RISING,
 	.board_ref_clock	= WL12XX_REFCLOCK_38,
-	.platform_quirks	= WL12XX_PLATFORM_QUIRK_EDGE_IRQ,
 };
 
 static __init int da850_wl12xx_init(void)
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index 56a9a4f..c2334aa 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -693,6 +693,7 @@ static void __init omap4_sdp4430_wifi_mux_init(void)
 }
 
 static struct wl12xx_platform_data omap4_sdp4430_wlan_data __initdata = {
+	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 	.board_ref_clock = WL12XX_REFCLOCK_26,
 	.board_tcxo_clock = WL12XX_TCXOCLOCK_26,
 };
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index f76d0de..a0c0adf 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -458,6 +458,7 @@ static struct platform_device omap3evm_wlan_regulator = {
 };
 
 struct wl12xx_platform_data omap3evm_wlan_data __initdata = {
+	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 	.board_ref_clock = WL12XX_REFCLOCK_38, /* 38.4 MHz */
 };
 #endif
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index 1e2c75e..ba00862 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -230,6 +230,7 @@ static struct platform_device omap_vwlan_device = {
 };
 
 static struct wl12xx_platform_data omap_panda_wlan_data  __initdata = {
+	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 	.board_ref_clock = WL12XX_REFCLOCK_38, /* 38.4 MHz */
 };
 
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index a90375d..ced012c 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -244,6 +244,7 @@ static struct platform_device *zoom_devices[] __initdata = {
 };
 
 static struct wl12xx_platform_data omap_zoom_wlan_data __initdata = {
+	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 	.board_ref_clock = WL12XX_REFCLOCK_26, /* 26 MHz */
 };
 
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
index b8db55c..e7294b8 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -516,7 +516,7 @@ static int wlcore_irq_locked(struct wl1271 *wl)
 	 * In case edge triggered interrupt must be used, we cannot iterate
 	 * more than once without introducing race conditions with the hardirq.
 	 */
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
+	if (wl->irq_flags & IRQF_TRIGGER_RISING)
 		loopcount = 1;
 
 	wl1271_debug(DEBUG_IRQ, "IRQ work");
@@ -5765,7 +5765,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->ap_ps_map = 0;
 	wl->ap_fw_ps_map = 0;
 	wl->quirks = 0;
-	wl->platform_quirks = 0;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->active_sta_count = 0;
 	wl->active_link_count = 0;
@@ -5901,7 +5900,6 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	struct platform_device *pdev = wl->pdev;
 	struct wlcore_platdev_data *pdev_data = pdev->dev.platform_data;
 	struct wl12xx_platform_data *pdata = pdev_data->pdata;
-	unsigned long irqflags;
 	int ret;
 
 	if (fw) {
@@ -5928,16 +5926,11 @@ static void wlcore_nvs_cb(const struct firmware *fw, void *context)
 	wlcore_adjust_conf(wl);
 
 	wl->irq = platform_get_irq(pdev, 0);
-	wl->platform_quirks = pdata->platform_quirks;
 	wl->if_ops = pdev_data->if_ops;
-
-	if (wl->platform_quirks & WL12XX_PLATFORM_QUIRK_EDGE_IRQ)
-		irqflags = IRQF_TRIGGER_RISING;
-	else
-		irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
+	wl->irq_flags = pdata->irq_flags;
 
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
index b516b4f..04e3096 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -57,15 +57,12 @@ struct wl1251_platform_data {
 
 struct wl12xx_platform_data {
 	int irq;
+	unsigned long irq_flags;
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

