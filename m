Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab3JELTx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 07:19:53 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:37297 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab3JELTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 07:19:50 -0400
From: Andreas Fenkart <afenkart@gmail.com>
To: Chris Ball <cjb@laptop.org>
Cc: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Felipe Balbi <balbi@ti.com>, Venkatraman S <svenkatr@ti.com>,
        Balaji T K <balajitk@ti.com>, zonque@gmail.com,
        devicetree-discuss@lists.ozlabs.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
        linux-omap@vger.kernel.org, Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v3 3/4] mmc: omap_hsmmc: Remux pins to support SDIO interrupt on AM335x
Date: Sat,  5 Oct 2013 13:17:09 +0200
Message-Id: <1380971830-21492-4-git-send-email-afenkart@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
References: <1380971830-21492-1-git-send-email-afenkart@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The am335x can't detect pending cirq in PM runtime suspend.
This patch reconfigures dat1 as a GPIO before going to suspend.
SDIO interrupts are detected with the GPIO, while in runtime
suspend, standard detection of the module block otherwise.

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>

diff --git a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
index 1136e6b..146f3ad 100644
--- a/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
+++ b/Documentation/devicetree/bindings/mmc/ti-omap-hsmmc.txt
@@ -21,8 +21,11 @@ ti,non-removable: non-removable slot (like eMMC)
 ti,needs-special-reset: Requires a special softreset sequence
 ti,needs-special-hs-handling: HSMMC IP needs special setting for handling High Speed
 ti,quirk-swakup-missing: SOC missing the swakeup line, will not detect
-SDIO irq while in suspend. Fallback to polling. Affected chips are
-am335x,
+SDIO irq while in suspend. The workaround is to reconfigure the dat1 line as a
+GPIO upon suspend. Beyond this option and the GPIO config, you also need to set
+named pinctrl states "default", "active" and "idle ", see example below.  The
+MMC driver will then then toggle between default and idle during the runtime
+Affected chips are am335x,
 
                             ------
                             | PRCM |
@@ -49,3 +52,24 @@ Example:
 		vmmc-supply = <&vmmc>; /* phandle to regulator node */
 		ti,non-removable;
 	};
+
+[am335x with with gpio for sdio irq]
+
+	mmc1_cirq_pin: pinmux_cirq_pin {
+		pinctrl-single,pins = <
+			0x0f8 0x3f	/* MMC0_DAT1 as GPIO2_28 */
+		>;
+	};
+
+	mmc1: mmc@48060000 {
+		ti,non-removable;
+		bus-width = <4>;
+		vmmc-supply = <&ldo2_reg>;
+		vmmc_aux-supply = <&vmmc>;
+	        ti,quirk-swakeup-missing;
+		pinctrl-names = "default", "active", "idle";
+		pinctrl-0 = <&mmc1_pins>;
+		pinctrl-1 = <&mmc1_pins>;
+		pinctrl-2 = <&mmc1_cirq_pin>;
+		ti,cirq-gpio = <&gpio3 28 0>;
+	};
diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 53beac4..a8894ee 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -36,6 +36,7 @@
 #include <linux/mmc/core.h>
 #include <linux/mmc/mmc.h>
 #include <linux/io.h>
+#include <linux/irq.h>
 #include <linux/gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/pinctrl/consumer.h>
@@ -214,11 +215,22 @@ struct omap_hsmmc_host {
 	int                     flags;
 #define HSMMC_RUNTIME_SUSPENDED	(1 << 0)        /* Runtime suspended */
 #define HSMMC_SDIO_IRQ_ENABLED	(1 << 1)        /* SDIO irq enabled */
+#define HSMMC_SWAKEUP_QUIRK	(1 << 2)        /* SDIO irq enabled */
 
 	struct omap_hsmmc_next	next_data;
+	struct pinctrl		*pinctrl;
+	struct pinctrl_state	*fixed, *active, *idle;
 	struct	omap_mmc_platform_data	*pdata;
 };
 
+static irqreturn_t omap_hsmmc_cirq(int irq, void *dev_id)
+{
+	struct omap_hsmmc_host *host = dev_id;
+
+	mmc_signal_sdio_irq(host->mmc);
+	return IRQ_HANDLED;
+}
+
 static int omap_hsmmc_card_detect(struct device *dev, int slot)
 {
 	struct omap_hsmmc_host *host = dev_get_drvdata(dev);
@@ -453,10 +465,31 @@ static int omap_hsmmc_gpio_init(struct omap_mmc_platform_data *pdata)
 	} else
 		pdata->slots[0].gpio_wp = -EINVAL;
 
