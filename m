Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3LRG6D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:58:03 -0500
Received: from mga14.intel.com ([143.182.124.37]:58557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab3LRG56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:57:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666832"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 08/13] ACPI, TPM: replace open-coded _DSM specific code with helper functions
Date: Wed, 18 Dec 2013 14:58:16 +0800
Message-Id: <1387349901-3391-9-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper functions to simplify _DSM related code in TPM driver.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/char/tpm/tpm_ppi.c |  404 ++++++++++++++++----------------------------
 1 file changed, 145 insertions(+), 259 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 1e9cc11..ad5143f 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -2,15 +2,6 @@
 #include <acpi/acpi_drivers.h>
 #include "tpm.h"
 
-static const u8 tpm_ppi_uuid[] = {
-	0xA6, 0xFA, 0xDD, 0x3D,
-	0x1B, 0x36,
-	0xB4, 0x4E,
-	0xA4, 0x24,
-	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
-};
-static char *tpm_device_name = "TPM";
-
 #define TPM_PPI_REVISION_ID	1
 #define TPM_PPI_FN_VERSION	1
 #define TPM_PPI_FN_SUBREQ	2
@@ -24,250 +15,185 @@ static char *tpm_device_name = "TPM";
 #define PPI_VS_REQ_END		255
 #define PPI_VERSION_LEN		3
 
+static const u8 tpm_ppi_uuid[] = {
+	0xA6, 0xFA, 0xDD, 0x3D,
+	0x1B, 0x36,
+	0xB4, 0x4E,
+	0xA4, 0x24,
+	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
+};
+
+static char *tpm_device_name = "TPM";
+static char tpm_ppi_version[PPI_VERSION_LEN + 1];
+static acpi_handle tpm_ppi_handle;
+
 static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
 				void **return_value)
 {
 	acpi_status status = AE_OK;
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
-	if (ACPI_SUCCESS(acpi_get_name(handle, ACPI_SINGLE_NAME, &buffer))) {
-		if (strstr(buffer.pointer, context) != NULL) {
-			*return_value = handle;
-			status = AE_CTRL_TERMINATE;
+	status = acpi_get_name(handle, ACPI_SINGLE_NAME, &buffer);
+	if (ACPI_FAILURE(status))
+		return AE_OK;
+
+	if (strstr(buffer.pointer, context) != NULL) {
+		union acpi_object *obj;
+
+		/* Cache version string */
+		obj = acpi_evaluate_dsm_typed(handle, tpm_ppi_uuid,
+				TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
+				NULL, ACPI_TYPE_STRING);
+		if (obj) {
+			strlcpy(tpm_ppi_version, obj->string.pointer,
+				PPI_VERSION_LEN + 1);
+			ACPI_FREE(obj);
 		}
-		kfree(buffer.pointer);
+
+		*return_value = handle;
+		status = AE_CTRL_TERMINATE;
 	}
+	kfree(buffer.pointer);
 
 	return status;
 }
 
-static inline void ppi_assign_params(union acpi_object params[4],
-				     u64 function_num)
+static inline union acpi_object *
+tpm_eval_dsm(int func, acpi_object_type type, union acpi_object *argv4)
 {
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = sizeof(tpm_ppi_uuid);
-	params[0].buffer.pointer = (char *)tpm_ppi_uuid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = TPM_PPI_REVISION_ID;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = function_num;
-	params[3].type = ACPI_TYPE_PACKAGE;
-	params[3].package.count = 0;
-	params[3].package.elements = NULL;
+	BUG_ON(!tpm_ppi_handle);
+	return acpi_evaluate_dsm_typed(tpm_ppi_handle, tpm_ppi_uuid,
+				       TPM_PPI_REVISION_ID, func, argv4, type);
 }
 
 static ssize_t tpm_show_ppi_version(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	acpi_handle handle;
-	acpi_status status;
-	struct acpi_object_list input;
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object params[4];
-	union acpi_object *obj;
-
-	input.count = 4;
-	ppi_assign_params(params, TPM_PPI_FN_VERSION);
-	input.pointer = params;
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX, ppi_callback, NULL,
-				     tpm_device_name, &handle);
-	if (ACPI_FAILURE(status))
-		return -ENXIO;
-
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					 ACPI_TYPE_STRING);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
-	obj = (union acpi_object *)output.pointer;
-	status = scnprintf(buf, PAGE_SIZE, "%s\n", obj->string.pointer);
-	kfree(output.pointer);
-	return status;
+	return scnprintf(buf, PAGE_SIZE, "%s\n", tpm_ppi_version);
 }
 
 static ssize_t tpm_show_ppi_request(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	acpi_handle handle;
-	acpi_status status;
-	struct acpi_object_list input;
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object params[4];
-	union acpi_object *ret_obj;
-
-	input.count = 4;
-	ppi_assign_params(params, TPM_PPI_FN_GETREQ);
-	input.pointer = params;
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX, ppi_callback, NULL,
-				     tpm_device_name, &handle);
-	if (ACPI_FAILURE(status))
+	ssize_t size = -EINVAL;
+	union acpi_object *obj;
+
+	obj = tpm_eval_dsm(TPM_PPI_FN_GETREQ, ACPI_TYPE_PACKAGE, NULL);
+	if (!obj)
 		return -ENXIO;
 
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					    ACPI_TYPE_PACKAGE);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
 	/*
 	 * output.pointer should be of package type, including two integers.
 	 * The first is function return code, 0 means success and 1 means
 	 * error. The second is pending TPM operation requested by the OS, 0
 	 * means none and >0 means operation value.
 	 */
