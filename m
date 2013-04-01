Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab3DARas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 13:30:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47080 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900Ab3DAR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 13:28:19 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 04/15] mfd: arizona: Allow GPIO to be specified for IRQ line
Date: Mon,  1 Apr 2013 18:28:01 +0100
Message-Id: <1364837292-30191-4-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20130401172748.GG18636@opensource.wolfsonmicro.com>
 <1364837292-30191-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a GPIO is specified for the chip IRQ line then request it. This
improves support for systems that do not put pins into input mode when
used as interrupts.

Also use this GPIO when the primary IRQ is in edge triggered mode to
detect if we have handled pending interrupts in order to improve
robustness.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/arizona-irq.c         |   66 +++++++++++++++++++++++++++++--------
 include/linux/mfd/arizona/pdata.h |    3 ++
 2 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
index aa25468..f761cc1 100644
--- a/drivers/mfd/arizona-irq.c
+++ b/drivers/mfd/arizona-irq.c
@@ -94,6 +94,7 @@ static irqreturn_t arizona_ctrlif_err(int irq, void *data)
 static irqreturn_t arizona_irq_thread(int irq, void *data)
 {
 	struct arizona *arizona = data;
+	bool poll;
 	unsigned int val;
 	int ret;
 
@@ -103,20 +104,39 @@ static irqreturn_t arizona_irq_thread(int irq, void *data)
 		return IRQ_NONE;
 	}
 
-	/* Always handle the AoD domain */
-	handle_nested_irq(irq_find_mapping(arizona->virq, 0));
+	do {
+		poll = false;
+
+		/* Always handle the AoD domain */
+		handle_nested_irq(irq_find_mapping(arizona->virq, 0));
+
+		/*
+		 * Check if one of the main interrupts is asserted and only
+		 * check that domain if it is.
+		 */
+		ret = regmap_read(arizona->regmap, ARIZONA_IRQ_PIN_STATUS,
+				  &val);
+		if (ret == 0 && val & ARIZONA_IRQ1_STS) {
+			handle_nested_irq(irq_find_mapping(arizona->virq, 1));
+		} else if (ret != 0) {
+			dev_err(arizona->dev,
+				"Failed to read main IRQ status: %d\n", ret);
+		}
 
-	/*
-	 * Check if one of the main interrupts is asserted and only
-	 * check that domain if it is.
-	 */
-	ret = regmap_read(arizona->regmap, ARIZONA_IRQ_PIN_STATUS, &val);
-	if (ret == 0 && val & ARIZONA_IRQ1_STS) {
-		handle_nested_irq(irq_find_mapping(arizona->virq, 1));
-	} else if (ret != 0) {
-		dev_err(arizona->dev, "Failed to read main IRQ status: %d\n",
-			ret);
-	}
+		/*
+		 * Poll the IRQ pin status to see if we're really done
+		 * if the interrupt controller can't do it for us.
+		 */
+		if (!arizona->pdata.irq_gpio) {
+			break;
+		} else if (arizona->pdata.irq_flags & IRQF_TRIGGER_RISING &&
+			   gpio_get_value_cansleep(arizona->pdata.irq_gpio)) {
+			poll = true;
+		} else if (arizona->pdata.irq_flags & IRQF_TRIGGER_FALLING &&
+			   !gpio_get_value_cansleep(arizona->pdata.irq_gpio)) {
+			poll = true;
+		}
+	} while (poll);
 
 	pm_runtime_mark_last_busy(arizona->dev);
 	pm_runtime_put_autosuspend(arizona->dev);
@@ -262,6 +282,26 @@ int arizona_irq_init(struct arizona *arizona)
 		}
 	}
 
+	/* Used to emulate edge trigger and to work around broken pinmux */
+	if (arizona->pdata.irq_gpio) {
+		if (gpio_to_irq(arizona->pdata.irq_gpio) != arizona->irq) {
+			dev_warn(arizona->dev, "IRQ %d is not GPIO %d (%d)\n",
+				 arizona->irq, arizona->pdata.irq_gpio,
+				 gpio_to_irq(arizona->pdata.irq_gpio));
+			arizona->irq = gpio_to_irq(arizona->pdata.irq_gpio);
+		}
+
+		ret = devm_gpio_request_one(arizona->dev,
+					    arizona->pdata.irq_gpio,
+					    GPIOF_IN, "arizona IRQ");
+		if (ret != 0) {
+			dev_err(arizona->dev,
+				"Failed to request IRQ GPIO %d:: %d\n",
+				arizona->pdata.irq_gpio, ret);
+			arizona->pdata.irq_gpio = 0;
+		}
+	}
+
 	ret = request_threaded_irq(arizona->irq, NULL, arizona_irq_thread,
 				   flags, "arizona", arizona);
 
diff --git a/include/linux/mfd/arizona/pdata.h b/include/linux/mfd/arizona/pdata.h
index 84fefed..8755dd0 100644
--- a/include/linux/mfd/arizona/pdata.h
+++ b/include/linux/mfd/arizona/pdata.h
@@ -163,6 +163,9 @@ struct arizona_pdata {
 
 	/** Haptic actuator type */
 	unsigned int hap_act;
+
+	/** GPIO for primary IRQ (used for edge triggered emulation) */
+	int irq_gpio;
 };
 
 #endif
-- 
1.7.10.4

