Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbbAPXdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 18:33:38 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:43193 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbbAPXd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 18:33:26 -0500
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Luis R . Rodriguez" <mcgrof@suse.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Olof Johansson <olof@lixom.net>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 2/8] driver-core: add asynchronous probing support for drivers
Date: Fri, 16 Jan 2015 15:33:11 -0800
Message-Id: <1421451197-19723-3-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
References: <1421451197-19723-1-git-send-email-dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices take a long time when initializing, and not all drivers are
suited to initialize their devices when they are open. For example,
input drivers need to interrogate their devices in order to publish
device's capabilities before userspace will open them. When such drivers
are compiled into kernel they may stall entire kernel initialization.

This change allows drivers request for their probe functions to be
called asynchronously during driver and device registration (manual
binding is still synchronous). Because async_schedule is used to perform
asynchronous calls module loading will still wait for the probing to
complete.

This change is based on earlier patch by "Luis R. Rodriguez"
<mcgrof@suse.com>

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/base/base.h    |   1 +
 drivers/base/bus.c     |  31 +++++++---
 drivers/base/dd.c      | 149 ++++++++++++++++++++++++++++++++++++++++++-------
 include/linux/device.h |  21 +++++++
 4 files changed, 175 insertions(+), 27 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index 251c5d3..fd3347d 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -116,6 +116,7 @@ static inline int driver_match_device(struct device_driver *drv,
 {
 	return drv->bus->match ? drv->bus->match(dev, drv) : 1;
 }
+extern bool driver_allows_async_probing(struct device_driver *drv);
 
 extern int driver_add_groups(struct device_driver *drv,
 			     const struct attribute_group **groups);
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 876bae5..a3d71ad 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -10,6 +10,7 @@
  *
  */
 
+#include <linux/async.h>
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/errno.h>
@@ -549,15 +550,12 @@ void bus_probe_device(struct device *dev)
 {
 	struct bus_type *bus = dev->bus;
 	struct subsys_interface *sif;
-	int ret;
 
 	if (!bus)
 		return;
 
-	if (bus->p->drivers_autoprobe) {
-		ret = device_attach(dev);
-		WARN_ON(ret < 0);
-	}
+	if (bus->p->drivers_autoprobe)
+		device_initial_probe(dev);
 
 	mutex_lock(&bus->p->mutex);
 	list_for_each_entry(sif, &bus->p->interfaces, node)
@@ -659,6 +657,17 @@ static ssize_t uevent_store(struct device_driver *drv, const char *buf,
 }
 static DRIVER_ATTR_WO(uevent);
 
+static void driver_attach_async(void *_drv, async_cookie_t cookie)
+{
+	struct device_driver *drv = _drv;
+	int ret;
+
+	ret = driver_attach(drv);
+
+	pr_debug("bus: '%s': driver %s async attach completed: %d\n",
+		 drv->bus->name, drv->name, ret);
+}
+
 /**
  * bus_add_driver - Add a driver to the bus.
  * @drv: driver.
@@ -691,9 +700,15 @@ int bus_add_driver(struct device_driver *drv)
 
 	klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
 	if (drv->bus->p->drivers_autoprobe) {
-		error = driver_attach(drv);
-		if (error)
-			goto out_unregister;
+		if (driver_allows_async_probing(drv)) {
+			pr_debug("bus: '%s': probing driver %s asynchronously\n",
+				drv->bus->name, drv->name);
+			async_schedule(driver_attach_async, drv);
+		} else {
+			error = driver_attach(drv);
+			if (error)
+				goto out_unregister;
+		}
 	}
 	module_add_driver(drv->owner, drv);
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index cdc779c..f9f4831 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -402,31 +402,95 @@ int driver_probe_device(struct device_driver *drv, struct device *dev)
 	return ret;
 }
 
-static int __device_attach(struct device_driver *drv, void *data)
+bool driver_allows_async_probing(struct device_driver *drv)
 {
-	struct device *dev = data;
+	return drv->probe_type == PROBE_PREFER_ASYNCHRONOUS;
+}
+
+struct device_attach_data {
+	struct device *dev;
+
+	/*
+	 * Indicates whether we are are considering asynchronous probing or
+	 * not. Only initial binding after device or driver registration
+	 * (including deferral processing) may be done asynchronously, the
+	 * rest is always synchronous, as we expect it is being done by
+	 * request from userspace.
+	 */
+	bool check_async;
+
+	/*
+	 * Indicates if we are binding synchronous or asynchronous drivers.
+	 * When asynchronous probing is enabled we'll execute 2 passes
+	 * over drivers: first pass doing synchronous probing and second
+	 * doing asynchronous probing (if synchronous did not succeed -
+	 * most likely because there was no driver requiring synchronous
+	 * probing - and we found asynchronous driver during first pass).
+	 * The 2 passes are done because we can't shoot asynchronous
+	 * probe for given device and driver from bus_for_each_drv() since
+	 * driver pointer is not guaranteed to stay valid once
+	 * bus_for_each_drv() iterates to the next driver on the bus.
+	 */
+	bool want_async;
+
+	/*
+	 * We'll set have_async to 'true' if, while scanning for matching
+	 * driver, we'll encounter one that requests asynchronous probing.
+	 */
+	bool have_async;
+};
+
+static int __device_attach_driver(struct device_driver *drv, void *_data)
+{
+	struct device_attach_data *data = _data;
+	struct device *dev = data->dev;
+	bool async_allowed;
+
+	/*
+	 * Check if device has already been claimed. This may
+	 * happen with driver loading, device discovery/registration,
+	 * and deferred probe processing happens all at once with
+	 * multiple threads.
+	 */
+	if (dev->driver)
+		return -EBUSY;
 
 	if (!driver_match_device(drv, dev))
 		return 0;
 
+	async_allowed = driver_allows_async_probing(drv);
+
+	if (async_allowed)
+		data->have_async = true;
+
+	if (data->check_async && async_allowed != data->want_async)
+		return 0;
+
 	return driver_probe_device(drv, dev);
 }
 
-/**
- * device_attach - try to attach device to a driver.
- * @dev: device.
- *
- * Walk the list of drivers that the bus has and call
- * driver_probe_device() for each pair. If a compatible
- * pair is found, break out and return.
- *
- * Returns 1 if the device was bound to a driver;
- * 0 if no matching driver was found;
- * -ENODEV if the device is not registered.
- *
- * When called for a USB interface, @dev->parent lock must be held.
- */
-int device_attach(struct device *dev)
+static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
+{
+	struct device *dev = _dev;
+	struct device_attach_data data = {
+		.dev		= dev,
+		.check_async	= true,
+		.want_async	= true,
+	};
+
+	device_lock(dev);
+
+	bus_for_each_drv(dev->bus, NULL, &data, __device_attach_driver);
+	dev_dbg(dev, "async probe completed\n");
+
+	pm_request_idle(dev);
+
+	device_unlock(dev);
+
+	put_device(dev);
+}
+
+int __device_attach(struct device *dev, bool allow_async)
 {
 	int ret = 0;
 
@@ -444,15 +508,59 @@ int device_attach(struct device *dev)
 			ret = 0;
 		}
 	} else {
-		ret = bus_for_each_drv(dev->bus, NULL, dev, __device_attach);
-		pm_request_idle(dev);
+		struct device_attach_data data = {
+			.dev = dev,
+			.check_async = allow_async,
+			.want_async = false,
+		};
+
+		ret = bus_for_each_drv(dev->bus, NULL, &data,
+					__device_attach_driver);
+		if (!ret && allow_async && data.have_async) {
+			/*
+			 * If we could not find appropriate driver
+			 * synchronously and we are allowed to do
+			 * async probes and there are drivers that
+			 * want to probe asynchronously, we'll
+			 * try them.
+			 */
+			dev_dbg(dev, "scheduling asynchronous probe\n");
+			get_device(dev);
+			async_schedule(__device_attach_async_helper, dev);
+		} else {
+			pm_request_idle(dev);
+		}
 	}
 out_unlock:
 	device_unlock(dev);
 	return ret;
 }
