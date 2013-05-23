Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab3EWMAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 08:00:42 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:62660 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758576Ab3EWMAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 08:00:40 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <wsa@the-dreams.de>
CC: <guz.fnst@cn.fujitsu.com>, <sonic.zhang@analog.com>,
        <uclinux-dist-devel@blackfin.uclinux.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
Date: Thu, 23 May 2013 20:00:05 +0800
Message-ID: <1369310405-21112-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

peripheral_request_list has got free if any one faild, so no need to free again in err case.
aovid this, convert them to devm_* API

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/i2c/busses/i2c-bfin-twi.c |   38 +++++++++---------------------------
 1 files changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/i2c/busses/i2c-bfin-twi.c b/drivers/i2c/busses/i2c-bfin-twi.c
index 05080c4..2b99c48 100644
--- a/drivers/i2c/busses/i2c-bfin-twi.c
+++ b/drivers/i2c/busses/i2c-bfin-twi.c
@@ -621,35 +621,27 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	int rc;
 	unsigned int clkhilow;
 
-	iface = kzalloc(sizeof(struct bfin_twi_iface), GFP_KERNEL);
+	iface = devm_kzalloc(&pdev->dev, sizeof(struct bfin_twi_iface),
+			GFP_KERNEL);
 	if (!iface) {
 		dev_err(&pdev->dev, "Cannot allocate memory\n");
-		rc = -ENOMEM;
-		goto out_error_nomem;
+		return -ENOMEM;
 	}
 
 	spin_lock_init(&(iface->lock));
 
 	/* Find and map our resources */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
-		rc = -ENOENT;
-		goto out_error_get_res;
-	}
-
-	iface->regs_base = ioremap(res->start, resource_size(res));
-	if (iface->regs_base == NULL) {
+	iface->regs_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(iface->regs_base)) {
 		dev_err(&pdev->dev, "Cannot map IO\n");
-		rc = -ENXIO;
-		goto out_error_ioremap;
+		return -ENXIO;
 	}
 
 	iface->irq = platform_get_irq(pdev, 0);
 	if (iface->irq < 0) {
 		dev_err(&pdev->dev, "No IRQ specified\n");
-		rc = -ENOENT;
-		goto out_error_no_irq;
+		return -ENOENT;
 	}
 
 	p_adap = &iface->adap;
@@ -666,10 +658,10 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 					"i2c-bfin-twi");
 	if (rc) {
 		dev_err(&pdev->dev, "Can't setup pin mux!\n");
-		goto out_error_pin_mux;
+		return rc;
 	}
 
-	rc = request_irq(iface->irq, bfin_twi_interrupt_entry,
+	rc = devm_request_irq(&pdev->dev, iface->irq, bfin_twi_interrupt_entry,
 		0, pdev->name, iface);
 	if (rc) {
 		dev_err(&pdev->dev, "Can't get IRQ %d !\n", iface->irq);
@@ -707,16 +699,9 @@ static int i2c_bfin_twi_probe(struct platform_device *pdev)
 	return 0;
 
 out_error_add_adapter:
-	free_irq(iface->irq, iface);
 out_error_req_irq:
-out_error_no_irq:
 	peripheral_free_list((unsigned short *)pdev->dev.platform_data);
-out_error_pin_mux:
-	iounmap(iface->regs_base);
-out_error_ioremap:
-out_error_get_res:
-	kfree(iface);
-out_error_nomem:
+
 	return rc;
 }
 
@@ -725,10 +710,7 @@ static int i2c_bfin_twi_remove(struct platform_device *pdev)
 	struct bfin_twi_iface *iface = platform_get_drvdata(pdev);
 
 	i2c_del_adapter(&(iface->adap));
-	free_irq(iface->irq, iface);
 	peripheral_free_list((unsigned short *)pdev->dev.platform_data);
-	iounmap(iface->regs_base);
-	kfree(iface);
 
 	return 0;
 }
-- 
1.7.1


