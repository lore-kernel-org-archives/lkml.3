Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab3LAG25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:28:57 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:51648 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab3LAG2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:28:54 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Landley <rob@landley.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH 08/11] misc: support for parallel slots in LP-8x4x
Date: Sun,  1 Dec 2013 10:26:21 +0400
Message-Id: <1385879185-22455-9-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enumerates parallel modules in expansion slots and exposes
model numbers via sysfs.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 Documentation/misc-devices/lp8x4x_bus.txt |   8 ++
 arch/arm/mach-pxa/include/mach/lp8x4x.h   |   8 ++
 arch/arm/mach-pxa/lp8x4x.c                |  42 +++++++++-
 drivers/misc/lp8x4x_bus.c                 | 127 ++++++++++++++++++++++++++++++
 4 files changed, 184 insertions(+), 1 deletion(-)

diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index d9a069d..9285fdc 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -28,6 +28,9 @@ into the device, they could be accessed using the 2nd PXA built-in UART port
 (/dev/ttySA1). However, it seems that addresses are not processed by
 the modules. So the parallel bus needs to select which slot is connected.
 
+Parallel modules allow much faster communication. There are accessed using
+IO memory through the FPGA. Their ports are exposed via sysfs.
+
 SYSFS
 -----
 
@@ -41,3 +44,8 @@ active_slot
 	     is a parallel module in the selected slot, it simply ignores
 	     incoming packets. So it is safe to activate any available
 	     slot.
+
+/sys/bus/icpdas/devices/slot%02i:
+
+model
+	RO - shows expansion module model number
diff --git a/arch/arm/mach-pxa/include/mach/lp8x4x.h b/arch/arm/mach-pxa/include/mach/lp8x4x.h
index 9addfa8..e1005c5 100644
--- a/arch/arm/mach-pxa/include/mach/lp8x4x.h
+++ b/arch/arm/mach-pxa/include/mach/lp8x4x.h
@@ -37,6 +37,14 @@
 
 /* board level registers in the FPGA */
 
+#define LP8X4X_SLOT1_IO		0x17001000
+#define LP8X4X_SLOT2_IO		0x17002000
+#define LP8X4X_SLOT3_IO		0x17003000
+#define LP8X4X_SLOT4_IO		0x17004000
+#define LP8X4X_SLOT5_IO		0x17005000
+#define LP8X4X_SLOT6_IO		0x17006000
+#define LP8X4X_SLOT7_IO		0x17007000
+#define LP8X4X_SLOT8_IO		0x17008000
 #define LP8X4X_SLOT_SWITCH	0x17009004
 #define LP8X4X_EOI		LP8X4X_P2V(0x17009006)
 #define LP8X4X_INSINT		LP8X4X_P2V(0x17009008)
diff --git a/arch/arm/mach-pxa/lp8x4x.c b/arch/arm/mach-pxa/lp8x4x.c
index b30343d..ae84d36 100644
--- a/arch/arm/mach-pxa/lp8x4x.c
+++ b/arch/arm/mach-pxa/lp8x4x.c
@@ -429,6 +429,46 @@ static struct resource lp8x4x_bus_resources[] = {
 		.end    = LP8X4X_SLOT_SWITCH,
 		.flags  = IORESOURCE_MEM,
 	},
