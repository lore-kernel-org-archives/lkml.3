Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaFER0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:26:39 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:65182 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761AbaFER0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:26:36 -0400
From: Matthias Brugger <matthias.bgg@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de, matthias.bgg@gmail.com,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        maxime.ripard@free-electrons.com, soren.brinkmann@xilinx.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v7 1/7] of: Provide function to request and map memory
Date: Thu,  5 Jun 2014 19:26:15 +0200
Message-Id: <1401989181-4712-2-git-send-email-matthias.bgg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1401989181-4712-1-git-send-email-matthias.bgg@gmail.com>
References: <1401989181-4712-1-git-send-email-matthias.bgg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A call to of_iomap does not request the memory region.
This patch adds the function of_io_request_and_map which requests
the memory region before mapping it.

Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
---
 drivers/of/address.c       |   28 ++++++++++++++++++++++++++++
 include/linux/of_address.h |    8 ++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index cb4242a..c55b107 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -721,3 +721,31 @@ void __iomem *of_iomap(struct device_node *np, int index)
 	return ioremap(res.start, resource_size(&res));
 }
 EXPORT_SYMBOL(of_iomap);
+
+/**
+ * of_io_request_and_map - Requests a resource and maps the memory mapped IO
+ *			   for a given device_node
+ * @device:	the device whose io range will be mapped
+ * @index:	index of the io range
+ * @name:	name of the resource
+ *
+ * Returns a pointer to the requested and mapped memory
+ */
+void __iomem *of_io_request_and_map(struct device_node *np, int index, char *name)
+{
+	struct resource res;
+	void __iomem *mem;
+
+	if (of_address_to_resource(np, index, &res))
+		return NULL;
+
+	if (!request_mem_region(res.start, resource_size(&res), name))
+		return NULL;
+
+	mem = ioremap(res.start, resource_size(&res));
+	if (!mem)
+		release_mem_region(res.start, resource_size(&res));
+
+	return mem;
+}
+EXPORT_SYMBOL(of_io_request_and_map);
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 5f6ed6b..725b875 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -96,6 +96,8 @@ static inline struct of_pci_range *of_pci_range_parser_one(
 extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
 void __iomem *of_iomap(struct device_node *node, int index);
+void __iomem *of_io_request_and_map(struct device_node *device,
+					int index, char *name);
 #else
 static inline int of_address_to_resource(struct device_node *dev, int index,
 					 struct resource *r)
@@ -107,6 +109,12 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
 {
 	return NULL;
 }
+
+static inline void __iomem *of_io_request_and_map(struct device_node *device,
+					int index, char *name)
+{
+	return NULL;
+}
 #endif
 
 #if defined(CONFIG_OF_ADDRESS) && defined(CONFIG_PCI)
-- 
1.7.9.5

