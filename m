Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3BKIWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 03:22:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55722 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab3BKIW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 03:22:28 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] of/pci: Add of_pci_parse_bus_range() function
Date: Mon, 11 Feb 2013 09:22:20 +0100
Message-Id: <1360570940-17086-5-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:Ed9neIwyaO/wtSBN7UeP0d5W8cvz1MsHviRGlZn7u3C
 EIP7lKqXATTBIcXomur05s67jIdt4+Ac1co5CxuJ5v5AGTzmX4
 Cre2ZyweAlzq5qb96HwOAH9o6sdTSPLOHz6ynVjeIBsqPwlgJz
 ldWv0hYodVvS3pw7vKiQrzxE/Su1nOkegEfBzs7l048MPmuELy
 DzP0P2Xslv0WJvfyoaMs7Ay9QMaQgoVucSzUlpvM1u3Q2Hf88a
 bQMkAr15nQmuVOoQMeM5d4zXx+NGularoBT/mpj8wabqezm/ue
 Nai0DIjbTassfW7424POQTCGBQRf6TapRH2gD6o+saheGmvyLZ
 XzbkKhD1Ee7xl2aQFTHRPQHAanWvg2wt1K5LVV/+oI79Xen4E9
 ZkWSOD3grRJayfJxTFcl1mrDsMC9O+83aozzGKxVkmby50Ce0t
 4xSUI
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
index d6e6de5..fb92ded 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -85,3 +85,28 @@ int of_pci_get_devfn(struct device_node *np)
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
index 9118321..fb6e95e 100644
--- a/include/linux/of_pci.h
+++ b/include/linux/of_pci.h
@@ -12,5 +12,6 @@ struct device_node *of_pci_find_child_device(struct device_node *parent,
 					     unsigned int devfn);
 int of_pci_get_bus(struct device_node *np);
 int of_pci_get_devfn(struct device_node *np);
+int of_pci_parse_bus_range(struct device_node *node, struct resource *res);
 
 #endif
-- 
1.8.1.2

