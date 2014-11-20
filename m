Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbaKTIwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:52:06 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:41268 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaKTIwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:52:04 -0500
From: Alexander Gavrilenko <alexander.gavrilenko@googlemail.com>
X-Google-Original-From: Alexander Gavrilenko <Alexander.Gavrilenko@gmail.com>
To: Mattia Dongili <malattia@linux.it>, Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Gavrilenko <alexander.gavrilenko@gmail.com>
Subject: [PATCH] sony-laptop: add support for Sony Vaio Fit multi-flip laptop/presentation/tablet transformation
Date: Thu, 20 Nov 2014 11:51:12 +0300
Message-Id: <1416473472-20851-1-git-send-email-Alexander.Gavrilenko@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current mode is exported via sysfs:
/sys/devices/platform/sony-laptop/tablet

Signed-off-by: Alexander Gavrilenko <alexander.gavrilenko@gmail.com>
---
--- linux-3.17.3/drivers/platform/x86/sony-laptop.c.orig	2014-11-19 13:15:35.965048636 +0300
+++ linux-3.17.3/drivers/platform/x86/sony-laptop.c	2014-11-19 13:17:21.139166837 +0300
@@ -135,6 +135,13 @@ MODULE_PARM_DESC(kbd_backlight_timeout,
 		 "meaningful values vary from 0 to 3 and their meaning depends "
 		 "on the model (default: no change from current value)");
 
+static int tablet_mode = 2;
+module_param(tablet_mode, int, 0);
+MODULE_PARM_DESC(tablet_mode,
+		 "set this if your laptop have different tablet mode value, "
+		 "default is 2 (Sony Vaio Fit multi-flip), "
+		 "only affects SW_TABLET_MODE events");
+
 #ifdef CONFIG_PM_SLEEP
 static void sony_nc_thermal_resume(void);
 #endif
@@ -181,6 +188,11 @@ static int sony_nc_touchpad_setup(struct
 				  unsigned int handle);
 static void sony_nc_touchpad_cleanup(struct platform_device *pd);
 
