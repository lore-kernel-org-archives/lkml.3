Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab3LMCcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 21:32:03 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:37327 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab3LMCaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 21:30:19 -0500
From: Sergei Ianovich <ynvich@gmail.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Sergei Ianovich <ynvich@gmail.com>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        linux-doc@vger.kernel.org (open list:DOCUMENTATION)
Subject: [PATCH v2 12/16] misc: support for serial slots in LP-8x4x
Date: Fri, 13 Dec 2013 06:27:21 +0400
Message-Id: <1386901645-28895-13-git-send-email-ynvich@gmail.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1386901645-28895-1-git-send-email-ynvich@gmail.com>
References: <1386543229-1542-1-git-send-email-ynvich@gmail.com>
 <1386901645-28895-1-git-send-email-ynvich@gmail.com>
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
   v0..v2
   * use device tree
   * use devm helpers where possible

 .../devicetree/bindings/misc/lp8x4x-bus.txt        |  8 ++-
 Documentation/misc-devices/lp8x4x_bus.txt          | 15 ++++-
 drivers/misc/lp8x4x_bus.c                          | 75 ++++++++++++++++++++--
 3 files changed, 87 insertions(+), 11 deletions(-)

diff --git a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
index 1c87a29..61ac96e 100644
--- a/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
+++ b/Documentation/devicetree/bindings/misc/lp8x4x-bus.txt
@@ -5,12 +5,14 @@ See Documentation/misc-devices/lp8x4x_bus.txt for details.
 Required properties:
 - compatible : should be "icpdas,backplane-lp8x4x"
 
-- reg: physical base address of the slot count register and the length
-       of the memory mapped region.
+- reg: physical base addresses and region lengths of
+       * the slot count register
+       * the serial slot select register
 
 Example:
 
 	backplane {
 		compatible = "icpdas,backplane-lp8x4x";
-		reg = <0x17009046 0x2>;
+		reg = <0x17009046 0x2
+		       0x17009004 0x2>;
 	};
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
+(/dev/ttyS1). However, it seems that addresses are not processed by
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
diff --git a/drivers/misc/lp8x4x_bus.c b/drivers/misc/lp8x4x_bus.c
index 7119738..cffe121 100644
--- a/drivers/misc/lp8x4x_bus.c
+++ b/drivers/misc/lp8x4x_bus.c
@@ -24,6 +24,8 @@ MODULE_DESCRIPTION("ICP DAS LP-8x4x parallel bus driver");
 struct lp8x4x_master {
 	unsigned int		slot_count;
 	void			*count_addr;
+	unsigned int		active_slot;
+	void			*switch_addr;
 	struct device		dev;
 };
 
@@ -55,8 +57,45 @@ static ssize_t slot_count_show(struct device *dev,
 
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
@@ -69,6 +108,9 @@ static void devm_lp8x4x_bus_release(struct device *dev, void *res)
 	dev_dbg(dev, "releasing devices\n");
 	device_unregister(&m->dev);
 	bus_unregister(&lp8x4x_bus_type);
+
+	/* Disable serial communications */
+	iowrite8(0xff, m->switch_addr);
 }
 
 static int __init lp8x4x_bus_probe(struct platform_device *pdev)
@@ -90,8 +132,9 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
+		dev_err(&pdev->dev, "Failed to get slot number address\n");
 		err = -ENODEV;
-		goto err2;
+		goto err_free;
 	}
 
 	m->count_addr = devm_ioremap_resource(&pdev->dev, res);
@@ -99,7 +142,22 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Failed to ioremap %p\n",
 		       m->count_addr);
 		err = -EFAULT;
-		goto err2;
+		goto err_free;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!res) {
+		dev_err(&pdev->dev, "Failed to get slot switch address\n");
+		err = -ENODEV;
+		goto err_free;
+	}
+
+	m->switch_addr = devm_ioremap_resource(&pdev->dev, res);
+	if (!m->switch_addr) {
+		dev_err(&pdev->dev, "Failed to ioremap %p\n",
+		       m->switch_addr);
+		err = -EFAULT;
+		goto err_free;
 	}
 
 	m->slot_count = ioread8(m->count_addr);
@@ -113,15 +171,18 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	default:
 		dev_err(&pdev->dev, "unexpected slot number(%u)",
 				m->slot_count);
-		goto err2;
+		goto err_free;
 	};
 
 	dev_info(&pdev->dev, "found bus with up to %u slots\n", m->slot_count);
 
+	/* Disable serial communications until explicitly enabled */
+	iowrite8(0xff, m->switch_addr);
+
 	err = bus_register(&lp8x4x_bus_type);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register bus type\n");
-		goto err3;
+		goto err_free;
 	}
 
 	m->dev.bus = &lp8x4x_bus_type;
@@ -133,15 +194,15 @@ static int __init lp8x4x_bus_probe(struct platform_device *pdev)
 	err = device_register(&m->dev);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to register backplane device\n");
-		goto err3;
+		goto err_bus;
 	}
 
 	devres_add(&pdev->dev, p);
 	return 0;
 
-err3:
+err_bus:
 	bus_unregister(&lp8x4x_bus_type);
-err2:
+err_free:
 	devres_free(p);
 err1:
 	kfree(m);
-- 
1.8.4.3