-	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
-	if (ret_obj->type == ACPI_TYPE_INTEGER) {
-		if (ret_obj->integer.value) {
-			status = -EFAULT;
-			goto cleanup;
-		}
-		ret_obj++;
-		if (ret_obj->type == ACPI_TYPE_INTEGER)
-			status = scnprintf(buf, PAGE_SIZE, "%llu\n",
-					   ret_obj->integer.value);
+	if (obj->package.count == 2 &&
+	    obj->package.elements[0].type == ACPI_TYPE_INTEGER &&
+	    obj->package.elements[1].type == ACPI_TYPE_INTEGER) {
+		if (obj->package.elements[0].integer.value)
+			size = -EFAULT;
 		else
-			status = -EINVAL;
-	} else {
-		status = -EINVAL;
+			size = scnprintf(buf, PAGE_SIZE, "%llu\n",
+				 obj->package.elements[1].integer.value);
 	}
-cleanup:
-	kfree(output.pointer);
-	return status;
+
+	ACPI_FREE(obj);
+
+	return size;
 }
 
 static ssize_t tpm_store_ppi_request(struct device *dev,
 				     struct device_attribute *attr,
 				     const char *buf, size_t count)
 {
-	char version[PPI_VERSION_LEN + 1];
-	acpi_handle handle;
-	acpi_status status;
-	struct acpi_object_list input;
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object params[4];
-	union acpi_object obj;
 	u32 req;
 	u64 ret;
+	int func = TPM_PPI_FN_SUBREQ;
+	union acpi_object *obj, tmp;
+	union acpi_object argv4 = ACPI_INIT_DSM_ARGV4(1, &tmp);
 
-	input.count = 4;
-	ppi_assign_params(params, TPM_PPI_FN_VERSION);
-	input.pointer = params;
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX, ppi_callback, NULL,
-				     tpm_device_name, &handle);
-	if (ACPI_FAILURE(status))
-		return -ENXIO;
-
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					    ACPI_TYPE_STRING);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
-	strlcpy(version,
-		((union acpi_object *)output.pointer)->string.pointer,
-		PPI_VERSION_LEN + 1);
-	kfree(output.pointer);
-	output.length = ACPI_ALLOCATE_BUFFER;
-	output.pointer = NULL;
 	/*
 	 * the function to submit TPM operation request to pre-os environment
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (strcmp(version, "1.1") == -1)
-		params[2].integer.value = TPM_PPI_FN_SUBREQ;
-	else
-		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
+	if (strcmp(tpm_ppi_version, "1.1") >= 0)
+		func = TPM_PPI_FN_SUBREQ2;
+
 	/*
 	 * PPI spec defines params[3].type as ACPI_TYPE_PACKAGE. Some BIOS
 	 * accept buffer/string/integer type, but some BIOS accept buffer/
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-	if (strcmp(version, "1.2") == -1) {
-		params[3].type = ACPI_TYPE_BUFFER;
-		params[3].buffer.length = sizeof(req);
-		sscanf(buf, "%d", &req);
-		params[3].buffer.pointer = (char *)&req;
+	if (strcmp(tpm_ppi_version, "1.2") < 0) {
+		if (sscanf(buf, "%d", &req) != 1)
+			return -EINVAL;
+		argv4.type = ACPI_TYPE_BUFFER;
+		argv4.buffer.length = sizeof(req);
+		argv4.buffer.pointer = (u8 *)&req;
 	} else {
-		params[3].package.count = 1;
-		obj.type = ACPI_TYPE_INTEGER;
-		sscanf(buf, "%llu", &obj.integer.value);
-		params[3].package.elements = &obj;
+		tmp.type = ACPI_TYPE_INTEGER;
+		if (sscanf(buf, "%llu", &tmp.integer.value) != 1)
+			return -EINVAL;
+	}
+
+	obj = tpm_eval_dsm(func, ACPI_TYPE_INTEGER, &argv4);
+	if (!obj) {
+		return -ENXIO;
+	} else {
+		ret = obj->integer.value;
+		ACPI_FREE(obj);
 	}
 
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					    ACPI_TYPE_INTEGER);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
-	ret = ((union acpi_object *)output.pointer)->integer.value;
 	if (ret == 0)
-		status = (acpi_status)count;
-	else if (ret == 1)
-		status = -EPERM;
-	else
-		status = -EFAULT;
-	kfree(output.pointer);
-	return status;
+		return (acpi_status)count;
+
+	return (ret == 1) ? -EPERM : -EFAULT;
 }
 
 static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 					      struct device_attribute *attr,
 					      char *buf)
 {
-	char version[PPI_VERSION_LEN + 1];
-	acpi_handle handle;
-	acpi_status status;
-	struct acpi_object_list input;
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object params[4];
 	u32 ret;
-	char *info[] = {
+	acpi_status status;
+	union acpi_object *obj = NULL;
+	union acpi_object tmp = {
+		.type = ACPI_TYPE_BUFFER,
+		.buffer.length = 0,
+		.buffer.pointer = NULL
+	};
+
+	static char *info[] = {
 		"None",
 		"Shutdown",
 		"Reboot",
 		"OS Vendor-specific",
 		"Error",
 	};
-	input.count = 4;
-	ppi_assign_params(params, TPM_PPI_FN_VERSION);
-	input.pointer = params;
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX, ppi_callback, NULL,
-				     tpm_device_name, &handle);
-	if (ACPI_FAILURE(status))
-		return -ENXIO;
 
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					    ACPI_TYPE_STRING);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
-	strlcpy(version,
-		((union acpi_object *)output.pointer)->string.pointer,
-		PPI_VERSION_LEN + 1);
 	/*
 	 * PPI spec defines params[3].type as empty package, but some platforms
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-	if (strcmp(version, "1.2") == -1) {
-		params[3].type = ACPI_TYPE_BUFFER;
-		params[3].buffer.length =  0;
-		params[3].buffer.pointer = NULL;
+	if (strcmp(tpm_ppi_version, "1.2") < 0)
+		obj = &tmp;
+	obj = tpm_eval_dsm(TPM_PPI_FN_GETACT, ACPI_TYPE_INTEGER, obj);
+	if (!obj) {
+		return -ENXIO;
+	} else {
+		ret = obj->integer.value;
+		ACPI_FREE(obj);
 	}
-	params[2].integer.value = TPM_PPI_FN_GETACT;
-	kfree(output.pointer);
-	output.length = ACPI_ALLOCATE_BUFFER;
-	output.pointer = NULL;
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					    ACPI_TYPE_INTEGER);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
-	ret = ((union acpi_object *)output.pointer)->integer.value;
+
 	if (ret < ARRAY_SIZE(info) - 1)
 		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret, info[ret]);
 	else
 		status = scnprintf(buf, PAGE_SIZE, "%d: %s\n", ret,
 				   info[ARRAY_SIZE(info)-1]);
-	kfree(output.pointer);
 	return status;
 }
 
@@ -275,27 +201,14 @@ static ssize_t tpm_show_ppi_response(struct device *dev,
 				     struct device_attribute *attr,
 				     char *buf)
 {
-	acpi_handle handle;
-	acpi_status status;
-	struct acpi_object_list input;
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object params[4];
-	union acpi_object *ret_obj;
-	u64 req;
-
-	input.count = 4;
-	ppi_assign_params(params, TPM_PPI_FN_GETRSP);
-	input.pointer = params;
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX, ppi_callback, NULL,
-				     tpm_device_name, &handle);
-	if (ACPI_FAILURE(status))
+	acpi_status status = -EINVAL;
+	union acpi_object *obj, *ret_obj;
+	u64 req, res;
+
+	obj = tpm_eval_dsm(TPM_PPI_FN_GETRSP, ACPI_TYPE_PACKAGE, NULL);
+	if (!obj)
 		return -ENXIO;
 
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					    ACPI_TYPE_PACKAGE);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
 	/*
 	 * parameter output.pointer should be of package type, including
 	 * 3 integers. The first means function return code, the second means
@@ -303,115 +216,81 @@ static ssize_t tpm_show_ppi_response(struct device *dev,
 	 * the most recent TPM operation request. Only if the first is 0, and
 	 * the second integer is not 0, the response makes sense.
 	 */
