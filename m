Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab3HZLkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:40:16 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:51863 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618Ab3HZLkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:40:14 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v4 2/3] bus: mvebu: add missing of_node_put() to fix reference leak
Date: Mon, 26 Aug 2013 19:36:57 +0800
Message-ID: <1377517018-7716-3-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
References: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add of_node_put to properly decrement the refcount when we are
done using a given node.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
Reviewed-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
---
 drivers/bus/mvebu-mbus.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index 19ab6ff..a7c12fb 100644
--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -701,6 +701,7 @@ static int __init mvebu_mbus_common_init(struct mvebu_mbus_state *mbus,
 					 size_t sdramwins_size)
 {
 	int win;
+	struct device_node *np;
 
 	mbus->mbuswins_base = ioremap(mbuswins_phys_base, mbuswins_size);
 	if (!mbus->mbuswins_base)
@@ -712,8 +713,11 @@ static int __init mvebu_mbus_common_init(struct mvebu_mbus_state *mbus,
 		return -ENOMEM;
 	}
 
-	if (of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric"))
+	np = of_find_compatible_node(NULL, NULL, "marvell,coherency-fabric");
+	if (np) {
 		mbus->hw_io_coherency = 1;
+		of_node_put(np);
+	}
 
 	for (win = 0; win < mbus->soc->num_wins; win++)
 		mvebu_mbus_disable_window(mbus, win);
@@ -902,23 +906,27 @@ int __init mvebu_mbus_dt_init(void)
 	prop = of_get_property(np, "controller", NULL);
 	if (!prop) {
 		pr_err("required 'controller' property missing\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto np_out;
 	}
 
 	controller = of_find_node_by_phandle(be32_to_cpup(prop));
 	if (!controller) {
 		pr_err("could not find an 'mbus-controller' node\n");
-		return -ENODEV;
+		ret = -ENODEV;
+		goto np_out;
 	}
 
 	if (of_address_to_resource(controller, 0, &mbuswins_res)) {
 		pr_err("cannot get MBUS register address\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto phandle_out;
 	}
 
 	if (of_address_to_resource(controller, 1, &sdramwins_res)) {
 		pr_err("cannot get SDRAM register address\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto phandle_out;
 	}
 
 	/* Get optional pcie-{mem,io}-aperture properties */
@@ -931,9 +939,14 @@ int __init mvebu_mbus_dt_init(void)
 				     sdramwins_res.start,
 				     resource_size(&sdramwins_res));
 	if (ret)
-		return ret;
+		goto phandle_out;
 
 	/* Setup statically declared windows in the DT */
-	return mbus_dt_setup(&mbus_state, np);
+	ret = mbus_dt_setup(&mbus_state, np);
+phandle_out:
+	of_node_put(controller);
+np_out:
+	of_node_put(np);
+	return ret;
 }
 #endif
-- 
1.8.4.rc3

