Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaJVObi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:31:38 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49641 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaJVObf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:35 -0400
X-ASG-Debug-ID: 1413988290-0759e74a717a4ec0003-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: Sebastian Reichel <sre@kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?q?Ren=C3=A9=20Moll?= <linux@r-moll.nl>,
        Guenter Roeck <linux@roeck-us.net>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH 04/13] power: reset: ltc2952: prefer devm_gpiod_get over gpiod_get
Date: Wed, 22 Oct 2014 16:31:01 +0200
X-ASG-Orig-Subj: [PATCH 04/13] power: reset: ltc2952: prefer devm_gpiod_get over gpiod_get
Message-ID: <1413988270-28092-5-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988291
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.10827
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces cleanup code and chance of errors.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 44 ++++++++--------------------------
 1 file changed, 10 insertions(+), 34 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index fc583e0..1e96b5b 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -207,44 +207,34 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
 	data = ltc2952_data;
 	ltc2952_poweroff_default(ltc2952_data);
 
-	ltc2952_data->gpio_watchdog = gpiod_get(&pdev->dev, "watchdog");
+	ltc2952_data->gpio_watchdog = devm_gpiod_get(&pdev->dev, "watchdog",
+						     GPIOD_OUT_LOW);
 	if (IS_ERR(ltc2952_data->gpio_watchdog)) {
 		ret = PTR_ERR(ltc2952_data->gpio_watchdog);
 		dev_err(&pdev->dev, "unable to claim gpio \"watchdog\"\n");
 		return ret;
 	}
 
-	ltc2952_data->gpio_kill = gpiod_get(&pdev->dev, "kill");
+	ltc2952_data->gpio_kill = devm_gpiod_get(&pdev->dev, "kill",
+						 GPIOD_OUT_LOW);
 	if (IS_ERR(ltc2952_data->gpio_kill)) {
 		ret = PTR_ERR(ltc2952_data->gpio_kill);
 		dev_err(&pdev->dev, "unable to claim gpio \"kill\"\n");
-		goto err_kill;
+		return ret;
 	}
 
-	ltc2952_data->gpio_trigger = gpiod_get(&pdev->dev, "trigger");
+	ltc2952_data->gpio_trigger = devm_gpiod_get(&pdev->dev, "trigger",
+						    GPIOD_IN);
 	if (IS_ERR(ltc2952_data->gpio_trigger)) {
 		ret = PTR_ERR(ltc2952_data->gpio_trigger);
 		dev_err(&pdev->dev, "unable to claim gpio \"trigger\"\n");
-		goto err_trigger;
-	}
-
-	ret = gpiod_direction_output(
-		ltc2952_data->gpio_watchdog, 0);
-	if (ret) {
-		dev_err(&pdev->dev, "unable to use watchdog-gpio as output\n");
-		goto err_io;
-	}
-
-	ret = gpiod_direction_output(ltc2952_data->gpio_kill, 0);
-	if (ret) {
-		dev_err(&pdev->dev, "unable to use kill-gpio as output\n");
-		goto err_io;
+		return ret;
 	}
 
 	virq = gpiod_to_irq(ltc2952_data->gpio_trigger);
 	if (virq < 0) {
 		dev_err(&pdev->dev, "cannot map GPIO as interrupt");
-		goto err_io;
+		return ret;
 	}
 
 	ret = devm_request_irq(&pdev->dev, virq,
@@ -255,19 +245,10 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
 
 	if (ret) {
 		dev_err(&pdev->dev, "cannot configure an interrupt handler\n");
-		goto err_io;
+		return ret;
 	}
 
 	return 0;
-
-err_io:
-	gpiod_put(ltc2952_data->gpio_trigger);
-err_trigger:
-	gpiod_put(ltc2952_data->gpio_kill);
-err_kill:
-	gpiod_put(ltc2952_data->gpio_watchdog);
-
-	return ret;
 }
 
 static int ltc2952_poweroff_probe(struct platform_device *pdev)
@@ -301,11 +282,6 @@ static int ltc2952_poweroff_remove(struct platform_device *pdev)
 {
 	pm_power_off = NULL;
 
-	if (ltc2952_data) {
-		gpiod_put(ltc2952_data->gpio_trigger);
-		gpiod_put(ltc2952_data->gpio_watchdog);
-		gpiod_put(ltc2952_data->gpio_kill);
-	}
 	return 0;
 }
 
-- 
2.1.0

