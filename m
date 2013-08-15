Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3HOK6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:58:30 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:54841
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755669Ab3HOK6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:58:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
From: Dong Aisheng <b29396@freescale.com>
To: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 3/3] of: add node status update via name format with cmdline
Date: Thu, 15 Aug 2013 18:55:33 +0800
Message-ID: <1376564133-11286-4-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1376564133-11286-1-git-send-email-b29396@freescale.com>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The node full patch is a bit long to use in the command line to
update the device node status, so we add a more convenient way to
simply use device node name in device tree.

e.g:
formerly:
fdt.enable=/soc/aips-bus@02100000/i2c@021a8000,/soc/aips-bus@02100000/weim@021b8000
fdt.disable=/soc/aips-bus@02100000/weim@021b8000
now:
fdt.enable=i2c@021a8000,weim@021b8000
fdt.disable=weim@021b8000

Signed-off-by: Dong Aisheng <b29396@freescale.com>
---
 Documentation/kernel-parameters.txt |    3 +-
 drivers/of/base.c                   |   33 +++++++++++++++++
 drivers/of/fdt.c                    |   66 ++++++++++++++++++++++++++++------
 include/linux/of.h                  |    8 ++++
 4 files changed, 97 insertions(+), 13 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 65f3be2..7fbdb86 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -900,10 +900,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	fdt.disable=
 			[KNL,FDT]
 			update device tree node status before populating devices
-			Format: fdt.<enable|disable>=<path>[,<path>]
+			Format: fdt.<enable|disable>=<path|node>[,<path|node>]
 			enable    := update the device node to a enabled state
 			disable   := update the device node to a disabled state
 			<path>    := node path or node full name in device tree
+			<node>	  := node name in device tree
 
 	floppy=		[HW]
 			See Documentation/blockdev/floppy.txt.
diff --git a/drivers/of/base.c b/drivers/of/base.c
index f944a54..b072722 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -20,6 +20,7 @@
 #include <linux/ctype.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/proc_fs.h>
@@ -514,6 +515,38 @@ struct device_node *of_find_node_by_name(struct device_node *from,
 EXPORT_SYMBOL(of_find_node_by_name);
 
 /**
+ *	of_find_node_by_name_and_reg - Find a node by its "name" and "reg" property
+ *	@from:	The node to start searching from or NULL, the node
+ *		you pass will not be searched, only the next one
+ *		will; typically, you pass what the previous call
+ *		returned. of_node_put() will be called on it
+ *	@name:	The name string to match against
+ *	@reg:	The reg address to match against
+ *
+ *	Returns a node pointer with refcount incremented, use
+ *	of_node_put() on it when done.
+ */
+struct device_node *of_find_node_by_name_and_reg(struct device_node *from,
+	const char *name, resource_size_t reg)
+{
+	struct device_node *np;
+	struct resource res;
+
+	while ((np = of_find_node_by_name(from, name)) != NULL) {
+		if (!of_address_to_resource(np, 0, &res))
+			if ((res.start == reg) && of_node_get(np)) {
+				pr_debug("find node %s 0x%x: %s\n", name,
+						reg, np->full_name);
+				break;
+			}
+		from = np;
+	}
+
+	return np;
+}
+EXPORT_SYMBOL(of_find_node_by_name_and_reg);
+
+/**
  *	of_find_node_by_type - Find a node by its "device_type" property
  *	@from:	The node to start searching from, or NULL to start searching
  *		the entire device tree. The node you pass will not be
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 423624b..27ad6ae 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -718,21 +718,52 @@ void __init unflatten_device_tree(void)
 	of_alias_scan(early_init_dt_alloc_memory_arch);
 }
 
+static int of_flat_update_node_by_name(const char *s, bool enable)
+{
+	char node[256];
+	char *r, *p;
+	struct device_node *np;
+	unsigned long reg;
+
+	if (!s)
+		return -EINVAL;
+
+	p = strchr(s, '@');
+	strncpy(node, s, p - s);
+	node[p - s] = '\0';
+	r = p + 1;
+	if (kstrtoul(r, 16, &reg))
+		return -EINVAL;
+
+	np = of_find_node_by_name_and_reg(NULL, node, reg);
+	if (!np) {
+		pr_debug("%s: unable to find node %s\n", __func__, s);
+		return -ENODEV;
+	}
+
+	return enable ? of_node_status_enable(np) :
+			of_node_status_disable(np);
+}
+
 /*
  * The format for the command line is as follows:
  *
- * fdt.<enable|disable>=<path>[,<path>]
+ * fdt.<enable|disable>=<path|node>[,<path|node>]
  * enable    := update the device node to a enabled state
  * disable   := update the device node to a disabled state
  * <path>    := node path or node full name in device tree
+ * <node>    := node name in device tree
  *
  * e.g:
  *	fdt.enable=/soc/aips-bus@02100000/i2c@021a8000,/soc/aips-bus@02100000/weim@021b8000
  *	fdt.disable=/soc/aips-bus@02100000/weim@021b8000
+ *	or
+ *	fdt.enable=i2c@021a8000,weim@021b8000
+ *	fdt.disable=weim@021b8000
  */
 static int __init __of_flat_parse_param(char *s, bool enable)
 {
-	char path[256], *p;
+	char node[256], *p;
 
 	if (!s)
 		return 0;
@@ -742,20 +773,31 @@ static int __init __of_flat_parse_param(char *s, bool enable)
 		p = strchr(s, ',');
 		if (p != NULL) {
 			BUG_ON((p - s) >= 256);
-			strncpy(path, s, p - s);
-			path[p - s] = '\0';
-			if (enable)
-				of_node_status_enable_by_path(path);
-			else
-				of_node_status_disable_by_path(path);
+			strncpy(node, s, p - s);
+			node[p - s] = '\0';
+			if (*s != '/') {
+				/* device tree node name */
+				of_flat_update_node_by_name(node, enable);
+			} else {
+				/* device tree node full path*/
+				if (enable)
+					of_node_status_enable_by_path(node);
+				else
+					of_node_status_disable_by_path(node);
+			}
+
 			/* search for next node */
 			s = p + 1;
 		} else {
 			/* last node */
-			if (enable)
-				of_node_status_enable_by_path(s);
-			else
-				of_node_status_disable_by_path(s);
+			if (*s != '/') {
+				of_flat_update_node_by_name(s, enable);
+			} else {
+				if (enable)
+					of_node_status_enable_by_path(s);
+				else
+					of_node_status_disable_by_path(s);
+			}
 			break;
 		}
 	}
diff --git a/include/linux/of.h b/include/linux/of.h
index 61b35fe..7dd3da0 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -170,6 +170,8 @@ extern struct device_node *of_find_node_by_name(struct device_node *from,
 #define for_each_node_by_name(dn, name) \
 	for (dn = of_find_node_by_name(NULL, name); dn; \
 	     dn = of_find_node_by_name(dn, name))
+extern struct device_node *of_find_node_by_name_and_reg(struct device_node *from,
+	const char *name, resource_size_t reg);
 extern struct device_node *of_find_node_by_type(struct device_node *from,
 	const char *type);
 #define for_each_node_by_type(dn, type) \
@@ -361,6 +363,12 @@ static inline struct device_node *of_find_node_by_name(struct device_node *from,
 	return NULL;
 }
 
+static inline struct device_node *of_find_node_by_name_and_reg(
+	struct device_node *from, const char *name, resource_size_t reg)
+{
+	return NULL;
+}
+
 static inline struct device_node *of_get_parent(const struct device_node *node)
 {
 	return NULL;
-- 
1.7.1


