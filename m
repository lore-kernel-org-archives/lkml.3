Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933Ab3HMM0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:26:14 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:36212 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab3HMM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:26:11 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 1/5] PCI: mvebu: move clock enable before register access
Date: Tue, 13 Aug 2013 14:25:20 +0200
Message-Id: <1376396724-32048-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The clock passed to PCI controller found on MVEBU SoCs may come from a
clock gate. This requires the clock to be enabled before any registers
are accessed. Therefore, move the clock enable before register iomap to
ensure it is enabled.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- remove iounmap, add clk_disable_unprepare on failure
  (Reported by Thomas Pettazoni)

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/host/pci-mvebu.c |   25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 6aa0daf..1533fda 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -897,10 +897,22 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
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
 		if (!port->base) {
 			dev_err(&pdev->dev, "PCIe%d.%d: cannot map registers\n",
 				port->port, port->lane);
+			clk_disable_unprepare(port->clk);
 			continue;
 		}
 
@@ -916,22 +928,9 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
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
1.7.10.4

