Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaAQBa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:30:26 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:18544 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbaAQBaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:30:20 -0500
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
Subject: [PATCH v2] ACPI: Fix acpi_evaluate_object() return value check
Date: Fri, 17 Jan 2014 09:29:51 +0800
Message-ID: <1389922191-28664-1-git-send-email-wangyijing@huawei.com>
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

v1->v2: Add CC to the related subsystem MAINTAINERS.

---
 drivers/gpu/drm/i915/intel_acpi.c              |   13 +++++++------
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |    6 +++---
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |   13 +++++++------
 drivers/pci/pci-label.c                        |    6 +++---
 4 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_acpi.c b/drivers/gpu/drm/i915/intel_acpi.c
index dfff090..7ea00e5 100644
--- a/drivers/gpu/drm/i915/intel_acpi.c
+++ b/drivers/gpu/drm/i915/intel_acpi.c
@@ -35,7 +35,7 @@ static int intel_dsm(acpi_handle handle, int func)
 	union acpi_object params[4];
 	union acpi_object *obj;
 	u32 result;
-	int ret = 0;
+	acpi_status status;
 
 	input.count = 4;
 	input.pointer = params;
@@ -50,8 +50,8 @@ static int intel_dsm(acpi_handle handle, int func)
 	params[3].package.count = 0;
 	params[3].package.elements = NULL;
 
-	ret = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (ret) {
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status)) {
 		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
 		return ret;
 	}
@@ -141,7 +141,8 @@ static void intel_dsm_platform_mux_info(void)
 	struct acpi_object_list input;
 	union acpi_object params[4];
 	union acpi_object *pkg;
-	int i, ret;
+	acpi_status status;
+	int i;
 
 	input.count = 4;
 	input.pointer = params;
@@ -156,9 +157,9 @@ static void intel_dsm_platform_mux_info(void)
 	params[3].package.count = 0;
 	params[3].package.elements = NULL;
 
-	ret = acpi_evaluate_object(intel_dsm_priv.dhandle, "_DSM", &input,
+	acpi_status = acpi_evaluate_object(intel_dsm_priv.dhandle, "_DSM", &input,
 				   &output);
-	if (ret) {
+	if (ACPI_FAILURE(status)) {
 		DRM_DEBUG_DRIVER("failed to evaluate _DSM: %d\n", ret);
 		goto out;
 	}
diff --git a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
index 1291204..3920943 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
@@ -114,14 +114,14 @@ mxm_shadow_dsm(struct nouveau_mxm *mxm, u8 version)
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
+	status = acpi_evaluate_object(handle, "_DSM", &list, &retn);
+	if (ACPI_FAILURE(status)) {
 		nv_debug(mxm, "DSM MXMS failed: %d\n", ret);
 		return false;
 	}
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index ba0183f..6f810f2 100644
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
@@ -101,8 +102,8 @@ static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *
 		args_buff[i] = (arg >> i * 8) & 0xFF;
 	params[3].buffer.pointer = args_buff;
 
-	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (err) {
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status)) {
 		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
 		return err;
 	}
@@ -134,7 +135,7 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
 	struct acpi_object_list input;
 	union acpi_object params[4];
 	union acpi_object *obj;
-	int err;
+	acpi_status status;
 
 	input.count = 4;
 	input.pointer = params;
@@ -148,8 +149,8 @@ static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
 	params[3].type = ACPI_TYPE_INTEGER;
 	params[3].integer.value = arg;
 
-	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (err) {
+	status = acpi_evaluate_object(handle, "_DSM", &input, &output);
+	if (ACPI_FAILURE(status)) {
 		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
 		return err;
 	}
diff --git a/drivers/pci/pci-label.c b/drivers/pci/pci-label.c
index d51f45a..3c21f1b 100644
--- a/drivers/pci/pci-label.c
+++ b/drivers/pci/pci-label.c
@@ -213,7 +213,7 @@ dsm_get_label(acpi_handle handle, int func,
 	union acpi_object *obj;
 	int len = 0;
 
-	int err;
+	acpi_status status;
 
 	input.count = 4;
 	input.pointer = params;
@@ -228,8 +228,8 @@ dsm_get_label(acpi_handle handle, int func,
 	params[3].package.count = 0;
 	params[3].package.elements = NULL;
 
-	err = acpi_evaluate_object(handle, "_DSM", &input, output);
-	if (err)
+	status = acpi_evaluate_object(handle, "_DSM", &input, output);
+	if (ACPI_FAILURE(status))
 		return -1;
 
 	obj = (union acpi_object *)output->pointer;
-- 
1.7.1


