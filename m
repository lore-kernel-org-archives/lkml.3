Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab3LAG2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 01:28:51 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:39473 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab3LAG2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 01:28:46 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Landley <rob@landley.net>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH 07/11] misc: support for serial slots in LP-8x4x
Date: Sun,  1 Dec 2013 10:26:20 +0400
Message-Id: <1385879185-22455-8-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serial modules (I-870xxW series) implement DCON protocol which
allows one-master-many-slaves configuration over RS-485. When
these modules are installed into the device, they could be
accessed using the 2nd PXA built-in UART port (/dev/ttySA1).
However, it seems that addresses are not processed by the modules.
So the parallel bus needs to select which slot is connected.

Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
---
 Documentation/misc-devices/lp8x4x_bus.txt | 15 ++++++-
 arch/arm/mach-pxa/include/mach/lp8x4x.h   |  1 +
 arch/arm/mach-pxa/lp8x4x.c                |  7 ++-
 drivers/misc/lp8x4x_bus.c                 | 73 +++++++++++++++++++++++++++++--
 4 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/Documentation/misc-devices/lp8x4x_bus.txt b/Documentation/misc-devices/lp8x4x_bus.txt
index f5392b3..d9a069d 100644
--- a/Documentation/misc-devices/lp8x4x_bus.txt
+++ b/Documentation/misc-devices/lp8x4x_bus.txt
@@ -19,7 +19,14 @@ LP-8x4x is an ARM-based industrial computer with a custom parallel bus to
 connect expansion modules with digital input/output, analog input/output,
 serial, CAN and other types of ports.
 
-The bus is implemented by a FPGA.
+The bus is implemented by a FPGA. There are two major groups of expansion
+modules: serial and parallel.
+
+Serial modules (I-870xxW series) implement DCON protocol which allows one-
+master-many-slaves configuration over RS-485. When these modules are installed
+into the device, they could be accessed using the 2nd PXA built-in UART port
+(/dev/ttySA1). However, it seems that addresses are not processed by
+the modules. So the parallel bus needs to select which slot is connected.
 
 SYSFS
 -----
@@ -28,3 +35,9 @@ SYSFS
 
 slot_count
 	RO - shows total number of expansion slots on the device
+
+active_slot
+	RW - connects the select slot for serial communications. If there
+	     is a parallel module in the selected slot, it simply ignores
+	     incoming packets. So it is safe to activate any available
+	     slot.
diff --git a/arch/arm/mach-pxa/include/mach/lp8x4x.h b/arch/arm/mach-pxa/include/mach/lp8x4x.h
index 5d289bf..9addfa8 100644
--- a/arch/arm/mach-pxa/include/mach/lp8x4x.h
+++ b/arch/arm/mach-pxa/include/mach/lp8x4x.h
@@ -37,6 +37,7 @@
 
 /* board level registers in the FPGA */
 
+#define LP8X4X_SLOT_SWITCH	0x17009004
 #define LP8X4X_EOI		LP8X4X_P2V(0x17009006)
 #define LP8X4X_INSINT		LP8X4X_P2V(0x17009008)
 #define LP8X4X_ENSYSINT		LP8X4X_P2V(0x1700900A)
diff --git a/arch/arm/mach-pxa/lp8x4x.c b/arch/arm/mach-pxa/lp8x4x.c
index 38482d3..b30343d 100644
--- a/arch/arm/mach-pxa/lp8x4x.c
+++ b/arch/arm/mach-pxa/lp8x4x.c
@@ -424,6 +424,11 @@ static struct resource lp8x4x_bus_resources[] = {
 		.end    = LP8X4X_MOD_NUM,
 		.flags  = IORESOURCE_MEM,
 	},
