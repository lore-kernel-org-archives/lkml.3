Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557AbaEGURk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 16:17:40 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:35694 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaEGURh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 16:17:37 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 May 2014 16:17:37 EDT
X-LoopCount0: from 10.208.46.70
X-IronPort-AV: E=Sophos;i="4.97,1006,1389765600"; 
   d="scan'208";a="501200781"
From: Mario Limonciello <mario_limonciello@dell.com>
To: matthew.garrett@nebula.com
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Mario Limonciello <mario_limonciello@dell.com>
Subject: [PATCH 2/2] alienware-wmi: For WMAX HDMI method, introduce a way to query HDMI cable status
Date: Wed,  7 May 2014 15:08:10 -0500
Message-Id: <1399493290-4572-2-git-send-email-mario_limonciello@dell.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399493290-4572-1-git-send-email-mario_limonciello@dell.com>
References: <1399493290-4572-1-git-send-email-mario_limonciello@dell.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are now multiple HDMI attributes associated with the WMAX method,
create a sysfs group for them instead.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
---
 drivers/platform/x86/alienware-wmi.c |  116 +++++++++++++++++++++++++---------
 1 file changed, 86 insertions(+), 30 deletions(-)

diff --git a/drivers/platform/x86/alienware-wmi.c b/drivers/platform/x86/alienware-wmi.c
index e5329ea..3b175b1 100644
--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -32,6 +32,7 @@
 #define WMAX_METHOD_HDMI_STATUS		0x2
 #define WMAX_METHOD_BRIGHTNESS		0x3
 #define WMAX_METHOD_ZONE_CONTROL	0x4
+#define WMAX_METHOD_HDMI_CABLE		0x5
 
 MODULE_AUTHOR("Mario Limonciello <mario_limonciello@dell.com>");
 MODULE_DESCRIPTION("Alienware special feature control");
@@ -422,41 +423,84 @@ static void alienware_zone_exit(struct platform_device *dev)
 	The HDMI mux sysfs node indicates the status of the HDMI input mux.
 	It can toggle between standard system GPU output and HDMI input.
 */
-static ssize_t show_hdmi(struct device *dev, struct device_attribute *attr,
-			 char *buf)
+static acpi_status alienware_hdmi_command(struct hdmi_args *in_args,
+					  u32 command, int *out_data)
 {
 	acpi_status status;
-	struct acpi_buffer input;
 	union acpi_object *obj;
-	u32 tmp = 0;
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
+	struct acpi_buffer input;
+	struct acpi_buffer output;
+	input.length = (acpi_size) sizeof(*in_args);
+	input.pointer = in_args;
+	if (out_data != NULL) {
+		output.length = ACPI_ALLOCATE_BUFFER;
+		output.pointer = NULL;
+		status = wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
+					     command, &input, &output);
+	} else
+		status = wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
+					     command, &input, NULL);
+
+	if (ACPI_SUCCESS(status) && out_data != NULL) {
+		obj = (union acpi_object *)output.pointer;
+		if (obj && obj->type == ACPI_TYPE_INTEGER)
+			*out_data = (u32) obj->integer.value;
+	}
+	return status;
+
+}
+
+static ssize_t show_hdmi_cable(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	acpi_status status;
+	u32 out_data;
 	struct hdmi_args in_args = {
 		.arg = 0,
 	};
-	input.length = (acpi_size) sizeof(in_args);
-	input.pointer = &in_args;
-	status = wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
-				     WMAX_METHOD_HDMI_STATUS, &input, &output);
+	status =
+	    alienware_hdmi_command(&in_args, WMAX_METHOD_HDMI_CABLE,
+				   (u32 *) &out_data);
+	if (ACPI_SUCCESS(status)) {
+		if (out_data == 0)
+			return scnprintf(buf, PAGE_SIZE,
+					 "[unconnected] connected unknown\n");
+		else if (out_data == 1)
+			return scnprintf(buf, PAGE_SIZE,
+					 "unconnected [connected] unknown\n");
+	}
+	pr_err("alienware-wmi: unknown HDMI cable status: %d\n", status);
+	return scnprintf(buf, PAGE_SIZE, "unconnected connected [unknown]\n");
+}
+
+static ssize_t show_hdmi_source(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	acpi_status status;
+	u32 out_data;
+	struct hdmi_args in_args = {
+		.arg = 0,
+	};
+	status =
+	    alienware_hdmi_command(&in_args, WMAX_METHOD_HDMI_STATUS,
+				   (u32 *) &out_data);
 
 	if (ACPI_SUCCESS(status)) {
-		obj = (union acpi_object *)output.pointer;
-		if (obj && obj->type == ACPI_TYPE_INTEGER)
-			tmp = (u32) obj->integer.value;
-		if (tmp == 1)
+		if (out_data == 1)
 			return scnprintf(buf, PAGE_SIZE,
 					 "[input] gpu unknown\n");
-		else if (tmp == 2)
+		else if (out_data == 2)
 			return scnprintf(buf, PAGE_SIZE,
 					 "input [gpu] unknown\n");
 	}
-	pr_err("alienware-wmi: unknown HDMI status: %d\n", status);
+	pr_err("alienware-wmi: unknown HDMI source status: %d\n", out_data);
 	return scnprintf(buf, PAGE_SIZE, "input gpu [unknown]\n");
 }
 
