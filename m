Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3AXDkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:40:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44276 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484Ab3AXD3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:29:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mike Dunn <mikedunn@newsguy.com>, Igor Grinberg <grinberg@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 35/74] ALSA: pxa27x: fix ac97 warm reset
Date: Thu, 24 Jan 2013 01:26:47 -0200
Message-Id: <1358998046-613-36-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Dunn <mikedunn@newsguy.com>

commit 3b4bc7bccc7857274705b05cf81a0c72cfd0b0dd upstream.

This patch fixes some code that implements a work-around to a hardware bug in
the ac97 controller on the pxa27x.  A bug in the controller's warm reset
functionality requires that the mfp used by the controller as the AC97_nRESET
line be temporarily reconfigured as a generic output gpio (AF0) and manually
held high for the duration of the warm reset cycle.  This is what was done in
the original code, but it was broken long ago by commit fb1bf8cd
    ([ARM] pxa: introduce processor specific pxa27x_assert_ac97reset())
which changed the mfp to a GPIO input instead of a high output.

The fix requires the ac97 controller to obtain the gpio via gpio_request_one(),
with arguments that configure the gpio as an output initially driven high.

Tested on a palm treo 680 machine.  Reportedly, this broken code only prevents a
warm reset on hardware that lacks a pull-up on the line, which appears to be the
case for me.

Signed-off-by: Mike Dunn <mikedunn@newsguy.com>
Signed-off-by: Igor Grinberg <grinberg@compulab.co.il>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h |    3 +++
 arch/arm/mach-pxa/pxa27x.c                  |    4 ++--
 sound/arm/pxa2xx-ac97-lib.c                 |   18 +++++++++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h b/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
index a611ad3..b6132aa 100644
--- a/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
@@ -463,6 +463,9 @@
 	GPIO76_LCD_PCLK,	\
 	GPIO77_LCD_BIAS
 
+/* these enable a work-around for a hw bug in pxa27x during ac97 warm reset */
+#define GPIO113_AC97_nRESET_GPIO_HIGH MFP_CFG_OUT(GPIO113, AF0, DEFAULT)
+#define GPIO95_AC97_nRESET_GPIO_HIGH MFP_CFG_OUT(GPIO95, AF0, DEFAULT)
 
 extern int keypad_set_wake(unsigned int on);
 #endif /* __ASM_ARCH_MFP_PXA27X_H */
diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
index 4726c24..a2fe795 100644
--- a/arch/arm/mach-pxa/pxa27x.c
+++ b/arch/arm/mach-pxa/pxa27x.c
@@ -47,9 +47,9 @@ void pxa27x_clear_otgph(void)
 EXPORT_SYMBOL(pxa27x_clear_otgph);
 
 static unsigned long ac97_reset_config[] = {
-	GPIO113_GPIO,
+	GPIO113_AC97_nRESET_GPIO_HIGH,
 	GPIO113_AC97_nRESET,
-	GPIO95_GPIO,
+	GPIO95_AC97_nRESET_GPIO_HIGH,
 	GPIO95_AC97_nRESET,
 };
 
diff --git a/sound/arm/pxa2xx-ac97-lib.c b/sound/arm/pxa2xx-ac97-lib.c
index 8cfb2c0..bd3ba88 100644
--- a/sound/arm/pxa2xx-ac97-lib.c
+++ b/sound/arm/pxa2xx-ac97-lib.c
@@ -18,6 +18,7 @@
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/io.h>
+#include <linux/gpio.h>
 
 #include <sound/ac97_codec.h>
 #include <sound/pxa2xx-lib.h>
@@ -344,8 +345,21 @@ int __devinit pxa2xx_ac97_hw_probe(struct platform_device *dev)
 	}
 
 	if (cpu_is_pxa27x()) {
-		/* Use GPIO 113 as AC97 Reset on Bulverde */
+		/*
+		 * This gpio is needed for a work-around to a bug in the ac97
+		 * controller during warm reset.  The direction and level is set
+		 * here so that it is an output driven high when switching from
+		 * AC97_nRESET alt function to generic gpio.
+		 */
+		ret = gpio_request_one(reset_gpio, GPIOF_OUT_INIT_HIGH,
+				       "pxa27x ac97 reset");
+		if (ret < 0) {
+			pr_err("%s: gpio_request_one() failed: %d\n",
+			       __func__, ret);
+			goto err_conf;
+		}
 		pxa27x_assert_ac97reset(reset_gpio, 0);
+
 		ac97conf_clk = clk_get(&dev->dev, "AC97CONFCLK");
 		if (IS_ERR(ac97conf_clk)) {
 			ret = PTR_ERR(ac97conf_clk);
@@ -388,6 +402,8 @@ EXPORT_SYMBOL_GPL(pxa2xx_ac97_hw_probe);
 
 void pxa2xx_ac97_hw_remove(struct platform_device *dev)
 {
+	if (cpu_is_pxa27x())
+		gpio_free(reset_gpio);
 	GCR |= GCR_ACLINK_OFF;
 	free_irq(IRQ_AC97, NULL);
 	if (ac97conf_clk) {
-- 
1.7.9.5

