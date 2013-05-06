Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab3EFXL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:11:57 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43823 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808Ab3EFXLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:11:55 -0400
MIME-Version: 1.0
Date: Mon, 6 May 2013 19:11:53 -0400
Message-ID: <CAOULuOb79h99RiyYpMGLzzM2QeawYfG8CfrvNtk4WtJJxRn87g@mail.gmail.com>
Subject: [PATCH] radeon: Allow disabling UVD
From: Parag Warudkar <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        airlied@linux.ie, alexander.deucher@amd.com, christian.koenig@amd.com
Content-Type: multipart/mixed; boundary=f46d0443048a8f40b704dc14d3ba
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0443048a8f40b704dc14d3ba
Content-Type: text/plain; charset=ISO-8859-1

Apparently UVD doesn't yet work everywhere - so allow it to be
disabled. Shaves off some reboot and suspend/resume time on machines
where it doesn't work. Might be useful for problematic chips in the
future as well.

Patch attached as well as inline below.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 1442ce7..f131d8f 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -79,6 +79,7 @@
  * Modules parameters.
  */
 extern int radeon_no_wb;
+extern int radeon_no_uvd;
 extern int radeon_modeset;
 extern int radeon_dynclks;
 extern int radeon_r4xx_atom;
diff --git a/drivers/gpu/drm/radeon/radeon_drv.c
b/drivers/gpu/drm/radeon/radeon_drv.c
index d33f484..7e5b171 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -147,6 +147,7 @@ static inline void radeon_unregister_atpx_handler(void) {}
 #endif

 int radeon_no_wb;
+int radeon_no_uvd;
 int radeon_modeset = 1;
 int radeon_dynclks = -1;
 int radeon_r4xx_atom = 0;
@@ -168,6 +169,9 @@ int radeon_fastfb = 0;
 MODULE_PARM_DESC(no_wb, "Disable AGP writeback for scratch registers");
 module_param_named(no_wb, radeon_no_wb, int, 0444);

+MODULE_PARM_DESC(no_uvd, "Disable UVD");
+module_param_named(no_uvd, radeon_no_uvd, int, 0444);
+
 MODULE_PARM_DESC(modeset, "Disable/Enable modesetting");
 module_param_named(modeset, radeon_modeset, int, 0400);

diff --git a/drivers/gpu/drm/radeon/radeon_drv.h
b/drivers/gpu/drm/radeon/radeon_drv.h
index b369d42..4320973 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.h
+++ b/drivers/gpu/drm/radeon/radeon_drv.h
@@ -329,6 +329,7 @@ typedef struct drm_radeon_kcmd_buffer {
 } drm_radeon_kcmd_buffer_t;

 extern int radeon_no_wb;
+extern int radeon_no_uvd;
 extern struct drm_ioctl_desc radeon_ioctls[];
 extern int radeon_max_ioctl;

diff --git a/drivers/gpu/drm/radeon/radeon_uvd.c
b/drivers/gpu/drm/radeon/radeon_uvd.c
index 906e5c0..93a7dbb 100644
--- a/drivers/gpu/drm/radeon/radeon_uvd.c
+++ b/drivers/gpu/drm/radeon/radeon_uvd.c
@@ -58,7 +58,8 @@ int radeon_uvd_init(struct radeon_device *rdev)
  unsigned long bo_size;
  const char *fw_name;
  int i, r;
-
+ if (radeon_no_uvd)
+ return -EINVAL;
  INIT_DELAYED_WORK(&rdev->uvd.idle_work, radeon_uvd_idle_work_handler);

  pdev = platform_device_register_simple("radeon_uvd", 0, NULL, 0);

--f46d0443048a8f40b704dc14d3ba
Content-Type: application/octet-stream; name="radeon-option-no-uvd.patch"
Content-Disposition: attachment; filename="radeon-option-no-uvd.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hge9jpa80

