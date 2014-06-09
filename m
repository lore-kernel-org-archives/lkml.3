Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaFISpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:45:46 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59486 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaFISpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:45:44 -0400
From: Raghavendra Ganiga <ravi23ganiga@gmail.com>
To: wsa@the-dreams.de, linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Cc: Raghavendra Ganiga <ravi23ganiga@gmail.com>
Subject: [PATCH] i2c: algos: add support for sc18im700 master i2c bus with uart interface
Date: Tue, 10 Jun 2014 00:15:27 +0530
Message-Id: <1402339527-5390-1-git-send-email-ravi23ganiga@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to add i2c algorith  support for nxp sc18im700
master i2c bus controller with uart interface

Signed-off-by: Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
---
 drivers/i2c/algos/Kconfig              |   2 +
 drivers/i2c/algos/Makefile             |   1 +
 drivers/i2c/algos/i2c-algo-sc18im700.c | 274 +++++++++++++++++++++++++++++++++
 include/linux/i2c-algo-sc18im700.h     |  81 ++++++++++
 4 files changed, 358 insertions(+)
 create mode 100644 drivers/i2c/algos/i2c-algo-sc18im700.c
 create mode 100644 include/linux/i2c-algo-sc18im700.h

diff --git a/drivers/i2c/algos/Kconfig b/drivers/i2c/algos/Kconfig
index f1cfe7e..03776c8 100644
--- a/drivers/i2c/algos/Kconfig
+++ b/drivers/i2c/algos/Kconfig
@@ -14,4 +14,6 @@ config I2C_ALGOPCF
 config I2C_ALGOPCA
 	tristate "I2C PCA 9564 interfaces"
 
+config I2C_ALGOSC18IM700
+	tristate "I2C SC18IM700 interfaces"
 endmenu
diff --git a/drivers/i2c/algos/Makefile b/drivers/i2c/algos/Makefile
index 215303f..26f92d7 100644
--- a/drivers/i2c/algos/Makefile
+++ b/drivers/i2c/algos/Makefile
@@ -5,5 +5,6 @@
 obj-$(CONFIG_I2C_ALGOBIT)	+= i2c-algo-bit.o
 obj-$(CONFIG_I2C_ALGOPCF)	+= i2c-algo-pcf.o
 obj-$(CONFIG_I2C_ALGOPCA)	+= i2c-algo-pca.o
+obj-$(CONFIG_I2C_ALGOSC18IM700)	+= i2c-algo-sc18im700.o
 
 ccflags-$(CONFIG_I2C_DEBUG_ALGO) := -DDEBUG
