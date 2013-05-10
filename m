Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab3EJIcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:32:00 -0400
Received: from sauhun.de ([89.238.76.85]:60384 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887Ab3EJIQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:38 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [RFC 10/42] drivers/input/keyboard: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:55 +0200
Message-Id: <1368173847-5661-11-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/input/keyboard/imx_keypad.c     |    7 +------
 drivers/input/keyboard/spear-keyboard.c |    7 +------
 drivers/input/keyboard/tegra-kbc.c      |    7 +------
 3 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/input/keyboard/imx_keypad.c b/drivers/input/keyboard/imx_keypad.c
index 03c8cc5..328cfc1 100644
--- a/drivers/input/keyboard/imx_keypad.c
+++ b/drivers/input/keyboard/imx_keypad.c
@@ -442,12 +442,6 @@ static int imx_keypad_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "no I/O memory defined in platform data\n");
-		return -EINVAL;
-	}
-
 	input_dev = devm_input_allocate_device(&pdev->dev);
 	if (!input_dev) {
 		dev_err(&pdev->dev, "failed to allocate the input device\n");
@@ -468,6 +462,7 @@ static int imx_keypad_probe(struct platform_device *pdev)
 	setup_timer(&keypad->check_matrix_timer,
 		    imx_keypad_check_for_events, (unsigned long) keypad);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	keypad->mmio_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(keypad->mmio_base))
 		return PTR_ERR(keypad->mmio_base);
diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index cb1e8f6..b2e77e4 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -191,12 +191,6 @@ static int spear_kbd_probe(struct platform_device *pdev)
 	int irq;
 	int error;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no keyboard resource defined\n");
-		return -EBUSY;
-	}
-
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0) {
 		dev_err(&pdev->dev, "not able to get irq for the device\n");
@@ -228,6 +222,7 @@ static int spear_kbd_probe(struct platform_device *pdev)
 		kbd->suspended_rate = pdata->suspended_rate;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	kbd->io_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(kbd->io_base))
 		return PTR_ERR(kbd->io_base);
diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
index b46142f..9cd20e6 100644
--- a/drivers/input/keyboard/tegra-kbc.c
+++ b/drivers/input/keyboard/tegra-kbc.c
@@ -638,12 +638,6 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 	if (!tegra_kbc_check_pin_cfg(kbc, &num_rows))
 		return -EINVAL;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get I/O memory\n");
-		return -ENXIO;
-	}
-
 	kbc->irq = platform_get_irq(pdev, 0);
 	if (kbc->irq < 0) {
 		dev_err(&pdev->dev, "failed to get keyboard IRQ\n");
@@ -658,6 +652,7 @@ static int tegra_kbc_probe(struct platform_device *pdev)
 
 	setup_timer(&kbc->timer, tegra_kbc_keypress_timer, (unsigned long)kbc);
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	kbc->mmio = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(kbc->mmio))
 		return PTR_ERR(kbc->mmio);
-- 
1.7.10.4

