Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219AbaJBHxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:53:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48366 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbaJBHxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:53:46 -0400
From: Jyri Sarha <jsarha@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        <kernel-janitors@vger.kernel.org>
CC: <dan.carpenter@oracle.com>, <detheridge@ti.com>,
        Jyri Sarha <jsarha@ti.com>
Subject: [PATCH 1/2] clk: gpio-gate: Stop using devres API
Date: Thu, 2 Oct 2014 10:53:31 +0300
Message-ID: <59d52e97a4954e0593a9aebc5b7d0d968a10f485.1412234778.git.jsarha@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1412234778.git.jsarha@ti.com>
References: <cover.1412234778.git.jsarha@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If some driver calls clk_register_gpio_gate() directly, then the
driver needs to kfree the resulting struct clk pointer in remove
function.

Signed-off-by: Jyri Sarha <jsarha@ti.com>
---
 drivers/clk/clk-gpio-gate.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/clk/clk-gpio-gate.c b/drivers/clk/clk-gpio-gate.c
index b87e5f0..a648761 100644
--- a/drivers/clk/clk-gpio-gate.c
+++ b/drivers/clk/clk-gpio-gate.c
@@ -82,23 +82,14 @@ struct clk *clk_register_gpio_gate(struct device *dev, const char *name,
 	else
 		gpio_flags = GPIOF_OUT_INIT_LOW;
 
-	if (dev)
-		err = devm_gpio_request_one(dev, desc_to_gpio(gpiod),
-					    gpio_flags, name);
-	else
-		err = gpio_request_one(desc_to_gpio(gpiod), gpio_flags, name);
-
+	err = gpio_request_one(desc_to_gpio(gpiod), gpio_flags, name);
 	if (err) {
 		pr_err("%s: %s: Error requesting clock control gpio %u\n",
 		       __func__, name, desc_to_gpio(gpiod));
 		return ERR_PTR(err);
 	}
 
-	if (dev)
-		clk_gpio = devm_kzalloc(dev, sizeof(struct clk_gpio),
-					GFP_KERNEL);
-	else
-		clk_gpio = kzalloc(sizeof(struct clk_gpio), GFP_KERNEL);
+	clk_gpio = kzalloc(sizeof(struct clk_gpio), GFP_KERNEL);
 
 	if (!clk_gpio) {
 		clk = ERR_PTR(-ENOMEM);
@@ -119,8 +110,7 @@ struct clk *clk_register_gpio_gate(struct device *dev, const char *name,
 	if (!IS_ERR(clk))
 		return clk;
 
-	if (!dev)
-		kfree(clk_gpio);
+	kfree(clk_gpio);
 
 clk_register_gpio_gate_err:
 	gpiod_put(gpiod);
-- 
1.7.9.5

