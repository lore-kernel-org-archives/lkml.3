Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaI3ErJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:47:09 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51373 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaI3ErH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:47:07 -0400
Message-ID: <542A35D9.6030100@gmail.com>
Date: Mon, 29 Sep 2014 21:47:21 -0700
From: Rajat Jain <rajatxjain@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org
CC: rajatjain@juniper.net, groeck@juniper.net
Subject: [PATCH 2/4] pci/pex8xxx: Add sysfs interface for userspace access.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the sysfs ABI for the I2C interface the PLX pex8xxx PCIe switch.
The ABI is documented, and a patch to "Documentation" accompanies this
patch.

Signed-off-by: Rajat Jain <rajatxjain@gmail.com>
Signed-off-by: Rajat Jain <rajatjain@juniper.net>
Signed-off-by: Guenter Roeck <groeck@juniper.net>
---
 drivers/pci/Kconfig       |    4 +-
 drivers/pci/pex8xxx_i2c.c |  282 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 284 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 29233aa..6a2b7dd 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -122,7 +122,9 @@ config PEX8XXX_I2C
 	  Select this if you want I2C interface support for the PLX PEX8xxx
 	  family of PCI express switches. Currently this I2C driver supports
 	  PEX8614, PEX8618, PEX8713 switches. It provides read / write API
-	  calls to talk to the switch (over I2C).
+	  calls to talk to the switch (over I2C), and a sysfs interface to
+	  provide the ability to debug. This is documented in
+	  Documentation/PCI/pex8xxx_i2c.txt.
 
 	  If built as a module, the driver will be called pex8xxx_i2c.
 
diff --git a/drivers/pci/pex8xxx_i2c.c b/drivers/pci/pex8xxx_i2c.c
index ab59417..e38998e 100644
--- a/drivers/pci/pex8xxx_i2c.c
+++ b/drivers/pci/pex8xxx_i2c.c
@@ -17,6 +17,8 @@
 #define PCI_DEVICE_ID_PLX_8618	    0x8618
 #define PCI_DEVICE_ID_PLX_8713	    0x8713
 
+#define PEX8XXX_PORT_REG_SPACE	    4096
+
 /* Supported devices */
 enum chips { pex8614, pex8618, pex8713 };
 
@@ -55,8 +57,21 @@ enum chips { pex8614, pex8618, pex8713 };
 
 struct pex8xxx_dev {
 	enum chips	        devtype;
+	u32			reg_addr;
+	u8                      port_num;
+	u8                      port_mode;      /* PEX8713 only */
+	u8                      port_stn;       /* PEX8713 only */
+	struct attribute_group  attr_group;
+	bool (*port_is_valid)(u8 port);
 };
 