U2lnbmVkLW9mZi1ieTogUGFyYWcgV2FydWRrYXIgPHBhcmFnLmxrbWxAZ21haWwuY29tPgoKZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uLmggYi9kcml2ZXJzL2dwdS9k
cm0vcmFkZW9uL3JhZGVvbi5oCmluZGV4IDE0NDJjZTcuLmYxMzFkOGYgMTAwNjQ0Ci0tLSBhL2Ry
aXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uLmgKKysrIGIvZHJpdmVycy9ncHUvZHJtL3JhZGVv
bi9yYWRlb24uaApAQCAtNzksNiArNzksNyBAQAogICogTW9kdWxlcyBwYXJhbWV0ZXJzLgogICov
CiBleHRlcm4gaW50IHJhZGVvbl9ub193YjsKK2V4dGVybiBpbnQgcmFkZW9uX25vX3V2ZDsKIGV4
dGVybiBpbnQgcmFkZW9uX21vZGVzZXQ7CiBleHRlcm4gaW50IHJhZGVvbl9keW5jbGtzOwogZXh0
ZXJuIGludCByYWRlb25fcjR4eF9hdG9tOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL3Jh
ZGVvbi9yYWRlb25fZHJ2LmMgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuYwpp
bmRleCBkMzNmNDg0Li43ZTViMTcxIDEwMDY0NAotLS0gYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JhZGVvbl9kcnYuYworKysgYi9kcml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl9kcnYuYwpA
QCAtMTQ3LDYgKzE0Nyw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCByYWRlb25fdW5yZWdpc3Rlcl9h
dHB4X2hhbmRsZXIodm9pZCkge30KICNlbmRpZgogCiBpbnQgcmFkZW9uX25vX3diOworaW50IHJh
ZGVvbl9ub191dmQ7CiBpbnQgcmFkZW9uX21vZGVzZXQgPSAxOwogaW50IHJhZGVvbl9keW5jbGtz
ID0gLTE7CiBpbnQgcmFkZW9uX3I0eHhfYXRvbSA9IDA7CkBAIC0xNjgsNiArMTY5LDkgQEAgaW50
IHJhZGVvbl9mYXN0ZmIgPSAwOwogTU9EVUxFX1BBUk1fREVTQyhub193YiwgIkRpc2FibGUgQUdQ
IHdyaXRlYmFjayBmb3Igc2NyYXRjaCByZWdpc3RlcnMiKTsKIG1vZHVsZV9wYXJhbV9uYW1lZChu
b193YiwgcmFkZW9uX25vX3diLCBpbnQsIDA0NDQpOwogCitNT0RVTEVfUEFSTV9ERVNDKG5vX3V2
ZCwgIkRpc2FibGUgVVZEIik7Cittb2R1bGVfcGFyYW1fbmFtZWQobm9fdXZkLCByYWRlb25fbm9f
dXZkLCBpbnQsIDA0NDQpOworCiBNT0RVTEVfUEFSTV9ERVNDKG1vZGVzZXQsICJEaXNhYmxlL0Vu
YWJsZSBtb2Rlc2V0dGluZyIpOwogbW9kdWxlX3BhcmFtX25hbWVkKG1vZGVzZXQsIHJhZGVvbl9t
b2Rlc2V0LCBpbnQsIDA0MDApOwogCmRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0vcmFkZW9u
L3JhZGVvbl9kcnYuaCBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Rydi5oCmluZGV4
IGIzNjlkNDIuLjQzMjA5NzMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFk
ZW9uX2Rydi5oCisrKyBiL2RyaXZlcnMvZ3B1L2RybS9yYWRlb24vcmFkZW9uX2Rydi5oCkBAIC0z
MjksNiArMzI5LDcgQEAgdHlwZWRlZiBzdHJ1Y3QgZHJtX3JhZGVvbl9rY21kX2J1ZmZlciB7CiB9
IGRybV9yYWRlb25fa2NtZF9idWZmZXJfdDsKIAogZXh0ZXJuIGludCByYWRlb25fbm9fd2I7Citl
eHRlcm4gaW50IHJhZGVvbl9ub191dmQ7CiBleHRlcm4gc3RydWN0IGRybV9pb2N0bF9kZXNjIHJh
ZGVvbl9pb2N0bHNbXTsKIGV4dGVybiBpbnQgcmFkZW9uX21heF9pb2N0bDsKIApkaWZmIC0tZ2l0
IGEvZHJpdmVycy9ncHUvZHJtL3JhZGVvbi9yYWRlb25fdXZkLmMgYi9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL3JhZGVvbl91dmQuYwppbmRleCA5MDZlNWMwLi45M2E3ZGJiIDEwMDY0NAotLS0gYS9k
cml2ZXJzL2dwdS9kcm0vcmFkZW9uL3JhZGVvbl91dmQuYworKysgYi9kcml2ZXJzL2dwdS9kcm0v
cmFkZW9uL3JhZGVvbl91dmQuYwpAQCAtNTgsNyArNTgsOCBAQCBpbnQgcmFkZW9uX3V2ZF9pbml0
KHN0cnVjdCByYWRlb25fZGV2aWNlICpyZGV2KQogCXVuc2lnbmVkIGxvbmcgYm9fc2l6ZTsKIAlj
b25zdCBjaGFyICpmd19uYW1lOwogCWludCBpLCByOwotCisJaWYgKHJhZGVvbl9ub191dmQpCisJ
CXJldHVybiAtRUlOVkFMOwogCUlOSVRfREVMQVlFRF9XT1JLKCZyZGV2LT51dmQuaWRsZV93b3Jr
LCByYWRlb25fdXZkX2lkbGVfd29ya19oYW5kbGVyKTsKIAogCXBkZXYgPSBwbGF0Zm9ybV9kZXZp
Y2VfcmVnaXN0ZXJfc2ltcGxlKCJyYWRlb25fdXZkIiwgMCwgTlVMTCwgMCk7Cg==
--f46d0443048a8f40b704dc14d3ba--
