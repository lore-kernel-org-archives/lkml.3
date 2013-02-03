Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3BCPU4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:20:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34178 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753777Ab3BCOzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:23 -0500
Message-Id: <20130203144646.430103100@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mike Dunn <mikedunn@newsguy.com>,
        Igor Grinberg <grinberg@compulab.co.il>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 027/128] ALSA: pxa27x: fix ac97 warm reset
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/mach-pxa/include/mach/mfp-pxa27x.h |    3 +++
 arch/arm/mach-pxa/pxa27x.c                  |    4 ++--
 sound/arm/pxa2xx-ac97-lib.c                 |   18 +++++++++++++++++-
 3 files changed, 22 insertions(+), 3 deletions(-)

--- a/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
+++ b/arch/arm/mach-pxa/include/mach/mfp-pxa27x.h
@@ -460,6 +460,9 @@
 	GPIO76_LCD_PCLK,	\
 	GPIO77_LCD_BIAS
 
+/* these enable a work-around for a hw bug in pxa27x during ac97 warm reset */
+#define GPIO113_AC97_nRESET_GPIO_HIGH MFP_CFG_OUT(GPIO113, AF0, DEFAULT)
+#define GPIO95_AC97_nRESET_GPIO_HIGH MFP_CFG_OUT(GPIO95, AF0, DEFAULT)
 
 extern int keypad_set_wake(unsigned int on);
 #endif /* __ASM_ARCH_MFP_PXA27X_H */
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
 
--- a/sound/arm/pxa2xx-ac97-lib.c
+++ b/sound/arm/pxa2xx-ac97-lib.c
@@ -17,6 +17,7 @@
 #include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/module.h>
+#include <linux/gpio.h>
 
 #include <sound/ac97_codec.h>
 #include <sound/pxa2xx-lib.h>
@@ -343,8 +344,21 @@ int __devinit pxa2xx_ac97_hw_probe(struc
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
@@ -387,6 +401,8 @@ EXPORT_SYMBOL_GPL(pxa2xx_ac97_hw_probe);
 
 void pxa2xx_ac97_hw_remove(struct platform_device *dev)
 {
+	if (cpu_is_pxa27x())
+		gpio_free(reset_gpio);
 	GCR |= GCR_ACLINK_OFF;
 	free_irq(IRQ_AC97, NULL);
 	if (ac97conf_clk) {


