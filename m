Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab3AUKMv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:12:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65212 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab3AUKKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:10:18 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 16/33] mfd: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:09 +0100
Message-Id: <1358762966-20791-17-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:AcE5m7ACgvJJ/iT+M1rswZ0JIj8ThpiCWgmpfUU1XSl
 q7A7X57vCQDhmpwpNymP20xTaok02bNnTy9Gj+trcO070xHFlo
 UMBG2EyuSSOwmLPO1cKClmFRH+jRx0J+0Sg5SNoBQq/eGpMtEk
 vfwOKW9AT1KWHqqW/k0zPLreqx7NLEwZSkctttgxHHgA9Ex7TU
 G4JtiChC/pun7mzUTQP2cBG35udrV82LlZPxOS/+rVG5wnbWDW
 H6KjRE/5lWcXDXiCZyll92jJadVsjb6kvClV+Hvt/RTCxzWU2F
 CHefmQJhYAP+PT/LjnaikZujUzziqNjbqKgK4j4QE4FlTJji76
 fv2cTE9f5PstShO6L9A6Ypiij6WYkPEBW5wtRrYGuLlx7nkZwP
 PvkEaAZrB2WMeC68X5GTKhNW3N/hXG/9jPI6DypmR1aXKcXy+X
 A1RFm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/mfd/intel_msic.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
index ab8d0b2..1804331 100644
--- a/drivers/mfd/intel_msic.c
+++ b/drivers/mfd/intel_msic.c
@@ -9,6 +9,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/err.h>
 #include <linux/gpio.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -424,11 +425,9 @@ static int intel_msic_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	msic->irq_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!msic->irq_base) {
-		dev_err(&pdev->dev, "failed to map SRAM memory\n");
-		return -ENOMEM;
-	}
+	msic->irq_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(msic->irq_base))
+		return PTR_ERR(msic->irq_base);
 
 	platform_set_drvdata(pdev, msic);
 
-- 
1.8.1.1

