Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3CULZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 07:25:07 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:58431 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757309Ab3CULZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 07:25:03 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>, davem@davemloft.net,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH V2 1/2] of: Make device nodes kobjects so they show up in sysfs
Date: Thu, 21 Mar 2013 11:24:56 +0000
Message-Id: <1363865097-32764-2-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
References: <1363865097-32764-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device tree nodes are already treated as objects, and we already want to
expose them to userspace which is done using the /proc filesystem today.
Right now the kernel has to do a lot of work to keep the /proc view in
sync with the in-kernel representation. If device_nodes are switched to
be kobjects then the device tree code can be a whole lot simpler. It
also turns out that switching to using /sysfs from /proc results in
smaller code and data size, and the userspace ABI won't change if
/proc/device-tree symlinks to /sys/device-tree

v2: switch to using sysfs bin_attributes which solve the problem of
    reporting incorrect property size.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David S. Miller <davem@davemloft.net>
---
 Documentation/ABI/testing/sysfs-firmware-ofw   |   28 ++++++
 arch/arm/boot/dts/testcases/tests-phandle.dtsi |    1 +
 drivers/of/Kconfig                             |    2 +-
 drivers/of/base.c                              |  116 ++++++++++++++++++++++--
 drivers/of/fdt.c                               |    3 +-
 drivers/of/pdt.c                               |    4 +-
 include/linux/of.h                             |    9 +-
 7 files changed, 150 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-ofw

