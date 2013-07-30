Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3G3NHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:07:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46334 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850Ab3G3NFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:05:45 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <coelho@ti.com>, <luca@coelho.fi>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <balbi@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nm@ti.com>, <martinez.javier@gmail.com>
Subject: [PATCH v4 4/8] wl12xx: use frequency instead of enumerations for pdata clocks
Date: Tue, 30 Jul 2013 16:04:32 +0300
Message-ID: <1375189476-21557-5-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375189476-21557-1-git-send-email-coelho@ti.com>
References: <1375189476-21557-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of defining an enumeration with the FW specific values for the
different clock rates, use the actual frequency instead.  Also add a
boolean to specify whether the clock is XTAL or not.

Change all board files to reflect this.

Additionally, this reverts commit 26f45c (ARM: OMAP2+: Legacy support
for wl12xx when booted with devicetree), since this is not be needed
anymore, now that DT support for WiLink is implemented.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c      |  3 +-
 arch/arm/mach-omap2/board-omap3evm.c         |  3 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c |  3 +-
 arch/arm/mach-omap2/devices.c                | 39 -------------------
 drivers/net/wireless/ti/wl12xx/main.c        | 58 +++++++++++++++++++++++++++-
 drivers/net/wireless/ti/wl12xx/wl12xx.h      | 28 ++++++++++++++
 include/linux/wl12xx.h                       | 27 ++-----------
 7 files changed, 93 insertions(+), 68 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index 03de2e9..6b2768f 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1376,7 +1376,8 @@ static const short da850_wl12xx_pins[] __initconst = {
 
 static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata = {
 	.irq			= -1,
-	.board_ref_clock	= WL12XX_REFCLOCK_38,
+	.ref_clock_freq		= 38400000,
+	.ref_clock_xtal		= false,
 };
 
 static __init int da850_wl12xx_init(void)
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 9c7dfc5..4ccfcc0 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -460,7 +460,8 @@ static struct platform_device omap3evm_wlan_regulator = {
 };
 
 struct wl12xx_platform_data omap3evm_wlan_data __initdata = {
-	.board_ref_clock = WL12XX_REFCLOCK_38, /* 38.4 MHz */
+	.ref_clock_freq = 38400000,
+	.ref_clock_xtal = false,
 };
 #endif
 
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index 4f84cf9..83a9a36 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -244,7 +244,8 @@ static struct platform_device *zoom_devices[] __initdata = {
 };
 
 static struct wl12xx_platform_data omap_zoom_wlan_data __initdata = {
-	.board_ref_clock = WL12XX_REFCLOCK_26, /* 26 MHz */
+	.ref_clock_freq = 26000000,
+	.ref_clock_xtal = false,
 };
 
 static struct omap2_hsmmc_info mmc[] = {
diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 3c1279f..10e6126 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -8,7 +8,6 @@
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  */
-#include <linux/gpio.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
@@ -19,7 +18,6 @@
 #include <linux/of.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/platform_data/omap4-keypad.h>
-#include <linux/wl12xx.h>
 #include <linux/platform_data/mailbox-omap.h>
 
 #include <asm/mach-types.h>
@@ -513,40 +511,6 @@ static void omap_init_vout(void)
 static inline void omap_init_vout(void) {}
 #endif
 
-#if IS_ENABLED(CONFIG_WL12XX)
-
-static struct wl12xx_platform_data wl12xx __initdata;
-
-void __init omap_init_wl12xx_of(void)
-{
-	int ret;
-
-	if (!of_have_populated_dt())
-		return;
-
-	if (of_machine_is_compatible("ti,omap4-sdp")) {
-		wl12xx.board_ref_clock = WL12XX_REFCLOCK_26;
-		wl12xx.board_tcxo_clock = WL12XX_TCXOCLOCK_26;
-		wl12xx.irq = gpio_to_irq(53);
-	} else if (of_machine_is_compatible("ti,omap4-panda")) {
-		wl12xx.board_ref_clock = WL12XX_REFCLOCK_38;
-		wl12xx.irq = gpio_to_irq(53);
-	} else {
-		return;
-	}
-
-	ret = wl12xx_set_platform_data(&wl12xx);
-	if (ret) {
-		pr_err("error setting wl12xx data: %d\n", ret);
-		return;
-	}
-}
-#else
-static inline void omap_init_wl12xx_of(void)
-{
-}
-#endif
-
 /*-------------------------------------------------------------------------*/
 
 static int __init omap2_init_devices(void)
@@ -570,9 +534,6 @@ static int __init omap2_init_devices(void)
 		omap_init_mcspi();
 		omap_init_sham();
 		omap_init_aes();
-	} else {
-		/* These can be removed when bindings are done */
-		omap_init_wl12xx_of();
 	}
 	omap_init_sti();
 	omap_init_rng();
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 1c627da..a6c2a14 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1701,6 +1701,43 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
 		},
 };
 
