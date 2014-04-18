Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439AbaDRJtc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 05:49:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:45883 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbaDRJWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 05:22:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 04/72] PCI: mvebu: move clock enable before register access
Date: Fri, 18 Apr 2014 11:21:37 +0200
Message-Id: <5829b0e06f0a34f3c3e1aca4851467f61918aeab.1397812482.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
References: <3389f243c528afc7c7300c83b8f296290cd3656d.1397812482.git.jslaby@suse.cz>
In-Reply-To: <cover.1397812482.git.jslaby@suse.cz>
References: <cover.1397812482.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b42285f66f871a9898a0e79e2d74bc7e7a101995 upstream.

The clock passed to PCI controller found on MVEBU SoCs may come from a
clock gate. This requires the clock to be enabled before any registers
are accessed. Therefore, move the clock enable before register iomap to
ensure it is enabled.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/pci/host/pci-mvebu.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 1953c1680986..8efd11dafd44 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -866,11 +866,23 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
 			continue;
 		}
 
+		port->clk = of_clk_get_by_name(child, NULL);
+		if (IS_ERR(port->clk)) {
+			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
+			       port->port, port->lane);
+			continue;
+		}
+
+		ret = clk_prepare_enable(port->clk);
+		if (ret)
+			continue;
+
 		port->base = mvebu_pcie_map_registers(pdev, child, port);
 		if (IS_ERR(port->base)) {
 			dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
 				port->port, port->lane);
 			port->base = NULL;
+			clk_disable_unprepare(port->clk);
 			continue;
 		}
 
@@ -886,22 +898,9 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
 				 port->port, port->lane);
 		}
 
-		port->clk = of_clk_get_by_name(child, NULL);
-		if (IS_ERR(port->clk)) {
-			dev_err(&pdev->dev, "PCIe%d.%d: cannot get clock\n",
-			       port->port, port->lane);
-			iounmap(port->base);
-			port->haslink = 0;
-			continue;
-		}
-
 		port->dn = child;
-
-		clk_prepare_enable(port->clk);
 		spin_lock_init(&port->conf_lock);
-
 		mvebu_sw_pci_bridge_init(port);
-
 		i++;
 	}
 
-- 
1.9.2

