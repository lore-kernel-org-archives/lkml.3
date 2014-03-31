Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaCaRxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 13:53:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:40985 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaCaRxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 13:53:07 -0400
X-AuditID: cbfee61b-b7f456d000006dfd-56-5339ab8118a0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-ide@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_samsung_cf: fix ata_host_activate() failure handling
Date: Mon, 31 Mar 2014 19:52:44 +0200
Message-id: <6050762.sdUI3gZZlK@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t9jQd3G1ZbBBlvnmltMWneAyaJ3wVU2
	i02Pr7FaHNvxiMni8q45bBYzzu9jsvi1/CijA7vH31UvmD02repk89i8pN6jb8sqRo/Pm+QC
	WKO4bFJSczLLUov07RK4Mv5eWsxScI+94k/rSpYGxiNsXYycHBICJhL7Djxnh7DFJC7cWw8U
	5+IQEpjOKLFj0h5GCKeFSeLW44mMIFVsAlYSE9tXgdkiArISV6Y9BCtiFjjLKNH8p5O5i5GD
	Q1jAS+JCezhIDYuAqsShFVvAwrwCmhLbvriChEUFPCV2bF8JdgSvgKDEj8n3WEBsZgF5iX37
	p7JC2FoS63ceZ5rAyDcLSdksJGWzkJQtYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc
	ss+kdzCuarA4xCjAwajEw2tRbhksxJpYVlyZe4hRgoNZSYR36wKgEG9KYmVValF+fFFpTmrx
	IUZpDhYlcd6DrdaBQgLpiSWp2ampBalFMFkmDk6pBsaqs3YRURN7Fp37ve75RH3eY/+PdV6P
	ndPgYb+i5GyqtSjP8ZUtVivex1+c9fD/lzlz1At3J26oO/1yiuxlHaPMpjmJ9y9zcj2oDZ4c
	+PYF89pd5nkMQYvYzHxumn4USOZt1KlJPn9a+u9Wp5Ocyt1vtjvKKb/Uunvl9dKHZqfSzt/p
	ywjq/tyuxFKckWioxVxUnAgAfwVE01UCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing clk_disable() call to ata_host_activate() failure path.

Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/ata/pata_samsung_cf.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: b/drivers/ata/pata_samsung_cf.c
===================================================================
--- a/drivers/ata/pata_samsung_cf.c	2014-03-14 16:45:04.344724378 +0100
+++ b/drivers/ata/pata_samsung_cf.c	2014-03-31 18:31:58.083631437 +0200
@@ -594,9 +594,13 @@ static int __init pata_s3c_probe(struct
 
 	platform_set_drvdata(pdev, host);
 
-	return ata_host_activate(host, info->irq,
-			info->irq ? pata_s3c_irq : NULL,
-			0, &pata_s3c_sht);
+	ret = ata_host_activate(host, info->irq,
+				info->irq ? pata_s3c_irq : NULL,
+				0, &pata_s3c_sht);
+	if (ret)
+		goto stop_clk;
+
+	return 0;
 
 stop_clk:
 	clk_disable(info->clk);

