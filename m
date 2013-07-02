Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3GBO6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:58:55 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51891 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3GBO4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:56:40 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>
Subject: [PATCH v2 4/9] wl12xx: use frequency instead of enumerations for pdata clocks
Date: Tue, 2 Jul 2013 17:55:43 +0300
Message-ID: <1372776948-24840-5-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1372776948-24840-1-git-send-email-coelho@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of defining an enumeration with the FW specific values for the
different clock rates, use the actual frequency instead.  Also add a
boolean to specify whether the clock is XTAL or not.

Change all board files to reflect this.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 arch/arm/mach-davinci/board-da850-evm.c      |    3 +-
 arch/arm/mach-omap2/board-4430sdp.c          |    5 ++-
 arch/arm/mach-omap2/board-omap3evm.c         |    3 +-
 arch/arm/mach-omap2/board-omap4panda.c       |    3 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c |    3 +-
 drivers/net/wireless/ti/wl12xx/main.c        |   58 +++++++++++++++++++++++++-
 drivers/net/wireless/ti/wl12xx/wl12xx.h      |   28 +++++++++++++
 include/linux/wl12xx.h                       |   28 ++-----------
 8 files changed, 99 insertions(+), 32 deletions(-)

diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
index d2a2a98..202f3d0 100644
--- a/arch/arm/mach-davinci/board-da850-evm.c
+++ b/arch/arm/mach-davinci/board-da850-evm.c
@@ -1378,7 +1378,8 @@ static const short da850_wl12xx_pins[] __initconst = {
 static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata = {
 	.irq			= -1,
 	.irq_flags		= IRQF_TRIGGER_RISING,
-	.board_ref_clock	= WL12XX_REFCLOCK_38,
+	.ref_clock_freq		= 38400000,
+	.ref_clock_xtal		= false,
 };
 
 static __init int da850_wl12xx_init(void)
diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index c2334aa..da2b892 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -694,8 +694,9 @@ static void __init omap4_sdp4430_wifi_mux_init(void)
 
 static struct wl12xx_platform_data omap4_sdp4430_wlan_data __initdata = {
 	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-	.board_ref_clock = WL12XX_REFCLOCK_26,
-	.board_tcxo_clock = WL12XX_TCXOCLOCK_26,
+	.ref_clock_freq = 26000000,
+	.ref_clock_xtal = false,
+	.tcxo_clock_freq = 26000000,
 };
 
 static void __init omap4_sdp4430_wifi_init(void)
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index a0c0adf..d24435c 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -459,7 +459,8 @@ static struct platform_device omap3evm_wlan_regulator = {
 
 struct wl12xx_platform_data omap3evm_wlan_data __initdata = {
 	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-	.board_ref_clock = WL12XX_REFCLOCK_38, /* 38.4 MHz */
+	.ref_clock_freq = 38400000,
+	.ref_clock_xtal = false,
 };
 #endif
 
diff --git a/arch/arm/mach-omap2/board-omap4panda.c b/arch/arm/mach-omap2/board-omap4panda.c
index ba00862..ac6413c 100644
--- a/arch/arm/mach-omap2/board-omap4panda.c
+++ b/arch/arm/mach-omap2/board-omap4panda.c
@@ -231,7 +231,8 @@ static struct platform_device omap_vwlan_device = {
 
 static struct wl12xx_platform_data omap_panda_wlan_data  __initdata = {
 	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-	.board_ref_clock = WL12XX_REFCLOCK_38, /* 38.4 MHz */
+	.ref_clock_freq = 38400000,
+	.ref_clock_xtal = false,
 };
 
 static struct twl6040_codec_data twl6040_codec = {
diff --git a/arch/arm/mach-omap2/board-zoom-peripherals.c b/arch/arm/mach-omap2/board-zoom-peripherals.c
index ced012c..f4f4fe7 100644
--- a/arch/arm/mach-omap2/board-zoom-peripherals.c
+++ b/arch/arm/mach-omap2/board-zoom-peripherals.c
@@ -245,7 +245,8 @@ static struct platform_device *zoom_devices[] __initdata = {
 
 static struct wl12xx_platform_data omap_zoom_wlan_data __initdata = {
 	.irq_flags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-	.board_ref_clock = WL12XX_REFCLOCK_26, /* 26 MHz */
+	.ref_clock_freq = 26000000,
+	.ref_clock_xtal = false,
 };
 
 static struct omap2_hsmmc_info mmc[] = {
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 1c627da..903dcb3 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1701,6 +1701,42 @@ static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
 		},
 };
 
+static struct wl12xx_clock wl12xx_refclock_table[] = {
+	{ 19200000,	false,	WL12XX_REFCLOCK_19	},
+	{ 26000000,	false,	WL12XX_REFCLOCK_26	},
+	{ 26000000,	true,	WL12XX_REFCLOCK_26_XTAL	},
+	{ 38400000,	false,	WL12XX_REFCLOCK_38	},
+	{ 38400000,	true,	WL12XX_REFCLOCK_38_XTAL	},
+	{ 52000000,	false,	WL12XX_REFCLOCK_52	},
+	{ 0,		false,	0 }
+};
+
+static struct wl12xx_clock wl12xx_tcxoclock_table[] = {
+	{ 16368000,	false,	WL12XX_TCXOCLOCK_16_368	},
+	{ 16800000,	false,	WL12XX_TCXOCLOCK_16_8	},
+	{ 19200000,	false,	WL12XX_TCXOCLOCK_19_2	},
+	{ 26000000,	false,	WL12XX_TCXOCLOCK_26	},
+	{ 32736000,	false,	WL12XX_TCXOCLOCK_32_736	},
+	{ 33600000,	false,	WL12XX_TCXOCLOCK_33_6	},
+	{ 38400000,	false,	WL12XX_TCXOCLOCK_38_4	},
+	{ 52000000,	false,	WL12XX_TCXOCLOCK_52	},
+	{ 0,		false,	0 }
+};
+
+static int wl12xx_get_clock_idx(struct wl12xx_clock *table, u32 freq, bool xtal)
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
@@ -1722,7 +1758,16 @@ static int wl12xx_setup(struct wl1271 *wl)
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
@@ -1741,7 +1786,16 @@ static int wl12xx_setup(struct wl1271 *wl)
 	}
 
 	if (!tcxo_param) {
-		priv->tcxo_clock = pdata->board_tcxo_clock;
+		priv->tcxo_clock = wl12xx_get_clock_idx(wl12xx_tcxoclock_table,
+							pdata->tcxo_clock_freq,
+							pdata->tcxo_clock_xtal);
+		if (priv->tcxo_clock < 0) {
+			wl1271_error("Invalid tcxo_clock frequency (%d Hz, %s)",
+				pdata->tcxo_clock_freq,
+				pdata->tcxo_clock_xtal ? "XTAL" : "not XTAL");
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
index 1e4ed6e..4982b94 100644
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
@@ -58,8 +36,10 @@ struct wl1251_platform_data {
 struct wl12xx_platform_data {
 	int irq;
 	unsigned long irq_flags;
-	int board_ref_clock;
-	int board_tcxo_clock;
+	int ref_clock_freq;	/* in Hertz */
+	bool ref_clock_xtal;	/* specify whether the clock is XTAL or not */
+	int tcxo_clock_freq;	/* in Hertz */
+	bool tcxo_clock_xtal;	/* specify whether the clock is XTAL or not */
 };
 
 #ifdef CONFIG_WILINK_PLATFORM_DATA
-- 
1.7.10.4

