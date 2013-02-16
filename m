Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751613Ab3BPH1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 02:27:09 -0500
Received: from intranet.asianux.com ([58.214.24.6]:14560 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab3BPH1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 02:27:07 -0500
X-Spam-Score: -100.8
Message-ID: <511F34C3.6020406@asianux.com>
Date: Sat, 16 Feb 2013 15:26:59 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@ti.com>, grant.likely@secretlab.ca,
        linus.walleij@linaro.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Tony Lindgren <tony@atomide.com>
Subject: [PATCH] drivers/gpio/*twl* need call irq_free_descs when leaving
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  since already call irq_alloc_descs before,
    we need call irq_free_descs when quiting, or resource leak.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 drivers/gpio/gpio-twl4030.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-twl4030.c b/drivers/gpio/gpio-twl4030.c
index 4d330e3..26aef72 100644
--- a/drivers/gpio/gpio-twl4030.c
+++ b/drivers/gpio/gpio-twl4030.c
@@ -486,8 +486,10 @@ static int gpio_twl4030_probe(struct platform_device *pdev)
 			      &irq_domain_simple_ops, NULL);
 
 	ret = twl4030_sih_setup(&pdev->dev, TWL4030_MODULE_GPIO, irq_base);
-	if (ret < 0)
+	if (ret < 0) {
+		irq_free_descs(irq_base, TWL4030_GPIO_MAX);
 		return ret;
+	}
 
 	priv->irq_base = irq_base;
 
@@ -578,6 +580,7 @@ static int gpio_twl4030_remove(struct platform_device *pdev)
 
 	/* REVISIT no support yet for deregistering all the IRQs */
 	WARN_ON(1);
+	irq_free_descs(priv->irq_base, TWL4030_GPIO_MAX);
 	return -EIO;
 }
 
-- 
1.7.7.6

