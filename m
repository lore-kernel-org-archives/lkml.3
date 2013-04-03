Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761853Ab3DCOqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:46:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63043 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844Ab3DCOpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:45:54 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH v3 03/12] of/pci: Add of_pci_parse_bus_range() function
Date: Wed,  3 Apr 2013 16:45:09 +0200
Message-Id: <1365000318-28256-4-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
References: <1365000318-28256-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:NMZjLb00773EoV79SNxpiFMIOXAvCykZPtwfpvzIML3
 +hOxiIUWNtPoUpJbaRJ2JLLelbrDps0OCmcZ8J+zzCuhsGeAcc
 qEHjokUWxRA0lSZdt0U0i0+gVpXGFIVfywBM32052SmaxxM/aj
 P6rYfr6T63L3oBvzvMsFz23kl/YmSmsG1PNS49Ghi80QK6lHA2
 L84hZhAo5UUHxHULietVsoxmARijBDigg4+BtobNfRQDkIVPNK
 cvABcRXAybk3iekg/eAIy/MIMHmyNrkg2Jq0NYk44HW8+5q/Rs
 3hc1U7oA/JDXpoIx+hJTYawze9jwkyZxMhaWx9ULoIvPCNfwkp
 1mu0FB/f4jS7e6BK+bDG87ovR+pSRm30/QJ05hMfLOBgWIAS4I
 HmBlxDGWhkyDTWSCWM+y+yvZ7f3RKmBAmnnJBT8sixy3oLRZ/s
 TeajF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function can be used to parse a bus-range property as specified by
device nodes representing PCI bridges.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/of/of_pci.c    | 25 +++++++++++++++++++++++++
 include/linux/of_pci.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index 4dd7b9b..42c687a 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -64,3 +64,28 @@ int of_pci_get_devfn(struct device_node *np)
 	return (be32_to_cpup(reg) >> 8) & 0xff;
 }
 EXPORT_SYMBOL_GPL(of_pci_get_devfn);
+
+/**
+ * of_pci_parse_bus_range() - parse the bus-range property of a PCI device
+ * @node: device node
+ * @res: address to a struct resource to return the bus-range
+ *
+ * Returns 0 on success or a negative error-code on failure.
+ */
+int of_pci_parse_bus_range(struct device_node *node, struct resource *res)
+{
+	const __be32 *values;
+	int len;
+
+	values = of_get_property(node, "bus-range", &len);
+	if (!values || len < sizeof(*values) * 2)
+		return -EINVAL;
+
+	res->name = node->name;
+	res->start = be32_to_cpup(values++);
+	res->end = be32_to_cpup(values);
+	res->flags = IORESOURCE_BUS;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_pci_parse_bus_range);
diff --git a/include/linux/of_pci.h b/include/linux/of_pci.h
index 91ec484..7a04826 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -11,5 +11,6 @@ struct device_node;
 struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
 int of_pci_get_devfn(struct device_node *np);
+int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 
 #endif
-- 
1.8.2

