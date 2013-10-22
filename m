Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3JVACV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 20:02:21 -0400
Received: from mga09.intel.com ([134.134.136.24]:64284 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3JVACT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 20:02:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422609992"
Message-ID: <5265C0FA.5060006@linux.intel.com>
Date: Mon, 21 Oct 2013 17:04:10 -0700
From: Bin Gao <bin.gao@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] drivers/misc: add rawio i2c driver
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With i2c rawio driver, you can read/write registers from any i2c
client(slave) device via debug fs interface.
This driver is based on the rawio framework.

Signed-off-by: Bin Gao <bin.gao@intel.com>
---
 drivers/misc/rawio/Kconfig     |  11 ++
 drivers/misc/rawio/Makefile    |   1 +
 drivers/misc/rawio/rawio_i2c.c | 224
+++++++++++++++++++++++++++++++++++++++++
 3 files changed, 236 insertions(+)
 create mode 100644 drivers/misc/rawio/rawio_i2c.c

diff --git a/drivers/misc/rawio/Kconfig b/drivers/misc/rawio/Kconfig
index 38e8a52..9ffbc5d 100644
--- a/drivers/misc/rawio/Kconfig
+++ b/drivers/misc/rawio/Kconfig
@@ -45,4 +45,15 @@ config RAWIO_IOMEM
 	  To compile this driver as a module, choose M: the module will
 	  be called rawio_iomem.

+config RAWIO_I2C
+	tristate "rawio I2C driver"
+	depends on RAWIO && I2C
+	default no
+	help
+	  This option enables the rawio I2C driver.
+	  With this driver, you can read or write any I2C device's
+	  register debugfs interface.
+	  To compile this driver as a module, choose M: the module will
+	  be called rawio_i2c.
+
 endif # RAWIO
diff --git a/drivers/misc/rawio/Makefile b/drivers/misc/rawio/Makefile
index 5f86257..9e33aec 100644
--- a/drivers/misc/rawio/Makefile
+++ b/drivers/misc/rawio/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_RAWIO)		+= rawio.o
 obj-$(CONFIG_RAWIO_PCI)		+= rawio_pci.o
 obj-$(CONFIG_RAWIO_IOMEM)	+= rawio_iomem.o
