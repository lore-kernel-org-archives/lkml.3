Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3FZSEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 14:04:40 -0400
Received: from gloria.sntech.de ([95.129.55.99]:45426 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383Ab3FZSEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 14:04:39 -0400
From: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 2/3] watchdog: dw_wdt: use clk_prepare_enable and clk_disable_unprepare
Date: Wed, 26 Jun 2013 20:04:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-686-pae; KDE/4.8.4; i686; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
References: <201306262003.13256.heiko@sntech.de>
In-Reply-To: <201306262003.13256.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201306262004.31808.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is necessary to make the driver work with platforms using the
common clock framework.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/watchdog/dw_wdt.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/watchdog/dw_wdt.c b/drivers/watchdog/dw_wdt.c
index 4d3906d..b922bec 100644
--- a/drivers/watchdog/dw_wdt.c
+++ b/drivers/watchdog/dw_wdt.c
@@ -255,14 +255,14 @@ static int dw_wdt_release(struct inode *inode, struct file *filp)
 #ifdef CONFIG_PM_SLEEP
 static int dw_wdt_suspend(struct device *dev)
 {
-	clk_disable(dw_wdt.clk);
+	clk_disable_unprepare(dw_wdt.clk);
 
 	return 0;
 }
 
 static int dw_wdt_resume(struct device *dev)
 {
-	int err = clk_enable(dw_wdt.clk);
+	int err = clk_prepare_enable(dw_wdt.clk);
 
 	if (err)
 		return err;
@@ -306,7 +306,7 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	if (IS_ERR(dw_wdt.clk))
 		return PTR_ERR(dw_wdt.clk);
 
-	ret = clk_enable(dw_wdt.clk);
+	ret = clk_prepare_enable(dw_wdt.clk);
 	if (ret)
 		return ret;
 
@@ -323,7 +323,7 @@ static int dw_wdt_drv_probe(struct platform_device *pdev)
 	return 0;
 
 out_disable_clk:
-	clk_disable(dw_wdt.clk);
+	clk_disable_unprepare(dw_wdt.clk);
 
 	return ret;
 }
@@ -332,7 +332,7 @@ static int dw_wdt_drv_remove(struct platform_device *pdev)
 {
 	misc_deregister(&dw_wdt_miscdev);
 
-	clk_disable(dw_wdt.clk);
+	clk_disable_unprepare(dw_wdt.clk);
 
 	return 0;
 }
-- 
1.7.10.4