diff --git a/Documentation/ABI/testing/sysfs-firmware-ofw b/Documentation/ABI/testing/sysfs-firmware-ofw
new file mode 100644
index 0000000..5ef9a77
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-ofw
@@ -0,0 +1,28 @@
+What:		/sys/firmware/ofw/../device-tree/
+Date:		March 2013
+Contact:	Grant Likely <grant.likely@secretlab.ca>
+Description:
+		When using OpenFirmware or a Flattened Device Tree to enumerate
+		hardware, the device tree structure will be exposed in this
+		directory.
+
+		It is possible for multiple device-tree directories to exist.
+		Some device drivers use a separate detached device tree which
+		have no attachment to the system tree and will appear in a
+		different subdirectory under /sys/firmware/ofw.
+
+		Userspace must not use the /sys/firmware/ofw/../device-tree
+		path directly, but instead should follow /proc/device-tree
+		symlink. It is possible that the absolute path will change
+		in the future, but the symlink is the stable ABI.
+
+		The /proc/device-tree symlink replaces the devicetree /proc
+		filesystem support, and has largely the same semantics and
+		should be compatible with existing userspace.
+
+		The contents of /sys/firmware/ofw/../device-tree is a
+		hierarchy of directories, one per device tree node. The
+		directory name is the resolved path component name (node
+		name plus address). Properties are represented as files
+		in the directory. The contents of each file is the exact
+		binary data from the device tree.
diff --git a/arch/arm/boot/dts/testcases/tests-phandle.dtsi b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
index 0007d3c..4399244 100644
--- a/arch/arm/boot/dts/testcases/tests-phandle.dtsi
+++ b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
@@ -1,6 +1,7 @@
 
 / {
 	testcase-data {
+		security-password = "password";
 		phandle-tests {
 			provider0: provider0 {
 				#phandle-cells = <0>;
diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
index d37bfcf..d2d7be9 100644
--- a/drivers/of/Kconfig
+++ b/drivers/of/Kconfig
@@ -38,7 +38,7 @@ config OF_PROMTREE
 # Hardly any platforms need this.  It is safe to select, but only do so if you
 # need it.
 config OF_DYNAMIC
-	bool
+	def_bool y
 
 config OF_ADDRESS
 	def_bool y
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..f1298cf 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -22,6 +22,7 @@
 #include <linux/of.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/proc_fs.h>
 
 #include "of_private.h"
@@ -33,6 +34,12 @@ EXPORT_SYMBOL(of_allnodes);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
 
+static struct kset *of_kset;
+
+/*
+ * Used to protect the of_aliases; but also overloaded to hold off addition of
+ * nodes to sysfs
+ */
 DEFINE_MUTEX(of_aliases_mutex);
 
 /* use when traversing tree through the allnext, child, sibling,
@@ -83,14 +90,14 @@ EXPORT_SYMBOL(of_n_size_cells);
 struct device_node *of_node_get(struct device_node *node)
 {
 	if (node)
-		kref_get(&node->kref);
+		kobject_get(&node->kobj);
 	return node;
 }
 EXPORT_SYMBOL(of_node_get);
 
-static inline struct device_node *kref_to_device_node(struct kref *kref)
+static inline struct device_node *kobj_to_device_node(struct kobject *kobj)
 {
-	return container_of(kref, struct device_node, kref);
+	return container_of(kobj, struct device_node, kobj);
 }
 
 /**
@@ -100,16 +107,15 @@ static inline struct device_node *kref_to_device_node(struct kref *kref)
  *	In of_node_put() this function is passed to kref_put()
  *	as the destructor.
  */
-static void of_node_release(struct kref *kref)
+static void of_node_release(struct kobject *kobj)
 {
-	struct device_node *node = kref_to_device_node(kref);
+	struct device_node *node = kobj_to_device_node(kobj);
 	struct property *prop = node->properties;
 
 	/* We should never be releasing nodes that haven't been detached. */
 	if (!of_node_check_flag(node, OF_DETACHED)) {
 		pr_err("ERROR: Bad of_node_put() on %s\n", node->full_name);
 		dump_stack();
-		kref_init(&node->kref);
 		return;
 	}
 
@@ -142,11 +148,105 @@ static void of_node_release(struct kref *kref)
 void of_node_put(struct device_node *node)
 {
 	if (node)
-		kref_put(&node->kref, of_node_release);
+		kobject_put(&node->kobj);
 }
 EXPORT_SYMBOL(of_node_put);
 #endif /* CONFIG_OF_DYNAMIC */
 
+struct kobj_type of_node_ktype = {
+	.release = of_node_release,
+};
+
+static ssize_t of_node_property_read(struct file *filp, struct kobject *kobj,
+				struct bin_attribute *bin_attr, char *buf,
+				loff_t offset, size_t count)
+{
+	struct property *pp = container_of(bin_attr, struct property, attr);
+	return memory_read_from_buffer(buf, count, &offset, pp->value, pp->length);
+}
+
+static bool of_init_complete = false;
+static int __of_node_add(struct device_node *np)
+{
+	const char *name;
+	struct property *pp;
+	static int extra = 0;
+	int rc;
+
+	np->kobj.kset = of_kset;
+	if (!np->parent) {
+		/* Nodes without parents are new top level trees */
+		rc = kobject_add(&np->kobj, NULL, "device-tree-%i", extra++);
+#if !defined(CONFIG_PROC_DEVICETREE)
+		/* Symlink to the new tree when PROC_DEVICETREE is disabled */
+		if (!rc && extra == 1)
+			proc_symlink("device-tree", NULL, "/sys/firmware/ofw/device-tree-0");
+#endif /* CONFIG_PROC_DEVICETREE */
+	} else {
+		name = kbasename(np->full_name);
+		if (!name || !name[0])
+			return -EINVAL;
+		rc = kobject_add(&np->kobj, &np->parent->kobj, "%s", name);
+	}
+	if (rc)
+		return rc;
+
+	for_each_property_of_node(np, pp) {
+		/* Important: Don't leak passwords */
+		bool secure = strncmp(pp->name, "security-", 9) == 0;
+
+		pp->attr.attr.name = pp->name;
+		pp->attr.attr.mode = secure ? S_IRUSR : S_IRUGO;
+		pp->attr.size = secure ? 0 : pp->length;
+		pp->attr.read = of_node_property_read;
+		rc = sysfs_create_bin_file(&np->kobj, &pp->attr);
+		WARN(rc, "error creating device node attribute\n");
+	}
+
+	return 0;
+}
+
+int of_node_add(struct device_node *np)
+{
+	int rc = 0;
+	kobject_init(&np->kobj, &of_node_ktype);
+	mutex_lock(&of_aliases_mutex);
+	if (of_init_complete)
+		rc = __of_node_add(np);
+	mutex_unlock(&of_aliases_mutex);
+	return rc;
+}
+
+#if defined(CONFIG_OF_DYNAMIC)
+static void of_node_remove(struct device_node *np)
+{
+	struct property *pp;
+
+	for_each_property_of_node(np, pp)
+		sysfs_remove_bin_file(&np->kobj, &pp->attr);
+
+	kobject_del(&np->kobj);
+}
+#endif
+
+static int __init of_init(void)
+{
+	struct device_node *np;
+
+	of_kset = kset_create_and_add("ofw", NULL, firmware_kobj);
+	if (!of_kset)
+		return -ENOMEM;
+
+	/* Make sure all nodes added before this time get added to sysfs */
+	mutex_lock(&of_aliases_mutex);
+	for_each_of_allnodes(np)
+		__of_node_add(np);
+	of_init_complete = true;
+	mutex_unlock(&of_aliases_mutex);
+	return 0;
+}
+core_initcall(of_init);
+
 static struct property *__of_find_property(const struct device_node *np,
 					   const char *name, int *lenp)
 {
@@ -1445,6 +1545,7 @@ int of_attach_node(struct device_node *np)
 	of_allnodes = np;
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
+	of_node_add(np);
 	of_add_proc_dt_entry(np);
 	return 0;
 }
@@ -1526,6 +1627,7 @@ int of_detach_node(struct device_node *np)
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	of_remove_proc_dt_entry(np);
+	of_node_remove(np);
 	return rc;
 }
 #endif /* defined(CONFIG_OF_DYNAMIC) */
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 808be06..8807059 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -232,7 +232,6 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 				dad->next->sibling = np;
 			dad->next = np;
 		}
-		kref_init(&np->kref);
 	}
 	/* process properties */
 	while (1) {
@@ -327,6 +326,8 @@ static unsigned long unflatten_dt_node(struct boot_param_header *blob,
 			np->name = "<NULL>";
 		if (!np->type)
 			np->type = "<NULL>";
+
+		of_node_add(np);
 	}
 	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
 		if (tag == OF_DT_NOP)
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 37b56fd..2d9d7e1 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -180,8 +180,6 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 	of_pdt_incr_unique_id(dp);
 	dp->parent = parent;
 
-	kref_init(&dp->kref);
-
 	dp->name = of_pdt_get_one_property(node, "name");
 	dp->type = of_pdt_get_one_property(node, "device_type");
 	dp->phandle = node;
@@ -216,6 +214,7 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
 		*nextp = &dp->allnext;
 
 		dp->full_name = of_pdt_build_full_name(dp);
+		of_node_add(dp);
 
 		dp->child = of_pdt_build_tree(dp,
 				of_pdt_prom_ops->getchild(node), nextp);
@@ -246,6 +245,7 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
 	of_allnodes->path_component_name = "";
 #endif
 	of_allnodes->full_name = "/";
+	of_node_add(of_allnodes);
 
 	nextp = &of_allnodes->allnext;
 	of_allnodes->child = of_pdt_build_tree(of_allnodes,
diff --git a/include/linux/of.h b/include/linux/of.h
index a0f1292..0709a5e 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -18,7 +18,7 @@
 #include <linux/types.h>
 #include <linux/bitops.h>
 #include <linux/errno.h>
-#include <linux/kref.h>
+#include <linux/kobject.h>
 #include <linux/mod_devicetable.h>
 #include <linux/spinlock.h>
 #include <linux/topology.h>
@@ -37,6 +37,7 @@ struct property {
 	struct property *next;
 	unsigned long _flags;
 	unsigned int unique_id;
+	struct bin_attribute attr;
 };
 
 #if defined(CONFIG_SPARC)
@@ -57,7 +58,7 @@ struct device_node {
 	struct	device_node *next;	/* next device of same type */
 	struct	device_node *allnext;	/* next in list of all nodes */
 	struct	proc_dir_entry *pde;	/* this node's proc directory */
-	struct	kref kref;
+	struct	kobject kobj;
 	unsigned long _flags;
 	void	*data;
 #if defined(CONFIG_SPARC)
@@ -74,6 +75,8 @@ struct of_phandle_args {
 	uint32_t args[MAX_PHANDLE_ARGS];
 };
 
+extern int of_node_add(struct device_node *node);
+
 #ifdef CONFIG_OF_DYNAMIC
 extern struct device_node *of_node_get(struct device_node *node);
 extern void of_node_put(struct device_node *node);
@@ -165,6 +168,8 @@ static inline const char *of_node_full_name(const struct device_node *np)
 	return np ? np->full_name : "<no-node>";
 }
 
+#define for_each_of_allnodes(dn) \
+	for (dn = of_allnodes; dn; dn = dn->allnext)
 extern struct device_node *of_find_node_by_name(struct device_node *from,
 	const char *name);
 #define for_each_node_by_name(dn, name) \
-- 
1.7.10.4

