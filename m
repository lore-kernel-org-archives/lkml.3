Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3A2DhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:37:19 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:46424 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756414Ab3A2Dfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 04/11] staging/fwserial: Create loop device the 'tty' way
Date: Mon, 28 Jan 2013 22:34:38 -0500
Message-Id: <1359430485-5301-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register a second tty driver to create loopback devices for
each firewire node. Note that the loopback devices are numbered
from 0; the tty->index is transformed when used to index the
port table.

Remove the hack that previously enabled this.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/TODO       |  13 ---
 drivers/staging/fwserial/fwserial.c | 176 +++++++++++++++++++-----------------
 2 files changed, 93 insertions(+), 96 deletions(-)

diff --git a/drivers/staging/fwserial/TODO b/drivers/staging/fwserial/TODO
index dc61d97..382a795 100644
--- a/drivers/staging/fwserial/TODO
+++ b/drivers/staging/fwserial/TODO
@@ -12,16 +12,3 @@ TODOs prior to this driver moving out of staging
 1. This driver uses the same unregistered vendor id that the firewire core does
      (0xd00d1e). Perhaps this could be exposed as a define in
      firewire.h?
-
--- Issues with TTY core --
-  1. Hack for alternate device name scheme
-     - because udev no longer allows device renaming, devices should have
-       their proper names on creation. This is an issue for creating the
-       fwloop<n> device with the fwtty<n> devices because although duplicating
-       roughly the same operations as tty_port_register_device() isn't difficult,
-       access to the tty_class & tty_fops is restricted in scope.
-
-       This is currently being worked around in create_loop_device() by
-       extracting the tty_class ptr and tty_fops ptr from the previously created
-       tty devices. Perhaps an add'l api can be added -- eg.,
-       tty_{port_}register_named_device().
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 473a2db..e143b7a 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -72,6 +72,9 @@ static DEFINE_MUTEX(port_table_lock);
 static bool port_table_corrupt;
 #define FWTTY_INVALID_INDEX  MAX_TOTAL_PORTS
 
+#define loop_idx(port)	(((port)->index) / num_ports)
+#define table_idx(loop)	((loop) * num_ports + num_ttys)
+
 /* total # of tty ports created per fw_card */
 static int num_ports;
 
@@ -79,6 +82,7 @@ static int num_ports;
 static struct kmem_cache *fwtty_txn_cache;
 
 struct tty_driver *fwtty_driver;
+static struct tty_driver *fwloop_driver;
 
 struct fwtty_transaction;
 typedef void (*fwtty_transaction_cb)(struct fw_card *card, int rcode,
@@ -1156,6 +1160,19 @@ static int fwtty_install(struct tty_driver *driver, struct tty_struct *tty)
 	return err;
 }
 
