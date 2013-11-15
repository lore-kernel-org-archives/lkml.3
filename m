Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab3KOTIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:08:11 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57485 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3KOTHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:07:11 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH v5 1/3] of: Make device nodes kobjects so they show up in sysfs
Date: Fri, 15 Nov 2013 17:46:42 +0000
Message-Id: <1384537604-5032-2-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1384537604-5032-1-git-send-email-grant.likely@linaro.org>
References: <1384537604-5032-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

Device tree nodes are already treated as objects, and we already want to
expose them to userspace which is done using the /proc filesystem today.
Right now the kernel has to do a lot of work to keep the /proc view in
sync with the in-kernel representation. If device_nodes are switched to
be kobjects then the device tree code can be a whole lot simpler. It
also turns out that switching to using /sysfs from /proc results in
smaller code and data size, and the userspace ABI won't change if
/proc/device-tree symlinks to /sys/firmware/devicetree/base.

v5: Rename firmware/ofw to firmware/devicetree
    Fix updating property values in sysfs
v4: Fixed build error on Powerpc
    Fixed handling of dynamic nodes on powerpc
v3: Fixed handling of duplicate attribute and child node names
v2: switch to using sysfs bin_attributes which solve the problem of
    reporting incorrect property size.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 Documentation/ABI/testing/sysfs-firmware-ofw   |  28 +++++
 arch/arm/boot/dts/testcases/tests-phandle.dtsi |   3 +
 arch/powerpc/platforms/pseries/dlpar.c         |   1 -
 arch/powerpc/platforms/pseries/reconfig.c      |   2 -
 arch/powerpc/sysdev/msi_bitmap.c               |   2 +-
 drivers/of/base.c                              | 157 +++++++++++++++++++++++--
 drivers/of/fdt.c                               |   3 +-
 drivers/of/pdt.c                               |   4 +-
 include/linux/of.h                             |   9 +-
 9 files changed, 193 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-ofw

diff --git a/Documentation/ABI/testing/sysfs-firmware-ofw b/Documentation/ABI/testing/sysfs-firmware-ofw
new file mode 100644
index 000000000000..f562b188e71d
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-ofw
@@ -0,0 +1,28 @@
+What:		/sys/firmware/devicetree/*
+Date:		November 2013
+Contact:	Grant Likely <grant.likely@linaro.org>
+Description:
+		When using OpenFirmware or a Flattened Device Tree to enumerate
+		hardware, the device tree structure will be exposed in this
+		directory.
+
+		It is possible for multiple device-tree directories to exist.
+		Some device drivers use a separate detached device tree which
+		have no attachment to the system tree and will appear in a
+		different subdirectory under /sys/firmware/devicetree.
+
+		Userspace must not use the /sys/firmware/devicetree/base
+		path directly, but instead should follow /proc/device-tree
+		symlink. It is possible that the absolute path will change
+		in the future, but the symlink is the stable ABI.
+
+		The /proc/device-tree symlink replaces the devicetree /proc
+		filesystem support, and has largely the same semantics and
+		should be compatible with existing userspace.
+
+		The contents of /sys/firmware/devicetree/ is a
+		hierarchy of directories, one per device tree node. The
+		directory name is the resolved path component name (node
+		name plus address). Properties are represented as files
+		in the directory. The contents of each file is the exact
+		binary data from the device tree.
diff --git a/arch/arm/boot/dts/testcases/tests-phandle.dtsi b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
index 0007d3cd7dc2..788a4c24b8f5 100644
--- a/arch/arm/boot/dts/testcases/tests-phandle.dtsi
+++ b/arch/arm/boot/dts/testcases/tests-phandle.dtsi
@@ -1,6 +1,9 @@
 
 / {
 	testcase-data {
+		security-password = "password";
+		duplicate-name = "duplicate";
+		duplicate-name { };
 		phandle-tests {
 			provider0: provider0 {
 				#phandle-cells = <0>;
diff --git a/arch/powerpc/platforms/pseries/dlpar.c b/arch/powerpc/platforms/pseries/dlpar.c
index a8fe5aa3d34f..397661de19ec 100644
--- a/arch/powerpc/platforms/pseries/dlpar.c
+++ b/arch/powerpc/platforms/pseries/dlpar.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kref.h>
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
 #include <linux/cpu.h>
diff --git a/arch/powerpc/platforms/pseries/reconfig.c b/arch/powerpc/platforms/pseries/reconfig.c
index f93cdf55628c..0435bb65d0aa 100644
--- a/arch/powerpc/platforms/pseries/reconfig.c
+++ b/arch/powerpc/platforms/pseries/reconfig.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/kref.h>
 #include <linux/notifier.h>
 #include <linux/proc_fs.h>
 #include <linux/slab.h>
@@ -70,7 +69,6 @@ static int pSeries_reconfig_add_node(const char *path, struct property *proplist
 
 	np->properties = proplist;
 	of_node_set_flag(np, OF_DYNAMIC);
-	kref_init(&np->kref);
 
 	np->parent = derive_parent(path);
 	if (IS_ERR(np->parent)) {
diff --git a/arch/powerpc/sysdev/msi_bitmap.c b/arch/powerpc/sysdev/msi_bitmap.c
index 0968b66b4cf9..8ba60424be95 100644
--- a/arch/powerpc/sysdev/msi_bitmap.c
+++ b/arch/powerpc/sysdev/msi_bitmap.c
@@ -202,7 +202,7 @@ void __init test_of_node(void)
 
 	/* There should really be a struct device_node allocator */
 	memset(&of_node, 0, sizeof(of_node));
