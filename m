Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3EXXWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 19:22:20 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.102]:54746 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab3EXXWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 19:22:19 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-14.tower-209.messagelabs.com!1369437737!7352315!1
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/14] misc/ep93xx_pwm: use managed device resources
Date: Fri, 24 May 2013 16:21:01 -0700
User-Agent: KMail/1.9.9
CC: <arnd@arndb.de>, <gregkh@linuxfoundation.org>,
        Ryan Mallon <rmallon@gmail.com>, <mcrapet@gmail.com>,
        <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201305241621.01788.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use managed device resources to clean up the probe/remove.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ryan Mallon <rmallon@gmail.com>
Cc: Matthieu Crapet <mcrapet@gmail.com>
---
 drivers/misc/ep93xx_pwm.c | 73 +++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 53 deletions(-)

diff --git a/drivers/misc/ep93xx_pwm.c b/drivers/misc/ep93xx_pwm.c
index 9ba93f0..36370b4 100644
--- a/drivers/misc/ep93xx_pwm.c
+++ b/drivers/misc/ep93xx_pwm.c
@@ -273,50 +273,33 @@ static int __init ep93xx_pwm_probe(struct platform_device *pdev)
 {
 	struct ep93xx_pwm *pwm;
 	struct resource *res;
-	int err;
+	int ret;
 
-	err = ep93xx_pwm_acquire_gpio(pdev);
-	if (err)
-		return err;
+	pwm = devm_kzalloc(&pdev->dev, sizeof(*pwm), GFP_KERNEL);
+	if (!pwm)
+		return -ENOMEM;
 
-	pwm = kzalloc(sizeof(struct ep93xx_pwm), GFP_KERNEL);
-	if (!pwm) {
-		err = -ENOMEM;
-		goto fail_no_mem;
-	}
+	pwm->clk = devm_clk_get(&pdev->dev, "pwm_clk");
+	if (IS_ERR(pwm->clk))
+		return PTR_ERR(pwm->clk);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		err = -ENXIO;
-		goto fail_no_mem_resource;
-	}
-
-	res = request_mem_region(res->start, resource_size(res), pdev->name);
-	if (res == NULL) {
-		err = -EBUSY;
-		goto fail_no_mem_resource;
-	}
-
-	pwm->mmio_base = ioremap(res->start, resource_size(res));
-	if (pwm->mmio_base == NULL) {
-		err = -ENXIO;
-		goto fail_no_ioremap;
-	}
-
-	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
-	if (err)
-		goto fail_no_sysfs;
-
-	pwm->clk = clk_get(&pdev->dev, "pwm_clk");
-	if (IS_ERR(pwm->clk)) {
-		err = PTR_ERR(pwm->clk);
-		goto fail_no_clk;
+	pwm->mmio_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(pwm->mmio_base))
+		return PTR_ERR(pwm->mmio_base);
+
+	ret = ep93xx_pwm_acquire_gpio(pdev);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
+	if (ret) {
+		ep93xx_pwm_release_gpio(pdev);
+		return ret;
 	}
 
 	pwm->duty_percent = 50;
 
-	platform_set_drvdata(pdev, pwm);
-
 	/* disable pwm at startup. Avoids zero value. */
 	ep93xx_pwm_disable(pwm);
 	ep93xx_pwm_write_tc(pwm, EP93XX_PWM_MAX_COUNT);
@@ -324,33 +307,17 @@ static int __init ep93xx_pwm_probe(struct platform_device *pdev)
 
 	clk_enable(pwm->clk);
 
+	platform_set_drvdata(pdev, pwm);
 	return 0;
-
-fail_no_clk:
-	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
-fail_no_sysfs:
-	iounmap(pwm->mmio_base);
-fail_no_ioremap:
-	release_mem_region(res->start, resource_size(res));
-fail_no_mem_resource:
-	kfree(pwm);
-fail_no_mem:
-	ep93xx_pwm_release_gpio(pdev);
-	return err;
 }
 
 static int __exit ep93xx_pwm_remove(struct platform_device *pdev)
 {
 	struct ep93xx_pwm *pwm = platform_get_drvdata(pdev);
-	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	ep93xx_pwm_disable(pwm);
 	clk_disable(pwm->clk);
-	clk_put(pwm->clk);
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_pwm_sysfs_files);
-	iounmap(pwm->mmio_base);
-	release_mem_region(res->start, resource_size(res));
-	kfree(pwm);
 	ep93xx_pwm_release_gpio(pdev);
 
 	return 0;
-- 
1.8.1.4

