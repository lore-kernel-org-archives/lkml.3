Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab3HZKCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 06:02:55 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:37346 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab3HZKCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 06:02:54 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <jszhang@marvell.com>, <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>,
        <ezequiel.garcia@free-electrons.com>, <mturquette@linaro.org>,
        <sebastian.hesselbarth@gmail.com>, <linus.walleij@linaro.org>
CC: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 2/3] bus: mvebu: add missing of_node_put() to fix reference leak
Date: Mon, 26 Aug 2013 17:56:20 +0800
Message-ID: <1377510981-1793-3-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377510981-1793-1-git-send-email-jszhang@marvell.com>
References: <1377510981-1793-1-git-send-email-jszhang@marvell.com>
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
 drivers/bus/mvebu-mbus.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/mvebu-mbus.c b/drivers/bus/mvebu-mbus.c
index 33c6947..20da90f 100644
--- a/drivers/bus/mvebu-mbus.c
+++ b/drivers/bus/mvebu-mbus.c
@@ -837,6 +837,7 @@ int __init mvebu_mbus_init(const char *soc, phys_addr_t mbuswins_phys_base,
 {
 	struct mvebu_mbus_state *mbus = &mbus_state;
 	const struct of_device_id *of_id;
+	struct device_node *np;
 	int win;
 
 	for (of_id = of_mvebu_mbus_ids; of_id->compatible; of_id++)
@@ -860,8 +861,11 @@ int __init mvebu_mbus_init(const char *soc, phys_addr_t mbuswins_phys_base,
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
-- 
1.8.4.rc3

