Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3LRG6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:58:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:47099 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab3LRG6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:58:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,506,1384329600"; 
   d="scan'208";a="328666909"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        Ashley Lai <ashley@ashleylai.com>, Peter Huewe <peterhuewe@gmx.de>,
        Rajiv Andrade <mail@srajiv.net>, Marcel Selhorst <tpmdd@selhorst.net>,
        Sirrix AG <tpmdd@sirrix.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Jiri Kosina <jkosina@suse.cz>,
        Ben Skeggs <bskeggs@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Dave Airlie <airlied@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>
Subject: [RFC Patch v1 13/13] ACPI, nouveau: replace open-coded _DSM specific code with helper functions
Date: Wed, 18 Dec 2013 14:58:21 +0800
Message-Id: <1387349901-3391-14-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
References: <1387349901-3391-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper functions to simplify _DSM related code in nouveau driver.
After analyzing the ACPI _DSM related code, I changed nouveau_optimus_dsm()
to expect a buffer and nouveau_dsm() to expect an integer only.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |   48 +++-----
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |  139 +++++++-----------------
 2 files changed, 54 insertions(+), 133 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
index 1291204..13c5af8 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
@@ -87,55 +87,39 @@ mxm_shadow_dsm(struct nouveau_mxm *mxm, u8 version)
 		0xB8, 0x9C, 0x79, 0xB6, 0x2F, 0xD5, 0x56, 0x65
 	};
 	u32 mxms_args[] = { 0x00000000 };
