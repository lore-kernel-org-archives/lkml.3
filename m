Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab3EHNbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 09:31:04 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:56065 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3EHNaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 09:30:19 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 8/9] pinctrl: abx500: Rejiggle platform data and DT initialisation
Date: Wed,  8 May 2013 14:29:08 +0100
Message-Id: <1368019749-19455-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
References: <1368019749-19455-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to GPIO platform data is always passed to the driver now, so
there's little point in checking for 'pdata' and executing the DT case if
it's not there. The difference between booting with DT and !DT is when
booting with DT, plat_id is not populated. Thus, in the DT case we have
to use a DT match table in order to find out which platform we're
executing on. So, we're changing the semantics here to only use the
match table if no plat_id is supplied though platform data.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/pinctrl/pinctrl-abx500.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-abx500.c b/drivers/pinctrl/pinctrl-abx500.c
index 2a2a9df..6d45327 100644
--- a/drivers/pinctrl/pinctrl-abx500.c
+++ b/drivers/pinctrl/pinctrl-abx500.c
@@ -851,23 +851,12 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 
 	if (abx500_pdata)
 		pdata = abx500_pdata->gpio;
-	if (!pdata) {
-		if (np) {
-			const struct of_device_id *match;
 
-			match = of_match_device(abx500_gpio_match, &pdev->dev);
-			if (!match)
-				return -ENODEV;
-			id = (unsigned long)match->data;
-		} else {
-			dev_err(&pdev->dev, "gpio dt and platform data missing\n");
-			return -ENODEV;
-		}
+	if (!(pdata || np)) {
+		dev_err(&pdev->dev, "gpio dt and platform data missing\n");
+		return -ENODEV;
 	}
 
-	if (platid)
-		id = platid->driver_data;
-
 	pct = devm_kzalloc(&pdev->dev, sizeof(struct abx500_pinctrl),
 				   GFP_KERNEL);
 	if (pct == NULL) {
@@ -882,6 +871,16 @@ static int abx500_gpio_probe(struct platform_device *pdev)
 	pct->chip.dev = &pdev->dev;
 	pct->chip.base = (np) ? -1 : pdata->gpio_base;
 
+	if (platid)
+		id = platid->driver_data;
+	else if (np) {
+		const struct of_device_id *match;
+
+		match = of_match_device(abx500_gpio_match, &pdev->dev);
+		if (match)
+			id = (unsigned long)match->data;
+	}
+
 	/* initialize the lock */
 	mutex_init(&pct->lock);
 
-- 
1.7.10.4

