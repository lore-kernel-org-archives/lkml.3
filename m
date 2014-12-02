Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaLBEsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:48:52 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15250 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbaLBEst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:48:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 01 Dec 2014 20:47:03 -0800
From: Vince Hsu <vinceh@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>, <gnurou@gmail.com>,
        <pdeschrijver@nvidia.com>, <bskeggs@redhat.com>,
        <martin.peres@free.fr>, <seven@nimrod-online.com>,
        <tbergstrom@nvidia.com>
CC: <nouveau@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vince Hsu <vinceh@nvidia.com>
Subject: [V3 PATCH nouveau 4/4] volt: add support for GK20A
Date: Tue, 2 Dec 2014 12:50:35 +0800
Message-ID: <1417495835-5556-4-git-send-email-vinceh@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417495835-5556-1-git-send-email-vinceh@nvidia.com>
References: <1417495835-5556-1-git-send-email-vinceh@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The voltage value are calculated by the hardware characterized
result.

Signed-off-by: Vince Hsu <vinceh@nvidia.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Martin Peres <martin.peres@free.fr>
---

v3: remove the tegra fuse dependency

v2: add Alex's Reviewed-by

 drm/Kbuild                   |   1 +
 drm/core/subdev/volt/gk20a.c |   1 +
 nvkm/engine/device/nve0.c    |   1 +
 nvkm/include/subdev/volt.h   |   1 +
 nvkm/subdev/clock/gk20a.c    |  15 ++++
 nvkm/subdev/volt/gk20a.c     | 200 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 219 insertions(+)
 create mode 120000 drm/core/subdev/volt/gk20a.c
 create mode 100644 nvkm/subdev/volt/gk20a.c

diff --git a/drm/Kbuild b/drm/Kbuild
index 728bc5b66b29..7c49e6655066 100644
--- a/drm/Kbuild
+++ b/drm/Kbuild
@@ -225,6 +225,7 @@ nouveau-y += core/subdev/vm/nvc0.o
 nouveau-y += core/subdev/volt/base.o
 nouveau-y += core/subdev/volt/gpio.o
 nouveau-y += core/subdev/volt/nv40.o
+nouveau-y += core/subdev/volt/gk20a.o
 
 nouveau-y += core/engine/falcon.o
 nouveau-y += core/engine/xtensa.o
diff --git a/drm/core/subdev/volt/gk20a.c b/drm/core/subdev/volt/gk20a.c
new file mode 120000
index 000000000000..2894eb1ede13
--- /dev/null
+++ b/drm/core/subdev/volt/gk20a.c
@@ -0,0 +1 @@
+../../../../nvkm/subdev/volt/gk20a.c
\ No newline at end of file
diff --git a/nvkm/engine/device/nve0.c b/nvkm/engine/device/nve0.c
index b1b2e484ecfa..674da1f095b2 100644
--- a/nvkm/engine/device/nve0.c
+++ b/nvkm/engine/device/nve0.c
@@ -179,6 +179,7 @@ nve0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_ENGINE_GR     ] =  gk20a_graph_oclass;
 		device->oclass[NVDEV_ENGINE_COPY2  ] = &nve0_copy2_oclass;
 		device->oclass[NVDEV_ENGINE_PERFMON] = &nve0_perfmon_oclass;
+		device->oclass[NVDEV_SUBDEV_VOLT   ] = &gk20a_volt_oclass;
 		break;
 	case 0xf0:
 		device->cname = "GK110";
diff --git a/nvkm/include/subdev/volt.h b/nvkm/include/subdev/volt.h
index 820b62ffd75b..67db5e58880d 100644
--- a/nvkm/include/subdev/volt.h
+++ b/nvkm/include/subdev/volt.h
@@ -52,6 +52,7 @@ int  _nouveau_volt_init(struct nouveau_object *);
 #define _nouveau_volt_fini _nouveau_subdev_fini
 
 extern struct nouveau_oclass nv40_volt_oclass;
+extern struct nouveau_oclass gk20a_volt_oclass;
 
 int nouveau_voltgpio_init(struct nouveau_volt *);
 int nouveau_voltgpio_get(struct nouveau_volt *);