+static const struct wl12xx_clock wl12xx_refclock_table[] = {
+	{ 19200000,	false,	WL12XX_REFCLOCK_19	},
+	{ 26000000,	false,	WL12XX_REFCLOCK_26	},
+	{ 26000000,	true,	WL12XX_REFCLOCK_26_XTAL	},
+	{ 38400000,	false,	WL12XX_REFCLOCK_38	},
+	{ 38400000,	true,	WL12XX_REFCLOCK_38_XTAL	},
+	{ 52000000,	false,	WL12XX_REFCLOCK_52	},
+	{ 0,		false,	0 }
+};
+
+static const struct wl12xx_clock wl12xx_tcxoclock_table[] = {
+	{ 16368000,	true,	WL12XX_TCXOCLOCK_16_368	},
+	{ 16800000,	true,	WL12XX_TCXOCLOCK_16_8	},
+	{ 19200000,	true,	WL12XX_TCXOCLOCK_19_2	},
+	{ 26000000,	true,	WL12XX_TCXOCLOCK_26	},
+	{ 32736000,	true,	WL12XX_TCXOCLOCK_32_736	},
+	{ 33600000,	true,	WL12XX_TCXOCLOCK_33_6	},
+	{ 38400000,	true,	WL12XX_TCXOCLOCK_38_4	},
+	{ 52000000,	true,	WL12XX_TCXOCLOCK_52	},
+	{ 0,		false,	0 }
+};
+
+static int wl12xx_get_clock_idx(const struct wl12xx_clock *table,
+				u32 freq, bool xtal)
+{
+	int i = 0;
+
+	while(table[i].freq != 0) {
+		if ((table[i].freq == freq) &&
+		    (table[i].xtal == xtal))
+			return table[i].hw_idx;
+		i++;
+	};
+
+	return -EINVAL;
+}
+
 static int wl12xx_setup(struct wl1271 *wl)
 {
 	struct wl12xx_priv *priv = wl->priv;
@@ -1722,7 +1759,16 @@ static int wl12xx_setup(struct wl1271 *wl)
 	wl12xx_conf_init(wl);
 
 	if (!fref_param) {
-		priv->ref_clock = pdata->board_ref_clock;
+		priv->ref_clock = wl12xx_get_clock_idx(wl12xx_refclock_table,
+						       pdata->ref_clock_freq,
+						       pdata->ref_clock_xtal);
+		if (priv->ref_clock < 0) {
+			wl1271_error("Invalid ref_clock frequency (%d Hz, %s)",
+				pdata->ref_clock_freq,
+				pdata->ref_clock_xtal ? "XTAL" : "not XTAL");
+
+			return priv->ref_clock;
+		}
 	} else {
 		if (!strcmp(fref_param, "19.2"))
 			priv->ref_clock = WL12XX_REFCLOCK_19;
@@ -1741,7 +1787,15 @@ static int wl12xx_setup(struct wl1271 *wl)
 	}
 
 	if (!tcxo_param) {
-		priv->tcxo_clock = pdata->board_tcxo_clock;
+		priv->tcxo_clock = wl12xx_get_clock_idx(wl12xx_tcxoclock_table,
+							pdata->tcxo_clock_freq,
+							true);
+		if (priv->tcxo_clock < 0) {
+			wl1271_error("Invalid tcxo_clock frequency (%d Hz)",
+				pdata->tcxo_clock_freq);
+
+			return priv->tcxo_clock;
+		}
 	} else {
 		if (!strcmp(tcxo_param, "19.2"))
 			priv->tcxo_clock = WL12XX_TCXOCLOCK_19_2;
diff --git a/drivers/net/wireless/ti/wl12xx/wl12xx.h b/drivers/net/wireless/ti/wl12xx/wl12xx.h
index 9e5484a..05f631b 100644
--- a/drivers/net/wireless/ti/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/ti/wl12xx/wl12xx.h
@@ -79,4 +79,32 @@ struct wl12xx_priv {
 	struct wl127x_rx_mem_pool_addr *rx_mem_addr;
 };
 
+/* Reference clock values */
+enum {
+	WL12XX_REFCLOCK_19	= 0, /* 19.2 MHz */
+	WL12XX_REFCLOCK_26	= 1, /* 26 MHz */
+	WL12XX_REFCLOCK_38	= 2, /* 38.4 MHz */
+	WL12XX_REFCLOCK_52	= 3, /* 52 MHz */
+	WL12XX_REFCLOCK_38_XTAL = 4, /* 38.4 MHz, XTAL */
+	WL12XX_REFCLOCK_26_XTAL = 5, /* 26 MHz, XTAL */
+};
+
+/* TCXO clock values */
+enum {
+	WL12XX_TCXOCLOCK_19_2	= 0, /* 19.2MHz */
+	WL12XX_TCXOCLOCK_26	= 1, /* 26 MHz */
+	WL12XX_TCXOCLOCK_38_4	= 2, /* 38.4MHz */
+	WL12XX_TCXOCLOCK_52	= 3, /* 52 MHz */
+	WL12XX_TCXOCLOCK_16_368	= 4, /* 16.368 MHz */
+	WL12XX_TCXOCLOCK_32_736	= 5, /* 32.736 MHz */
+	WL12XX_TCXOCLOCK_16_8	= 6, /* 16.8 MHz */
+	WL12XX_TCXOCLOCK_33_6	= 7, /* 33.6 MHz */
+};
+
+struct wl12xx_clock {
+	u32	freq;
+	bool	xtal;
+	u8	hw_idx;
+};
+
 #endif /* __WL12XX_PRIV_H__ */
diff --git a/include/linux/wl12xx.h b/include/linux/wl12xx.h
index ab90b1c..11491ad 100644
--- a/include/linux/wl12xx.h
+++ b/include/linux/wl12xx.h
@@ -26,28 +26,6 @@
 
 #include <linux/err.h>
 
-/* Reference clock values */
-enum {
-	WL12XX_REFCLOCK_19	= 0, /* 19.2 MHz */
-	WL12XX_REFCLOCK_26	= 1, /* 26 MHz */
-	WL12XX_REFCLOCK_38	= 2, /* 38.4 MHz */
-	WL12XX_REFCLOCK_52	= 3, /* 52 MHz */
-	WL12XX_REFCLOCK_38_XTAL = 4, /* 38.4 MHz, XTAL */
-	WL12XX_REFCLOCK_26_XTAL = 5, /* 26 MHz, XTAL */
-};
-
-/* TCXO clock values */
-enum {
-	WL12XX_TCXOCLOCK_19_2	= 0, /* 19.2MHz */
-	WL12XX_TCXOCLOCK_26	= 1, /* 26 MHz */
-	WL12XX_TCXOCLOCK_38_4	= 2, /* 38.4MHz */
-	WL12XX_TCXOCLOCK_52	= 3, /* 52 MHz */
-	WL12XX_TCXOCLOCK_16_368	= 4, /* 16.368 MHz */
-	WL12XX_TCXOCLOCK_32_736	= 5, /* 32.736 MHz */
-	WL12XX_TCXOCLOCK_16_8	= 6, /* 16.8 MHz */
-	WL12XX_TCXOCLOCK_33_6	= 7, /* 33.6 MHz */
-};
-
 struct wl1251_platform_data {
 	void (*set_power)(bool enable);
 	/* SDIO only: IRQ number if WLAN_IRQ line is used, 0 for SDIO IRQs */
@@ -57,8 +35,9 @@ struct wl1251_platform_data {
 
 struct wl12xx_platform_data {
 	int irq;
-	int board_ref_clock;
-	int board_tcxo_clock;
+	int ref_clock_freq;	/* in Hertz */
+	bool ref_clock_xtal;	/* specify whether the clock is XTAL or not */
+	int tcxo_clock_freq;	/* in Hertz, tcxo is always XTAL */
 };
 
 #ifdef CONFIG_WILINK_PLATFORM_DATA
-- 
1.8.3.2

