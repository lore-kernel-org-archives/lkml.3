Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3HGK07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:26:59 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56419 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab3HGK0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:26:54 -0400
Date: Wed, 7 Aug 2013 12:20:15 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 16/26] x86 STA2X11 platform: add sta2x11_platform_init()
Message-ID: <bb52ae56c1148e8b19337859e8ebfb69f0737e41.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds an init function which looks for connext nodes in the
device tree (compatible "pci104a,cc17") and creates a list of sta2x11
related data structures (struct sta2x11_instance_data). For each sta2x11,
the relevant four platform devices are also created (scr, apbreg,
apb-soc-regs, sctl).
Finally, of_match_tables are added to the four struct platform_driver.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/include/asm/sta2x11.h      |   17 +++++-
 arch/x86/platform/sta2x11/sta2x11.c |  111 ++++++++++++++++++++++++++++++++++-
 2 files changed, 125 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
index cd76923..30dd761 100644
--- a/arch/x86/include/asm/sta2x11.h
+++ b/arch/x86/include/asm/sta2x11.h
@@ -21,7 +21,7 @@
 #define __ASM_STA2X11_H
 
 #include <linux/types.h>
-#include <linux/pci.h>
+#include <linux/of.h>
 
 enum sta2x11_plat_dev {
 	sta2x11_sctl = 0,
@@ -34,6 +34,21 @@ enum sta2x11_plat_dev {
 	sta2x11_n_plat_devs,
 };
 
+/*
+ * Data structure representing a connext instance.
+ */
+struct sta2x11_instance_data {
+	/* Instance id */
+	int id;
+	/* Registers data */
+	struct sta2x11_platform_drv_data *sctl;
+	struct sta2x11_platform_drv_data *scr;
+	struct sta2x11_platform_drv_data *apbreg;
+	struct sta2x11_platform_drv_data *apb_soc_regs;
+	/* Do not touch this from outside arch/x86/platform/sta2x11/sta2x11.c */
+	struct list_head list;
+};
+
 #define STA2X11_SCTL_NAME		"sta2x11-sctl"
 #define STA2X11_GPIO_NAME		"sta2x11-gpio"
 #define STA2X11_SCR_NAME		"sta2x11-scr"
diff --git a/arch/x86/platform/sta2x11/sta2x11.c b/arch/x86/platform/sta2x11/sta2x11.c
index ab3bc62..936a7ab 100644
--- a/arch/x86/platform/sta2x11/sta2x11.c
+++ b/arch/x86/platform/sta2x11/sta2x11.c
@@ -30,9 +30,14 @@
 #include <linux/seq_file.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/list.h>
+#include <linux/of_pci.h>
+#include <linux/of_platform.h>
 
 #include <asm/sta2x11.h>
 
+static LIST_HEAD(connext_instances);
+
 static inline int __reg_within_range(unsigned int r,
 				     unsigned int start,
 				     unsigned int end)
@@ -213,10 +218,16 @@ static int sta2x11_scr_probe(struct platform_device *dev)
 }
 
 /* The three platform drivers */
+static const struct of_device_id sctl_ids[] = {
+	{ .compatible = "st,sta2x11-sctl" },
+	{}
+};
+
 static struct platform_driver sta2x11_sctl_platform_driver = {
 	.driver = {
 		.name	= STA2X11_SCTL_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = sctl_ids,
 	},
 	.probe		= sta2x11_sctl_probe,
 };
@@ -227,10 +238,16 @@ static int __init sta2x11_sctl_init(void)
 	return platform_driver_register(&sta2x11_sctl_platform_driver);
 }
 
