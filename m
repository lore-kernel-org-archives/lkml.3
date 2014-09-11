Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaIKP5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:57:00 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49282 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756509AbaIKPti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:49:38 -0400
From: mathieu.poirier@linaro.org
To: will.deacon@arm.com, linux@arm.linux.org.uk, gregkh@linuxfoundation.org
Cc: pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, kaixu.xia@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dsaxena@linaro.org, mathieu.poirier@linaro.org
Subject: [PATCH 01/11 v6] coresight: add CoreSight core layer framework
Date: Thu, 11 Sep 2014 09:49:08 -0600
Message-Id: <1410450558-12358-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
References: <1410450558-12358-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

CoreSight components are compliant with the ARM CoreSight
architecture specification and can be connected in various
topologies to suit a particular SoC tracing needs. These trace
components can generally be classified as sources, links and
sinks. Trace data produced by one or more sources flows through
the intermediate links connecting the source to the currently
selected sink.

The CoreSight framework provides an interface for the CoreSight trace
drivers to register themselves with. It's intended to build up a
topological view of the CoreSight components and configure the
correct serie of components on user input via debugfs.

For eg., when enabling a source, the framework builds up a path
consisting of all the components connecting the source to the
currently selected sink(s) and enables all of them.

The framework also supports switching between available sinks
and provides status information to user space applications
through the debugfs interface.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 arch/arm/Kconfig.debug             |   9 +
 drivers/Makefile                   |   1 +
 drivers/amba/bus.c                 |   2 +-
 drivers/coresight/Makefile         |   5 +
 drivers/coresight/coresight-priv.h |  63 ++++
 drivers/coresight/coresight.c      | 663 +++++++++++++++++++++++++++++++++++++
 drivers/coresight/of_coresight.c   | 201 +++++++++++
 include/linux/amba/bus.h           |   1 +
 include/linux/coresight.h          | 275 +++++++++++++++
 9 files changed, 1219 insertions(+), 1 deletion(-)
 create mode 100644 drivers/coresight/Makefile
 create mode 100644 drivers/coresight/coresight-priv.h
 create mode 100644 drivers/coresight/coresight.c
 create mode 100644 drivers/coresight/of_coresight.c
 create mode 100644 include/linux/coresight.h

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 8f90595..c04d0d9 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1257,4 +1257,13 @@ config DEBUG_SET_MODULE_RONX
 	  against certain classes of kernel exploits.
 	  If in doubt, say "N".
 
+menuconfig CORESIGHT
+	bool "CoreSight Tracing Support"
+	select ARM_AMBA
+	help
+	  This framework provides a kernel interface for the CoreSight debug
+	  and trace drivers to register themselves with. It's intended to build
+	  a topological view of the CoreSight components based on a DT
+	  specification and configure the right serie of components when a
+	  trace source gets enabled.
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index f98b50d..fb58a94 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -158,3 +158,4 @@ obj-$(CONFIG_NTB)		+= ntb/
 obj-$(CONFIG_FMC)		+= fmc/
 obj-$(CONFIG_POWERCAP)		+= powercap/
 obj-$(CONFIG_MCB)		+= mcb/
+obj-$(CONFIG_CORESIGHT)		+= coresight/
diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
index 3cf61a1..131258b 100644
--- a/drivers/amba/bus.c
+++ b/drivers/amba/bus.c
@@ -327,7 +327,7 @@ int amba_device_add(struct amba_device *dev, struct resource *parent)
 
 		amba_put_disable_pclk(dev);
 
-		if (cid == AMBA_CID)
+		if (cid == AMBA_CID || cid == CORESIGHT_CID)
 			dev->periphid = pid;
 
 		if (!dev->periphid)