+static int fwloop_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct fwtty_port *port = fwtty_port_get(table_idx(tty->index));
+	int err;
+
+	err = tty_standard_install(driver, tty);
+	if (!err)
+		tty->driver_data = port;
+	else
+		fwtty_port_put(port);
+	return err;
+}
+
 static int fwtty_write(struct tty_struct *tty, const unsigned char *buf, int c)
 {
 	struct fwtty_port *port = tty->driver_data;
@@ -1592,6 +1609,26 @@ static const struct tty_operations fwtty_ops = {
 	.proc_fops =		&fwtty_proc_fops,
 };
 
+static const struct tty_operations fwloop_ops = {
+	.open =			fwtty_open,
+	.close =		fwtty_close,
+	.hangup =		fwtty_hangup,
+	.cleanup =		fwtty_cleanup,
+	.install =		fwloop_install,
+	.write =		fwtty_write,
+	.write_room =		fwtty_write_room,
+	.chars_in_buffer =	fwtty_chars_in_buffer,
+	.send_xchar =           fwtty_send_xchar,
+	.throttle =             fwtty_throttle,
+	.unthrottle =           fwtty_unthrottle,
+	.ioctl =		fwtty_ioctl,
+	.set_termios =		fwtty_set_termios,
+	.break_ctl =		fwtty_break_ctl,
+	.tiocmget =		fwtty_tiocmget,
+	.tiocmset =		fwtty_tiocmset,
+	.get_icount =		fwtty_get_icount,
+};
+
 static inline int mgmt_pkt_expected_len(__be16 code)
 {
 	static const struct fwserial_mgmt_pkt pkt;
@@ -1888,7 +1925,8 @@ free_pkt:
  * The port reference is put by fwtty_cleanup (if a reference was
  * ever taken).
  */
-static void fwserial_close_port(struct fwtty_port *port)
+static void fwserial_close_port(struct tty_driver *driver,
+				struct fwtty_port *port)
 {
 	struct tty_struct *tty;
 
@@ -1900,7 +1938,10 @@ static void fwserial_close_port(struct fwtty_port *port)
 	}
 	mutex_unlock(&port->port.mutex);
 
-	tty_unregister_device(fwtty_driver, port->index);
+	if (driver == fwloop_driver)
+		tty_unregister_device(driver, loop_idx(port));
+	else
+		tty_unregister_device(driver, port->index);
 }
 
 /**
@@ -2158,78 +2199,6 @@ static void fwserial_remove_peer(struct fwtty_peer *peer)
 }
 
 /**
- * create_loop_device - create a loopback tty device
- * @tty_driver: tty_driver to own loopback device
- * @prototype: ptr to already-assigned 'prototype' tty port
- * @index: index to associate this device with the tty port
- * @parent: device to child to
- *
- * HACK - this is basically tty_port_register_device() with an
- * alternate naming scheme. Suggest tty_port_register_named_device()
- * helper api.
- *
- * Creates a loopback tty device named 'fwloop<n>' which is attached to
- * the local unit in fwserial_add_peer(). Note that <n> in the device
- * name advances in increments of port allocation blocks, ie., for port
- * indices 0..3, the device name will be 'fwloop0'; for 4..7, 'fwloop1',
- * and so on.
- *
- * Only one loopback device should be created per fw_card.
- */
-static void release_loop_device(struct device *dev)
-{
-	kfree(dev);
-}
-
-static struct device *create_loop_device(struct tty_driver *driver,
-					 struct fwtty_port *prototype,
-					 struct fwtty_port *port,
-					 struct device *parent)
-{
-	char name[64];
-	int index = port->index;
-	dev_t devt = MKDEV(driver->major, driver->minor_start) + index;
-	struct device *dev = NULL;
-	int err;
-
-	if (index >= fwtty_driver->num)
-		return ERR_PTR(-EINVAL);
-
-	snprintf(name, 64, "%s%d", loop_dev_name, index / num_ports);
-
-	tty_port_link_device(&port->port, driver, index);
-
-	cdev_init(&driver->cdevs[index], driver->cdevs[prototype->index].ops);
-	driver->cdevs[index].owner = driver->owner;
-	err = cdev_add(&driver->cdevs[index], devt, 1);
-	if (err)
-		return ERR_PTR(err);
-
-	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
-	if (!dev) {
-		cdev_del(&driver->cdevs[index]);
-		return ERR_PTR(-ENOMEM);
-	}
-
-	dev->devt = devt;
-	dev->class = prototype->device->class;
-	dev->parent = parent;
-	dev->release = release_loop_device;
-	dev_set_name(dev, "%s", name);
-	dev->groups = NULL;
-	dev_set_drvdata(dev, NULL);
-
-	err = device_register(dev);
-	if (err) {
-		put_device(dev);
-		cdev_del(&driver->cdevs[index]);
-		return ERR_PTR(err);
-	}
-
-	return dev;
-}
-
-/**
  * fwserial_create - init everything to create TTYs for a specific fw_card
  * @unit: fw_unit for first 'serial' unit device probed for this fw_card
  *
@@ -2327,17 +2296,17 @@ static int fwserial_create(struct fw_unit *unit)
 	if (create_loop_dev) {
 		struct device *loop_dev;
 
-		loop_dev = create_loop_device(fwtty_driver,
-					      serial->ports[0],
-					      serial->ports[num_ttys],
-					      card->device);
+		loop_dev = tty_port_register_device(&serial->ports[j]->port,
+						    fwloop_driver,
+						    loop_idx(serial->ports[j]),
+						    card->device);
 		if (IS_ERR(loop_dev)) {
 			err = PTR_ERR(loop_dev);
 			fwtty_err(&unit, "create loop device failed (%d)", err);
 			goto unregister_ttys;
 		}
-		serial->ports[num_ttys]->device = loop_dev;
-		serial->ports[num_ttys]->loopback = true;
+		serial->ports[j]->device = loop_dev;
+		serial->ports[j]->loopback = true;
 	}
 
 	list_add_rcu(&serial->list, &fwserial_list);
@@ -2353,6 +2322,8 @@ static int fwserial_create(struct fw_unit *unit)
 
 	/* fall-through to error processing */
 	list_del_rcu(&serial->list);
+	if (create_loop_dev)
+		tty_unregister_device(fwloop_driver, loop_idx(serial->ports[j]));
 unregister_ttys:
 	for (--j; j >= 0; --j)
 		tty_unregister_device(fwtty_driver, serial->ports[j]->index);
@@ -2441,8 +2412,10 @@ static int fwserial_remove(struct device *dev)
 		/* unlink from the fwserial_list here */
 		list_del_rcu(&serial->list);
 
-		for (i = 0; i < num_ports; ++i)
-			fwserial_close_port(serial->ports[i]);
+		for (i = 0; i < num_ttys; ++i)
+			fwserial_close_port(fwtty_driver, serial->ports[i]);
+		if (create_loop_dev)
+			fwserial_close_port(fwloop_driver, serial->ports[i]);
 		kref_put(&serial->kref, fwserial_destroy);
 	}
 	mutex_unlock(&fwserial_list_mutex);
