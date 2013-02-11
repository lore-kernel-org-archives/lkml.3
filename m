Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3BKIW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:22:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:56010 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab3BKIW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:22:27 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] of/pci: Add of_pci_get_bus() function
Date: Mon, 11 Feb 2013 09:22:19 +0100
Message-Id: <1360570940-17086-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:9nfQBbUNmJGXiUfiK6uGmjRReOh3jRmr7xRLIjUXNhj
 sRb/Q0h0/LAtcqKdk9ZCpl7Tz0eZA06+hoeL/Ys9neat6i+zRI
 TueBClrTcl4PUyquPzWiYmk9o5VssxYb+bg9r5OmS5o+fmNZjk
 pOiaK8zz+XPA5FxTH0IxVxXFELX5o4d8Gt5qsgGwgBU5snScnN
 hAfqjRX5iKM6QRL6OMBRa/4iM5BuaWfIOH90RVlqLu7dYoGdyK
 9zHFZ6fEePzhg5ZfdkpVDzPFemYKR46is7XOqOqKi6bIK91+Xu
 vKtaJJ1WZTvuerOJ9zkewpPx/Sf2XbE78iICb6H7UVBy1V9EEY
 u+0gIHGvLUpzukm1wAsCgsY8HTDrvd5VhOEvdmtTblSnPaRz2d
 ojOFWW1i4eqZEPM6Hx/0sgxtLRjg1cN1OTWFBSKaEy4wjW1isI
 RwiO3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to parse the number of a device's parent PCI
bus from a standard 5-cell PCI resource.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/of/of_pci.c    | 21 +++++++++++++++++++++
 include/linux/of_pci.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 4dd7b9b..d6e6de5 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -43,6 +43,27 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 EXPORT_SYMBOL_GPL(of_pci_find_child_device);
 
 /**
+ * of_pci_get_bus() - Get bus number for a device node
+ * @np: device node
+ *
+ * Parses a standard 5-cell PCI resource and returns the 8-bit bus number of
+ * the device's parent PCI bus. On error a negative error code is returned.
+ */
+int of_pci_get_bus(struct device_node *np)
+{
+	unsigned int size;
+	const __be32 *reg;
+
+	reg = of_get_property(np, "reg", &size);
+
+	if (!reg || size < 5 * sizeof(__be32))
+		return -EINVAL;
+
+	return (be32_to_cpup(reg) >> 16) & 0xff;
+}
+EXPORT_SYMBOL_GPL(of_pci_get_bus);
+
+/**
  * of_pci_get_devfn() - Get device and function numbers for a device node
  * @np: device node
  *
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 91ec484..9118321 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -10,6 +10,7 @@ int of_irq_map_pci(const struct pci_dev *pdev, struct of_irq *out_irq);
 struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
+int of_pci_get_bus(struct device_node *np);
 int of_pci_get_devfn(struct device_node *np);
 
 #endif
-- 
1.8.1.2

