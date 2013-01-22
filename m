Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945Ab3AVR4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 12:56:30 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:43929 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3AVR43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 12:56:29 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mitch Bradley <wmb@firmworks.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Rickard Andersson <rickard.andersson@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V5] drivers/pinctrl: grab default handles from device core
Date: Tue, 22 Jan 2013 10:56:14 -0700
Message-Id: <1358877374-1279-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes the device core auto-grab the pinctrl handle and set
the "default" (PINCTRL_STATE_DEFAULT) state for every device
that is present in the device model right before probe. This will
account for the lion's share of embedded silicon devcies.

A modification of the semantics for pinctrl_get() is also done:
previously if the pinctrl handle for a certain device was already
taken, the pinctrl core would return an error. Now, since the
core may have already default-grabbed the handle and set its
state to "default", if the handle was already taken, this will
be disregarded and the located, previously instanitated handle
will be returned to the caller.

This way all code in drivers explicitly requesting their pinctrl
handlers will still be functional, and drivers that want to
explicitly retrieve and switch their handles can still do that.
But if the desired functionality is just boilerplate of this
type in the probe() function:

struct pinctrl  *p;

p = devm_pinctrl_get_select_default(&dev);
if (IS_ERR(p)) {
   if (PTR_ERR(p) == -EPROBE_DEFER)
        return -EPROBE_DEFER;
        dev_warn(&dev, "no pinctrl handle\n");
}

The discussion began with the addition of such boilerplate
to the omap4 keypad driver:
http://marc.info/?l=linux-input&m=135091157719300&w=2

A previous approach using notifiers was discussed:
http://marc.info/?l=linux-kernel&m=135263661110528&w=2
This failed because it could not handle deferred probes.

This patch alone does not solve the entire dilemma faced:
whether code should be distributed into the drivers or
if it should be centralized to e.g. a PM domain. But it
solves the immediate issue of the addition of boilerplate
to a lot of drivers that just want to grab the default
state. As mentioned, they can later explicitly retrieve
the handle and set different states, and this could as
well be done by e.g. PM domains as it is only related
to a certain struct device * pointer.

Cc: Felipe Balbi <balbi@ti.com>
Cc: Benoit Cousson <b-cousson@ti.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Mitch Bradley <wmb@firmworks.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Rickard Andersson <rickard.andersson@stericsson.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[swarren: fixed and simplified error-handling in pinctrl_bind_pins(), to
correctly handle deferred probe. Removed admonition from docs not to use
pinctrl hogs for devices]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 Documentation/pinctrl.txt       |   18 ++++++++--
 drivers/base/Makefile           |    1 +
 drivers/base/dd.c               |    7 ++++
 drivers/base/pinctrl.c          |   69 +++++++++++++++++++++++++++++++++++++++
 drivers/pinctrl/core.c          |   30 ++++++++++++++---
 drivers/pinctrl/core.h          |    3 ++
 include/linux/device.h          |    7 ++++
 include/linux/pinctrl/devinfo.h |   45 +++++++++++++++++++++++++
 8 files changed, 173 insertions(+), 7 deletions(-)
 create mode 100644 drivers/base/pinctrl.c
 create mode 100644 include/linux/pinctrl/devinfo.h

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index da40efb..a2b57e0 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -972,6 +972,18 @@ pinmux core.
 Pin control requests from drivers
 =================================
 
+When a device driver is about to probe the device core will automatically
+attempt to issue pinctrl_get_select_default() on these devices.
+This way driver writers do not need to add any of the boilerplate code
+of the type found below. However when doing fine-grained state selection
+and not using the "default" state, you may have to do some device driver
+handling of the pinctrl handles and states.
+
+So if you just want to put the pins for a certain device into the default
+state and be done with it, there is nothing you need to do besides
+providing the proper mapping table. The device core will take care of
+the rest.
+
 Generally it is discouraged to let individual drivers get and enable pin
 control. So if possible, handle the pin control in platform code or some other
 place where you have access to all the affected struct device * pointers. In
@@ -1097,9 +1109,9 @@ situations that can be electrically unpleasant, you will certainly want to
 mux in and bias pins in a certain way before the GPIO subsystems starts to
 deal with them.
 
-The above can be hidden: using pinctrl hogs, the pin control driver may be
-setting up the config and muxing for the pins when it is probing,
-nevertheless orthogonal to the GPIO subsystem.
+The above can be hidden: using the device core, the pinctrl core may be
+setting up the config and muxing for the pins right before the device is
+probing, nevertheless orthogonal to the GPIO subsystem.
 
 But there are also situations where it makes sense for the GPIO subsystem
 to communicate directly with with the pinctrl subsystem, using the latter
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 5aa2d70..4e22ce3 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -21,6 +21,7 @@ endif
 obj-$(CONFIG_SYS_HYPERVISOR) += hypervisor.o
 obj-$(CONFIG_REGMAP)	+= regmap/
 obj-$(CONFIG_SOC_BUS) += soc.o
