Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaBERy4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 12:54:56 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.110]:28193 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753176AbaBERyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 12:54:53 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-8.tower-193.messagelabs.com!1391622517!10613157!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <c332a2885a76869f922057211ebae4757c5079f4.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
In-Reply-To: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
From: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
Date: Wed, 5 Feb 2014 17:48:36 +0000
Subject: [PATCH 5/8] onkey: da9055: Remove use of platform_get_irq_byname()
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
CC: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.netg>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using platform_get_irq_byname() to retrieve the IRQ number
returns the VIRQ number rather than the local IRQ number for
the device. Passing that value then into regmap_irq_get_virq()
causes a failure because the function is expecting the local
IRQ number (e.g. 0, 1, 2, 3, etc). This patch removes use of
platform_get_irq_byname() and uses the local IRQ number instead.

Signed-off-by: Adam Thomson <Adam.Thomson.Opensource@diasemi.com>
---
 drivers/input/misc/da9055_onkey.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/input/misc/da9055_onkey.c b/drivers/input/misc/da9055_onkey.c
index 4b11ede..4842c6c 100644
--- a/drivers/input/misc/da9055_onkey.c
+++ b/drivers/input/misc/da9055_onkey.c
@@ -79,13 +79,6 @@ static int da9055_onkey_probe(struct platform_device *pdev)
 	struct input_dev *input_dev;
 	int irq, err;

-	irq = platform_get_irq_byname(pdev, "ONKEY");
-	if (irq < 0) {
-		dev_err(&pdev->dev,
-			"Failed to get an IRQ for input device, %d\n", irq);
-		return -EINVAL;
-	}
-
 	onkey = devm_kzalloc(&pdev->dev, sizeof(*onkey), GFP_KERNEL);
 	if (!onkey) {
 		dev_err(&pdev->dev, "Failed to allocate memory\n");
@@ -109,7 +102,7 @@ static int da9055_onkey_probe(struct platform_device *pdev)

 	INIT_DELAYED_WORK(&onkey->work, da9055_onkey_work);

-	irq = regmap_irq_get_virq(da9055->irq_data, irq);
+	irq = regmap_irq_get_virq(da9055->irq_data, DA9055_IRQ_NONKEY);
 	err = request_threaded_irq(irq, NULL, da9055_onkey_irq,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "ONKEY", onkey);
--
1.7.0.4

