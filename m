Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3AUKSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:18:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:57794 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3AUKJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:45 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        linux-input@vger.kernel.org
Subject: [PATCH 12/33] Input: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:05 +0100
Message-Id: <1358762966-20791-13-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:ChyyDLn7Trm57CFTISpSsL1LTKq21m7ww3ok0sxO0aU
 OWK+n40KuwdRfVpdGZU18jI3/yWEdYjZmC3SPI2EQFJAtwECH0
 5fJs4t+u+mgjcp6FCf1bDgoy+JQcPYJaeHlTY2FEy3z86gyabX
 LxdRL27RFzTu0ZiKKbPbovzMA2HiatFU98+CPdp6KmojFRLg8d
 Qw1b/A/RW2GLBmo18D5lYiP/h+J4ZtVpQ0ISv8WNHObZwEQsSM
 4p0Qk1YckPz9Wzge6gumPvufqOV7822nwOOcuWWT91LC6GtT4a
 g8b7qjbudS+mfJh9y+D2HFQpjK2vSzcipgqq6ZG0NHwnQXwVKO
 kj+NkHl6xGX9ShTFrClnL+RObJXTtMXtvFLF2G9YWihscrUI+c
 3Aj7WI/dRbMwxJKuFscxaGGgrWnLuzNg9z1ljScAS8se4Efzjn
 te9ZI
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
---
 drivers/input/keyboard/spear-keyboard.c | 8 +++-----
 drivers/input/serio/arc_ps2.c           | 7 ++++---
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 695d237..cb1e8f6 100644
--- a/drivers/input/keyboard/spear-keyboard.c
+++ b/drivers/input/keyboard/spear-keyboard.c
@@ -228,11 +228,9 @@ static int spear_kbd_probe(struct platform_device *pdev)
 		kbd->suspended_rate = pdata->suspended_rate;
 	}
 
-	kbd->io_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!kbd->io_base) {
-		dev_err(&pdev->dev, "request-ioremap failed for kbd_region\n");
-		return -ENOMEM;
-	}
+	kbd->io_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(kbd->io_base))
+		return PTR_ERR(kbd->io_base);
 
 	kbd->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(kbd->clk))
diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
index b571eb3..c52e3e5 100644
--- a/drivers/input/serio/arc_ps2.c
+++ b/drivers/input/serio/arc_ps2.c
@@ -8,6 +8,7 @@
  * Driver is originally developed by Pavel Sokolov <psokolov@synopsys.com>
  */
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/input.h>
@@ -206,9 +207,9 @@ static int arc_ps2_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	arc_ps2->addr = devm_request_and_ioremap(&pdev->dev, res);
-	if (!arc_ps2->addr)
-		return -EBUSY;
+	arc_ps2->addr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(arc_ps2->addr))
+		return PTR_ERR(arc_ps2->addr);
 
 	dev_info(&pdev->dev, "irq = %d, address = 0x%p, ports = %i\n",
 		 irq, arc_ps2->addr, ARC_PS2_PORTS);
-- 
1.8.1.1

