Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab3LRG6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:58:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:59267 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3LRG6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:58:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666868"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 11/13] ACPI, i915: replace open-coded _DSM specific code with helper functions
Date: Wed, 18 Dec 2013 14:58:19 +0800
Message-Id: <1387349901-3391-12-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper functions to simplify _DSM related code in i915 driver.

Function intel_dsm() is used to check functions supported by ACPI _DSM
method, but it has strange check for special value 0x80000002. After
digging into nouveau driver, I think the check is copied from nouveau
driver and is useless for i915 driver, so remove it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_acpi.c |  144 ++++++++-----------------------------
 1 file changed, 30 insertions(+), 114 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
index dfff090..1bfac94 100644
--- a/drivers/gpu/drm/i915/intel_acpi.c
+++ b/drivers/gpu/drm/i915/intel_acpi.c
@@ -12,8 +12,6 @@
 #include "i915_drv.h"
 
 #define INTEL_DSM_REVISION_ID 1 /* For Calpella anyway... */
-
-#define INTEL_DSM_FN_SUPPORTED_FUNCTIONS 0 /* No args */
 #define INTEL_DSM_FN_PLATFORM_MUX_INFO 1 /* No args */
 
 static struct intel_dsm_priv {
@@ -28,61 +26,6 @@ static const u8 intel_dsm_guid[] = {
 	0x0f, 0x13, 0x17, 0xb0, 0x1c, 0x2c
 };
 
-static int intel_dsm(acpi_handle handle, int func)
-{
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_object_list input;
-	union acpi_object params[4];
-	union acpi_object *obj;
-	u32 result;
-	int ret = 0;
-
-	input.count = 4;
-	input.pointer = params;
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = sizeof(intel_dsm_guid);
-	params[0].buffer.pointer = (char *)intel_dsm_guid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = INTEL_DSM_REVISION_ID;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = func;
-	params[3].type = ACPI_TYPE_PACKAGE;
-	params[3].package.count = 0;
-	params[3].package.elements = NULL;
-
-	ret = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (ret) {
-		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
-		return ret;
-	}
-
-	obj = (union acpi_object *)output.pointer;
-
-	result = 0;
-	switch (obj->type) {
-	case ACPI_TYPE_INTEGER:
-		result = obj->integer.value;
-		break;
-
-	case ACPI_TYPE_BUFFER:
-		if (obj->buffer.length == 4) {
-			result = (obj->buffer.pointer[0] |
-				(obj->buffer.pointer[1] <<  8) |
-				(obj->buffer.pointer[2] << 16) |
-				(obj->buffer.pointer[3] << 24));
-			break;
-		}
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	if (result == 0x80000002)
-		ret = -ENODEV;
-
-	kfree(output.pointer);
-	return ret;
-}
-
 static char *intel_dsm_port_name(u8 id)
 {
 	switch (id) {
@@ -137,83 +80,56 @@ static char *intel_dsm_mux_type(u8 type)
 
 static void intel_dsm_platform_mux_info(void)
 {
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_object_list input;
-	union acpi_object params[4];
-	union acpi_object *pkg;
-	int i, ret;
-
-	input.count = 4;
-	input.pointer = params;
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = sizeof(intel_dsm_guid);
-	params[0].buffer.pointer = (char *)intel_dsm_guid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = INTEL_DSM_REVISION_ID;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = INTEL_DSM_FN_PLATFORM_MUX_INFO;
-	params[3].type = ACPI_TYPE_PACKAGE;
-	params[3].package.count = 0;
-	params[3].package.elements = NULL;
-
-	ret = acpi_evaluate_object(intel_dsm_priv.dhandle, "_DSM", &input,
-				   &output);
-	if (ret) {
-		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
-		goto out;
+	int i;
+	union acpi_object *pkg, *connector_count;
+
+	pkg = acpi_evaluate_dsm_typed(intel_dsm_priv.dhandle, intel_dsm_guid,
+			INTEL_DSM_REVISION_ID, INTEL_DSM_FN_PLATFORM_MUX_INFO,
+			NULL, ACPI_TYPE_PACKAGE);
+	if (!pkg) {
+		DRM_DEBUG_DRIVER("failed to evaluate _DSM\n");
+		return;
 	}
 
-	pkg = (union acpi_object *)output.pointer;
-
-	if (pkg->type == ACPI_TYPE_PACKAGE) {
-		union acpi_object *connector_count = &pkg->package.elements[0];
-		DRM_DEBUG_DRIVER("MUX info connectors: %lld\n",
-			  (unsigned long long)connector_count->integer.value);
-		for (i = 1; i < pkg->package.count; i++) {
-			union acpi_object *obj = &pkg->package.elements[i];
-			union acpi_object *connector_id =
-				&obj->package.elements[0];
-			union acpi_object *info = &obj->package.elements[1];
-			DRM_DEBUG_DRIVER("Connector id: 0x%016llx\n",
-				  (unsigned long long)connector_id->integer.value);
-			DRM_DEBUG_DRIVER("  port id: %s\n",
-			       intel_dsm_port_name(info->buffer.pointer[0]));
-			DRM_DEBUG_DRIVER("  display mux info: %s\n",
-			       intel_dsm_mux_type(info->buffer.pointer[1]));
-			DRM_DEBUG_DRIVER("  aux/dc mux info: %s\n",
-			       intel_dsm_mux_type(info->buffer.pointer[2]));
-			DRM_DEBUG_DRIVER("  hpd mux info: %s\n",
-			       intel_dsm_mux_type(info->buffer.pointer[3]));
-		}
+	connector_count = &pkg->package.elements[0];
+	DRM_DEBUG_DRIVER("MUX info connectors: %lld\n",
+		  (unsigned long long)connector_count->integer.value);
+	for (i = 1; i < pkg->package.count; i++) {
+		union acpi_object *obj = &pkg->package.elements[i];
+		union acpi_object *connector_id = &obj->package.elements[0];
+		union acpi_object *info = &obj->package.elements[1];
+		DRM_DEBUG_DRIVER("Connector id: 0x%016llx\n",
+			  (unsigned long long)connector_id->integer.value);
+		DRM_DEBUG_DRIVER("  port id: %s\n",
+		       intel_dsm_port_name(info->buffer.pointer[0]));
+		DRM_DEBUG_DRIVER("  display mux info: %s\n",
+		       intel_dsm_mux_type(info->buffer.pointer[1]));
+		DRM_DEBUG_DRIVER("  aux/dc mux info: %s\n",
+		       intel_dsm_mux_type(info->buffer.pointer[2]));
+		DRM_DEBUG_DRIVER("  hpd mux info: %s\n",
+		       intel_dsm_mux_type(info->buffer.pointer[3]));
 	}
 
-out:
-	kfree(output.pointer);
+	ACPI_FREE(pkg);
 }
 
 static bool intel_dsm_pci_probe(struct pci_dev *pdev)
 {
 	acpi_handle dhandle;
-	int ret;
 
 	dhandle = ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
 
-	if (!acpi_has_method(dhandle, "_DSM")) {
+	if (!acpi_check_dsm(dhandle, intel_dsm_guid, INTEL_DSM_REVISION_ID,
+			    1 << INTEL_DSM_FN_PLATFORM_MUX_INFO)) {
 		DRM_DEBUG_KMS("no _DSM method for intel device\n");
 		return false;
 	}
 
-	ret = intel_dsm(dhandle, INTEL_DSM_FN_SUPPORTED_FUNCTIONS);
-	if (ret < 0) {
-		DRM_DEBUG_KMS("failed to get supported _DSM functions\n");
-		return false;
-	}
-
 	intel_dsm_priv.dhandle = dhandle;
-
 	intel_dsm_platform_mux_info();
+
 	return true;
 }
 
-- 
1.7.10.4

