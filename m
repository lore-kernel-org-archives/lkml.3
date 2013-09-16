Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab3IPXLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:11:54 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44043 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab3IPXJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:53 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 23/28] of: introduce common FDT machine related functions
Date: Mon, 16 Sep 2013 18:09:19 -0500
Message-Id: <1379372965-22359-24-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Introduce common of_flat_dt_match_machine and
of_flat_dt_get_machine_name functions to unify architectures' handling
of machine level model and compatible properties.

Several architectures match the root compatible string with an arch
specific list of machine descriptors duplicating the same search
algorithm. Create a common implementation with a simple architecture
specific hook to iterate over each machine's match table.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/fdt.c       | 60 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_fdt.h |  4 ++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 83cdeb5..e21d1dc 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -619,6 +619,66 @@ int __init of_scan_flat_dt_by_path(const char *path,
 		return ret;
 }
 
+const char *of_flat_dt_get_machine_name(void)
+{
+	const char *name;
+	unsigned long dt_root = of_get_flat_dt_root();
+
+	name = of_get_flat_dt_prop(dt_root, "model", NULL);
+	if (!name)
+		name = of_get_flat_dt_prop(dt_root, "compatible", NULL);
+	return name;
+}
+
+/**
+ * of_flat_dt_match_machine - Iterate match tables to find matching machine.
+ *
+ * @default_match: A machine specific ptr to return in case of no match.
+ * @get_next_compat: callback function to return next compatible match table.
+ *
+ * Iterate through machine match tables to find the best match for the machine
+ * compatible string in the FDT.
+ */
+void * __init of_flat_dt_match_machine(void *default_match,
+				       void * (*get_next_compat)(const char * const**))
+{
+	void *data = NULL;
+	void *best_data = default_match;
+	const char *const *compat;
+	unsigned long dt_root;
+	unsigned int best_score = ~1, score = 0;
+
+	dt_root = of_get_flat_dt_root();
+	while ((data = get_next_compat(&compat))) {
+		score = of_flat_dt_match(dt_root, compat);
+		if (score > 0 && score < best_score) {
+			best_data = data;
+			best_score = score;
+		}
+	}
+	if (!best_data) {
+		const char *prop;
+		long size;
+
+		pr_err("\n unrecognized device tree list:\n[ ");
+
+		prop = of_get_flat_dt_prop(dt_root, "compatible", &size);
+		if (prop) {
+			while (size > 0) {
+				printk("'%s' ", prop);
+				size -= strlen(prop) + 1;
+				prop += strlen(prop) + 1;
+			}
+		}
+		printk("]\n\n");
+		return NULL;
+	}
+
+	pr_info("Machine model: %s\n", of_flat_dt_get_machine_name());
+
+	return best_data;
+}
+
 #ifdef CONFIG_BLK_DEV_INITRD
 /**
  * early_init_dt_check_for_initrd - Decode initrd location from flat tree
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index b365f5a..985a744 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -108,6 +108,10 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
 
 extern bool early_init_dt_scan(void *params);
 
+const char *of_flat_dt_get_machine_name(void);
+extern void *of_flat_dt_match_machine(void *default_match,
+		void * (*get_next_compat)(const char * const**));
+
 /* Other Prototypes */
 extern void unflatten_device_tree(void);
 extern void unflatten_and_copy_device_tree(void);
-- 
1.8.1.2