-static struct platform_driver sta2x11_platform_driver = {
+static const struct of_device_id apbreg_ids[] = {
+	{ .compatible = "st,sta2x11-apb-regs" },
+	{}
+};
+
+static struct platform_driver sta2x11_apbreg_platform_driver = {
 	.driver = {
 		.name	= STA2X11_APBREG_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = apbreg_ids
 	},
 	.probe		= sta2x11_apbreg_probe,
 };
@@ -238,13 +255,19 @@ static struct platform_driver sta2x11_platform_driver = {
 static int __init sta2x11_apbreg_init(void)
 {
 	pr_info("%s\n", __func__);
-	return platform_driver_register(&sta2x11_platform_driver);
+	return platform_driver_register(&sta2x11_apbreg_platform_driver);
 }
 
+static const struct of_device_id apb_soc_regs_ids[] = {
+	{ .compatible = "st,sta2x11-apb-soc-regs" },
+	{}
+};
+
 static struct platform_driver sta2x11_apb_soc_regs_platform_driver = {
 	.driver = {
 		.name	= STA2X11_APB_SOC_REGS_NAME,
 		.owner	= THIS_MODULE,
+		.of_match_table = apb_soc_regs_ids,
 	},
 	.probe		= sta2x11_apb_soc_regs_probe,
 };
@@ -255,10 +278,16 @@ static int __init sta2x11_apb_soc_regs_init(void)
 	return platform_driver_register(&sta2x11_apb_soc_regs_platform_driver);
 }
 
+static const struct of_device_id scr_ids[] = {
+	{ .compatible = "st,sta2x11-scr" },
+	{}
+};
+
 static struct platform_driver sta2x11_scr_platform_driver = {
 	.driver = {
 		.name = STA2X11_SCR_NAME,
 		.owner = THIS_MODULE,
+		.of_match_table = scr_ids,
 	},
 	.probe = sta2x11_scr_probe,
 };
@@ -269,10 +298,88 @@ static int __init sta2x11_scr_init(void)
 	return platform_driver_register(&sta2x11_scr_platform_driver);
 }
 
+
+static struct platform_device *
+do_create(const char *c, struct device_node *from,
+	  struct sta2x11_instance_data *idata)
+{
+	struct device_node *n;
+	struct platform_device *out = NULL;
+	int name_size;
+	char *name;
+
+	n = of_find_compatible_node(of_node_get(from), NULL, c);
+	if (!n)
+		return out;
+	/* %s.%1d */
+	name_size = strlen(n->name) + 3;
+	name = kzalloc(name_size, GFP_KERNEL);
+	if (!name)
+		return out;
+	snprintf(name, name_size, "%s.%1d", n->name, idata->id);
+
+	out = of_platform_device_create(n, name, NULL);
+	of_node_put(n);
+
+	if (!out) {
+		kfree(name);
+		return out;
+	}
+	/*
+	  Avoid the node to be re-instantiated later on
+	  by the pci-amba bridge
+	*/
+	of_detach_node(n);
+	return out;
+}
+
+static int new_connext(struct device_node *from,
+		       struct sta2x11_instance_data *idata)
+{
+	int i;
+	/* Create platform devices belonging to this connext instance */
+	const char *devs[] = {
+		"st,sta2x11-scr",
+		"st,sta2x11-apb-soc-regs",
+		"st,sta2x11-apb-regs",
+		"st,sta2x11-sctl",
+	};
+	for (i = 0; i < ARRAY_SIZE(devs); i++)
+		WARN_ON(!do_create(devs[i], from, idata));
+	return 0;
+}
+
+static int __init sta2x11_platform_init(void)
+{
+	struct device_node *n;
+	int ret = 0, stat;
+	struct sta2x11_instance_data *idata;
+	struct resource r;
+
+	for_each_compatible_node(n, NULL, "pci104a,cc17") {
+		if (of_pci_parse_bus_range(of_node_get(n), &r) < 0) {
+			ret = -EINVAL;
+			continue;
+		}
+		idata = kzalloc(sizeof(*idata), GFP_KERNEL);
+		if (!idata) {
+			ret = -ENOMEM;
+			continue;
+		}
+		idata->id = r.start + 1;
+		list_add(&idata->list, &connext_instances);
+		stat = new_connext(n, idata);
+		if (stat < 0)
+			ret = stat;
+	}
+	return ret;
+}
+
 subsys_initcall(sta2x11_apbreg_init);
 subsys_initcall(sta2x11_sctl_init);
 subsys_initcall(sta2x11_apb_soc_regs_init);
 subsys_initcall(sta2x11_scr_init);
+rootfs_initcall(sta2x11_platform_init);
 
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Wind River");
-- 
1.7.7.2
