Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885AbaAQEWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 23:22:19 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:33066 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaAQEWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 23:22:16 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
CC: <linux-acpi@vger.kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, Bjorn Helgaas <bhelgaas@google.com>,
        <intel-gfx@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dave Airlie <airlied@redhat.com>, Yijing Wang <wangyijing@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH v3] ACPI: Fix acpi_evaluate_object() return value check
Date: Fri, 17 Jan 2014 12:21:53 +0800
Message-ID: <1389932513-27684-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix acpi_evaluate_object() return value check,
shoud acpi_status not int.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
v2->v3: Fix compile error pointed out by Hanjun.
v1->v2: Add CC to related subsystem MAINTAINERS
---
 drivers/gpu/drm/i915/intel_acpi.c              |   24 ++++++++++++++----------
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |    9 +++++----
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |   23 +++++++++++++----------
 drivers/pci/pci-label.c                        |    9 ++++++---
 4 files changed, 38 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
index dfff090..87e8f74 100644
--- a/drivers/gpu/drm/i915/intel_acpi.c
+++ b/drivers/gpu/drm/i915/intel_acpi.c
@@ -35,7 +35,8 @@ static int intel_dsm(acpi_handle handle, int func)
 	union acpi_object params[4];
 	union acpi_object *obj;
 	u32 result;
-	int ret = 0;
+	acpi_status status;
+	int ret;
 
 	input.count = 4;
 	input.pointer = params;
@@ -50,10 +51,11 @@ static int intel_dsm(acpi_handle handle, int func)
 	params[3].package.count = 0;
 	params[3].package.elements = NULL;
 
-	ret = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (ret) {
-		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
-		return ret;
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status)) {
+		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %s\n",
+				acpi_format_exception(status));
+		return -EINVAL;
 	}
 
 	obj = (union acpi_object *)output.pointer;
@@ -141,7 +143,8 @@ static void intel_dsm_platform_mux_info(void)
 	struct acpi_object_list input;
 	union acpi_object params[4];
 	union acpi_object *pkg;
-	int i, ret;
+	acpi_status status;
+	int i;
 
 	input.count = 4;
 	input.pointer = params;
@@ -156,10 +159,11 @@ static void intel_dsm_platform_mux_info(void)
 	params[3].package.count = 0;
 	params[3].package.elements = NULL;
 
-	ret = acpi_evaluate_object(intel_dsm_priv.dhandle, "_DSM", &input,
-				   &output);
-	if (ret) {
-		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
+	acpi_status = acpi_evaluate_object(intel_dsm_priv.dhandle,
+			"_DSM", &input, &output);
+	if (ACPI_FAILURE(status)) {
+		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %s\n",
+				acpi_format_exception(status));
 		goto out;
 	}
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
index 1291204..c5e7a2b 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
@@ -114,15 +114,16 @@ mxm_shadow_dsm(struct nouveau_mxm *mxm, u8 version)
 	struct acpi_buffer retn = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	acpi_handle handle;
-	int ret;
+	acpi_status status;
 
 	handle = ACPI_HANDLE(&device->pdev->dev);
 	if (!handle)
 		return false;
 
-	ret = acpi_evaluate_object(handle, "_DSM", &list, &retn);
-	if (ret) {
-		nv_debug(mxm, "DSM MXMS failed: %d\n", ret);
+	status = acpi_evaluate_object(handle, "_DSM", &list, &retn);
+	if (ACPI_FAILURE(status)) {
+		nv_debug(mxm, "DSM MXMS failed: %s\n",
+				acpi_format_exception(status));
 		return false;
 	}
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index ba0183f..de3068b 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -82,7 +82,8 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
 	struct acpi_object_list input;
 	union acpi_object params[4];
 	union acpi_object *obj;
-	int i, err;
+	acpi_status status;
+	int i;
 	char args_buff[4];
 
 	input.count = 4;
@@ -101,10 +102,11 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
 		args_buff[i] = (arg >> i * 8) & 0xFF;
 	params[3].buffer.pointer = args_buff;
 
-	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (err) {
-		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
-		return err;
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status)) {
+		pr_info("failed to evaluate _DSM: %s\n",
+				acpi_format_exception(status));
+		return -EINVAL;
 	}
 
 	obj = (union acpi_object *)output.pointer;
@@ -134,7 +136,7 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
 	struct acpi_object_list input;
 	union acpi_object params[4];
 	union acpi_object *obj;
-	int err;
+	acpi_status status;
 
 	input.count = 4;
 	input.pointer = params;
@@ -148,10 +150,11 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
 	params[3].type = ACPI_TYPE_INTEGER;
 	params[3].integer.value = arg;
 
-	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (err) {
-		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
-		return err;
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status)) {
+		pr_info("failed to evaluate _DSM: %s\n",
+				acpi_format_exception(status));
+		return -EINVAL;
 	}
 
 	obj = (union acpi_object *)output.pointer;
diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index d51f45a..7ba4de6 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -213,7 +213,7 @@ dsm_get_label(acpi_handle handle, int func,
 	union acpi_object *obj;
 	int len = 0;
 
-	int err;
+	acpi_status status;
 
 	input.count = 4;
 	input.pointer = params;
@@ -228,9 +228,12 @@ dsm_get_label(acpi_handle handle, int func,
 	params[3].package.count = 0;
 	params[3].package.elements = NULL;
 
-	err = acpi_evaluate_object(handle, "_DSM", &input, output);
-	if (err)
+	status = acpi_evaluate_object(handle, "_DSM", &input, output);
+	if (ACPI_FAILURE(status)) {
+		pr_info("failed to evaluate _DSM: %s\n",
+				acpi_format_exception(status));
 		return -1;
+	}
 
 	obj = (union acpi_object *)output->pointer;
 
-- 
1.7.1