-	ret_obj = ((union acpi_object *)output.pointer)->package.elements;
-	if (ret_obj->type != ACPI_TYPE_INTEGER) {
-		status = -EINVAL;
+	ret_obj = obj->package.elements;
+	if (obj->package.count < 3 ||
+	    ret_obj[0].type != ACPI_TYPE_INTEGER ||
+	    ret_obj[1].type != ACPI_TYPE_INTEGER ||
+	    ret_obj[2].type != ACPI_TYPE_INTEGER)
 		goto cleanup;
-	}
-	if (ret_obj->integer.value) {
+
+	if (ret_obj[0].integer.value) {
 		status = -EFAULT;
 		goto cleanup;
 	}
-	ret_obj++;
-	if (ret_obj->type != ACPI_TYPE_INTEGER) {
-		status = -EINVAL;
-		goto cleanup;
-	}
-	if (ret_obj->integer.value) {
-		req = ret_obj->integer.value;
-		ret_obj++;
-		if (ret_obj->type != ACPI_TYPE_INTEGER) {
-			status = -EINVAL;
-			goto cleanup;
-		}
-		if (ret_obj->integer.value == 0)
+
+	req = ret_obj[1].integer.value;
+	res = ret_obj[2].integer.value;
+	if (req) {
+		if (res == 0)
 			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
 					   "0: Success");
-		else if (ret_obj->integer.value == 0xFFFFFFF0)
+		else if (res == 0xFFFFFFF0)
 			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
 					   "0xFFFFFFF0: User Abort");
-		else if (ret_obj->integer.value == 0xFFFFFFF1)
+		else if (res == 0xFFFFFFF1)
 			status = scnprintf(buf, PAGE_SIZE, "%llu %s\n", req,
 					   "0xFFFFFFF1: BIOS Failure");
-		else if (ret_obj->integer.value >= 1 &&
-			 ret_obj->integer.value <= 0x00000FFF)
+		else if (res >= 1 && res <= 0x00000FFF)
 			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
-					   req, ret_obj->integer.value,
-					   "Corresponding TPM error");
+					   req, res, "Corresponding TPM error");
 		else
 			status = scnprintf(buf, PAGE_SIZE, "%llu %llu: %s\n",
-					   req, ret_obj->integer.value,
-					   "Error");
+					   req, res, "Error");
 	} else {
 		status = scnprintf(buf, PAGE_SIZE, "%llu: %s\n",
-				   ret_obj->integer.value, "No Recent Request");
+				   req, "No Recent Request");
 	}
