Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbbANI2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:28:32 -0500
Received: from filter1.ibarracuda.nl ([83.247.7.10]:41767 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbbANI23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:28:29 -0500
X-Greylist: delayed 640 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2015 03:28:29 EST
X-ASG-Debug-ID: 1421223474-0759e7543ba83440002-xx1T2L
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
Subject: [PATCH RESEND 01/13] power: reset: ltc2952: prefer devm_kzalloc over kzalloc
Date: Wed, 14 Jan 2015 09:15:34 +0100
X-ASG-Orig-Subj: [PATCH RESEND 01/13] power: reset: ltc2952: prefer devm_kzalloc over kzalloc
Message-ID: <1421223346-27410-2-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421223346-27410-1-git-send-email-frans.klaver@xsens.com>
References: <1421223346-27410-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.149]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1421223474
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: https://filter1.ibarracuda.nl:443/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.14271
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the fact that the allocated resources can be automatically
deallocated. This reduces cleanup code and chance of leaks.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/reset/ltc2952-poweroff.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/power/reset/ltc2952-poweroff.c b/drivers/power/reset/ltc2952-poweroff.c
index 116a1ce..951a90d 100644
--- a/drivers/power/reset/ltc2952-poweroff.c
+++ b/drivers/power/reset/ltc2952-poweroff.c
@@ -292,7 +292,8 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 		return -EBUSY;
 	}
 
-	ltc2952_data = kzalloc(sizeof(*ltc2952_data), GFP_KERNEL);
+	ltc2952_data = devm_kzalloc(&pdev->dev, sizeof(*ltc2952_data),
+				    GFP_KERNEL);
 	if (!ltc2952_data)
 		return -ENOMEM;
 
@@ -300,17 +301,13 @@ static int ltc2952_poweroff_probe(struct platform_device *pdev)
 
 	ret = ltc2952_poweroff_init(pdev);
 	if (ret)
-		goto err;
+		return ret;
 
 	pm_power_off = &ltc2952_poweroff_kill;
 
 	dev_info(&pdev->dev, "probe successful\n");
 
 	return 0;
-
-err:
-	kfree(ltc2952_data);
-	return ret;
 }
 
 static int ltc2952_poweroff_remove(struct platform_device *pdev)
@@ -324,8 +321,6 @@ static int ltc2952_poweroff_remove(struct platform_device *pdev)
 
 		for (i = 0; i < ARRAY_SIZE(ltc2952_data->gpio); i++)
 			gpiod_put(ltc2952_data->gpio[i]);
-
-		kfree(ltc2952_data);
 	}
 
 	return 0;
-- 
2.1.0