+
+/**
+ * device_attach - try to attach device to a driver.
+ * @dev: device.
+ *
+ * Walk the list of drivers that the bus has and call
+ * driver_probe_device() for each pair. If a compatible
+ * pair is found, break out and return.
+ *
+ * Returns 1 if the device was bound to a driver;
+ * 0 if no matching driver was found;
+ * -ENODEV if the device is not registered.
+ *
+ * When called for a USB interface, @dev->parent lock must be held.
+ */
+int device_attach(struct device *dev)
+{
+	return __device_attach(dev, false);
+}
 EXPORT_SYMBOL_GPL(device_attach);
 
+void device_initial_probe(struct device *dev)
+{
+	__device_attach(dev, true);
+}
+
 static int __driver_attach(struct device *dev, void *data)
 {
 	struct device_driver *drv = data;
@@ -507,6 +615,9 @@ static void __device_release_driver(struct device *dev)
 
 	drv = dev->driver;
 	if (drv) {
+		if (driver_allows_async_probing(drv))
+			async_synchronize_full();
+
 		pm_runtime_get_sync(dev);
 
 		driver_sysfs_remove(dev);
diff --git a/include/linux/device.h b/include/linux/device.h
index fb50673..9ace4c0 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -195,6 +195,25 @@ extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
 
 /**
+  * enum probe_type - device driver probe type to try
+  *	Device drivers may opt in for special handling of their
+  *	respective probe routines. This tells the core what to
+  *	expect and prefer.
+  *
+  * @PROBE_SYNCHRONOUS: Default. Drivers expect their probe routines
+  *	to run synchronously with driver and device registration
+  *	(with the exception of -EPROBE_DEFER handling - re-probing
+  *	always ends up being done asynchronously).
+  * @PROBE_PREFER_ASYNCHRONOUS: Drivers for "slow" devices which
+  *	probing order is not essential for booting the system may
+  *	opt into executing their probes asynchronously.
+  */
+enum probe_type {
+	PROBE_SYNCHRONOUS,
+	PROBE_PREFER_ASYNCHRONOUS,
+};
+
+/**
  * struct device_driver - The basic device driver structure
  * @name:	Name of the device driver.
  * @bus:	The bus which the device of this driver belongs to.
@@ -234,6 +253,7 @@ struct device_driver {
 	const char		*mod_name;	/* used for built-in modules */
 
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
+	enum probe_type probe_type;
 
 	const struct of_device_id	*of_match_table;
 	const struct acpi_device_id	*acpi_match_table;
@@ -972,6 +992,7 @@ extern int __must_check device_bind_driver(struct device *dev);
 extern void device_release_driver(struct device *dev);
 extern int  __must_check device_attach(struct device *dev);
 extern int __must_check driver_attach(struct device_driver *drv);
+extern void device_initial_probe(struct device *dev);
 extern int __must_check device_reprobe(struct device *dev);
 
 /*
-- 
2.2.0.rc0.207.ga3a616c

