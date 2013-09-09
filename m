Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359Ab3IIIkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 04:40:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:37859 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870Ab3IIIkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 04:40:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="375383746"
Message-ID: <522D8991.5070707@intel.com>
Date: Mon, 09 Sep 2013 16:40:49 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 1/2] ACPI / video: seperate backlight control and event interface
References: <522D88C3.7000808@intel.com>
In-Reply-To: <522D88C3.7000808@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backlight control and event delivery functionality provided by ACPI
video module is mixed together and registered all during video device
enumeration time. As a result, the two functionality are also removed
together on module unload time or by the acpi_video_unregister function.
The two functionalities are actually independent and one may be useful
while the other one may be broken, so it is desirable to seperate the
two functionalities such that it is clear and easy to disable one
functionality without affecting the other one. This patch does the
seperation and as a result, a new video_bus_head list is introduced to
store all registered video bus structure and a new function
acpi_video_unregister_backlight is introduced to unregister backlight
interfaces for all video devices belonging to stored video buses.

Currently, there is no need to unregister ACPI video's event delivery
functionality alone so the function acpi_video_remove_notify_handler is
not introduced, it can be easily added when needed.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/acpi/video.c | 451 ++++++++++++++++++++++++++++++---------------------
 include/acpi/video.h |   2 +
 2 files changed, 264 insertions(+), 189 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index aebcf63..5ad5a71 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -89,6 +89,8 @@ static bool use_bios_initial_backlight = 1;
 module_param(use_bios_initial_backlight, bool, 0644);
 
 static int register_count;
+static struct mutex video_list_lock;
+static struct list_head video_bus_head;
 static int acpi_video_bus_add(struct acpi_device *device);
 static int acpi_video_bus_remove(struct acpi_device *device);
 static void acpi_video_bus_notify(struct acpi_device *device, u32 event);
