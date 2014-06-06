Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaFFRxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:53:35 -0400
Received: from alfter.us ([96.126.100.72]:57833 "EHLO alfter.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaFFRxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:53:31 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jun 2014 13:53:31 EDT
Message-ID: <37853c31eb688a3745310acf905ca9fa.squirrel@webmail.alfter.us>
In-Reply-To: <64681401965067@web25m.yandex.ru>
References: <1853313.sEkU5HsBDk@kaylee> <64681401965067@web25m.yandex.ru>
Date: Fri, 6 Jun 2014 17:46:50 -0000
Subject: Re: new driver: w1_ds2406
To: linux-kernel@vger.kernel.org
Cc: zbr@ioremap.net, greg@kroah.com
User-Agent: SquirrelMail/1.4.23 [SVN]
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20140606174650_43495"
X-Priority: 3 (Normal)
Importance: Normal
X-Delivery-Agent: TMDA/1.1.12 (Macallan)
From: Scott Alfter <scott@alfter.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_20140606174650_43495
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, June 5, 2014 10:44, Evgeniy Polyakov wrote:
> 04.06.2014, 08:25, "Scott Alfter" <scott@alfter.us>:
>> I have a project for which I needed support for the DS2406 addressable
>> switch, so I started with an existing driver and modified it as needed.
>> It allows the switch outputs to be controlled over the bus, which is
>> what I needed from it.
>
> Driver seems good, although debug prints like 'mutex is locked' are better
> to be dropped.

Those were in the DS2413 driver, which I used as a base for my changes. 
I've taken them out.  Also, I fixed a typo I made in the description in a
Kconfig file.

> Please send this patch to linux-kernel@ and add me and greg@kroah.com to
> copy, and patch will be pulled upstream.
> Feel free to add my acked/reviewed-by tags.

Signed-off-by: Scott Alfter <scott@alfter.us>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Reviewed-by: Evgeniy Polyakov <zbr@ioremap.net>

------=_20140606174650_43495
Content-Type: text/plain; name="w1_ds2406.patch.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="w1_ds2406.patch.txt"

diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index 5e6a3c9..6b04f0f 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -38,6 +38,13 @@ config W1_SLAVE_DS2413
 	  Say Y here if you want to use a 1-wire
 	  DS2413 Dual Channel Addressable Switch device support
 
+config W1_SLAVE_DS2406
+	tristate "Dual Channel Addressable Switch 0x12 family support (DS2406)"
+	help
+	  Say Y or M here if you want to use a 1-wire
+	  DS2406 Dual Channel Addressable Switch.  EPROM read/write
+	  support for these devices is not implemented.
+
 config W1_SLAVE_DS2423
 	tristate "Counter 1-wire device (DS2423)"
 	select CRC16
diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
index 06529f3..1e9989a 100644
--- a/drivers/w1/slaves/Makefile
+++ b/drivers/w1/slaves/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
 obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
 obj-$(CONFIG_W1_SLAVE_DS2408)	+= w1_ds2408.o
 obj-$(CONFIG_W1_SLAVE_DS2413)	+= w1_ds2413.o
+obj-$(CONFIG_W1_SLAVE_DS2406)	+= w1_ds2406.o
 obj-$(CONFIG_W1_SLAVE_DS2423)	+= w1_ds2423.o
 obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
 obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
diff --git a/drivers/w1/w1_family.h b/drivers/w1/w1_family.h
index 625dd08..56d8a0c 100644
--- a/drivers/w1/w1_family.h
+++ b/drivers/w1/w1_family.h
@@ -40,6 +40,7 @@
 #define W1_FAMILY_DS2760	0x30
 #define W1_FAMILY_DS2780	0x32
 #define W1_FAMILY_DS2413	0x3A
+#define W1_FAMILY_DS2406	0x12
 #define W1_THERM_DS1825		0x3B
 #define W1_FAMILY_DS2781	0x3D
 #define W1_THERM_DS28EA00	0x42
diff --git a/Documentation/w1/slaves/w1_ds2406 b/Documentation/w1/slaves/w1_ds2406
new file mode 100644
index 0000000..1aa409a
--- /dev/null
+++ b/Documentation/w1/slaves/w1_ds2406
@@ -0,0 +1,22 @@
+w1_ds2406 kernel driver
+=======================
+
+Supported chips:
+  * Maxim DS2406 (and other family 0x12) addressable switches
+
+Author: Scott Alfter <scott@alfter.us>
+
+Description
+-----------
+
+The w1_ds2406 driver allows connected devices to be switched on and off. 
+These chips also provide 128 bytes of OTP EPROM, but reading/writing it is
+not supported.  In TSOC-6 form, the DS2406 provides two switch outputs and
+can be provided with power on a dedicated input.  In TO-92 form, it provides
+one output and uses parasitic power only.
+
+The driver provides two sysfs files.  state is readable; it gives the
+current state of each switch, with PIO A in bit 0 and PIO B in bit 1.  The
+driver ORs this state with 0x30, so shell scripts get an ASCII 0/1/2/3 to
+work with.  output is writable; bits 0 and 1 control PIO A and B,
+respectively.  Bits 2-7 are ignored, so it's safe to write ASCII data.
diff --git a/drivers/w1/slaves/w1_ds2406.c b/drivers/w1/slaves/w1_ds2406.c
new file mode 100644
index 0000000..9fcfefb
--- /dev/null
+++ b/drivers/w1/slaves/w1_ds2406.c
@@ -0,0 +1,159 @@
+/*
+ * w1_ds2406.c - w1 family 12 (DS2406) driver
+ * based on w1_ds2413.c by Mariusz Bialonczyk <manio@skyboo.net>
+ *
+ * Copyright (c) 2014 Scott Alfter <scott@alfter.us>
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2. See the file COPYING for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+
+#include "../w1.h"
+#include "../w1_int.h"
+#include "../w1_family.h"
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Scott Alfter <scott@alfter.us>");
+MODULE_DESCRIPTION("w1 family 12 driver for DS2406 2 Pin IO");
+
+#define W1_F12_FUNC_READ_STATUS		   0xAA
+#define W1_F12_FUNC_WRITE_STATUS	   0x55
+
+static ssize_t w1_f12_read_state(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	u8 w1_buf[3];
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+
+	if (off != 0)
+		return 0;
+	if (!buf)
+		return -EINVAL;
+
+	mutex_lock(&sl->master->bus_mutex);
+
+	if (w1_reset_select_slave(sl)) {
+		mutex_unlock(&sl->master->bus_mutex);
+		return -EIO;
+	}
+
+	w1_buf[0] = W1_F12_FUNC_READ_STATUS;
+	w1_buf[1] = 0x07; // byte 7
+	w1_buf[2] = 0x00;
+	w1_write_block(sl->master, w1_buf, 3);
+	*buf = ((w1_read_8(sl->master)>>5)&3)|0x30;
+
+	mutex_unlock(&sl->master->bus_mutex);
+
+	return 1;
+}
+
+static ssize_t w1_f12_write_output(
+	struct file *filp, struct kobject *kobj,
+	struct bin_attribute *bin_attr,
+	char *buf, loff_t off, size_t count)
+{
+	struct w1_slave *sl = kobj_to_w1_slave(kobj);
+	u8 w1_buf[4];
+	u8 rbuf[6];
+
+	if (count != 1 || off != 0)
+		return -EFAULT;
+
+	mutex_lock(&sl->master->bus_mutex);
+
+	if (w1_reset_select_slave(sl))
+		goto error;
+
+	w1_buf[0] = W1_F12_FUNC_WRITE_STATUS;
+	w1_buf[1] = 0x07; // byte #7
+	w1_buf[2] = 0x00;
+	w1_buf[3] = (((*buf)&3)<<5)|0x1F;
+	w1_write_block(sl->master, w1_buf, 4);
+	w1_read_block(sl->master, rbuf, 6);
+	w1_write_8(sl->master, 0xFF);
+
+	mutex_unlock(&sl->master->bus_mutex);
+	return 1;
+
+error:
+	mutex_unlock(&sl->master->bus_mutex);
+	return -EIO;
+}
+
+#define NB_SYSFS_BIN_FILES 2
+static struct bin_attribute w1_f12_sysfs_bin_files[NB_SYSFS_BIN_FILES] = {
+	{
+		.attr = {
+			.name = "state",
+			.mode = S_IRUGO,
+		},
+		.size = 1,
+		.read = w1_f12_read_state,
+	},
+	{
+		.attr = {
+			.name = "output",
+			.mode = S_IRUGO | S_IWUSR | S_IWGRP,
+		},
+		.size = 1,
+		.write = w1_f12_write_output,
+	}
+};
+
+static int w1_f12_add_slave(struct w1_slave *sl)
+{
+	int err = 0;
+	int i;
+
+	for (i = 0; i < NB_SYSFS_BIN_FILES && !err; ++i)
+		err = sysfs_create_bin_file(
+			&sl->dev.kobj,
+			&(w1_f12_sysfs_bin_files[i]));
+	if (err)
+		while (--i >= 0)
+			sysfs_remove_bin_file(&sl->dev.kobj,
+				&(w1_f12_sysfs_bin_files[i]));
+	return err;
+}
+
+static void w1_f12_remove_slave(struct w1_slave *sl)
+{
+	int i;
+	for (i = NB_SYSFS_BIN_FILES - 1; i >= 0; --i)
+		sysfs_remove_bin_file(&sl->dev.kobj,
+			&(w1_f12_sysfs_bin_files[i]));
+}
+
+static struct w1_family_ops w1_f12_fops = {
+	.add_slave      = w1_f12_add_slave,
+	.remove_slave   = w1_f12_remove_slave,
+};
+
+static struct w1_family w1_family_3a = {
+	.fid = W1_FAMILY_DS2406,
+	.fops = &w1_f12_fops,
+};
+
+static int __init w1_f12_init(void)
+{
+	return w1_register_family(&w1_family_3a);
+}
+
+static void __exit w1_f12_exit(void)
+{
+	w1_unregister_family(&w1_family_3a);
+}
+
+module_init(w1_f12_init);
+module_exit(w1_f12_exit);
------=_20140606174650_43495--