-static ssize_t toggle_hdmi(struct device *dev, struct device_attribute *attr,
-			   const char *buf, size_t count)
+static ssize_t toggle_hdmi_source(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
 {
-	struct acpi_buffer input;
 	acpi_status status;
 	struct hdmi_args args;
 	if (strcmp(buf, "gpu\n") == 0)
@@ -466,33 +510,45 @@ static ssize_t toggle_hdmi(struct device *dev, struct device_attribute *attr,
 	else
 		args.arg = 3;
 	pr_debug("alienware-wmi: setting hdmi to %d : %s", args.arg, buf);
-	input.length = (acpi_size) sizeof(args);
-	input.pointer = &args;
-	status = wmi_evaluate_method(WMAX_CONTROL_GUID, 1,
-				     WMAX_METHOD_HDMI_SOURCE, &input, NULL);
+
+	status = alienware_hdmi_command(&args, WMAX_METHOD_HDMI_SOURCE, NULL);
+
 	if (ACPI_FAILURE(status))
 		pr_err("alienware-wmi: HDMI toggle failed: results: %u\n",
 		       status);
 	return count;
 }
 
-static DEVICE_ATTR(hdmi, S_IRUGO | S_IWUSR, show_hdmi, toggle_hdmi);
+static DEVICE_ATTR(cable, S_IRUGO, show_hdmi_cable, NULL);
+static DEVICE_ATTR(source, S_IRUGO | S_IWUSR, show_hdmi_source,
+		   toggle_hdmi_source);
 
-static void remove_hdmi(struct platform_device *device)
+static struct attribute *hdmi_attrs[] = {
+	&dev_attr_cable.attr,
+	&dev_attr_source.attr,
+	NULL,
+};
+
+static struct attribute_group hdmi_attribute_group = {
+	.name = "hdmi",
+	.attrs = hdmi_attrs,
+};
+
+static void remove_hdmi(struct platform_device *dev)
 {
-	device_remove_file(&device->dev, &dev_attr_hdmi);
+	sysfs_remove_group(&dev->dev.kobj, &hdmi_attribute_group);
 }
 
-static int create_hdmi(void)
+static int create_hdmi(struct platform_device *dev)
 {
-	int ret = -ENOMEM;
-	ret = device_create_file(&platform_device->dev, &dev_attr_hdmi);
+	int ret;
+	ret = sysfs_create_group(&dev->dev.kobj, &hdmi_attribute_group);
 	if (ret)
 		goto error_create_hdmi;
 	return 0;
 
 error_create_hdmi:
-	remove_hdmi(platform_device);
+	remove_hdmi(dev);
 	return ret;
 }
 
@@ -526,7 +582,7 @@ static int __init alienware_wmi_init(void)
 		goto fail_platform_device2;
 
 	if (interface == WMAX) {
-		ret = create_hdmi();
+		ret = create_hdmi(platform_device);
 		if (ret)
 			goto fail_prep_hdmi;
 	}
-- 
1.7.9.5