+obj-$(CONFIG_RAWIO_I2C)		+= rawio_i2c.o
diff --git a/drivers/misc/rawio/rawio_i2c.c b/drivers/misc/rawio/rawio_i2c.c
new file mode 100644
index 0000000..f872602
--- /dev/null
+++ b/drivers/misc/rawio/rawio_i2c.c
@@ -0,0 +1,224 @@
+/*
+ * rawio_i2c.c - rawio I2C driver.
+ * Read or write a I2C device's register, based on the rawio framework.
+ *
+ * Copyright (c) 2013 Bin Gao <bin.gao@intel.com>
+ *
+ * This file is released under the GPLv2
+ *
+ *
+ * read i2c registers:
+ * echo "r i2c <bus_num> <slace_addr> <reg> [<len>]" >
+ *			/sys/kernel/debug/rawio_cmd
+ * cat /sys/kernel/debug/rawio_output
+ * e.g. echo "r i2c 3 0x6b 0x84 5" > /sys/kernel/debug/rawio_cmd
+ *      cat /sys/kernel/debug/rawio_output
+ *
+ * write a i2c register:
+ * echo "w i2c <bus_num> <slace_addr> <reg> <val>" >
+ *			/sys/kernel/debug/rawio_cmd
+ * cat /sys/kernel/debug/rawio_output
+ * e.g. echo "w i2c 4 0x70 0x4 0xfa" > /sys/kernel/debug/rawio_cmd
+ *      cat /sys/kernel/debug/rawio_output
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/i2c.h>
+#include <linux/rawio.h>
+
+static int i2c_prepare(u8 i2c_bus, u16 i2c_addr, u16 i2c_reg, u16 len,
+			int ten_bit_addr, struct i2c_adapter **ppadap)
+{
+	struct i2c_adapter *adap;
+
+	adap = i2c_get_adapter((int)i2c_bus);
+	if (!adap) {
+		rawio_err("can't find bus adapter for i2c bus %d\n",
+			i2c_bus);
+		return -ENODEV;
+	}
+
+	if ((!ten_bit_addr && (i2c_addr > 128)) || (i2c_addr > 1024)) {
+		rawio_err("register address is out of range, forgot 't' for 10bit
addr?\n");
+		return -EINVAL;
+	}
+
+	if ((!ten_bit_addr && ((i2c_addr + len) > 128)) ||
+			((i2c_addr + len) > 1024)) {
+		rawio_err("register address is out of range, forgot 't' for 10bit
addr?\n");
+		return -EINVAL;
+	}
+
+	*ppadap = adap;
+	return 0;
+}
+
+static int rawio_i2c_read(struct rawio_driver *driver, int width, u64
*input,
+	u8 *postfix, int input_num, void **output, int *output_num)
+{
+	int ret, len;
+	struct i2c_adapter *adap;
+	u16 i2c_addr, i2c_reg;
+	struct i2c_msg msg[2];
+	u8 i2c_bus, buf[2], *out_buf, ten_bit_addr, sixteen_bit_reg;
+
+	i2c_bus = (u8)input[0];
+	i2c_addr = (u16)input[1];
+	i2c_reg = (u16)input[2];
+
+	len = 1;
+	if (input_num == 4)
+		len = (u16)input[3];
+
+	ten_bit_addr = postfix[1];
+	sixteen_bit_reg = postfix[2];
+
+	ret = i2c_prepare(i2c_bus, i2c_addr, i2c_reg, len, ten_bit_addr, &adap);
+	if (ret)
+		return ret;
+
+	out_buf = kzalloc(sizeof(u8) * len, GFP_KERNEL);
+	if (buf == NULL) {
+		rawio_err("can't alloc memory\n");
+		return -ENOMEM;
+	}
+	buf[0] = i2c_reg & 0xff;
+	buf[1] = (i2c_reg >> 8) & 0xff;
+
+	/* write i2c reg address */
+	msg[0].addr = i2c_addr;
+	msg[0].flags = ten_bit_addr ? I2C_M_TEN : 0;
+	msg[0].len = sixteen_bit_reg ? 2 : 1;
+	msg[0].buf = buf;
+
+	/* read i2c reg */
+	msg[1].addr = i2c_addr;
+	msg[1].flags = I2C_M_RD | (ten_bit_addr ? I2C_M_TEN : 0);
+	msg[1].len = len;
+	msg[1].buf = out_buf;
+
+	ret = i2c_transfer(adap, msg, 2);
+	if (ret != 2) {
+		rawio_err("i2c_transfer() failed, ret = %d\n", ret);
+		kfree(out_buf);
+		return -EIO;
+	}
+
+	*output = out_buf;
+	*output_num = len;
+	return 0;
+}
+
+static int rawio_i2c_write(struct rawio_driver *driver, int width, u64
*input,
+			u8 *postfix, int input_num)
+{
+	int ret;
+	struct i2c_adapter *adap;
+	u16 i2c_addr, i2c_reg;
+	struct i2c_msg msg;
+	u8 value, i2c_bus, buf[2], buf16[3], ten_bit_addr, sixteen_bit_reg;
+
+	i2c_bus = (u8)input[0];
+	i2c_addr = (u8)input[1];
+	i2c_reg = (u16)input[2];
+	value = (u8)input[3];
+
+	ten_bit_addr = postfix[1];
+	sixteen_bit_reg = postfix[2];
+
+	ret = i2c_prepare(i2c_bus, i2c_addr, i2c_reg, 0, ten_bit_addr, &adap);
+	if (ret)
+		return ret;
+
+	if (sixteen_bit_reg) {
+		buf16[0] = (i2c_reg >> 8) & 0xff; /* high 8 bit reg addr */
+		buf16[1] = i2c_reg & 0xff; /* low 8 bit reg addr */
+		buf16[2] = value;
+		msg.len = 3;
+		msg.buf = buf16;
+	} else {
+		buf[0] = i2c_reg & 0xff; /* low 8 bit reg addr */
+		buf[1] = value;
+		msg.len = 2;
+		msg.buf = buf;
+	}
+
+	msg.addr = i2c_addr;
+	msg.flags = ten_bit_addr ? I2C_M_TEN : 0;
+
+	ret = i2c_transfer(adap, &msg, 1);
+	if (ret != 1) {
+		rawio_err("i2c_transfer() failed, ret = %d\n", ret);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static struct rawio_ops rawio_i2c_ops = {
+	rawio_i2c_read,
+	NULL,
+	rawio_i2c_write,
+};
+
+static struct rawio_driver rawio_i2c = {
+	{NULL, NULL}, /* list node */
+	"i2c", /* driver name */
+
+	/* read */
+	4, /* max args */
+	{TYPE_U8, TYPE_U16, TYPE_U16, TYPE_U8}, /* type of read args */
+	3, /* min args */
+	{ 0, 't', 's', 0 }, /* args postfix */
+
+	/* write */
+	4, /* max args */
+	{TYPE_U8, TYPE_U16, TYPE_U16, TYPE_U8}, /* type of write args */
+	4, /* min args */
+	{ 0, 't', 's', 0 }, /* args postfix */
+
+	2, /* index of arg that specifies the register or memory address */
+
+	WIDTH_1, /* supported width */
+	WIDTH_1, /* default width */
+
+	/*
+	 * Slave address with postfix 't' indicates 10 bit slave address,
+	 * otherwise it's 7 bit address by default.
+	 * Register offset with postfix 's' indicates register offset is
+	 * 16 bit, otherwise it's 8 bit offset by default.
+	 * For example "r i2c 5 0x108t 0x0394s 2" means 10 bit slave address
+	 * and 16 bit register offset, and "r i2c 5 0x28 0x74" means 7 bit
+	 * slave address and 8 bit register offset.
+	 */
+	"r i2c <bus> <addr>[t] <reg>[s] [<len>]\n"
+	"w i2c <bus> <addr>[t] <reg>[s] <val>\n",
+	&rawio_i2c_ops,
+	NULL
+};
+
+static int __init rawio_i2c_init(void)
+{
+	if (rawio_register_driver(&rawio_i2c))
+		return -ENODEV;
+
+	return 0;
+}
+module_init(rawio_i2c_init);
+
+static void __exit rawio_i2c_exit(void)
+{
+	rawio_unregister_driver(&rawio_i2c);
+}
+module_exit(rawio_i2c_exit);
+
+MODULE_DESCRIPTION("Rawio I2C driver");
+MODULE_VERSION("1.0");
+MODULE_AUTHOR("Bin Gao <bin.gao@intel.com>");
+MODULE_LICENSE("GPL v2");
-- 
1.8.1.2