@@ -2863,12 +2836,39 @@ static int __init fwserial_init(void)
 		goto put_tty;
 	}
 
+	if (create_loop_dev) {
+		fwloop_driver = alloc_tty_driver(MAX_TOTAL_PORTS / num_ports);
+		if (!fwloop_driver) {
+			err = -ENOMEM;
+			goto unregister_driver;
+		}
+
+		fwloop_driver->driver_name	= KBUILD_MODNAME "_loop";
+		fwloop_driver->name		= loop_dev_name;
+		fwloop_driver->major		= 0;
+		fwloop_driver->minor_start	= 0;
+		fwloop_driver->type		= TTY_DRIVER_TYPE_SERIAL;
+		fwloop_driver->subtype		= SERIAL_TYPE_NORMAL;
+		fwloop_driver->flags		= TTY_DRIVER_REAL_RAW |
+							TTY_DRIVER_DYNAMIC_DEV;
+
+		fwloop_driver->init_termios	    = tty_std_termios;
+		fwloop_driver->init_termios.c_cflag  |= CLOCAL;
+		tty_set_operations(fwloop_driver, &fwloop_ops);
+
+		err = tty_register_driver(fwloop_driver);
+		if (err) {
+			driver_err("register loop driver failed (%d)", err);
+			goto put_loop;
+		}
+	}
+
 	fwtty_txn_cache = kmem_cache_create("fwtty_txn_cache",
 					    sizeof(struct fwtty_transaction),
 					    0, 0, fwtty_txn_constructor);
 	if (!fwtty_txn_cache) {
 		err = -ENOMEM;
-		goto unregister_driver;
+		goto unregister_loop;
 	}
 
 	/*
@@ -2910,6 +2910,12 @@ remove_handler:
 	fw_core_remove_address_handler(&fwserial_mgmt_addr_handler);
 destroy_cache:
 	kmem_cache_destroy(fwtty_txn_cache);
+unregister_loop:
+	if (create_loop_dev)
+		tty_unregister_driver(fwloop_driver);
+put_loop:
+	if (create_loop_dev)
+		put_tty_driver(fwloop_driver);
 unregister_driver:
 	tty_unregister_driver(fwtty_driver);
 put_tty:
@@ -2923,6 +2929,10 @@ static void __exit fwserial_exit(void)
 	fw_core_remove_descriptor(&fwserial_unit_directory);
 	fw_core_remove_address_handler(&fwserial_mgmt_addr_handler);
 	kmem_cache_destroy(fwtty_txn_cache);
+	if (create_loop_dev) {
+		tty_unregister_driver(fwloop_driver);
+		put_tty_driver(fwloop_driver);
+	}
 	tty_unregister_driver(fwtty_driver);
 	put_tty_driver(fwtty_driver);
 }
-- 
1.8.1.1