+	if (pdata->slots[0].gpio_cirq > 0 &&
+	    gpio_is_valid(pdata->slots[0].gpio_cirq)) {
+		pdata->slots[0].sdio_irq =
+				gpio_to_irq(pdata->slots[0].gpio_cirq);
+
+		ret = gpio_request(pdata->slots[0].gpio_cirq, "sdio_cirq");
+		if (ret)
+			goto err_free_ro;
+		ret = gpio_direction_input(pdata->slots[0].gpio_cirq);
+		if (ret)
+			goto err_free_cirq;
+
+	} else {
+		pdata->slots[0].gpio_cirq = -EINVAL;
+	}
+
+
 	return 0;
 
+err_free_cirq:
+	gpio_free(pdata->slots[0].gpio_cirq);
+err_free_ro:
+	if (gpio_is_valid(pdata->slots[0].gpio_wp))
 err_free_wp:
-	gpio_free(pdata->slots[0].gpio_wp);
+		gpio_free(pdata->slots[0].gpio_wp);
 err_free_cd:
 	if (gpio_is_valid(pdata->slots[0].switch_pin))
 err_free_sp:
@@ -470,6 +503,68 @@ static void omap_hsmmc_gpio_free(struct omap_mmc_platform_data *pdata)
 		gpio_free(pdata->slots[0].gpio_wp);
 	if (gpio_is_valid(pdata->slots[0].switch_pin))
 		gpio_free(pdata->slots[0].switch_pin);
+	if (gpio_is_valid(pdata->slots[0].gpio_cirq))
+		gpio_free(pdata->slots[0].gpio_cirq);
+}
+
+static int omap_hsmmc_pin_init(struct omap_hsmmc_host *host)
+{
+	int ret;
+
+	host->pinctrl = devm_pinctrl_get(host->dev);
+	if (IS_ERR(host->pinctrl)) {
+		dev_dbg(host->dev, "no pinctrl handle\n");
+		ret = 0;
+		goto out;
+	}
+
+	host->fixed = pinctrl_lookup_state(host->pinctrl,
+					   PINCTRL_STATE_DEFAULT);
+	if (IS_ERR(host->fixed)) {
+		dev_dbg(host->dev, "pins are not configured from the driver\n");
+		host->fixed = NULL;
+		ret = 0;
+		goto out;
+	}
+
+	ret = pinctrl_select_state(host->pinctrl, host->fixed);
+	if (ret < 0)
+		goto err;
+
+	/* For most cases we don't have wake-ups, and exit after this */
+	host->active = pinctrl_lookup_state(host->pinctrl, "active");
+	if (IS_ERR(host->active)) {
+		ret = PTR_ERR(host->active);
+		host->active = NULL;
+		return 0;
+	}
+
+	host->idle = pinctrl_lookup_state(host->pinctrl,
+					  PINCTRL_STATE_IDLE);
+	if (IS_ERR(host->idle)) {
+		ret = PTR_ERR(host->idle);
+		host->idle = NULL;
+		goto err;
+	}
+
+	/* Let's make sure the active and idle states work */
+	ret = pinctrl_select_state(host->pinctrl, host->idle);
+	if (ret < 0)
+		goto err;
+
+	ret = pinctrl_select_state(host->pinctrl, host->active);
+	if (ret < 0)
+		goto err;
+
+	dev_info(mmc_dev(host->mmc), "pins configured for wake-up events\n");
+
+	return 0;
+
+err:
+	dev_err(mmc_dev(host->mmc), "pins configuration error: %i\n", ret);
+
+out:
+	return ret;
 }
 
 /*
@@ -1613,13 +1708,18 @@ static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
 
 	spin_lock_irqsave(&host->irq_lock, flags);
 
+	if (!enable == !(host->flags & HSMMC_SDIO_IRQ_ENABLED)) {
+		/* sdio_irq is refcounted, keep in sync */
+		goto out;
+	}
+
 	if (enable)
 		host->flags |= HSMMC_SDIO_IRQ_ENABLED;
 	else
 		host->flags &= ~HSMMC_SDIO_IRQ_ENABLED;
 
-	/* if statement here with followup patch */
-	{
+	if (!(host->flags & HSMMC_RUNTIME_SUSPENDED)) {
+		/* SIGBUS without without fclk */
 		irq_mask = OMAP_HSMMC_READ(host->base, ISE);
 		if (enable)
 			irq_mask |= CIRQ_EN;
@@ -1638,6 +1738,16 @@ static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int enable)
 		OMAP_HSMMC_READ(host->base, IE);
 	}
 
