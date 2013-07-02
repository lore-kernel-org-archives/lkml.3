Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab3GBQur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 12:50:47 -0400
Received: from fallback5.mail.ru ([94.100.176.59]:43300 "EHLO
	fallback5.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3GBQup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 12:50:45 -0400
From: Alexander Shiyan <shc_work@mail.ru>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/3] rtc: ds1742: Using devm_ioremap_resource()
Date: Tue,  2 Jul 2013 20:50:00 +0400
Message-Id: <1372783802-6569-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.1.5
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/rtc/rtc-ds1742.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-ds1742.c b/drivers/rtc/rtc-ds1742.c
index eccdc62..9fba0ae 100644
--- a/drivers/rtc/rtc-ds1742.c
+++ b/drivers/rtc/rtc-ds1742.c
@@ -56,7 +56,6 @@ struct rtc_plat_data {
 	void __iomem *ioaddr_nvram;
 	void __iomem *ioaddr_rtc;
 	size_t size_nvram;
-	size_t size;
 	unsigned long last_jiffies;
 	struct bin_attribute nvram_attr;
 };
@@ -168,22 +167,17 @@ static int ds1742_rtc_probe(struct platform_device *pdev)
 	void __iomem *ioaddr;
 	int ret = 0;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
 	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
-	pdata->size = resource_size(res);
-	if (!devm_request_mem_region(&pdev->dev, res->start, pdata->size,
-		pdev->name))
-		return -EBUSY;
-	ioaddr = devm_ioremap(&pdev->dev, res->start, pdata->size);
-	if (!ioaddr)
-		return -ENOMEM;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(ioaddr))
+		return PTR_ERR(ioaddr);
 
 	pdata->ioaddr_nvram = ioaddr;
-	pdata->size_nvram = pdata->size - RTC_SIZE;
+	pdata->size_nvram = resource_size(res) - RTC_SIZE;
 	pdata->ioaddr_rtc = ioaddr + pdata->size_nvram;
 
 	sysfs_bin_attr_init(&pdata->nvram_attr);
-- 
1.8.1.5

