Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaE0FcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:32:25 -0400
Received: from mail-pb0-f65.google.com ([209.85.160.65]:55575 "EHLO
	mail-pb0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaE0FcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:32:12 -0400
From: hnnnet48@gmail.com
To: gregkh@suse.de, devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Cc: kevin <hnnnet48@gmail.com>
Subject: [PATCH] This is my first commit
Date: Tue, 27 May 2014 13:31:57 +0800
Message-Id: <1401168717-6068-1-git-send-email-hnnnet48@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: kevin <hnnnet48@gmail.com>

---
 gtserio.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100755 gtserio.c

diff --git a/gtserio.c b/gtserio.c
new file mode 100755
index 0000000..24f1e00
--- /dev/null
+++ b/gtserio.c
@@ -0,0 +1,188 @@
+/*
+ *  gtserio.c - Create an input/output character device for GeneralTouch serial screen
+ */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <asm/uaccess.h>
+#include <linux/device.h>
+#include <linux/input.h>
+#include <linux/kd.h>
+//#include <linux/ioctl.h>
+
+#define MAJOR_NUM              100
+#define MAJOR_MIN              0
+#define SUCCESS                0
+#define DEVICE_NAME            "general_touch_serial"
+#define BUF_LEN                80
+MODULE_AUTHOR("GeneralTouch <support@generaltouch.com>");
+MODULE_DESCRIPTION(DEVICE_NAME);
+MODULE_LICENSE("GPL");
+static int Device_Open = 0;
+struct input_dev *devq;
+char Message[BUF_LEN];
+dev_t gts_t;
+unsigned char val[10];
+int gtsdata[4];
+unsigned long min_x = 0;
+unsigned long max_x = 32767;
+unsigned long min_y = 0;
+unsigned long max_y = 32767;
+
+char *Message_Ptr;
+struct class *gts_class;
+
+static int device_open(struct inode *inode, struct file *file)
+{
+	printk("GTS device_open(%p)\n", file);
+
+#ifdef DEBUG
+	printk("device_open(%p)\n", file);
+#endif
+
+	/* 
+	 * We don't want to talk to two processes at the same time 
+	 */
+	if (Device_Open)
+		return -EBUSY;
+
+	Device_Open++;
+	/*
+	 * Initialize the message 
+	 */
+	Message_Ptr = Message;
+	return SUCCESS;
+}
+
+static int device_release(struct inode *inode, struct file *file)
+{
+#ifdef DEBUG
+	printk("device_release(%p,%p)\n", inode, file);
+#endif
+
+	/* 
+	 * We're now ready for our next caller 
+	 */
+	Device_Open--;
+
+	module_put(THIS_MODULE);
+	return SUCCESS;
+}
+
+/* 
+ * This function is called whenever a process which has already opened the
+ * device file attempts to read from it.
+ */
+static ssize_t device_read(struct file *file,
+			   char __user * buffer, size_t length, loff_t * offset)
+{
+
+	return 0;
+}
+
+static ssize_t
+device_write(struct file *file,
+	     const char __user * buffer, size_t length, loff_t * offset)
+{
+#ifdef DEBUG
+	printk("device_write(%p,%s,%d)", file, buffer, length);
+#endif
+
+	if (copy_from_user(&val, buffer, length)) {
+		length = -EFAULT;
+	}
+
+	printk("val[3] = %x,val[4] = %x\nval[5] = %x,val[6] = %x\n", val[3],
+	       val[4], val[5], val[6]);
+	gtsdata[0] = val[2];
+	gtsdata[1] = (val[4] << 8) | (val[3]);
+	gtsdata[2] = (val[6] << 8) | (val[5]);
+	gtsdata[3] = val[9];
+	printk("gtsdata[1] = %x\ngtsdata[2] = %x\n", gtsdata[1], gtsdata[2]);
+	input_report_abs(devq, ABS_X, gtsdata[1]);
+	input_report_abs(devq, ABS_Y, gtsdata[2]);
+	if (gtsdata[0] == 0x81) {
+
+		input_report_key(devq, BTN_TOUCH, 1);
+		input_report_abs(devq, ABS_PRESSURE, 1);
+		input_sync(devq);
+	}
+	if (gtsdata[0] == 0x84) {
+		input_report_key(devq, BTN_TOUCH, 0);
+		input_report_abs(devq, ABS_PRESSURE, 0);
+		input_sync(devq);
+	}
+	input_sync(devq);
+
+	return length;
+}
+
+struct file_operations Fops = {
+	.read = device_read,
+	.write = device_write,
+	.open = device_open,
+	.release = device_release,	/* a.k.a. close */
+};
+
+/* 
+ * Initialize the module - Register the character device 
+ */
+static int __init gts_init(void)
+{
+	int ret_val;
+	struct input_dev *gts_dev;
+	int err1;
+	gts_t = MKDEV(MAJOR_NUM, MAJOR_MIN);
+
+	gts_class = class_create(THIS_MODULE, "gts_class");
+	device_create(gts_class, NULL, gts_t, NULL, DEVICE_NAME);
+	ret_val = register_chrdev(MAJOR_NUM, DEVICE_NAME, &Fops);
+
+	if (ret_val < 0) {
+		printk("%s failed with %d\n",
+		       "Sorry, registering the character device ", ret_val);
+		return ret_val;
+	}
+
+	gts_dev = input_allocate_device();
+	if (!gts_dev) {
+		err1 = -ENOMEM;
+		goto fail1;
+	}
+	gts_dev->name = "GeneralTouch Serial TouchScreen";
+	gts_dev->phys = "generaltouch/input0";
+	gts_dev->id.bustype = BUS_RS232;
+	gts_dev->id.vendor = (int)("GT_SERIAL");
+	gts_dev->id.product = (int)("GT_SERIAL");
+	gts_dev->id.version = 0x0100;
+	gts_dev->evbit[0] =
+	    BIT_MASK(EV_SYN) | BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
+	gts_dev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
+
+	input_set_abs_params(gts_dev, ABS_X, min_x, max_x, 0, 0);
+	input_set_abs_params(gts_dev, ABS_Y, min_y, max_y, 0, 0);
+
+	err1 = input_register_device(gts_dev);
+	devq = gts_dev;
+fail1:	input_free_device(gts_dev);
+	return err1;
+}
+
+static void __exit gts_exit(void)
+{
+	int ret;
+
+	/* 
+	 * Unregister the device 
+	 */
+	unregister_chrdev(MAJOR_NUM, DEVICE_NAME);
+
+	/* 
+	 * If there's an error, report it 
+	 */
+	if (ret < 0)
+		printk("Error in module_unregister_chrdev: %d\n", ret);
+}
+
+module_init(gts_init);
+module_exit(gts_exit);
-- 
1.8.3.2