diff --git a/drivers/coresight/Makefile b/drivers/coresight/Makefile
new file mode 100644
index 0000000..218e3b5
--- /dev/null
+++ b/drivers/coresight/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for CoreSight drivers.
+#
+obj-$(CONFIG_CORESIGHT) += coresight.o
+obj-$(CONFIG_OF) += of_coresight.o
diff --git a/drivers/coresight/coresight-priv.h b/drivers/coresight/coresight-priv.h
new file mode 100644
index 0000000..83172c4
--- /dev/null
+++ b/drivers/coresight/coresight-priv.h
@@ -0,0 +1,63 @@
+/* Copyright (c) 2011-2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _CORESIGHT_PRIV_H
+#define _CORESIGHT_PRIV_H
+
+#include <linux/bitops.h>
+#include <linux/io.h>
+#include <linux/coresight.h>
+
+/*
+ * Coresight management registers (0xf00-0xfcc)
+ * 0xfa0 - 0xfa4: Management	registers in PFTv1.0
+ *		  Trace		registers in PFTv1.1
+ */
+#define CORESIGHT_ITCTRL	0xf00
+#define CORESIGHT_CLAIMSET	0xfa0
+#define CORESIGHT_CLAIMCLR	0xfa4
+#define CORESIGHT_LAR		0xfb0
+#define CORESIGHT_LSR		0xfb4
+#define CORESIGHT_AUTHSTATUS	0xfb8
+#define CORESIGHT_DEVID		0xfc8
+#define CORESIGHT_DEVTYPE	0xfcc
+
+#define TIMEOUT_US		100
+#define BMVAL(val, lsb, msb)	((val & GENMASK(msb, lsb)) >> lsb)
+
+static inline void CS_LOCK(void __iomem *addr)
+{
+	do {
+		/* wait for things to settle */
+		mb();
+		writel_relaxed(0x0, addr + CORESIGHT_LAR);
+	} while (0);
+}
+
+static inline void CS_UNLOCK(void __iomem *addr)
+{
+	do {
+		writel_relaxed(CORESIGHT_UNLOCK, addr + CORESIGHT_LAR);
+		/* make sure eveyone has seen this */
+		mb();
+	} while (0);
+}
+
+#ifdef CONFIG_CORESIGHT_SOURCE_ETM3X
+extern unsigned int etm_readl_cp14(u32 off);
+extern void etm_writel_cp14(u32 val, u32 off);
+#else
+static inline unsigned int etm_readl_cp14(u32 off) { return 0; }
+static inline void etm_writel_cp14(u32 val, u32 off) {}
+#endif
+
+#endif
diff --git a/drivers/coresight/coresight.c b/drivers/coresight/coresight.c
new file mode 100644
index 0000000..7e1e6b7
--- /dev/null
+++ b/drivers/coresight/coresight.c
@@ -0,0 +1,663 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) "coresight: " fmt
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/err.h>
+#include <linux/export.h>
+#include <linux/slab.h>
+#include <linux/semaphore.h>
+#include <linux/clk.h>
+#include <linux/coresight.h>
+#include <linux/of_platform.h>
+#include <linux/debugfs.h>
+#include <linux/delay.h>
+
+#include "coresight-priv.h"
+
+struct dentry *cs_debugfs_parent = NULL;
+
+static LIST_HEAD(coresight_orph_conns);
+static LIST_HEAD(coresight_devs);
+static DEFINE_SEMAPHORE(coresight_semaphore);
+
+static int coresight_source_is_unique(struct coresight_device *csdev)
+{
+	struct coresight_device *cd;
+	int trace_id = source_ops(csdev)->trace_id(csdev);
+
+	/* this shouldn't happen */
+	if (trace_id < 0)
+		return 0;
+
+	/* circle through all known components looking for sources */
+	list_for_each_entry(cd, &coresight_devs, dev_link) {
+		/* no need to care about oneself and components that are not
+		 * sources or not enabled
+		 */
+		if (cd == csdev || !cd->enable ||
+		    cd->type != CORESIGHT_DEV_TYPE_SOURCE)
+			continue;
+
+		/* all you need is one */
+		if (trace_id == source_ops(cd)->trace_id(cd))
+			return 0;
+	}
+
+	return 1;
+}
+
+static int coresight_find_link_inport(struct coresight_device *csdev)
+{
+	int i;
+	struct coresight_device *parent;
+	struct coresight_connection *conn;
+
+	parent = container_of(csdev->path_link.next, struct coresight_device,
+			     path_link);
+	for (i = 0; i < parent->nr_conns; i++) {
+		conn = &parent->conns[i];
+		if (conn->child_dev == csdev)
+			return conn->child_port;
+	}
+
+	pr_err("couldn't find inport, parent: %d, child: %d\n",
+	       parent->id, csdev->id);
+	return 0;
+}
+
+static int coresight_find_link_outport(struct coresight_device *csdev)
+{
+	int i;
+	struct coresight_device *child;
+	struct coresight_connection *conn;
+
+	child = container_of(csdev->path_link.prev, struct coresight_device,
+			      path_link);
+	for (i = 0; i < csdev->nr_conns; i++) {
+		conn = &csdev->conns[i];
+		if (conn->child_dev == child)
+			return conn->outport;
+	}
+
+	pr_err("couldn't find outport, parent: %d, child: %d\n",
+	       csdev->id, child->id);
+	return 0;
+}
+
+static int coresight_enable_sink(struct coresight_device *csdev)
+{
+	int ret;
+
+	if (!csdev->enable) {
+		if (sink_ops(csdev)->enable) {
+			ret = sink_ops(csdev)->enable(csdev);
+			if (ret)
+				return ret;
+		}
+		kref_init(&csdev->kref);
+		csdev->enable = true;
+		return 0;
+	}
+
+	kref_get(&csdev->kref);
+
+	return 0;
+}
+
+static void coresight_driver_disable_sink(struct kref *kref)
+{
+	struct coresight_device *csdev = container_of(kref,
+					struct coresight_device, kref);
+
+	if (sink_ops(csdev)->disable) {
+		sink_ops(csdev)->disable(csdev);
+		csdev->enable = false;
+	}
+}
+
+static void coresight_disable_sink(struct coresight_device *csdev)
+{
+	kref_put(&csdev->kref, coresight_driver_disable_sink);
+}
+
+static int coresight_enable_link(struct coresight_device *csdev)
+{
+	int ret;
+	int inport, outport;
+
+	inport = coresight_find_link_inport(csdev);
+	outport = coresight_find_link_outport(csdev);
+
+	if (link_ops(csdev)->enable) {
+		ret = link_ops(csdev)->enable(csdev, inport, outport);
+		if (ret)
+			return ret;
+	}
+
+	if (!csdev->enable) {
+		csdev->enable = true;
+		kref_init(&csdev->kref);
+	} else {
+		kref_get(&csdev->kref);
+	}
+
+	return 0;
+}
+
+static void coresight_driver_disable_link(struct kref *kref)
+{
+	struct coresight_device *csdev = container_of(kref,
+					struct coresight_device, kref);
+	csdev->enable = false;
+}
+
+static void coresight_disable_link(struct coresight_device *csdev)
+{
+	int inport, outport;
+
+	inport = coresight_find_link_inport(csdev);
+	outport = coresight_find_link_outport(csdev);
+
+	if (link_ops(csdev)->disable)
+		link_ops(csdev)->disable(csdev, inport, outport);
+
+	kref_put(&csdev->kref, coresight_driver_disable_link);
+}
+
+static int coresight_enable_source(struct coresight_device *csdev)
+{
+	int ret;
+
+	if (!coresight_source_is_unique(csdev)) {
+		pr_warn("traceID %d not unique\n",
+			source_ops(csdev)->trace_id(csdev));
+		return -EINVAL;
+	}
+
+	if (!csdev->enable) {
+		if (source_ops(csdev)->enable) {
+			ret = source_ops(csdev)->enable(csdev);
+			if (ret)
+				return ret;
+		}
+		kref_init(&csdev->kref);
+		csdev->enable = true;
+		return 0;
+	}
+
+	kref_get(&csdev->kref);
+
+	return 0;
+}
+
+static void coresight_driver_disable_source(struct kref *kref)
+{
+	struct coresight_device *csdev = container_of(kref,
+					struct coresight_device, kref);
+
+	if (source_ops(csdev)->disable) {
+		source_ops(csdev)->disable(csdev);
+		csdev->enable = false;
+	}
+}
+
+static void coresight_disable_source(struct coresight_device *csdev)
+{
+	kref_put(&csdev->kref, coresight_driver_disable_source);
+}
+
+static int coresight_enable_path(struct list_head *path)
+{
+	int ret = 0;
+	struct coresight_device *cd;
+
+	list_for_each_entry(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			ret = coresight_enable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			/* dont' enable the source just yet - this needs to
+			 * happen at the very end when all links and sink
+			 * along the path have been configured properly.
+			 */
+			;
+		} else {
+			ret = coresight_enable_link(cd);
+		}
+		if (ret)
+			goto err;
+	}
+	return 0;
+err:
+	list_for_each_entry_continue_reverse(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			coresight_disable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			;
+		} else {
+			coresight_disable_link(cd);
+		}
+	}
+	return ret;
+}
+
+static int coresight_disable_path(struct list_head *path)
+{
+	struct coresight_device *cd;
+
+	list_for_each_entry_reverse(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			coresight_disable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			/* the source has already been stopped, no need
+			 * to do it again here.
+			 */
+			;
+		} else {
+			coresight_disable_link(cd);
+		}
+	}
+
+	return 0;
+}
+
+static int coresight_build_paths(struct coresight_device *csdev,
+				 struct list_head *path,
+				 bool enable)
+{
+	int i, ret = -EINVAL;
+	struct coresight_connection *conn;
+
+	list_add(&csdev->path_link, path);
+
+	if (csdev->type == CORESIGHT_DEV_TYPE_SINK && csdev->activated) {
+		if (enable)
+			ret = coresight_enable_path(path);
+		else
+			ret = coresight_disable_path(path);
+	} else {
+		for (i = 0; i < csdev->nr_conns; i++) {
+			conn = &csdev->conns[i];
+			if (coresight_build_paths(conn->child_dev,
+						    path, enable) == 0)
+				ret = 0;
+		}
+	}
+
+	if (list_first_entry(path, struct coresight_device, path_link) != csdev)
+		pr_err("wrong device in %s\n", __func__);
+
+	list_del(&csdev->path_link);
+	return ret;
+}
+
+int coresight_enable(struct coresight_device *csdev)
+{
+	int ret = 0;
+	LIST_HEAD(path);
+
+	WARN_ON(IS_ERR_OR_NULL(csdev));
+
+	down(&coresight_semaphore);
+	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
+		ret = -EINVAL;
+		pr_err("wrong device type in %s\n", __func__);
+		goto out;
+	}
+	if (csdev->enable)
+		goto out;
+
+	if (coresight_build_paths(csdev, &path, true)) {
+		pr_err("building path(s) failed\n");
+		goto out;
+	}
+
+	if (coresight_enable_source(csdev))
+		pr_err("source enable failed\n");
+out:
+	up(&coresight_semaphore);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(coresight_enable);
+
+void coresight_disable(struct coresight_device *csdev)
+{
+	LIST_HEAD(path);
+
+	WARN_ON(IS_ERR_OR_NULL(csdev));
+
+	down(&coresight_semaphore);
+	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
+		pr_err("wrong device type in %s\n", __func__);
+		goto out;
+	}
+	if (!csdev->enable)
+		goto out;
+
+	coresight_disable_source(csdev);
+	if (coresight_build_paths(csdev, &path, false))
+		pr_err("releasing path(s) failed\n");
+
+out:
+	up(&coresight_semaphore);
+}
+EXPORT_SYMBOL_GPL(coresight_disable);
+
+static ssize_t debugfs_active_get(void *data, u64 *val)
+{
+	struct coresight_device *csdev = data;
+
+	*val = csdev->activated;
+	return 0;
+}
+
+static ssize_t debugfs_active_set(void *data, u64 val)
+{
+	struct coresight_device *csdev = data;
+
+	csdev->activated = !!val;
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_active, "enable",
+			S_IRUGO | S_IWUSR, debugfs_active_get,
+			debugfs_active_set, "%llx\n");
+
+static ssize_t debugfs_enable_get(void *data, u64 *val)
+{
+	struct coresight_device *csdev = data;
+
+	*val = csdev->enable;
+	return 0;
+}
+
+static ssize_t debugfs_enable_set(void *data, u64 val)
+{
+	struct coresight_device *csdev = data;
+
+	if (val)
+		return coresight_enable(csdev);
+	else
+		coresight_disable(csdev);
+
+	return 0;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_enable, "enable",
+			S_IRUGO | S_IWUSR, debugfs_enable_get,
+			debugfs_enable_set, "%llx\n");
+
+
+static const struct coresight_ops_entry *coresight_grps_sink[] = {
+	&debugfs_active_entry,
+	NULL,
+};
+
+static const struct coresight_ops_entry *coresight_grps_source[] = {
+	&debugfs_enable_entry,
+	NULL,
+};
+
+struct coresight_group_entries {
+	const char *name;
+	const struct coresight_ops_entry **entries;
+};
+
+struct coresight_group_entries coresight_debugfs_entries[] = {
+	{
+		.name = "none",
+	},
+	{
+		.name = "sink",
+		.entries = coresight_grps_sink,
+	},
+	{
+		.name = "link",
+	},
+	{
+		.name = "linksink",
+	},
+	{
+		.name = "source",
+		.entries = coresight_grps_source,
+	},
+};
+
+static void coresight_device_release(struct device *dev)
+{
+	struct coresight_device *csdev = to_coresight_device(dev);
+
+	kfree(csdev);
+}
+
+static void coresight_fixup_orphan_conns(struct coresight_device *csdev)
+{
+	struct coresight_connection *conn, *temp;
+
+	list_for_each_entry_safe(conn, temp, &coresight_orph_conns, link) {
+		if (conn->child_id == csdev->id) {
+			conn->child_dev = csdev;
+			list_del(&conn->link);
+		}
+	}
+}
+
+static void coresight_fixup_device_conns(struct coresight_device *csdev)
+{
+	int i;
+	struct coresight_device *cd;
+	bool found;
+
+	for (i = 0; i < csdev->nr_conns; i++) {
+		found = false;
+		list_for_each_entry(cd, &coresight_devs, dev_link) {
+			if (csdev->conns[i].child_id == cd->id) {
+				csdev->conns[i].child_dev = cd;
+				found = true;
+				break;
+			}
+		}
+		if (!found)
+			list_add_tail(&csdev->conns[i].link,
+				      &coresight_orph_conns);
+	}
+}
+
+static int debugfs_coresight_init(void)
+{
+	if (!cs_debugfs_parent) {
+		cs_debugfs_parent = debugfs_create_dir("coresight", 0);
+		if (IS_ERR(cs_debugfs_parent))
+			return PTR_ERR(cs_debugfs_parent);
+	}
+
+	return 0;
+}
+
+static struct dentry *coresight_debugfs_desc_init(
+				struct coresight_device *csdev,
+				const struct coresight_ops_entry **debugfs_ops)
+{
+	int i = 0;
+	struct dentry *parent;
+	struct device *dev = &csdev->dev;
+	const struct coresight_ops_entry *ops_entry, **ops_entries;
+
+	parent = debugfs_create_dir(dev_name(dev), cs_debugfs_parent);
+	if (IS_ERR(parent))
+		return NULL;
+
+	/* device-specific ops */
+	while (debugfs_ops && debugfs_ops[i]) {
+		ops_entry = debugfs_ops[i];
+		if (!debugfs_create_file(ops_entry->name, ops_entry->mode,
+					 parent, dev_get_drvdata(dev->parent),
+					 ops_entry->ops)) {
+			debugfs_remove_recursive(parent);
+			return NULL;
+		}
+		i++;
+	}
+
+	/* group-specific ops */
+	i = 0;
+	ops_entries = coresight_debugfs_entries[csdev->type].entries;
+
+	while (ops_entries && ops_entries[i]) {
+		if (!debugfs_create_file(ops_entries[i]->name,
+					 ops_entries[i]->mode,
+					 parent, csdev, ops_entries[i]->ops)) {
+			debugfs_remove_recursive(parent);
+			return NULL;
+		}
+		i++;
+	}
+
+	return parent;
+}
+
+/**
+ * coresight_timeout - loop until a bit has changed to a specific state.
+ * @addr: base address of the area of interest.
+ * @offset: address of a register, starting from @addr.
+ * @position: the position of the bit of interest.
+ * @value: the value the bit should have.
+ *
+ * Returns as soon as the bit has taken the desired state or TIMEOU_US has
+ * elapsed, which ever happens first.
+ */
+
+void coresight_timeout(void __iomem *addr, u32 offset, int position, int value)
+{
+	int i;
+	u32 val;
+
+	for (i = TIMEOUT_US; i > 0; i--) {
+		val = __raw_readl(addr + offset);
+		/* waiting on the bit to go from 0 to 1 */
+		if (value) {
+			if (val & BIT(position))
+				return;
+		/* waiting on the bit to go from 1 to 0 */
+		} else {
+			if (!(val & BIT(position)))
+				return;
+		}
+
+		/* The specification doesn't say how long we are expected
+		 * to wait.
+		 */
+		udelay(1);
+	}
+
+	WARN(1,
+	     "coresight: timeout observed when proving at offset %#x\n",
+	     offset);
+}
+
+struct coresight_device *coresight_register(struct coresight_desc *desc)
+{
+	int i;
+	int ret;
+	int link_subtype;
+	struct coresight_device *csdev;
+	struct coresight_connection *conns;
+
+	WARN_ON(IS_ERR_OR_NULL(desc));
+
+	csdev = kzalloc(sizeof(*csdev), GFP_KERNEL);
+	if (!csdev) {
+		ret = -ENOMEM;
+		goto err_kzalloc_csdev;
+	}
+
+	csdev->id = desc->pdata->id;
+
+	if (desc->type == CORESIGHT_DEV_TYPE_LINK ||
+	    desc->type == CORESIGHT_DEV_TYPE_LINKSINK)
+		link_subtype = desc->subtype.link_subtype;
+
+	csdev->nr_conns = desc->pdata->nr_outports;
+	conns = kcalloc(csdev->nr_conns, sizeof(*conns), GFP_KERNEL);
+	if (!conns) {
+		ret = -ENOMEM;
+		goto err_kzalloc_conns;
+	}
+
+	for (i = 0; i < csdev->nr_conns; i++) {
+		conns[i].outport = desc->pdata->outports[i];
+		conns[i].child_id = desc->pdata->child_ids[i];
+		conns[i].child_port = desc->pdata->child_ports[i];
+	}
+	csdev->conns = conns;
+
+	csdev->type = desc->type;
+	csdev->subtype = desc->subtype;
+	csdev->ops = desc->ops;
+	csdev->owner = desc->owner;
+
+	csdev->dev.parent = desc->dev;
+	csdev->dev.release = coresight_device_release;
+	dev_set_name(&csdev->dev, "%s", desc->pdata->name);
+
+
+	down(&coresight_semaphore);
+
+	coresight_fixup_device_conns(csdev);
+
+	ret = debugfs_coresight_init();
+	if (ret < 0)
+		goto err_coresight_init;
+
+	csdev->de = coresight_debugfs_desc_init(csdev, desc->debugfs_ops);
+
+	coresight_fixup_orphan_conns(csdev);
+
+	list_add_tail(&csdev->dev_link, &coresight_devs);
+	up(&coresight_semaphore);
+
+	return csdev;
+
+err_coresight_init:
+	up(&coresight_semaphore);
+	kfree(conns);
+err_kzalloc_conns:
+	kfree(csdev);
+err_kzalloc_csdev:
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(coresight_register);
+
+void coresight_unregister(struct coresight_device *csdev)
+{
+	WARN_ON(IS_ERR_OR_NULL(csdev));
+
+	down(&coresight_semaphore);
+
+	list_del(&csdev->dev_link);
+	debugfs_remove_recursive(csdev->de);
+	kfree(csdev->conns);
+	if (list_empty(&coresight_devs))
+		kfree(cs_debugfs_parent);
+
+	up(&coresight_semaphore);
+}
+EXPORT_SYMBOL_GPL(coresight_unregister);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
new file mode 100644
index 0000000..c780b4b
--- /dev/null
+++ b/drivers/coresight/of_coresight.c
@@ -0,0 +1,201 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_graph.h>
+#include <linux/coresight.h>
+#include <asm/smp_plat.h>
+
+static int of_get_coresight_id(struct device_node *node, int *id)
+{
+	const __be32 *reg;
+	u64 addr;
+
+	/* derive component id from its memory map */
+	reg = of_get_property(node, "reg", NULL);
+	if (reg) {
+		addr = of_translate_address(node, reg);
+		if (addr != OF_BAD_ADDR) {
+			*id = addr;
+			return 0;
+		}
+	}
+
+	/* no "reg", we have a non-configurable replicator */
+	reg = of_get_property(node, "id", NULL);
+	if (reg) {
+		*id = of_read_ulong(reg, 1);
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static struct device_node *of_get_coresight_endpoint(
+		const struct device_node *parent, struct device_node *prev)
+{
+	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
+
+	of_node_put(prev);
+	return node;
+}
+
+static void of_coresight_get_ports(struct device_node *node,
+				   int *nr_inports, int *nr_outports)
+{
+	struct device_node *ep = NULL;
+	int in = 0, out = 0;
+
+	do {
+		ep = of_get_coresight_endpoint(node, ep);
+		if (!ep)
+			break;
+
+		if (of_property_read_bool(ep, "slave-mode"))
+			in++;
+		else
+			out++;
+
+	} while (ep);
+
+	*nr_inports = in;
+	*nr_outports = out;
+}
+
+static int of_coresight_alloc_memory(struct device *dev,
+			struct coresight_platform_data *pdata)
+{
+	/* list of output port on this component */
+	pdata->outports = devm_kzalloc(dev, pdata->nr_outports *
+				       sizeof(*pdata->outports),
+				       GFP_KERNEL);
+	if (!pdata->outports)
+		return -ENOMEM;
+
+
+	/* children connected to this component via @outport */
+	pdata->child_ids = devm_kzalloc(dev, pdata->nr_outports *
+					sizeof(*pdata->child_ids),
+					GFP_KERNEL);
+	if (!pdata->child_ids)
+		return -ENOMEM;
+
+	/* port number on the child this component is connected to */
+	pdata->child_ports = devm_kzalloc(dev, pdata->nr_outports *
+					  sizeof(*pdata->child_ports),
+					  GFP_KERNEL);
+	if (!pdata->child_ports)
+		return -ENOMEM;
+
+	return 0;
+}
+
+struct coresight_platform_data *of_get_coresight_platform_data(
+				struct device *dev, struct device_node *node)
+{
+	int id, i = 0, ret = 0;
+	struct device_node *cpu;
+	struct coresight_platform_data *pdata;
+	struct of_endpoint endpoint, rendpoint;
+	struct device_node *ep = NULL;
+	struct device_node *rparent = NULL;
+	struct device_node *rport = NULL;
+
+	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
+	if (!pdata)
+		return ERR_PTR(-ENOMEM);
+
+	/* use the base address as id */
+	ret = of_get_coresight_id(node, &id);
+	if (ret)
+		return ERR_PTR(ret);
+	pdata->id = id;
+
+	/* use device name as debugfs handle */
+	pdata->name = dev_name(dev);
+
+	/* get the number of input and output port for this component */
+	of_coresight_get_ports(node, &pdata->nr_inports, &pdata->nr_outports);
+
+	if (pdata->nr_outports) {
+		ret = of_coresight_alloc_memory(dev, pdata);
+		if (ret)
+			return ERR_PTR(ret);
+
+		/* iterate through each port to discover topology */
+		do {
+			/* get a handle on a port */
+			ep = of_get_coresight_endpoint(node, ep);
+			if (!ep)
+				break;
+
+			/* no need to deal with input ports, processing for as
+			 * processing for output ports will deal with them.
+			 */
+			if (of_find_property(ep, "slave-mode", NULL))
+				continue;
+
+			/* get a handle on the local endpoint */
+			ret = of_graph_parse_endpoint(ep, &endpoint);
+
+			if (ret)
+				continue;
+
+			/* the local out port number */
+			pdata->outports[i] = endpoint.id;
+
+			/* get a handle the remote port and parent
+			 * attached to it.
+			 */
+			rparent = of_graph_get_remote_port_parent(ep);
+			rport = of_graph_get_remote_port(ep);
+
+			if (!rparent || !rport)
+				continue;
+
+			if (of_graph_parse_endpoint(rport, &rendpoint))
+				continue;
+
+			ret = of_get_coresight_id(rparent, &id);
+			if (ret)
+				continue;
+			pdata->child_ids[i] = id;
+			pdata->child_ports[i] = rendpoint.id;
+
+			i++;
+		} while (ep);
+	}
+
+	/* affinity defaults to CPU0 */
+	pdata->cpu = 0;
+	cpu = of_parse_phandle(node, "cpu", 0);
+	if (cpu) {
+		const u32 *mpidr;
+		int len, index;
+
+		mpidr = of_get_property(cpu, "reg", &len);
+		if (mpidr && len == 4) {
+			index = get_logical_index(be32_to_cpup(mpidr));
+			if (index != -EINVAL)
+				pdata->cpu = index;
+		}
+	}
+
+	return pdata;
+}
+EXPORT_SYMBOL_GPL(of_get_coresight_platform_data);
diff --git a/include/linux/amba/bus.h b/include/linux/amba/bus.h
index fdd7e1b..cdddabe 100644
--- a/include/linux/amba/bus.h
+++ b/include/linux/amba/bus.h
@@ -23,6 +23,7 @@
 
 #define AMBA_NR_IRQS	9
 #define AMBA_CID	0xb105f00d
+#define CORESIGHT_CID	0xb105900d
 
 struct clk;
 
diff --git a/include/linux/coresight.h b/include/linux/coresight.h
new file mode 100644
index 0000000..5b22287
--- /dev/null
+++ b/include/linux/coresight.h
@@ -0,0 +1,275 @@
+/* Copyright (c) 2012, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _LINUX_CORESIGHT_H
+#define _LINUX_CORESIGHT_H
+
+#include <linux/device.h>
+
+/* Peripheral id registers (0xFD0-0xFEC) */
+#define CORESIGHT_PERIPHIDR4	0xfd0
+#define CORESIGHT_PERIPHIDR5	0xfd4
+#define CORESIGHT_PERIPHIDR6	0xfd8
+#define CORESIGHT_PERIPHIDR7	0xfdC
+#define CORESIGHT_PERIPHIDR0	0xfe0
+#define CORESIGHT_PERIPHIDR1	0xfe4
+#define CORESIGHT_PERIPHIDR2	0xfe8
+#define CORESIGHT_PERIPHIDR3	0xfeC
+/* Component id registers (0xFF0-0xFFC) */
+#define CORESIGHT_COMPIDR0	0xff0
+#define CORESIGHT_COMPIDR1	0xff4
+#define CORESIGHT_COMPIDR2	0xff8
+#define CORESIGHT_COMPIDR3	0xffC
+
+#define ETM_ARCH_V3_3		0x23
+#define ETM_ARCH_V3_5		0x25
+#define PFT_ARCH_V1_0		0x30
+#define PFT_ARCH_V1_1		0x31
+
+#define CORESIGHT_UNLOCK	0xc5acce55
+
+enum coresight_dev_type {
+	CORESIGHT_DEV_TYPE_NONE,
+	CORESIGHT_DEV_TYPE_SINK,
+	CORESIGHT_DEV_TYPE_LINK,
+	CORESIGHT_DEV_TYPE_LINKSINK,
+	CORESIGHT_DEV_TYPE_SOURCE,
+};
+
+enum coresight_dev_subtype_sink {
+	CORESIGHT_DEV_SUBTYPE_SINK_NONE,
+	CORESIGHT_DEV_SUBTYPE_SINK_PORT,
+	CORESIGHT_DEV_SUBTYPE_SINK_BUFFER,
+};
+
+enum coresight_dev_subtype_link {
+	CORESIGHT_DEV_SUBTYPE_LINK_NONE,
+	CORESIGHT_DEV_SUBTYPE_LINK_MERG,
+	CORESIGHT_DEV_SUBTYPE_LINK_SPLIT,
+	CORESIGHT_DEV_SUBTYPE_LINK_FIFO,
+};
+
+enum coresight_dev_subtype_source {
+	CORESIGHT_DEV_SUBTYPE_SOURCE_NONE,
+	CORESIGHT_DEV_SUBTYPE_SOURCE_PROC,
+	CORESIGHT_DEV_SUBTYPE_SOURCE_BUS,
+	CORESIGHT_DEV_SUBTYPE_SOURCE_SOFTWARE,
+};
+
+/**
+ * @name:	name of the entry to appear under the component's
+		debugfs sub-directory.
+ * @mode:	what operation can be performed on the entry.
+ * @ops:	specific manipulation to be done using this entry.
+ */
+struct coresight_ops_entry {
+	const char *name;
+	umode_t mode;
+	const struct file_operations *ops;
+};
+
+/**
+ * @sink_subtype:	type of sink this component is, as defined
+			by @coresight_dev_subtype_sink.
+ * @link_subtype:	type of link this component is, as defined
+			by @coresight_dev_subtype_link.
+ * @source_subtype:	type of source this component is, as defined
+			by @coresight_dev_subtype_source.
+ */
+struct coresight_dev_subtype {
+	enum coresight_dev_subtype_sink sink_subtype;
+	enum coresight_dev_subtype_link link_subtype;
+	enum coresight_dev_subtype_source source_subtype;
+};
+
+/**
+ * @id:		unique ID of the component, usually the memory mapped address.
+ * @cpu:	the CPU a source belongs to. Only applicable for ETM/PTMs.
+ * @name:	name of the component as shown under debugfs.
+ * @nr_inports:	number of input ports for this component.
+ * @nr_outports:number of output ports for this component.
+ * @child_ids:	unique ID of a child component.
+ * @child_ports:child component port number the current component is
+		connected  to.
+ * @clk:	The clock this component is associated to.
+ */
+struct coresight_platform_data {
+	int id;
+	int cpu;
+	const char *name;
+	int nr_inports;
+	int *outports;
+	int *child_ids;
+	int *child_ports;
+	int nr_outports;
+	struct clk *clk;
+};
+
+/**
+ * @type:	as defined by @coresight_dev_type.
+ * @subtype:	as defined by @coresight_dev_subtype.
+ * @ops:	generic operations for this component, as defined
+		by @coresight_ops.
+ * @pdata:	platform data collected from DT.
+ * @dev:	The device entity associated to this component.
+ * @debugfs_ops:operations specific to this component. These will end up
+		in the component's debugfs sub-directory.
+ * @owner:	typically "THIS_MODULE".
+ */
+struct coresight_desc {
+	enum coresight_dev_type type;
+	struct coresight_dev_subtype subtype;
+	const struct coresight_ops *ops;
+	struct coresight_platform_data *pdata;
+	struct device *dev;
+	const struct coresight_ops_entry **debugfs_ops;
+	struct module *owner;
+};
+
+/**
+ * @outport:	a connection's output port number.
+ * @chid_id:	remote component's ID.
+ * @child_port:	remote component's port number @output is connected to.
+ * @child_dev:	a @coresight_device representation of the component
+		connected to @outport.
+ * @link:	hook to @coresight_orph_conns, for framework internal
+		use only.
+ */
+struct coresight_connection {
+	int outport;
+	int child_id;
+	int child_port;
+	struct coresight_device *child_dev;
+	struct list_head link;
+};
+
+/**
+ * @id:		unique ID of the component.
+ * @conns:	list of connections associated to this component.
+ * @type:	as defined by @coresight_dev_type.
+ * @subtype:	as defined by @coresight_dev_subtype.
+ * @ops:	generic operations for this component, as defined
+		by @coresight_ops.
+ * @de:		handle on a component's debugfs entry.
+ * @dev:	The device entity associated to this component.
+ * @kref:	keeping count on component references.
+ * @dev_link:	link of current component into list of all components
+		discovered in the system.
+ * @path_link:	link of current component into the path being enabled.
+ * @owner:	typically "THIS_MODULE".
+ * @enable:	'true' if component is currently part of an active path.
+ * @activated:	'true' only if a _sink_ has been activated.  A sink can be
+		activated but not yet enabled.  Enabling for a _sink_
+		happens when a source has been selected for that it.
+ */
+struct coresight_device {
+	int id;
+	struct coresight_connection *conns;
+	int nr_conns;
+	enum coresight_dev_type type;
+	struct coresight_dev_subtype subtype;
+	const struct coresight_ops *ops;
+	struct dentry *de;
+	struct device dev;
+	struct kref kref;
+	struct list_head dev_link;
+	struct list_head path_link;
+	struct module *owner;
+	bool enable;	/* true only if configured as part of a path */
+	bool activated;	/* true only if a sink is part of a path */
+};
+
+#define to_coresight_device(d) container_of(d, struct coresight_device, dev)
+
+#define source_ops(csdev)	csdev->ops->source_ops
+#define sink_ops(csdev)		csdev->ops->sink_ops
+#define link_ops(csdev)		csdev->ops->link_ops
+
+#define CORESIGHT_DEBUGFS_ENTRY(__name, __entry_name,			\
+				 __mode, __get, __set, __fmt)		\
+DEFINE_SIMPLE_ATTRIBUTE(__name ## _ops, __get, __set, __fmt)		\
+static const struct coresight_ops_entry __name ## _entry = {		\
+	.name = __entry_name,						\
+	.mode = __mode,							\
+	.ops  = &__name ## _ops						\
+}
+
+/**
+ * Operations available for sinks
+ * @enable:	enables the sink.
+ * @disable:	disables the sink.
+ */
+struct coresight_ops_sink {
+	int (*enable)(struct coresight_device *csdev);
+	void (*disable)(struct coresight_device *csdev);
+};
+
+/**
+ * Operations available for links.
+ * @enable:	enables flow between iport and oport.
+ * @disable:	disables flow between iport and oport.
+ */
+struct coresight_ops_link {
+	int (*enable)(struct coresight_device *csdev, int iport, int oport);
+	void (*disable)(struct coresight_device *csdev, int iport, int oport);
+};
+
+/**
+ * Operations available for sources.
+ * @trace_id:	returns the value of the component's trace ID as known
+		to the HW.
+ * @enable:	enables tracing from a source.
+ * @disable:	disables tracing for a source.
+ */
+struct coresight_ops_source {
+	int (*trace_id)(struct coresight_device *csdev);
+	int (*enable)(struct coresight_device *csdev);
+	void (*disable)(struct coresight_device *csdev);
+};
+
+struct coresight_ops {
+	const struct coresight_ops_sink *sink_ops;
+	const struct coresight_ops_link *link_ops;
+	const struct coresight_ops_source *source_ops;
+};
+
+#ifdef CONFIG_CORESIGHT
+extern struct coresight_device *
+coresight_register(struct coresight_desc *desc);
+extern void coresight_unregister(struct coresight_device *csdev);
+extern int coresight_enable(struct coresight_device *csdev);
+extern void coresight_disable(struct coresight_device *csdev);
+extern int coresight_is_bit_set(u32 val, int position, int value);
+extern void coresight_timeout(void __iomem *addr, u32 offset,
+			      int position, int value);
+#ifdef CONFIG_OF
+extern struct coresight_platform_data *of_get_coresight_platform_data(
+				struct device *dev, struct device_node *node);
+#endif
+#else
+static inline struct coresight_device *
+coresight_register(struct coresight_desc *desc) { return NULL; }
+static inline void coresight_unregister(struct coresight_device *csdev) {}
+static inline int
+coresight_enable(struct coresight_device *csdev) { return -ENOSYS; }
+static inline void coresight_disable(struct coresight_device *csdev) {}
+static inline int coresight_is_bit_set(u32 val, int position, int value)
+					 { return 0; }
+static inline void coresight_timeout(void __iomem *addr, u32 offset,
+				     int position, int value) {}
+#ifdef CONFIG_OF
+static inline struct coresight_platform_data *of_get_coresight_platform_data(
+	struct device *dev, struct device_node *node) { return NULL; }
+#endif
+#endif
+
+#endif
-- 
1.9.1

