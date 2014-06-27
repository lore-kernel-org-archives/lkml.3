Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbaF0SHG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 14:07:06 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:41953 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaF0SEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 14:04:38 -0400
From: mathieu.poirier@linaro.org
To: linus.walleij@linaro.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        daniel.thompson@linaro.org, robherring2@gmail.com
Cc: mathieu.poirier@linaro.org, arve@android.com, john.stultz@linaro.org,
        pratikp@codeaurora.org, varshney@ti.com, Al.Grant@arm.com,
        jonas.svennebring@avagotech.com, james.king@linaro.org,
        panchaxari.prasannamurthy@linaro.org, arnd@linaro.org,
        marcin.jabrzyk@gmail.com, r.sengupta@samsung.com,
        robbelibobban@gmail.com, Tony.Armitstead@arm.com, patches@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/9 v2] coresight: add CoreSight core layer framework
Date: Fri, 27 Jun 2014 12:04:13 -0600
Message-Id: <1403892261-25026-2-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
References: <1403892261-25026-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pratik Patel <pratikp@codeaurora.org>

CoreSight components are compliant with the ARM CoreSight
architecture specification and can be connected in various
topologies to suite a particular SoCs tracing needs. These trace
components can generally be classified as sources, links and
sinks. Trace data produced by one or more sources flows through
the intermediate links connecting the source to the currently
selected sink.

CoreSight framework provides an interface for the CoreSight trace
drivers to register themselves with. It's intended to build up a
topological view of the CoreSight components and configure the
right series of components on user input via debugfs.

For eg., when enabling a source, framework builds up a path
consisting of all the components connecting the source to the
currently selected sink and enables all of them.

Framework also supports switching between available sinks and
also provides status information to user space applications
through the debugfs interface.

Signed-off-by: Pratik Patel <pratikp@codeaurora.org>
Signed-off-by: Panchaxari Prasannamurthy <panchaxari.prasannamurthy@linaro.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 .../devicetree/bindings/arm/coresight.txt          | 141 +++++
 drivers/Kconfig                                    |   2 +
 drivers/Makefile                                   |   1 +
 drivers/amba/bus.c                                 |   2 +-
 drivers/coresight/Kconfig                          |  10 +
 drivers/coresight/Makefile                         |   5 +
 drivers/coresight/coresight-priv.h                 |  69 +++
 drivers/coresight/coresight.c                      | 680 +++++++++++++++++++++
 drivers/coresight/of_coresight.c                   | 207 +++++++
 include/linux/amba/bus.h                           |   1 +
 include/linux/coresight.h                          | 190 ++++++
 include/linux/of_coresight.h                       |  27 +
 12 files changed, 1334 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/arm/coresight.txt
 create mode 100644 drivers/coresight/Kconfig
 create mode 100644 drivers/coresight/Makefile
 create mode 100644 drivers/coresight/coresight-priv.h
 create mode 100644 drivers/coresight/coresight.c
 create mode 100644 drivers/coresight/of_coresight.c
 create mode 100644 include/linux/coresight.h
 create mode 100644 include/linux/of_coresight.h

