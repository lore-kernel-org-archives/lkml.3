Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab3LMCac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:30:32 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:40485 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3LMCa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:30:28 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v2 13/16] misc: support for parallel slots in LP-8x4x
Date: Fri, 13 Dec 2013 06:27:22 +0400
Message-Id: <1386901645-28895-14-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enumerates parallel modules in expansion slots and exposes
model numbers via sysfs.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
   v0..v2
   * use device tree
   * use devm helpers where possible

 Documentation/misc-devices/lp8x4x_bus.txt |   8 ++
 drivers/misc/lp8x4x_bus.c                 | 120 ++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+)

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
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index cffe121..324e922 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -21,14 +21,57 @@ MODULE_LICENSE("GPL");
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
@@ -39,6 +82,26 @@ static struct bus_type lp8x4x_bus_type = {
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
@@ -104,8 +167,15 @@ ATTRIBUTE_GROUPS(master_dev);
 static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 {
 	struct lp8x4x_master *m = *(struct lp8x4x_master **)res;
+	struct lp8x4x_slot *s;
+	int i;
 
 	dev_dbg(dev, "releasing devices\n");
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		s = &m->slot[i];
+		if (s->model)
+			device_unregister(&s->dev);
+	}
 	device_unregister(&m->dev);
 	bus_unregister(&lp8x4x_bus_type);
 
@@ -113,11 +183,36 @@ static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 	iowrite8(0xff, m->switch_addr);
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
@@ -160,6 +255,24 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 		goto err_free;
 	}
 
+	for (i = 0; i < LP8X4X_MAX_SLOT_COUNT; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i + 2);
+		if (!res) {
+			dev_err(&pdev->dev, "Failed to get slot %i address\n",
+					i);
+			err = -ENODEV;
+			goto err_free;
+		}
+
+		m->slot[i].data_addr = devm_ioremap_resource(&pdev->dev, res);
+		if (!m->slot[i].data_addr) {
+			dev_err(&pdev->dev, "Failed to ioremap %p\n",
+					m->slot[i].data_addr);
+			err = -EFAULT;
+			goto err_free;
+		}
+	}
+
 	m->slot_count = ioread8(m->count_addr);
 	switch (m->slot_count) {
 	case 1:
@@ -198,6 +311,13 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
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
 
 err_bus:
-- 
1.8.4.3

