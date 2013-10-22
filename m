Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab3JVAB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 20:01:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:60698 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab3JVABc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 20:01:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422609662"
Message-ID: <5265C0CD.5030705@linux.intel.com>
Date: Mon, 21 Oct 2013 17:03:25 -0700
From: Bin Gao <bin.gao@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] drivers/misc: add rawio pci driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With pci rawio driver, you can read/write any pci config space register
by debug fs interface. This driver is based on the rawio framework.

Signed-off-by: Bin Gao <bin.gao@intel.com>
---
 drivers/misc/rawio/Kconfig     |  15 +++
 drivers/misc/rawio/Makefile    |   1 +
 drivers/misc/rawio/rawio_pci.c | 235
+++++++++++++++++++++++++++++++++++++++++
 3 files changed, 251 insertions(+)
 create mode 100644 drivers/misc/rawio/rawio_pci.c

diff --git a/drivers/misc/rawio/Kconfig b/drivers/misc/rawio/Kconfig
index fd4272e..47be40a 100644
--- a/drivers/misc/rawio/Kconfig
+++ b/drivers/misc/rawio/Kconfig
@@ -19,3 +19,18 @@ menuconfig RAWIO
 	  be called rawio.

 	  If you are not sure, say N here.
+
+if RAWIO
+
+config RAWIO_PCI
+	tristate "rawio PCI driver"
+	depends on RAWIO && PCI
+	default no
+	help
+	  This option enables the rawio PCI driver.
+	  With this driver, you can read or write any PCI device's
+	  configuration space via debugfs.
+	  To compile this driver as a module, choose M: the module will
+	  be called rawio_pci.
+
+endif # RAWIO
diff --git a/drivers/misc/rawio/Makefile b/drivers/misc/rawio/Makefile
index c21453c..0933ca6 100644
--- a/drivers/misc/rawio/Makefile
+++ b/drivers/misc/rawio/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_RAWIO)		+= rawio.o
+obj-$(CONFIG_RAWIO_PCI)		+= rawio_pci.o
diff --git a/drivers/misc/rawio/rawio_pci.c b/drivers/misc/rawio/rawio_pci.c
new file mode 100644
index 0000000..052ad1b
--- /dev/null
+++ b/drivers/misc/rawio/rawio_pci.c
@@ -0,0 +1,235 @@
+/*
+ * rawio_pci.c - a driver to read/write pci configuration space
registers based
+ *               on the rawio framework.
+ *
+ * 1: byte, 2: word, 4: dword
+ *
+ * read pci config space registers
+ * echo "r[1|2|4] pci <domain> <bus> <dev> <func> <reg> [<len>]" >
+ *				/sys/kernel/debug/rawio_cmd
+ * cat /sys/kernel/debug/rawio_output
+ * e.g. echo "r1 pci 0 0 3 0 8 12" > /sys/kernel/debug/rawio_cmd
+ *      cat /sys/kernel/debug/rawio_output
+ *
+ * write a pci config space register:
+ * echo "w[1|2|4] pci <domain> <bus> <dev> <func> <reg> <val>" >
+ *				/sys/kernel/debug/rawio_output
+ * cat /sys/kernel/debug/rawio_output
+ * e.g. echo "w pci 0 0 0x11 2 0x10 0xffffffff" >
/sys/kernel/debug/rawio_cmd
+ *      cat /sys/kernel/debug/rawio_output
+ *
+ *
+ * Copyright (c) 2013 Bin Gao <bin.gao@intel.com>
+ *
+ * This file is released under the GPLv2
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/pm_runtime.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/rawio.h>
+
+static int pci_prepare(int pci_domain, unsigned int pci_bus,
+		u8 pci_dev, u8 pci_func, enum width width,
+		u16 pci_reg, u16 len, struct pci_dev **ppdev)
+{
+	struct pci_dev *pdev;
+	int ret;
+
+	if (((width == WIDTH_2) && (pci_reg & 0x1)) ||
+		((width == WIDTH_4) && (pci_reg & 0x3))) {
+		rawio_err("register address requires 2 bytes aligned for 16 bit
access, and 4 bytes aligned for 32 bit access\n");
+		return -EINVAL;
+	}
+
+	pdev = pci_get_domain_bus_and_slot(pci_domain, pci_bus,
+				PCI_DEVFN(pci_dev, pci_func));
+	if (!pdev) {
+		rawio_err("pci device %04x:%02x:%02x.%01x doesn't exist\n",
+				pci_domain, pci_bus, pci_dev, pci_func);
+		return -ENODEV;
+	}
+
+	if (((pci_reg >= 0x100) && !pci_is_pcie(pdev)) ||
+				(pci_reg >= 0x1000)) {
+		rawio_err("register address is out of range\n");
+		return -EINVAL;
+	}
+
+	if ((((pci_reg + len * width) >= 0x100) && !pci_is_pcie(pdev)) ||
+				((pci_reg + len * width) >= 0x1000)) {
+		rawio_err("register address is out of range\n");
+		return -EINVAL;
+	}
+
+	ret = pm_runtime_get_sync(&pdev->dev);
+	if ((ret >= 0) || (ret == -EACCES))
+		goto out;
+
+	rawio_err("can't put pci device %04x:%02x:%02x.%01xinto running state,
pm_runtime_get_sync() returned %d\n",
+			pci_domain, pci_bus, pci_dev, pci_func, ret);
+	return -EBUSY;
+
+out:
+	*ppdev = pdev;
+	return 0;
+}
+
+static void pci_finish(struct pci_dev *pdev)
+{
+	pm_runtime_put_sync(&pdev->dev);
+}
+
+static int rawio_pci_read(struct rawio_driver *driver, int width,
+			u64 *input, u8 *postfix, int input_num,
+			void **output, int *output_num)
+{
+	int i, ret, pci_domain;
+	struct pci_dev *pdev;
+	unsigned int pci_bus;
+	u8 pci_dev, pci_func;
+	u16 pci_reg, len;
+	void *buf;
+
+	pci_domain = (int)input[0];
+	pci_bus = (unsigned int)input[1];
+	pci_dev = (u8)input[2];
+	pci_func = (u8)input[3];
+	pci_reg = (u16)input[4];
+	len = 1;
+	if (input_num == 6)
+		len = (u16)input[5];
+
+	ret = pci_prepare(pci_domain, pci_bus, pci_dev, pci_func,
+				width, pci_reg, len, &pdev);
+	if (ret)
+		return ret;
+
+	buf = kzalloc(width * len, GFP_KERNEL);
+	if (buf == NULL) {
+		rawio_err("can't alloc memory\n");
+		pci_finish(pdev);
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < len; i++) {
+		switch (width) {
+		case WIDTH_1:
+			pci_read_config_byte(pdev, pci_reg + i, (u8 *)buf + i);
+			break;
+		case WIDTH_2:
+			pci_read_config_word(pdev, pci_reg + i * 2,
+						(u16 *)buf + i);
+			break;
+		case WIDTH_4:
+			pci_read_config_dword(pdev, pci_reg + i * 4,
+						(u32 *)buf + i);
+			break;
+		default:
+			break;
+		}
+	}
+
+	pci_finish(pdev);
+	*output = buf;
+	*output_num = len;
+	return 0;
+}
+
+static int rawio_pci_write(struct rawio_driver *driver, int width,
+			u64 *input, u8 *postfix, int input_num)
+{
+	int ret, pci_domain;
+	struct pci_dev *pdev;
+	unsigned int pci_bus;
+	u8 pci_dev, pci_func;
+	u16 pci_reg;
+	u32 value;
+
+	pci_domain = (int)input[0];
+	pci_bus = (unsigned int)input[1];
+	pci_dev = (u8)input[2];
+	pci_func = (u8)input[3];
+	pci_reg = (u16)input[4];
+	value = (u32) input[5];
+
+	ret = pci_prepare(pci_domain, pci_bus, pci_dev, pci_func,
+					width, pci_reg, 1, &pdev);
+	if (ret)
+		return ret;
+
+	switch (width) {
+	case WIDTH_1:
+		pci_write_config_byte(pdev, pci_reg, (u8) value);
+		break;
+	case WIDTH_2:
+		pci_write_config_word(pdev, pci_reg, (u16) value);
+		break;
+	case WIDTH_4:
+		pci_write_config_dword(pdev, pci_reg, value);
+		break;
+	default:
+		break;
+	}
+
+	pci_finish(pdev);
+	return 0;
+}
+
+static struct rawio_ops rawio_pci_ops = {
+	rawio_pci_read,
+	NULL,
+	rawio_pci_write,
+};
+
+static struct rawio_driver rawio_pci = {
+	{NULL, NULL},
+	"pci",
+
+	/* read */
+	6, /* max args */
+	{TYPE_S32, TYPE_U32, TYPE_U8, TYPE_U8, TYPE_U16, TYPE_S16}, /* types */
+	5, /* min args */
+
+	{ 0, }, /* postfix */
+
+	/* write */
+	6, /* max args */
+	{TYPE_S32, TYPE_U32, TYPE_U8, TYPE_U8, TYPE_U16, TYPE_U32}, /* types */
+	6, /* min args */
+	{ 0, },
+
+	4, /* index of address arg */
+
+	WIDTH_1 | WIDTH_2 | WIDTH_4, /* supported width */
+	WIDTH_4, /* default width */
+	"r[1|2|4] pci <domain> <bus> <dev> <func> <reg> [<len>]\n"
+	"w[1|2|4] pci <domain> <bus> <dev> <func> <reg> <val>\n",
+	&rawio_pci_ops,
+	NULL
+};
+
+static int __init rawio_pci_init(void)
+{
+	if (rawio_register_driver(&rawio_pci))
+		return -ENODEV;
+
+	return 0;
+}
+module_init(rawio_pci_init);
+
+static void __exit rawio_pci_exit(void)
+{
+	rawio_unregister_driver(&rawio_pci);
+}
+module_exit(rawio_pci_exit);
+
+MODULE_DESCRIPTION("Rawio PCI driver");
+MODULE_VERSION("1.0");
+MODULE_AUTHOR("Bin Gao <bin.gao@intel.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.2

