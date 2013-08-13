Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757983Ab3HMM0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 08:26:17 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:37832 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab3HMM0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 08:26:11 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v2 2/5] PCI: mvebu: increment nports only for registered ports
Date: Tue, 13 Aug 2013 14:25:21 +0200
Message-Id: <1376396724-32048-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376396724-32048-1-git-send-email-sebastian.hesselbarth@gmail.com>
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
Changelog:
v1->v2:
- also use 'i' as iterator during port parsing and assign at the end of
  probing (Reported by Thomas Pettazoni)

Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/host/pci-mvebu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/host/pci-mvebu.c b/drivers/pci/host/pci-mvebu.c
index 1533fda..d2e9ae7 100644
--- a/drivers/pci/host/pci-mvebu.c
+++ b/drivers/pci/host/pci-mvebu.c
@@ -842,13 +842,14 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
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
@@ -934,8 +935,8 @@ static int __init mvebu_pcie_probe(struct platform_device *pdev)
 		i++;
 	}
 
+	pcie->nports = i;
 	mvebu_pcie_msi_enable(pcie);
-
 	mvebu_pcie_enable(pcie);
 
 	return 0;
-- 
1.7.10.4

