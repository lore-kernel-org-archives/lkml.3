Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3L0M0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 07:26:10 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:48145 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab3L0M0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 07:26:05 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Dec 2013 07:26:04 EST
From: scott <scott.liu@emc.com.tw>
To: Scott Liu <scott.liu@emc.com.tw>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Cc: Vincent Wang <vincent.wang@emc.com.tw>,
        Jeff Chuang <jeff.chuang@emc.com.tw>,
        Agnes Cheng <agnescheng@google.com>
Subject: [PATCH v1] Input: elants_i2c: Add Elan touchscreen support
Date: Fri, 27 Dec 2013 20:15:15 +0800
Message-Id: <1388146515-19481-1-git-send-email-scott.liu@emc.com.tw>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scott Liu <scott.liu@emc.com.tw>

This patch is for Elan eKTH Touchscreen product, I2C adpater module.

Signed-off-by: Scott Liu <scott.liu@emc.com.tw>
---
 drivers/input/touchscreen/Kconfig      |   12 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/elants_i2c.c | 1789 ++++++++++++++++++++++++++++++++
 3 files changed, 1802 insertions(+)
 create mode 100644 drivers/input/touchscreen/elants_i2c.c

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 961d58d..b400faa 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -317,6 +317,18 @@ config TOUCHSCREEN_GUNZE
 	  To compile this driver as a module, choose M here: the
 	  module will be called gunze.
 
+config TOUCHSCREEN_ELAN
+	tristate "Elan touchscreens"
+	depends on I2C
+	help
+	  Say Y here if you have an Elan touchscreen connected to
+	  your system.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called elan.
+
 config TOUCHSCREEN_ELO
 	tristate "Elo serial touchscreens"
 	select SERIO
diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
index 62801f2..687d5a7 100644
--- a/drivers/input/touchscreen/Makefile
+++ b/drivers/input/touchscreen/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_TOUCHSCREEN_EDT_FT5X06)	+= edt-ft5x06.o
 obj-$(CONFIG_TOUCHSCREEN_HAMPSHIRE)	+= hampshire.o
 obj-$(CONFIG_TOUCHSCREEN_GUNZE)		+= gunze.o
 obj-$(CONFIG_TOUCHSCREEN_EETI)		+= eeti_ts.o
+obj-$(CONFIG_TOUCHSCREEN_ELAN)		+= elants_i2c.o
 obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
 obj-$(CONFIG_TOUCHSCREEN_EGALAX)	+= egalax_ts.o
 obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
