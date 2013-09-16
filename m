Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab3IPXP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 19:15:58 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35974 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab3IPXJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 19:09:36 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 03/28] of: create unflatten_and_copy_device_tree
Date: Mon, 16 Sep 2013 18:08:59 -0500
Message-Id: <1379372965-22359-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
References: <1379372965-22359-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Several architectures using DT support built-in dtb's in the init
section. These platforms need to copy the dtb from init since the
strings are referenced after unflattening. Every arch has their own
copying routine which do the same thing. Create a common function,
unflatten_and_copy_device_tree, to copy the dtb when unflattening the
dtb.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/fdt.c       | 13 +++++++++++++
 include/linux/of_fdt.h |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 229dd9d..eca1810 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -802,6 +802,19 @@ void __init unflatten_device_tree(void)
 	of_alias_scan(early_init_dt_alloc_memory_arch);
 }
 
+void __init unflatten_and_copy_device_tree(void)
+{
+	int size = __be32_to_cpu(initial_boot_params->totalsize);
+	void *dt = early_init_dt_alloc_memory_arch(size,
+		__alignof__(struct boot_param_header));
+
+	if (dt) {
+		memcpy(dt, initial_boot_params, size);
+		initial_boot_params = dt;
+	}
+	unflatten_device_tree();
+}
+
 #endif /* CONFIG_OF_EARLY_FLATTREE */
 
 /* Feed entire flattened device tree into the random pool */
diff --git a/include/linux/of_fdt.h b/include/linux/of_fdt.h
index a478c62..58c28a8 100644
--- a/include/linux/of_fdt.h
+++ b/include/linux/of_fdt.h
@@ -118,9 +118,11 @@ extern int early_init_dt_scan_root(unsigned long node, const char *uname,
 
 /* Other Prototypes */
 extern void unflatten_device_tree(void);
+extern void unflatten_and_copy_device_tree(void);
 extern void early_init_devtree(void *);
 #else /* CONFIG_OF_FLATTREE */
 static inline void unflatten_device_tree(void) {}
+static inline void unflatten_and_copy_device_tree(void) {}
 #endif /* CONFIG_OF_FLATTREE */
 
 #endif /* __ASSEMBLY__ */
-- 
1.8.1.2

