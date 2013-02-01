Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3BAKRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 05:17:21 -0500
Received: from mail-da0-f54.google.com ([209.85.210.54]:33873 "EHLO
	mail-da0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3BAKRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 05:17:16 -0500
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, thierry.reding@avionic-design.de,
        sachin.kamat@linaro.org, Laxman Dewangan <ldewangan@nvidia.com>,
        linux-serial@vger.kernel.org
Subject: [PATCH v2 2/2] serial: tegra: Convert to devm_ioremap_resource()
Date: Fri,  1 Feb 2013 15:37:57 +0530
Message-Id: <1359713277-14228-2-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1359713277-14228-1-git-send-email-sachin.kamat@linaro.org>
References: <1359713277-14228-1-git-send-email-sachin.kamat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced devm_ioremap_resource() instead of
devm_request_and_ioremap() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages; so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: linux-serial@vger.kernel.org
---
Patch based & compile tested on linux-next tree (20130128).
Changes since v1:
* Dropped the error message as it is now handled by devm_ioremap_resource()
itself.
---
 drivers/tty/serial/serial-tegra.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 4f5e629..24ced23 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -26,6 +26,7 @@
 #include <linux/dmaengine.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
+#include <linux/err.h>
 #include <linux/io.h>
 #include <linux/irq.h>
 #include <linux/module.h>
@@ -1302,11 +1303,9 @@ static int tegra_uart_probe(struct platform_device *pdev)
 	}
 
 	u->mapbase = resource->start;
-	u->membase = devm_request_and_ioremap(&pdev->dev, resource);
-	if (!u->membase) {
-		dev_err(&pdev->dev, "memregion/iomap address req failed\n");
-		return -EADDRNOTAVAIL;
-	}
+	u->membase = devm_ioremap_resource(&pdev->dev, resource);
+	if (IS_ERR(u->membase))
+		return PTR_ERR(u->membase);
 
 	tup->uart_clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(tup->uart_clk)) {
-- 
1.7.4.1