+static inline struct pex8xxx_dev *pex8xxx_get_drvdata(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+
+	return i2c_get_clientdata(client);
+}
+
 /**
  * pex8xxx_read() - Read a (32 bit) register from the PEX8xxx device.
  * @client:	struct i2c_client*, representing the pex8xxx device.
@@ -175,6 +190,257 @@ int pex8xxx_write(struct i2c_client *client, u8 stn, u8 mode, u8 byte_mask,
 }
 EXPORT_SYMBOL(pex8xxx_write);
 
+/*
+ * Different PCIe switch can have different port validators.
+ * Also, some switches have discontinuous port number configurations.
+ */
+static bool pex8618_port_is_valid(u8 port)
+{
+	return port <= 15;
+}
+
+static bool pex8713_port_is_valid(u8 port)
+{
+	return port <= 5 || (port >= 8 && port <= 13);
+}
+
+static bool pex8614_port_is_valid(u8 port)
+{
+	return port <= 2 ||
+	    (port >= 4 && port <= 10) ||
+	    port == 12 ||
+	    port == 14;
+}
+
+static ssize_t port_num_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", pex8xxx->port_num);
+}
+static ssize_t port_num_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+	u8 port_num;
+
+	if (kstrtou8(buf, 0, &port_num))
+		return -EINVAL;
+
+	if (!pex8xxx->port_is_valid(port_num))
+		return -EINVAL;
+
+	pex8xxx->port_num = port_num;
+	return count;
+}
+static DEVICE_ATTR_RW(port_num);
+
+static ssize_t port_mode_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+	char *str;
+
+	switch (pex8xxx->port_mode) {
+	case MODE_TRANSPARENT:
+		str = "transparent";
+		break;
+	case MODE_NT_LINK:
+		str = "nt-link";
+		break;
+	case MODE_NT_VIRT:
+		str = "nt-virtual";
+		break;
+	case MODE_DMA:
+		str = "dma";
+		break;
+	default:
+		str = "unknown";
+		break;
+	}
+	return sprintf(buf, "%s\n", str);
+}
+static ssize_t port_mode_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+
+	if (!strcmp(buf, "transparent\n"))
+		pex8xxx->port_mode = MODE_TRANSPARENT;
+	else if (!strcmp(buf, "nt-link\n"))
+		pex8xxx->port_mode = MODE_NT_LINK;
+	else if (!strcmp(buf, "nt-virtual\n"))
+		pex8xxx->port_mode = MODE_NT_VIRT;
+	else if (!strcmp(buf, "dma\n"))
+		pex8xxx->port_mode = MODE_DMA;
+	else
+		return -EINVAL;
+
+	return count;
+}
+static DEVICE_ATTR_RW(port_mode);
+
+static ssize_t port_stn_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+
+	return sprintf(buf, "%d\n", pex8xxx->port_stn);
+}
+static ssize_t port_stn_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+	u8 stn;
+
+	if (kstrtou8(buf, 0, &stn) || (stn >= MAXSTN))
+		return -EINVAL;
+
+	pex8xxx->port_stn = stn;
+
+	return count;
+}
+static DEVICE_ATTR_RW(port_stn);
+
+static ssize_t reg_addr_show(struct device *dev, struct device_attribute *attr,
+			     char *buf)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+
+	return sprintf(buf, "0x%X\n", pex8xxx->reg_addr);
+}
+static ssize_t reg_addr_store(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct pex8xxx_dev *pex8xxx = pex8xxx_get_drvdata(dev);
+	unsigned long reg_addr;
+
+	/* PEX8xxx devices support 4K memory per port */
+	if (kstrtoul(buf, 0, &reg_addr) ||
+	    reg_addr >= PEX8XXX_PORT_REG_SPACE ||
+	    reg_addr % 4)
+		return -EINVAL;
+
+	pex8xxx->reg_addr = reg_addr;
+
+	return count;
+}
+static DEVICE_ATTR_RW(reg_addr);
+
+static ssize_t reg_value_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct pex8xxx_dev *pex8xxx;
+	struct i2c_client *client;
+	u32 regval = 0;
+	int ret;
+
+	client = to_i2c_client(dev);
+	pex8xxx = i2c_get_clientdata(client);
+
+	ret = pex8xxx_read(client, pex8xxx->port_stn, pex8xxx->port_mode,
+			   MASK_BYTE_ALL, pex8xxx->port_num, pex8xxx->reg_addr,
+			   &regval);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "0x%08X\n", regval);
+}
+
+static ssize_t reg_value_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct pex8xxx_dev *pex8xxx;
+	struct i2c_client *client;
+	unsigned long reg_val;
+	int retval;
+
+	client = to_i2c_client(dev);
+	pex8xxx = i2c_get_clientdata(client);
+
+	if (kstrtoul(buf, 0, &reg_val))
+		return -EINVAL;
+
+	retval = pex8xxx_write(client, pex8xxx->port_stn, pex8xxx->port_mode,
+			       MASK_BYTE_ALL, pex8xxx->port_num,
+			       pex8xxx->reg_addr, reg_val);
+	if (retval)
+		return retval;
+
+	return count;
+}
+static DEVICE_ATTR_RW(reg_value);
+
+/*
+ * Dump the 4096 byte binary configuration space
+ */
+static ssize_t
+pex8xxx_read_full_config(struct file *filp, struct kobject *kobj,
+			 struct bin_attribute *bin_attr,
+			 char *buf, loff_t off, size_t count)
+{
+	unsigned int size = PEX8XXX_PORT_REG_SPACE;
+	struct pex8xxx_dev *pex8xxx;
+	struct i2c_client *client;
+	struct device *dev;
+	loff_t init_off = off;
+	u32 *buf32 = (u32 *)buf;
+	u32 regval;
+	int ret;
+
+	dev = container_of(kobj, struct device, kobj);
+	client = to_i2c_client(dev);
+	pex8xxx = i2c_get_clientdata(client);
+
+	if (off > size || off & 3)
+		return 0;
+	if (off + count > size) {
+		size -= off;
+		count = size;
+	} else {
+		size = count;
+	}
+
+	while (size) {
+		ret = pex8xxx_read(client, pex8xxx->port_stn,
+				   pex8xxx->port_mode, MASK_BYTE_ALL,
+				   pex8xxx->port_num, off, &regval);
+		if (ret)
+			regval = 0xDEADBEEF;
+
+		buf32[(off - init_off)/4] = regval;
+		off += 4;
+		size -= 4;
+	}
+
+	return count;
+}
+static BIN_ATTR(port_config_regs, S_IRUGO, pex8xxx_read_full_config,
+		NULL, PEX8XXX_PORT_REG_SPACE);
+
+static struct attribute *pex861x_attrs[] = {
+	&dev_attr_port_num.attr,
+	&dev_attr_reg_addr.attr,
+	&dev_attr_reg_value.attr,
+	NULL,
+};
+static struct attribute *pex8713_attrs[] = {
+	&dev_attr_port_num.attr,
+	&dev_attr_port_mode.attr,
+	&dev_attr_port_stn.attr,
+	&dev_attr_reg_addr.attr,
+	&dev_attr_reg_value.attr,
+	NULL,
+};
+
+static struct bin_attribute *pex8xxx_bin_attrs[] = {
+	&bin_attr_port_config_regs,
+	NULL,
+};
+
 static int pex8xxx_verify_device(struct pex8xxx_dev *pex8xxx,
 				 struct i2c_client *client)
 {
@@ -198,12 +464,18 @@ static int pex8xxx_verify_device(struct pex8xxx_dev *pex8xxx,
 	switch (data >> 16) {
 	case PCI_DEVICE_ID_PLX_8614:
 		pex8xxx->devtype = pex8614;
+		pex8xxx->port_is_valid = pex8614_port_is_valid;
+		pex8xxx->attr_group.attrs = pex861x_attrs;
 		break;
 	case PCI_DEVICE_ID_PLX_8618:
 		pex8xxx->devtype = pex8618;
+		pex8xxx->port_is_valid = pex8618_port_is_valid;
+		pex8xxx->attr_group.attrs = pex861x_attrs;
 		break;
 	case PCI_DEVICE_ID_PLX_8713:
 		pex8xxx->devtype = pex8713;
+		pex8xxx->port_is_valid = pex8713_port_is_valid;
+		pex8xxx->attr_group.attrs = pex8713_attrs;
 		break;
 	default:    /* Unsupported PLX device */
 		return -ENODEV;
@@ -216,6 +488,7 @@ static int pex8xxx_probe(struct i2c_client *client,
 			 const struct i2c_device_id *dev_id)
 {
 	struct pex8xxx_dev *pex8xxx;
+	int retval;
 
 	pex8xxx = devm_kzalloc(&client->dev, sizeof(*pex8xxx), GFP_KERNEL);
 	if (!pex8xxx)
@@ -226,11 +499,18 @@ static int pex8xxx_probe(struct i2c_client *client,
 	if (pex8xxx_verify_device(pex8xxx, client))
 		return -ENODEV;
 
-	return 0;
+	pex8xxx->attr_group.bin_attrs = pex8xxx_bin_attrs;
+
+	retval =  sysfs_create_group(&client->dev.kobj, &pex8xxx->attr_group);
+
+	return retval;
 }
 
 static int pex8xxx_remove(struct i2c_client *client)
 {
+	struct pex8xxx_dev *pex8xxx = i2c_get_clientdata(client);
+
+	sysfs_remove_group(&client->dev.kobj, &pex8xxx->attr_group);
 	return 0;
 }
 
-- 
1.7.9.5

