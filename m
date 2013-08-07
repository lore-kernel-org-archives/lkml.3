Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757Ab3HGK1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:27:08 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56426 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932701Ab3HGK1E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:27:04 -0400
Date: Wed, 7 Aug 2013 12:20:26 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 17/26] x86 STA2X11 platform: add sta2x11_instance_data
 helpers
Message-ID: <1c8d5fd1f37f1df891e027d83b8713702ab1a998.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds functions to get a pointer to a sta2x11 instance data
structure given a pointer to a connext device or device node.
Such helpers will be used by the (now empty) common probe function,
and maybe by the common clock framework.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/include/asm/sta2x11.h      |   13 ++++++++
 arch/x86/platform/sta2x11/sta2x11.c |   55 ++++++++++++++++++++++++++++++++++-
 2 files changed, 67 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/sta2x11.h b/arch/x86/include/asm/sta2x11.h
index 30dd761..6df0c87 100644
--- a/arch/x86/include/asm/sta2x11.h
+++ b/arch/x86/include/asm/sta2x11.h
@@ -49,6 +49,19 @@ struct sta2x11_instance_data {
 	struct list_head list;
 };
 
+/*
+ * Helper functions: get the pointer to a sta2x11 instance given the pointer
+ * to a device/device node belonging to a connext chip
+ */
+extern struct sta2x11_instance_data *
+sta2x11_node_to_instance(struct device_node *);
+
+static inline
+struct sta2x11_instance_data *sta2x11_dev_to_instance(struct device *dev)
+{
+	return sta2x11_node_to_instance(dev->of_node);
+}
+
 #define STA2X11_SCTL_NAME		"sta2x11-sctl"
 #define STA2X11_GPIO_NAME		"sta2x11-gpio"
 #define STA2X11_SCR_NAME		"sta2x11-scr"
diff --git a/arch/x86/platform/sta2x11/sta2x11.c b/arch/x86/platform/sta2x11/sta2x11.c
index 936a7ab..861d447 100644
--- a/arch/x86/platform/sta2x11/sta2x11.c
+++ b/arch/x86/platform/sta2x11/sta2x11.c
@@ -189,7 +189,60 @@ sta2x11_platform_regmap_configs[sta2x11_n_plat_devs] = {
 	[sta2x11_scr] = &sta2x11_scr_regmap_config,
 };
 
-/* Probe for the four platform devices */
+static struct sta2x11_instance_data *find_instance(int id)
+{
+	struct sta2x11_instance_data *ptr;
+	list_for_each_entry(ptr, &connext_instances, list)
+		if (ptr->id == id)
+			return ptr;
+	return NULL;
+}
+
+static struct sta2x11_instance_data
+*connext_node_to_instance(struct device_node *n)
+{
+	struct resource r;
+	if (of_pci_parse_bus_range(n, &r) < 0)
+		return NULL;
+	return find_instance(r.start + 1);
+}
+
+struct sta2x11_instance_data *sta2x11_node_to_instance(struct device_node *n)
+{
+	struct device_node *amba_bus, *pci_amba_bridge, *connext_node = NULL,
+		*parent;
+
+	if (!of_node_cmp(n->type, "pci")) {
+		/* A pci node */
+		for (parent = n->parent; parent; parent = parent->parent) {
+			if (of_device_is_compatible(parent, "pci104a,cc17")) {
+				connext_node = parent;
+				break;
+			}
+		}
+		if (!connext_node)
+			return NULL;
+		return connext_node_to_instance(connext_node);
+	}
+
+	/* An amba or platform device (or even an amba bus node) */
+	amba_bus = n;
+	if (!of_device_is_compatible(n, "arm,amba-bus"))
+		amba_bus = n->parent;
+	if (!amba_bus || !of_device_is_compatible(amba_bus, "arm,amba-bus"))
+		return NULL;
+	pci_amba_bridge = amba_bus->parent;
+	if (!pci_amba_bridge || !of_device_is_compatible(pci_amba_bridge,
+							 "pci104a,cc18"))
+		return NULL;
+	connext_node = pci_amba_bridge->parent;
+	if (!connext_node ||
+	    !of_device_is_compatible(connext_node, "pci104a,cc17.0"))
+		return NULL;
+	return connext_node_to_instance(connext_node);
+}
+EXPORT_SYMBOL(sta2x11_node_to_instance);
+
 
 static int sta2x11_platform_probe(struct platform_device *dev,
 				  enum sta2x11_plat_dev index)
-- 
1.7.7.2
