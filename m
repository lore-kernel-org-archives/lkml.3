Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbaENIt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 04:49:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33255 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753559AbaENItx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 04:49:53 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <arnd@arndb.de>, <tony@atomide.com>, <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>
Subject: [PATCH] bus: ocp2scp: SYNC2 value should be changed to 0x6
Date: Wed, 14 May 2014 14:19:33 +0530
Message-ID: <1400057373-2871-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read path of OCP2SCP is not working properly due to low reset value
of SYNC2 parameter in OCP2SCP. So changed the SYNC2 value to 0x6.

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 drivers/bus/omap-ocp2scp.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/bus/omap-ocp2scp.c b/drivers/bus/omap-ocp2scp.c
index 5511f98..0a974b2 100644
--- a/drivers/bus/omap-ocp2scp.c
+++ b/drivers/bus/omap-ocp2scp.c
@@ -16,6 +16,7 @@
  *
  */
 
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
@@ -23,6 +24,9 @@
 #include <linux/of.h>
 #include <linux/of_platform.h>
 
+#define	OCP2SCP_TIMING	0x18
+#define	SYNC2_MASK	0xf
+
 static int ocp2scp_remove_devices(struct device *dev, void *c)
 {
 	struct platform_device *pdev = to_platform_device(dev);
@@ -35,6 +39,9 @@ static int ocp2scp_remove_devices(struct device *dev, void *c)
 static int omap_ocp2scp_probe(struct platform_device *pdev)
 {
 	int ret;
+	u32 reg;
+	void __iomem *regs;
+	struct resource *res;
 	struct device_node *np = pdev->dev.of_node;
 
 	if (np) {
@@ -46,8 +53,24 @@ static int omap_ocp2scp_probe(struct platform_device *pdev)
 		}
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	regs = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(regs))
+		return PTR_ERR(regs);
+
 	pm_runtime_enable(&pdev->dev);
 
+	/*
+	 * Read path of OCP2SCP is not working properly due to low reset value
+	 * of SYNC2 parameter in OCP2SCP. Suggested reset value is 0x6.
+	 */
+	pm_runtime_get_sync(&pdev->dev);
+	reg = readl(regs + OCP2SCP_TIMING);
+	reg &= ~(SYNC2_MASK);
+	reg |= 0x6;
+	writel(reg, regs + OCP2SCP_TIMING);
+	pm_runtime_put_sync(&pdev->dev);
+
 	return 0;
 
 err0:
-- 
1.7.9.5

