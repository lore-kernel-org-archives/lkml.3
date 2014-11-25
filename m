Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaKYKmG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:42:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58596 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbaKYKl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Emil Velikov <emil.l.velikov@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 120/254] drm/nouveau/gpio: rename g92 class to g94
Date: Tue, 25 Nov 2014 10:37:50 +0000
Message-Id: <1416912004-5928-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emil Velikov <emil.l.velikov@gmail.com>

commit b485a7005faba38286bc02ab1d80e2cbf61c1002 upstream.

nv92 hardware has only 16 interrupt lines, while nv94 and later
has 32. Accessing 0xe0c{0,4} registers on nv92 can lead to incorrect
PDISP setup. This is a regression introduced with

commit 9d0f5ec9ee0fd5dc5fc1cc2cf559286431e406e3
Author: Ben Skeggs <bskeggs@redhat.com>
Date:   Mon May 12 15:22:42 2014 +1000

    gpio: split g92 class from nv50

Reported-by: estece on #nouveau
Signed-off-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/Makefile                   |  2 +-
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  | 22 +++----
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  | 14 ++--
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |  2 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c    | 74 ----------------------
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c    | 74 ++++++++++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |  4 +-
 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h    |  4 +-
 8 files changed, 98 insertions(+), 98 deletions(-)
 delete mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index 8b307e143632..f850f380165f 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -125,7 +125,7 @@ nouveau-y += core/subdev/fb/gddr5.o
 nouveau-y += core/subdev/gpio/base.o
 nouveau-y += core/subdev/gpio/nv10.o
 nouveau-y += core/subdev/gpio/nv50.o
-nouveau-y += core/subdev/gpio/nv92.o
+nouveau-y += core/subdev/gpio/nv94.o
 nouveau-y += core/subdev/gpio/nvd0.o
 nouveau-y += core/subdev/gpio/nve0.o
 nouveau-y += core/subdev/i2c/base.o
diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nv50.c b/drivers/gpu/drm/nouveau/core/engine/device/nv50.c
index ef0b0bde1a91..354c8cf61093 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/nv50.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nv50.c
@@ -141,7 +141,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0x92:
 		device->cname = "G92";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv50_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv50_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] =  nv84_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nv84_therm_oclass;
@@ -169,7 +169,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0x94:
 		device->cname = "G94";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] =  nv84_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nv84_therm_oclass;
@@ -197,7 +197,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0x96:
 		device->cname = "G96";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] =  nv84_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nv84_therm_oclass;
@@ -225,7 +225,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0x98:
 		device->cname = "G98";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] =  nv84_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nv84_therm_oclass;
@@ -253,7 +253,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0xa0:
 		device->cname = "G200";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv50_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] =  nv84_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nv84_therm_oclass;
@@ -281,7 +281,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0xaa:
 		device->cname = "MCP77/MCP78";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] =  nvaa_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nv84_therm_oclass;
@@ -309,7 +309,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0xac:
 		device->cname = "MCP79/MCP7A";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] =  nvaa_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nv84_therm_oclass;
@@ -337,7 +337,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0xa3:
 		device->cname = "GT215";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nva3_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -367,7 +367,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0xa5:
 		device->cname = "GT216";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nva3_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -396,7 +396,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0xa8:
 		device->cname = "GT218";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nva3_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -425,7 +425,7 @@ nv50_identify(struct nouveau_device *device)
 	case 0xaf:
 		device->cname = "MCP89";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nva3_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
index 8d55ed633b19..01e5e5545de2 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
@@ -60,7 +60,7 @@ nvc0_identify(struct nouveau_device *device)
 	case 0xc0:
 		device->cname = "GF100";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -92,7 +92,7 @@ nvc0_identify(struct nouveau_device *device)
 	case 0xc4:
 		device->cname = "GF104";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -124,7 +124,7 @@ nvc0_identify(struct nouveau_device *device)
 	case 0xc3:
 		device->cname = "GF106";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -155,7 +155,7 @@ nvc0_identify(struct nouveau_device *device)
 	case 0xce:
 		device->cname = "GF114";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -187,7 +187,7 @@ nvc0_identify(struct nouveau_device *device)
 	case 0xcf:
 		device->cname = "GF116";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -219,7 +219,7 @@ nvc0_identify(struct nouveau_device *device)
 	case 0xc1:
 		device->cname = "GF108";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