+	[1] = {
+		.start  = LP8X4X_SLOT_SWITCH,
+		.end    = LP8X4X_SLOT_SWITCH,
+		.flags  = IORESOURCE_MEM,
+	},
 };
 
 static struct platform_device lp8x4x_bus_device[] = {
@@ -431,7 +436,7 @@ static struct platform_device lp8x4x_bus_device[] = {
 		.name           = "lp8x4x-bus",
 		.id             = 0,
 		.resource = &lp8x4x_bus_resources[0],
-		.num_resources = 1,
+		.num_resources = 2,
 	},
 };
 
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 9cd840e..647fde7 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -27,6 +27,8 @@ MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 struct lp8x4x_master {
 	unsigned int		slot_count;
 	void			*count_addr;
+	unsigned int		active_slot;
+	void			*switch_addr;
 	struct device		dev;
 };
 
@@ -58,8 +60,45 @@ static ssize_t slot_count_show(struct device *dev,
 
 static DEVICE_ATTR_RO(slot_count);
 
+static ssize_t active_slot_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+
+	return sprintf(buf, "%u\n", m->active_slot);
+}
+
+static ssize_t active_slot_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct lp8x4x_master *m = container_of(dev, struct lp8x4x_master, dev);
+	unsigned int active_slot = 0;
+	int err;
+
+	if (!buf)
+		return count;
+	if (0 == count)
+		return count;
+
+	err = kstrtouint(buf, 10, &active_slot);
+	if (err != 0 || !active_slot || active_slot > m->slot_count) {
+		dev_err(dev, "slot number is out of range 1..%u\n",
+				m->slot_count);
+		return count;
+	}
+
+	m->active_slot = active_slot;
+
+	iowrite8((1 << (m->active_slot - 1)) ^ 0xff, m->switch_addr);
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(active_slot);
+
 static struct attribute *master_dev_attrs[] = {
 	&dev_attr_slot_count.attr,
+	&dev_attr_active_slot.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(master_dev);
@@ -69,10 +108,15 @@ static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 {
 	struct lp8x4x_master *m = *(struct lp8x4x_master **)res;
 	void *mem = m->count_addr;
+	void *mem2 = m->switch_addr;
 
 	dev_info(dev, "releasing devices\n");
 	device_unregister(&m->dev);
 	bus_unregister(&lp8x4x_bus_type);
+
+	/* Disable serial communications */
+	iowrite8(0xff, mem2);
+	iounmap(mem2);
 	iounmap(mem);
 }
 
@@ -95,6 +139,7 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
+		dev_err(&pdev->dev, "Failed to get slot number address\n");
 		err = -ENODEV;
 		goto err2;
 	}
@@ -107,6 +152,21 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get slot switch address\n");
+		err = -ENODEV;
+		goto err3;
+	}
+
+	m->switch_addr = ioremap(res->start, resource_size(res));
+	if (!m->switch_addr) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n",
+		       m->switch_addr);
+		err = -EFAULT;
+		goto err3;
+	}
+
 	m->slot_count = ioread8(m->count_addr);
 	switch (m->slot_count) {
 	case 1:
@@ -118,15 +178,18 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	default:
 		dev_info(&pdev->dev, "unexpected slot number(%u)",
 				m->slot_count);
-		goto err3;
+		goto err_bus;
 	};
 
 	dev_info(&pdev->dev, "found bus with up to %u slots\n", m->slot_count);
 
+	/* Disable serial communications until explicitly enabled */
+	iowrite8(0xff, m->switch_addr);
+
 	err = bus_register(&lp8x4x_bus_type);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register bus type\n");
-		goto err3;
+		goto err_bus;
 	}
 
 	m->dev.bus = &lp8x4x_bus_type;
@@ -138,14 +201,16 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	err = device_register(&m->dev);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register backplane device\n");
-		goto err4;
+		goto err_dev;
 	}
 
 	devres_add(&pdev->dev, p);
 	return 0;
 
-err4:
+err_dev:
 	bus_unregister(&lp8x4x_bus_type);
+err_bus:
+	iounmap(m->switch_addr);
 err3:
 	iounmap(m->count_addr);
 err2:
-- 
1.8.4.2

