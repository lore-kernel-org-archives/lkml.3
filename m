Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756AbaLTALE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 19:11:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49090 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880AbaLTALC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 19:11:02 -0500
From: NeilBrown <neilb@suse.de>
To: Mark Rutland <mark.rutland@arm.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sebastian Reichel <sre@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Date: Sat, 20 Dec 2014 11:09:20 +1100
Subject: [PATCH 1/2] TTY: add support for "tty slave" devices.
Cc: GTA04 owners <gta04-owner@goldelico.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141220000920.13943.22511.stgit@notabene.brown>
In-Reply-To: <20141219235827.13943.45713.stgit@notabene.brown>
References: <20141219235827.13943.45713.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A "tty slave" is a device connected via UART.
It may need a driver to, for example, power the device on
when the tty is opened, and power it off when the tty
is released.

A "tty slave" is a platform device which is declared as a
child of the uart in device-tree:

&uart1 {
	bluetooth {
		compatible = "wi2wi,w2cbw003";
		vdd-supply = <&vaux4>;
	};
};

The driver can attach to the tty by calling
   tty_set_slave(dev->parent, dev, &slave_ops);

where slave_ops' is a set of interface that
the tty layer must call when appropriate.
Currently only 'open' and 'release' are defined.
They are called at first open and last close.
They cannot fail.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 .../devicetree/bindings/serial/of-serial.txt       |    4 +
 drivers/tty/tty_io.c                               |   73 +++++++++++++++++++-
 include/linux/tty.h                                |   16 ++++
 3 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
index 8c4fd0332028..fc5d00c3c474 100644
--- a/Documentation/devicetree/bindings/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/serial/of-serial.txt
@@ -39,6 +39,10 @@ Optional properties:
   driver is allowed to detect support for the capability even without this
   property.
 
+Optional child node:
+- a platform device listed as a child node will be probed and can
+  register with the tty for open/close events to manage power.
+
 Example:
 
 	uart@80230000 {
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 0508a1d8e4cd..6c67a3fd257e 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -95,6 +95,7 @@
 #include <linux/seq_file.h>
 #include <linux/serial.h>
 #include <linux/ratelimit.h>
+#include <linux/of_platform.h>
 
 #include <linux/uaccess.h>
 
@@ -110,6 +111,13 @@
 #define TTY_PARANOIA_CHECK 1
 #define CHECK_TTY_COUNT 1
 
+struct tty_device {
+	struct device dev;
+
+	struct tty_slave_operations *slave_ops;
+	struct device *slave;
+};
+
 struct ktermios tty_std_termios = {	/* for the benefit of tty drivers  */
 	.c_iflag = ICRNL | IXON,
 	.c_oflag = OPOST | ONLCR,
@@ -1825,6 +1833,17 @@ int tty_release(struct inode *inode, struct file *filp)
 				__func__, tty->count, tty_name(tty, buf));
 		tty->count = 0;
 	}
+	if (tty->dev && tty->count == 0) {
+		struct tty_device *ttyd = container_of(tty->dev,
+						       struct tty_device,
+						       dev);
+		if (ttyd->slave) {
+			mutex_lock(&ttyd->dev.mutex);
+			if (ttyd->slave)
+				ttyd->slave_ops->release(ttyd->slave, tty);
+			mutex_unlock(&ttyd->dev.mutex);
+		}
+	}
 
 	/*
 	 * We've decremented tty->count, so we need to remove this file
@@ -2105,6 +2124,18 @@ retry_open:
 		goto retry_open;
 	}
 	clear_bit(TTY_HUPPED, &tty->flags);
+	if (tty->dev && tty->count == 1) {
+		struct tty_device *ttyd = container_of(tty->dev,
+						       struct tty_device,
+						       dev);
+		if (ttyd->slave) {
+			mutex_lock(&ttyd->dev.mutex);
+			if (ttyd->slave &&
+			    ttyd->slave_ops->open)
+				ttyd->slave_ops->open(ttyd->slave, tty);
+			mutex_unlock(&ttyd->dev.mutex);
+		}
+	}
 	tty_unlock(tty);
 
 
@@ -3168,6 +3199,7 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 {
 	char name[64];
 	dev_t devt = MKDEV(driver->major, driver->minor_start) + index;
+	struct tty_device *tty_dev;
 	struct device *dev = NULL;
 	int retval = -ENODEV;
 	bool cdev = false;
@@ -3190,12 +3222,12 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 		cdev = true;
 	}
 
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
+	tty_dev = kzalloc(sizeof(*tty_dev), GFP_KERNEL);
+	if (!tty_dev) {
 		retval = -ENOMEM;
 		goto error;
 	}
-
+	dev = &tty_dev->dev;
 	dev->devt = devt;
 	dev->class = tty_class;
 	dev->parent = device;
@@ -3207,6 +3239,12 @@ struct device *tty_register_device_attr(struct tty_driver *driver,
 	retval = device_register(dev);
 	if (retval)
 		goto error;
+	if (device && device->of_node)
+		/* Children are platform devices and can register
+		 * for various call-backs on tty operations.
+		 */
+		of_platform_populate(device->of_node, NULL, NULL, dev);
+
 
 	return dev;
 
@@ -3238,6 +3276,35 @@ void tty_unregister_device(struct tty_driver *driver, unsigned index)
 }
 EXPORT_SYMBOL(tty_unregister_device);
 
+int tty_set_slave(struct device *tty, struct device *slave,
+		  struct tty_slave_operations *ops)
+{
+	struct tty_device *ttyd = container_of(tty, struct tty_device, dev);
+	int err;
+	if (tty->class != tty_class)
+		return -ENODEV;
+	if (ttyd->slave)
+		err = -EBUSY;
+	else {
+		ttyd->slave = slave;
+		ttyd->slave_ops = ops;
+		err = 0;
+	}
+	return err;
+}
+EXPORT_SYMBOL_GPL(tty_set_slave);
+
+void tty_clear_slave(struct device *tty, struct device *slave)
+{
+	struct tty_device *ttyd = container_of(tty, struct tty_device, dev);
+
+	WARN_ON(ttyd->slave != slave);
+	ttyd->slave = NULL;
+	ttyd->slave_ops = NULL;
+}
+EXPORT_SYMBOL_GPL(tty_clear_slave);
+
+
 /**
  * __tty_alloc_driver -- allocate tty driver
  * @lines: count of lines this driver can handle at most
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5171ef8f7b85..fab8af995bd3 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -299,6 +299,22 @@ struct tty_file_private {
 	struct list_head list;
 };
 
+/* A "tty slave" device is permanently attached to a tty, typically
+ * via a UART.
+ * The driver can register for notifications for power management
+ * etc.  Any operation can be NULL.
+ * Operations are called under dev->mutex for the tty device.
+ */
+struct tty_slave_operations {
+	/* 'open' is called when the device is first opened */
+	void (*open)(struct device *slave, struct tty_struct *tty);
+	/* 'release' is called on last close */
+	void (*release)(struct device *slave, struct tty_struct *tty);
+};
+int tty_set_slave(struct device *tty, struct device *slave,
+		  struct tty_slave_operations *ops);
+void tty_clear_slave(struct device *tty, struct device *slave);
+
 /* tty magic number */
 #define TTY_MAGIC		0x5401
 


