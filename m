Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390Ab3DGLKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:10:23 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50821 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933360Ab3DGLKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:10:22 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <florian@openwrt.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: mvmdio: get and enable optional clock
Date: Sun,  7 Apr 2013 13:09:47 +0200
Message-Id: <1365332988-9053-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvell mdio driver uses internal registers that can be clock gated on
some SoCs. This patch just adds optional clock handling, to allow to pass
and enable the corresponding clock.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Florian Fainelli <florian@openwrt.org>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/marvell/mvmdio.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 7b5158f..e2f6626 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -28,6 +28,7 @@
 #include <linux/platform_device.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/clk.h>
 #include <linux/of_mdio.h>
 #include <linux/sched.h>
 #include <linux/wait.h>
@@ -46,6 +47,7 @@
 struct orion_mdio_dev {
 	struct mutex lock;
 	void __iomem *regs;
+	struct clk *clk;
 	/*
 	 * If we have access to the error interrupt pin (which is
 	 * somewhat misnamed as it not only reflects internal errors
@@ -230,6 +232,10 @@ static int orion_mdio_probe(struct platform_device *pdev)
 
 	init_waitqueue_head(&dev->smi_busy_wait);
 
+	dev->clk = devm_clk_get(&pdev->dev, NULL);
+	if (!IS_ERR(dev->clk))
+		clk_prepare_enable(dev->clk);
+
 	dev->err_interrupt = platform_get_irq(pdev, 0);
 	if (dev->err_interrupt != -ENXIO) {
 		ret = devm_request_irq(&pdev->dev, dev->err_interrupt,
@@ -258,6 +264,8 @@ static int orion_mdio_probe(struct platform_device *pdev)
 	return 0;
 
 out_mdio:
+	if (!IS_ERR(dev->clk))
+		clk_disable_unprepare(dev->clk);
 	kfree(bus->irq);
 	mdiobus_free(bus);
 	return ret;
@@ -272,6 +280,9 @@ static int orion_mdio_remove(struct platform_device *pdev)
 	mdiobus_unregister(bus);
 	kfree(bus->irq);
 	mdiobus_free(bus);
+	if (!IS_ERR(dev->clk))
+		clk_disable_unprepare(dev->clk);
+
 	return 0;
 }
 
-- 
1.7.10.4

