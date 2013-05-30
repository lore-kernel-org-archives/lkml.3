Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967318Ab3E3CYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 22:24:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:47862 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966953Ab3E3CYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 22:24:36 -0400
Message-ID: <51A6B7D4.7040202@huawei.com>
Date: Thu, 30 May 2013 10:22:12 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <dwmw2@infradead.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        <artem.bityutskiy@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>, <hauke@hauke-m.de>,
        <linux-mtd@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [PATCH RESEND 1/2] mtd: bcm47: convert kzalloc to avoid invalid access
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mtd is just member of bcm47xxsflash, so we should free bcm47xxsflash not its member.
So I use devm_kazlloc instead of kazlloc to avoid it.

* Changelog:
   convert to devm_kzalloc

Signed-off-by: Libo chen <libo.chen@huawei.com>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/mtd/devices/bcm47xxsflash.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/mtd/devices/bcm47xxsflash.c b/drivers/mtd/devices/bcm47xxsflash.c
index 18e7761..2630d5c 100644
--- a/drivers/mtd/devices/bcm47xxsflash.c
+++ b/drivers/mtd/devices/bcm47xxsflash.c
@@ -54,11 +54,9 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
 	struct bcm47xxsflash *b47s;
 	int err;

-	b47s = kzalloc(sizeof(*b47s), GFP_KERNEL);
-	if (!b47s) {
-		err = -ENOMEM;
-		goto out;
-	}
+	b47s = devm_kzalloc(&pdev->dev, sizeof(*b47s), GFP_KERNEL);
+	if (!b47s)
+		return -ENOMEM;
 	sflash->priv = b47s;

 	b47s->bcma_cc = container_of(sflash, struct bcma_drv_cc, sflash);
@@ -81,15 +79,10 @@ static int bcm47xxsflash_bcma_probe(struct platform_device *pdev)
 	err = mtd_device_parse_register(&b47s->mtd, probes, NULL, NULL, 0);
 	if (err) {
 		pr_err("Failed to register MTD device: %d\n", err);
-		goto err_dev_reg;
+		return err;
 	}

 	return 0;
-
-err_dev_reg:
-	kfree(&b47s->mtd);
-out:
-	return err;
 }

 static int bcm47xxsflash_bcma_remove(struct platform_device *pdev)
@@ -98,7 +91,6 @@ static int bcm47xxsflash_bcma_remove(struct platform_device *pdev)
 	struct bcm47xxsflash *b47s = sflash->priv;

 	mtd_device_unregister(&b47s->mtd);
-	kfree(b47s);

 	return 0;
 }
-- 
1.7.1


