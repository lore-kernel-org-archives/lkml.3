Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab3LSMk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:40:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:40586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755496Ab3LSMkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:40:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,512,1384329600"; 
   d="scan'208";a="427186487"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Robert Moore <robert.moore@intel.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        devel@acpica.org
Subject: [Patch v2 01/13] ACPI: introduce helper interfaces to support ACPI _DSM method
Date: Thu, 19 Dec 2013 20:38:10 +0800
Message-Id: <1387456702-4709-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387456702-4709-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several drivers making use of ACPI _DSM method to detect
and invoke device specific methods. Currently every driver has
implemented its private version to support ACPI _DSM method.
So this patch introduces three helper functions to support ACPI _DSM
method, which will be used to replace open-coded versions.

It helps to simplify code and improve code readability.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>
Cc: Ashley Lai <ashley@ashleylai.com>
Cc: Peter Huewe <peterhuewe@gmx.de>
Cc: Rajiv Andrade <mail@srajiv.net>
Cc: Marcel Selhorst <tpmdd@selhorst.net>
Cc: Sirrix AG <tpmdd@sirrix.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: David Airlie <airlied@linux.ie>
Cc: Jiri Kosina <jkosina@suse.cz>
---
 drivers/acpi/utils.c    |   98 +++++++++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |   26 +++++++++++++
 2 files changed, 124 insertions(+)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 6d408bf..9517b0a 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -574,3 +574,101 @@ acpi_status acpi_evaluate_lck(acpi_handle handle, int lock)
 
 	return status;
 }
+
+/**
+ * acpi_evaluate_dsm: evaluate device's _DSM method
+ * @handle: ACPI device handle
+ * @uuid: UUID of requested functions, should be 16 bytes
+ * @rev: revision number of requested function
+ * @func: requested function number
+ * @argv4: the function specific parameter
+ *
+ * Evaluate device's _DSM method with specified UUID, revision id and
+ * function number. Caller needs to free the returned object.
+ *
+ * Though ACPI defines the fourth parameter for _DSM should be a package,
+ * some old BIOSes do expect a buffer or an integer etc.
+ */
+union acpi_object *
+acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid, int rev, int func,
+		  union acpi_object *argv4)
+{
+	acpi_status ret;
+	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
+	union acpi_object params[4];
+	struct acpi_object_list input = {
+		.count = 4,
+		.pointer = params,
+	};
+
+	params[0].type = ACPI_TYPE_BUFFER;
+	params[0].buffer.length = 16;
+	params[0].buffer.pointer = (char *)uuid;
+	params[1].type = ACPI_TYPE_INTEGER;
+	params[1].integer.value = rev;
+	params[2].type = ACPI_TYPE_INTEGER;
+	params[2].integer.value = func;
+	if (argv4) {
+		params[3] = *argv4;
+	} else {
+		params[3].type = ACPI_TYPE_PACKAGE;
+		params[3].package.count = 0;
+		params[3].package.elements = NULL;
+	}
+
+	ret = acpi_evaluate_object(handle, "_DSM", &input, &buf);
+	if (ACPI_SUCCESS(ret))
+		return (union acpi_object *)buf.pointer;
+
+	if (ret != AE_NOT_FOUND)
+		acpi_handle_warn(handle,
+				"failed to evaluate _DSM method (0x%x)\n", ret);
+
+	return NULL;
+}
+EXPORT_SYMBOL(acpi_evaluate_dsm);
+
+/**
+ * acpi_check_dsm: check whether _DSM method under @handle supports
+ *		   requested functions.
+ * @handle: ACPI device handle
+ * @uuid: UUID of requested functions, should be 16 bytes at least
+ * @rev: revision number of requested functions
+ * @funcs: bitmap of requested functions
+ * @exclude: excluding special value, used to support i915 and nouveau
+ *
+ * Evaluate device's _DSM method to check whether it supports requested
+ * functions. Currently only support 64 functions at maximum, should be
+ * enough for now.
+ */
+bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, int rev, u64 funcs)
+{
+	int i;
+	u64 mask = 0;
+	union acpi_object *obj;
+
+	if (funcs == 0)
+		return false;
+
+	obj = acpi_evaluate_dsm(handle, uuid, rev, 0, NULL);
+	if (!obj)
+		return false;
+
+	/* For compatibility, old BIOSes may return an integer */
+	if (obj->type == ACPI_TYPE_INTEGER)
+		mask = obj->integer.value;
+	else if (obj->type == ACPI_TYPE_BUFFER)
+		for (i = 0; i < obj->buffer.length && i < 8; i++)
+			mask |= (((u8)obj->buffer.pointer[i]) << (i * 8));
+	ACPI_FREE(obj);
+
+	/*
+	 * Bit 0 indicates whether there's support for any functions other than
+	 * function 0 for the specified UUID and revision.
+	 */
+	if ((mask & 0x1) && (mask & funcs) == funcs)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(acpi_check_dsm);
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c602c77..6db129b 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -66,6 +66,32 @@ bool acpi_ata_match(acpi_handle handle);
 bool acpi_bay_match(acpi_handle handle);
 bool acpi_dock_match(acpi_handle handle);
 
+bool acpi_check_dsm(acpi_handle handle, const u8 *uuid, int rev, u64 funcs);
+union acpi_object *acpi_evaluate_dsm(acpi_handle handle, const u8 *uuid,
+			int rev, int func, union acpi_object *argv4);
+
+static inline union acpi_object *
+acpi_evaluate_dsm_typed(acpi_handle handle, const u8 *uuid, int rev, int func,
+			union acpi_object *argv4, acpi_object_type type)
+{
+	union acpi_object *obj;
+
+	obj = acpi_evaluate_dsm(handle, uuid, rev, func, argv4);
+	if (obj && obj->type != type) {
+		ACPI_FREE(obj);
+		obj = NULL;
+	}
+
+	return obj;
+}
+
+#define	ACPI_INIT_DSM_ARGV4(cnt, eles)			\
+	{						\
+	  .package.type = ACPI_TYPE_PACKAGE,		\
+	  .package.count = (cnt),			\
+	  .package.elements = (eles)			\
+	}
+
 #ifdef CONFIG_ACPI
 
 #include <linux/proc_fs.h>
-- 
1.7.10.4

