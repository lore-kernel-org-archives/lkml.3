Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab3BLAsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:48:20 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:53658 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab3BLAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:48:18 -0500
From: Doug Anderson <dianders@chromium.org>
To: linux-i2c@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Padmavathi Venna <padma.v@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Doug Anderson <dianders@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] i2c: pxa: Use i2c-core to get bus number now
Date: Mon, 11 Feb 2013 16:48:05 -0800
Message-Id: <1360630085-26874-3-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360630085-26874-1-git-send-email-dianders@chromium.org>
References: <1360630085-26874-1-git-send-email-dianders@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit: "i2c-core: dt: Pick i2c bus number from i2c alias if
present" adds support for automatically picking the bus number based
on the alias ID.  Remove the now unnecessary code from i2c-pxa that
did the same thing.

Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Changes in v3: None
Changes in v2:
- No longer tweak pdev->id as per Sylwester Nawrocki.
- No longer add the dev ID to the adap.name.  Other drivers don't
  include the device ID here and it doesn't make sense with
  dynamically (or automatically) allocated IDs.
- Use dev_name(&dev->dev) to register for the IRQ; this matches what
  the i2c-s3c2410.c does and handles dynamically allocated IDs.
- This change was only compile-tested (corgi_defconfig), since I don't
  have access to a board that uses this driver.

 drivers/i2c/busses/i2c-pxa.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 1034d93..705cc9f 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1053,16 +1053,13 @@ static int i2c_pxa_probe_dt(struct platform_device *pdev, struct pxa_i2c *i2c,
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *of_id =
 			of_match_device(i2c_pxa_dt_ids, &pdev->dev);
-	int ret;
 
 	if (!of_id)
 		return 1;
-	ret = of_alias_get_id(np, "i2c");
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
-		return ret;
-	}
-	pdev->id = ret;
+
+	/* For device tree we always use the dynamic or alias-assigned ID */
+	i2c->adap.nr = -1;
+
 	if (of_get_property(np, "mrvl,i2c-polling", NULL))
 		i2c->use_pio = 1;
 	if (of_get_property(np, "mrvl,i2c-fast-mode", NULL))
@@ -1100,6 +1097,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
 		goto emalloc;
 	}
 
+	/* Default adapter num to device id; i2c_pxa_probe_dt can override. */
+	i2c->adap.nr = dev->id;
+
 	ret = i2c_pxa_probe_dt(dev, i2c, &i2c_type);
 	if (ret > 0)
 		ret = i2c_pxa_probe_pdata(dev, i2c, &i2c_type);
@@ -1124,9 +1124,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	spin_lock_init(&i2c->lock);
 	init_waitqueue_head(&i2c->wait);
 
-	i2c->adap.nr = dev->id;
-	snprintf(i2c->adap.name, sizeof(i2c->adap.name), "pxa_i2c-i2c.%u",
-		 i2c->adap.nr);
+	strlcpy(i2c->adap.name, "pxa_i2c-i2c", sizeof(i2c->adap.name));
 
 	i2c->clk = clk_get(&dev->dev, NULL);
 	if (IS_ERR(i2c->clk)) {
@@ -1169,7 +1167,7 @@ static int i2c_pxa_probe(struct platform_device *dev)
 	} else {
 		i2c->adap.algo = &i2c_pxa_algorithm;
 		ret = request_irq(irq, i2c_pxa_handler, IRQF_SHARED,
-				  i2c->adap.name, i2c);
+				  dev_name(&dev->dev), i2c);
 		if (ret)
 			goto ereqirq;
 	}
-- 
1.8.1

