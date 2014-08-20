Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaHTNnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:43:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60686 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbaHTNnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:43:03 -0400
X-AuditID: cbfee61b-f79f86d00000144c-07-53f4a5e4310d
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, devicetree@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH/RFC v5 2/2] leds: Add Flash Manager functionality
Date: Wed, 20 Aug 2014 15:42:43 +0200
Message-id: <1408542163-32764-3-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
References: <1408542163-32764-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsVy+t9jQd2nS78EG0z8ymixccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1ktdu96yurA6bFz1l12jz3zf7B69G1Z
	xejxeZNcAEsUl01Kak5mWWqRvl0CV8bbVzOYCn6sYqpYf/4YSwPj1U+MXYycHBICJhJnbp1n
	hbDFJC7cW8/WxcjFISQwnVHi0Le7YEVCAu1MErt25ILYbAKGEj9fvGYCsUUEyiV63j8Da2AW
	WM0ocWfrV7BJwgKOEq/erQcrYhFQlZj8ayWYzSvgIfH813KgoRxA2xQk5kyyATE5BTwlvm2o
	hVjlIbH/w2/2CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEB9gz6R2MqxosDjEK
	cDAq8fDeWPQlWIg1say4MvcQowQHs5IIb3snUIg3JbGyKrUoP76oNCe1+BCjNAeLkjjvwVbr
	QCGB9MSS1OzU1ILUIpgsEwenVANj7ZKLX/80RU2a+c04LmH6bEmprdVLX269enDJzX9xC3fO
	X8ylrBLUuOS3lcv7E1wzbvcf6/qyPEuFK6zW/9mFIN643dPZtv6JXJH7ekoEo7SK5/V7Jxsn
	1JqkNRbOOvClj2mv2fEHWf6T60U8mXav9mdm1GO+XD5r5vKpzL29CoeW39sgXxdyWomlOCPR
	UIu5qDgRAAXHtbMsAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds Flash Manager functionality to the LED Flash Class.
It allows for changing flash - strobe provider connections
dynamically, if the flash led device has its external strobe
signal routed through multiplexer(s). This is an optional feature.

Available strobe signal providers are listed in the form of
strobe_providerN sysfs attributes. If more than one strobe provider
is available then a strobe_provider sysfs attribute shall be used
for carrying information about the identifier of the currently
selected one.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/leds/Kconfig                 |   11 +
 drivers/leds/Makefile                |    4 +
 drivers/leds/led-class-flash.c       |   19 ++
 drivers/leds/led-flash-gpio-mux.c    |  102 ++++++
 drivers/leds/led-flash-manager.c     |  590 ++++++++++++++++++++++++++++++++++
 drivers/leds/of_led_flash_manager.c  |  155 +++++++++
 include/linux/led-flash-gpio-mux.h   |   68 ++++
 include/linux/led-flash-manager.h    |  146 +++++++++
 include/linux/leds.h                 |    1 +
 include/linux/of_led_flash_manager.h |   80 +++++
 10 files changed, 1176 insertions(+)
 create mode 100644 drivers/leds/led-flash-gpio-mux.c
 create mode 100644 drivers/leds/led-flash-manager.c
 create mode 100644 drivers/leds/of_led_flash_manager.c
 create mode 100644 include/linux/led-flash-gpio-mux.h
 create mode 100644 include/linux/led-flash-manager.h
 create mode 100644 include/linux/of_led_flash_manager.h

diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
index a22c211..f8a26ec 100644
--- a/drivers/leds/Kconfig
+++ b/drivers/leds/Kconfig
@@ -30,6 +30,17 @@ config LEDS_CLASS_FLASH
 	  for the flash related features of a LED device. It can be built
 	  as a module.
 
+config LEDS_FLASH_MANAGER
+	bool "LED Flash Manager Support"
+	depends on LEDS_CLASS_FLASH
+	depends on OF
+	help
+	  This option enables the Flash Manager functionality for the
+	  LED Flash Class. It allows for chaning the flash - strobe provider
+	  connections dynamically. You'll need this only if any of the flash
+	  led devices on the board has its external strobe signal routed
+	  through multiplexer(s).
+
 comment "LED drivers"
 
 config LEDS_88PM860X
diff --git a/drivers/leds/Makefile b/drivers/leds/Makefile
index 9238b8a..d063364 100644
--- a/drivers/leds/Makefile
+++ b/drivers/leds/Makefile
@@ -3,6 +3,10 @@
 obj-$(CONFIG_NEW_LEDS)			+= led-core.o
 obj-$(CONFIG_LEDS_CLASS)		+= led-class.o
 obj-$(CONFIG_LEDS_CLASS_FLASH)		+= led-class-flash.o
+obj-$(CONFIG_LEDS_FLASH_MANAGER)	+= led-fm.o
+led-fm-objs				:= led-flash-manager.o \
+					   led-flash-gpio-mux.o \
+					   of_led_flash_manager.o
 obj-$(CONFIG_LEDS_TRIGGERS)		+= led-triggers.o
 
 # LED Platform Drivers
diff --git a/drivers/leds/led-class-flash.c b/drivers/leds/led-class-flash.c
index 4132769..4ff99a9 100644
--- a/drivers/leds/led-class-flash.c
+++ b/drivers/leds/led-class-flash.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/leds.h>
 #include <linux/led-class-flash.h>
