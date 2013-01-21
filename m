Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab3AUKJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:09:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60830 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3AUKJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:55 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 20/33] net: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:13 +0100
Message-Id: <1358762966-20791-21-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:np+DKSIWrhk1ZGD8dCs+MoVpioEamb81H4z1Vz6cR/k
 qDS+HkBF1juoFoDY5B6oakatcO6UrcfPCf6pf4tIu9rPNs+k8e
 FSiv5Tqo3mVTxq1ir0LCtcH7Nie+xI0CtXg2ryUL3kELCFwZpG
 jisa7qDGDMoufNg2m5IuMGbKd9RvmKm6vQm9aVVsIWMJj0Ahop
 ArcXn2ZoRCrL/EM/tpTN+N4WB+ZzmydufNK56O915uSzI603vI
 rC8EaK/oJx7xFKKDBnDy7cJ8reFYR4JqRm3DEh8ch41ko3dMf2
 yfWSACdhtE5aIYfu3P7WtvCDIizxAXk4/Ei0dqsyn7aLqWsnwk
 zcE0vENaFCu/Orz2+PRs75kB5O90T/dnwwASISlLSemtgyncf1
 07EXt4QqC0/zhblYWTWoys2leHjWtjtbzlgkzXm14CU7cJEH0E
 krovr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/can/grcan.c                               | 8 ++++----
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 9 ++++-----
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/can/grcan.c b/drivers/net/can/grcan.c
index 17fbc7a..4c3a7dd 100644
--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -26,6 +26,7 @@
  * Contributors: Andreas Larsson <andreas@gaisler.com>
  */
 
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -1683,10 +1684,9 @@ static int grcan_probe(struct platform_device *ofdev)
 	}
 
 	res = platform_get_resource(ofdev, IORESOURCE_MEM, 0);
-	base = devm_request_and_ioremap(&ofdev->dev, res);
-	if (!base) {
-		dev_err(&ofdev->dev, "couldn't map IO resource\n");
-		err = -EADDRNOTAVAIL;
+	base = devm_ioremap_resource(&ofdev->dev, res);
+	if (IS_ERR(base)) {
+		err = PTR_ERR(base);
 		goto exit_error;
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index b43d68b..a3431aa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -22,6 +22,7 @@
   Author: Giuseppe Cavallaro <peppe.cavallaro@st.com>
 *******************************************************************************/
 
+#include <linux/err.h>
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/of.h>
@@ -88,11 +89,9 @@ static int stmmac_pltfr_probe(struct platform_device *pdev)
 	if (!res)
 		return -ENODEV;
 
-	addr = devm_request_and_ioremap(dev, res);
-	if (!addr) {
-		pr_err("%s: ERROR: memory mapping failed", __func__);
-		return -ENOMEM;
-	}
+	addr = devm_ioremap_resource(dev, res);
+	if (IS_ERR(addr))
+		return PTR_ERR(addr);
 
 	if (pdev->dev.of_node) {
 		plat_dat = devm_kzalloc(&pdev->dev,
-- 
1.8.1.1