+	[2] = {
+		.start  = LP8X4X_SLOT1_IO,
+		.end    = LP8X4X_SLOT1_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
+	[3] = {
+		.start  = LP8X4X_SLOT2_IO,
+		.end    = LP8X4X_SLOT2_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
+	[4] = {
+		.start  = LP8X4X_SLOT3_IO,
+		.end    = LP8X4X_SLOT3_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
+	[5] = {
+		.start  = LP8X4X_SLOT4_IO,
+		.end    = LP8X4X_SLOT4_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
+	[6] = {
+		.start  = LP8X4X_SLOT5_IO,
+		.end    = LP8X4X_SLOT5_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
+	[7] = {
+		.start  = LP8X4X_SLOT6_IO,
+		.end    = LP8X4X_SLOT6_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
+	[8] = {
+		.start  = LP8X4X_SLOT7_IO,
+		.end    = LP8X4X_SLOT7_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
+	[9] = {
+		.start  = LP8X4X_SLOT8_IO,
+		.end    = LP8X4X_SLOT8_IO + 15,
+		.flags  = IORESOURCE_MEM,
+	},
 };
 
 static struct platform_device lp8x4x_bus_device[] = {
@@ -436,7 +476,7 @@ static struct platform_device lp8x4x_bus_device[] = {
 		.name           = "lp8x4x-bus",
 		.id             = 0,
 		.resource = &lp8x4x_bus_resources[0],
-		.num_resources = 2,
+		.num_resources = 10,
 	},
 };
 
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 647fde7..b2d4a04 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -24,14 +24,57 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sergei Ianovich <ynvich@gmail.com>");
 MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 
+struct lp8x4x_slot {
+	void			*data_addr;
+	unsigned int		model;
+	struct device		dev;
+};
+
+#define LP8X4X_MAX_SLOT_COUNT	8
 struct lp8x4x_master {
 	unsigned int		slot_count;
 	void			*count_addr;
 	unsigned int		active_slot;
 	void			*switch_addr;
+	struct lp8x4x_slot	slot[LP8X4X_MAX_SLOT_COUNT];
 	struct device		dev;
 };
 
+static unsigned char lp8x4x_model[256] = {
+	   0,    0,    0, 0x11,    0, 0x18, 0x13, 0x11,
+	0x0e, 0x11,    0,    0,    0, 0x5a, 0x5b, 0x5c,
+	0x3c, 0x44, 0x34, 0x3a, 0x39, 0x36, 0x37, 0x33,
+	0x35, 0x40, 0x41, 0x42, 0x38, 0x3f, 0x32, 0x45,
+	0xac, 0x70, 0x8e, 0x8e, 0x1e, 0x72, 0x90, 0x29,
+	0x4a, 0x22, 0xd3, 0xd2, 0x28, 0x25, 0x2a, 0x29,
+	0x48, 0x49, 0x5d, 0x1f, 0x20, 0x23, 0x24, 0x4d,
+	0x3d, 0x3e,    0,    0,    0,    0,    0,    0,
+	   0, 0x78, 0x72, 0x2b, 0x5e, 0x5e, 0x36, 0xae,
+	0x30,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0, 0x5c, 0x5e,    0, 0x5e,    0,    0,
+	   0, 0x3b,    0,    0,    0,    0,    0,    0,
+	   0, 0x50, 0x2e,    0, 0x58,    0,    0, 0x43,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0, 0x54,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0,
+	   0,    0,    0,    0,    0,    0,    0,    0
+};
+
 static int lp8x4x_match(struct device *dev, struct device_driver *drv)
 {
 	return 1;
@@ -42,6 +85,26 @@ static struct bus_type lp8x4x_bus_type = {
 	.match		= lp8x4x_match,
 };
 
+static void lp8x4x_slot_release(struct device *dev)
+{
+}
+
+static ssize_t model_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_slot *s = container_of(dev, struct lp8x4x_slot, dev);
+
+	return sprintf(buf, "%u\n", s->model + 8000);
+}
+
+static DEVICE_ATTR_RO(model);
+
+static struct attribute *slot_dev_attrs[] = {
+	&dev_attr_model.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(slot_dev);
+
 static void lp8x4x_master_release(struct device *dev)
 {
 	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
@@ -107,10 +170,18 @@ ATTRIBUTE_GROUPS(master_dev);
 static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 {
 	struct lp8x4x_master *m = *(struct lp8x4x_master **)res;
+	struct lp8x4x_slot *s;
 	void *mem = m->count_addr;
 	void *mem2 = m->switch_addr;
+	int i;
 
 	dev_info(dev, "releasing devices\n");
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		s = &m->slot[i];
+		if (s->model)
+			device_unregister(&s->dev);
+		iounmap(s->data_addr);
+	}
 	device_unregister(&m->dev);
 	bus_unregister(&lp8x4x_bus_type);
 
@@ -120,11 +191,36 @@ static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 	iounmap(mem);
 }
 
+static void __init lp8x4x_bus_probe_slot(struct lp8x4x_master *m, int i,
+		unsigned char model)
+{
+	struct lp8x4x_slot *s = &m->slot[i];
+	int err;
+
+	dev_info(&m->dev, "found %u in slot %i\n", 8000 + model, i + 1);
+
+	s->dev.bus = &lp8x4x_bus_type;
+	dev_set_name(&s->dev, "slot%02i", i + 1);
+	s->dev.parent = &m->dev;
+	s->dev.release = lp8x4x_slot_release;
+	s->dev.groups = slot_dev_groups;
+	s->model = model;
+
+	err = device_register(&s->dev);
+	if (err < 0) {
+		dev_err(&s->dev, "failed to register device\n");
+		s->model = 0;
+		return;
+	}
+}
+
 static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 {
 	struct lp8x4x_master *m, **p;
 	struct resource *res;
+	int i;
 	int err = 0;
+	unsigned int model;
 
 	m = kzalloc(sizeof(*m), GFP_KERNEL);
 	if (!m)
@@ -167,6 +263,30 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 		goto err3;
 	}
 
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i + 2);
+		if (!res) {
+			dev_err(&pdev->dev, "Failed to get slot %i address\n",
+					i);
+			err = -ENODEV;
+			goto err4;
+		}
+
+		m->slot[i].data_addr = ioremap(res->start, resource_size(res));
+		if (!m->slot[i].data_addr) {
+			dev_err(&pdev->dev, "Failed to ioremap %p\n",
+					m->slot[i].data_addr);
+			err = -EFAULT;
+			goto err4;
+		}
+		continue;
+err4:
+		for (i--; i >= 0; i--)
+			iounmap(m->slot[i].data_addr);
+
+		goto err3;
+	}
+
 	m->slot_count = ioread8(m->count_addr);
 	switch (m->slot_count) {
 	case 1:
@@ -205,6 +325,13 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	}
 
 	devres_add(&pdev->dev, p);
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		model = lp8x4x_model[ioread8(m->slot[i].data_addr)];
+		if (!model)
+			continue;
+
+		lp8x4x_bus_probe_slot(m, i, model);
+	}
 	return 0;
 
 err_dev:
-- 
1.8.4.2

