Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaBKVsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:48:05 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:46867 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaBKVr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:47:29 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gupta Pekon <pekon@ti.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Subject: =?UTF-8?q?=5BRFC=20PATCH=20v2=203/4=5D=20mtd=3A=20nand=3A=20add=20DT=20NAND=20partition=20parser?=
Date: Tue, 11 Feb 2014 22:46:48 +0100
Message-Id: <1392155209-14495-4-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1392155209-14495-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ofnandpart_parse function to help parsing NAND partitions from DT.
This function should be called from NAND controller drivers just after the
nand_scan_tail in place of mtd_device_parse_register.
The caller can specify a parser function to retrieve HW specific
informations from  the DT.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/mtd/nand/ofnandpart.c |  104 +++++++++++++++++++++++++++++++++++++++++
 include/linux/mtd/nand.h      |   17 +++++++
 2 files changed, 121 insertions(+)
 create mode 100644 drivers/mtd/nand/ofnandpart.c

diff --git a/drivers/mtd/nand/ofnandpart.c b/drivers/mtd/nand/ofnandpart.c
new file mode 100644
index 0000000..293daee
--- /dev/null
+++ b/drivers/mtd/nand/ofnandpart.c
@@ -0,0 +1,104 @@
+/*
+ * NAND Flash partitions described by the OF (or flattened) device tree
+ *
+ * Copyright © 2014 Boris BREZILLON <b.brezillon.dev@gmail.com>
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/of.h>
+#include <linux/mtd/mtd.h>
+#include <linux/slab.h>
+#include <linux/mtd/nand.h>
+
+static inline bool node_has_compatible(struct device_node *pp)
+{
+	return of_get_property(pp, "compatible", NULL);
+}
+
+int ofnandpart_parse(struct mtd_info *master,
+		     const struct ofnandpart_data *data)
+{
+	struct device_node *node;
+	const char *partname;
+	struct device_node *pp;
+	int i;
+
+	if (!data)
+		return 0;
+
+	node = data->node;
+	if (!node)
+		return 0;
+
+	i = 0;
+	for_each_child_of_node(node,  pp) {
+		const __be32 *reg;
+		int len;
+		int a_cells, s_cells;
+		uint64_t offset, size;
+		uint32_t mask_flags = 0;
+		struct nand_part *part;
+
+		if (node_has_compatible(pp))
+			continue;
+
+		reg = of_get_property(pp, "reg", &len);
+		if (!reg)
+			continue;
+
+		a_cells = of_n_addr_cells(pp);
+		s_cells = of_n_size_cells(pp);
+		offset = of_read_number(reg, a_cells);
+		size = of_read_number(reg + a_cells, s_cells);
+
+		partname = of_get_property(pp, "label", &len);
+		if (!partname)
+			partname = of_get_property(pp, "name", &len);
+
+		if (of_get_property(pp, "read-only", &len))
+			mask_flags |= MTD_WRITEABLE;
+
+		if (of_get_property(pp, "lock", &len))
+			mask_flags |= MTD_POWERUP_LOCK;
+
+		if (data->parse)
+			part = data->parse(data->priv, master, pp);
+		else
+			part = nandpart_alloc();
+
+		if (IS_ERR(part))
+			continue;
+
+		part->offset = offset;
+		part->master = master;
+		part->mtd.name = partname;
+		part->mtd.size = size;
+		part->mtd.flags = mask_flags;
+
+		if (nand_add_partition(master, part)) {
+			if (part->release)
+				part->release(part);
+			continue;
+		}
+
+		i++;
+	}
+
+	if (!i) {
+		of_node_put(pp);
+		pr_err("No valid partition found on %s\n", node->full_name);
+	}
+
+	return i;
+}
+EXPORT_SYMBOL(ofnandpart_parse);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Parser for NAND flash partitioning information in device tree");
+MODULE_AUTHOR("Boris BREZILLON");
diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index c4d271a..0c5890b 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -845,6 +845,23 @@ void nand_del_partition(struct nand_part *part);
 struct nand_part *nandpart_alloc(void);
 
 /**
+ * struct ofnandpart_data - struct used to retrieve NAND partitions from a DT
+ *			    node
+ * @parse:		driver specific parser function
+ * @priv:		driver private data
+ * @node:		OF node containing NAND partitions
+ */
+struct ofnandpart_data {
+	struct nand_part *(*parse)(void *priv, struct mtd_info *master,
+				   struct device_node *pp);
+	void *priv;
+	struct device_node *node;
+};
+
+int ofnandpart_parse(struct mtd_info *master,
+		     const struct ofnandpart_data *data);
+
+/**
  * struct nand_sdr_timings - SDR NAND chip timings
  *
  * This struct defines the timing requirements of a SDR NAND chip.
-- 
1.7.9.5

