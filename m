Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbaB1NJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:09:00 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53568 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751581AbaB1NI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:08:56 -0500
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        linaro-kernel <linaro-kernel@lists.linaro.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 3/5] pci: Create pci_host_bridge before its associated bus in pci_create_root_bus.
Date: Fri, 28 Feb 2014 13:08:20 +0000
Message-Id: <1393592902-24750-4-git-send-email-Liviu.Dudau@arm.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393592902-24750-1-git-send-email-Liviu.Dudau@arm.com>
References: <1393592902-24750-1-git-send-email-Liviu.Dudau@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before commit 7b5436635800 the pci_host_bridge was created before the root bus.
As that commit has added a needless dependency on the bus for pci_alloc_host_bridge()
the creation order has been changed for no good reason. Revert the order of
creation as we are going to depend on the pci_host_bridge structure to retrieve the
domain number of the root bus.

Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6e34498..78ccba0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -505,7 +505,7 @@ static void pci_release_host_bridge_dev(struct device *dev)
 	kfree(bridge);
 }
 
-static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
+static struct pci_host_bridge *pci_alloc_host_bridge(void)
 {
 	struct pci_host_bridge *bridge;
 
@@ -514,7 +514,6 @@ static struct pci_host_bridge *pci_alloc_host_bridge(struct pci_bus *b)
 		return NULL;
 
 	INIT_LIST_HEAD(&bridge->windows);
-	bridge->bus = b;
 	return bridge;
 }
 
@@ -1727,9 +1726,21 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	char bus_addr[64];
 	char *fmt;
 
+	bridge = pci_alloc_host_bridge();
+	if (!bridge)
+		return NULL;
+
+	bridge->dev.parent = parent;
+	bridge->dev.release = pci_release_host_bridge_dev;
+	error = pcibios_root_bridge_prepare(bridge);
+	if (error) {
+		kfree(bridge);
+		return NULL;
+	}
+
 	b = pci_alloc_bus();
 	if (!b)
-		return NULL;
+		goto err_out;
 
 	b->sysdata = sysdata;
 	b->ops = ops;
@@ -1738,26 +1749,15 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 	if (b2) {
 		/* If we already got to this bus through a different bridge, ignore it */
 		dev_dbg(&b2->dev, "bus already known\n");
-		goto err_out;
+		goto err_bus_out;
 	}
 
-	bridge = pci_alloc_host_bridge(b);
-	if (!bridge)
-		goto err_out;
-
-	bridge->dev.parent = parent;
-	bridge->dev.release = pci_release_host_bridge_dev;
+	bridge->bus = b;
 	dev_set_name(&bridge->dev, "pci%04x:%02x", pci_domain_nr(b), bus);
-	error = pcibios_root_bridge_prepare(bridge);
-	if (error) {
-		kfree(bridge);
-		goto err_out;
-	}
-
 	error = device_register(&bridge->dev);
 	if (error) {
 		put_device(&bridge->dev);
-		goto err_out;
+		goto err_bus_out;
 	}
 	b->bridge = get_device(&bridge->dev);
 	device_enable_async_suspend(b->bridge);
@@ -1814,8 +1814,10 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 class_dev_reg_err:
 	put_device(&bridge->dev);
 	device_unregister(&bridge->dev);
-err_out:
+err_bus_out:
 	kfree(b);
+err_out:
+	kfree(bridge);
 	return NULL;
 }
 
-- 
1.9.0