+
 cleanup:
-	kfree(output.pointer);
+	ACPI_FREE(obj);
 	return status;
 }
 
 static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 {
-	char *str = buf;
-	char version[PPI_VERSION_LEN + 1];
-	acpi_handle handle;
-	acpi_status status;
-	struct acpi_object_list input;
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	union acpi_object params[4];
-	union acpi_object obj;
 	int i;
 	u32 ret;
-	char *info[] = {
+	char *str = buf;
+	union acpi_object *obj, tmp;
+	union acpi_object argv = ACPI_INIT_DSM_ARGV4(1, &tmp);
+
+	static char *info[] = {
 		"Not implemented",
 		"BIOS only",
 		"Blocked for OS by BIOS",
 		"User required",
 		"User not required",
 	};
-	input.count = 4;
-	ppi_assign_params(params, TPM_PPI_FN_VERSION);
-	input.pointer = params;
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-				     ACPI_UINT32_MAX, ppi_callback, NULL,
-				     tpm_device_name, &handle);
-	if (ACPI_FAILURE(status))
-		return -ENXIO;
 
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					 ACPI_TYPE_STRING);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
-
-	strlcpy(version,
-		((union acpi_object *)output.pointer)->string.pointer,
-		PPI_VERSION_LEN + 1);
-	kfree(output.pointer);
-	output.length = ACPI_ALLOCATE_BUFFER;
-	output.pointer = NULL;
-	if (strcmp(version, "1.2") == -1)
+	if (strcmp(tpm_ppi_version, "1.2") < 0)
 		return -EPERM;
 