diff --git a/nvkm/subdev/clock/gk20a.c b/nvkm/subdev/clock/gk20a.c
index 82abbea2be12..fb4fad374bdd 100644
--- a/nvkm/subdev/clock/gk20a.c
+++ b/nvkm/subdev/clock/gk20a.c
@@ -470,76 +470,91 @@ gk20a_pstates[] = {
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 72000,
+			.voltage = 0,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 108000,
+			.voltage = 1,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 180000,
+			.voltage = 2,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 252000,
+			.voltage = 3,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 324000,
+			.voltage = 4,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 396000,
+			.voltage = 5,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 468000,
+			.voltage = 6,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 540000,
+			.voltage = 7,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 612000,
+			.voltage = 8,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 648000,
+			.voltage = 9,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 684000,
+			.voltage = 10,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 708000,
+			.voltage = 11,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 756000,
+			.voltage = 12,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 804000,
+			.voltage = 13,
 		},
 	},
 	{
 		.base = {
 			.domain[nv_clk_src_gpc] = 852000,
+			.voltage = 14,
 		},
 	},
 };
diff --git a/nvkm/subdev/volt/gk20a.c b/nvkm/subdev/volt/gk20a.c
new file mode 100644
index 000000000000..03fa866833e6
--- /dev/null
+++ b/nvkm/subdev/volt/gk20a.c
@@ -0,0 +1,200 @@
+/*
+ * Copyright (c) 2014, NVIDIA CORPORATION. All rights reserved.
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
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/kernel.h>
+#include <linux/regulator/consumer.h>
+
+#include <nouveau_platform.h>
+#include <subdev/volt.h>
+
+struct cvb_coef {
+	int c0;
+	int c1;
+	int c2;
+	int c3;
+	int c4;
+	int c5;
+};
+
+struct gk20a_volt_priv {
+	struct nouveau_volt base;
+	struct regulator *vdd;
+};
+
+const struct cvb_coef gk20a_cvb_coef[] = {
+	/* MHz,        c0,     c1,   c2,    c3,     c4,   c5 */
+	/*  72 */ { 1209886, -36468,  515,   417, -13123,  203},
+	/* 108 */ { 1130804, -27659,  296,   298, -10834,  221},
+	/* 180 */ { 1162871, -27110,  247,   238, -10681,  268},
+	/* 252 */ { 1220458, -28654,  247,   179, -10376,  298},
+	/* 324 */ { 1280953, -30204,  247,   119,  -9766,  304},
+	/* 396 */ { 1344547, -31777,  247,   119,  -8545,  292},
+	/* 468 */ { 1420168, -34227,  269,    60,  -7172,  256},
+	/* 540 */ { 1490757, -35955,  274,    60,  -5188,  197},
+	/* 612 */ { 1599112, -42583,  398,     0,  -1831,  119},
+	/* 648 */ { 1366986, -16459, -274,     0,  -3204,   72},
+	/* 684 */ { 1391884, -17078, -274,   -60,  -1526,   30},
+	/* 708 */ { 1415522, -17497, -274,   -60,   -458,    0},
+	/* 756 */ { 1464061, -18331, -274,  -119,   1831,  -72},
+	/* 804 */ { 1524225, -20064, -254,  -119,   4272, -155},
+	/* 852 */ { 1608418, -21643, -269,     0,    763,  -48},
+};
+
+/**
+ * cvb_mv = ((c2 * speedo / s_scale + c1) * speedo / s_scale + c0)
+ */
+static inline int
+gk20a_volt_get_cvb_voltage(int speedo, int s_scale,
+		const struct cvb_coef *coef)
+{
+	int mv;
+
+	mv = DIV_ROUND_CLOSEST(coef->c2 * speedo, s_scale);
+	mv = DIV_ROUND_CLOSEST((mv + coef->c1) * speedo, s_scale) + coef->c0;
+	return mv;
+}
+
+/**
+ * cvb_t_mv =
+ * ((c2 * speedo / s_scale + c1) * speedo / s_scale + c0) +
+ * ((c3 * speedo / s_scale + c4 + c5 * T / t_scale) * T / t_scale)
+ */
+static inline int
+gk20a_volt_get_cvb_t_voltage(int speedo, int temp, int s_scale, int t_scale,
+		const struct cvb_coef *coef)
+{
+	int cvb_mv, mv;
+
+	cvb_mv = gk20a_volt_get_cvb_voltage(speedo, s_scale, coef);
+
+	mv = DIV_ROUND_CLOSEST(coef->c3 * speedo, s_scale) + coef->c4 +
+		DIV_ROUND_CLOSEST(coef->c5 * temp, t_scale);
+	mv = DIV_ROUND_CLOSEST(mv * temp, t_scale) + cvb_mv;
+	return mv;
+}
+
+static int
+gk20a_volt_calc_voltage(const struct cvb_coef *coef, int speedo)
+{
+	int mv;
+
+	mv = gk20a_volt_get_cvb_t_voltage(speedo, -10, 100, 10, coef);
+	mv = DIV_ROUND_UP(mv, 1000);
+
+	return mv * 1000;
+}
+
+static int
+gk20a_volt_vid_get(struct nouveau_volt *volt)
+{
+	struct gk20a_volt_priv *priv = (void *)volt;
+	int i, uv;
+
+	uv = regulator_get_voltage(priv->vdd);
+
+	for (i = 0; i < volt->vid_nr; i++)
+		if (volt->vid[i].uv >= uv)
+			return i;
+
+	return -EINVAL;
+}
+
+static int
+gk20a_volt_vid_set(struct nouveau_volt *volt, u8 vid)
+{
+	struct gk20a_volt_priv *priv = (void *)volt;
+
+	nv_debug(volt, "set voltage as %duv\n", volt->vid[vid].uv);
+	return regulator_set_voltage(priv->vdd, volt->vid[vid].uv, 1200000);
+}
+
+static int
+gk20a_volt_set_id(struct nouveau_volt *volt, u8 id, int condition)
+{
+	struct gk20a_volt_priv *priv = (void *)volt;
+	int prev_uv = regulator_get_voltage(priv->vdd);
+	int target_uv = volt->vid[id].uv;
+	int ret;
+
+	nv_debug(volt, "prev=%d, target=%d, condition=%d\n",
+			prev_uv, target_uv, condition);
+	if (!condition ||
+		(condition < 0 && target_uv < prev_uv) ||
+		(condition > 0 && target_uv > prev_uv)) {
+		ret = gk20a_volt_vid_set(volt, volt->vid[id].vid);
+	} else {
+		ret = 0;
+	}
+
+	return ret;
+}
+
+static int
+gk20a_volt_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
+	       struct nouveau_oclass *oclass, void *data, u32 size,
+	       struct nouveau_object **pobject)
+{
+	struct gk20a_volt_priv *priv;
+	struct nouveau_volt *volt;
+	struct nouveau_platform_device *plat;
+	int i, ret, uv;
+
+	ret = nouveau_volt_create(parent, engine, oclass, &priv);
+	*pobject = nv_object(priv);
+	if (ret)
+		return ret;
+
+	volt = &priv->base;
+
+	plat = nv_device_to_platform(nv_device(parent));
+
+	uv = regulator_get_voltage(plat->gpu->vdd);
+	nv_info(priv, "The default voltage is %duV\n", uv);
+
+	priv->vdd = plat->gpu->vdd;
+	priv->base.vid_get = gk20a_volt_vid_get;
+	priv->base.vid_set = gk20a_volt_vid_set;
+	priv->base.set_id = gk20a_volt_set_id;
+
+	volt->vid_nr = ARRAY_SIZE(gk20a_cvb_coef);
+	nv_debug(priv, "%s - vid_nr = %d\n", __func__, volt->vid_nr);
+	for (i = 0; i < volt->vid_nr; i++) {
+		volt->vid[i].vid = i;
+		volt->vid[i].uv = gk20a_volt_calc_voltage(&gk20a_cvb_coef[i],
+					plat->gpu_speedo);
+		nv_debug(priv, "%2d: vid=%d, uv=%d\n", i, volt->vid[i].vid,
+					volt->vid[i].uv);
+	}
+
+	return 0;
+}
+
+struct nouveau_oclass
+gk20a_volt_oclass = {
+	.handle = NV_SUBDEV(VOLT, 0xea),
+	.ofuncs = &(struct nouveau_ofuncs) {
+		.ctor = gk20a_volt_ctor,
+		.dtor = _nouveau_volt_dtor,
+		.init = _nouveau_volt_init,
+		.fini = _nouveau_volt_fini,
+	},
+};
-- 
1.9.1

