Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3LRG6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:58:16 -0500
Received: from mga14.intel.com ([143.182.124.37]:58557 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab3LRG6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:58:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666837"
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
Subject: [RFC Patch v1 09/13] ACPI, TPM: detecting PPI features by checking availability of _DSM functions
Date: Wed, 18 Dec 2013 14:58:17 +0800
Message-Id: <1387349901-3391-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Detecting physical presence interface features by checking availbility
of corresponding ACPI _DSM functions, it should be more accurate than
checking TPM version number.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/char/tpm/tpm_ppi.c |   45 +++++++++++++++++++-------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index ad5143f..272c22d 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -23,39 +23,31 @@ static const u8 tpm_ppi_uuid[] = {
 	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
 };
 
-static char *tpm_device_name = "TPM";
 static char tpm_ppi_version[PPI_VERSION_LEN + 1];
 static acpi_handle tpm_ppi_handle;
 
 static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
 				void **return_value)
 {
-	acpi_status status = AE_OK;
-	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
+	union acpi_object *obj;
 
-	status = acpi_get_name(handle, ACPI_SINGLE_NAME, &buffer);
-	if (ACPI_FAILURE(status))
+	if (!acpi_check_dsm(handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
+			    1 << TPM_PPI_FN_VERSION))
 		return AE_OK;
 
-	if (strstr(buffer.pointer, context) != NULL) {
-		union acpi_object *obj;
-
-		/* Cache version string */
-		obj = acpi_evaluate_dsm_typed(handle, tpm_ppi_uuid,
-				TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
-				NULL, ACPI_TYPE_STRING);
-		if (obj) {
-			strlcpy(tpm_ppi_version, obj->string.pointer,
-				PPI_VERSION_LEN + 1);
-			ACPI_FREE(obj);
-		}
-
-		*return_value = handle;
-		status = AE_CTRL_TERMINATE;
+	/* Cache version string */
+	obj = acpi_evaluate_dsm_typed(handle, tpm_ppi_uuid,
+				      TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
+				      NULL, ACPI_TYPE_STRING);
+	if (obj) {
+		strlcpy(tpm_ppi_version, obj->string.pointer,
+			PPI_VERSION_LEN + 1);
+		ACPI_FREE(obj);
 	}
-	kfree(buffer.pointer);
 
-	return status;
+	*return_value = handle;
+
+	return AE_CTRL_TERMINATE;
 }
 
 static inline union acpi_object *
@@ -118,7 +110,8 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (strcmp(tpm_ppi_version, "1.1") >= 0)
+	if (acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
+			   1 << TPM_PPI_FN_SUBREQ2))
 		func = TPM_PPI_FN_SUBREQ2;
 
 	/*
@@ -272,7 +265,8 @@ static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 		"User not required",
 	};
 
-	if (strcmp(tpm_ppi_version, "1.2") < 0)
+	if (!acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
+			    1 << TPM_PPI_FN_GETOPR))
 		return -EPERM;
 
 	tmp.type = ACPI_TYPE_INTEGER;
@@ -334,8 +328,7 @@ int tpm_add_ppi(struct kobject *parent)
 {
 	/* Cache TPM ACPI handle and version string */
 	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
-			    ppi_callback, NULL,
-			    tpm_device_name, &tpm_ppi_handle);
+			    ppi_callback, NULL, NULL, &tpm_ppi_handle);
 	if (tpm_ppi_handle == NULL)
 		return -ENODEV;
 
-- 
1.7.10.4