+static int sony_nc_tablet_mode_setup(struct platform_device *pd,
+				  unsigned int handle);
+static void sony_nc_tablet_mode_cleanup(struct platform_device *pd);
+static int sony_nc_tablet_mode_update(void);
+
 enum sony_nc_rfkill {
 	SONY_WIFI,
 	SONY_BLUETOOTH,
@@ -1198,7 +1210,8 @@ static int sony_nc_hotkeys_decode(u32 ev
 enum event_types {
 	HOTKEY = 1,
 	KILLSWITCH,
-	GFX_SWITCH
+	GFX_SWITCH,
+	TABLET_MODE_SWITCH
 };
 static void sony_nc_notify(struct acpi_device *device, u32 event)
 {
@@ -1273,6 +1286,10 @@ static void sony_nc_notify(struct acpi_d
 			ev_type = GFX_SWITCH;
 			real_ev = __sony_nc_gfx_switch_status_get();
 			break;
+		case 0x016f:
+			ev_type = TABLET_MODE_SWITCH;
+			real_ev = sony_nc_tablet_mode_update();
+			break;
 		default:
 			dprintk("Unknown event 0x%x for handle 0x%x\n",
 					event, handle);
@@ -1428,6 +1445,13 @@ static void sony_nc_function_setup(struc
 				pr_err("couldn't set up smart connect support (%d)\n",
 						result);
 			break;
+		case 0x016f:
+			/* laptop/presentation/tablet transformation for Sony Vaio Fit 11a/13a/14a/15a */
+			result = sony_nc_tablet_mode_setup(pf_device, handle);
+			if (result)
+				pr_err("couldn't set up tablet mode support (%d)\n",
+						result);
+			break;
 		default:
 			continue;
 		}
@@ -1507,6 +1531,9 @@ static void sony_nc_function_cleanup(str
 		case 0x0168:
 			sony_nc_smart_conn_cleanup(pd);
 			break;
+		case 0x016f:
+			sony_nc_tablet_mode_cleanup(pd);
+			break;
 		default:
 			continue;
 		}
@@ -1547,6 +1574,12 @@ static void sony_nc_function_resume(void
 		case 0x0135:
 			sony_nc_rfkill_update();
 			break;
+		case 0x016f:
+			/* re-enable transformation events */
+			sony_call_snc_handle(handle, 0, &result);
+			acpi_bus_generate_netlink_event(sony_nc_acpi_device->pnp.device_class,
+					dev_name(&sony_nc_acpi_device->dev), TABLET_MODE_SWITCH, sony_nc_tablet_mode_update());
+			break;
 		default:
 			continue;
 		}
@@ -3145,6 +3178,97 @@ static void sony_nc_backlight_cleanup(vo
 		backlight_device_unregister(sony_bl_props.dev);
 }
 
+/* laptop/presentation/tablet mode for Sony Vaio Fit 11a/13a/14a/15a */
+struct snc_tablet_control {
+	struct device_attribute attr;
+	int handle;
+	int mode;
+};
+static struct snc_tablet_control *tablet_ctl;
+
+static ssize_t sony_nc_tablet_mode_show(struct device *dev,
+					struct device_attribute *attr,
+					char *buffer)
+{
+	if(!tablet_ctl)
+		return -EIO;
+
+	return snprintf(buffer, PAGE_SIZE, "%d\n", tablet_ctl->mode);
+}
+
+static int sony_nc_tablet_mode_update(void) {
+	struct input_dev *key_dev = sony_laptop_input.key_dev;
+
+	if (!key_dev)
+		return -1;
+
+	if (!tablet_ctl)
+		return -1;
+
+	if (sony_call_snc_handle(tablet_ctl->handle, 0x0200, &tablet_ctl->mode))
+		return -1;
+
+	input_report_switch(key_dev, SW_TABLET_MODE, tablet_ctl->mode == tablet_mode);
+	input_sync(key_dev);
+
+	return tablet_ctl->mode;
+}
+
+static int sony_nc_tablet_mode_setup(struct platform_device *pd,
+					unsigned int handle)
+{
+	struct input_dev *key_dev = sony_laptop_input.key_dev;
+	int value, ret;
+
+	if (tablet_ctl) {
+		pr_warn("handle 0x%.4x: laptop/presentation/tablet mode control setup already done for 0x%.4x\n",
+				handle, tablet_ctl->handle);
+		return -EBUSY;
+	}
+
+	if (sony_call_snc_handle(handle, 0x0000, &value))
+		return -EIO;
+
+	tablet_ctl = kzalloc(sizeof(struct snc_tablet_control), GFP_KERNEL);
+	if (!tablet_ctl)
+		return -ENOMEM;
+
+	tablet_ctl->handle = handle;
+
+	sysfs_attr_init(&tablet_ctl->attr.attr);
+	tablet_ctl->attr.attr.name = "tablet";
+	tablet_ctl->attr.attr.mode = S_IRUGO;
+	tablet_ctl->attr.show = sony_nc_tablet_mode_show;
+	tablet_ctl->attr.store = NULL;
+
+	if (key_dev)
+		input_set_capability(key_dev, EV_SW, SW_TABLET_MODE);
+
+	ret = device_create_file(&pd->dev, &tablet_ctl->attr);
+	if (ret)
+		goto tablet_error;
+	return 0;
+
+tablet_error:
+	device_remove_file(&pd->dev, &tablet_ctl->attr);
+	kfree(tablet_ctl);
+	tablet_ctl = NULL;
+	sony_call_snc_handle(handle, 0x0100, &value);
+	return ret;
+}
+
+static void sony_nc_tablet_mode_cleanup(struct platform_device *pd)
+{
+	int value;
+
+	if(tablet_ctl) {
+		device_remove_file(&pd->dev, &tablet_ctl->attr);
+		sony_call_snc_handle(tablet_ctl->handle, 0x0100, &value);
+		kfree(tablet_ctl);
+		tablet_ctl = NULL;
+	}
+}
+
 static int sony_nc_add(struct acpi_device *device)
 {
 	acpi_status status;