diff --git a/drivers/input/touchscreen/elants_i2c.c b/drivers/input/touchscreen/elants_i2c.c
new file mode 100644
index 0000000..e46675a
--- /dev/null
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -0,0 +1,1789 @@
+/*
+ * Elan Microelectronics touchpanels with I2C interface
+ *
+ * Copyright (C) 2012 Elan Microelectronics Corporation.
+ * Scott Liu <scott.liu@emc.com.tw>
+ *
+ * This code is partly based on hid-multitouch.c:
+ *
+ *  Copyright (c) 2010-2012 Stephane Chatty <chatty@enac.fr>
+ *  Copyright (c) 2010-2012 Benjamin Tissoires <benjamin.tissoires@gmail.com>
+ *  Copyright (c) 2010-2012 Ecole Nationale de l'Aviation Civile, France
+ *
+ */
+
+/*
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/input.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/async.h>
+#include <linux/i2c.h>
+#include <linux/delay.h>
+#include <linux/uaccess.h>
+#include <linux/buffer_head.h>
+#include <linux/version.h>
+#include <linux/kfifo.h>
+#include <linux/slab.h>
+#include <linux/debugfs.h>
+#include <linux/firmware.h>
+#include <linux/version.h>
+#include <linux/input/mt.h>
+
+/* debug option */
+static bool debug = false;
+module_param(debug, bool, 0444);
+MODULE_PARM_DESC(debug, "print a lot of debug information");
+
+#define elan_dbg(client, fmt, arg...)   \
+	do {	\
+		if (debug)      \
+			dev_printk(KERN_DEBUG, \
+				&client->dev, fmt, ##arg);	\
+	} while (0)
+
+/*
+ * Device, Driver information
+ */
+#define DEVICE_NAME	"elants_i2c"
+
+#define DRV_MA_VER 1
+#define DRV_MI_VER 0
+#define DRV_SUB_MI_VER 4
+
+#define _str(s) (#s)
+#define str(s)  _str(s)
+#define DRIVER_VERSION  str(DRV_MA_VER.DRV_MI_VER.DRV_SUB_MI_VER)
+
+/* For CMT (must match XRANGE/YRANGE as defined in board config */
+#define X_PIXELS_PER_MM	13
+#define Y_PIXELS_PER_MM	14
+
+/*
+ * Finger report description
+ */
+
+#define MAX_CONTACT_NUM	10
+
+/*
+ * kfifo buffer size, used for Read command handshake
+ */
+
+#define FIFO_SIZE       (64)
+
+/*
+ *Convert from rows or columns into resolution
+ */
+
+#define ELAN_TS_RESOLUTION(n)   ((n - 1) * 64)
+
+static const char hello_packet[4] = { 0x55, 0x55, 0x55, 0x55 };
+static const char iniap_packet[4] = { 0x55, 0xaa, 0x33, 0xcc };
+static const char recov_packet[4] = { 0x55, 0x55, 0x80, 0x80 };
+
+/*
+ * Elan I2C Address definition
+ */
+
+#define	DEV_MASTER	0x10
+#define	DEV_SLAVE1	0x20
+#define	DEV_SLAVE2	0x21
+#define	MAX_DEVICE	3
+
+/*
+ * Finger report header byte definition
+ */
+
+#define	REPORT_HEADER_10_FINGER	0x62
+
+/*
+ * Buffer mode Queue Header information
+ */
+
+#define	QUEUE_HEADER_SINGLE	0x62
+#define	QUEUE_HEADER_NORMAL	0X63
+#define QUEUE_HEADER_WAIT	0x64
+#define	QUEUE_HEADER_SIZE	4
+
+#define PACKET_SIZE	55
+#define	MAX_PACKET_LEN	169
+
+/*
+ * Command header definition
+ */
+
+#define	CMD_HEADER_WRITE	0x54
+#define	CMD_HEADER_READ	0x53
+#define CMD_HEADER_6B_READ	0x5B
+#define	CMD_HEADER_RESP	0x52
+#define	CMD_HEADER_6B_RESP	0x9B
+#define	CMD_HEADER_HELLO	0x55
+#define	CMD_HEADER_REK	0x66
+#define	CMD_RESP_LEN	4
+
+/*
+ * FW information position
+ */
+
+#define	FW_POS_HEADER	0
+#define	FW_POS_STATE	1
+#define	FW_POS_TOTAL	2
+#define	FW_POS_CHECKSUM	34
+#define	FW_POS_WIDTH	35
+#define FW_POS_PRESSURE 45
+
+/*
+ * test_bit definition
+ */
+
+#define	LOCK_FILE_OPERATE	0
+#define	LOCK_CMD_HANDSHAKE	1
+#define	LOCK_FINGER_REPORT	2
+#define	LOCK_FW_UPDATE	3
+
+/*
+ * kfifo return value definition
+ */
+
+#define RET_OK	0
+#define	RET_CMDRSP	1
+#define	RET_FAIL	-1
+
+/*
+ * define boot condition definition
+ */
+
+#define	E_BOOT_NORM	0
+#define	E_BOOT_IAP	1
+
+/* FW read command, 0x53 0x?? 0x0, 0x01 */
+#define	E_ELAN_INFO_FW_VER	0x00
+#define	E_ELAN_INFO_BC_VER	0x10
+#define E_ELAN_INFO_TEST_VER	0xe0
+#define	E_ELAN_INFO_FW_ID	0xf0
+
+/**
+ * struct multi_queue_header - used by buffer queue header
+ *
+ * @packet_id: packet_id represented status of buffer.
+ * @report_count: number of finger report in buffer.
+ * @report_length: total length exclusive queue length.
+ */
+struct multi_queue_header {
+	u8 packet_id;
+	u8 report_count;
+	u8 report_length;
+	u8 reserved;
+};
+
+struct mt_slot {
+	__s32 x, y, p, w, h;
+	__s32 contactid;	/* the device ContactID assigned to this slot */
+	bool touch_state;	/* is the touch valid? */
+	bool seen_in_this_frame;	/* has this slot been updated */
+};
+
+struct mt_device {
+	struct mt_slot curdata;	/* placeholder of incoming data */
+	__u8 num_received;	/* how many contacts we received */
+	__u8 num_expected;	/* expected last contact index */
+	__u8 maxcontacts;
+	bool curvalid;		/* is the current contact valid? */
+	unsigned mt_flags;	/* flags to pass to input-mt */
+	struct mt_slot *slots;
+};
+
+/**
+ * struct elants_data - represents a global define of elants device
+ */
+struct elants_data {
+
+	bool irq_wake;
+
+	/* [0] : Solution version
+	   [1] : minor version */
+	union {
+		u8 _fw_version[2];
+		u16 fw_version;
+	};
+
+	u8 bc_version;
+	u8 iap_version;
+
+	union {
+		u8 _test_version[2];
+		u16 test_version;
+	};
+
+	bool fw_enabled;
+	int rows;
+	int cols;
+	int x_max;
+	int y_max;
+#define IAP_MODE_ENABLE	1
+	unsigned int iap_mode;
+	unsigned int rx_size;
+
+	u8 packet_size;
+
+	struct multi_queue_header mq_header;
+
+	struct i2c_client *client;
+	struct input_dev *input;
+	struct task_struct *thread;
+
+	struct mutex mutex;	/* Protects I2C accesses to device */
+	struct mutex tr_mutex;	/* Protects I2C tx/rx */
+
+	unsigned long flags;	/* device flags */
+
+	unsigned short i2caddr;
+
+	struct kfifo fifo;
+	struct mutex fifo_mutex;
+	wait_queue_head_t wait;
+	spinlock_t rx_kfifo_lock;
+
+	struct mt_device td;	/* mt device */
+
+	/* fields required for debug fs */
+	struct mutex dbfs_mutex;
+	struct dentry *dbfs_root;
+
+	/* Add for TS driver debug */
+	long int irq_received;
+	long int packet_received;
+	long int touched_sync;
+	long int no_touched_sync;
+	long int checksum_correct;
+	long int wdt_reset;
+	u16 checksum_fail;
+	u16 header_fail;
+	u16 mq_header_fail;
+};
+
+/*
+ *  Function implement
+ */
+static inline void elan_msleep(u32 t)
+{
+	/*
+	 * If the sleeping time is 10us - 20ms, usleep_range() is recommended.
+	 * Read Documentation/timers/timers-howto.txt
+	 */
+	usleep_range(t * 1000, t * 1000 + 500);
+}
+
+static inline bool elan_chip_number(u8 addr)
+{
+	return addr == DEV_MASTER ? 1 : 0;
+}
+
+/**
+ *	elan_set_data - set command to TP.
+ *
+ *	@client: our i2c device
+ *	@data: command or data which will send to TP.
+ *	@len: command length usually.
+ *
+ *	set command to our TP.
+ */
+static int elan_set_data(struct i2c_client *client, const u8 *data, size_t len)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	struct i2c_adapter *adap = client->adapter;
+	struct i2c_msg msg;
+	int rc = 0;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+	elan_dbg(client,
+		 "%s cmd: %*phC, addr=%x\n",
+		 __func__, (int)len, data, ts->i2caddr);
+
+	mutex_lock(&ts->tr_mutex);
+
+	msg.addr = ts->i2caddr;
+	msg.flags = ts->client->flags & I2C_M_TEN;
+	msg.len = len;
+	msg.buf = (char *)data;
+
+	rc = i2c_transfer(adap, &msg, 1);
+	if (rc != 1)
+		dev_err(&ts->client->dev,
+			"i2c_transfer write fail, rc=%d\n", rc);
+
+	mutex_unlock(&ts->tr_mutex);
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #0
+	   transmitted, else error code. */
+	return (rc < 0) ? -EIO : 0;
+
+}
+
+/**
+ *	elan_get_data - get command to TP.
+ *
+ *	@client: our i2c device
+ *	@data: data to be received from TP.
+ *	@len: command length usually.
+ *
+ *	get data from our TP.
+ */
+static int elan_get_data(struct i2c_client *client, const u8 *buf, size_t len)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	struct i2c_adapter *adap = client->adapter;
+	struct i2c_msg msg;
+	int rc = 0;
+
+	dev_dbg(&client->dev, "Enter: %s id:0x%x\n", __func__, ts->i2caddr);
+
+	mutex_lock(&ts->tr_mutex);
+
+	msg.addr = ts->i2caddr;
+	msg.flags = client->flags & I2C_M_TEN;
+	msg.flags |= I2C_M_RD;
+	msg.len = len;
+	msg.buf = (char *)buf;
+
+	rc = i2c_transfer(adap, &msg, 1);
+	if (rc != 1)
+		dev_err(&client->dev, "i2c_transfer read fail, rc=%d\n", rc);
+
+	elan_dbg(client, "%s len=%zu data:%*phC\n",
+		 __func__, len, (int)len, buf);
+
+	mutex_unlock(&ts->tr_mutex);
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #0
+	   transmitted, else error code. */
+	return rc != 1 ? -EIO : 0;
+}
+
+/**
+ *	elan_i2c_read_block
+ *
+ *	@client: our i2c device
+ *	@cmd: command
+ *	@val: data to be received from TP.
+ *	@len: command length usually.
+ *
+ *	get data from our TP by continueous read.
+ */
+static int elan_i2c_read_block(struct i2c_client *client,
+			       u8 *cmd, u8 *val, u16 len)
+{
+	struct i2c_msg msgs[2];
+	int ret;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	msgs[0].addr = client->addr;
+	msgs[0].flags = client->flags & I2C_M_TEN;
+	msgs[0].len = 4;
+	msgs[0].buf = cmd;
+
+	msgs[1].addr = client->addr;
+	msgs[1].flags = client->flags & I2C_M_TEN;
+	msgs[1].flags |= I2C_M_RD;
+	msgs[1].len = len;
+	msgs[1].buf = val;
+
+	ret = i2c_transfer(client->adapter, msgs, 2);
+	return (ret == 2) ? len : ret;
+}
+
+static int elan_dbfs_open(struct inode *inode, struct file *file)
+{
+	int retval = 0;
+	struct elants_data *ts = inode->i_private;
+
+	dev_dbg(&ts->client->dev, "Enter %s\n", __func__);
+
+	if (!ts)
+		return -ENODEV;
+
+	retval = mutex_lock_interruptible(&ts->dbfs_mutex);
+	if (retval)
+		return retval;
+
+	if (!kobject_get(&ts->client->dev.kobj)) {
+		retval = -ENODEV;
+		goto dbfs_out;
+	}
+
+	file->private_data = ts;
+dbfs_out:
+	mutex_unlock(&ts->dbfs_mutex);
+	return retval;
+}
+
+static ssize_t elan_dbfs_read(struct file *file,
+			      char __user *buffer, size_t count, loff_t *ppos)
+{
+	u8 rxbuf[256];
+	int ret;
+	struct elants_data *ts = file->private_data;
+	struct i2c_adapter *adap = ts->client->adapter;
+	struct i2c_msg msg;
+
+	if (count > 256)
+		return -EMSGSIZE;
+
+	msg.addr = ts->i2caddr;
+	msg.flags = ts->client->flags & I2C_M_TEN;
+	msg.flags |= I2C_M_RD;
+	msg.len = count;
+	msg.buf = rxbuf;
+
+	ret = i2c_transfer(adap, &msg, 1);
+	if (ret == 1)
+		if (copy_to_user(buffer, rxbuf, count))
+			return -EFAULT;
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #bytes
+	   transmitted, else error code. */
+	return (ret == 1) ? count : ret;
+}
+
+static ssize_t elan_dbfs_write(struct file *file,
+			       const char __user *buffer, size_t count,
+			       loff_t *ppos)
+{
+	int ret;
+	u8 txbuf[256];
+	struct elants_data *ts = file->private_data;
+	struct i2c_adapter *adap = ts->client->adapter;
+	struct i2c_msg msg;
+
+	if (count > 256)
+		return -EMSGSIZE;
+
+	if (copy_from_user(txbuf, buffer, count))
+		return -EFAULT;
+
+	msg.addr = ts->i2caddr;
+	msg.flags = ts->client->flags & I2C_M_TEN;
+	msg.len = count;
+	msg.buf = (char *)txbuf;
+
+	ret = i2c_transfer(adap, &msg, 1);
+	if (ret != 1)
+		dev_err(&ts->client->dev,
+			"i2c_master_send fail, ret=%d\n", ret);
+
+	/* If everything went ok (i.e. 1 msg transmitted), return #bytes
+	   transmitted, else error code. */
+	return (ret == 1) ? count : ret;
+}
+
+static int elan_dbfs_release(struct inode *inode, struct file *file)
+{
+	struct elants_data *ts = file->private_data;
+
+	if (!ts)
+		return -ENODEV;
+
+	if (ts->dbfs_root) {
+		debugfs_remove_recursive(ts->dbfs_root);
+		mutex_destroy(&ts->dbfs_mutex);
+	}
+
+	return 0;
+}
+
+static const struct file_operations elan_debug_fops = {
+	.owner = THIS_MODULE,
+	.open = elan_dbfs_open,
+	.release = elan_dbfs_release,
+	.read = elan_dbfs_read,
+	.write = elan_dbfs_write,
+};
+
+static int elan_dbfs_init(struct elants_data *ts)
+{
+	/* Create a global debugfs root for all elan ts devices */
+	ts->dbfs_root = debugfs_create_dir(DEVICE_NAME, NULL);
+	if (ts->dbfs_root == ERR_PTR(-ENODEV))
+		ts->dbfs_root = NULL;
+
+	mutex_init(&ts->dbfs_mutex);
+
+	debugfs_create_file("elan-iap", 0777,
+			    ts->dbfs_root, ts, &elan_debug_fops);
+
+	return 0;
+}
+
+/**
+ * elan_sw_reset - software reset.
+ *
+ * @client: our i2c device
+ *	retval >0 means reset success,
+ *	otherwise is fail.
+ *
+ */
+static int elan_sw_reset(struct i2c_client *client)
+{
+	int ret;
+	const u8 srst[4] = { 0x77, 0x77, 0x77, 0x77 };
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	ret = i2c_master_send(client, srst, sizeof(srst));
+
+	if (ret != sizeof(srst)) {
+		dev_err(&client->dev, "%s: i2c_master_send failed\n", __func__);
+		return -ENODEV;
+	}
+
+	/* Wait to send fastboot command */
+	elan_msleep(10);
+
+	return ret;
+}
+
+static int elan_boot(struct i2c_client *client, u16 addr, u8 type)
+{
+	int rc;
+	struct elants_data *ts = i2c_get_clientdata(client);
+	uint8_t command[2][4] = {
+		{0x4D, 0x61, 0x69, 0x6E},
+		{0x45, 0x49, 0x41, 0x50},
+	};
+
+	ts->i2caddr = addr;
+	rc = elan_set_data(client, command[(int32_t) type], 4);
+	if (rc < 0) {
+		if (type == E_BOOT_IAP)
+			dev_err(&client->dev, "Boot IAP fail, error=%d\n", rc);
+		else
+			dev_dbg(&client->dev,
+				"Boot normal fail, error=%d\n", rc);
+		ts->i2caddr = DEV_MASTER;
+		return -EINVAL;
+	}
+	dev_info(&client->dev, "Boot success -- 0x%x\n", addr);
+	ts->i2caddr = DEV_MASTER;
+	return 0;
+}
+
+/**
+ *	__hello_packet_handler	- hadle hello packet.
+ *
+ *	@client: our i2c device
+ *	@return:
+ *		>0 means success,
+ *		otherwise fail.
+ *
+ *	Normal hello packet is {0x55, 0x55, 0x55, 0x55}
+ *	recovery mode hello packet is {0x55, 0x55, 0x80, 0x80}
+ */
+static int __hello_packet_handler(struct i2c_client *client)
+{
+	int rc = 0;
+	uint8_t buf_recv[4] = { 0 };
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	rc = elan_get_data(client, buf_recv, 4);
+
+	/* Print buf_recv anyway */
+	dev_info(&client->dev, "rc=%d HelloPacket:%*phC\n",
+			rc, 4, buf_recv);
+
+	if (rc < 0) {
+		dev_err(&client->dev,
+			"%s: Try recovery because of no hello\n", __func__);
+	}
+
+	if (memcmp(buf_recv, hello_packet, 4)) {
+		if (!memcmp(buf_recv, recov_packet, 4)) {
+			dev_info(&client->dev,
+				 "got mainflow recovery message\n");
+
+			ts->iap_mode = IAP_MODE_ENABLE;
+			set_bit(LOCK_FW_UPDATE, &ts->flags);
+		}
+
+		return -ENODEV;
+	}
+
+	ts->i2caddr = DEV_MASTER;
+
+	return rc;
+}
+
+/**
+ * Firmware version is for something big movement.
+ * ex: CodeBase update.
+ */
+static int __fw_packet_handler(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc, tries = 3;
+	const uint8_t cmd[] = { CMD_HEADER_READ,
+		E_ELAN_INFO_FW_VER, 0x00, 0x01
+	};
+	uint8_t buf_recv[4] = { 0x0 };
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+retry:
+	rc = elan_i2c_read_block(client, (u8 *) cmd, buf_recv, 4);
+	if (rc < 0)
+		elan_dbg(client,
+			 "read fw version rc=%d, buf=%*phC\n", rc, 4, buf_recv);
+
+	if (buf_recv[0] == CMD_HEADER_RESP) {
+		ts->_fw_version[0] = ((buf_recv[1] & 0x0f) << 4) |
+		    ((buf_recv[2] & 0xf0) >> 4);
+		ts->_fw_version[1] = ((buf_recv[2] & 0x0f) << 4) |
+		    ((buf_recv[3] & 0xf0) >> 4);
+
+		if (ts->fw_version == 0x00 || ts->fw_version == 0xFF) {
+			dev_err(&client->dev,
+				"\n\nFW version is empty, "
+				"suggest IAP ELAN chip\n\n");
+			return -EINVAL;
+		}
+	} else {
+		elan_dbg(client, "read fw retry tries=%d\n", tries);
+		if (tries > 0) {
+			tries--;
+			goto retry;
+		}
+
+		ts->fw_version = 0xffff;
+		dev_err(&client->dev,
+			"\n\nFW version is empty, "
+			"suggest IAP ELAN chip\n\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * Test version is for something minor change.
+ * ex: parameters, coordination
+ */
+static int __test_packet_handler(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc, tries = 3;
+	const uint8_t cmd[] = { CMD_HEADER_READ,
+		E_ELAN_INFO_TEST_VER, 0x00, 0x01
+	};
+	uint8_t buf_recv[4] = { 0x0 };
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+retry:
+	rc = elan_i2c_read_block(client, (u8 *) cmd, buf_recv, 4);
+	if (rc < 0) {
+		elan_dbg(client, "read test version error rc=%d, buf=%*phC\n",
+			 rc, 4, buf_recv);
+		return rc;
+	}
+
+	if (buf_recv[0] == CMD_HEADER_RESP) {
+		ts->_test_version[0] = ((buf_recv[1] & 0x0f) << 4) |
+		    ((buf_recv[2] & 0xf0) >> 4);
+		ts->_test_version[1] = ((buf_recv[2] & 0x0f) << 4) |
+		    ((buf_recv[3] & 0xf0) >> 4);
+	} else {
+		elan_dbg(client, "read fw retry tries=%d\n", tries);
+		if (tries > 0) {
+			tries--;
+			goto retry;
+		}
+		ts->test_version = 0xffff;
+		dev_err(&client->dev, "Get test version fail\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __tp_info_handler(struct i2c_client *client)
+{
+	struct i2c_msg msgs[2];
+	struct elants_data *ts = i2c_get_clientdata(client);
+	int rc;
+	uint8_t buf_recv[17] = { 0x0 };
+	const uint8_t get_resolution_cmd[] = {
+		CMD_HEADER_6B_READ, 0x00, 0x00, 0x00, 0x00, 0x00
+	};
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+
+	msgs[0].addr = client->addr;
+	msgs[0].flags = client->flags & I2C_M_TEN;
+	msgs[0].len = 6;
+	msgs[0].buf = (u8 *) get_resolution_cmd;
+
+	msgs[1].addr = client->addr;
+	msgs[1].flags = client->flags & I2C_M_TEN;
+	msgs[1].flags |= I2C_M_RD;
+	msgs[1].len = sizeof(buf_recv);
+	msgs[1].buf = buf_recv;
+
+	rc = i2c_transfer(client->adapter, msgs, 2);
+	if (rc < 0) {
+		elan_dbg(client, "tp_info error rc=%d\n", rc);
+		return rc;
+	}
+
+	if (buf_recv[0] != CMD_HEADER_6B_RESP)
+		return -EINVAL;
+
+	ts->rows = (buf_recv[2] + buf_recv[6] + buf_recv[10]);
+	ts->cols = (buf_recv[3] + buf_recv[7] + buf_recv[11]);
+
+	if (ts->rows < 2 || ts->cols < 2) {
+		dev_warn(&client->dev,
+			 "Invalid resolution (%d, %d)\n", ts->rows, ts->cols);
+
+		ts->rows = -1;
+		ts->cols = -1;
+
+		return 0;
+	}
+
+	return 0;
+}
+
+/**
+*	elan_touch_get_bc_ver	- obtain bootcode data from device
+*
+*	@client: the interface we are querying
+*
+*	Send a bootcode version command and fill the results into the
+*	elan device structures. Caller must hold the mutex
+*
+*	Returns 0 or an error code
+*/
+static int __bc_packet_handler(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 get_bc_ver_cmd[] = { CMD_HEADER_READ,
+		E_ELAN_INFO_BC_VER, 0x00, 0x01
+	};
+	u8 buf_recv[4];
+	int rc;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+
+	rc = elan_i2c_read_block(client, (u8 *) get_bc_ver_cmd,
+				 buf_recv, sizeof(buf_recv));
+	if (rc < 0) {
+		dev_err(&client->dev,
+			"Read FW version error rc=%d, buf=%*phC\n", rc, 4,
+			buf_recv);
+		return rc;
+	}
+
+	ts->bc_version = (((buf_recv[1] & 0x0f) << 4) |
+			  ((buf_recv[2] & 0xf0) >> 4));
+	ts->iap_version = (((buf_recv[2] & 0x0f) << 4) |
+			   ((buf_recv[3] & 0xf0) >> 4));
+	return 0;
+}
+
+static int __elan_fastboot(struct i2c_client *client)
+{
+	int rc = 0;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	rc = elan_boot(client, DEV_MASTER, E_BOOT_NORM);
+	if (rc < 0)
+		return -1;
+
+	/* Wait for Hello packets */
+	msleep(50);
+
+	return rc;
+}
+
+static int elan_open(struct input_dev *input)
+{
+	struct elants_data *ts = input_get_drvdata(input);
+
+	dev_dbg(&ts->client->dev, "Enter: %s\n", __func__);
+
+	return 0;
+}
+
+static void elan_close(struct input_dev *input)
+{
+	struct elants_data *ts = input_get_drvdata(input);
+
+	dev_dbg(&ts->client->dev, "Enter %s\n", __func__);
+
+	return;
+}
+
+/**
+*	elan_touch_pull_frame - pull a frame from the fifo
+*
+*	@ts: our elan touch device
+*	@buf: data buffer
+*
+*	Pulls a frame from the FIFO into the provided ehr and data buffer.
+*	The data buffer must be at least CMD_RESP_LEN bytes long.
+*/
+static int elan_touch_pull_frame(struct elants_data *ts, u8 *buf)
+{
+	dev_dbg(&ts->client->dev, "Enter: %s\n", __func__);
+
+	WARN_ON(kfifo_out_locked(&ts->fifo, buf, CMD_RESP_LEN,
+				 &ts->rx_kfifo_lock)
+		!= CMD_RESP_LEN);
+	return CMD_RESP_LEN;
+}
+
+/**
+ *	elan_touch_fifo_clean_old - Make room for new frames
+ *
+ *	@ed: our elan touch device
+ *	@room: space needed
+ *
+ *	Empty old frames out of the FIFO until we can fit the new one into
+ *	the other end.
+ */
+static void elan_touch_fifo_clean_old(struct elants_data *ts, int room)
+{
+	u8 buffer[CMD_RESP_LEN];
+
+	dev_dbg(&ts->client->dev, "Enter: %s\n", __func__);
+
+	while (kfifo_len(&ts->fifo) + room >= FIFO_SIZE)
+		elan_touch_pull_frame(ts, buffer);
+}
+
+/**
+ *	elan_getrepoinfo - parse Multi-queue report header
+ *
+ *	@client: our i2c device
+ *	@buf: buffer data
+ *
+ *	parsing report header and get data length.
+ *
+ */
+static int elan_getrepoinfo(struct i2c_client *client, uint8_t *buf)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	struct multi_queue_header *buff = (struct multi_queue_header *)buf;
+	struct multi_queue_header *mq = &ts->mq_header;
+	const u8 wait_packet[4] = { 0x64, 0x64, 0x64, 0x64 };
+	int times = 10, rc = 0;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	switch (buf[FW_POS_HEADER]) {
+	case CMD_HEADER_HELLO:
+		if (!memcmp(buf, hello_packet, 4))
+			ts->wdt_reset++;
+		return RET_CMDRSP;
+	case CMD_HEADER_RESP:
+	case CMD_HEADER_REK:
+		/* Queue the data, using the fifo lock to serialize
+		 * the multiple accesses to the FIFO
+		 */
+		elan_dbg(client, "recv CMD_HEADER_RESP\n");
+
+		mutex_lock(&ts->fifo_mutex);
+		if (kfifo_len(&ts->fifo) + CMD_RESP_LEN >= FIFO_SIZE)
+			elan_touch_fifo_clean_old(ts, CMD_RESP_LEN);
+		/* Push the data */
+		kfifo_in_locked(&ts->fifo, buf,
+				CMD_RESP_LEN, &ts->rx_kfifo_lock);
+		mutex_unlock(&ts->fifo_mutex);
+
+		elan_dbg(client, "wake_up [%*phC]\n", 4, buf);
+		wake_up_interruptible(&ts->wait);
+		return RET_CMDRSP;
+		/* Buffer mode header */
+	case QUEUE_HEADER_NORMAL:
+		elan_dbg(client,
+			 "report_count=%d report_len=%d\n",
+			 buff->report_count, buff->report_length);
+
+		if (buff->report_count <= 3) {
+			mq->report_count = buff->report_count;
+			mq->report_length = buff->report_length;
+			ts->rx_size = mq->report_length;
+			ts->packet_size = mq->report_length / mq->report_count;
+		} else
+			return RET_FAIL;
+
+		break;
+	case QUEUE_HEADER_WAIT:
+		dev_info(&client->dev,
+			 "QUEUE_HEADER_WAIT %x:%x:%x:%x\n",
+			 buf[0], buf[1], buf[2], buf[3]);
+		/* BUGFIX: buff[0] might be wrong (0x63),
+		 * check buff[1 ~ 3] is enough
+		 */
+		if (!memcmp(buf + 1, &wait_packet[1], 3)) {
+			do {
+				udelay(30);
+				elan_get_data(client, (u8 *) buff, ts->rx_size);
+			} while ((buff->packet_id != QUEUE_HEADER_NORMAL) &&
+				 (--times > 0));
+			if (times > 0)
+				rc = elan_getrepoinfo(client, (uint8_t *) buff);
+			else
+				return RET_FAIL;
+			elan_dbg(client,
+				 "Detect Wait_Header:rx_size=%d, "
+				 "report_count=%d report_len=%d\n",
+				 ts->rx_size,
+				 mq->report_count, mq->report_length);
+		} else
+			dev_err(&client->dev,
+				"ERROR!! wait header:%x:%x:%x:%x\n",
+				buf[0], buf[1], buf[2], buf[3]);
+		break;
+		/* Not buffer mode, it's single word mode */
+	case QUEUE_HEADER_SINGLE:
+		mq->report_count = 1;
+		mq->report_length = PACKET_SIZE;
+		ts->rx_size = mq->report_length;
+		return ts->rx_size;
+	default:
+		dev_err(&client->dev,
+			"unknown multi-queue command!! --%x %x:%x:%x--\n",
+			buf[0], buf[1], buf[2], buf[3]);
+		ts->mq_header_fail++;
+
+		/* If glitch causes frame error, drop all finger report */
+		ts->rx_size = MAX_PACKET_LEN;
+		elan_get_data(client, (u8 *) buff, ts->rx_size);
+		return RET_FAIL;
+	}
+
+	return ts->rx_size;
+}
+
+/**
+ *	elan_touch_checksum -  Add for checksum mechanism
+ *
+ *	@client : our i2c device
+ *	@buf : buffer data
+ *
+ *	caculating checksum for make sure all data validity.
+ */
+static int elan_touch_checksum(struct i2c_client *client, u8 *buf)
+{
+	u8 i = 0, checksum = 0;
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	for (i = 0; i < FW_POS_CHECKSUM; i++)
+		checksum = checksum + buf[i];
+
+	ts->checksum_correct = checksum;
+
+	if (checksum != buf[FW_POS_CHECKSUM]) {
+		ts->checksum_fail++;
+		dev_err(&client->dev,
+			"elan touch checksum fail: %02x:%02x\n",
+			checksum, buf[FW_POS_CHECKSUM]);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ *	elan_parse_fid - parse the 10 fid bits
+ *
+ *	@data: the input bit stream
+ *	@fid: an array of fid values
+ *
+ *	Unpack the 10 bits into an array.
+ *	FIXME: Review whether we can't just use << operators after making
+ *	sure the bits are native endian ?
+ */
+static inline void elan_parse_fid(u8 *data, u8 *fid)
+{
+	fid[0] = (data[0] & 0x01);
+	fid[1] = (data[0] & 0x02);
+	fid[2] = (data[0] & 0x04);
+	fid[3] = (data[0] & 0x08);
+	fid[4] = (data[0] & 0x10);
+	fid[5] = (data[0] & 0x20);
+	fid[6] = (data[0] & 0x40);
+	fid[7] = (data[0] & 0x80);
+	fid[8] = (data[1] & 0x10);
+	fid[9] = (data[1] & 0x20);
+}
+
+/**
+ *      elan_parse_wid - parse width data with length of 5-bit
+ *
+ *      @data: the input bit stream
+ *      @wid: an array of width level
+ *
+ *      Unpack the 10 bits into an array.
+ */
+static inline void elan_parse_wid(u8 *data, u8 *wid)
+{
+	wid[0] = (data[0] & 0x1f);
+	wid[1] = (data[1] & 0x1f);
+	wid[2] = (data[2] & 0x1f);
+	wid[3] = (data[3] & 0x1f);
+	wid[4] = (data[4] & 0x1f);
+	wid[5] = (data[5] & 0x1f);
+	wid[6] = (data[6] & 0x1f);
+	wid[7] = (data[7] & 0x1f);
+	wid[8] = (data[8] & 0x1f);
+	wid[9] = (data[9] & 0x1f);
+
+	return;
+}
+
+/**
+ *      elan_parse_pid - parse pressure data with length of 8-bit
+ *
+ *      @data: the input bit stream
+ *      @wid: an array of width level
+ *
+ *      Unpack the 10 bits into an array.
+ */
+static inline void elan_parse_pid(u8 *data, u8 *pressure)
+{
+	pressure[0] = data[0];
+	pressure[1] = data[1];
+	pressure[2] = data[2];
+	pressure[3] = data[3];
+	pressure[4] = data[4];
+	pressure[5] = data[5];
+	pressure[6] = data[6];
+	pressure[7] = data[7];
+	pressure[8] = data[8];
+	pressure[9] = data[9];
+
+	return;
+}
+
+static inline int elan_parse_xy(uint8_t *data, uint16_t *x, uint16_t *y)
+{
+	*x = *y = 0;
+
+	*x = (data[0] & 0xf0);
+	*x <<= 4;
+	*x |= data[1];
+
+	*y = (data[0] & 0x0f);
+	*y <<= 8;
+	*y |= data[2];
+
+	return 0;
+}
+
+static inline int elan_lookup_wid(u8 data, u16 *w, u16 *h)
+{
+	static u16 pre_w = 0, pre_h = 0, cur_w, cur_h;
+	const u8 width_lookup_table[15][2] = {
+		{3, 2}, {3, 2}, {6, 3},
+		{6, 3}, {10, 3}, {15, 4},
+		{15, 5}, {15, 5}, {15, 5},
+		{15, 5}, {15, 5}, {15, 5},
+		{15, 5}, {15, 5}, {15, 5},
+	};
+
+	cur_w = width_lookup_table[data][0] * 17;
+	cur_h = width_lookup_table[data][1] * 17;
+
+	*w = (cur_w + pre_w) >> 1;
+	*h = (cur_h + pre_h) >> 1;
+
+	pre_w = cur_w;
+	pre_h = cur_h;
+
+	return 0;
+}
+
+static int elan_mt_compute_slot(struct mt_device *td)
+{
+	int i;
+	for (i = 0; i < td->maxcontacts; ++i) {
+		if (td->slots[i].contactid == td->curdata.contactid &&
+		    td->slots[i].touch_state)
+			return i;
+	}
+	for (i = 0; i < td->maxcontacts; ++i) {
+		if (!td->slots[i].seen_in_this_frame &&
+		    !td->slots[i].touch_state)
+			return i;
+	}
+	/* should not occurs. If this happens that means
+	 * that the device sent more touches that it says
+	 * in the report descriptor. It is ignored then. */
+	return -1;
+}
+
+/*
+* this function is called when a whole contact has been processed,
+* so that it can assign it to a slot and store the data there
+*/
+static void elan_mt_complete_slot(struct mt_device *td)
+{
+	td->curdata.seen_in_this_frame = true;
+	if (td->curvalid) {
+		int slotnum = elan_mt_compute_slot(td);
+
+		if (slotnum >= 0 && slotnum < td->maxcontacts)
+			td->slots[slotnum] = td->curdata;
+	}
+	td->num_received++;
+}
+
+/*
+* this function is called when a whole packet has been received and processed,
+* so that it can decide what to send to the input layer.
+*/
+static void elan_mt_emit_event(struct mt_device *td, struct input_dev *input)
+{
+	struct elants_data *ts = container_of(td, struct elants_data, td);
+	int i;
+
+	for (i = 0; i < td->maxcontacts; ++i) {
+		struct mt_slot *s = &(td->slots[i]);
+		if (!s->seen_in_this_frame)
+			s->touch_state = false;
+
+		input_mt_slot(input, i);
+		input_mt_report_slot_state(input, MT_TOOL_FINGER,
+					   s->touch_state);
+		if (s->touch_state) {
+			/* this finger is on the screen */
+			int major = max(s->w, s->h), minor = min(s->w, s->h);
+
+			elan_dbg(ts->client, "i=%d x=%d y=%d p=%d w=%d h=%d.\n",
+				 i, s->x, s->y, s->p, major, minor);
+
+			input_event(input, EV_ABS, ABS_MT_POSITION_X, s->x);
+			input_event(input, EV_ABS, ABS_MT_POSITION_Y, s->y);
+			input_event(input, EV_ABS, ABS_MT_PRESSURE, s->p);
+			input_event(input, EV_ABS, ABS_MT_TOUCH_MAJOR, major);
+		}
+		s->seen_in_this_frame = false;
+	}
+
+	input_mt_report_pointer_emulation(input, true);
+	input_sync(input);
+	td->num_received = 0;
+}
+
+/**
+ *	elan_mt_event - process finger reports
+ *	@ts: our touchscreen
+ *	@finger_stat: number of fingers in packet
+ *	@buf: received buffer
+ *
+ *	Walk the received report and process the finger data, extracting
+ *	and reporting co-ordinates. No locking is needed here as the workqueue
+ *	does our threading for us.
+ */
+static int elan_mt_event(struct elants_data *ts, int finger_stat, u8 *buf)
+{
+	int i;
+	u8 fid[MAX_CONTACT_NUM] = { 0 };
+	u8 wid[MAX_CONTACT_NUM] = { 0 };
+	u8 pid[MAX_CONTACT_NUM] = { 0 };
+	u16 x = 0, y = 0, w = 0, h = 0;
+	struct i2c_client *client = ts->client;
+	struct mt_device *td = &ts->td;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* Parsing Finger, Width, Pressure field */
+	elan_parse_fid(&buf[FW_POS_STATE], &fid[0]);
+	elan_parse_wid(&buf[FW_POS_WIDTH], &wid[0]);
+	elan_parse_pid(&buf[FW_POS_PRESSURE], &pid[0]);
+
+	/* number of fingers expects in this frame */
+	td->num_expected = finger_stat;
+	for (i = 0; i < td->maxcontacts; i++) {
+		if (finger_stat == 0)
+			break;
+
+		/* tracking id */
+		td->curdata.contactid = (fid[i] > 0) ? i + 1 : 0;
+
+		if (td->curdata.contactid == 0)
+			continue;
+
+		td->curdata.touch_state = true;
+
+		elan_parse_xy(&buf[3 + i * 3], &x, &y);
+		td->curdata.x = x;
+		td->curdata.y = y;
+		td->curdata.p = pid[i];
+
+		h = w = wid[i];
+		td->curdata.w = w;
+		td->curdata.h = h;
+
+		finger_stat--;
+
+		elan_mt_complete_slot(td);
+	}
+
+	if (td->num_received >= td->num_expected)
+		elan_mt_emit_event(td, ts->input);
+
+	return 1;
+}
+
+/**
+ *	elan_report_data - report finger report to user space.
+ *
+ *	@client : our i2c device
+ *	@buf : raw data from TP device.
+ *
+ *	- reporting finger data to user space.
+ *
+ */
+static void elan_report_data(struct i2c_client *client, uint8_t *buf)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	switch (buf[FW_POS_HEADER]) {
+	case REPORT_HEADER_10_FINGER:{
+			u8 finger_stat = buf[FW_POS_TOTAL] & 0x0f;
+			elan_dbg(client, "finger_stat == %d\n", finger_stat);
+			elan_dbg(client, "finger:%*phC\n", 10, buf);
+
+			/* Enter right process, reset int_status */
+			ts->packet_received++;
+
+			if (likely(finger_stat != 0)) {
+				ts->td.curvalid = true;
+				ts->touched_sync++;
+			} else {
+				ts->no_touched_sync++;
+			}
+			elan_mt_event(ts, finger_stat, buf);
+		}
+		break;
+	default:
+		ts->header_fail++;
+		dev_warn(&client->dev,
+			 "%s: unknown packet type: %*phC\n", __func__, 10, buf);
+		break;
+	}
+
+	return;
+}
+
+static irqreturn_t elan_work_func(int irq, void *work)
+{
+	struct elants_data *ts = work;
+	struct i2c_client *client = ts->client;
+
+	uint8_t buf[MAX_PACKET_LEN] = { 0x0 };
+	u8 pos = 0, rc = 0;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	ts->irq_received++;
+
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return IRQ_HANDLED;
+
+	mutex_lock(&ts->mutex);
+
+	set_bit(LOCK_FINGER_REPORT, &ts->flags);
+
+	/* - Read multi_queue header */
+	rc = elan_get_data(client, (u8 *) buf, ts->rx_size);
+	if (rc < 0)
+		goto fail;
+
+	/*  - Get multi_queue header info */
+	rc = elan_getrepoinfo(ts->client, buf);
+	if (rc < 0 || rc == RET_CMDRSP)
+		goto fail;
+
+	/*  - check if packet size is valid */
+	if ((ts->packet_size != PACKET_SIZE)) {
+		dev_err(&ts->client->dev, "%s: uncorrect packet size = %d\n",
+			__func__, ts->packet_size);
+		goto fail;
+	}
+
+	/* - Get finger report data */
+	rc = elan_get_data(client, (u8 *) buf, ts->rx_size);
+	if (rc < 0)
+		goto fail;
+
+	clear_bit(LOCK_FINGER_REPORT, &ts->flags);
+
+	mutex_unlock(&ts->mutex);
+
+	/* - parsing report and send out */
+	while (ts->mq_header.report_count--) {
+		if (elan_touch_checksum(ts->client, buf + pos) == 0)
+			elan_report_data(ts->client, buf + pos);
+		pos = pos + ts->packet_size;
+		udelay(10);
+	}
+
+	ts->rx_size = QUEUE_HEADER_SIZE;
+
+	return IRQ_HANDLED;
+
+fail:
+	clear_bit(LOCK_FINGER_REPORT, &ts->flags);
+	mutex_unlock(&ts->mutex);
+	ts->rx_size = QUEUE_HEADER_SIZE;
+
+	return IRQ_HANDLED;
+}
+
+static int remove_elants(struct i2c_client *client)
+{
+	int ret = 0;
+	struct elants_data *ts = i2c_get_clientdata(client);
+
+	if ((client->irq))
+		free_irq(client->irq, ts);
+
+	if (ts->input)
+		input_unregister_device(ts->input);
+
+	if (&ts->mutex)
+		mutex_destroy(&ts->mutex);
+	if (&ts->tr_mutex)
+		mutex_destroy(&ts->tr_mutex);
+	if (&ts->fifo_mutex)
+		mutex_destroy(&ts->fifo_mutex);
+
+	kfree(ts->td.slots);
+	kfifo_free(&ts->fifo);
+	kfree(ts);
+
+	return ret;
+}
+
+static int elan_input_dev_create(struct elants_data *ts)
+{
+	int err = 0;
+	struct i2c_client *client = ts->client;
+
+	if (ts->rows > 0 && ts->cols > 0) {
+		/* translate trace number to TSP resolution */
+		ts->x_max = ELAN_TS_RESOLUTION(ts->rows);
+		ts->y_max = ELAN_TS_RESOLUTION(ts->cols);
+	} else
+		dev_warn(&client->dev, "trace number error, %d,%d\n",
+			 ts->rows, ts->cols);
+
+	/* Clear the existing one if it exists */
+	if (ts->input) {
+		input_unregister_device(ts->input);
+		ts->input = NULL;
+	}
+
+	ts->input = input_allocate_device();
+	if (ts->input == NULL) {
+		dev_err(&client->dev, "Failed to allocate input device\n");
+		return -ENOMEM;
+	}
+
+	ts->input->name = "Elan-Touchscreen";
+	ts->input->id.bustype = BUS_I2C;
+	ts->input->dev.parent = &ts->client->dev;
+	ts->input->open = elan_open;
+	ts->input->close = elan_close;
+
+	__set_bit(BTN_TOUCH, ts->input->keybit);
+	__set_bit(EV_ABS, ts->input->evbit);
+	__set_bit(EV_KEY, ts->input->evbit);
+
+	/*! - Single touch input params setup */
+	input_set_abs_params(ts->input, ABS_X, 0, ts->x_max, 0, 0);
+	input_set_abs_params(ts->input, ABS_Y, 0, ts->y_max, 0, 0);
+	input_set_abs_params(ts->input, ABS_PRESSURE, 0, 255, 0, 0);
+	input_abs_set_res(ts->input, ABS_X, X_PIXELS_PER_MM);
+	input_abs_set_res(ts->input, ABS_Y, Y_PIXELS_PER_MM);
+
+	ts->td.maxcontacts = MAX_CONTACT_NUM;
+	ts->td.mt_flags |= INPUT_MT_DIRECT;
+
+	/* Multitouch input params setup */
+	err =
+	    input_mt_init_slots(ts->input, ts->td.maxcontacts, ts->td.mt_flags);
+	if (err) {
+		dev_err(&client->dev,
+			"allocate memory for MT slots failed, %d\n", err);
+		goto err_free_device;
+	}
+
+	input_set_abs_params(ts->input, ABS_MT_POSITION_X, 0, ts->x_max, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_POSITION_Y, 0, ts->y_max, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_TOUCH_MAJOR, 0, 255, 0, 0);
+	input_set_abs_params(ts->input, ABS_MT_PRESSURE, 0, 255, 0, 0);
+	input_abs_set_res(ts->input, ABS_MT_POSITION_X, X_PIXELS_PER_MM);
+	input_abs_set_res(ts->input, ABS_MT_POSITION_Y, Y_PIXELS_PER_MM);
+
+	input_set_drvdata(ts->input, ts);
+
+	ts->td.slots = kzalloc(MAX_CONTACT_NUM * sizeof(struct mt_slot),
+			       GFP_KERNEL);
+	if (!ts->td.slots) {
+		dev_err(&client->dev, "cannot allocate multitouch slots\n");
+		goto err_free_device;
+	}
+
+	err = input_register_device(ts->input);
+	if (err) {
+		dev_err(&client->dev, "unable to register input device\n");
+		goto err_free_slot;
+	}
+
+	return 0;
+
+err_free_slot:
+	kfree(ts->td.slots);
+err_free_device:
+	input_free_device(ts->input);
+	ts->input = NULL;
+	return err;
+}
+
+/**
+ *	elan_initialize - initialization process.
+ *
+ *	@client: our i2c client
+ *
+ *	set our TP up
+ *	-# reset
+ *	-# hello packet
+ *	-# fw version
+ *	-# test version
+ *	-# TP info (resolution)
+ *
+ */
+static int elan_initialize(struct i2c_client *client)
+{
+	struct elants_data *ts = i2c_get_clientdata(client);
+	u8 buf[4] = { 0 };
+	int rc;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* handle recovery packets */
+	rc = elan_get_data(client, buf, 3);
+	if (rc == 0) {
+		if (!memcmp(buf, recov_packet + 2, 2)) {
+			ts->iap_mode = IAP_MODE_ENABLE;
+			set_bit(LOCK_FW_UPDATE, &ts->flags);
+			dev_err(&client->dev, "Get recovery packet == %*phC\n",
+				3, buf);
+
+			return -ENODEV;
+		}
+	}
+
+	rc = elan_sw_reset(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "Software reset failed\n");
+		/* continue */
+	}
+
+	ts->rx_size = QUEUE_HEADER_SIZE;
+
+	rc = __elan_fastboot(client);
+	if (rc < 0)
+		dev_err(&client->dev, "fastboot failed, rc=%d\n", rc);
+
+	/*! - elan hello packet init */
+	rc = __hello_packet_handler(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "hello packet error.\n");
+
+		return -ENODEV;
+	}
+
+	/* elan fw version */
+	rc = __fw_packet_handler(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "firmware checking error rc=%d\n", rc);
+
+		if (rc == -EINVAL) {
+			set_bit(LOCK_FW_UPDATE, &ts->flags);
+			ts->iap_mode = IAP_MODE_ENABLE;
+		}
+	}
+
+	/* elan TP information */
+	rc = __tp_info_handler(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "TP information checking error.\n");
+		/* Go through down */
+	}
+
+	/* elan test version */
+	rc = __test_packet_handler(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "test version error\n");
+		/* Go through down */
+	}
+
+	/* Get TS BootCode version */
+	rc = __bc_packet_handler(client);
+	if (rc < 0) {
+		dev_err(&client->dev, "TP get BC version error.\n");
+		/* Go through down */
+	}
+
+	return 0;
+}
+
+/**
+ *	elan_initialize_async	- init touch device.
+ *
+ *	@work: /INT work queue
+ *
+ *	Perform real probe for our I2C device and if successful configure
+ *	it up as an input device. If not then clean up and return an error
+ *	code.
+ */
+
+static void elan_initialize_async(void *data, async_cookie_t cookie)
+{
+	struct elants_data *ts = data;
+	struct i2c_client *client = ts->client;
+	int err = 0;
+
+	mutex_lock(&ts->mutex);
+
+	err = elan_initialize(client);
+	if (err < 0)
+		dev_err(&client->dev, "probe failed! unbind device.\n");
+
+	err = elan_input_dev_create(ts);
+	if (err) {
+		dev_err(&client->dev, "%s crated failed, %d\n", __func__, err);
+		goto fail_un;
+	}
+
+	dev_info(&client->dev, "Elan Touchscreen Information:\n\r");
+	dev_info(&client->dev,
+		 "    Firmware Version:  0x%04x\n\r", ts->fw_version);
+	dev_info(&client->dev,
+		 "    Test Version:  0x%04x\n\r", ts->test_version);
+	dev_info(&client->dev, "    BC Version:  0x%04x\n\r", ts->bc_version);
+	dev_info(&client->dev, "    IAP Version:  0x%04x\n\r", ts->iap_version);
+	dev_info(&client->dev, "    Trace Num:   %d, %d\n", ts->rows, ts->cols);
+	dev_info(&client->dev, "    Resolution X,Y:  %d,%d\n",
+			ts->x_max, ts->y_max);
+
+	err = request_threaded_irq(client->irq, NULL,
+				   elan_work_func,
+				   IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
+				   client->name, ts);
+	if (err) {
+		dev_err(&client->dev, "Failed to register interrupt\n");
+		goto fail_un;
+	}
+
+	mutex_unlock(&ts->mutex);
+
+	return;
+
+fail_un:
+	mutex_unlock(&ts->mutex);
+	remove_elants(client);
+	return;
+}
+
+/**
+ *	elan_probe - probe for touchpad
+ *
+ *	Perform setup and probe for our I2C device and if successful configure
+ *	it up as an input device. If not then clean up and return an error
+ *	code.
+ */
+static int elan_probe(struct i2c_client *client, const struct i2c_device_id *id)
+{
+	long err = -1;
+	struct elan_i2c_platform_data *pdata = NULL;
+	struct elants_data *ts =
+	    kzalloc(sizeof(struct elants_data), GFP_KERNEL);
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		dev_err(&client->dev,
+			"%s: i2c check functionality error\n", DEVICE_NAME);
+		return -ENODEV;
+	}
+
+	ts = kzalloc(sizeof(struct elants_data), GFP_KERNEL);
+	if (!ts)
+		return -ENOMEM;
+
+	mutex_init(&ts->mutex);
+	mutex_init(&ts->tr_mutex);
+	mutex_init(&ts->fifo_mutex);
+	init_waitqueue_head(&ts->wait);
+	spin_lock_init(&ts->rx_kfifo_lock);
+
+	err = elan_dbfs_init(ts);
+	if (err < 0) {
+		dev_err(&client->dev, "error create elan debugfs.\n");
+		goto fail_un;
+	} else
+		ts->fw_enabled = 1;
+
+	pdata = client->dev.platform_data;
+	if (!pdata) {
+		dev_err(&client->dev,
+			"%s No platform data provided\n", DEVICE_NAME);
+	}
+
+	/* set initial i2c address */
+	client->addr = DEV_MASTER;
+	ts->i2caddr = client->addr;
+
+	ts->client = client;
+	i2c_set_clientdata(client, ts);
+
+	/* initial kfifo */
+	err = kfifo_alloc(&ts->fifo, FIFO_SIZE, GFP_KERNEL);
+	if (!kfifo_initialized(&ts->fifo)) {
+		dev_err(&client->dev, "%s error kfifo_alloc\n", __func__);
+		goto fail_un;
+	}
+
+	/* Says HELLO to touch device */
+	async_schedule(elan_initialize_async, ts);
+
+	device_init_wakeup(&client->dev, true);
+
+	return 0;
+
+fail_un:
+	remove_elants(client);
+	return err;
+}
+
+static int elan_remove(struct i2c_client *client)
+{
+	return remove_elants(client);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int elan_suspend(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 set_sleep_cmd[] = { 0x54, 0x50, 0x00, 0x01 };
+	int rc = 0;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+
+	mutex_lock(&ts->mutex);
+	rc = elan_set_data(client, set_sleep_cmd, sizeof(set_sleep_cmd));
+	if (rc < 0)
+		dev_err(&client->dev, "suspend command failed!\n");
+
+	if (device_may_wakeup(dev))
+		ts->irq_wake = (enable_irq_wake(client->irq) == 0);
+
+	disable_irq(client->irq);
+
+	mutex_unlock(&ts->mutex);
+
+	return 0;
+}
+
+static int elan_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct elants_data *ts = i2c_get_clientdata(client);
+	const u8 set_active_cmd[] = { 0x54, 0x58, 0x00, 0x01 };
+	int rc = 0;
+
+	dev_dbg(&client->dev, "Enter: %s\n", __func__);
+
+	/* Command not support in IAP recovery mode */
+	if (test_bit(LOCK_FW_UPDATE, &ts->flags))
+		return 0;
+
+	if (device_may_wakeup(dev) && ts->irq_wake)
+		disable_irq_wake(client->irq);
+
+	mutex_lock(&ts->mutex);
+
+	rc = elan_set_data(client, set_active_cmd, sizeof(set_active_cmd));
+	if (rc < 0)
+		dev_err(&client->dev, "resume command failed!\n");
+
+	enable_irq(client->irq);
+
+	mutex_unlock(&ts->mutex);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(elan_pm_ops, elan_suspend, elan_resume);
+
+static const struct i2c_device_id elan_ts_id[] = {
+	{DEVICE_NAME, 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, elan_ts_id);
+
+static struct i2c_driver elan_ts_driver = {
+	.probe = elan_probe,
+	.remove = elan_remove,
+	.id_table = elan_ts_id,
+	.driver = {
+		   .name = DEVICE_NAME,
+		   .owner = THIS_MODULE,
+		   .pm = &elan_pm_ops,
+		   },
+};
+
+module_i2c_driver(elan_ts_driver);
+
+MODULE_VERSION(DEVICE_NAME);
+MODULE_DESCRIPTION("Elan I2c Touchscreen driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