-	params[2].integer.value = TPM_PPI_FN_GETOPR;
-	params[3].package.count = 1;
-	obj.type = ACPI_TYPE_INTEGER;
-	params[3].package.elements = &obj;
+	tmp.type = ACPI_TYPE_INTEGER;
 	for (i = start; i <= end; i++) {
-		obj.integer.value = i;
-		status = acpi_evaluate_object_typed(handle, "_DSM",
-			 &input, &output, ACPI_TYPE_INTEGER);
-		if (ACPI_FAILURE(status))
+		tmp.integer.value = i;
+		obj = tpm_eval_dsm(TPM_PPI_FN_GETOPR, ACPI_TYPE_INTEGER, &argv);
+		if (!obj) {
 			return -ENOMEM;
+		} else {
+			ret = obj->integer.value;
+			ACPI_FREE(obj);
+		}
 
-		ret = ((union acpi_object *)output.pointer)->integer.value;
 		if (ret > 0 && ret < ARRAY_SIZE(info))
 			str += scnprintf(str, PAGE_SIZE, "%d %d: %s\n",
 					 i, ret, info[ret]);
-		kfree(output.pointer);
-		output.length = ACPI_ALLOCATE_BUFFER;
-		output.pointer = NULL;
 	}
+
 	return str - buf;
 }
 
@@ -453,6 +332,13 @@ static struct attribute_group ppi_attr_grp = {
 
 int tpm_add_ppi(struct kobject *parent)
 {
+	/* Cache TPM ACPI handle and version string */
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
+			    ppi_callback, NULL,
+			    tpm_device_name, &tpm_ppi_handle);
+	if (tpm_ppi_handle == NULL)
+		return -ENODEV;
+
 	return sysfs_create_group(parent, &ppi_attr_grp);
 }
 
-- 
1.7.10.4

