Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaJVOfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:35:50 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:49578 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236AbaJVOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:31:29 -0400
X-ASG-Debug-ID: 1413988287-0759e74a717a4e60002-xx1T2L
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
Subject: [PATCH 02/13] power: reset: ltc2952: prefer devm_request_irq over request_irq
Date: Wed, 22 Oct 2014 16:30:59 +0200
X-ASG-Orig-Subj: [PATCH 02/13] power: reset: ltc2952: prefer devm_request_irq over request_irq
Message-ID: <1413988270-28092-3-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
References: <1413988270-28092-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.125]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1413988287
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

Make use of the fact that we allocated resources can be automatically
deallocated. This reduces cleanup code and chance of errors. It also
removes the need for the virq member of the ltc2952_poweroff_data
struct.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 951a90d..2c11316 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -72,8 +72,6 @@ struct ltc2952_poweroff_data {
 
 	struct device *dev;
 
-	unsigned int virq;
-
 	/**
 	 * 0: trigger
 	 * 1: watchdog
@@ -260,13 +258,11 @@ static int ltc2952_poweroff_init(struct platform_device *pdev)
 		goto err_io;
 	}
 
-	ltc2952_data->virq = virq;
-	ret = request_irq(virq,
-		ltc2952_poweroff_handler,
-		(IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING),
-		"ltc2952-poweroff",
-		ltc2952_data
-	);
+	ret = devm_request_irq(&pdev->dev, virq,
+			       ltc2952_poweroff_handler,
+			       (IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING),
+			       "ltc2952-poweroff",
+			       ltc2952_data);
 
 	if (ret) {
 		dev_err(&pdev->dev, "cannot configure an interrupt handler\n");
@@ -316,12 +312,9 @@ static int ltc2952_poweroff_remove(struct platform_device *pdev)
 
 	pm_power_off = NULL;
 
-	if (ltc2952_data) {
-		free_irq(ltc2952_data->virq, ltc2952_data);
-
+	if (ltc2952_data)
 		for (i = 0; i < ARRAY_SIZE(ltc2952_data->gpio); i++)
 			gpiod_put(ltc2952_data->gpio[i]);
-	}
 
 	return 0;
 }
-- 
2.1.0