diff --git a/Documentation/devicetree/bindings/arm/coresight.txt b/Documentation/devicetree/bindings/arm/coresight.txt
new file mode 100644
index 0000000..9d4eb53
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/coresight.txt
@@ -0,0 +1,141 @@
+* CoreSight Components
+
+CoreSight components are compliant with the ARM CoreSight architecture
+specification and can be connected in various topologies to suit a particular
+SoCs tracing needs. These trace components can generally be classified as sinks,
+links and sources. Trace data produced by one or more sources flows through the
+intermediate links connecting the source to the currently selected sink. Each
+CoreSight component device should use these properties to describe its hardware
+characteristcs.
+
+Required properties:
+
+- compatible : name of the component used for driver matching.  Possible values
+	include: "arm,coresight-etb", "arm,coresight-tpiu", "arm,coresight-tmc",
+	"arm,coresight-funnel", and "arm,coresight-etm".  All of these have to
+	be supplemented with "arm,primecell" as drivers are using the AMBA bus
+	interface.
+- reg : physical base address and length of the register set(s) of the component
+- clocks : the clock associated to this component
+- clock-names: the name of the clock as referenced by the code.  Since we are
+	using the AMBA framework, the name should be "apb_pclk".
+- ports or port: The representation of the component's port layout using the
+	generic DT graph presentation found in "bindings/graph.txt"
+
+Optional properties for Sinks:
+- coresight-default-sink: must be specified for one of the sink devices that is
+intended to be made the default sink. Other sink devices must not have this
+specified. Not specifying this property on any of the sinks is invalid.
+
+Optional properties for ETM/PTMs:
+- arm,cp14 : access to ETM/PTM management registers is made via cp14.
+- cpu: the cpu this ETM/PTM is affined to.
+
+Optional property for TMC:
+- arm,buffer-size : size of contiguous buffer space for TMC ETR (embedded trace router)
+
+
+Example:
+
+1. Sinks
+	etb: etb@20010000 {
+		compatible = "arm,coresight-etb", "arm,primecell";
+		reg = <0 0x20010000 0 0x1000>;
+
+		coresight-default-sink;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			etb_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&funnel_out_port0>;
+			};
+		};
+	};
+
+	tpiu: tpiu@20030000 {
+		compatible = "arm,coresight-tpiu", "arm,primecell";
+		reg = <0 0x20030000 0 0x1000>;
+
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			tpiu_in_port: endpoint@0 {
+				slave-mode;
+				remote-endpoint = <&funnel_out_port1>;
+			};
+		};
+	};
+
+2. Links
+	funnel {
+		compatible = "arm,coresight-funnel", "arm,primecell";
+		reg = <0 0x20040000 0 0x1000>;
+
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@0 {
+				reg = <0>;
+				funnel_out_port0: endpoint {
+					remote-endpoint = <&etb_in_port>;
+				};
+			};
+
+			port@1 {
+				reg = <1>;
+				funnel_out_port1: endpoint {
+					remote-endpoint = <&tpiu_in_port>;
+				};
+			};
+
+			port@2 {
+				reg = <0>;
+				funnel_in_port0: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm0_out_port>;
+				};
+			};
+
+			port@3 {
+				reg = <1>;
+				funnel_in_port1: endpoint {
+					slave-mode;
+					remote-endpoint = <&ptm1_out_port>;
+				};
+			};
+
+		};
+	};
+
+3. Sources
+	ptm0: ptm@2201c000 {
+		compatible = "arm,coresight-etm", "arm,primecell";
+		reg = <0 0x2201c000 0 0x1000>;
+
+		cpu = <&cpu0>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			ptm0_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port0>;
+			};
+		};
+	};
+
+	ptm1: ptm@2201d000 {
+		compatible = "arm,coresight-etm", "arm,primecell";
+		reg = <0 0x2201d000 0 0x1000>;
+
+		cpu = <&cpu1>;
+		clocks = <&oscclk6a>;
+		clock-names = "apb_pclk";
+		port {
+			ptm1_out_port: endpoint {
+				remote-endpoint = <&funnel_in_port1>;
+			};
+		};
+	};
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 0a0a90f..0323ffb 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -174,4 +174,6 @@ source "drivers/powercap/Kconfig"
 
 source "drivers/mcb/Kconfig"
 
