Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971Ab3HaLEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:04:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39613 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab3HaLEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:04:16 -0400
From: Mark Brown <broonie@kernel.org>
To: Liam Girdwood <lgirdwood@gmail.com>
Cc: patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Mark Brown <broonie@linaro.org>
Date: Sat, 31 Aug 2013 12:03:19 +0100
Message-Id: <1377947000-5746-3-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377947000-5746-1-git-send-email-broonie@kernel.org>
References: <1377947000-5746-1-git-send-email-broonie@kernel.org>
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH 3/4] regulator: wm831x-isink: Use devm_request_threaded_irq()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Brown <broonie@linaro.org>

devm guarantees that resources are freed in the opposite order to that in
which they are allocated.

Signed-off-by: Mark Brown <broonie@linaro.org>
---
 drivers/regulator/wm831x-isink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/wm831x-isink.c b/drivers/regulator/wm831x-isink.c
index 4eb373d..841cb52 100644
--- a/drivers/regulator/wm831x-isink.c
+++ b/drivers/regulator/wm831x-isink.c
@@ -203,8 +203,10 @@ static int wm831x_isink_probe(struct platform_device *pdev)
 	}
 
 	irq = wm831x_irq(wm831x, platform_get_irq(pdev, 0));
-	ret = request_threaded_irq(irq, NULL, wm831x_isink_irq,
-				   IRQF_TRIGGER_RISING, isink->name, isink);
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+					wm831x_isink_irq,
+					IRQF_TRIGGER_RISING, isink->name,
+					isink);
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request ISINK IRQ %d: %d\n",
 			irq, ret);
@@ -225,8 +227,6 @@ static int wm831x_isink_remove(struct platform_device *pdev)
 {
 	struct wm831x_isink *isink = platform_get_drvdata(pdev);
 
-	free_irq(wm831x_irq(isink->wm831x, platform_get_irq(pdev, 0)), isink);
-
 	regulator_unregister(isink->regulator);
 
 	return 0;
-- 
1.8.4.rc3