@@ -250,7 +250,7 @@ nvc0_identify(struct nouveau_device *device)
 	case 0xc8:
 		device->cname = "GF110";
 		device->oclass[NVDEV_SUBDEV_VBIOS  ] = &nouveau_bios_oclass;
-		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv92_gpio_oclass;
+		device->oclass[NVDEV_SUBDEV_GPIO   ] =  nv94_gpio_oclass;
 		device->oclass[NVDEV_SUBDEV_I2C    ] =  nv94_i2c_oclass;
 		device->oclass[NVDEV_SUBDEV_CLOCK  ] = &nvc0_clock_oclass;
 		device->oclass[NVDEV_SUBDEV_THERM  ] = &nva3_therm_oclass;
diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/gpio.h b/drivers/gpu/drm/nouveau/core/include/subdev/gpio.h
index 612d82ab683d..b2028238f40f 100644
--- a/drivers/gpu/drm/nouveau/core/include/subdev/gpio.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/gpio.h
@@ -34,7 +34,7 @@ nouveau_gpio(void *obj)
 
 extern struct nouveau_oclass *nv10_gpio_oclass;
 extern struct nouveau_oclass *nv50_gpio_oclass;
-extern struct nouveau_oclass *nv92_gpio_oclass;
+extern struct nouveau_oclass *nv94_gpio_oclass;
 extern struct nouveau_oclass *nvd0_gpio_oclass;
 extern struct nouveau_oclass *nve0_gpio_oclass;
 