-	kref_init(&of_node.kref);
+	kref_init(&of_node.kobj.kref);
 	of_node.full_name = node_name;
 
 	check(0 == msi_bitmap_alloc(&bmp, size, &of_node));
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 967b3209907a..efcfead5ba2d 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <linux/proc_fs.h>
 
 #include "of_private.h"
@@ -35,6 +36,12 @@ struct device_node *of_chosen;
 struct device_node *of_aliases;
 static struct device_node *of_stdout;
 
+static struct kset *of_kset;
+
+/*
+ * Used to protect the of_aliases; but also overloaded to hold off addition of
+ * nodes to sysfs
+ */
 DEFINE_MUTEX(of_aliases_mutex);
 
 /* use when traversing tree through the allnext, child, sibling,
@@ -92,14 +99,14 @@ int __weak of_node_to_nid(struct device_node *np)
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
@@ -109,16 +116,15 @@ static inline struct device_node *kref_to_device_node(struct kref *kref)
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
 
@@ -151,11 +157,138 @@ static void of_node_release(struct kref *kref)
 void of_node_put(struct device_node *node)
 {
 	if (node)
-		kref_put(&node->kref, of_node_release);
+		kobject_put(&node->kobj);
 }
 EXPORT_SYMBOL(of_node_put);
+#else
+static void of_node_release(struct kobject *kobj)
+{
+	/* Without CONFIG_OF_DYNAMIC, no nodes gets freed */
+}
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
+static const char *safe_name(struct kobject *kobj, const char *orig_name)
+{
+	const char *name = orig_name;
+	struct sysfs_dirent *sd;
+	int i = 0;
+
+	/* don't be a hero. After 16 tries give up */
+	while (i < 16 && (sd = sysfs_get_dirent(kobj->sd, name))) {
+		sysfs_put(sd);
+		if (name != orig_name)
+			kfree(name);
+		name = kasprintf(GFP_KERNEL, "%s#%i", orig_name, ++i);
+	}
+
+	if (name != orig_name)
+		pr_warn("device-tree: Duplicate name in %s, renamed to \"%s\"\n",
+			kobject_name(kobj), name);
+	return name;
+}
+
+static int __of_add_property(struct device_node *np, struct property *pp)
+{
+	int rc;
+
+	/* Important: Don't leak passwords */
+	bool secure = strncmp(pp->name, "security-", 9) == 0;
+
+	pp->attr.attr.name = safe_name(&np->kobj, pp->name);
+	pp->attr.attr.mode = secure ? S_IRUSR : S_IRUGO;
+	pp->attr.size = secure ? 0 : pp->length;
+	pp->attr.read = of_node_property_read;
+
+	rc = sysfs_create_bin_file(&np->kobj, &pp->attr);
+	WARN(rc, "error adding attribute %s to node %s\n", pp->name, np->full_name);
+	return rc;
+}
+
+static int __of_node_add(struct device_node *np)
+{
+	const char *name;
+	struct property *pp;
+	int rc;
+
+	np->kobj.kset = of_kset;
+	if (!np->parent) {
+		/* Nodes without parents are new top level trees */
+		rc = kobject_add(&np->kobj, NULL, safe_name(&of_kset->kobj, "base"));
+	} else {
+		name = safe_name(&np->parent->kobj, kbasename(np->full_name));
+		if (!name || !name[0])
+			return -EINVAL;
+
+		rc = kobject_add(&np->kobj, &np->parent->kobj, "%s", name);
+	}
+	if (rc)
+		return rc;
+
+	for_each_property_of_node(np, pp)
+		__of_add_property(np, pp);
+
+	return 0;
+}
+
+int of_node_add(struct device_node *np)
+{
+	int rc = 0;
+	kobject_init(&np->kobj, &of_node_ktype);
+	mutex_lock(&of_aliases_mutex);
+	if (of_kset)
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
+	of_kset = kset_create_and_add("devicetree", NULL, firmware_kobj);
+	if (!of_kset)
+		return -ENOMEM;
+
+	/* Make sure all nodes added before this time get added to sysfs */
+	mutex_lock(&of_aliases_mutex);
+	for_each_of_allnodes(np)
+		__of_node_add(np);
+	mutex_unlock(&of_aliases_mutex);
+
+#if !defined(CONFIG_PROC_DEVICETREE)
+	/* Symlink to the new tree when PROC_DEVICETREE is disabled */
+	if (of_allnodes)
+		proc_symlink("device-tree", NULL, "/sys/firmware/devicetree/base");
+#endif /* CONFIG_PROC_DEVICETREE */
+
+	return 0;
+}
+core_initcall(of_init);
+
 static struct property *__of_find_property(const struct device_node *np,
 					   const char *name, int *lenp)
 {
@@ -1495,6 +1628,8 @@ int of_add_property(struct device_node *np, struct property *prop)
 	*next = prop;
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
+	__of_add_property(np, prop);
+
 #ifdef CONFIG_PROC_DEVICETREE
 	/* try to add to proc as well if it was initialized */
 	if (np->pde)
@@ -1541,6 +1676,8 @@ int of_remove_property(struct device_node *np, struct property *prop)
 	if (!found)
 		return -ENODEV;
 
+	sysfs_remove_bin_file(&np->kobj, &prop->attr);
+
 #ifdef CONFIG_PROC_DEVICETREE
 	/* try to remove the proc node as well */
 	if (np->pde)
@@ -1595,6 +1732,10 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	if (!found)
 		return -ENODEV;
 
+	/* Update the sysfs attribute */
+	sysfs_remove_bin_file(&np->kobj, &oldprop->attr);
+	__of_add_property(np, newprop);
+
 #ifdef CONFIG_PROC_DEVICETREE
 	/* try to add to proc as well if it was initialized */
 	if (np->pde)
@@ -1671,6 +1812,7 @@ int of_attach_node(struct device_node *np)
 	of_node_clear_flag(np, OF_DETACHED);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
+	of_node_add(np);
 	of_add_proc_dt_entry(np);
 	return 0;
 }
