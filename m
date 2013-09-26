Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab3IZSvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:51:39 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57039 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab3IZSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:33 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 14/21] of: implement of_node_to_nid as a weak function
Date: Thu, 26 Sep 2013 13:50:49 -0500
Message-Id: <1380221456-11192-15-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Implement of_node_to_nid as weak function to remove the dependency on
asm/prom.h. This is in preparation to make prom.h optional.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
---
 arch/powerpc/include/asm/prom.h |  7 -------
 arch/sparc/include/asm/prom.h   |  4 ----
 drivers/of/base.c               |  7 +++++++
 include/linux/of.h              | 11 ++++-------
 4 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index bd215f7..6707c16 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -42,13 +42,6 @@ extern void kdump_move_device_tree(void);
 /* cache lookup */
 struct device_node *of_find_next_cache_node(struct device_node *np);
 
-#ifdef CONFIG_NUMA
-extern int of_node_to_nid(struct device_node *device);
-#else
-static inline int of_node_to_nid(struct device_node *device) { return 0; }
-#endif
-#define of_node_to_nid of_node_to_nid
-
 extern void of_instantiate_rtc(void);
 
 extern int of_get_ibm_chip_id(struct device_node *np);
diff --git a/arch/sparc/include/asm/prom.h b/arch/sparc/include/asm/prom.h
index 67c6257..60c8d7b 100644
--- a/arch/sparc/include/asm/prom.h
+++ b/arch/sparc/include/asm/prom.h
@@ -43,10 +43,6 @@ extern int of_getintprop_default(struct device_node *np,
 				 const char *name,
 				 int def);
 extern int of_find_in_proplist(const char *list, const char *match, int len);
-#ifdef CONFIG_NUMA
-extern int of_node_to_nid(struct device_node *dp);
-#define of_node_to_nid of_node_to_nid
-#endif
 
 extern void prom_build_devicetree(void);
 extern void of_populate_present_mask(void);
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 865d3f6..ced4c06 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -74,6 +74,13 @@ int of_n_size_cells(struct device_node *np)
 }
 EXPORT_SYMBOL(of_n_size_cells);
 
+#ifdef CONFIG_NUMA
+int __weak of_node_to_nid(struct device_node *np)
+{
+	return numa_node_id();
+}
+#endif
+
 #if defined(CONFIG_OF_DYNAMIC)
 /**
  *	of_node_get - Increment refcount of a node
diff --git a/include/linux/of.h b/include/linux/of.h
index f95aee3..4d294a0 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -534,13 +534,10 @@ static inline const char *of_prop_next_string(struct property *prop,
 #define of_match_node(_matches, _node)	NULL
 #endif /* CONFIG_OF */
 
-#ifndef of_node_to_nid
-static inline int of_node_to_nid(struct device_node *np)
-{
-	return numa_node_id();
-}
-
-#define of_node_to_nid of_node_to_nid
+#if defined(CONFIG_OF) && defined(CONFIG_NUMA)
+extern int of_node_to_nid(struct device_node *np);
+#else
+static inline int of_node_to_nid(struct device_node *device) { return 0; }
 #endif
 
 /**
-- 
1.8.1.2

