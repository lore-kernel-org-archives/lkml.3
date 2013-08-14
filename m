Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932824Ab3HNLDk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 07:03:40 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:60107
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932787Ab3HNLDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 07:03:38 -0400
X-IronPort-AV: E=Sophos;i="4.89,876,1367964000"; 
   d="scan'208";a="23920207"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: kernel-janitors@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/29] drivers/input/{keyboard,serio}: simplify use of devm_ioremap_resource
Date: Wed, 14 Aug 2013 13:03:33 +0200
Message-Id: <1376478213-24091-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Remove unneeded error handling on the result of a call to
platform_get_resource when the value is passed to devm_ioremap_resource.

Move the call to platform_get_resource adjacent to the call to
devm_ioremap_resource to make the connection between them more clear.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression pdev,res,n,e,e1;
expression ret != 0;
identifier l;
@@

- res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  ... when != res
- if (res == NULL) { ... \(goto l;\|return ret;\) }
  ... when != res
+ res = platform_get_resource(pdev, IORESOURCE_MEM, n);
  e = devm_ioremap_resource(e1, res);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/input/keyboard/imx_keypad.c     |    7 +------
 drivers/input/keyboard/nspire-keypad.c  |    7 +------
 drivers/input/keyboard/spear-keyboard.c |    7 +------
 drivers/input/serio/arc_ps2.c           |    7 +------
 drivers/input/serio/olpc_apsp.c         |    3 ---
 5 files changed, 4 insertions(+), 27 deletions(-)

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
diff --git a/drivers/input/keyboard/nspire-keypad.c b/drivers/input/keyboard/nspire-keypad.c
index 20d872d..b3e3eda 100644
--- a/drivers/input/keyboard/nspire-keypad.c
+++ b/drivers/input/keyboard/nspire-keypad.c
@@ -171,12 +171,6 @@ static int nspire_keypad_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "missing platform resources\n");
-		return -EINVAL;
-	}
-
 	keypad = devm_kzalloc(&pdev->dev, sizeof(struct nspire_keypad),
 			      GFP_KERNEL);
 	if (!keypad) {
@@ -208,6 +202,7 @@ static int nspire_keypad_probe(struct platform_device *pdev)
 		return PTR_ERR(keypad->clk);
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	keypad->reg_base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(keypad->reg_base))
 		return PTR_ERR(keypad->reg_base);
diff --git a/drivers/input/keyboard/spear-keyboard.c b/drivers/input/keyboard/spear-keyboard.c
index 7111124..85ff530 100644
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
diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
index 3fb7727..8024a6d 100644
--- a/drivers/input/serio/arc_ps2.c
+++ b/drivers/input/serio/arc_ps2.c
@@ -189,12 +189,6 @@ static int arc_ps2_probe(struct platform_device *pdev)
 	int irq;
 	int error, id, i;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "no IO memory defined\n");
-		return -EINVAL;
-	}
-
 	irq = platform_get_irq_byname(pdev, "arc_ps2_irq");
 	if (irq < 0) {
 		dev_err(&pdev->dev, "no IRQ defined\n");
@@ -208,6 +202,7 @@ static int arc_ps2_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	arc_ps2->addr = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(arc_ps2->addr))
 		return PTR_ERR(arc_ps2->addr);
diff --git a/drivers/input/serio/olpc_apsp.c b/drivers/input/serio/olpc_apsp.c
index 818aa46..51b1d40 100644
--- a/drivers/input/serio/olpc_apsp.c
+++ b/drivers/input/serio/olpc_apsp.c
@@ -183,9 +183,6 @@ static int olpc_apsp_probe(struct platform_device *pdev)
 
 	np = pdev->dev.of_node;
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
-
 	priv->base = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(priv->base)) {
 		dev_err(&pdev->dev, "Failed to map WTM registers\n");

