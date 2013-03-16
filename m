Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab3CPGSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 02:18:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55615 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab3CPGRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 02:17:08 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <santosh.shilimkar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 4/8] memory: emif: Handle devices which are not rated for >85C
Date: Sat, 16 Mar 2013 11:46:44 +0530
Message-ID: <1363414608-7448-5-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
References: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

As per JESD209-2E specification for LPDDR2,
      http://www.jedec.org/standards-documents/results/jesd209-2E
Table 73, LPDDR2 memories come in two flavors - Standard and
Extended. The Standard types can operate from -25C to +85C
However, beyond that and upto +105C can only be supported by
Extended types.

Unfortunately, it seems there is no info in MR0(device info) or
MR[1,2](device feature) for run time detection of this capability
as far as seen on the spec. Hence, we provide a custom_config
flag to be populated by platforms which have these "extended"
type memories.

For the "Standard" memories, we need to consider MR4 notifications
of temperature triggers >85C as equivalent to thermal shutdown
events (equivalent to Spec specified thermal shutdown events for
"extended" parts).

Reported-by: Richard Woodruff <r-woodruff2@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
Changes since V1: No changes

 drivers/memory/emif.c                   |   27 +++++++++++++++++++++++++++
 include/linux/platform_data/emif_plat.h |    1 +
 2 files changed, 28 insertions(+)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index e513889..827eb3b 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -918,6 +918,7 @@ static irqreturn_t handle_temp_alert(void __iomem *base, struct emif_data *emif)
 {
 	u32		old_temp_level;
 	irqreturn_t	ret = IRQ_HANDLED;
+	struct emif_custom_configs *custom_configs;
 
 	spin_lock_irqsave(&emif_lock, irq_state);
 	old_temp_level = emif->temperature_level;
@@ -930,6 +931,29 @@ static irqreturn_t handle_temp_alert(void __iomem *base, struct emif_data *emif)
 		goto out;
 	}
 
+	custom_configs = emif->plat_data->custom_configs;
+
+	/*
+	 * IF we detect higher than "nominal rating" from DDR sensor
+	 * on an unsupported DDR part, shutdown system
+	 */
+	if (custom_configs && !(custom_configs->mask &
+				EMIF_CUSTOM_CONFIG_EXTENDED_TEMP_PART)) {
+		if (emif->temperature_level >= SDRAM_TEMP_HIGH_DERATE_REFRESH) {
+			dev_err(emif->dev,
+				"%s:NOT Extended temperature capable memory."
+				"Converting MR4=0x%02x as shutdown event\n",
+				__func__, emif->temperature_level);
+			/*
+			 * Temperature far too high - do kernel_power_off()
+			 * from thread context
+			 */
+			emif->temperature_level = SDRAM_TEMP_VERY_HIGH_SHUTDOWN;
+			ret = IRQ_WAKE_THREAD;
+			goto out;
+		}
+	}
+
 	if (emif->temperature_level < old_temp_level ||
 		emif->temperature_level == SDRAM_TEMP_VERY_HIGH_SHUTDOWN) {
 		/*
@@ -1228,6 +1252,9 @@ static void __init_or_module of_get_custom_configs(struct device_node *np_emif,
 		cust_cfgs->temp_alert_poll_interval_ms = *poll_intvl;
 	}
 
+	if (of_find_property(np_emif, "extended-temp-part", &len))
+		cust_cfgs->mask |= EMIF_CUSTOM_CONFIG_EXTENDED_TEMP_PART;
+
 	if (!is_custom_config_valid(cust_cfgs, emif->dev)) {
 		devm_kfree(emif->dev, cust_cfgs);
 		return;
diff --git a/include/linux/platform_data/emif_plat.h b/include/linux/platform_data/emif_plat.h
index 03378ca..5c19a2a 100644
--- a/include/linux/platform_data/emif_plat.h
+++ b/include/linux/platform_data/emif_plat.h
@@ -40,6 +40,7 @@
 /* Custom config requests */
 #define EMIF_CUSTOM_CONFIG_LPMODE			0x00000001
 #define EMIF_CUSTOM_CONFIG_TEMP_ALERT_POLL_INTERVAL	0x00000002
+#define EMIF_CUSTOM_CONFIG_EXTENDED_TEMP_PART		0x00000004
 
 #ifndef __ASSEMBLY__
 /**
-- 
1.7.9.5

