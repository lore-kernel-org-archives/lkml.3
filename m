Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbaFRUzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:55:00 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:64978 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbaFRUy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:54:57 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org,
        olof@lixom.net, benh@kernel.crashing.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 1/4] of: Create of_console_check() for selecting a console specified in /chosen
Date: Wed, 18 Jun 2014 21:54:31 +0100
Message-Id: <1403124874-19929-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403124874-19929-1-git-send-email-grant.likely@linaro.org>
References: <1403124874-19929-1-git-send-email-grant.likely@linaro.org>
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
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/of/base.c  | 23 +++++++++++++----------
 include/linux/of.h |  6 +++---
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 8368d96ae7b4..ed037ae7eefe 100644
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
@@ -2179,20 +2180,22 @@ const char *of_prop_next_string(struct property *prop, const char *cur)
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
index 196b34c1ef4e..9d9734056e39 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -352,7 +352,7 @@ const __be32 *of_prop_next_u32(struct property *prop, const __be32 *cur,
  */
 const char *of_prop_next_string(struct property *prop, const char *cur);
 
-int of_device_is_stdout_path(struct device_node *dn);
+bool of_console_check(struct device_node *dn, char *name, int index);
 
 #else /* CONFIG_OF */
 
@@ -564,9 +564,9 @@ static inline int of_machine_is_compatible(const char *compat)
 	return 0;
 }
 
-static inline int of_device_is_stdout_path(struct device_node *dn)
+static inline bool of_console_check(const struct device_node *dn, const char *name, int index)
 {
-	return 0;
+	return false;
 }
 
 static inline const __be32 *of_prop_next_u32(struct property *prop,
-- 
1.9.1

