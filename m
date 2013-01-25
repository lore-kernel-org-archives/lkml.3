Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945905Ab3AYKGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:06:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:53013 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab3AYKGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:06:37 -0500
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>
Subject: [PATCH v2 5/5] wlcore: move wl12xx_platform_data up and make it truly optional
Date: Fri, 25 Jan 2013 12:05:34 +0200
Message-ID: <1359108334-18459-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358952038-5982-6-git-send-email-coelho@ti.com>
References: <1358952038-5982-6-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The platform data is used not only by wlcore-based drivers, but also
by wl1251.  Move it up in the directory hierarchy to reflect this.

Additionally, make it truly optional.  At the moment, disabling
platform data while wl1251_sdio or wlcore_sdio are enabled doesn't
work, but it will be necessary when device tree support is
implemented.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---

In v2:
   * Fix ti/Makefile
   * Modify board_omap3evm.c which was still using the old Kconfig define

Tony, is it okay if I add this change in the omap3evm board in this
patch and queue it via wireless so that the whole thing is in sync?


 arch/arm/mach-omap2/board-omap3evm.c                     |   10 +++++-----
 drivers/net/wireless/ti/Kconfig                          |    9 +++++++++
 drivers/net/wireless/ti/Makefile                         |    4 +++-
 .../wl12xx_platform_data.c => wilink_platform_data.c}    |    0
 drivers/net/wireless/ti/wlcore/Kconfig                   |    5 -----
 drivers/net/wireless/ti/wlcore/Makefile                  |    3 ---
 include/linux/wl12xx.h                                   |   14 +++++++++++---
 7 files changed, 28 insertions(+), 17 deletions(-)
 rename drivers/net/wireless/ti/{wlcore/wl12xx_platform_data.c => wilink_platform_data.c} (100%)

diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 3985f35..a4ca63b 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -309,7 +309,7 @@ static struct omap2_hsmmc_info mmc[] = {
 		.gpio_wp	= 63,
 		.deferred	= true,
 	},