+obj-$(CONFIG_PINCTRL) += pinctrl.o
 
 ccflags-$(CONFIG_DEBUG_DRIVER) := -DDEBUG
 
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index e3bbed8..65631015 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -24,6 +24,7 @@
 #include <linux/wait.h>
 #include <linux/async.h>
 #include <linux/pm_runtime.h>
+#include <linux/pinctrl/devinfo.h>
 
 #include "base.h"
 #include "power/power.h"
@@ -269,6 +270,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
 	WARN_ON(!list_empty(&dev->devres_head));
 
 	dev->driver = drv;
+
+	/* If using pinctrl, bind pins now before probing */
+	ret = pinctrl_bind_pins(dev);
+	if (ret)
+		goto probe_failed;
+
 	if (driver_sysfs_add(dev)) {
 		printk(KERN_ERR "%s: driver_sysfs_add(%s) failed\n",
 			__func__, dev_name(dev));
diff --git a/drivers/base/pinctrl.c b/drivers/base/pinctrl.c
new file mode 100644
index 0000000..67a274e
--- /dev/null
+++ b/drivers/base/pinctrl.c
@@ -0,0 +1,69 @@
+/*
+ * Driver core interface to the pinctrl subsystem.
+ *
+ * Copyright (C) 2012 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * Based on bits of regulator core, gpio core and clk core
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#include <linux/device.h>
+#include <linux/pinctrl/devinfo.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/slab.h>
+
+/**
+ * pinctrl_bind_pins() - called by the device core before probe
+ * @dev: the device that is just about to probe
+ */
+int pinctrl_bind_pins(struct device *dev)
+{
+	int ret;
+
+	dev->pins = devm_kzalloc(dev, sizeof(*(dev->pins)), GFP_KERNEL);
+	if (!dev->pins)
+		return -ENOMEM;
+
+	dev->pins->p = devm_pinctrl_get(dev);
+	if (IS_ERR(dev->pins->p)) {
+		dev_dbg(dev, "no pinctrl handle\n");
+		ret = PTR_ERR(dev->pins->p);
+		goto cleanup_alloc;
+	}
+
+	dev->pins->default_state = pinctrl_lookup_state(dev->pins->p,
+					PINCTRL_STATE_DEFAULT);
+	if (IS_ERR(dev->pins->default_state)) {
+		dev_dbg(dev, "no default pinctrl state\n");
+		ret = 0;
+		goto cleanup_get;
+	}
+
+	ret = pinctrl_select_state(dev->pins->p, dev->pins->default_state);
+	if (ret) {
+		dev_dbg(dev, "failed to activate default pinctrl state\n");
+		goto cleanup_get;
+	}
+
+	return 0;
+
+	/*
+	 * If no pinctrl handle or default state was found for this device,
+	 * let's explicitly free the pin container in the device, there is
+	 * no point in keeping it around.
+	 */
+cleanup_get:
+	devm_pinctrl_put(dev->pins->p);
+cleanup_alloc:
+	devm_kfree(dev, dev->pins);
+	dev->pins = NULL;
+
+	/* Only return deferrals */
+	if (ret != -EPROBE_DEFER)
+		ret = 0;
+
+	return ret;
+}
diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index 3611753..0dbbbf3 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -14,6 +14,7 @@
 #define pr_fmt(fmt) "pinctrl core: " fmt
 
 #include <linux/kernel.h>
+#include <linux/kref.h>
 #include <linux/export.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -721,6 +722,8 @@ static struct pinctrl *create_pinctrl(struct device *dev)
 		return ERR_PTR(ret);
 	}
 
+	kref_init(&p->users);
+
 	/* Add the pinctrl handle to the global list */
 	list_add_tail(&p->node, &pinctrl_list);
 
@@ -734,9 +737,17 @@ static struct pinctrl *pinctrl_get_locked(struct device *dev)
 	if (WARN_ON(!dev))
 		return ERR_PTR(-EINVAL);
 
+	/*
+	 * See if somebody else (such as the device core) has already
+	 * obtained a handle to the pinctrl for this device. In that case,
+	 * return another pointer to it.
+	 */
 	p = find_pinctrl(dev);
-	if (p != NULL)
-		return ERR_PTR(-EBUSY);
+	if (p != NULL) {
+		dev_dbg(dev, "obtain a copy of previously claimed pinctrl\n");
+		kref_get(&p->users);
+		return p;
+	}
 
 	return create_pinctrl(dev);
 }
