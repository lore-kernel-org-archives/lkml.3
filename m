Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3LRG5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:57:44 -0500
Received: from mga14.intel.com ([143.182.124.37]:58557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab3LRG5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:57:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666721"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 04/13] ACPI, PCI: replace open-coded _DSM specific code with helper functions
Date: Wed, 18 Dec 2013 14:58:12 +0800
Message-Id: <1387349901-3391-5-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper functions to simplify _DSM related code in pci-label driver.
Also enforce more strict checks on objects returned by _DSM method.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/pci-label.c |  121 +++++++++++++----------------------------------
 1 file changed, 34 insertions(+), 87 deletions(-)

diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index f6e01a5..f12dcd1 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -195,80 +195,58 @@ enum acpi_attr_enum {
 static void dsm_label_utf16s_to_utf8s(union acpi_object *obj, char *buf)
 {
 	int len;
-	len = utf16s_to_utf8s((const wchar_t *)obj->
-			      package.elements[1].string.pointer,
-			      obj->package.elements[1].string.length,
+	len = utf16s_to_utf8s((const wchar_t *)obj->string.pointer,
+			      obj->string.length,
 			      UTF16_LITTLE_ENDIAN,
 			      buf, PAGE_SIZE);
 	buf[len] = '\n';
 }
 
 static int
-dsm_get_label(acpi_handle handle, int func,
-	      struct acpi_buffer *output,
-	      char *buf, enum acpi_attr_enum attribute)
+dsm_get_label(struct device *dev, char *buf, enum acpi_attr_enum attr)
 {
-	struct acpi_object_list input;
-	union acpi_object params[4];
-	union acpi_object *obj;
-	int len = 0;
-
-	int err;
-
-	input.count = 4;
-	input.pointer = params;
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = sizeof(device_label_dsm_uuid);
-	params[0].buffer.pointer = (char *)device_label_dsm_uuid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = 0x02;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = func;
-	params[3].type = ACPI_TYPE_PACKAGE;
-	params[3].package.count = 0;
-	params[3].package.elements = NULL;
-
-	err = acpi_evaluate_object(handle, "_DSM", &input, output);
-	if (err)
+	acpi_handle handle;
+	union acpi_object *obj, *tmp;
+	int len = -1;
+
+	handle = ACPI_HANDLE(dev);
+	if (!handle)
 		return -1;
 
-	obj = (union acpi_object *)output->pointer;
-	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2) {
-		len = obj->package.elements[0].integer.value;
+	obj = acpi_evaluate_dsm(handle, device_label_dsm_uuid, 0x2,
+				DEVICE_LABEL_DSM, NULL);
+	if (!obj)
+		return -1;
+
+	tmp = obj->package.elements;
+	if (obj->type == ACPI_TYPE_PACKAGE && obj->package.count == 2 &&
+	    tmp[0].type == ACPI_TYPE_INTEGER &&
+	    tmp[1].type == ACPI_TYPE_STRING) {
+		len = tmp[0].integer.value;
 		if (buf) {
-			if (attribute == ACPI_ATTR_INDEX_SHOW)
+			/*
+			 * This second string element is optional even when
+			 * this _DSM is implemented; when not implemented,
+			 * this entry must return a null string.
+			 */
+			if (attr == ACPI_ATTR_INDEX_SHOW)
 				scnprintf(buf, PAGE_SIZE, "%llu\n",
-				obj->package.elements[0].integer.value);
-			else if (attribute == ACPI_ATTR_LABEL_SHOW)
-				dsm_label_utf16s_to_utf8s(obj, buf);
-			kfree(output->pointer);
-			return strlen(buf);
+				tmp->integer.value);
+			else if (attr == ACPI_ATTR_LABEL_SHOW)
+				dsm_label_utf16s_to_utf8s(tmp + 1, buf);
+			len = strlen(buf) > 0 ? strlen(buf) : -1;
 		}
-		kfree(output->pointer);
-		return len;
 	}
 
-	kfree(output->pointer);
+	ACPI_FREE(obj);
 
-	return -1;
+	return len;
 }
 
 static bool
 device_has_dsm(struct device *dev)
 {
-	acpi_handle handle;
-	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
-
-	handle = ACPI_HANDLE(dev);
-
-	if (!handle)
-		return FALSE;
-
-	if (dsm_get_label(handle, DEVICE_LABEL_DSM, &output, NULL,
-			  ACPI_ATTR_NONE) > 0)
-		return TRUE;
-
-	return FALSE;
+	return dsm_get_label(dev, NULL, ACPI_ATTR_NONE) > 0;
 }
 
 static umode_t
@@ -287,44 +265,13 @@ acpi_index_string_exist(struct kobject *kobj, struct attribute *attr, int n)
 static ssize_t
 acpilabel_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
-	acpi_handle handle;
-	int length;
-
-	handle = ACPI_HANDLE(dev);
-
-	if (!handle)
-		return -1;
-
-	length = dsm_get_label(handle, DEVICE_LABEL_DSM,
-			       &output, buf, ACPI_ATTR_LABEL_SHOW);
-
-	if (length < 1)
-		return -1;
-
-	return length;
+	return dsm_get_label(dev, buf, ACPI_ATTR_LABEL_SHOW);
 }
 
 static ssize_t
 acpiindex_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
-	acpi_handle handle;
-	int length;
-
-	handle = ACPI_HANDLE(dev);
-
-	if (!handle)
-		return -1;
-
-	length = dsm_get_label(handle, DEVICE_LABEL_DSM,
-			       &output, buf, ACPI_ATTR_INDEX_SHOW);
-
-	if (length < 0)
-		return -1;
-
-	return length;
-
+	return dsm_get_label(dev, buf, ACPI_ATTR_INDEX_SHOW);
 }
 
 static struct device_attribute acpi_attr_label = {
-- 
1.7.10.4