-	union acpi_object args[4] = {
-		/* _DSM MUID */
-		{ .buffer.type = 3,
-		  .buffer.length = sizeof(muid),
-		  .buffer.pointer = muid,
-		},
-		/* spec says this can be zero to mean "highest revision", but
-		 * of course there's at least one bios out there which fails
-		 * unless you pass in exactly the version it supports..
-		 */
-		{ .integer.type = ACPI_TYPE_INTEGER,
-		  .integer.value = (version & 0xf0) << 4 | (version & 0x0f),
-		},
-		/* MXMS function */
-		{ .integer.type = ACPI_TYPE_INTEGER,
-		  .integer.value = 0x00000010,
-		},
-		/* Pointer to MXMS arguments */
-		{ .buffer.type = ACPI_TYPE_BUFFER,
-		  .buffer.length = sizeof(mxms_args),
-		  .buffer.pointer = (char *)mxms_args,
-		},
+	union acpi_object argv4 = {
+		.buffer.type = ACPI_TYPE_BUFFER,
+		.buffer.length = sizeof(mxms_args),
+		.buffer.pointer = (char *)mxms_args,
 	};
-	struct acpi_object_list list = { ARRAY_SIZE(args), args };
-	struct acpi_buffer retn = { ACPI_ALLOCATE_BUFFER, NULL };
 	union acpi_object *obj;
 	acpi_handle handle;
-	int ret;
+	int rev;
 
 	handle = ACPI_HANDLE(&device->pdev->dev);
 	if (!handle)
 		return false;
 
-	ret = acpi_evaluate_object(handle, "_DSM", &list, &retn);
-	if (ret) {
-		nv_debug(mxm, "DSM MXMS failed: %d\n", ret);
+	/*
+	 * spec says this can be zero to mean "highest revision", but
+	 * of course there's at least one bios out there which fails
+	 * unless you pass in exactly the version it supports..
+	 */
+	rev = (version & 0xf0) << 4 | (version & 0x0f);
+	obj = acpi_evaluate_dsm(handle, muid, rev, 0x00000010, &argv4);
+	if (!obj) {
+		nv_debug(mxm, "DSM MXMS failed\n");
 		return false;
 	}
 
-	obj = retn.pointer;
 	if (obj->type == ACPI_TYPE_BUFFER) {
 		mxm->mxms = kmemdup(obj->buffer.pointer,
 					 obj->buffer.length, GFP_KERNEL);
-	} else
-	if (obj->type == ACPI_TYPE_INTEGER) {
+	} else if (obj->type == ACPI_TYPE_INTEGER) {
 		nv_debug(mxm, "DSM MXMS returned 0x%llx\n", obj->integer.value);
 	}
 
-	kfree(obj);
+	ACPI_FREE(obj);
 	return mxm->mxms != NULL;
 }
 #endif
diff --git a/drivers/gpu/drm/nouveau/nouveau_acpi.c b/drivers/gpu/drm/nouveau/nouveau_acpi.c
index 03d4911..7ac7234 100644
--- a/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ b/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -77,127 +77,66 @@ static const char nouveau_op_dsm_muid[] = {
 
 static int nouveau_optimus_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
 {
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_object_list input;
-	union acpi_object params[4];
+	int i;
 	union acpi_object *obj;
-	int i, err;
 	char args_buff[4];
+	union acpi_object argv4 = {
+		.type = ACPI_TYPE_BUFFER,
+		.buffer.length = 4,
+		.buffer.pointer = args_buff
+	};
 
-	input.count = 4;
-	input.pointer = params;
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = sizeof(nouveau_op_dsm_muid);
-	params[0].buffer.pointer = (char *)nouveau_op_dsm_muid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = 0x00000100;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = func;
-	params[3].type = ACPI_TYPE_BUFFER;
-	params[3].buffer.length = 4;
 	/* ACPI is little endian, AABBCCDD becomes {DD,CC,BB,AA} */
 	for (i = 0; i < 4; i++)
 		args_buff[i] = (arg >> i * 8) & 0xFF;
-	params[3].buffer.pointer = args_buff;
 
-	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (err) {
-		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
-		return err;
-	}
-
-	obj = (union acpi_object *)output.pointer;
-
-	if (obj->type == ACPI_TYPE_INTEGER)
-		if (obj->integer.value == 0x80000002) {
-			kfree(output.pointer);
-			return -ENODEV;
-		}
-
-	if (obj->type == ACPI_TYPE_BUFFER) {
-		if (obj->buffer.length == 4 && result) {
-			*result = 0;
+	*result = 0;
+	obj = acpi_evaluate_dsm_typed(handle, nouveau_op_dsm_muid, 0x00000100,
+				      func, &argv4, ACPI_TYPE_BUFFER);
+	if (!obj) {
+		acpi_handle_info(handle, "failed to evaluate _DSM\n");
+		return AE_ERROR;
+	} else {
+		if (obj->buffer.length == 4) {
 			*result |= obj->buffer.pointer[0];
 			*result |= (obj->buffer.pointer[1] << 8);
 			*result |= (obj->buffer.pointer[2] << 16);
 			*result |= (obj->buffer.pointer[3] << 24);
 		}
+		ACPI_FREE(obj);
 	}
 
-	kfree(output.pointer);
 	return 0;
 }
 
-static int nouveau_dsm(acpi_handle handle, int func, int arg, uint32_t *result)
+static int nouveau_dsm(acpi_handle handle, int func, int arg)
 {
-	struct acpi_buffer output = { ACPI_ALLOCATE_BUFFER, NULL };
-	struct acpi_object_list input;
-	union acpi_object params[4];
+	int ret = 0;
 	union acpi_object *obj;
-	int err;
-
-	input.count = 4;
-	input.pointer = params;
-	params[0].type = ACPI_TYPE_BUFFER;
-	params[0].buffer.length = sizeof(nouveau_dsm_muid);
-	params[0].buffer.pointer = (char *)nouveau_dsm_muid;
-	params[1].type = ACPI_TYPE_INTEGER;
-	params[1].integer.value = 0x00000102;
-	params[2].type = ACPI_TYPE_INTEGER;
-	params[2].integer.value = func;
-	params[3].type = ACPI_TYPE_INTEGER;
-	params[3].integer.value = arg;
-
-	err = acpi_evaluate_object(handle, "_DSM", &input, &output);
-	if (err) {
-		printk(KERN_INFO "failed to evaluate _DSM: %d\n", err);
-		return err;
-	}
-
-	obj = (union acpi_object *)output.pointer;
-
-	if (obj->type == ACPI_TYPE_INTEGER)
-		if (obj->integer.value == 0x80000002) {
-			kfree(output.pointer);
-			return -ENODEV;
-		}
-
-	if (obj->type == ACPI_TYPE_BUFFER) {
-		if (obj->buffer.length == 4 && result) {
-			*result = 0;
-			*result |= obj->buffer.pointer[0];
-			*result |= (obj->buffer.pointer[1] << 8);
-			*result |= (obj->buffer.pointer[2] << 16);
-			*result |= (obj->buffer.pointer[3] << 24);
-		}
+	union acpi_object argv4 = {
+		.type = ACPI_TYPE_INTEGER,
+		.integer.value = arg,
+	};
+
+	obj = acpi_evaluate_dsm_typed(handle, nouveau_dsm_muid, 0x00000102,
+				      func, &argv4, ACPI_TYPE_INTEGER);
+	if (!obj) {
+		acpi_handle_info(handle, "failed to evaluate _DSM\n");
+		return AE_ERROR;
+	} else {
+		if (obj->integer.value == 0x80000002)
+			ret = -ENODEV;
+		ACPI_FREE(obj);
 	}
 
-	kfree(output.pointer);
-	return 0;
-}
-
-/* Returns 1 if a DSM function is usable and 0 otherwise */
-static int nouveau_test_dsm(acpi_handle test_handle,
-	int (*dsm_func)(acpi_handle, int, int, uint32_t *),
-	int sfnc)
-{
-	u32 result = 0;
-
-	/* Function 0 returns a Buffer containing available functions. The args
-	 * parameter is ignored for function 0, so just put 0 in it */
-	if (dsm_func(test_handle, 0, 0, &result))
-		return 0;
-
-	/* ACPI Spec v4 9.14.1: if bit 0 is zero, no function is supported. If
-	 * the n-th bit is enabled, function n is supported */
-	return result & 1 && result & (1 << sfnc);
+	return ret;
 }
 
 static int nouveau_dsm_switch_mux(acpi_handle handle, int mux_id)
 {
 	mxm_wmi_call_mxmx(mux_id == NOUVEAU_DSM_LED_STAMINA ? MXM_MXDS_ADAPTER_IGD : MXM_MXDS_ADAPTER_0);
 	mxm_wmi_call_mxds(mux_id == NOUVEAU_DSM_LED_STAMINA ? MXM_MXDS_ADAPTER_IGD : MXM_MXDS_ADAPTER_0);
-	return nouveau_dsm(handle, NOUVEAU_DSM_LED, mux_id, NULL);
+	return nouveau_dsm(handle, NOUVEAU_DSM_LED, mux_id);
 }
 
 static int nouveau_dsm_set_discrete_state(acpi_handle handle, enum vga_switcheroo_state state)
@@ -207,7 +146,7 @@ static int nouveau_dsm_set_discrete_state(acpi_handle handle, enum vga_switchero
 		arg = NOUVEAU_DSM_POWER_SPEED;
 	else
 		arg = NOUVEAU_DSM_POWER_STAMINA;
-	nouveau_dsm(handle, NOUVEAU_DSM_POWER, arg, NULL);
+	nouveau_dsm(handle, NOUVEAU_DSM_POWER, arg);
 	return 0;
 }
 
@@ -263,14 +202,12 @@ static int nouveau_dsm_pci_probe(struct pci_dev *pdev)
 	if (!dhandle)
 		return false;
 
-	if (!acpi_has_method(dhandle, "_DSM"))
-		return false;
-
-	if (nouveau_test_dsm(dhandle, nouveau_dsm, NOUVEAU_DSM_POWER))
+	if (acpi_check_dsm(dhandle, nouveau_dsm_muid, 0x00000102,
+			   1 << NOUVEAU_DSM_POWER))
 		retval |= NOUVEAU_DSM_HAS_MUX;
 
-	if (nouveau_test_dsm(dhandle, nouveau_optimus_dsm,
-		NOUVEAU_DSM_OPTIMUS_CAPS))
+	if (acpi_check_dsm(dhandle, nouveau_op_dsm_muid, 0x00000100,
+			   1 << NOUVEAU_DSM_OPTIMUS_CAPS))
 		retval |= NOUVEAU_DSM_HAS_OPT;
 
 	if (retval & NOUVEAU_DSM_HAS_OPT) {
-- 
1.7.10.4