@@ -1743,6 +1885,7 @@ int of_detach_node(struct device_node *np)
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	of_remove_proc_dt_entry(np);
+	of_node_remove(np);
 	return rc;
 }
 #endif /* defined(CONFIG_OF_DYNAMIC) */
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index 2fa024b97c43..d5d62cd5680f 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -232,7 +232,6 @@ static void * unflatten_dt_node(struct boot_param_header *blob,
 				dad->next->sibling = np;
 			dad->next = np;
 		}
-		kref_init(&np->kref);
 	}
 	/* process properties */
 	while (1) {
@@ -327,6 +326,8 @@ static void * unflatten_dt_node(struct boot_param_header *blob,
 			np->name = "<NULL>";
 		if (!np->type)
 			np->type = "<NULL>";
+
+		of_node_add(np);
 	}
 	while (tag == OF_DT_BEGIN_NODE || tag == OF_DT_NOP) {
 		if (tag == OF_DT_NOP)
diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 7b666736c168..e64fa3d3da5f 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -179,8 +179,6 @@ static struct device_node * __init of_pdt_create_node(phandle node,
 	of_pdt_incr_unique_id(dp);
 	dp->parent = parent;
 
-	kref_init(&dp->kref);
-
 	dp->name = of_pdt_get_one_property(node, "name");
 	dp->type = of_pdt_get_one_property(node, "device_type");
 	dp->phandle = node;
@@ -215,6 +213,7 @@ static struct device_node * __init of_pdt_build_tree(struct device_node *parent,
 		*nextp = &dp->allnext;
 
 		dp->full_name = of_pdt_build_full_name(dp);
+		of_node_add(dp);
 
 		dp->child = of_pdt_build_tree(dp,
 				of_pdt_prom_ops->getchild(node), nextp);
@@ -245,6 +244,7 @@ void __init of_pdt_build_devicetree(phandle root_node, struct of_pdt_ops *ops)
 	of_allnodes->path_component_name = "";
 #endif
 	of_allnodes->full_name = "/";
+	of_node_add(of_allnodes);
 
 	nextp = &of_allnodes->allnext;
 	of_allnodes->child = of_pdt_build_tree(of_allnodes,
diff --git a/include/linux/of.h b/include/linux/of.h
index a4b7fdf17044..c899a89de9a8 100644
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
@@ -187,6 +190,8 @@ static inline const char *of_node_full_name(const struct device_node *np)
 	return np ? np->full_name : "<no-node>";
 }
 
+#define for_each_of_allnodes(dn) \
+	for (dn = of_allnodes; dn; dn = dn->allnext)
 extern struct device_node *of_find_node_by_name(struct device_node *from,
 	const char *name);
 #define for_each_node_by_name(dn, name) \
-- 
1.8.3.2