@@ -157,6 +159,7 @@ struct acpi_video_bus {
 	struct acpi_video_bus_flags flags;
 	struct list_head video_device_list;
 	struct mutex device_list_lock;	/* protects video_device_list */
+	struct list_head entry;
 	struct input_dev *input;
 	char phys[32];	/* for input device */
 	struct notifier_block pm_nb;
@@ -884,79 +887,6 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 
 	if (acpi_has_method(device->dev->handle, "_DDC"))
 		device->cap._DDC = 1;
-
-	if (acpi_video_backlight_support()) {
-		struct backlight_properties props;
-		struct pci_dev *pdev;
-		acpi_handle acpi_parent;
-		struct device *parent = NULL;
-		int result;
-		static int count;
-		char *name;
-
-		result = acpi_video_init_brightness(device);
-		if (result)
-			return;
-		name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
-		if (!name)
-			return;
-		count++;
-
-		acpi_get_parent(device->dev->handle, &acpi_parent);
-
-		pdev = acpi_get_pci_dev(acpi_parent);
-		if (pdev) {
-			parent = &pdev->dev;
-			pci_dev_put(pdev);
-		}
-
-		memset(&props, 0, sizeof(struct backlight_properties));
-		props.type = BACKLIGHT_FIRMWARE;
-		props.max_brightness = device->brightness->count - 3;
-		device->backlight = backlight_device_register(name,
-							      parent,
-							      device,
-							      &acpi_backlight_ops,
-							      &props);
-		kfree(name);
-		if (IS_ERR(device->backlight))
-			return;
-
-		/*
-		 * Save current brightness level in case we have to restore it
-		 * before acpi_video_device_lcd_set_level() is called next time.
-		 */
-		device->backlight->props.brightness =
-				acpi_video_get_brightness(device->backlight);
-
-		device->cooling_dev = thermal_cooling_device_register("LCD",
-					device->dev, &video_cooling_ops);
-		if (IS_ERR(device->cooling_dev)) {
-			/*
-			 * Set cooling_dev to NULL so we don't crash trying to
-			 * free it.
-			 * Also, why the hell we are returning early and
-			 * not attempt to register video output if cooling
-			 * device registration failed?
-			 * -- dtor
-			 */
-			device->cooling_dev = NULL;
-			return;
-		}
-
-		dev_info(&device->dev->dev, "registered as cooling_device%d\n",
-			 device->cooling_dev->id);
-		result = sysfs_create_link(&device->dev->dev.kobj,
-				&device->cooling_dev->device.kobj,
-				"thermal_cooling");
-		if (result)
-			printk(KERN_ERR PREFIX "Create sysfs link\n");
-		result = sysfs_create_link(&device->cooling_dev->device.kobj,
-				&device->dev->dev.kobj, "device");
-		if (result)
-			printk(KERN_ERR PREFIX "Create sysfs link\n");
-
-	}
 }
 
 /*
@@ -1143,13 +1073,6 @@ acpi_video_bus_get_one_device(struct acpi_device *device,
 	acpi_video_device_bind(video, data);
 	acpi_video_device_find_cap(data);
 
-	status = acpi_install_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
-					     acpi_video_device_notify, data);
-	if (ACPI_FAILURE(status))
-		dev_err(&device->dev, "Error installing notify handler\n");
-	else
-		data->flags.notify = 1;
-
 	mutex_lock(&video->device_list_lock);
 	list_add_tail(&data->entry, &video->video_device_list);
 	mutex_unlock(&video->device_list_lock);
@@ -1454,64 +1377,6 @@ acpi_video_bus_get_devices(struct acpi_video_bus *video,
 	return status;
 }
 
-static int acpi_video_bus_put_one_device(struct acpi_video_device *device)
-{
-	acpi_status status;
-
-	if (!device || !device->video)
-		return -ENOENT;
-
-	if (device->flags.notify) {
-		status = acpi_remove_notify_handler(device->dev->handle,
-				ACPI_DEVICE_NOTIFY, acpi_video_device_notify);
-		if (ACPI_FAILURE(status))
-			dev_err(&device->dev->dev,
-					"Can't remove video notify handler\n");
-	}
-
-	if (device->backlight) {
-		backlight_device_unregister(device->backlight);
-		device->backlight = NULL;
-	}
-	if (device->cooling_dev) {
-		sysfs_remove_link(&device->dev->dev.kobj,
-				  "thermal_cooling");
-		sysfs_remove_link(&device->cooling_dev->device.kobj,
-				  "device");
-		thermal_cooling_device_unregister(device->cooling_dev);
-		device->cooling_dev = NULL;
-	}
-
-	return 0;
-}
-
-static int acpi_video_bus_put_devices(struct acpi_video_bus *video)
-{
-	int status;
-	struct acpi_video_device *dev, *next;
-
-	mutex_lock(&video->device_list_lock);
-
-	list_for_each_entry_safe(dev, next, &video->video_device_list, entry) {
-
-		status = acpi_video_bus_put_one_device(dev);
-		if (ACPI_FAILURE(status))
-			printk(KERN_WARNING PREFIX
-			       "hhuuhhuu bug in acpi video driver.\n");
-
-		if (dev->brightness) {
-			kfree(dev->brightness->levels);
-			kfree(dev->brightness);
-		}
-		list_del(&dev->entry);
-		kfree(dev);
-	}
-
-	mutex_unlock(&video->device_list_lock);
-
-	return 0;
-}
-
 /* acpi_video interface */
 
 /*
@@ -1536,7 +1401,7 @@ static void acpi_video_bus_notify(struct acpi_device *device, u32 event)
 	struct input_dev *input;
 	int keycode = 0;
 
-	if (!video)
+	if (!video || !video->input)
 		return;
 
 	input = video->input;
@@ -1691,12 +1556,253 @@ acpi_video_bus_match(acpi_handle handle, u32 level, void *context,
 	return AE_OK;
 }
 
+static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
+{
+	if (acpi_video_backlight_support()) {
+		struct backlight_properties props;
+		struct pci_dev *pdev;
+		acpi_handle acpi_parent;
+		struct device *parent = NULL;
+		int result;
+		static int count;
+		char *name;
+
+		result = acpi_video_init_brightness(device);
+		if (result)
+			return;
+		name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
+		if (!name)
+			return;
+		count++;
+
+		acpi_get_parent(device->dev->handle, &acpi_parent);
+
+		pdev = acpi_get_pci_dev(acpi_parent);
+		if (pdev) {
+			parent = &pdev->dev;
+			pci_dev_put(pdev);
+		}
+
+		memset(&props, 0, sizeof(struct backlight_properties));
+		props.type = BACKLIGHT_FIRMWARE;
+		props.max_brightness = device->brightness->count - 3;
+		device->backlight = backlight_device_register(name,
+							      parent,
+							      device,
+							      &acpi_backlight_ops,
+							      &props);
+		kfree(name);
+		if (IS_ERR(device->backlight))
+			return;
+
+		/*
+		 * Save current brightness level in case we have to restore it
+		 * before acpi_video_device_lcd_set_level() is called next time.
+		 */
+		device->backlight->props.brightness =
+				acpi_video_get_brightness(device->backlight);
+
+		device->cooling_dev = thermal_cooling_device_register("LCD",
+					device->dev, &video_cooling_ops);
+		if (IS_ERR(device->cooling_dev)) {
+			/*
+			 * Set cooling_dev to NULL so we don't crash trying to
+			 * free it.
+			 * Also, why the hell we are returning early and
+			 * not attempt to register video output if cooling
+			 * device registration failed?
+			 * -- dtor
+			 */
+			device->cooling_dev = NULL;
+			return;
+		}
+
+		dev_info(&device->dev->dev, "registered as cooling_device%d\n",
+			 device->cooling_dev->id);
+		result = sysfs_create_link(&device->dev->dev.kobj,
+				&device->cooling_dev->device.kobj,
+				"thermal_cooling");
+		if (result)
+			printk(KERN_ERR PREFIX "Create sysfs link\n");
+		result = sysfs_create_link(&device->cooling_dev->device.kobj,
+				&device->dev->dev.kobj, "device");
+		if (result)
+			printk(KERN_ERR PREFIX "Create sysfs link\n");
+	}
+}
+
+static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
+{
+	struct acpi_video_device *dev;
+
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry(dev, &video->video_device_list, entry)
+		acpi_video_dev_register_backlight(dev);
+	mutex_unlock(&video->device_list_lock);
+
+	video->pm_nb.notifier_call = acpi_video_resume;
+	video->pm_nb.priority = 0;
+	return register_pm_notifier(&video->pm_nb);
+}
+
+static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device)
+{
+	if (device->backlight) {
+		backlight_device_unregister(device->backlight);
+		device->backlight = NULL;
+	}
+	if (device->brightness) {
+		kfree(device->brightness->levels);
+		kfree(device->brightness);
+		device->brightness = NULL;
+	}
+	if (device->cooling_dev) {
+		sysfs_remove_link(&device->dev->dev.kobj, "thermal_cooling");
+		sysfs_remove_link(&device->cooling_dev->device.kobj, "device");
+		thermal_cooling_device_unregister(device->cooling_dev);
+		device->cooling_dev = NULL;
+	}
+}
+
+static int acpi_video_bus_unregister_backlight(struct acpi_video_bus *video)
+{
+	struct acpi_video_device *dev;
+	int error = unregister_pm_notifier(&video->pm_nb);
+
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry(dev, &video->video_device_list, entry)
+		acpi_video_dev_unregister_backlight(dev);
+	mutex_unlock(&video->device_list_lock);
+
+	return error;
+}
+
+int acpi_video_unregister_backlight(void)
+{
+	struct acpi_video_bus *video;
+	int error = 0;
+
+	mutex_lock(&video_list_lock);
+	list_for_each_entry(video, &video_bus_head, entry) {
+		error = acpi_video_bus_unregister_backlight(video);
+		if (error)
+			break;
+	}
+	mutex_unlock(&video_list_lock);
+
+	return error;
+}
+EXPORT_SYMBOL(acpi_video_unregister_backlight);
+
+static void acpi_video_dev_add_notify_handler(struct acpi_video_device *device)
+{
+	acpi_status status;
+	struct acpi_device *adev = device->dev;
+
+	status = acpi_install_notify_handler(adev->handle, ACPI_DEVICE_NOTIFY,
+					     acpi_video_device_notify, device);
+	if (ACPI_FAILURE(status))
+		dev_err(&adev->dev, "Error installing notify handler\n");
+	else
+		device->flags.notify = 1;
+}
+
+static int acpi_video_bus_add_notify_handler(struct acpi_video_bus *video)
+{
+	struct input_dev *input;
+	struct acpi_video_device *dev;
+	int error;
+
+	video->input = input = input_allocate_device();
+	if (!input) {
+		error = -ENOMEM;
+		goto out;
+	}
+
+	error = acpi_video_bus_start_devices(video);
+	if (error)
+		goto err_free_input;
+
+	snprintf(video->phys, sizeof(video->phys),
+			"%s/video/input0", acpi_device_hid(video->device));
+
+	input->name = acpi_device_name(video->device);
+	input->phys = video->phys;
+	input->id.bustype = BUS_HOST;
+	input->id.product = 0x06;
+	input->dev.parent = &video->device->dev;
+	input->evbit[0] = BIT(EV_KEY);
+	set_bit(KEY_SWITCHVIDEOMODE, input->keybit);
+	set_bit(KEY_VIDEO_NEXT, input->keybit);
+	set_bit(KEY_VIDEO_PREV, input->keybit);
+	set_bit(KEY_BRIGHTNESS_CYCLE, input->keybit);
+	set_bit(KEY_BRIGHTNESSUP, input->keybit);
+	set_bit(KEY_BRIGHTNESSDOWN, input->keybit);
+	set_bit(KEY_BRIGHTNESS_ZERO, input->keybit);
+	set_bit(KEY_DISPLAY_OFF, input->keybit);
+
+	error = input_register_device(input);
+	if (error)
+		goto err_stop_dev;
+
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry(dev, &video->video_device_list, entry)
+		acpi_video_dev_add_notify_handler(dev);
+	mutex_unlock(&video->device_list_lock);
+
+	return 0;
+
+err_stop_dev:
+	acpi_video_bus_stop_devices(video);
+err_free_input:
+	input_free_device(input);
+	video->input = NULL;
+out:
+	return error;
+}
+
+static void acpi_video_dev_remove_notify_handler(struct acpi_video_device *dev)
+{
+	if (dev->flags.notify) {
+		acpi_remove_notify_handler(dev->dev->handle, ACPI_DEVICE_NOTIFY,
+					   acpi_video_device_notify);
+		dev->flags.notify = 0;
+	}
+}
+
+static void acpi_video_bus_remove_notify_handler(struct acpi_video_bus *video)
+{
+	struct acpi_video_device *dev;
+
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry(dev, &video->video_device_list, entry)
+		acpi_video_dev_remove_notify_handler(dev);
+	mutex_unlock(&video->device_list_lock);
+
+	acpi_video_bus_stop_devices(video);
+	input_unregister_device(video->input);
+	video->input = NULL;
+}
+
+static int acpi_video_bus_put_devices(struct acpi_video_bus *video)
+{
+	struct acpi_video_device *dev, *next;
+
+	mutex_lock(&video->device_list_lock);
+	list_for_each_entry_safe(dev, next, &video->video_device_list, entry) {
+		list_del(&dev->entry);
+		kfree(dev);
+	}
+	mutex_unlock(&video->device_list_lock);
+
+	return 0;
+}
+
 static int instance;
 
 static int acpi_video_bus_add(struct acpi_device *device)
 {
 	struct acpi_video_bus *video;
-	struct input_dev *input;
 	int error;
 	acpi_status status;
 
@@ -1748,62 +1854,24 @@ static int acpi_video_bus_add(struct acpi_device *device)
 	if (error)
 		goto err_put_video;
 
-	video->input = input = input_allocate_device();
-	if (!input) {
-		error = -ENOMEM;
-		goto err_put_video;
-	}
-
-	error = acpi_video_bus_start_devices(video);
-	if (error)
-		goto err_free_input_dev;
-
-	snprintf(video->phys, sizeof(video->phys),
-		"%s/video/input0", acpi_device_hid(video->device));
-
-	input->name = acpi_device_name(video->device);
-	input->phys = video->phys;
-	input->id.bustype = BUS_HOST;
-	input->id.product = 0x06;
-	input->dev.parent = &device->dev;
-	input->evbit[0] = BIT(EV_KEY);
-	set_bit(KEY_SWITCHVIDEOMODE, input->keybit);
-	set_bit(KEY_VIDEO_NEXT, input->keybit);
-	set_bit(KEY_VIDEO_PREV, input->keybit);
-	set_bit(KEY_BRIGHTNESS_CYCLE, input->keybit);
-	set_bit(KEY_BRIGHTNESSUP, input->keybit);
-	set_bit(KEY_BRIGHTNESSDOWN, input->keybit);
-	set_bit(KEY_BRIGHTNESS_ZERO, input->keybit);
-	set_bit(KEY_DISPLAY_OFF, input->keybit);
-
 	printk(KERN_INFO PREFIX "%s [%s] (multi-head: %s  rom: %s  post: %s)\n",
 	       ACPI_VIDEO_DEVICE_NAME, acpi_device_bid(device),
 	       video->flags.multihead ? "yes" : "no",
 	       video->flags.rom ? "yes" : "no",
 	       video->flags.post ? "yes" : "no");
+	mutex_lock(&video_list_lock);
+	list_add_tail(&video->entry, &video_bus_head);
+	mutex_unlock(&video_list_lock);
 
-	video->pm_nb.notifier_call = acpi_video_resume;
-	video->pm_nb.priority = 0;
-	error = register_pm_notifier(&video->pm_nb);
-	if (error)
-		goto err_stop_video;
-
-	error = input_register_device(input);
-	if (error)
-		goto err_unregister_pm_notifier;
+	acpi_video_bus_register_backlight(video);
+	acpi_video_bus_add_notify_handler(video);
 
 	return 0;
 
- err_unregister_pm_notifier:
-	unregister_pm_notifier(&video->pm_nb);
- err_stop_video:
-	acpi_video_bus_stop_devices(video);
- err_free_input_dev:
-	input_free_device(input);
- err_put_video:
+err_put_video:
 	acpi_video_bus_put_devices(video);
 	kfree(video->attached_array);
- err_free_video:
+err_free_video:
 	kfree(video);
 	device->driver_data = NULL;
 
@@ -1820,12 +1888,14 @@ static int acpi_video_bus_remove(struct acpi_device *device)
 
 	video = acpi_driver_data(device);
 
-	unregister_pm_notifier(&video->pm_nb);
-
-	acpi_video_bus_stop_devices(video);
+	acpi_video_bus_remove_notify_handler(video);
+	acpi_video_bus_unregister_backlight(video);
 	acpi_video_bus_put_devices(video);
 
-	input_unregister_device(video->input);
+	mutex_lock(&video_list_lock);
+	list_del(&video->entry);
+	mutex_unlock(&video_list_lock);
+
 	kfree(video->attached_array);
 	kfree(video);
 
@@ -1874,6 +1944,9 @@ int acpi_video_register(void)
 		return 0;
 	}
 
+	mutex_init(&video_list_lock);
+	INIT_LIST_HEAD(&video_bus_head);
+
 	result = acpi_bus_register_driver(&acpi_video_bus);
 	if (result < 0)
 		return -ENODEV;
diff --git a/include/acpi/video.h b/include/acpi/video.h
index 61109f2..0c665b5 100644
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -19,11 +19,13 @@ struct acpi_device;
 #if (defined CONFIG_ACPI_VIDEO || defined CONFIG_ACPI_VIDEO_MODULE)
 extern int acpi_video_register(void);
 extern void acpi_video_unregister(void);
+extern int acpi_video_unregister_backlight(void);
 extern int acpi_video_get_edid(struct acpi_device *device, int type,
 			       int device_id, void **edid);
 #else
 static inline int acpi_video_register(void) { return 0; }
 static inline void acpi_video_unregister(void) { return; }
+static inline int acpi_video_unregister_backlight(void) { return; }
 static inline int acpi_video_get_edid(struct acpi_device *device, int type,
 				      int device_id, void **edid)
 {
-- 
1.8.4.12.g2ea3df6