-#ifdef CONFIG_WL12XX_PLATFORM_DATA
+#ifdef CONFIG_WILINK_PLATFORM_DATA
 	{
 		.name		= "wl1271",
 		.mmc		= 2,
@@ -450,7 +450,7 @@ static struct regulator_init_data omap3evm_vio = {
 	.consumer_supplies	= omap3evm_vio_supply,
 };
 
-#ifdef CONFIG_WL12XX_PLATFORM_DATA
+#ifdef CONFIG_WILINK_PLATFORM_DATA
 
 #define OMAP3EVM_WLAN_PMENA_GPIO	(150)
 #define OMAP3EVM_WLAN_IRQ_GPIO		(149)
@@ -563,7 +563,7 @@ static struct omap_board_mux omap35x_board_mux[] __initdata = {
 				OMAP_PIN_OFF_NONE),
 	OMAP3_MUX(GPMC_WAIT2, OMAP_MUX_MODE4 | OMAP_PIN_INPUT_PULLUP |
 				OMAP_PIN_OFF_NONE),
-#ifdef CONFIG_WL12XX_PLATFORM_DATA
+#ifdef CONFIG_WILINK_PLATFORM_DATA
 	/* WLAN IRQ - GPIO 149 */
 	OMAP3_MUX(UART1_RTS, OMAP_MUX_MODE4 | OMAP_PIN_INPUT),
 
@@ -601,7 +601,7 @@ static struct omap_board_mux omap36x_board_mux[] __initdata = {
 	OMAP3_MUX(SYS_BOOT4, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
 	OMAP3_MUX(SYS_BOOT5, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
 	OMAP3_MUX(SYS_BOOT6, OMAP_MUX_MODE3 | OMAP_PIN_OFF_NONE),
-#ifdef CONFIG_WL12XX_PLATFORM_DATA
+#ifdef CONFIG_WILINK_PLATFORM_DATA
 	/* WLAN IRQ - GPIO 149 */
 	OMAP3_MUX(UART1_RTS, OMAP_MUX_MODE4 | OMAP_PIN_INPUT),
 
@@ -637,7 +637,7 @@ static struct gpio omap3_evm_ehci_gpios[] __initdata = {
 
 static void __init omap3_evm_wl12xx_init(void)
 {
-#ifdef CONFIG_WL12XX_PLATFORM_DATA
+#ifdef CONFIG_WILINK_PLATFORM_DATA
 	int ret;
 
 	/* WL12xx WLAN Init */
diff --git a/drivers/net/wireless/ti/Kconfig b/drivers/net/wireless/ti/Kconfig
index be80011..cbe1e7f 100644
--- a/drivers/net/wireless/ti/Kconfig
+++ b/drivers/net/wireless/ti/Kconfig
@@ -12,4 +12,13 @@ source "drivers/net/wireless/ti/wl18xx/Kconfig"
 
 # keep last for automatic dependencies
 source "drivers/net/wireless/ti/wlcore/Kconfig"
+
+config WILINK_PLATFORM_DATA
+	bool "TI WiLink platform data"
+	depends on WLCORE_SDIO || WL1251_SDIO
+	default y
+	---help---
+	Small platform data bit needed to pass data to the sdio modules.
+
+
 endif # WL_TI
diff --git a/drivers/net/wireless/ti/Makefile b/drivers/net/wireless/ti/Makefile
index 4d68239..af14231 100644
--- a/drivers/net/wireless/ti/Makefile
+++ b/drivers/net/wireless/ti/Makefile
@@ -1,5 +1,7 @@
 obj-$(CONFIG_WLCORE)			+= wlcore/
 obj-$(CONFIG_WL12XX)			+= wl12xx/
-obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wlcore/
 obj-$(CONFIG_WL1251)			+= wl1251/
 obj-$(CONFIG_WL18XX)			+= wl18xx/
+
+# small builtin driver bit
+obj-$(CONFIG_WILINK_PLATFORM_DATA)	+= wilink_platform_data.o
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx_platform_data.c b/drivers/net/wireless/ti/wilink_platform_data.c
similarity index 100%
rename from drivers/net/wireless/ti/wlcore/wl12xx_platform_data.c
rename to drivers/net/wireless/ti/wilink_platform_data.c
diff --git a/drivers/net/wireless/ti/wlcore/Kconfig b/drivers/net/wireless/ti/wlcore/Kconfig
index d7b907e..2b83282 100644
--- a/drivers/net/wireless/ti/wlcore/Kconfig
+++ b/drivers/net/wireless/ti/wlcore/Kconfig
@@ -33,8 +33,3 @@ config WLCORE_SDIO
 
 	  If you choose to build a module, it'll be called wlcore_sdio.
 	  Say N if unsure.
-
-config WL12XX_PLATFORM_DATA
-	bool
-	depends on WLCORE_SDIO != n || WL1251_SDIO != n
-	default y
diff --git a/drivers/net/wireless/ti/wlcore/Makefile b/drivers/net/wireless/ti/wlcore/Makefile
index d9fba9e..b21398f 100644
--- a/drivers/net/wireless/ti/wlcore/Makefile
+++ b/drivers/net/wireless/ti/wlcore/Makefile
@@ -9,7 +9,4 @@ obj-$(CONFIG_WLCORE)			+= wlcore.o
 obj-$(CONFIG_WLCORE_SPI)		+= wlcore_spi.o
 obj-$(CONFIG_WLCORE_SDIO)		+= wlcore_sdio.o
 
-# small builtin driver bit
-obj-$(CONFIG_WL12XX_PLATFORM_DATA)	+= wl12xx_platform_data.o
-
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index 360c9bc..a54fe82 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -24,6 +24,8 @@
 #ifndef _LINUX_WL12XX_H
 #define _LINUX_WL12XX_H
 
+#include <linux/err.h>
+
 /* Reference clock values */
 enum {
 	WL12XX_REFCLOCK_19	= 0, /* 19.2 MHz */
@@ -60,10 +62,12 @@ struct wl12xx_platform_data {
 /* Platform does not support level trigger interrupts */
 #define WL12XX_PLATFORM_QUIRK_EDGE_IRQ	BIT(0)
 
-#ifdef CONFIG_WL12XX_PLATFORM_DATA
+#ifdef CONFIG_WILINK_PLATFORM_DATA
 
 int wl12xx_set_platform_data(const struct wl12xx_platform_data *data);
 
+struct wl12xx_platform_data *wl12xx_get_platform_data(void);
+
 #else
 
 static inline
@@ -72,8 +76,12 @@ int wl12xx_set_platform_data(const struct wl12xx_platform_data *data)
 	return -ENOSYS;
 }
 
-#endif
+static inline
+struct wl12xx_platform_data *wl12xx_get_platform_data(void)
+{
+	return ERR_PTR(-ENODATA);
+}
 
-struct wl12xx_platform_data *wl12xx_get_platform_data(void);
+#endif
 
 #endif
-- 
1.7.10.4