+source "drivers/coresight/Kconfig"
+
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 7183b6a..a864d9f 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -157,3 +157,4 @@ obj-$(CONFIG_NTB)		+= ntb/
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
diff --git a/drivers/coresight/Kconfig b/drivers/coresight/Kconfig
new file mode 100644
index 0000000..fdd4d08
--- /dev/null
+++ b/drivers/coresight/Kconfig
@@ -0,0 +1,10 @@
+menuconfig CORESIGHT
+	bool "CoreSight Tracing Support"
+	select ARM_AMBA
+	help
+	  This framework provides an interface for the CoreSight debug and
+	  trace drivers to register themselves with. It's intended to build
+	  up a topological view of the CoreSight components and configure
+	  the right series of components on user input via sysfs. It also
+	  provides status information to user space applications through
+	  the debugfs interface.
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
index 0000000..da1ebbb
--- /dev/null
+++ b/drivers/coresight/coresight-priv.h
@@ -0,0 +1,69 @@
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
+ * Coresight management registers (0xF00-0xFCC)
+ * 0xFA0 - 0xFA4: Management	registers in PFTv1.0
+ *		  Trace		registers in PFTv1.1
+ */
+#define CORESIGHT_ITCTRL	(0xF00)
+#define CORESIGHT_CLAIMSET	(0xFA0)
+#define CORESIGHT_CLAIMCLR	(0xFA4)
+#define CORESIGHT_LAR		(0xFB0)
+#define CORESIGHT_LSR		(0xFB4)
+#define CORESIGHT_AUTHSTATUS	(0xFB8)
+#define CORESIGHT_DEVID		(0xFC8)
+#define CORESIGHT_DEVTYPE	(0xFCC)
+
+#define TIMEOUT_US		(100)
+
+#define BM(lsb, msb)		((BIT(msb) - BIT(lsb)) + BIT(msb))
+#define BMVAL(val, lsb, msb)	((val & BM(lsb, msb)) >> lsb)
+#define BVAL(val, n)		((val & BIT(n)) >> n)
+
+#define cs_writel(addr, val, off)	__raw_writel((val), addr + off)
+#define cs_readl(addr, off)		__raw_readl(addr + off)
+
+static inline void CS_LOCK(void __iomem *addr)
+{
+	do {
+		/* wait for things to settle */
+		mb();
+		cs_writel(addr, 0x0, CORESIGHT_LAR);
+	} while (0);
+}
+
+static inline void CS_UNLOCK(void __iomem *addr)
+{
+	do {
+		cs_writel(addr, CORESIGHT_UNLOCK, CORESIGHT_LAR);
+		/* make sure eveyone has seen this */
+		mb();
+	} while (0);
+}
+
+#ifdef CONFIG_CORESIGHT_SOURCE_ETM
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
index 0000000..6218d86
--- /dev/null
+++ b/drivers/coresight/coresight.c
@@ -0,0 +1,680 @@
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
+
+#include "coresight-priv.h"
+
+#define NO_SINK		(-1)
+
+struct dentry *cs_debugfs_parent = NULL;
+
+static int curr_sink = NO_SINK;
+static LIST_HEAD(coresight_orph_conns);
+static LIST_HEAD(coresight_devs);
+static DEFINE_SEMAPHORE(coresight_mutex);
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
+	pr_err("coresight: couldn't find inport, parent: %d, child: %d\n",
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
+	pr_err("coresight: couldn't find outport, parent: %d, child: %d\n",
+	       csdev->id, child->id);
+	return 0;
+}
+
+static int coresight_enable_sink(struct coresight_device *csdev)
+{
+	int ret;
+
+	if (csdev->refcnt.sink_refcnt == 0) {
+		if (csdev->ops->sink_ops->enable) {
+			ret = csdev->ops->sink_ops->enable(csdev);
+			if (ret)
+				goto err;
+			csdev->enable = true;
+		}
+	}
+	csdev->refcnt.sink_refcnt++;
+
+	return 0;
+err:
+	return ret;
+}
+
+static void coresight_disable_sink(struct coresight_device *csdev)
+{
+	if (csdev->refcnt.sink_refcnt == 1) {
+		if (csdev->ops->sink_ops->disable) {
+			csdev->ops->sink_ops->disable(csdev);
+			csdev->enable = false;
+		}
+	}
+	csdev->refcnt.sink_refcnt--;
+}
+
+static int coresight_enable_link(struct coresight_device *csdev)
+{
+	int ret;
+	int link_subtype;
+	int refport, inport, outport;
+
+	inport = coresight_find_link_inport(csdev);
+	outport = coresight_find_link_outport(csdev);
+
+	link_subtype = csdev->subtype.link_subtype;
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
+		refport = inport;
+	else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
+		refport = outport;
+	else
+		refport = 0;
+
+	if (csdev->refcnt.link_refcnts[refport] == 0) {
+		if (csdev->ops->link_ops->enable) {
+			ret = csdev->ops->link_ops->enable(csdev, inport,
+							   outport);
+			if (ret)
+				goto err;
+			csdev->enable = true;
+		}
+	}
+	csdev->refcnt.link_refcnts[refport]++;
+
+	return 0;
+err:
+	return ret;
+}
+
+static void coresight_disable_link(struct coresight_device *csdev)
+{
+	int link_subtype;
+	int refport, inport, outport;
+
+	inport = coresight_find_link_inport(csdev);
+	outport = coresight_find_link_outport(csdev);
+
+	link_subtype = csdev->subtype.link_subtype;
+	if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
+		refport = inport;
+	else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
+		refport = outport;
+	else
+		refport = 0;
+
+	if (csdev->refcnt.link_refcnts[refport] == 1) {
+		if (csdev->ops->link_ops->disable) {
+			csdev->ops->link_ops->disable(csdev, inport, outport);
+			csdev->enable = false;
+		}
+	}
+	csdev->refcnt.link_refcnts[refport]--;
+}
+
+static int coresight_enable_source(struct coresight_device *csdev)
+{
+	int ret;
+
+	if (csdev->refcnt.source_refcnt == 0) {
+		if (csdev->ops->source_ops->enable) {
+			ret = csdev->ops->source_ops->enable(csdev);
+			if (ret)
+				goto err;
+			csdev->enable = true;
+		}
+	}
+	csdev->refcnt.source_refcnt++;
+
+	return 0;
+err:
+	return ret;
+}
+
+static void coresight_disable_source(struct coresight_device *csdev)
+{
+	if (csdev->refcnt.source_refcnt == 1) {
+		if (csdev->ops->source_ops->disable) {
+			csdev->ops->source_ops->disable(csdev);
+			csdev->enable = false;
+		}
+	}
+	csdev->refcnt.source_refcnt--;
+}
+
+static struct list_head *coresight_build_path(struct coresight_device *csdev,
+					      struct list_head *path)
+{
+	int i;
+	struct list_head *p;
+	struct coresight_connection *conn;
+
+	if (csdev->id == curr_sink) {
+		list_add_tail(&csdev->path_link, path);
+		return path;
+	}
+
+	for (i = 0; i < csdev->nr_conns; i++) {
+		conn = &csdev->conns[i];
+		p = coresight_build_path(conn->child_dev, path);
+		if (p) {
+			list_add_tail(&csdev->path_link, p);
+			return p;
+		}
+	}
+	return NULL;
+}
+
+static void coresight_release_path(struct list_head *path)
+{
+	struct coresight_device *cd, *temp;
+
+	list_for_each_entry_safe(cd, temp, path, path_link)
+		list_del(&cd->path_link);
+}
+
+static int coresight_enable_path(struct list_head *path, bool incl_source)
+{
+	int ret = 0;
+	struct coresight_device *cd;
+
+	list_for_each_entry(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			ret = coresight_enable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			if (incl_source)
+				ret = coresight_enable_source(cd);
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
+			if (incl_source)
+				coresight_disable_source(cd);
+		} else {
+			coresight_disable_link(cd);
+		}
+	}
+	return ret;
+}
+
+static void coresight_disable_path(struct list_head *path, bool incl_source)
+{
+	struct coresight_device *cd;
+
+	list_for_each_entry(cd, path, path_link) {
+		if (cd == list_first_entry(path, struct coresight_device,
+					   path_link)) {
+			coresight_disable_sink(cd);
+		} else if (list_is_last(&cd->path_link, path)) {
+			if (incl_source)
+				coresight_disable_source(cd);
+		} else {
+			coresight_disable_link(cd);
+		}
+	}
+}
+
+static int coresight_switch_sink(struct coresight_device *csdev)
+{
+	int ret = 0;
+	LIST_HEAD(path);
+	struct coresight_device *cd;
+
+	if (IS_ERR_OR_NULL(csdev))
+		return -EINVAL;
+
+	down(&coresight_mutex);
+	if (csdev->id == curr_sink)
+		goto out;
+
+	list_for_each_entry(cd, &coresight_devs, dev_link) {
+		if (cd->type == CORESIGHT_DEV_TYPE_SOURCE && cd->enable) {
+			coresight_build_path(cd, &path);
+			coresight_disable_path(&path, false);
+			coresight_release_path(&path);
+		}
+	}
+	curr_sink = csdev->id;
+	list_for_each_entry(cd, &coresight_devs, dev_link) {
+		if (cd->type == CORESIGHT_DEV_TYPE_SOURCE && cd->enable) {
+			coresight_build_path(cd, &path);
+			ret = coresight_enable_path(&path, false);
+			coresight_release_path(&path);
+			if (ret)
+				goto err;
+		}
+	}
+out:
+	up(&coresight_mutex);
+	return 0;
+err:
+	list_for_each_entry(cd, &coresight_devs, dev_link) {
+		if (cd->type == CORESIGHT_DEV_TYPE_SOURCE && cd->enable)
+			coresight_disable_source(cd);
+	}
+	pr_err("coresight: sink switch failed, sources disabled; try again\n");
+	return ret;
+}
+
+int coresight_enable(struct coresight_device *csdev)
+{
+	int ret = 0;
+	LIST_HEAD(path);
+
+	if (IS_ERR_OR_NULL(csdev))
+		return -EINVAL;
+
+	down(&coresight_mutex);
+	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
+		ret = -EINVAL;
+		pr_err("coresight: wrong device type in %s\n", __func__);
+		goto out;
+	}
+	if (csdev->enable)
+		goto out;
+
+	coresight_build_path(csdev, &path);
+	ret = coresight_enable_path(&path, true);
+	coresight_release_path(&path);
+	if (ret)
+		pr_err("coresight: enable failed\n");
+out:
+	up(&coresight_mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(coresight_enable);
+
+void coresight_disable(struct coresight_device *csdev)
+{
+	LIST_HEAD(path);
+
+	if (IS_ERR_OR_NULL(csdev))
+		return;
+
+	down(&coresight_mutex);
+	if (csdev->type != CORESIGHT_DEV_TYPE_SOURCE) {
+		pr_err("coresight: wrong device type in %s\n", __func__);
+		goto out;
+	}
+	if (!csdev->enable)
+		goto out;
+
+	coresight_build_path(csdev, &path);
+	coresight_disable_path(&path, true);
+	coresight_release_path(&path);
+out:
+	up(&coresight_mutex);
+}
+EXPORT_SYMBOL_GPL(coresight_disable);
+
+void coresight_abort(void)
+{
+	struct coresight_device *cd;
+
+	if (down_trylock(&coresight_mutex)) {
+		pr_err("coresight: abort could not be processed\n");
+		return;
+	}
+	if (curr_sink == NO_SINK)
+		goto out;
+
+	list_for_each_entry(cd, &coresight_devs, dev_link) {
+		if (cd->id == curr_sink) {
+			if (cd->enable && cd->ops->sink_ops->abort) {
+				cd->ops->sink_ops->abort(cd);
+				cd->enable = false;
+			}
+		}
+	}
+out:
+	up(&coresight_mutex);
+}
+EXPORT_SYMBOL_GPL(coresight_abort);
+
+static ssize_t debugfs_curr_sink_get(void *data, u64 *val)
+{
+	struct coresight_device *csdev = data;
+
+	*val = (csdev->id == curr_sink) ? 1 : 0;
+	return 0;
+}
+
+static ssize_t debugfs_curr_sink_set(void *data, u64 val)
+{
+	struct coresight_device *csdev = data;
+
+	if (val)
+		return coresight_switch_sink(csdev);
+	else
+		return -EINVAL;
+}
+CORESIGHT_DEBUGFS_ENTRY(debugfs_curr_sink, "curr_sink",
+			S_IRUGO | S_IWUSR, debugfs_curr_sink_get,
+			debugfs_curr_sink_set, "%llu\n");
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
+			debugfs_enable_set, "%llu\n");
+
+
+static const struct coresight_ops_entry *coresight_grps_sink[] = {
+	&debugfs_curr_sink_entry,
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
+			return -1;
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
+struct coresight_device *coresight_register(struct coresight_desc *desc)
+{
+	int i;
+	int ret;
+	int link_subtype;
+	int nr_refcnts;
+	int *refcnts = NULL;
+	struct coresight_device *csdev;
+	struct coresight_connection *conns;
+
+	if (IS_ERR_OR_NULL(desc))
+		return ERR_PTR(-EINVAL);
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
+	    desc->type == CORESIGHT_DEV_TYPE_LINKSINK) {
+		link_subtype = desc->subtype.link_subtype;
+		if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_MERG)
+			nr_refcnts = desc->pdata->nr_inports;
+		else if (link_subtype == CORESIGHT_DEV_SUBTYPE_LINK_SPLIT)
+			nr_refcnts = desc->pdata->nr_outports;
+		else
+			nr_refcnts = 1;
+
+		refcnts = kzalloc(sizeof(*refcnts) * nr_refcnts, GFP_KERNEL);
+		if (!refcnts) {
+			ret = -ENOMEM;
+			goto err_kzalloc_refcnts;
+		}
+		csdev->refcnt.link_refcnts = refcnts;
+	}
+
+	csdev->nr_conns = desc->pdata->nr_outports;
+	conns = kzalloc(sizeof(*conns) * csdev->nr_conns, GFP_KERNEL);
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
+	down(&coresight_mutex);
+	if (desc->pdata->default_sink) {
+		if (curr_sink == NO_SINK) {
+			curr_sink = csdev->id;
+		} else {
+			ret = -EINVAL;
+			goto err_default_sink;
+		}
+	}
+
+	coresight_fixup_device_conns(csdev);
+
+	debugfs_coresight_init();
+	csdev->de = coresight_debugfs_desc_init(csdev, desc->debugfs_ops);
+
+	coresight_fixup_orphan_conns(csdev);
+
+	list_add_tail(&csdev->dev_link, &coresight_devs);
+	up(&coresight_mutex);
+
+	return csdev;
+
+err_default_sink:
+	up(&coresight_mutex);
+	kfree(conns);
+err_kzalloc_conns:
+	kfree(refcnts);
+err_kzalloc_refcnts:
+	kfree(csdev);
+err_kzalloc_csdev:
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(coresight_register);
+
+void coresight_unregister(struct coresight_device *csdev)
+{
+	if (IS_ERR_OR_NULL(csdev))
+		return;
+
+	down(&coresight_mutex);
+
+	list_del(&csdev->dev_link);
+	debugfs_remove_recursive(csdev->de);
+	kfree(csdev->conns);
+	kfree(csdev->refcnt.link_refcnts);
+	if (list_empty(&coresight_devs))
+		kfree(cs_debugfs_parent);
+
+	up(&coresight_mutex);
+}
+EXPORT_SYMBOL_GPL(coresight_unregister);
+
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/coresight/of_coresight.c b/drivers/coresight/of_coresight.c
new file mode 100644
index 0000000..e0cb6a3
--- /dev/null
+++ b/drivers/coresight/of_coresight.c
@@ -0,0 +1,207 @@
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
+/* Returns the base address found in @node. Seriously
+ * tailored on @of_device_make_bus_id().
+ */
+static u32 of_get_coresight_id(struct device_node *node)
+{
+	u32 addr = 0;
+	const __be32 *reg, *addrp;
+
+	reg = of_get_property(node, "reg", NULL);
+	if (reg) {
+		if (of_can_translate_address(node)) {
+			addr = of_translate_address(node, reg);
+		} else {
+			addrp = of_get_address(node, 0, NULL, NULL);
+			if (addrp)
+				addr = of_read_ulong(addrp, 1);
+			else
+				addr = 0;
+		}
+	}
+
+	return addr;
+}
+
+static struct device_node *of_get_coresight_endpoint(
+		const struct device_node *parent, struct device_node *prev)
+{
+	struct device_node *node = of_graph_get_next_endpoint(parent, prev);
+	of_node_put(prev);
+	return node;
+}
+
+static bool of_coresight_is_input_port(struct device_node *port)
+{
+	if (of_find_property(port, "slave-mode", NULL))
+		return true;
+	else
+		return false;
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
+		of_coresight_is_input_port(ep) ? in++ : out++;
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
+	u32 id;
+	int i = 0, ret = 0;
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
+	id = of_get_coresight_id(node);
+	if (id == 0)
+		return  ERR_PTR(-EINVAL);
+
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
+			return ERR_PTR(-ENOMEM);
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
+			if (of_coresight_is_input_port(ep))
+				continue;
+
+			/* get a handle on the local endpoint */
+			ret = of_graph_parse_endpoint(ep, &endpoint);
+
+			if (!ret) {
+				/* the local out port number */
+				*(u32 *)&pdata->outports[i] = endpoint.id;
+
+				/* get a handle the remote port and parent
+				 * attached to it.
+				 */
+				rparent = of_graph_get_remote_port_parent(ep);
+				rport = of_graph_get_remote_port(ep);
+
+				if (!rparent || !rport)
+					continue;
+
+				if (of_graph_parse_endpoint(rport,
+							     &rendpoint))
+					continue;
+
+				*(u32 *)&pdata->child_ids[i] =
+					of_get_coresight_id(rparent);
+				*(u32 *)&pdata->child_ports[i] = rendpoint.id;
+
+				i++;
+			}
+
+		} while (ep);
+	}
+
+	pdata->default_sink = of_property_read_bool(node,
+						    "coresight-default-sink");
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
index 0000000..a19420e
--- /dev/null
+++ b/include/linux/coresight.h
@@ -0,0 +1,190 @@
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
+#define CORESIGHT_PERIPHIDR4	(0xFD0)
+#define CORESIGHT_PERIPHIDR5	(0xFD4)
+#define CORESIGHT_PERIPHIDR6	(0xFD8)
+#define CORESIGHT_PERIPHIDR7	(0xFDC)
+#define CORESIGHT_PERIPHIDR0	(0xFE0)
+#define CORESIGHT_PERIPHIDR1	(0xFE4)
+#define CORESIGHT_PERIPHIDR2	(0xFE8)
+#define CORESIGHT_PERIPHIDR3	(0xFEC)
+/* Component id registers (0xFF0-0xFFC) */
+#define CORESIGHT_COMPIDR0	(0xFF0)
+#define CORESIGHT_COMPIDR1	(0xFF4)
+#define CORESIGHT_COMPIDR2	(0xFF8)
+#define CORESIGHT_COMPIDR3	(0xFFC)
+
+#define ETM_ARCH_V3_3		(0x23)
+#define ETM_ARCH_V3_5		(0x25)
+#define PFT_ARCH_V1_1		(0x31)
+
+#define CORESIGHT_UNLOCK	(0xC5ACCE55)
+
+enum coresight_clk_rate {
+	CORESIGHT_CLK_RATE_OFF,
+	CORESIGHT_CLK_RATE_TRACE,
+	CORESIGHT_CLK_RATE_HSTRACE,
+};
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
+struct coresight_ops_entry {
+	const char *name;
+	umode_t mode;
+	const struct file_operations *ops;
+};
+
+struct coresight_dev_subtype {
+	enum coresight_dev_subtype_sink sink_subtype;
+	enum coresight_dev_subtype_link link_subtype;
+	enum coresight_dev_subtype_source source_subtype;
+};
+
+struct coresight_platform_data {
+	int id;
+	int cpu;
+	const char *name;
+	int nr_inports;
+	const int *outports;
+	const int *child_ids;
+	const int *child_ports;
+	int nr_outports;
+	bool default_sink;
+	struct clk *clk;
+};
+
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
+struct coresight_connection {
+	int outport;
+	int child_id;
+	int child_port;
+	struct coresight_device *child_dev;
+	struct list_head link;
+};
+
+struct coresight_refcnt {
+	int sink_refcnt;
+	int *link_refcnts;
+	int source_refcnt;
+};
+
+struct coresight_device {
+	int id;
+	struct coresight_connection *conns;
+	int nr_conns;
+	enum coresight_dev_type type;
+	struct coresight_dev_subtype subtype;
+	const struct coresight_ops *ops;
+	struct dentry *de;
+	struct device dev;
+	struct coresight_refcnt refcnt;
+	struct list_head dev_link;
+	struct list_head path_link;
+	struct module *owner;
+	bool enable;
+};
+
+#define to_coresight_device(d) container_of(d, struct coresight_device, dev)
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
+struct coresight_ops_sink {
+	int (*enable)(struct coresight_device *csdev);
+	void (*disable)(struct coresight_device *csdev);
+	void (*abort)(struct coresight_device *csdev);
+};
+
+struct coresight_ops_link {
+	int (*enable)(struct coresight_device *csdev, int iport, int oport);
+	void (*disable)(struct coresight_device *csdev, int iport, int oport);
+};
+
+struct coresight_ops_source {
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
+extern void coresight_abort(void);
+extern struct clk *coresight_get_clk(void);
+#else
+static inline struct coresight_device *
+coresight_register(struct coresight_desc *desc) { return NULL; }
+static inline void coresight_unregister(struct coresight_device *csdev) {}
+static inline int
+coresight_enable(struct coresight_device *csdev) { return -ENOSYS; }
+static inline void coresight_disable(struct coresight_device *csdev) {}
+static inline void coresight_abort(void) {}
+extern struct clk *coresight_get_clk(void) {};
+#endif
+
+#endif
diff --git a/include/linux/of_coresight.h b/include/linux/of_coresight.h
new file mode 100644
index 0000000..6a5e4d4
--- /dev/null
+++ b/include/linux/of_coresight.h
@@ -0,0 +1,27 @@
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
+#ifndef __LINUX_OF_CORESIGHT_H
+#define __LINUX_OF_CORESIGHT_H
+
+#ifdef CONFIG_OF
+extern struct coresight_platform_data *of_get_coresight_platform_data(
+				struct device *dev, struct device_node *node);
+#else
+static inline struct coresight_platform_data *of_get_coresight_platform_data(
+				struct device *dev, struct device_node *node)
+{
+	return NULL;
+}
+#endif
+
+#endif
-- 
1.9.1

