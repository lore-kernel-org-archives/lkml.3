Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbaC1QIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:08:47 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:46093 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270AbaC1QIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:08:17 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, benh@kernel.crashing.org,
        rob.herring@linaro.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [RFC 2/5] of: Create of_console_check() for selecting a console specified in /chosen
Date: Fri, 28 Mar 2014 09:08:02 -0700
Message-Id: <1396022885-6102-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The devicetree has a binding for specifying the console device in the
/chosen node, but the kernel doesn't use it consistently. This change
adds an API for testing if a device node is a console, and adds a
preferred console entry if it is.

At the same time this patch removes the of_device_is_stdout_path() API
since it is unused.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/of/base.c  | 23 +++++++++++++----------
 include/linux/of.h |  6 +++---
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index be2861d69b02..a5643badeb1d 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -17,6 +17,7 @@
  *      as published by the Free Software Foundation; either version
  *      2 of the License, or (at your option) any later version.
  */
+#include <linux/console.h>
 #include <linux/ctype.h>
 #include <linux/cpu.h>
 #include <linux/module.h>
@@ -2073,20 +2074,22 @@ const char *of_prop_next_string(struct property *prop, const char *cur)
 EXPORT_SYMBOL_GPL(of_prop_next_string);
 
 /**
- * of_device_is_stdout_path - check if a device node matches the
- *                            linux,stdout-path property
- *
- * Check if this device node matches the linux,stdout-path property
- * in the chosen node. return true if yes, false otherwise.
+ * of_console_check() - Test and setup console for DT setup
+ * @dn - Pointer to device node
+ * @name - Name to use for preferred console without index. ex. "ttyS"
+ * @index - Index to use for preferred console.
+ *
+ * Check if the given device node matches the stdout-path property in the
+ * /chosen node. If it does then register it as the preferred console and return
+ * TRUE. Otherwise return FALSE.
  */
-int of_device_is_stdout_path(struct device_node *dn)
+bool of_console_check(struct device_node *dn, char *name, int index)
 {
-	if (!of_stdout)
+	if (!dn || dn != of_stdout || console_set_on_cmdline)
 		return false;
-
-	return of_stdout == dn;
+	return add_preferred_console(name, index, NULL);
 }
-EXPORT_SYMBOL_GPL(of_device_is_stdout_path);
+EXPORT_SYMBOL_GPL(of_console_check);
 
 /**
  *	of_find_next_cache_node - Find a node's subsidiary cache
diff --git a/include/linux/of.h b/include/linux/of.h
index a8b9dad90c64..417945ebd8e1 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -343,7 +343,7 @@ const __be32 *of_prop_next_u32(struct property *prop, const __be32 *cur,
  */
 const char *of_prop_next_string(struct property *prop, const char *cur);
 
-int of_device_is_stdout_path(struct device_node *dn);
+bool of_console_check(struct device_node *dn, char *name, int index);
 
 #else /* CONFIG_OF */
 
@@ -544,9 +544,9 @@ static inline int of_machine_is_compatible(const char *compat)
 	return 0;
 }
 
-static inline int of_device_is_stdout_path(struct device_node *dn)
+static bool of_console_check(const struct device_node *dn, const char *name, int index)
 {
-	return 0;
+	return false;
 }
 
 static inline const __be32 *of_prop_next_u32(struct property *prop,
-- 
1.8.3.2

