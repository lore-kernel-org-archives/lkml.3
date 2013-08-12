Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3HLSrK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:47:10 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:51248 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab3HLSrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:47:03 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH 2/9] PCI: mvebu: increment nports only for registered ports
Date: Mon, 12 Aug 2013 20:46:48 +0200
Message-Id: <1376333215-12885-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of ports is probed by counting the number of available child nodes.
Later on, the registration of a port can fail and cause a mismatch between
the ->nports counter and registered ports. This patch modifies the counting
strategy, to make ->nports represent the number of registered ports instead
of the number of available childs.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/host/pci-mvebu.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index d5fe674..0a359d7 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -842,21 +842,21 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	i = 0;
 	for_each_child_of_node(pdev->dev.of_node, child) {
 		if (!of_device_is_available(child))
 			continue;
-		pcie->nports++;
+		i++;
 	}
 
-	pcie->ports = devm_kzalloc(&pdev->dev, pcie->nports *
+	pcie->ports = devm_kzalloc(&pdev->dev, i *
 				   sizeof(struct mvebu_pcie_port),
 				   GFP_KERNEL);
 	if (!pcie->ports)
 		return -ENOMEM;
 
-	i = 0;
 	for_each_child_of_node(pdev->dev.of_node, child) {
-		struct mvebu_pcie_port *port = &pcie->ports[i];
+		struct mvebu_pcie_port *port = &pcie->ports[pcie->nports];
 
 		if (!of_device_is_available(child))
 			continue;
@@ -929,7 +929,7 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
 		port->dn = child;
 		spin_lock_init(&port->conf_lock);
 		mvebu_sw_pci_bridge_init(port);
-		i++;
+		pcie->nports++;
 	}
 
 	mvebu_pcie_msi_enable(pcie);
-- 
1.7.10.4

