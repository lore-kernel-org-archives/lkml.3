Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828AbaCTJXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:23:25 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33154 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745AbaCTJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:22:33 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        computersforpeace@gmail.com
Cc: linux-mtd@lists.infradead.org, dwmw2@infradead.org, Angus.Clark@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v6 35/36] mtd: st_spi_fsm: Convert ST SPI FSM (NOR) Flash driver to new DT partitions
Date: Thu, 20 Mar 2014 09:21:07 +0000
Message-Id: <1395307268-12721-36-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
References: <1395307268-12721-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old API expected a "partitions" property provided a phandle to a
separate partitions node, which itself contained yet more nodes each
representing one partition. The new API rids the requirement for the
superfluous intermediary partitions node. This patch provides the
added information required for automatic parsing by the core.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/devices/st_spi_fsm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
index dccbac0..aefd48d 100644
--- a/drivers/mtd/devices/st_spi_fsm.c
+++ b/drivers/mtd/devices/st_spi_fsm.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/mfd/syscon.h>
 #include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
 #include <linux/sched.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -1997,6 +1998,7 @@ boot_device_fail:
 static int stfsm_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
+	struct mtd_part_parser_data ppdata;
 	struct flash_info *info;
 	struct resource *res;
 	struct stfsm *fsm;
@@ -2006,6 +2008,7 @@ static int stfsm_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "No DT found\n");
 		return -EINVAL;
 	}
+	ppdata.of_node = np;
 
 	fsm = devm_kzalloc(&pdev->dev, sizeof(*fsm), GFP_KERNEL);
 	if (!fsm)
@@ -2062,6 +2065,7 @@ static int stfsm_probe(struct platform_device *pdev)
 			return ret;
 	}
 
+	fsm->mtd.name		= info->name;
 	fsm->mtd.dev.parent	= &pdev->dev;
 	fsm->mtd.type		= MTD_NORFLASH;
 	fsm->mtd.writesize	= 4;
@@ -2081,7 +2085,7 @@ static int stfsm_probe(struct platform_device *pdev)
 		(long long)fsm->mtd.size, (long long)(fsm->mtd.size >> 20),
 		fsm->mtd.erasesize, (fsm->mtd.erasesize >> 10));
 
-	return mtd_device_parse_register(&fsm->mtd, NULL, NULL, NULL, 0);
+	return mtd_device_parse_register(&fsm->mtd, NULL, &ppdata, NULL, 0);
 }
 
 static int stfsm_remove(struct platform_device *pdev)
-- 
1.8.3.2