@@ -792,13 +803,24 @@ static void pinctrl_put_locked(struct pinctrl *p, bool inlist)
 }
 
 /**
- * pinctrl_put() - release a previously claimed pinctrl handle
+ * pinctrl_release() - release the pinctrl handle
+ * @kref: the kref in the pinctrl being released
+ */
+void pinctrl_release(struct kref *kref)
+{
+	struct pinctrl *p = container_of(kref, struct pinctrl, users);
+
+	pinctrl_put_locked(p, true);
+}
+
+/**
+ * pinctrl_put() - decrease use count on a previously claimed pinctrl handle
  * @p: the pinctrl handle to release
  */
 void pinctrl_put(struct pinctrl *p)
 {
 	mutex_lock(&pinctrl_mutex);
-	pinctrl_put_locked(p, true);
+	kref_put(&p->users, pinctrl_release);
 	mutex_unlock(&pinctrl_mutex);
 }
 EXPORT_SYMBOL_GPL(pinctrl_put);
diff --git a/drivers/pinctrl/core.h b/drivers/pinctrl/core.h
index 232a9f6..fdd350d 100644
--- a/drivers/pinctrl/core.h
+++ b/drivers/pinctrl/core.h
@@ -9,6 +9,7 @@
  * License terms: GNU General Public License (GPL) version 2
  */
 
+#include <linux/kref.h>
 #include <linux/mutex.h>
 #include <linux/radix-tree.h>
 #include <linux/pinctrl/pinconf.h>
@@ -58,6 +59,7 @@ struct pinctrl_dev {
  * @state: the current state
  * @dt_maps: the mapping table chunks dynamically parsed from device tree for
  *	this device, if any
+ * @users: reference count
  */
 struct pinctrl {
 	struct list_head node;
@@ -65,6 +67,7 @@ struct pinctrl {
 	struct list_head states;
 	struct pinctrl_state *state;
 	struct list_head dt_maps;
+	struct kref users;
 };
 
 /**
diff --git a/include/linux/device.h b/include/linux/device.h
index 43dcda9..001f663 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -21,6 +21,7 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/mutex.h>
+#include <linux/pinctrl/devinfo.h>
 #include <linux/pm.h>
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
@@ -620,6 +621,8 @@ struct acpi_dev_node {
  * @pm_domain:	Provide callbacks that are executed during system suspend,
  * 		hibernation, system resume and during runtime PM transitions
  * 		along with subsystem-level and driver-level callbacks.
+ * @pins:	For device pin management.
+ *		See Documentation/pinctrl.txt for details.
  * @numa_node:	NUMA node this device is close to.
  * @dma_mask:	Dma mask (if dma'ble device).
  * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
@@ -672,6 +675,10 @@ struct device {
 	struct dev_pm_info	power;
 	struct dev_pm_domain	*pm_domain;
 
+#ifdef CONFIG_PINCTRL
+	struct dev_pin_info	*pins;
+#endif
+
 #ifdef CONFIG_NUMA
 	int		numa_node;	/* NUMA node this device is close to */
 #endif
diff --git a/include/linux/pinctrl/devinfo.h b/include/linux/pinctrl/devinfo.h
new file mode 100644
index 0000000..6e5f8a9
--- /dev/null
+++ b/include/linux/pinctrl/devinfo.h
@@ -0,0 +1,45 @@
+/*
+ * Per-device information from the pin control system.
+ * This is the stuff that get included into the device
+ * core.
+ *
+ * Copyright (C) 2012 ST-Ericsson SA
+ * Written on behalf of Linaro for ST-Ericsson
+ * This interface is used in the core to keep track of pins.
+ *
+ * Author: Linus Walleij <linus.walleij@linaro.org>
+ *
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef PINCTRL_DEVINFO_H
+#define PINCTRL_DEVINFO_H
+
+#ifdef CONFIG_PINCTRL
+
+/* The device core acts as a consumer toward pinctrl */
+#include <linux/pinctrl/consumer.h>
+
+/**
+ * struct dev_pin_info - pin state container for devices
+ * @p: pinctrl handle for the containing device
+ * @default_state: the default state for the handle, if found
+ */
+struct dev_pin_info {
+	struct pinctrl *p;
+	struct pinctrl_state *default_state;
+};
+
+extern int pinctrl_bind_pins(struct device *dev);
+
+#else
+
+/* Stubs if we're not using pinctrl */
+
+static inline int pinctrl_bind_pins(struct device *dev)
+{
+	return 0;
+}
+
+#endif /* CONFIG_PINCTRL */
+#endif /* PINCTRL_DEVINFO_H */
-- 
1.7.10.4