+#include <linux/led-flash-manager.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include "leds.h"
@@ -468,6 +469,13 @@ int led_classdev_flash_register(struct device *parent,
 	if (ret < 0)
 		return -EINVAL;
 
+	/* Register in the flash manager if there is related data to parse */
+	if (node) {
+		ret = led_flash_manager_register_flash(flash, node);
+		if (ret < 0)
+			goto err_flash_manager_register;
+	}
+
 	/* Create flash led specific sysfs attributes */
 	ret = led_flash_create_sysfs_groups(flash);
 	if (ret < 0)
@@ -476,6 +484,8 @@ int led_classdev_flash_register(struct device *parent,
 	return 0;
 
 err_create_sysfs_groups:
+	led_flash_manager_unregister_flash(flash);
+err_flash_manager_register:
 	led_classdev_unregister(led_cdev);
 
 	return ret;
@@ -488,6 +498,7 @@ void led_classdev_flash_unregister(struct led_classdev_flash *flash)
 		return;
 
 	led_flash_remove_sysfs_groups(flash);
+	led_flash_manager_unregister_flash(flash);
 	led_classdev_unregister(&flash->led_cdev);
 }
 EXPORT_SYMBOL_GPL(led_classdev_flash_unregister);
@@ -542,6 +553,7 @@ EXPORT_SYMBOL_GPL(led_get_flash_fault);
 
 int led_set_external_strobe(struct led_classdev_flash *flash, bool enable)
 {
+	struct led_classdev *led_cdev = &flash->led_cdev;
 	int ret;
 
 	if (flash->has_external_strobe) {
@@ -556,6 +568,13 @@ int led_set_external_strobe(struct led_classdev_flash *flash, bool enable)
 		}
 
 		flash->external_strobe = enable;
+
+		if (led_cdev->flags & LED_DEV_CAP_FL_MANAGER) {
+			ret = led_flash_manager_set_external_strobe(flash,
+								    enable);
+			if (ret < 0)
+				return ret;
+		}
 	} else if (enable) {
 		return -EINVAL;
 	}
diff --git a/drivers/leds/led-flash-gpio-mux.c b/drivers/leds/led-flash-gpio-mux.c
new file mode 100644
index 0000000..2803fcc
--- /dev/null
+++ b/drivers/leds/led-flash-gpio-mux.c
@@ -0,0 +1,102 @@
+/*
+ * LED Flash Class gpio mux
+ *
+ *      Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *      Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/gpio.h>
+#include <linux/led-flash-gpio-mux.h>
+#include <linux/of_gpio.h>
+#include <linux/slab.h>
+
+int led_flash_gpio_mux_select_line(u32 line_id, void *mux)
+{
+	struct led_flash_gpio_mux *gpio_mux = (struct led_flash_gpio_mux *) mux;
+	struct led_flash_gpio_mux_selector *sel;
+	u32 mask = 1;
+
+	/* Setup selectors */
+	list_for_each_entry(sel, &gpio_mux->selectors, list) {
+		gpio_set_value(sel->gpio, !!(line_id & mask));
+		mask <<= 1;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(led_flash_gpio_mux_select_line);
+
+/* Create standard gpio mux */
+int led_flash_gpio_mux_create(struct led_flash_gpio_mux **new_mux,
+			      struct device_node *mux_node)
+{
+	struct led_flash_gpio_mux *mux;
+	struct led_flash_gpio_mux_selector *sel;
+	int gpio_num, gpio, ret, i;
+	char gpio_name[20];
+	static int cnt_gpio;
+
+	/* Get the number of mux selectors */
+	gpio_num = of_gpio_count(mux_node);
+	if (gpio_num == 0)
+		return -EINVAL;
+
+	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
+	if (!mux)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&mux->selectors);
+
+	/* Request gpios for all selectors */
+	for (i = 0; i < gpio_num; ++i) {
+		gpio = of_get_gpio(mux_node, i);
+		if (gpio_is_valid(gpio)) {
+			sprintf(gpio_name, "v4l2_mux selector %d", cnt_gpio++);
+			ret = gpio_request_one(gpio, GPIOF_DIR_OUT, gpio_name);
+			if (ret < 0)
+				goto err_gpio_request;
+
+			/* Add new entry to the gpio selectors list */
+			sel = kzalloc(sizeof(*sel), GFP_KERNEL);
+			if (!sel) {
+				ret = -ENOMEM;
+				goto err_gpio_request;
+			}
+			sel->gpio = gpio;
+
+			list_add_tail(&sel->list, &mux->selectors);
+		} else {
+			ret = -EINVAL;
+			goto err_gpio_request;
+		}
+
+	}
+
+	*new_mux = mux;
+
+	return 0;
+
+err_gpio_request:
+	led_flash_gpio_mux_release(mux);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_gpio_mux_create);
+
+void led_flash_gpio_mux_release(void *mux)
+{
+	struct led_flash_gpio_mux *gpio_mux = (struct led_flash_gpio_mux *) mux;
+	struct led_flash_gpio_mux_selector *sel, *n;
+
+	list_for_each_entry_safe(sel, n, &gpio_mux->selectors, list) {
+		if (gpio_is_valid(sel->gpio))
+			gpio_free(sel->gpio);
+		kfree(sel);
+	}
+	kfree(gpio_mux);
+}
+EXPORT_SYMBOL_GPL(led_flash_gpio_mux_release);
diff --git a/drivers/leds/led-flash-manager.c b/drivers/leds/led-flash-manager.c
new file mode 100644
index 0000000..0005f05
--- /dev/null
+++ b/drivers/leds/led-flash-manager.c
@@ -0,0 +1,590 @@
+/*
+ * LED Flash Manager for maintaining LED Flash Class devices
+ * along with their corresponding muxex, faciliating dynamic
+ * reconfiguration of the strobe signal source.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/delay.h>
+#include <linux/led-class-flash.h>
+#include <linux/led-flash-gpio-mux.h>
+#include <linux/led-flash-manager.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of_gpio.h>
+#include <linux/of_led_flash_manager.h>
+#include <linux/slab.h>
+
+static LIST_HEAD(flash_list);
+static LIST_HEAD(mux_bound_list);
+static LIST_HEAD(mux_waiting_list);
+static DEFINE_MUTEX(fm_lock);
+
+static ssize_t strobe_provider_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t size)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+	unsigned long provider_id;
+	ssize_t ret;
+
+	mutex_lock(&led_cdev->led_lock);
+
+	if (led_sysfs_is_locked(led_cdev)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	ret = kstrtoul(buf, 10, &provider_id);
+	if (ret)
+		goto unlock;
+
+	if (provider_id > flash->num_strobe_providers - 1) {
+		ret = -ERANGE;
+		goto unlock;
+	}
+
+	flash->strobe_provider_id = provider_id;
+
+	ret = size;
+unlock:
+	mutex_unlock(&led_cdev->led_lock);
+	return ret;
+}
+
+static ssize_t strobe_provider_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_classdev *led_cdev = dev_get_drvdata(dev);
+	struct led_classdev_flash *flash = lcdev_to_flash(led_cdev);
+
+	return sprintf(buf, "%u\n", flash->strobe_provider_id);
+}
+static DEVICE_ATTR_RW(strobe_provider);
+
+static ssize_t available_strobe_providers_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct led_flash_strobe_provider *provider =
+		container_of(attr, struct led_flash_strobe_provider, attr);
+	const char *no_name = "undefined";
+	const char *provider_name;
+
+	provider_name = provider->name ? provider->name :
+					 no_name;
+
+	return sprintf(buf, "%s\n", provider_name);
+}
+
+static int led_flash_manager_create_providers_attrs(
+					struct led_classdev_flash *flash)
+{
+	struct led_flash_strobe_provider *provider;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int cnt_attr = 0;
+	int ret;
+
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		provider->attr.show = available_strobe_providers_show;
+		provider->attr.attr.mode = S_IRUGO;
+
+		sprintf(provider->attr_name, "strobe_provider%d",
+							cnt_attr++);
+		provider->attr.attr.name = provider->attr_name;
+
+		sysfs_attr_init(&provider->attr.attr);
+
+		ret = sysfs_create_file(&led_cdev->dev->kobj,
+						&provider->attr.attr);
+		if (ret < 0)
+			goto error_create_attr;
+
+		provider->attr_registered = true;
+	}
+
+	/*
+	 * strobe_provider attribute is required only if there have been more
+	 * than one strobe source defined for the LED Flash Class device.
+	 */
+	if (cnt_attr > 1) {
+		ret = sysfs_create_file(&led_cdev->dev->kobj,
+					&dev_attr_strobe_provider.attr);
+		if (ret < 0)
+			goto error_create_attr;
+	}
+
+	return 0;
+
+error_create_attr:
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		if (!provider->attr_registered)
+			break;
+		sysfs_remove_file(&led_cdev->dev->kobj, &provider->attr.attr);
+	}
+
+	return ret;
+}
+
+static void led_flash_manager_remove_providers_attrs(
+					struct led_classdev_flash *flash)
+{
+	struct led_flash_strobe_provider *provider;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int cnt_attr = 0;
+
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		if (!provider->attr_registered)
+			break;
+		sysfs_remove_file(&led_cdev->dev->kobj, &provider->attr.attr);
+		provider->attr_registered = false;
+		++cnt_attr;
+	}
+
+	/*
+	 * If there was more than one strobe_providerN attr to remove
+	 * than there is also strobe_provider attr to remove.
+	 */
+	if (cnt_attr > 1)
+		sysfs_remove_file(&led_cdev->dev->kobj,
+				  &dev_attr_strobe_provider.attr);
+}
+
+/* Return mux associated with gate */
+static struct led_flash_mux *led_flash_manager_get_mux_by_gate(
+					struct led_flash_strobe_gate *gate,
+					struct list_head *mux_list)
+{
+	struct led_flash_mux *mux;
+
+	list_for_each_entry(mux, mux_list, list)
+		if (mux->node == gate->mux_node)
+			return mux;
+
+	return NULL;
+}
+
+/* Setup all muxes in the gate list */
+static int led_flash_manager_setup_muxes(struct led_classdev_flash *flash,
+					  struct list_head *gate_list)
+{
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	struct led_flash_strobe_gate *gate;
+	struct led_flash_mux *mux;
+	struct device *dev = led_cdev->dev->parent;
+	int ret = 0;
+
+	list_for_each_entry(gate, gate_list, list) {
+		mux = led_flash_manager_get_mux_by_gate(gate, &mux_bound_list);
+		if (!mux) {
+			dev_err(dev, "Flash mux not bound (%s)\n",
+				gate->mux_node->name);
+			return -ENODEV;
+		}
+
+		ret = mux->ops->select_line(gate->line_id,
+						mux->private_data);
+	}
+
+	return ret;
+}
+
+/*
+ * Setup all muxes required to open the route
+ * to the external strobe signal provider
+ */
+static int led_flash_manager_select_strobe_provider(
+					struct led_classdev_flash *flash,
+					int provider_id)
+{
+	struct led_flash_strobe_provider *provider;
+	int ret, provider_cnt = 0;
+
+	list_for_each_entry(provider, &flash->strobe_providers, list)
+		if (provider_cnt++ == provider_id) {
+			ret = led_flash_manager_setup_muxes(flash,
+						&provider->strobe_gates);
+			return ret;
+		}
+
+	return -EINVAL;
+}
+
+/*
+ * Setup all muxes required to open the route
+ * either to software or external strobe source.
+ */
+int led_flash_manager_set_external_strobe(
+					struct led_classdev_flash *flash,
+					bool external)
+{
+	int ret;
+
+	if (external)
+		ret = led_flash_manager_select_strobe_provider(flash,
+						flash->strobe_provider_id);
+	else
+		/* There can be only one software strobe provider */
+		ret = led_flash_manager_setup_muxes(flash,
+						&flash->software_strobe_gates);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_set_external_strobe);
+
+/* Notify flash manager that async mux is available. */
+int led_flash_manager_bind_async_mux(struct led_flash_mux *async_mux)
+{
+	struct led_flash_mux *mux;
+	bool mux_found = false;
+	int ret = 0;
+
+	if (!async_mux)
+		return -EINVAL;
+
+	mutex_lock(&fm_lock);
+
+	/*
+	 * Check whether the LED Flash Class device using this
+	 * mux has been already registered in the flash manager.
+	 */
+	list_for_each_entry(mux, &mux_waiting_list, list)
+		if (async_mux->node == mux->node) {
+			/* Move the mux to the bound muxes list */
+
+			list_move(&mux->list, &mux_bound_list);
+			mux_found = true;
+
+			if (!try_module_get(async_mux->owner)) {
+				ret = -ENODEV;
+				goto unlock;
+			}
+
+			break;
+		}
+
+	if (!mux_found) {
+		/* This is a new mux - create its representation */
+		mux = kzalloc(sizeof(*mux), GFP_KERNEL);
+		if (!mux) {
+			ret = -ENOMEM;
+			goto unlock;
+		}
+
+		INIT_LIST_HEAD(&mux->refs);
+
+		/* Add the mux to the bound list. */
+		list_add(&mux->list, &mux_bound_list);
+	}
+
+	mux->ops = async_mux->ops;
+	mux->node = async_mux->node;
+	mux->owner = async_mux->owner;
+
+unlock:
+	mutex_unlock(&fm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_bind_async_mux);
+
+int led_flash_manager_unbind_async_mux(struct device_node *mux_node)
+{
+	struct led_flash_mux *mux;
+	int ret = -ENODEV;
+
+	mutex_lock(&fm_lock);
+
+	/*
+	 * Mux can be unbound only when is not used by any
+	 * flash led device, otherwise this is erroneous call.
+	 */
+	list_for_each_entry(mux, &mux_waiting_list, list)
+		if (mux->node == mux_node) {
+			list_move(&mux->list, &mux_waiting_list);
+			ret = 0;
+			break;
+		}
+
+	mutex_unlock(&fm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_unbind_async_mux);
+
+struct led_flash_mux_ops gpio_mux_ops = {
+	.select_line = led_flash_gpio_mux_select_line,
+	.release_private_data = led_flash_gpio_mux_release,
+};
+
+static int __add_mux_ref(struct led_flash_mux_ref *ref,
+				struct led_flash_mux *mux)
+{
+	struct led_flash_mux_ref *r;
+	int ret;
+
+	/*
+	 * One mux device usually appear in more than one strobe
+	 * gate of a single flash LED device (e.g. one software
+	 * and one hardware strobe gate is defined in its DT binding,
+	 * which reflects two lines of a mux). Don't allow for
+	 * more than one flash reference to the same mux.
+	 */
+	list_for_each_entry(r, &mux->refs, list)
+		if (r->flash == ref->flash) {
+			kfree(ref);
+			return 0;
+		}
+
+	/* protect async mux against rmmod */
+	if (mux->owner) {
+		ret = try_module_get(mux->owner);
+		if (ret < 0)
+			return ret;
+	}
+
+	list_add(&ref->list, &mux->refs);
+
+	return 0;
+}
+
+static void __remove_mux_ref(struct led_flash_mux_ref *ref,
+				struct led_flash_mux *mux)
+{
+	/* decrement async mux refcount */
+	if (mux->owner)
+		module_put(mux->owner);
+
+	list_del(&ref->list);
+}
+
+/*
+ * Parse mux node and add the mux it refers to either to waiting
+ * or bound list depending on the mux type (gpio or asynchronous).
+ */
+static int led_flash_manager_parse_mux_node(struct led_classdev_flash *flash,
+					    struct led_flash_strobe_gate *gate)
+{
+	struct led_flash_mux *mux;
+	struct device_node *async_mux_node;
+	struct led_flash_gpio_mux *gpio_mux;
+	struct led_flash_mux_ref *ref;
+	int ret = -EINVAL;
+
+	/* Create flash ref to be added to the mux references list */
+	ref = kzalloc(sizeof(*ref), GFP_KERNEL);
+	if (!ref)
+		return -ENOMEM;
+	ref->flash = flash;
+
+	/* if this is async mux update gate's mux_node accordingly */
+	async_mux_node = of_parse_phandle(gate->mux_node, "mux-async", 0);
+	if (async_mux_node)
+		gate->mux_node = async_mux_node;
+
+	/* Check if the mux isn't already on waiting list */
+	list_for_each_entry(mux, &mux_waiting_list, list)
+		if (mux->node == gate->mux_node)
+			return __add_mux_ref(ref, mux);
+
+	/* Check if the mux isn't already on bound list */
+	list_for_each_entry(mux, &mux_bound_list, list)
+		if (mux->node == gate->mux_node)
+			return __add_mux_ref(ref, mux);
+
+	/* This is a new mux - create its representation */
+	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
+	if (!mux)
+		return -ENOMEM;
+
+	mux->node = gate->mux_node;
+
+	INIT_LIST_HEAD(&mux->refs);
+
+	/* Increment reference count */
+	ret = __add_mux_ref(ref, mux);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Check if this mux has its own driver
+	 * or this is standard gpio mux.
+	 */
+	if (async_mux_node) {
+		/* Add async mux to the waiting list */
+		list_add(&mux->list, &mux_waiting_list);
+	} else {
+		/* Create default gpio mux */
+		ret = led_flash_gpio_mux_create(&gpio_mux, gate->mux_node);
+		if (ret < 0)
+			goto err_gpio_mux_init;
+
+		/* Register gpio mux device */
+		mux->private_data = gpio_mux;
+		mux->ops = &gpio_mux_ops;
+		list_add(&mux->list, &mux_bound_list);
+	}
+
+	return 0;
+
+err_gpio_mux_init:
+	kfree(mux);
+	kfree(ref);
+
+	return ret;
+}
+
+static void led_flash_manager_release_mux(struct led_flash_mux *mux)
+{
+	if (mux->ops->release_private_data) {
+		if (mux->ops->release_private_data)
+			mux->ops->release_private_data(mux->private_data);
+		list_del(&mux->list);
+		kfree(mux);
+	}
+}
+
+static void led_flash_manager_remove_flash_refs(
+					struct led_classdev_flash *flash)
+{
+	struct led_flash_mux_ref *ref, *rn;
+	struct led_flash_mux *mux, *mn;
+
+	/*
+	 * Remove references to the flash from
+	 * all the muxes on the list.
+	 */
+	list_for_each_entry_safe(mux, mn, &mux_bound_list, list)
+		/* Seek for matching flash ref */
+		list_for_each_entry_safe(ref, rn, &mux->refs, list)
+			if (ref->flash == flash) {
+				/* Decrement reference count */
+				__remove_mux_ref(ref, mux);
+				kfree(ref);
+				/*
+				 * Release mux if there are no more
+				 * references pointing to it.
+				 */
+				if (list_empty(&mux->refs))
+					led_flash_manager_release_mux(mux);
+			}
+}
+
+int led_flash_manager_register_flash(struct led_classdev_flash *flash,
+				     struct device_node *node)
+{
+	struct led_flash_strobe_provider *provider;
+	struct led_flash_strobe_gate *gate;
+	struct led_classdev_flash *fl;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	int ret = 0;
+
+	if (!flash || !node)
+		return -EINVAL;
+
+	mutex_lock(&fm_lock);
+
+	/* Don't allow to register the same flash more than once */
+	list_for_each_entry(fl, &flash_list, list)
+		if (fl == flash)
+			goto unlock;
+
+	INIT_LIST_HEAD(&flash->software_strobe_gates);
+	INIT_LIST_HEAD(&flash->strobe_providers);
+
+	ret = of_led_flash_manager_parse_dt(flash, node);
+	if (ret < 0)
+		goto unlock;
+
+	/*
+	 * Register mux devices declared by the flash device
+	 * if they have not been yet known to the flash manager.
+	 */
+	list_for_each_entry(gate, &flash->software_strobe_gates, list) {
+		ret = led_flash_manager_parse_mux_node(flash, gate);
+		if (ret < 0)
+			goto err_parse_mux_node;
+	}
+
+	list_for_each_entry(provider, &flash->strobe_providers, list) {
+		list_for_each_entry(gate, &provider->strobe_gates, list) {
+			ret = led_flash_manager_parse_mux_node(flash, gate);
+			if (ret < 0)
+				goto err_parse_mux_node;
+		}
+		++flash->num_strobe_providers;
+	}
+
+	/*
+	 * It doesn't make sense to register in the flash manager
+	 * if there are no strobe providers defined.
+	 */
+	if (flash->num_strobe_providers == 0)
+		goto err_parse_mux_node;
+
+	led_cdev->flags |= LED_DEV_CAP_FL_MANAGER;
+	flash->has_external_strobe = true;
+	flash->strobe_provider_id = 0;
+
+	/* Create sysfs attributes describing available strobe providers. */
+	ret = led_flash_manager_create_providers_attrs(flash);
+	if (ret < 0)
+		goto err_create_provider_attrs;
+
+	/* Add flash to the list of flashes maintained by the flash manager. */
+	list_add_tail(&flash->list, &flash_list);
+
+	mutex_unlock(&fm_lock);
+
+	return ret;
+
+err_create_provider_attrs:
+	led_flash_manager_remove_providers_attrs(flash);
+err_parse_mux_node:
+	led_flash_manager_remove_flash_refs(flash);
+	of_led_flash_manager_release_dt_data(flash);
+unlock:
+	mutex_unlock(&fm_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_register_flash);
+
+void led_flash_manager_unregister_flash(struct led_classdev_flash *flash)
+{
+	struct led_classdev_flash *fl, *n;
+	bool found_flash = false;
+
+	mutex_lock(&fm_lock);
+
+	/* Remove flash from the list, if found */
+	list_for_each_entry_safe(fl, n, &flash_list, list)
+		if (fl == flash) {
+			found_flash = true;
+			break;
+		}
+
+	if (!found_flash)
+		goto unlock;
+
+	list_del(&fl->list);
+
+	led_flash_manager_remove_providers_attrs(flash);
+
+	/* Remove all references to the flash */
+	led_flash_manager_remove_flash_refs(flash);
+	of_led_flash_manager_release_dt_data(flash);
+
+unlock:
+	mutex_unlock(&fm_lock);
+}
+EXPORT_SYMBOL_GPL(led_flash_manager_unregister_flash);
+
+MODULE_AUTHOR("Jacek Anaszewski <j.anaszewski@samsung.com>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("LED Flash Manager");
diff --git a/drivers/leds/of_led_flash_manager.c b/drivers/leds/of_led_flash_manager.c
new file mode 100644
index 0000000..d22d853
--- /dev/null
+++ b/drivers/leds/of_led_flash_manager.c
@@ -0,0 +1,155 @@
+/*
+ * LED flash manager of helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#include <linux/device.h>
+#include <linux/led-class-flash.h>
+#include <linux/of.h>
+#include <linux/of_led_flash_manager.h>
+#include <linux/slab.h>
+
+static int __parse_strobe_gate_node(struct led_classdev_flash *flash,
+				    struct device_node *node,
+				    struct list_head *gates)
+{
+	struct device_node *mux_node, *subnode;
+	struct led_flash_strobe_gate *gate;
+	struct led_classdev *led_cdev = &flash->led_cdev;
+	u32 line_id;
+	int ret, num_gates = 0;
+
+	/* Get node mux node */
+	mux_node = of_parse_phandle(node, "mux", 0);
+	if (!mux_node)
+		return -EINVAL;
+
+	/* Get the value the mux has to be written to open the gate */
+	ret = of_property_read_u32(node, "mux-line-id", &line_id);
+	if (ret < 0)
+		return ret;
+
+	gate = kzalloc(sizeof(*gate), GFP_KERNEL);
+	if (!gate)
+		return -ENOMEM;
+
+	gate->mux_node = mux_node;
+	gate->line_id = line_id;
+	list_add_tail(&gate->list, gates);
+
+	/* Parse nested gate nodes */
+	for_each_available_child_of_node(node, subnode) {
+		if (!of_node_ncmp(subnode->name, "gate", 4)) {
+			ret = __parse_strobe_gate_node(flash, subnode, gates);
+			if (ret < 0) {
+				dev_dbg(led_cdev->dev->parent,
+				"Failed to parse gate node (%d)\n",
+				ret);
+				goto err_parse_gate;
+			}
+
+			if (++num_gates > 1) {
+				dev_dbg(led_cdev->dev->parent,
+				"Only one available child gate is allowed.\n");
+				ret = -EINVAL;
+				goto err_parse_gate;
+			}
+		}
+	}
+
+	return 0;
+
+err_parse_gate:
+	kfree(gate);
+
+	return ret;
+}
+
+static int __parse_strobe_provider_node(struct led_classdev_flash *flash,
+			       struct device_node *node)
+{
+	struct device_node *provider_node;
+	struct led_flash_strobe_provider *provider;
+	int ret;
+
+	/* Create strobe provider representation */
+	provider = kzalloc(sizeof(*provider), GFP_KERNEL);
+	if (!provider)
+		return -ENOMEM;
+
+	/* Get phandle of the device generating strobe source signal */
+	provider_node = of_parse_phandle(node, "strobe-provider", 0);
+
+	/* provider property may be absent */
+	if (provider_node) {
+		/* Use compatible property as a strobe provider name */
+		ret = of_property_read_string(provider_node, "compatible",
+					(const char **) &provider->name);
+		if (ret < 0)
+			goto err_read_name;
+	}
+
+	INIT_LIST_HEAD(&provider->strobe_gates);
+
+	list_add_tail(&provider->list, &flash->strobe_providers);
+
+	ret = __parse_strobe_gate_node(flash, node, &provider->strobe_gates);
+	if (ret < 0)
+		goto err_read_name;
+
+	return 0;
+
+err_read_name:
+	kfree(provider);
+
+	return ret;
+}
+
+int of_led_flash_manager_parse_dt(struct led_classdev_flash *flash,
+				  struct device_node *node)
+{
+	struct device_node *subnode;
+	int ret;
+
+	for_each_available_child_of_node(node, subnode) {
+		if (!of_node_cmp(subnode->name, "gate-software-strobe")) {
+			ret = __parse_strobe_gate_node(flash, subnode,
+						&flash->software_strobe_gates);
+			if (ret < 0)
+				return ret;
+		}
+		if (!of_node_ncmp(subnode->name, "gate-external-strobe", 20)) {
+			ret = __parse_strobe_provider_node(flash, subnode);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_led_flash_manager_parse_dt);
+
+void of_led_flash_manager_release_dt_data(struct led_classdev_flash *flash)
+{
+	struct list_head *gate_list;
+	struct led_flash_strobe_gate *gate, *gn;
+	struct led_flash_strobe_provider *provider, *sn;
+
+	gate_list = &flash->software_strobe_gates;
+	list_for_each_entry_safe(gate, gn, gate_list, list)
+		kfree(gate);
+
+	list_for_each_entry_safe(provider, sn, &flash->strobe_providers, list) {
+		list_for_each_entry_safe(gate, gn, &provider->strobe_gates,
+								list)
+			kfree(gate);
+		kfree(provider);
+	}
+}
+EXPORT_SYMBOL_GPL(of_led_flash_manager_release_dt_data);
diff --git a/include/linux/led-flash-gpio-mux.h b/include/linux/led-flash-gpio-mux.h
new file mode 100644
index 0000000..c56d38f
--- /dev/null
+++ b/include/linux/led-flash-gpio-mux.h
@@ -0,0 +1,68 @@
+/*
+ * LED Flash Class gpio mux
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _LED_FLASH_GPIO_MUX_H
+#define _LED_FLASH_GPIO_MUX_H
+
+struct device_node;
+
+struct list_head;
+
+/**
+ * struct led_flash_gpio_mux_selector - element of gpio mux selectors list
+ * @list: links mux selectors
+ * @gpio: mux selector gpio
+ */
+struct led_flash_gpio_mux_selector {
+	struct list_head list;
+	int gpio;
+};
+
+/**
+ * struct led_flash_gpio_mux - gpio mux
+ * @selectors:	mux selectors
+ */
+struct led_flash_gpio_mux {
+	struct list_head selectors;
+};
+
+/**
+ * led_flash_gpio_mux_create - create gpio mux
+ * @new_mux: created mux
+ * @mux_node: device tree node with gpio definitions
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int led_flash_gpio_mux_create(struct led_flash_gpio_mux **new_mux,
+			struct device_node *mux_node);
+
+/**
+ * led_flash_gpio_mux_release - release gpio mux
+ * @gpio_mux: mux to be released
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ */
+void led_flash_gpio_mux_release(void *gpio_mux);
+
+/**
+ * led_flash_gpio_mux_select_line - select mux line
+ * @line_id: id of the line to be selected
+ * @mux: mux to be set
+ *
+ * Create V4L2 subdev wrapping given LED subsystem device.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int led_flash_gpio_mux_select_line(u32 line_id, void *mux);
+
+#endif /* _LED_FLASH_GPIO_MUX_H */
diff --git a/include/linux/led-flash-manager.h b/include/linux/led-flash-manager.h
new file mode 100644
index 0000000..a3d958c
--- /dev/null
+++ b/include/linux/led-flash-manager.h
@@ -0,0 +1,146 @@
+/*
+ * LED Flash Manager for maintaining LED Flash Class devices
+ * along with their corresponding muxes that faciliate dynamic
+ * reconfiguration of the strobe signal source.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _LED_FLASH_MANAGER_H
+#define _LED_FLASH_MANAGER_H
+
+#include <linux/types.h>
+
+struct list_head;
+
+struct led_flash_mux_ops {
+	/* select mux line */
+	int (*select_line)(u32 line_id, void *mux);
+	/*
+	 * release private mux data - it is intended for gpio muxes
+	 * only and mustn't be initialized by asynchronous muxes.
+	 */
+	void (*release_private_data)(void *mux);
+};
+
+/**
+ * struct led_flash_mux_ref - flash mux reference
+ * @list:	links flashes pointing to a mux
+ * @flash:	flash holding a mux reference
+ */
+struct led_flash_mux_ref {
+	struct list_head list;
+	struct led_classdev_flash *flash;
+};
+
+/**
+ * struct led_flash_mux - flash mux used for routing strobe signal
+ * @list:		list of muxes declared by registered flashes
+ * @node:		mux Device Tree node
+ * @private_data:	mux internal data
+ * @ops:		ops facilitating mux state manipulation
+ * @refs:		list of flashes using the mux
+ * @owner:		module owning an async mux driver
+ */
+struct led_flash_mux {
+	struct list_head list;
+	struct device_node *node;
+	void *private_data;
+	struct led_flash_mux_ops *ops;
+	struct list_head refs;
+	struct module *owner;
+};
+
+#ifdef CONFIG_LEDS_FLASH_MANAGER
+
+/**
+ * led_flash_manager_set_external_strobe - setup strobe signal routing
+ * @flash: the flash LED to set
+ * @external: true - setup external strobe,
+ *	      false - setup software strobe
+ *
+ * Configure muxes to route either software or external
+ * strobe signal to the flash LED device.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_set_external_strobe(
+					struct led_classdev_flash *flash,
+					bool external);
+
+/**
+ * led_flash_manager_bind_async_mux - bind asynchronous mulitplexer
+ * @async_mux: mux registration data
+ *
+ * Notify the flash manager that an asychronous mux has been probed.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_bind_async_mux(struct led_flash_mux *async_mux);
+
+/**
+ * led_flash_manager_unbind_async_mux - unbind asynchronous mulitplexer
+ * @mux_node: device node of the mux to be unbound
+ *
+ * Notify the flash manager that an asychronous mux has been removed.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_unbind_async_mux(struct device_node *mux_node);
+
+/**
+ * led_flash_manager_register_flash - register LED Flash Class device
+				      in the flash manager
+ * @flash: the flash LED to register
+ * @node: Device Tree node - it is expected to contain information
+ *	  about strobe signal topology
+ *
+ * Register LED Flash Class device and retrieve information
+ * about topology of the strobe signals available for the device.
+ *
+ * Returns: 0 on success or negative error value on failure.
+ */
+int led_flash_manager_register_flash(struct led_classdev_flash *flash,
+				     struct device_node *node);
+
+/**
+ * led_flash_manager_unregister_flash - unregister LED Flash Class device
+ *					from the flash manager
+ * @flash: the flash LED to unregister
+ *
+ * Unregister LED Flash Class device from the flash manager.
+ */
+void led_flash_manager_unregister_flash(struct led_classdev_flash *flash);
+#else
+static inline int led_flash_manager_set_external_strobe(
+					struct led_classdev_flash *flash,
+					bool external)
+{
+	return 0;
+}
+static inline int led_flash_manager_bind_async_mux(
+					struct led_flash_mux *async_mux)
+{
+	return 0;
+}
+static inline int led_flash_manager_unbind_async_mux(
+					struct device_node *mux_node)
+{
+	return 0;
+}
+static inline int led_flash_manager_register_flash(
+					struct led_classdev_flash *flash,
+					struct device_node *node)
+{
+	return 0;
+}
+static inline void led_flash_manager_unregister_flash(
+					struct led_classdev_flash *flash) { }
+#endif /* CONFIG_LEDS_FLASH_MANAGER */
+
+#endif /* _LED_FLASH_MANAGER_H */
diff --git a/include/linux/leds.h b/include/linux/leds.h
index 8e38eef..b42bb59 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -46,6 +46,7 @@ struct led_classdev {
 #define LED_DEV_CAP_TORCH	(1 << 21)
 #define LED_DEV_CAP_FLASH	(1 << 22)
 #define LED_DEV_CAP_INDICATOR	(1 << 23)
+#define LED_DEV_CAP_FL_MANAGER	(1 << 24)
 
 	/* Set LED brightness level */
 	/* Must not sleep, use a workqueue if needed */
diff --git a/include/linux/of_led_flash_manager.h b/include/linux/of_led_flash_manager.h
new file mode 100644
index 0000000..d27cb46
--- /dev/null
+++ b/include/linux/of_led_flash_manager.h
@@ -0,0 +1,80 @@
+/*
+ * LED flash manager of helpers.
+ *
+ *	Copyright (C) 2014 Samsung Electronics Co., Ltd
+ *	Author: Jacek Anaszewski <j.anaszewski@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation."
+ */
+
+#ifndef _OF_LED_FLASH_MANAGER_H
+#define _OF_LED_FLASH_MANAGER_H
+
+#include <linux/sysfs.h>
+#include <linux/device.h>
+
+struct led_classdev_flash;
+struct device_node;
+struct list_head;
+
+#define MAX_ATTR_NAME 18 /* allows for strobe providers ids up to 999 */
+
+/**
+ * struct led_flash_strobe_gate - strobe signal gate
+ * @list:	links gates
+ * @mux_node:	gate's parent mux
+ * @line_id:	id of a mux line that the gate represents
+ */
+struct led_flash_strobe_gate {
+	struct list_head list;
+	struct device_node *mux_node;
+	u32 line_id;
+};
+
+/**
+ * struct led_flash_strobe_provider - external strobe signal provider that
+				      may be associated with the flash device
+ * @list:		links strobe providers
+ * @strobe_gates:	list of gates that route strobe signal
+			from the strobe provider to the flash device
+ * @node:		device node of the strobe provider device
+ */
+struct led_flash_strobe_provider {
+	struct list_head list;
+	struct list_head strobe_gates;
+	const char *name;
+	struct device_attribute attr;
+	char attr_name[MAX_ATTR_NAME];
+	bool attr_registered;
+};
+
+/**
+ * of_led_flash_manager_parse_dt - parse flash manager data of
+ *				   a LED Flash Class device DT node
+ *
+ * @flash: the LED Flash Class device to store the parsed data in
+ * @node: device node to parse
+ *
+ * Parse the multiplexers' settings that need to be applied for
+ * opening a route to all the flash strobe signals available for
+ * the device.
+ *
+ * Returns: 0 on success or negative error value on failure
+ */
+int of_led_flash_manager_parse_dt(struct led_classdev_flash *flash,
+					 struct device_node *node);
+
+
+/**
+ * of_led_flash_manager_release_dt_data - release parsed DT data
+ *
+ * @flash: the LED Flash Class device to release data from
+ *
+ * Release data structures containing information about strobe
+ * source routes available for the device.
+ */
+void of_led_flash_manager_release_dt_data(struct led_classdev_flash *flash);
+
+#endif /* _OF_LED_FLASH_MANAGER_H */
-- 
1.7.9.5