+	if (host->flags & HSMMC_SWAKEUP_QUIRK) {
+		if (enable) {
+			enable_irq(mmc_slot(host).sdio_irq);
+		} else {
+			/* _nosync, see mmc_signal_sdio_irq */
+			disable_irq_nosync(mmc_slot(host).sdio_irq);
+		}
+	}
+
+out:
 	spin_unlock_irqrestore(&host->irq_lock, flags);
 }
 
@@ -1797,6 +1907,7 @@ static struct omap_mmc_platform_data *of_get_hsmmc_pdata(struct device *dev)
 	pdata->nr_slots = 1;
 	pdata->slots[0].switch_pin = cd_gpio;
 	pdata->slots[0].gpio_wp = wp_gpio;
+	pdata->slots[0].gpio_cirq = of_get_named_gpio(np, "ti,cirq-gpio", 0);
 
 	if (of_find_property(np, "ti,non-removable", NULL)) {
 		pdata->slots[0].nonremovable = true;
@@ -1837,7 +1948,6 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 	const struct of_device_id *match;
 	dma_cap_mask_t mask;
 	unsigned tx_req, rx_req;
-	struct pinctrl *pinctrl;
 
 	match = of_match_device(of_match_ptr(omap_mmc_of_match), &pdev->dev);
 	if (match) {
@@ -2075,12 +2185,35 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 		pdata->resume = omap_hsmmc_resume_cdirq;
 	}
 
-	omap_hsmmc_disable_irq(host);
+	if ((mmc_slot(host).sdio_irq)) {
+		/* prevent auto-enabling of IRQ */
+		irq_set_status_flags(mmc_slot(host).sdio_irq, IRQ_NOAUTOEN);
+		ret = request_irq(mmc_slot(host).sdio_irq, omap_hsmmc_cirq,
+				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				  mmc_hostname(mmc), host);
+		if (ret) {
+			dev_dbg(mmc_dev(host->mmc),
+				"Unable to grab MMC SDIO IRQ\n");
+			goto err_irq_sdio;
+		}
 
-	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
-	if (IS_ERR(pinctrl))
-		dev_warn(&pdev->dev,
-			"pins are not configured from the driver\n");
+		/*
+		 * sdio_irq is managed with ref count
+		 * - start with initial value of 2
+		 * - omap_hsmmc_enable_sdio_irq enable/disable will -1/+1
+		 * - pm_suspend/pm_resume will -1/+1
+		 *
+		 * if sdio irq are enabled AND runtime suspend on, only then
+		 * the ref count drops to zero and the gpio irq is armed
+		 */
+		disable_irq(mmc_slot(host).sdio_irq); /* -> ref cnt == 2 */
+	}
+
+	ret = omap_hsmmc_pin_init(host);
+	if (ret)
+		goto err_pinctrl_state;
+
+	omap_hsmmc_disable_irq(host);
 
 	/*
 	 * For now, only support SDIO interrupt if we are booted with
@@ -2093,8 +2226,14 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 		mmc->caps |= MMC_CAP_SDIO_IRQ;
 		if (of_find_property(host->dev->of_node,
 				     "ti,quirk-swakeup-missing", NULL)) {
-			/* no wakeup from deeper power states, use polling */
-			mmc->caps &= ~MMC_CAP_SDIO_IRQ;
+			/* no wakeup from deeper power states, use GPIO */
+			if (!host->idle || !mmc_slot(host).sdio_irq) {
+				dev_err(mmc_dev(host->mmc),
+					"Missing GPIO config or pinctrl idle state\n");
+				goto err_pinctrl_state;
+			}
+
+			host->flags |= HSMMC_SWAKEUP_QUIRK;
 		}
 	}
 
@@ -2122,7 +2261,13 @@ static int omap_hsmmc_probe(struct platform_device *pdev)
 
 err_slot_name:
 	mmc_remove_host(mmc);
-	free_irq(mmc_slot(host).card_detect_irq, host);
+err_pinctrl_state:
+	devm_pinctrl_put(host->pinctrl);
+	if ((mmc_slot(host).sdio_irq))
+		free_irq(mmc_slot(host).sdio_irq, host);
+err_irq_sdio:
+	if ((mmc_slot(host).card_detect_irq))
+		free_irq(mmc_slot(host).card_detect_irq, host);
 err_irq_cd:
 	if (host->use_reg)
 		omap_hsmmc_reg_put(host);
@@ -2167,13 +2312,15 @@ static int omap_hsmmc_remove(struct platform_device *pdev)
 	if (host->pdata->cleanup)
 		host->pdata->cleanup(&pdev->dev);
 	free_irq(host->irq, host);