diff --git a/drivers/i2c/algos/i2c-algo-sc18im700.c b/drivers/i2c/algos/i2c-algo-sc18im700.c
new file mode 100644
index 0000000..cf73aad
--- /dev/null
+++ b/drivers/i2c/algos/i2c-algo-sc18im700.c
@@ -0,0 +1,274 @@
+/*
+ *  i2c-algo-sc18im700.c i2c driver algorithms for SC18IM700 adapters
+ *  Master I2C bus with UART interface
+ *
+ *  Copyright (C) 2014 Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ *  MA 02110-1301 USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/i2c.h>
+#include <linux/i2c-algo-sc18im700.h>
+
+#define DEB1(x) if (i2c_debug >= 1) x
+
+static int i2c_debug;
+
+#define set_sc18im(adap, value) adap->set_data(adap->data, value)
+#define get_sc18im(adap, buff) adap->get_data(adap->data, buff)
+#define sc18im_reset(adap) adap->reset(adap->data)
+#define sc18im_get_own_addr(adap) adap->get_own_addr(adap->data)
+
+static unsigned char sc18im_read_reg(struct i2c_algo_sc18imdata *adap,
+					unsigned char reg, unsigned char *buf)
+{
+	set_sc18im(adap, SC18IM_REG_READ);
+	set_sc18im(adap, reg);
+	set_sc18im(adap, SC18IM_STOP);
+	return get_sc18im(adap, buf);
+}
+
+static void sc18im_write_reg(struct i2c_algo_sc18imdata *adap,
+				unsigned char reg, unsigned char value)
+{
+	set_sc18im(adap, SC18IM_REG_WRITE);
+	set_sc18im(adap, reg);
+	set_sc18im(adap, value);
+	set_sc18im(adap, SC18IM_STOP);
+}
+
+static int sc18im_xfer(struct i2c_adapter *adap,
+			struct i2c_msg *msgs,
+			int num)
+{
+	struct i2c_algo_sc18imdata *algo_data = adap->algo_data;
+	struct i2c_msg *msg;
+	int curmsg, addr, numbytes;
+	unsigned char data;
+
+	DEB1(printk(KERN_DEBUG "i2c algo sc18im700: Transfer Starts"));
+
+	if (algo_data->xfer_begin)
+		algo_data->xfer_begin(algo_data->data);
+
+	curmsg = 0;
+	while (curmsg < num) {
+		numbytes = 0;
+		msg = &msgs[curmsg];
+
+		DEB1(printk(KERN_DEBUG "i2c algo sc18im700: Operation: %s, "
+				"Addr: 0x%02x, Length: %d, "
+				"Current Transfer No: %d, "
+				"Total No of transfer: %d\n",
+				(msg->flags & I2C_M_RD) ? "Read" : "Write",
+				msg->addr, msg->len, (curmsg + 1), num));
+
+		/* Data frame in sc18im700 for write is
+		 * start_char;address;length;data1;data2;---;data.n
+		 *;terminate_char
+		 * first provide the start character followed by address,
+		 * length, data bytes upto length bytes and then terminate
+		 * character, as terminate character is received by sc18im700
+		 * it transfers the data to addressed device
+		 * Data frame for read is
+		 * start_char;address;length;terminate_char;data1;data2.---
+		 *;data.n
+		 * similarly in read operation , as terminate character
+		 * is received, the data is read from the addressed device
+		 * and given out in uart
+		 */
+		set_sc18im(algo_data, SC18IM_START);
+
+		addr = (msg->addr & 0x7F) << 1;
+		if (msg->flags & I2C_M_RD)
+			addr |= 1;
+		if (msg->flags & I2C_M_REV_DIR_ADDR)
+			addr ^= 1;
+		set_sc18im(algo_data, addr);
+
+		set_sc18im(algo_data, msg->len);
+
+		if (msg->flags & I2C_M_RD) {
+			set_sc18im(algo_data, SC18IM_STOP);
+
+			while (numbytes < msg->len) {
+				data = get_sc18im(algo_data,
+						&msg->buf[numbytes]);
+				if (data) {
+					DEB1(printk(KERN_ERR
+					"i2c algo sc18im700: Read Error"));
+					curmsg = -ENXIO;
+					goto out;
+				}
+			}
+		} else {
+			while (numbytes < msg->len) {
+				set_sc18im(algo_data, msg->buf[numbytes]);
+				numbytes++;
+			}
+
+			set_sc18im(algo_data, SC18IM_STOP);
+			sc18im_read_reg(algo_data, SC18IM_I2CSTATUS, &data);
+			if (data != I2C_SC18IM_OK) {
+				DEB1(printk(KERN_ERR
+				"i2c algo sc18im700: Write Error"));
+				curmsg = -ENXIO;
+				goto out;
+			}
+		}
+
+		curmsg++;
+	}
+
+out:
+	DEB1(printk(KERN_DEBUG "i2c algo sc18im700: Transfer Ends"));
+
+	if (algo_data->xfer_end)
+		algo_data->xfer_end(algo_data->data);
+
+	return curmsg;
+}
+
+static u32 sc18im_functionality(struct i2c_adapter *adap)
+{
+	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL |
+		I2C_FUNC_PROTOCOL_MANGLING;
+}
+
+static int sc18im_init(struct i2c_adapter *adap)
+{
+	struct i2c_algo_sc18imdata *algo_data = adap->algo_data;
+	unsigned char data;
+
+	sc18im_reset(algo_data);
+
+	/* after reset sc18im700 gives out
+	 * OK response in ascii format
+	 */
+	get_sc18im(algo_data, &data);
+	if (data != 'O') {
+		DEB1(printk(KERN_ERR
+		"i2c algo sc18im700: Reset response OK not received\n"));
+
+		return -ENXIO;
+	}
+
+	get_sc18im(algo_data, &data);
+	if (data != 'K') {
+		DEB1(printk(KERN_ERR
+		"i2c algo sc18im700: Reset response OK not received\n"));
+
+		return -ENXIO;
+	}
+
+	switch (algo_data->clock_freq) {
+	case I2C_SC18IM_369KHZ:
+		printk(KERN_INFO
+			"i2c algo sc18im700: Clock frequency is 369 KHz\n");
+		break;
+	case I2C_SC18IM_246KHZ:
+		printk(KERN_INFO
+			"i2c algo sc18im700: Clock frequency is 246 KHz\n");
+		break;
+	case I2C_SC18IM_147KHZ:
+		printk(KERN_INFO
+			"i2c algo sc18im700: Clock frequency is 147 KHz\n");
+		break;
+	case I2C_SC18IM_123KHZ:
+		printk(KERN_INFO
+			"i2c algo sc18im700: Clock frequency is 123 KHz\n");
+		break;
+	case I2C_SC18IM_74KHZ:
+		printk(KERN_INFO
+			"i2c algo sc18im700: Clock frequency is 74 KHz\n");
+		break;
+	case I2C_SC18IM_61KHZ:
+		printk(KERN_INFO
+			"i2c algo sc18im700: Clock frequency is 61 KHz\n");
+		break;
+	case I2C_SC18IM_37KHZ:
+		printk(KERN_INFO
+			"i2c algo sc18im700: Clock frequency is 37 KHz\n");
+		break;
+	default:
+		printk(KERN_WARNING
+			"i2c algo sc18im700: Invalid Freq: Clock: 37 KHz\n");
+		algo_data->clock_freq = I2C_SC18IM_37KHZ;
+	}
+
+	/* passed clock frequency is divided into
+	 * half and stored in clock high and clock
+	 * low to achieve the desired clock frequency
+	 */
+	data = algo_data->clock_freq / 2;
+
+	sc18im_write_reg(algo_data, SC18IM_I2C_CLK_LOW, data);
+	sc18im_write_reg(algo_data, SC18IM_I2C_CLK_HIGH, data);
+
+	data = sc18im_get_own_addr(algo_data);
+	sc18im_write_reg(algo_data, SC18IM_I2CADDR, data);
+
+	printk(KERN_DEBUG "i2c algo sc18im700: detected and initialized\n");
+
+	return 0;
+}
+
+static const struct i2c_algorithm sc18im_algo = {
+	.master_xfer	= sc18im_xfer,
+	.functionality	= sc18im_functionality,
+};
+
+/*
+ * registering functions to load algorithms at runtime
+ */
+int i2c_sc18im_add_bus(struct i2c_adapter *adap)
+{
+	int ret;
+
+	adap->algo = &sc18im_algo;
+
+	ret = sc18im_init(adap);
+	if (ret)
+		return ret;
+
+	return i2c_add_adapter(adap);
+}
+EXPORT_SYMBOL(i2c_sc18im_add_bus);
+
+int i2c_sc18im_add_numbered_bus(struct i2c_adapter *adap)
+{
+	int ret;
+
+	adap->algo = &sc18im_algo;
+
+	ret = sc18im_init(adap);
+	if (ret)
+		return ret;
+
+	return i2c_add_numbered_adapter(adap);
+}
+EXPORT_SYMBOL(i2c_sc18im_add_numbered_bus);
+
+module_param(i2c_debug, int, S_IRUGO | S_IWUSR);
+
+MODULE_PARM_DESC(i2c_debug, "debug level - 0 - off, 1 - more verbose");
+MODULE_DESCRIPTION("SC18IM700 I2C Algorithm Driver");
+MODULE_AUTHOR("Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/i2c-algo-sc18im700.h b/include/linux/i2c-algo-sc18im700.h
new file mode 100644
index 0000000..231dbd2
--- /dev/null
+++ b/include/linux/i2c-algo-sc18im700.h
@@ -0,0 +1,81 @@
+/*
+ *  i2c-algo-sc18im700.c i2c driver algorithms header file
+ *
+ *  Copyright (C) 2014 Raghavendra Chandra Ganiga <ravi23ganiga@gmail.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
+ *  MA 02110-1301 USA.
+ */
+
+#ifndef _LINUX_I2C_ALGO_SC18IM700_H
+#define _LINUX_I2C_ALGO_SC18IM700_H
+
+/* SC18IM700 Internal Registers */
+
+#define SC18IM_BRG0		0x00
+#define SC18IM_BRG1		0x01
+#define SC18IM_PORT_CONF1	0x02
+#define SC18IM_PORT_CONF2	0x03
+#define SC18IM_IOSTATE		0x04
+#define SC18IM_I2CADDR		0x06
+#define SC18IM_I2C_CLK_LOW	0x07
+#define SC18IM_I2C_CLK_HIGH	0x08
+#define SC18IM_I2CTO		0x09
+#define SC18IM_I2CSTATUS	0x0A
+
+/* SC18IM700 I2C Commands */
+
+#define SC18IM_START		0x53
+#define SC18IM_STOP		0x50
+#define SC18IM_REG_READ		0x52
+#define SC18IM_REG_WRITE	0x57
+#define SC18IM_READ_GPIO	0x49
+#define SC18IM_WRITE_GPIO	0x4F
+#define SC18IM_POWER_DOWN	0x5A
+
+/* SC18IM700 I2C Clock frequencies */
+
+#define I2C_SC18IM_369KHZ	0x0A
+#define I2C_SC18IM_246KHZ	0x0F
+#define I2C_SC18IM_147KHZ	0x19
+#define I2C_SC18IM_123KHZ	0x1E
+#define I2C_SC18IM_74KHZ	0x32
+#define I2C_SC18IM_61KHZ	0x3C
+#define I2C_SC18IM_37KHZ	0x64
+
+/* SC18IM700 I2C TRANSACTION STATUS */
+
+#define I2C_SC18IM_OK		0xF0
+#define I2C_SC18IM_NACK_ADDR	0xF1
+#define I2C_SC18IM_NACK_DATA	0xF2
+#define I2C_SC18IM_TMOUT	0xF8
+
+struct i2c_algo_sc18imdata {
+	/* private low level data */
+	void		*data;
+	unsigned char	clock_freq;
+
+	void (*set_data) (void *data, unsigned char value);
+	int (*get_data) (void *data, unsigned char *buff);
+	void (*reset) (void *data);
+	unsigned char (*get_own_addr) (void *data);
+	void (*xfer_begin) (void *data);
+	void (*xfer_end) (void *data);
+};
+
+int i2c_sc18im_add_bus(struct i2c_adapter *);
+int i2c_sc18im_add_numbered_bus(struct i2c_adapter *);
+
+#endif /* _LINUX_I2C_ALGO_SC18IM700_H */
-- 
1.9.1