diff --git a/drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c b/drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c
deleted file mode 100644
index 252083d376f5..000000000000
--- a/drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c
+++ /dev/null
@@ -1,74 +0,0 @@
-/*
- * Copyright 2012 Red Hat Inc.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- * Authors: Ben Skeggs
- */
-
-#include "priv.h"
-
-void
-nv92_gpio_intr_stat(struct nouveau_gpio *gpio, u32 *hi, u32 *lo)
-{
-	u32 intr0 = nv_rd32(gpio, 0x00e054);
-	u32 intr1 = nv_rd32(gpio, 0x00e074);
-	u32 stat0 = nv_rd32(gpio, 0x00e050) & intr0;
-	u32 stat1 = nv_rd32(gpio, 0x00e070) & intr1;
-	*lo = (stat1 & 0xffff0000) | (stat0 >> 16);
-	*hi = (stat1 << 16) | (stat0 & 0x0000ffff);
-	nv_wr32(gpio, 0x00e054, intr0);
-	nv_wr32(gpio, 0x00e074, intr1);
-}
-
-void
-nv92_gpio_intr_mask(struct nouveau_gpio *gpio, u32 type, u32 mask, u32 data)
-{
-	u32 inte0 = nv_rd32(gpio, 0x00e050);
-	u32 inte1 = nv_rd32(gpio, 0x00e070);
-	if (type & NVKM_GPIO_LO)
-		inte0 = (inte0 & ~(mask << 16)) | (data << 16);
-	if (type & NVKM_GPIO_HI)
-		inte0 = (inte0 & ~(mask & 0xffff)) | (data & 0xffff);
-	mask >>= 16;
-	data >>= 16;
-	if (type & NVKM_GPIO_LO)
-		inte1 = (inte1 & ~(mask << 16)) | (data << 16);
-	if (type & NVKM_GPIO_HI)
-		inte1 = (inte1 & ~mask) | data;
-	nv_wr32(gpio, 0x00e050, inte0);
-	nv_wr32(gpio, 0x00e070, inte1);
-}
-
-struct nouveau_oclass *
-nv92_gpio_oclass = &(struct nouveau_gpio_impl) {
-	.base.handle = NV_SUBDEV(GPIO, 0x92),
-	.base.ofuncs = &(struct nouveau_ofuncs) {
-		.ctor = _nouveau_gpio_ctor,
-		.dtor = _nouveau_gpio_dtor,
-		.init = _nouveau_gpio_init,
-		.fini = _nouveau_gpio_fini,
-	},
-	.lines = 32,
-	.intr_stat = nv92_gpio_intr_stat,
-	.intr_mask = nv92_gpio_intr_mask,
-	.drive = nv50_gpio_drive,
-	.sense = nv50_gpio_sense,
-	.reset = nv50_gpio_reset,
-}.base;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c b/drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c
new file mode 100644
index 000000000000..cae404ccadac
--- /dev/null
+++ b/drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c
@@ -0,0 +1,74 @@
+/*
+ * Copyright 2012 Red Hat Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Ben Skeggs
+ */
+
+#include "priv.h"
+
+void
+nv94_gpio_intr_stat(struct nouveau_gpio *gpio, u32 *hi, u32 *lo)
+{
+	u32 intr0 = nv_rd32(gpio, 0x00e054);
+	u32 intr1 = nv_rd32(gpio, 0x00e074);
+	u32 stat0 = nv_rd32(gpio, 0x00e050) & intr0;
+	u32 stat1 = nv_rd32(gpio, 0x00e070) & intr1;
+	*lo = (stat1 & 0xffff0000) | (stat0 >> 16);
+	*hi = (stat1 << 16) | (stat0 & 0x0000ffff);
+	nv_wr32(gpio, 0x00e054, intr0);
+	nv_wr32(gpio, 0x00e074, intr1);
+}
+
+void
+nv94_gpio_intr_mask(struct nouveau_gpio *gpio, u32 type, u32 mask, u32 data)
+{
+	u32 inte0 = nv_rd32(gpio, 0x00e050);
+	u32 inte1 = nv_rd32(gpio, 0x00e070);
+	if (type & NVKM_GPIO_LO)
+		inte0 = (inte0 & ~(mask << 16)) | (data << 16);
+	if (type & NVKM_GPIO_HI)
+		inte0 = (inte0 & ~(mask & 0xffff)) | (data & 0xffff);
+	mask >>= 16;
+	data >>= 16;
+	if (type & NVKM_GPIO_LO)
+		inte1 = (inte1 & ~(mask << 16)) | (data << 16);
+	if (type & NVKM_GPIO_HI)
+		inte1 = (inte1 & ~mask) | data;
+	nv_wr32(gpio, 0x00e050, inte0);
+	nv_wr32(gpio, 0x00e070, inte1);
+}
+
+struct nouveau_oclass *
+nv94_gpio_oclass = &(struct nouveau_gpio_impl) {
+	.base.handle = NV_SUBDEV(GPIO, 0x94),
+	.base.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = _nouveau_gpio_ctor,
+		.dtor = _nouveau_gpio_dtor,
+		.init = _nouveau_gpio_init,
+		.fini = _nouveau_gpio_fini,
+	},
+	.lines = 32,
+	.intr_stat = nv94_gpio_intr_stat,
+	.intr_mask = nv94_gpio_intr_mask,
+	.drive = nv50_gpio_drive,
+	.sense = nv50_gpio_sense,
+	.reset = nv50_gpio_reset,
+}.base;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c b/drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c
index a4682b0956ad..480d6d2af770 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c
@@ -77,8 +77,8 @@ nvd0_gpio_oclass = &(struct nouveau_gpio_impl) {
 		.fini = _nouveau_gpio_fini,
 	},
 	.lines = 32,
-	.intr_stat = nv92_gpio_intr_stat,
-	.intr_mask = nv92_gpio_intr_mask,
+	.intr_stat = nv94_gpio_intr_stat,
+	.intr_mask = nv94_gpio_intr_mask,
 	.drive = nvd0_gpio_drive,
 	.sense = nvd0_gpio_sense,
 	.reset = nvd0_gpio_reset,
diff --git a/drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h b/drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h
index e1724dfc86ae..bff98b86e2b5 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h
+++ b/drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h
@@ -56,8 +56,8 @@ void nv50_gpio_reset(struct nouveau_gpio *, u8);
 int  nv50_gpio_drive(struct nouveau_gpio *, int, int, int);
 int  nv50_gpio_sense(struct nouveau_gpio *, int);
 
-void nv92_gpio_intr_stat(struct nouveau_gpio *, u32 *, u32 *);
-void nv92_gpio_intr_mask(struct nouveau_gpio *, u32, u32, u32);
+void nv94_gpio_intr_stat(struct nouveau_gpio *, u32 *, u32 *);
+void nv94_gpio_intr_mask(struct nouveau_gpio *, u32, u32, u32);
 
 void nvd0_gpio_reset(struct nouveau_gpio *, u8);
 int  nvd0_gpio_drive(struct nouveau_gpio *, int, int, int);
-- 
2.1.0