+	if ((mmc_slot(host).sdio_irq))
+		free_irq(mmc_slot(host).sdio_irq, host);
 	if (mmc_slot(host).card_detect_irq)
 		free_irq(mmc_slot(host).card_detect_irq, host);
-
 	if (host->tx_chan)
 		dma_release_channel(host->tx_chan);
 	if (host->rx_chan)
 		dma_release_channel(host->rx_chan);
+	devm_pinctrl_put(host->pinctrl);
 
 	pm_runtime_put_sync(host->dev);
 	pm_runtime_disable(host->dev);
@@ -2293,23 +2440,66 @@ static int omap_hsmmc_resume(struct device *dev)
 static int omap_hsmmc_runtime_suspend(struct device *dev)
 {
 	struct omap_hsmmc_host *host;
+	unsigned long flags;
+	int ret = 0;
 
 	host = platform_get_drvdata(to_platform_device(dev));
 	omap_hsmmc_context_save(host);
 	dev_dbg(dev, "disabled\n");
 
-	return 0;
+	if (host->flags & HSMMC_SWAKEUP_QUIRK) {
+		spin_lock_irqsave(&host->irq_lock, flags);
+		OMAP_HSMMC_WRITE(host->base, ISE, 0);
+		OMAP_HSMMC_WRITE(host->base, IE, 0);
+		OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
+		spin_unlock_irqrestore(&host->irq_lock, flags);
+
+		ret = pinctrl_select_state(host->pinctrl, host->idle);
+		if (ret < 0)
+			dev_warn(mmc_dev(host->mmc), "Unable to select idle pinmux\n");
+
+		enable_irq(mmc_slot(host).sdio_irq);
+	}
+
+	spin_lock_irqsave(&host->irq_lock, flags);
+	/* infinite loop, if irq not cleared in omap_hsmmc_enable_sdio_irq */
+	host->flags |= HSMMC_RUNTIME_SUSPENDED;
+	spin_unlock_irqrestore(&host->irq_lock, flags);
+
+	return ret;
 }
 
 static int omap_hsmmc_runtime_resume(struct device *dev)
 {
 	struct omap_hsmmc_host *host;
+	unsigned long flags;
+	int ret = 0;
 
 	host = platform_get_drvdata(to_platform_device(dev));
 	omap_hsmmc_context_restore(host);
 	dev_dbg(dev, "enabled\n");
 
-	return 0;
+	spin_lock_irqsave(&host->irq_lock, flags);
+	/* infinite loop, if irq not cleared in omap_hsmmc_enable_sdio_irq */
+	host->flags &= ~HSMMC_RUNTIME_SUSPENDED;
+	spin_unlock_irqrestore(&host->irq_lock, flags);
+
+	if (host->flags & HSMMC_SWAKEUP_QUIRK) {
+		disable_irq(mmc_slot(host).sdio_irq);
+
+		ret = pinctrl_select_state(host->pinctrl, host->active);
+		if (ret < 0)
+			dev_warn(mmc_dev(host->mmc), "Unable to select active pinmux\n");
+
+		spin_lock_irqsave(&host->irq_lock, flags);
+		if (host->flags & HSMMC_SDIO_IRQ_ENABLED) {
+			OMAP_HSMMC_WRITE(host->base, STAT, STAT_CLEAR);
+			OMAP_HSMMC_WRITE(host->base, ISE, CIRQ_EN);
+			OMAP_HSMMC_WRITE(host->base, IE, CIRQ_EN);
+		}
+		spin_unlock_irqrestore(&host->irq_lock, flags);
+	}
+	return ret;
 }
 
 static struct dev_pm_ops omap_hsmmc_dev_pm_ops = {
diff --git a/include/linux/platform_data/mmc-omap.h b/include/linux/platform_data/mmc-omap.h
index 2bf1b30..fd5fff5 100644
--- a/include/linux/platform_data/mmc-omap.h
+++ b/include/linux/platform_data/mmc-omap.h
@@ -115,6 +115,7 @@ struct omap_mmc_platform_data {
 
 		int switch_pin;			/* gpio (card detect) */
 		int gpio_wp;			/* gpio (write protect) */
+		int gpio_cirq;			/* gpio (card irq) */
 
 		int (*set_bus_mode)(struct device *dev, int slot, int bus_mode);
 		int (*set_power)(struct device *dev, int slot,
@@ -145,6 +146,9 @@ struct omap_mmc_platform_data {
 		int card_detect_irq;
 		int (*card_detect)(struct device *dev, int slot);
 
+		/* SDIO IRQs */
+		int sdio_irq;
+
 		unsigned int ban_openended:1;
 
 	} slots[OMAP_MMC_MAX_SLOTS];
-- 
1.7.10.4

