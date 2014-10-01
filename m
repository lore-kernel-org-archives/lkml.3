Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaJAO4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:56:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35319 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751345AbaJAOxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:53:33 -0400
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v7 05/11] drm: add Atmel HLCDC Display Controller support
Date: Wed,  1 Oct 2014 16:53:02 +0200
Message-Id: <1412175188-28278-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris BREZILLON <boris.brezillon@free-electrons.com>

The Atmel HLCDC (HLCD Controller) IP available on some Atmel SoCs (i.e.
at91sam9n12, at91sam9x5 family or sama5d3 family) provides a display
controller device.

This display controller supports at least one primary plane and might
provide several overlays and an hardware cursor depending on the IP
version.

At the moment, this driver only implements an RGB connector to interface
with LCD panels, but support for other kind of external devices might be
added later.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Reviewed-by: Rob Clark <robdclark@gmail.com>
Tested-by: Anthony Harivel <anthony.harivel@emtrion.de>
Tested-by: Ludovic Desroches <ludovic.desroches@atmel.com>
---
 drivers/gpu/drm/Kconfig                          |   2 +
 drivers/gpu/drm/Makefile                         |   1 +
 drivers/gpu/drm/atmel-hlcdc/Kconfig              |  13 +
 drivers/gpu/drm/atmel-hlcdc/Makefile             |   7 +
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   | 390 +++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c     | 531 +++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h     | 216 ++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c  | 638 +++++++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h  | 394 +++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c | 443 ++++++++++++
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c  | 831 +++++++++++++++++++++++
 11 files changed, 3466 insertions(+)
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/Kconfig
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/Makefile
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
 create mode 100644 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index b066bb3..2d97f7e 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -185,6 +185,8 @@ source "drivers/gpu/drm/cirrus/Kconfig"
 
 source "drivers/gpu/drm/armada/Kconfig"
 
+source "drivers/gpu/drm/atmel-hlcdc/Kconfig"
+
 source "drivers/gpu/drm/rcar-du/Kconfig"
 
 source "drivers/gpu/drm/shmobile/Kconfig"
diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 4a55d59..abb4f29 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_DRM_GMA500) += gma500/
 obj-$(CONFIG_DRM_UDL) += udl/
 obj-$(CONFIG_DRM_AST) += ast/
 obj-$(CONFIG_DRM_ARMADA) += armada/
+obj-$(CONFIG_DRM_ATMEL_HLCDC)	+= atmel-hlcdc/
 obj-$(CONFIG_DRM_RCAR_DU) += rcar-du/
 obj-$(CONFIG_DRM_SHMOBILE) +=shmobile/
 obj-$(CONFIG_DRM_OMAP)	+= omapdrm/
diff --git a/drivers/gpu/drm/atmel-hlcdc/Kconfig b/drivers/gpu/drm/atmel-hlcdc/Kconfig
new file mode 100644
index 0000000..942407f
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/Kconfig
@@ -0,0 +1,13 @@
+config DRM_ATMEL_HLCDC
+	tristate "DRM Support for ATMEL HLCDC Display Controller"
+	depends on DRM && OF && COMMON_CLK
+	select DRM_GEM_CMA_HELPER
+	select DRM_KMS_HELPER
+	select DRM_KMS_FB_HELPER
+	select DRM_KMS_CMA_HELPER
+	select DRM_PANEL
+	select MFD_ATMEL_HLCDC
+	depends on OF
+	help
+	  Choose this option if you have an ATMEL SoC with an HLCDC display
+	  controller (i.e. at91sam9n12, at91sam9x5 family or sama5d3 family).
diff --git a/drivers/gpu/drm/atmel-hlcdc/Makefile b/drivers/gpu/drm/atmel-hlcdc/Makefile
new file mode 100644
index 0000000..10ae426
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/Makefile
@@ -0,0 +1,7 @@
+atmel-hlcdc-dc-y := atmel_hlcdc_crtc.o \
+		atmel_hlcdc_dc.o \
+		atmel_hlcdc_layer.o \
+		atmel_hlcdc_output.o \
+		atmel_hlcdc_plane.o
+
+obj-$(CONFIG_DRM_ATMEL_HLCDC)	+= atmel-hlcdc-dc.o
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
new file mode 100644
index 0000000..02f7a98
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c
@@ -0,0 +1,390 @@
+/*
+ * Copyright (C) 2014 Traphandler
+ * Copyright (C) 2014 Free Electrons
+ *
+ * Author: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/pm.h>
+#include <linux/pm_runtime.h>
+
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drmP.h>
+
+#include <video/videomode.h>
+
+#include "atmel_hlcdc_dc.h"
+
+/**
+ * Atmel HLCDC CRTC structure
+ *
+ * @base: base DRM CRTC structure
+ * @hlcdc: pointer to the atmel_hlcdc structure provided by the MFD device
+ * @event: pointer to the current page flip event
+ * @id: CRTC id (returned by drm_crtc_index)
+ * @dpms: DPMS mode
+ */
+struct atmel_hlcdc_crtc {
+	struct drm_crtc base;
+	struct atmel_hlcdc_dc *dc;
+	struct drm_pending_vblank_event *event;
+	int id;
+	int dpms;
+};
+
+static inline struct atmel_hlcdc_crtc *
+drm_crtc_to_atmel_hlcdc_crtc(struct drm_crtc *crtc)
+{
+	return container_of(crtc, struct atmel_hlcdc_crtc, base);
+}
+
+static void atmel_hlcdc_crtc_dpms(struct drm_crtc *c, int mode)
+{
+	struct drm_device *dev = c->dev;
+	struct atmel_hlcdc_crtc *crtc = drm_crtc_to_atmel_hlcdc_crtc(c);
+	struct regmap *regmap = crtc->dc->hlcdc->regmap;
+	unsigned int status;
+
+	if (mode != DRM_MODE_DPMS_ON)
+		mode = DRM_MODE_DPMS_OFF;
+
+	if (crtc->dpms == mode)
+		return;
+
+	pm_runtime_get_sync(dev->dev);
+
+	if (mode != DRM_MODE_DPMS_ON) {
+		regmap_write(regmap, ATMEL_HLCDC_DIS, ATMEL_HLCDC_DISP);
+		while (!regmap_read(regmap, ATMEL_HLCDC_SR, &status) &&
+		       (status & ATMEL_HLCDC_DISP))
+			cpu_relax();
+
+		regmap_write(regmap, ATMEL_HLCDC_DIS, ATMEL_HLCDC_SYNC);
+		while (!regmap_read(regmap, ATMEL_HLCDC_SR, &status) &&
+		       (status & ATMEL_HLCDC_SYNC))
+			cpu_relax();
+
+		regmap_write(regmap, ATMEL_HLCDC_DIS, ATMEL_HLCDC_PIXEL_CLK);
+		while (!regmap_read(regmap, ATMEL_HLCDC_SR, &status) &&
+		       (status & ATMEL_HLCDC_PIXEL_CLK))
+			cpu_relax();
+
+		clk_disable_unprepare(crtc->dc->hlcdc->sys_clk);
+
+		pm_runtime_allow(dev->dev);
+	} else {
+		pm_runtime_forbid(dev->dev);
+
+		clk_prepare_enable(crtc->dc->hlcdc->sys_clk);
+
+		regmap_write(regmap, ATMEL_HLCDC_EN, ATMEL_HLCDC_PIXEL_CLK);
+		while (!regmap_read(regmap, ATMEL_HLCDC_SR, &status) &&
+		       !(status & ATMEL_HLCDC_PIXEL_CLK))
+			cpu_relax();
+
+
+		regmap_write(regmap, ATMEL_HLCDC_EN, ATMEL_HLCDC_SYNC);
+		while (!regmap_read(regmap, ATMEL_HLCDC_SR, &status) &&
+		       !(status & ATMEL_HLCDC_SYNC))
+			cpu_relax();
+
+		regmap_write(regmap, ATMEL_HLCDC_EN, ATMEL_HLCDC_DISP);
+		while (!regmap_read(regmap, ATMEL_HLCDC_SR, &status) &&
+		       !(status & ATMEL_HLCDC_DISP))
+			cpu_relax();
+	}
+
+	pm_runtime_put_sync(dev->dev);
+
+	crtc->dpms = mode;
+}
+
+static int atmel_hlcdc_crtc_mode_set(struct drm_crtc *c,
+				     struct drm_display_mode *mode,
+				     struct drm_display_mode *adj,
+				     int x, int y,
+				     struct drm_framebuffer *old_fb)
+{
+	struct atmel_hlcdc_crtc *crtc = drm_crtc_to_atmel_hlcdc_crtc(c);
+	struct regmap *regmap = crtc->dc->hlcdc->regmap;
+	struct drm_plane *plane = c->primary;
+	struct drm_framebuffer *fb;
+	unsigned long mode_rate;
+	struct videomode vm;
+	unsigned long prate;
+	unsigned int cfg;
+	int div;
+
+	if (atmel_hlcdc_dc_mode_valid(crtc->dc, adj) != MODE_OK)
+		return -EINVAL;
+
+	vm.vfront_porch = adj->vsync_start - adj->vdisplay;
+	vm.vback_porch = adj->vtotal - adj->vsync_end;
+	vm.vsync_len = adj->vsync_end - adj->vsync_start;
+	vm.hfront_porch = adj->hsync_start - adj->hdisplay;
+	vm.hback_porch = adj->htotal - adj->hsync_end;
+	vm.hsync_len = adj->hsync_end - adj->hsync_start;
+
+	regmap_write(regmap, ATMEL_HLCDC_CFG(1),
+		     (vm.hsync_len - 1) | ((vm.vsync_len - 1) << 16));
+
+	regmap_write(regmap, ATMEL_HLCDC_CFG(2),
+		     (vm.vfront_porch - 1) | (vm.vback_porch << 16));
+
+	regmap_write(regmap, ATMEL_HLCDC_CFG(3),
+		     (vm.hfront_porch - 1) | ((vm.hback_porch - 1) << 16));
+
+	regmap_write(regmap, ATMEL_HLCDC_CFG(4),
+		     (adj->hdisplay - 1) | ((adj->vdisplay - 1) << 16));
+
+	cfg = ATMEL_HLCDC_CLKPOL;
+
+	prate = clk_get_rate(crtc->dc->hlcdc->sys_clk);
+	mode_rate = mode->clock * 1000;
+	if ((prate / 2) < mode_rate) {
+		prate *= 2;
+		cfg |= ATMEL_HLCDC_CLKSEL;
+	}
+
+	div = DIV_ROUND_UP(prate, mode_rate);
+	if (div < 2)
+		div = 2;
+
+	cfg |= ATMEL_HLCDC_CLKDIV(div);
+
+	regmap_update_bits(regmap, ATMEL_HLCDC_CFG(0),
+			   ATMEL_HLCDC_CLKSEL | ATMEL_HLCDC_CLKDIV_MASK |
+			   ATMEL_HLCDC_CLKPOL, cfg);
+
+	cfg = 0;
+
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
+		cfg |= ATMEL_HLCDC_VSPOL;
+
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+		cfg |= ATMEL_HLCDC_HSPOL;
+
+	regmap_update_bits(regmap, ATMEL_HLCDC_CFG(5),
+			   ATMEL_HLCDC_HSPOL | ATMEL_HLCDC_VSPOL |
+			   ATMEL_HLCDC_VSPDLYS | ATMEL_HLCDC_VSPDLYE |
+			   ATMEL_HLCDC_DISPPOL | ATMEL_HLCDC_DISPDLY |
+			   ATMEL_HLCDC_VSPSU | ATMEL_HLCDC_VSPHO |
+			   ATMEL_HLCDC_GUARDTIME_MASK,
+			   cfg);
+
+	fb = plane->fb;
+	plane->fb = old_fb;
+
+	return plane->funcs->update_plane(plane, c, fb,
+					  0, 0,
+					  adj->hdisplay, adj->vdisplay,
+					  x << 16, y << 16,
+					  adj->hdisplay << 16,
+					  adj->vdisplay << 16);
+}
+
+int atmel_hlcdc_crtc_mode_set_base(struct drm_crtc *c, int x, int y,
+				   struct drm_framebuffer *old_fb)
+{
+	struct drm_plane *plane = c->primary;
+	struct drm_framebuffer *fb = plane->fb;
+	struct drm_display_mode *mode = &c->hwmode;
+
+	plane->fb = old_fb;
+
+	return plane->funcs->update_plane(plane, c, fb,
+					  0, 0,
+					  mode->hdisplay, mode->vdisplay,
+					  x << 16, y << 16,
+					  mode->hdisplay << 16,
+					  mode->vdisplay << 16);
+}
+
+static void atmel_hlcdc_crtc_prepare(struct drm_crtc *crtc)
+{
+	atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_OFF);
+}
+
+static void atmel_hlcdc_crtc_commit(struct drm_crtc *crtc)
+{
+	atmel_hlcdc_crtc_dpms(crtc, DRM_MODE_DPMS_ON);
+}
+
+static bool atmel_hlcdc_crtc_mode_fixup(struct drm_crtc *crtc,
+					const struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+
+static const struct drm_crtc_helper_funcs lcdc_crtc_helper_funcs = {
+
+	.mode_fixup = atmel_hlcdc_crtc_mode_fixup,
+	.dpms = atmel_hlcdc_crtc_dpms,
+	.mode_set = atmel_hlcdc_crtc_mode_set,
+	.mode_set_base = atmel_hlcdc_crtc_mode_set_base,
+	.prepare = atmel_hlcdc_crtc_prepare,
+	.commit = atmel_hlcdc_crtc_commit,
+};
+
+static void atmel_hlcdc_crtc_destroy(struct drm_crtc *c)
+{
+	struct atmel_hlcdc_crtc *crtc = drm_crtc_to_atmel_hlcdc_crtc(c);
+
+	drm_crtc_cleanup(c);
+	kfree(crtc);
+}
+
+void atmel_hlcdc_crtc_cancel_page_flip(struct drm_crtc *c,
+				       struct drm_file *file)
+{
+	struct atmel_hlcdc_crtc *crtc = drm_crtc_to_atmel_hlcdc_crtc(c);
+	struct drm_pending_vblank_event *event;
+	struct drm_device *dev = c->dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	event = crtc->event;
+	if (event && event->base.file_priv == file) {
+		event->base.destroy(&event->base);
+		drm_vblank_put(dev, crtc->id);
+		crtc->event = NULL;
+	}
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+}
+
+static void atmel_hlcdc_crtc_finish_page_flip(struct atmel_hlcdc_crtc *crtc)
+{
+	struct drm_device *dev = crtc->base.dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	if (crtc->event) {
+		drm_send_vblank_event(dev, crtc->id, crtc->event);
+		drm_vblank_put(dev, crtc->id);
+		crtc->event = NULL;
+	}
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+}
+
+void atmel_hlcdc_crtc_irq(struct drm_crtc *c)
+{
+	drm_handle_vblank(c->dev, 0);
+	atmel_hlcdc_crtc_finish_page_flip(drm_crtc_to_atmel_hlcdc_crtc(c));
+}
+
+static int atmel_hlcdc_crtc_page_flip(struct drm_crtc *c,
+				      struct drm_framebuffer *fb,
+				      struct drm_pending_vblank_event *event,
+				      uint32_t page_flip_flags)
+{
+	struct atmel_hlcdc_crtc *crtc = drm_crtc_to_atmel_hlcdc_crtc(c);
+	struct atmel_hlcdc_plane_update_req req;
+	struct drm_plane *plane = c->primary;
+	struct drm_device *dev = c->dev;
+	unsigned long flags;
+	int ret = 0;
+
+	spin_lock_irqsave(&dev->event_lock, flags);
+	if (crtc->event)
+		ret = -EBUSY;
+	spin_unlock_irqrestore(&dev->event_lock, flags);
+
+	if (ret)
+		return ret;
+
+	memset(&req, 0, sizeof(req));
+	req.crtc_x = 0;
+	req.crtc_y = 0;
+	req.crtc_h = c->mode.crtc_vdisplay;
+	req.crtc_w = c->mode.crtc_hdisplay;
+	req.src_x = c->x << 16;
+	req.src_y = c->y << 16;
+	req.src_w = req.crtc_w << 16;
+	req.src_h = req.crtc_h << 16;
+	req.fb = fb;
+	req.crtc = c;
+
+	ret = atmel_hlcdc_plane_prepare_update_req(plane, &req);
+	if (ret)
+		return ret;
+
+	if (event) {
+		drm_vblank_get(c->dev, crtc->id);
+		spin_lock_irqsave(&dev->event_lock, flags);
+		crtc->event = event;
+		spin_unlock_irqrestore(&dev->event_lock, flags);
+	}
+
+	ret = atmel_hlcdc_plane_apply_update_req(plane, &req);
+	if (ret)
+		crtc->event = NULL;
+	else
+		plane->fb = fb;
+
+	return ret;
+}
+
+static const struct drm_crtc_funcs atmel_hlcdc_crtc_funcs = {
+	.page_flip = atmel_hlcdc_crtc_page_flip,
+	.set_config = drm_crtc_helper_set_config,
+	.destroy = atmel_hlcdc_crtc_destroy,
+};
+
+int atmel_hlcdc_crtc_create(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	struct atmel_hlcdc_planes *planes = dc->planes;
+	struct atmel_hlcdc_crtc *crtc;
+	int ret;
+	int i;
+
+	crtc = kzalloc(sizeof(*crtc), GFP_KERNEL);
+	if (!crtc)
+		return -ENOMEM;
+
+	crtc->dpms = DRM_MODE_DPMS_OFF;
+	crtc->dc = dc;
+
+	ret = drm_crtc_init_with_planes(dev, &crtc->base,
+				&planes->primary->base,
+				planes->cursor ? &planes->cursor->base : NULL,
+				&atmel_hlcdc_crtc_funcs);
+	if (ret < 0)
+		goto fail;
+
+	crtc->id = drm_crtc_index(&crtc->base);
+
+	if (planes->cursor)
+		planes->cursor->base.possible_crtcs = 1 << crtc->id;
+
+	for (i = 0; i < planes->noverlays; i++)
+		planes->overlays[i]->base.possible_crtcs = 1 << crtc->id;
+
+	drm_crtc_helper_add(&crtc->base, &lcdc_crtc_helper_funcs);
+
+	dc->crtc = &crtc->base;
+
+	return 0;
+
+fail:
+	atmel_hlcdc_crtc_destroy(&crtc->base);
+	return ret;
+}
+
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
new file mode 100644
index 0000000..031bf6b
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.c
@@ -0,0 +1,531 @@
+/*
+ * Copyright (C) 2014 Traphandler
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/clk.h>
+#include <linux/irq.h>
+#include <linux/irqchip.h>
+#include <linux/module.h>
+#include <linux/pm_runtime.h>
+
+#include "atmel_hlcdc_dc.h"
+
+#define ATMEL_HLCDC_LAYER_IRQS_OFFSET		8
+
+static const struct atmel_hlcdc_layer_desc atmel_hlcdc_sama5d3_layers[] = {
+	{
+		.name = "base",
+		.formats = &atmel_hlcdc_plane_rgb_formats,
+		.regs_offset = 0x40,
+		.id = 0,
+		.type = ATMEL_HLCDC_BASE_LAYER,
+		.nconfigs = 7,
+		.layout = {
+			.xstride = { 2 },
+			.default_color = 3,
+			.general_config = 4,
+			.disc_pos = 5,
+			.disc_size = 6,
+		},
+	},
+	{
+		.name = "overlay1",
+		.formats = &atmel_hlcdc_plane_rgb_formats,
+		.regs_offset = 0x140,
+		.id = 1,
+		.type = ATMEL_HLCDC_OVERLAY_LAYER,
+		.nconfigs = 10,
+		.layout = {
+			.pos = 2,
+			.size = 3,
+			.xstride = { 4 },
+			.pstride = { 5 },
+			.default_color = 6,
+			.chroma_key = 7,
+			.chroma_key_mask = 8,
+			.general_config = 9,
+		},
+	},
+	{
+		.name = "overlay2",
+		.formats = &atmel_hlcdc_plane_rgb_formats,
+		.regs_offset = 0x240,
+		.id = 2,
+		.type = ATMEL_HLCDC_OVERLAY_LAYER,
+		.nconfigs = 10,
+		.layout = {
+			.pos = 2,
+			.size = 3,
+			.xstride = { 4 },
+			.pstride = { 5 },
+			.default_color = 6,
+			.chroma_key = 7,
+			.chroma_key_mask = 8,
+			.general_config = 9,
+		},
+	},
+	{
+		.name = "high-end-overlay",
+		.formats = &atmel_hlcdc_plane_rgb_and_yuv_formats,
+		.regs_offset = 0x340,
+		.id = 3,
+		.type = ATMEL_HLCDC_OVERLAY_LAYER,
+		.nconfigs = 42,
+		.layout = {
+			.pos = 2,
+			.size = 3,
+			.memsize = 4,
+			.xstride = { 5, 7 },
+			.pstride = { 6, 8 },
+			.default_color = 9,
+			.chroma_key = 10,
+			.chroma_key_mask = 11,
+			.general_config = 12,
+			.csc = 14,
+		},
+	},
+	{
+		.name = "cursor",
+		.formats = &atmel_hlcdc_plane_rgb_formats,
+		.regs_offset = 0x440,
+		.id = 4,
+		.type = ATMEL_HLCDC_CURSOR_LAYER,
+		.nconfigs = 10,
+		.max_width = 128,
+		.max_height = 128,
+		.layout = {
+			.pos = 2,
+			.size = 3,
+			.xstride = { 4 },
+			.pstride = { 5 },
+			.default_color = 6,
+			.chroma_key = 7,
+			.chroma_key_mask = 8,
+			.general_config = 9,
+		},
+	},
+};
+
+static const struct atmel_hlcdc_dc_desc atmel_hlcdc_dc_sama5d3 = {
+	.min_width = 0,
+	.min_height = 0,
+	.max_width = 2048,
+	.max_height = 2048,
+	.nlayers = ARRAY_SIZE(atmel_hlcdc_sama5d3_layers),
+	.layers = atmel_hlcdc_sama5d3_layers,
+};
+
+static const struct of_device_id atmel_hlcdc_of_match[] = {
+	{
+		.compatible = "atmel,sama5d3-hlcdc",
+		.data = &atmel_hlcdc_dc_sama5d3,
+	},
+	{ /* sentinel */ },
+};
+
+int atmel_hlcdc_dc_mode_valid(struct atmel_hlcdc_dc *dc,
+			      struct drm_display_mode *mode)
+{
+	int vfront_porch = mode->vsync_start - mode->vdisplay;
+	int vback_porch = mode->vtotal - mode->vsync_end;
+	int vsync_len = mode->vsync_end - mode->vsync_start;
+	int hfront_porch = mode->hsync_start - mode->hdisplay;
+	int hback_porch = mode->htotal - mode->hsync_end;
+	int hsync_len = mode->hsync_end - mode->hsync_start;
+
+	if (hsync_len > 0x40 || hsync_len < 1)
+		return MODE_HSYNC;
+
+	if (vsync_len > 0x40 || vsync_len < 1)
+		return MODE_VSYNC;
+
+	if (hfront_porch > 0x200 || hfront_porch < 1 ||
+	    hback_porch > 0x200 || hback_porch < 1 ||
+	    mode->hdisplay < 1)
+		return MODE_H_ILLEGAL;
+
+	if (vfront_porch > 0x40 || vfront_porch < 1 ||
+	    vback_porch > 0x40 || vback_porch < 0 ||
+	    mode->vdisplay < 1)
+		return MODE_V_ILLEGAL;
+
+	return MODE_OK;
+}
+
+static irqreturn_t atmel_hlcdc_dc_irq_handler(int irq, void *data)
+{
+	struct drm_device *dev = data;
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	unsigned long status;
+	unsigned int imr, isr;
+	int i;
+
+	regmap_read(dc->hlcdc->regmap, ATMEL_HLCDC_IMR, &imr);
+	regmap_read(dc->hlcdc->regmap, ATMEL_HLCDC_ISR, &isr);
+	status = imr & isr;
+	if (!status)
+		return IRQ_NONE;
+
+	if (status & ATMEL_HLCDC_SOF)
+		atmel_hlcdc_crtc_irq(dc->crtc);
+
+	for (i = 0; i < ATMEL_HLCDC_MAX_LAYERS; i++) {
+		struct atmel_hlcdc_layer *layer = dc->layers[i];
+
+		if (!(ATMEL_HLCDC_LAYER_STATUS(i) & status) || !layer)
+			continue;
+
+		atmel_hlcdc_layer_irq(layer);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static struct drm_framebuffer *atmel_hlcdc_fb_create(struct drm_device *dev,
+		struct drm_file *file_priv, struct drm_mode_fb_cmd2 *mode_cmd)
+{
+	return drm_fb_cma_create(dev, file_priv, mode_cmd);
+}
+
+static void atmel_hlcdc_fb_output_poll_changed(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+
+	if (dc->fbdev) {
+		drm_fbdev_cma_hotplug_event(dc->fbdev);
+	} else {
+		dc->fbdev = drm_fbdev_cma_init(dev, 24,
+				dev->mode_config.num_crtc,
+				dev->mode_config.num_connector);
+		if (IS_ERR(dc->fbdev))
+			dc->fbdev = NULL;
+	}
+}
+
+static const struct drm_mode_config_funcs mode_config_funcs = {
+	.fb_create = atmel_hlcdc_fb_create,
+	.output_poll_changed = atmel_hlcdc_fb_output_poll_changed,
+};
+
+static int atmel_hlcdc_dc_modeset_init(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	struct atmel_hlcdc_planes *planes;
+	int ret;
+	int i;
+
+	drm_mode_config_init(dev);
+
+	ret = atmel_hlcdc_create_outputs(dev);
+	if (ret) {
+		dev_err(dev->dev, "failed to create panel: %d\n", ret);
+		return ret;
+	}
+
+	planes = atmel_hlcdc_create_planes(dev);
+	if (IS_ERR(planes)) {
+		dev_err(dev->dev, "failed to create planes\n");
+		return PTR_ERR(planes);
+	}
+
+	dc->planes = planes;
+
+	dc->layers[planes->primary->layer.desc->id] =
+						&planes->primary->layer;
+
+	if (planes->cursor)
+		dc->layers[planes->cursor->layer.desc->id] =
+							&planes->cursor->layer;
+
+	for (i = 0; i < planes->noverlays; i++)
+		dc->layers[planes->overlays[i]->layer.desc->id] =
+						&planes->overlays[i]->layer;
+
+	ret = atmel_hlcdc_crtc_create(dev);
+	if (ret) {
+		dev_err(dev->dev, "failed to create crtc\n");
+		return ret;
+	}
+
+	dev->mode_config.min_width = dc->desc->min_width;
+	dev->mode_config.min_height = dc->desc->min_height;
+	dev->mode_config.max_width = dc->desc->max_width;
+	dev->mode_config.max_height = dc->desc->max_height;
+	dev->mode_config.funcs = &mode_config_funcs;
+
+	return 0;
+}
+
+static int atmel_hlcdc_dc_load(struct drm_device *dev, unsigned long flags)
+{
+	struct platform_device *pdev = to_platform_device(dev->dev);
+	const struct of_device_id *match;
+	struct atmel_hlcdc_dc *dc;
+	int ret;
+
+	match = of_match_node(atmel_hlcdc_of_match, dev->dev->parent->of_node);
+	if (!match) {
+		dev_err(&pdev->dev, "invalid compatible string\n");
+		return -ENODEV;
+	}
+
+	if (!match->data) {
+		dev_err(&pdev->dev, "invalid hlcdc description\n");
+		return -EINVAL;
+	}
+
+	dc = devm_kzalloc(dev->dev, sizeof(*dc), GFP_KERNEL);
+	if (!dc)
+		return -ENOMEM;
+
+	dc->wq = alloc_ordered_workqueue("atmel-hlcdc-dc", 0);
+	if (!dc->wq)
+		return -ENOMEM;
+
+	dc->desc = match->data;
+	dc->hlcdc = dev_get_drvdata(dev->dev->parent);
+	dev->dev_private = dc;
+
+	ret = clk_prepare_enable(dc->hlcdc->periph_clk);
+	if (ret) {
+		dev_err(dev->dev, "failed to enable periph_clk\n");
+		goto err_destroy_wq;
+	}
+
+	pm_runtime_enable(dev->dev);
+
+	pm_runtime_put_sync(dev->dev);
+
+	ret = atmel_hlcdc_dc_modeset_init(dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to initialize mode setting\n");
+		goto err_periph_clk_disable;
+	}
+
+	ret = drm_vblank_init(dev, 1);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to initialize vblank\n");
+		goto err_periph_clk_disable;
+	}
+
+	pm_runtime_get_sync(dev->dev);
+	ret = drm_irq_install(dev, dc->hlcdc->irq);
+	pm_runtime_put_sync(dev->dev);
+	if (ret < 0) {
+		dev_err(dev->dev, "failed to install IRQ handler\n");
+		goto err_periph_clk_disable;
+	}
+
+	platform_set_drvdata(pdev, dev);
+
+	drm_kms_helper_poll_init(dev);
+
+	/* force connectors detection */
+	drm_helper_hpd_irq_event(dev);
+
+	return 0;
+
+err_periph_clk_disable:
+	clk_disable_unprepare(dc->hlcdc->periph_clk);
+
+err_destroy_wq:
+	destroy_workqueue(dc->wq);
+
+	return ret;
+}
+
+static int atmel_hlcdc_dc_unload(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+
+	drm_kms_helper_poll_fini(dev);
+	drm_mode_config_cleanup(dev);
+	drm_vblank_cleanup(dev);
+
+	pm_runtime_get_sync(dev->dev);
+	drm_irq_uninstall(dev);
+	pm_runtime_put_sync(dev->dev);
+
+	dev->dev_private = NULL;
+
+	pm_runtime_disable(dev->dev);
+	clk_disable_unprepare(dc->hlcdc->periph_clk);
+
+	flush_workqueue(dc->wq);
+	destroy_workqueue(dc->wq);
+
+	return 0;
+}
+
+static void atmel_hlcdc_dc_preclose(struct drm_device *dev,
+				    struct drm_file *file)
+{
+	struct drm_crtc *crtc;
+
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head)
+		atmel_hlcdc_crtc_cancel_page_flip(crtc, file);
+}
+
+static void atmel_hlcdc_dc_lastclose(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+
+	drm_fbdev_cma_restore_mode(dc->fbdev);
+}
+
+static void atmel_hlcdc_dc_irq_preinstall(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	unsigned int isr;
+
+	regmap_write(dc->hlcdc->regmap, ATMEL_HLCDC_IDR, 0xffffffff);
+	regmap_read(dc->hlcdc->regmap, ATMEL_HLCDC_ISR, &isr);
+}
+
+static int atmel_hlcdc_dc_irq_postinstall(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	/* Enable SOF (Start Of Frame) interrupt for vblank counting */
+	unsigned int cfg = ATMEL_HLCDC_SOF;
+	int i;
+
+	/* Enable interrupts on activated layers */
+	for (i = 0; i < ATMEL_HLCDC_MAX_LAYERS; i++) {
+		if (dc->layers[i])
+			cfg |= ATMEL_HLCDC_LAYER_STATUS(i);
+	}
+
+	regmap_write(dc->hlcdc->regmap, ATMEL_HLCDC_IER, cfg);
+
+	return 0;
+}
+
+static void atmel_hlcdc_dc_irq_uninstall(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	unsigned int isr;
+
+	regmap_write(dc->hlcdc->regmap, ATMEL_HLCDC_IDR, 0xffffffff);
+	regmap_read(dc->hlcdc->regmap, ATMEL_HLCDC_ISR, &isr);
+}
+
+static int atmel_hlcdc_dc_enable_vblank(struct drm_device *dev, int crtc)
+{
+	return 0;
+}
+
+static void atmel_hlcdc_dc_disable_vblank(struct drm_device *dev, int crtc)
+{
+}
+
+static const struct file_operations fops = {
+	.owner              = THIS_MODULE,
+	.open               = drm_open,
+	.release            = drm_release,
+	.unlocked_ioctl     = drm_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl       = drm_compat_ioctl,
+#endif
+	.poll               = drm_poll,
+	.read               = drm_read,
+	.llseek             = no_llseek,
+	.mmap               = drm_gem_cma_mmap,
+};
+
+static struct drm_driver atmel_hlcdc_dc_driver = {
+	.driver_features = DRIVER_HAVE_IRQ | DRIVER_GEM | DRIVER_MODESET,
+	.load = atmel_hlcdc_dc_load,
+	.unload = atmel_hlcdc_dc_unload,
+	.preclose = atmel_hlcdc_dc_preclose,
+	.lastclose = atmel_hlcdc_dc_lastclose,
+	.irq_handler = atmel_hlcdc_dc_irq_handler,
+	.irq_preinstall = atmel_hlcdc_dc_irq_preinstall,
+	.irq_postinstall = atmel_hlcdc_dc_irq_postinstall,
+	.irq_uninstall = atmel_hlcdc_dc_irq_uninstall,
+	.get_vblank_counter = drm_vblank_count,
+	.enable_vblank = atmel_hlcdc_dc_enable_vblank,
+	.disable_vblank = atmel_hlcdc_dc_disable_vblank,
+	.gem_free_object = drm_gem_cma_free_object,
+	.gem_vm_ops = &drm_gem_cma_vm_ops,
+	.dumb_create = drm_gem_cma_dumb_create,
+	.dumb_map_offset = drm_gem_cma_dumb_map_offset,
+	.dumb_destroy = drm_gem_dumb_destroy,
+	.fops = &fops,
+	.name = "atmel-hlcdc",
+	.desc = "Atmel HLCD Controller DRM",
+	.date = "20141504",
+	.major = 1,
+	.minor = 0,
+};
+
+static int atmel_hlcdc_dc_drm_probe(struct platform_device *pdev)
+{
+	struct drm_device *ddev;
+	int ret;
+
+	ddev = drm_dev_alloc(&atmel_hlcdc_dc_driver, &pdev->dev);
+	if (!ddev)
+		return -ENOMEM;
+
+	ret = drm_dev_set_unique(ddev, dev_name(ddev->dev));
+	if (ret) {
+		drm_dev_unref(ddev);
+		return ret;
+	}
+
+	ret = drm_dev_register(ddev, 0);
+	if (ret) {
+		drm_dev_unref(ddev);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int atmel_hlcdc_dc_drm_remove(struct platform_device *pdev)
+{
+	struct drm_device *ddev = platform_get_drvdata(pdev);
+
+	drm_dev_unregister(ddev);
+	drm_dev_unref(ddev);
+
+	return 0;
+}
+
+static const struct of_device_id atmel_hlcdc_dc_of_match[] = {
+	{ .compatible = "atmel,hlcdc-display-controller" },
+	{ },
+};
+
+static struct platform_driver atmel_hlcdc_dc_platform_driver = {
+	.probe	= atmel_hlcdc_dc_drm_probe,
+	.remove	= atmel_hlcdc_dc_drm_remove,
+	.driver	= {
+		.name	= "atmel-hlcdc-display-controller",
+		.of_match_table = atmel_hlcdc_dc_of_match,
+	},
+};
+module_platform_driver(atmel_hlcdc_dc_platform_driver);
+
+MODULE_AUTHOR("Jean-Jacques Hiblot <jjhiblot@traphandler.com>");
+MODULE_AUTHOR("Boris BREZILLON <boris.brezillon@free-electrons.com>");
+MODULE_DESCRIPTION("Atmel HLCDC Display Controller DRM Driver");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:atmel-hlcdc-dc");
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
new file mode 100644
index 0000000..8194152
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_dc.h
@@ -0,0 +1,216 @@
+/*
+ * Copyright (C) 2014 Traphandler
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef DRM_ATMEL_HLCDC_H
+#define DRM_ATMEL_HLCDC_H
+
+#include <linux/clk.h>
+#include <linux/irqdomain.h>
+#include <linux/pwm.h>
+
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <drm/drm_fb_cma_helper.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <drm/drm_panel.h>
+#include <drm/drmP.h>
+
+#include "atmel_hlcdc_layer.h"
+
+#define ATMEL_HLCDC_MAX_LAYERS		5
+
+/**
+ * Atmel HLCDC Display Controller description structure.
+ *
+ * This structure describe the HLCDC IP capabilities and depends on the
+ * HLCDC IP version (or Atmel SoC family).
+ *
+ * @min_width: minimum width supported by the Display Controller
+ * @min_height: minimum height supported by the Display Controller
+ * @max_width: maximum width supported by the Display Controller
+ * @max_height: maximum height supported by the Display Controller
+ * @layer: a layer description table describing available layers
+ * @nlayers: layer description table size
+ */
+struct atmel_hlcdc_dc_desc {
+	int min_width;
+	int min_height;
+	int max_width;
+	int max_height;
+	const struct atmel_hlcdc_layer_desc *layers;
+	int nlayers;
+};
+
+/**
+ * Atmel HLCDC Plane properties.
+ *
+ * This structure stores plane property definitions.
+ *
+ * @alpha: alpha blending (or transparency) property
+ * @csc: YUV to RGB conversion factors property
+ */
+struct atmel_hlcdc_plane_properties {
+	struct drm_property *alpha;
+	struct drm_property *rotation;
+};
+
+/**
+ * Atmel HLCDC Plane.
+ *
+ * @base: base DRM plane structure
+ * @layer: HLCDC layer structure
+ * @properties: pointer to the property definitions structure
+ * @alpha: current alpha blending (or transparency) status
+ */
+struct atmel_hlcdc_plane {
+	struct drm_plane base;
+	struct atmel_hlcdc_layer layer;
+	struct atmel_hlcdc_plane_properties *properties;
+	unsigned int rotation;
+};
+
+static inline struct atmel_hlcdc_plane *
+drm_plane_to_atmel_hlcdc_plane(struct drm_plane *p)
+{
+	return container_of(p, struct atmel_hlcdc_plane, base);
+}
+
+static inline struct atmel_hlcdc_plane *
+atmel_hlcdc_layer_to_plane(struct atmel_hlcdc_layer *l)
+{
+	return container_of(l, struct atmel_hlcdc_plane, layer);
+}
+
+/**
+ * Atmel HLCDC Plane update request structure.
+ *
+ * @crtc_x: x position of the plane relative to the CRTC
+ * @crtc_y: y position of the plane relative to the CRTC
+ * @crtc_w: visible width of the plane
+ * @crtc_h: visible height of the plane
+ * @src_x: x buffer position
+ * @src_y: y buffer position
+ * @src_w: buffer width
+ * @src_h: buffer height
+ * @pixel_format: pixel format
+ * @gems: GEM object object containing image buffers
+ * @offsets: offsets to apply to the GEM buffers
+ * @pitches: line size in bytes
+ * @crtc: crtc to display on
+ * @finished: finished callback
+ * @finished_data: data passed to the finished callback
+ * @bpp: bytes per pixel deduced from pixel_format
+ * @xstride: value to add to the pixel pointer between each line
+ * @pstride: value to add to the pixel pointer between each pixel
+ * @nplanes: number of planes (deduced from pixel_format)
+ */
+struct atmel_hlcdc_plane_update_req {
+	int crtc_x;
+	int crtc_y;
+	unsigned int crtc_w;
+	unsigned int crtc_h;
+	uint32_t src_x;
+	uint32_t src_y;
+	uint32_t src_w;
+	uint32_t src_h;
+	struct drm_framebuffer *fb;
+	struct drm_crtc *crtc;
+
+	/* These fields are private and should not be touched */
+	int bpp[ATMEL_HLCDC_MAX_PLANES];
+	unsigned int offsets[ATMEL_HLCDC_MAX_PLANES];
+	int xstride[ATMEL_HLCDC_MAX_PLANES];
+	int pstride[ATMEL_HLCDC_MAX_PLANES];
+	int nplanes;
+};
+
+/**
+ * Atmel HLCDC Planes.
+ *
+ * This structure stores the instantiated HLCDC Planes and can be accessed by
+ * the HLCDC Display Controller or the HLCDC CRTC.
+ *
+ * @primary: primary plane
+ * @cursor: hardware cursor plane
+ * @overlays: overlay plane table
+ * @noverlays: number of overlay planes
+ */
+struct atmel_hlcdc_planes {
+	struct atmel_hlcdc_plane *primary;
+	struct atmel_hlcdc_plane *cursor;
+	struct atmel_hlcdc_plane **overlays;
+	int noverlays;
+};
+
+/**
+ * Atmel HLCDC Display Controller.
+ *
+ * @desc: HLCDC Display Controller description
+ * @hlcdc: pointer to the atmel_hlcdc structure provided by the MFD device
+ * @fbdev: framebuffer device attached to the Display Controller
+ * @crtc: CRTC provided by the display controller
+ * @planes: instantiated planes
+ * @layers: active HLCDC layer
+ * @wq: display controller workqueue
+ */
+struct atmel_hlcdc_dc {
+	const struct atmel_hlcdc_dc_desc *desc;
+	struct atmel_hlcdc *hlcdc;
+	struct drm_fbdev_cma *fbdev;
+	struct drm_crtc *crtc;
+	struct atmel_hlcdc_planes *planes;
+	struct atmel_hlcdc_layer *layers[ATMEL_HLCDC_MAX_LAYERS];
+	struct workqueue_struct *wq;
+};
+
+extern struct atmel_hlcdc_formats atmel_hlcdc_plane_rgb_formats;
+extern struct atmel_hlcdc_formats atmel_hlcdc_plane_rgb_and_yuv_formats;
+
+int atmel_hlcdc_dc_mode_valid(struct atmel_hlcdc_dc *dc,
+			      struct drm_display_mode *mode);
+
+struct atmel_hlcdc_planes *
+atmel_hlcdc_create_planes(struct drm_device *dev);
+
+int atmel_hlcdc_plane_prepare_update_req(struct drm_plane *p,
+				struct atmel_hlcdc_plane_update_req *req);
+
+int atmel_hlcdc_plane_apply_update_req(struct drm_plane *p,
+				struct atmel_hlcdc_plane_update_req *req);
+
+void atmel_hlcdc_crtc_irq(struct drm_crtc *c);
+
+void atmel_hlcdc_crtc_cancel_page_flip(struct drm_crtc *crtc,
+				       struct drm_file *file);
+
+int atmel_hlcdc_crtc_create(struct drm_device *dev);
+
+int atmel_hlcdc_create_outputs(struct drm_device *dev);
+
+struct atmel_hlcdc_pwm_chip *atmel_hlcdc_pwm_create(struct drm_device *dev,
+						    struct clk *slow_clk,
+						    struct clk *sys_clk,
+						    void __iomem *regs);
+
+int atmel_hlcdc_pwm_destroy(struct drm_device *dev,
+			    struct atmel_hlcdc_pwm_chip *chip);
+
+#endif /* DRM_ATMEL_HLCDC_H */
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
new file mode 100644
index 0000000..4799325
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.c
@@ -0,0 +1,638 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/dma-mapping.h>
+#include <linux/interrupt.h>
+
+#include "atmel_hlcdc_dc.h"
+
+static void
+atmel_hlcdc_layer_fb_flip_release(struct drm_flip_work *work, void *val)
+{
+	struct atmel_hlcdc_layer_fb_flip *flip = val;
+
+	if (flip->fb)
+		drm_framebuffer_unreference(flip->fb);
+	kfree(flip);
+}
+
+static void
+atmel_hlcdc_layer_fb_flip_destroy(struct atmel_hlcdc_layer_fb_flip *flip)
+{
+	if (flip->fb)
+		drm_framebuffer_unreference(flip->fb);
+	kfree(flip->task);
+	kfree(flip);
+}
+
+static void
+atmel_hlcdc_layer_fb_flip_release_queue(struct atmel_hlcdc_layer *layer,
+					struct atmel_hlcdc_layer_fb_flip *flip)
+{
+	int i;
+
+	if (!flip)
+		return;
+
+	for (i = 0; i < layer->max_planes; i++) {
+		if (!flip->dscrs[i])
+			break;
+
+		flip->dscrs[i]->status = 0;
+		flip->dscrs[i] = NULL;
+	}
+
+	drm_flip_work_queue_task(&layer->gc, flip->task);
+	drm_flip_work_commit(&layer->gc, layer->wq);
+}
+
+static void atmel_hlcdc_layer_update_reset(struct atmel_hlcdc_layer *layer,
+					   int id)
+{
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	struct atmel_hlcdc_layer_update_slot *slot;
+
+	if (id < 0 || id > 1)
+		return;
+
+	slot = &upd->slots[id];
+	bitmap_clear(slot->updated_configs, 0, layer->desc->nconfigs);
+	memset(slot->configs, 0,
+	       sizeof(*slot->configs) * layer->desc->nconfigs);
+
+	if (slot->fb_flip) {
+		atmel_hlcdc_layer_fb_flip_release_queue(layer, slot->fb_flip);
+		slot->fb_flip = NULL;
+	}
+}
+
+static void atmel_hlcdc_layer_update_apply(struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_dma_channel *dma = &layer->dma;
+	const struct atmel_hlcdc_layer_desc *desc = layer->desc;
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	struct regmap *regmap = layer->hlcdc->regmap;
+	struct atmel_hlcdc_layer_update_slot *slot;
+	struct atmel_hlcdc_layer_fb_flip *fb_flip;
+	struct atmel_hlcdc_dma_channel_dscr *dscr;
+	unsigned int cfg;
+	u32 action = 0;
+	int i = 0;
+
+	if (upd->pending < 0 || upd->pending > 1 ||
+	    dma->status == ATMEL_HLCDC_LAYER_DISABLING)
+		return;
+
+	slot = &upd->slots[upd->pending];
+
+	for_each_set_bit(cfg, slot->updated_configs, layer->desc->nconfigs) {
+		regmap_write(regmap,
+			     desc->regs_offset +
+			     ATMEL_HLCDC_LAYER_CFG(layer, cfg),
+			     slot->configs[cfg]);
+		action |= ATMEL_HLCDC_LAYER_UPDATE;
+	}
+
+	fb_flip = slot->fb_flip;
+
+	if (!fb_flip->fb)
+		goto apply;
+
+	if (dma->status == ATMEL_HLCDC_LAYER_DISABLED) {
+		for (i = 0; i < fb_flip->ngems; i++) {
+			dscr =  fb_flip->dscrs[i];
+			dscr->ctrl = ATMEL_HLCDC_LAYER_DFETCH |
+				     ATMEL_HLCDC_LAYER_DMA_IRQ |
+				     ATMEL_HLCDC_LAYER_ADD_IRQ |
+				     ATMEL_HLCDC_LAYER_DONE_IRQ;
+
+			regmap_write(regmap,
+				     desc->regs_offset +
+				     ATMEL_HLCDC_LAYER_PLANE_ADDR(i),
+				     dscr->addr);
+			regmap_write(regmap,
+				     desc->regs_offset +
+				     ATMEL_HLCDC_LAYER_PLANE_CTRL(i),
+				     dscr->ctrl);
+			regmap_write(regmap,
+				     desc->regs_offset +
+				     ATMEL_HLCDC_LAYER_PLANE_NEXT(i),
+				     dscr->next);
+		}
+
+		action |= ATMEL_HLCDC_LAYER_DMA_CHAN;
+		dma->status = ATMEL_HLCDC_LAYER_ENABLED;
+	} else {
+		for (i = 0; i < fb_flip->ngems; i++) {
+			dscr =  fb_flip->dscrs[i];
+			dscr->ctrl = ATMEL_HLCDC_LAYER_DFETCH |
+				     ATMEL_HLCDC_LAYER_DMA_IRQ |
+				     ATMEL_HLCDC_LAYER_DSCR_IRQ |
+				     ATMEL_HLCDC_LAYER_DONE_IRQ;
+
+			regmap_write(regmap,
+				     desc->regs_offset +
+				     ATMEL_HLCDC_LAYER_PLANE_HEAD(i),
+				     dscr->next);
+		}
+
+		action |= ATMEL_HLCDC_LAYER_A2Q;
+	}
+
+	/* Release unneeded descriptors */
+	for (i = fb_flip->ngems; i < layer->max_planes; i++) {
+		fb_flip->dscrs[i]->status = 0;
+		fb_flip->dscrs[i] = NULL;
+	}
+
+	dma->queue = fb_flip;
+	slot->fb_flip = NULL;
+
+apply:
+	if (action)
+		regmap_write(regmap,
+			     desc->regs_offset + ATMEL_HLCDC_LAYER_CHER,
+			     action);
+
+	atmel_hlcdc_layer_update_reset(layer, upd->pending);
+
+	upd->pending = -1;
+}
+
+void atmel_hlcdc_layer_irq(struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_dma_channel *dma = &layer->dma;
+	const struct atmel_hlcdc_layer_desc *desc = layer->desc;
+	struct regmap *regmap = layer->hlcdc->regmap;
+	struct atmel_hlcdc_layer_fb_flip *flip;
+	unsigned long flags;
+	unsigned int isr, imr;
+	unsigned int status;
+	unsigned int plane_status;
+	u32 flip_status;
+
+	int i;
+
+	regmap_read(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_IMR, &imr);
+	regmap_read(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_ISR, &isr);
+	status = imr & isr;
+	if (!status)
+		return;
+
+	spin_lock_irqsave(&layer->lock, flags);
+
+	flip = dma->queue ? dma->queue : dma->cur;
+
+	if (!flip) {
+		spin_unlock_irqrestore(&layer->lock, flags);
+		return;
+	}
+
+	flip_status = 0;
+	for (i = 0; i < flip->ngems; i++) {
+		plane_status = (status >> (8 * i));
+
+		if (plane_status &
+		    (ATMEL_HLCDC_LAYER_ADD_IRQ |
+		     ATMEL_HLCDC_LAYER_DSCR_IRQ) &
+		    ~flip->dscrs[i]->ctrl) {
+			flip->dscrs[i]->status |=
+					ATMEL_HLCDC_DMA_CHANNEL_DSCR_LOADED;
+			flip->dscrs[i]->ctrl |=
+					ATMEL_HLCDC_LAYER_ADD_IRQ |
+					ATMEL_HLCDC_LAYER_DSCR_IRQ;
+		}
+
+		if (plane_status &
+		    ATMEL_HLCDC_LAYER_DONE_IRQ &
+		    ~flip->dscrs[i]->ctrl) {
+			flip->dscrs[i]->status |=
+					ATMEL_HLCDC_DMA_CHANNEL_DSCR_DONE;
+			flip->dscrs[i]->ctrl |=
+					ATMEL_HLCDC_LAYER_DONE_IRQ;
+		}
+
+		if (plane_status & ATMEL_HLCDC_LAYER_OVR_IRQ)
+			flip->dscrs[i]->status |=
+					ATMEL_HLCDC_DMA_CHANNEL_DSCR_OVERRUN;
+
+		flip_status |= flip->dscrs[i]->status;
+	}
+
+	/* Get changed bits */
+	flip_status ^= flip->status;
+	flip->status |= flip_status;
+
+	if (flip_status & ATMEL_HLCDC_DMA_CHANNEL_DSCR_LOADED) {
+		atmel_hlcdc_layer_fb_flip_release_queue(layer, dma->cur);
+		dma->cur = dma->queue;
+		dma->queue = NULL;
+	}
+
+	if (flip_status & ATMEL_HLCDC_DMA_CHANNEL_DSCR_DONE) {
+		atmel_hlcdc_layer_fb_flip_release_queue(layer, dma->cur);
+		dma->cur = NULL;
+	}
+
+	if (flip_status & ATMEL_HLCDC_DMA_CHANNEL_DSCR_OVERRUN) {
+		regmap_write(regmap,
+			     desc->regs_offset + ATMEL_HLCDC_LAYER_CHDR,
+			     ATMEL_HLCDC_LAYER_RST);
+		if (dma->queue)
+			atmel_hlcdc_layer_fb_flip_release_queue(layer,
+								dma->queue);
+
+		if (dma->cur)
+			atmel_hlcdc_layer_fb_flip_release_queue(layer,
+								dma->cur);
+
+		dma->cur = NULL;
+		dma->queue = NULL;
+	}
+
+	if (!dma->queue) {
+		atmel_hlcdc_layer_update_apply(layer);
+
+		if (!dma->cur)
+			dma->status = ATMEL_HLCDC_LAYER_DISABLED;
+	}
+
+	spin_unlock_irqrestore(&layer->lock, flags);
+}
+
+int atmel_hlcdc_layer_disable(struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_dma_channel *dma = &layer->dma;
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	struct atmel_hlcdc_layer_fb_flip *flip;
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&layer->lock, flags);
+
+	/*
+	 * First disable DMA transfers. If a DMA transfer has been queued
+	 * we're stopping this one instead of the current one because we
+	 * can't know for sure if queued transfer has been started or not.
+	 */
+	flip = dma->queue ? dma->queue : dma->cur;
+	if (flip) {
+		for (i = 0; i < flip->ngems; i++)
+			flip->dscrs[i]->ctrl &= ~(ATMEL_HLCDC_LAYER_DFETCH |
+						  ATMEL_HLCDC_LAYER_DONE_IRQ);
+
+		dma->status = ATMEL_HLCDC_LAYER_DISABLING;
+	}
+
+	/*
+	 * Then discard the pending update request (if any) to prevent
+	 * DMA irq handler from restarting the DMA channel after it has
+	 * been disabled.
+	 */
+	if (upd->pending >= 0) {
+		atmel_hlcdc_layer_update_reset(layer, upd->pending);
+		upd->pending = -1;
+	}
+
+	spin_unlock_irqrestore(&layer->lock, flags);
+
+	return 0;
+}
+
+int atmel_hlcdc_layer_update_start(struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_dma_channel *dma = &layer->dma;
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	struct regmap *regmap = layer->hlcdc->regmap;
+	struct atmel_hlcdc_layer_fb_flip *fb_flip;
+	struct atmel_hlcdc_layer_update_slot *slot;
+	unsigned long flags;
+	int i, j = 0;
+
+	fb_flip = kzalloc(sizeof(*fb_flip), GFP_KERNEL);
+	if (!fb_flip)
+		return -ENOMEM;
+
+	fb_flip->task = drm_flip_work_allocate_task(fb_flip, GFP_KERNEL);
+	if (!fb_flip->task) {
+		kfree(fb_flip);
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&layer->lock, flags);
+
+	upd->next = upd->pending ? 0 : 1;
+
+	slot = &upd->slots[upd->next];
+
+	for (i = 0; i < layer->max_planes * 4; i++) {
+		if (!dma->dscrs[i].status) {
+			fb_flip->dscrs[j++] = &dma->dscrs[i];
+			dma->dscrs[i].status =
+				ATMEL_HLCDC_DMA_CHANNEL_DSCR_RESERVED;
+			if (j == layer->max_planes)
+				break;
+		}
+	}
+
+	if (j < layer->max_planes) {
+		for (i = 0; i < j; i++)
+			fb_flip->dscrs[i]->status = 0;
+	}
+
+	if (j < layer->max_planes) {
+		spin_unlock_irqrestore(&layer->lock, flags);
+		atmel_hlcdc_layer_fb_flip_destroy(fb_flip);
+		return -EBUSY;
+	}
+
+	slot->fb_flip = fb_flip;
+
+	if (upd->pending >= 0) {
+		memcpy(slot->configs,
+		       upd->slots[upd->pending].configs,
+		       layer->desc->nconfigs * sizeof(u32));
+		memcpy(slot->updated_configs,
+		       upd->slots[upd->pending].updated_configs,
+		       DIV_ROUND_UP(layer->desc->nconfigs,
+				    BITS_PER_BYTE * sizeof(unsigned long)) *
+		       sizeof(unsigned long));
+		slot->fb_flip->fb = upd->slots[upd->pending].fb_flip->fb;
+		if (upd->slots[upd->pending].fb_flip->fb) {
+			slot->fb_flip->fb =
+				upd->slots[upd->pending].fb_flip->fb;
+			slot->fb_flip->ngems =
+				upd->slots[upd->pending].fb_flip->ngems;
+			drm_framebuffer_reference(slot->fb_flip->fb);
+		}
+	} else {
+		regmap_bulk_read(regmap,
+				 layer->desc->regs_offset +
+				 ATMEL_HLCDC_LAYER_CFG(layer, 0),
+				 upd->slots[upd->next].configs,
+				 layer->desc->nconfigs);
+	}
+
+	spin_unlock_irqrestore(&layer->lock, flags);
+
+	return 0;
+}
+
+void atmel_hlcdc_layer_update_rollback(struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+
+	atmel_hlcdc_layer_update_reset(layer, upd->next);
+	upd->next = -1;
+}
+
+void atmel_hlcdc_layer_update_set_fb(struct atmel_hlcdc_layer *layer,
+				     struct drm_framebuffer *fb,
+				     unsigned int *offsets)
+{
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	struct atmel_hlcdc_layer_fb_flip *fb_flip;
+	struct atmel_hlcdc_layer_update_slot *slot;
+	struct atmel_hlcdc_dma_channel_dscr *dscr;
+	struct drm_framebuffer *old_fb;
+	int nplanes = 0;
+	int i;
+
+	if (upd->next < 0 || upd->next > 1)
+		return;
+
+	if (fb)
+		nplanes = drm_format_num_planes(fb->pixel_format);
+
+	if (nplanes > layer->max_planes)
+		return;
+
+	slot = &upd->slots[upd->next];
+
+	fb_flip = slot->fb_flip;
+	old_fb = slot->fb_flip->fb;
+
+	for (i = 0; i < nplanes; i++) {
+		struct drm_gem_cma_object *gem;
+
+		dscr = slot->fb_flip->dscrs[i];
+		gem = drm_fb_cma_get_gem_obj(fb, i);
+		dscr->addr = gem->paddr + offsets[i];
+	}
+
+	fb_flip->ngems = nplanes;
+	fb_flip->fb = fb;
+
+	if (fb)
+		drm_framebuffer_reference(fb);
+
+	if (old_fb)
+		drm_framebuffer_unreference(old_fb);
+}
+
+void atmel_hlcdc_layer_update_cfg(struct atmel_hlcdc_layer *layer, int cfg,
+				  u32 mask, u32 val)
+{
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	struct atmel_hlcdc_layer_update_slot *slot;
+
+	if (upd->next < 0 || upd->next > 1)
+		return;
+
+	if (cfg >= layer->desc->nconfigs)
+		return;
+
+	slot = &upd->slots[upd->next];
+	slot->configs[cfg] &= ~mask;
+	slot->configs[cfg] |= (val & mask);
+	set_bit(cfg, slot->updated_configs);
+}
+
+void atmel_hlcdc_layer_update_commit(struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_dma_channel *dma = &layer->dma;
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	struct atmel_hlcdc_layer_update_slot *slot;
+	unsigned long flags;
+
+	if (upd->next < 0  || upd->next > 1)
+		return;
+
+	slot = &upd->slots[upd->next];
+
+	spin_lock_irqsave(&layer->lock, flags);
+
+	/*
+	 * Release pending update request and replace it by the new one.
+	 */
+	if (upd->pending >= 0)
+		atmel_hlcdc_layer_update_reset(layer, upd->pending);
+
+	upd->pending = upd->next;
+	upd->next = -1;
+
+	if (!dma->queue)
+		atmel_hlcdc_layer_update_apply(layer);
+
+	spin_unlock_irqrestore(&layer->lock, flags);
+
+
+	upd->next = -1;
+}
+
+static int atmel_hlcdc_layer_dma_init(struct drm_device *dev,
+				      struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_dma_channel *dma = &layer->dma;
+	dma_addr_t dma_addr;
+	int i;
+
+	dma->dscrs = dma_alloc_coherent(dev->dev,
+					layer->max_planes * 4 *
+					sizeof(*dma->dscrs),
+					&dma_addr, GFP_KERNEL);
+	if (!dma->dscrs)
+		return -ENOMEM;
+
+	for (i = 0; i < layer->max_planes * 4; i++) {
+		struct atmel_hlcdc_dma_channel_dscr *dscr = &dma->dscrs[i];
+
+		dscr->next = dma_addr + (i * sizeof(*dscr));
+	}
+
+	return 0;
+}
+
+static void atmel_hlcdc_layer_dma_cleanup(struct drm_device *dev,
+					  struct atmel_hlcdc_layer *layer)
+{
+	struct atmel_hlcdc_layer_dma_channel *dma = &layer->dma;
+	int i;
+
+	for (i = 0; i < layer->max_planes * 4; i++) {
+		struct atmel_hlcdc_dma_channel_dscr *dscr = &dma->dscrs[i];
+
+		dscr->status = 0;
+	}
+
+	dma_free_coherent(dev->dev, layer->max_planes * 4 *
+			  sizeof(*dma->dscrs), dma->dscrs,
+			  dma->dscrs[0].next);
+}
+
+static int atmel_hlcdc_layer_update_init(struct drm_device *dev,
+				struct atmel_hlcdc_layer *layer,
+				const struct atmel_hlcdc_layer_desc *desc)
+{
+	struct atmel_hlcdc_layer_update *upd = &layer->update;
+	int updated_size;
+	void *buffer;
+	int i;
+
+	updated_size = DIV_ROUND_UP(desc->nconfigs,
+				    BITS_PER_BYTE *
+				    sizeof(unsigned long));
+
+	buffer = devm_kzalloc(dev->dev,
+			      ((desc->nconfigs * sizeof(u32)) +
+				(updated_size * sizeof(unsigned long))) * 2,
+			      GFP_KERNEL);
+	if (!buffer)
+		return -ENOMEM;
+
+	for (i = 0; i < 2; i++) {
+		upd->slots[i].updated_configs = buffer;
+		buffer += updated_size * sizeof(unsigned long);
+		upd->slots[i].configs = buffer;
+		buffer += desc->nconfigs * sizeof(u32);
+	}
+
+	upd->pending = -1;
+	upd->next = -1;
+
+	return 0;
+}
+
+int atmel_hlcdc_layer_init(struct drm_device *dev,
+			   struct atmel_hlcdc_layer *layer,
+			   const struct atmel_hlcdc_layer_desc *desc)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	struct regmap *regmap = dc->hlcdc->regmap;
+	unsigned int tmp;
+	int ret;
+	int i;
+
+	layer->hlcdc = dc->hlcdc;
+	layer->wq = dc->wq;
+	layer->desc = desc;
+
+	regmap_write(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_CHDR,
+		     ATMEL_HLCDC_LAYER_RST);
+	for (i = 0; i < desc->formats->nformats; i++) {
+		int nplanes = drm_format_num_planes(desc->formats->formats[i]);
+
+		if (nplanes > layer->max_planes)
+			layer->max_planes = nplanes;
+	}
+
+	spin_lock_init(&layer->lock);
+	drm_flip_work_init(&layer->gc, desc->name,
+			   atmel_hlcdc_layer_fb_flip_release);
+	ret = atmel_hlcdc_layer_dma_init(dev, layer);
+	if (ret)
+		return ret;
+
+	ret = atmel_hlcdc_layer_update_init(dev, layer, desc);
+	if (ret)
+		return ret;
+
+	/* Flush Status Register */
+	regmap_write(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_IDR,
+		     0xffffffff);
+	regmap_read(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_ISR,
+		    &tmp);
+
+	tmp = 0;
+	for (i = 0; i < layer->max_planes; i++)
+		tmp |= (ATMEL_HLCDC_LAYER_DMA_IRQ |
+			ATMEL_HLCDC_LAYER_DSCR_IRQ |
+			ATMEL_HLCDC_LAYER_ADD_IRQ |
+			ATMEL_HLCDC_LAYER_DONE_IRQ |
+			ATMEL_HLCDC_LAYER_OVR_IRQ) << (8 * i);
+
+	regmap_write(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_IER, tmp);
+
+	return 0;
+}
+
+void atmel_hlcdc_layer_cleanup(struct drm_device *dev,
+			       struct atmel_hlcdc_layer *layer)
+{
+	const struct atmel_hlcdc_layer_desc *desc = layer->desc;
+	struct regmap *regmap = layer->hlcdc->regmap;
+
+	regmap_write(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_IDR,
+		     0xffffffff);
+	regmap_write(regmap, desc->regs_offset + ATMEL_HLCDC_LAYER_CHDR,
+		     ATMEL_HLCDC_LAYER_RST);
+
+	atmel_hlcdc_layer_dma_cleanup(dev, layer);
+	drm_flip_work_cleanup(&layer->gc);
+}
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
new file mode 100644
index 0000000..01fcf96
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_layer.h
@@ -0,0 +1,394 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef DRM_ATMEL_HLCDC_LAYER_H
+#define DRM_ATMEL_HLCDC_LAYER_H
+
+#include <linux/mfd/atmel-hlcdc.h>
+
+#include <drm/drm_crtc.h>
+#include <drm/drm_flip_work.h>
+#include <drm/drmP.h>
+
+#define ATMEL_HLCDC_LAYER_CHER			0x0
+#define ATMEL_HLCDC_LAYER_CHDR			0x4
+#define ATMEL_HLCDC_LAYER_CHSR			0x8
+#define ATMEL_HLCDC_LAYER_DMA_CHAN		BIT(0)
+#define ATMEL_HLCDC_LAYER_UPDATE		BIT(1)
+#define ATMEL_HLCDC_LAYER_A2Q			BIT(2)
+#define ATMEL_HLCDC_LAYER_RST			BIT(8)
+
+#define ATMEL_HLCDC_LAYER_IER			0xc
+#define ATMEL_HLCDC_LAYER_IDR			0x10
+#define ATMEL_HLCDC_LAYER_IMR			0x14
+#define ATMEL_HLCDC_LAYER_ISR			0x18
+#define ATMEL_HLCDC_LAYER_DFETCH		BIT(0)
+#define ATMEL_HLCDC_LAYER_LFETCH		BIT(1)
+#define ATMEL_HLCDC_LAYER_DMA_IRQ		BIT(2)
+#define ATMEL_HLCDC_LAYER_DSCR_IRQ		BIT(3)
+#define ATMEL_HLCDC_LAYER_ADD_IRQ		BIT(4)
+#define ATMEL_HLCDC_LAYER_DONE_IRQ		BIT(5)
+#define ATMEL_HLCDC_LAYER_OVR_IRQ		BIT(6)
+
+#define ATMEL_HLCDC_LAYER_PLANE_HEAD(n)		(((n) * 0x10) + 0x1c)
+#define ATMEL_HLCDC_LAYER_PLANE_ADDR(n)		(((n) * 0x10) + 0x20)
+#define ATMEL_HLCDC_LAYER_PLANE_CTRL(n)		(((n) * 0x10) + 0x24)
+#define ATMEL_HLCDC_LAYER_PLANE_NEXT(n)		(((n) * 0x10) + 0x28)
+#define ATMEL_HLCDC_LAYER_CFG(p, c)		(((c) * 4) + ((p)->max_planes * 0x10) + 0x1c)
+
+#define ATMEL_HLCDC_LAYER_DMA_CFG_ID		0
+#define ATMEL_HLCDC_LAYER_DMA_CFG(p)		ATMEL_HLCDC_LAYER_CFG(p, ATMEL_HLCDC_LAYER_DMA_CFG_ID)
+#define ATMEL_HLCDC_LAYER_DMA_SIF		BIT(0)
+#define ATMEL_HLCDC_LAYER_DMA_BLEN_MASK		GENMASK(5, 4)
+#define ATMEL_HLCDC_LAYER_DMA_DLBO		BIT(8)
+#define ATMEL_HLCDC_LAYER_DMA_ROTDIS		BIT(12)
+#define ATMEL_HLCDC_LAYER_DMA_LOCKDIS		BIT(13)
+
+#define ATMEL_HLCDC_LAYER_FORMAT_CFG_ID		1
+#define ATMEL_HLCDC_LAYER_FORMAT_CFG(p)		ATMEL_HLCDC_LAYER_CFG(p, ATMEL_HLCDC_LAYER_FORMAT_CFG_ID)
+#define ATMEL_HLCDC_LAYER_RGB			(0 << 0)
+#define ATMEL_HLCDC_LAYER_CLUT			(1 << 0)
+#define ATMEL_HLCDC_LAYER_YUV			(2 << 0)
+#define ATMEL_HLCDC_RGB_MODE(m)			(((m) & 0xf) << 4)
+#define ATMEL_HLCDC_CLUT_MODE(m)		(((m) & 0x3) << 8)
+#define ATMEL_HLCDC_YUV_MODE(m)			(((m) & 0xf) << 12)
+#define ATMEL_HLCDC_YUV422ROT			(1 << 16)
+#define ATMEL_HLCDC_YUV422SWP			(1 << 17)
+#define ATMEL_HLCDC_DSCALEOPT			(1 << 20)
+
+#define ATMEL_HLCDC_XRGB4444_MODE		(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(0))
+#define ATMEL_HLCDC_ARGB4444_MODE		(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(1))
+#define ATMEL_HLCDC_RGBA4444_MODE		(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(2))
+#define ATMEL_HLCDC_RGB565_MODE			(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(3))
+#define ATMEL_HLCDC_ARGB1555_MODE		(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(4))
+#define ATMEL_HLCDC_XRGB8888_MODE		(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(9))
+#define ATMEL_HLCDC_RGB888_MODE			(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(10))
+#define ATMEL_HLCDC_ARGB8888_MODE		(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(12))
+#define ATMEL_HLCDC_RGBA8888_MODE		(ATMEL_HLCDC_LAYER_RGB | ATMEL_HLCDC_RGB_MODE(13))
+
+#define ATMEL_HLCDC_AYUV_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(0))
+#define ATMEL_HLCDC_YUYV_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(1))
+#define ATMEL_HLCDC_UYVY_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(2))
+#define ATMEL_HLCDC_YVYU_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(3))
+#define ATMEL_HLCDC_VYUY_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(4))
+#define ATMEL_HLCDC_NV61_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(5))
+#define ATMEL_HLCDC_YUV422_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(6))
+#define ATMEL_HLCDC_NV21_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(7))
+#define ATMEL_HLCDC_YUV420_MODE			(ATMEL_HLCDC_LAYER_YUV | ATMEL_HLCDC_YUV_MODE(8))
+
+#define ATMEL_HLCDC_LAYER_POS_CFG(p)		ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.pos)
+#define ATMEL_HLCDC_LAYER_SIZE_CFG(p)		ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.size)
+#define ATMEL_HLCDC_LAYER_MEMSIZE_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.memsize)
+#define ATMEL_HLCDC_LAYER_XSTRIDE_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.xstride)
+#define ATMEL_HLCDC_LAYER_PSTRIDE_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.pstride)
+#define ATMEL_HLCDC_LAYER_DFLTCOLOR_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.default_color)
+#define ATMEL_HLCDC_LAYER_CRKEY_CFG(p)		ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.chroma_key)
+#define ATMEL_HLCDC_LAYER_CRKEY_MASK_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.chroma_key_mask)
+
+#define ATMEL_HLCDC_LAYER_GENERAL_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.general_config)
+#define ATMEL_HLCDC_LAYER_CRKEY			BIT(0)
+#define ATMEL_HLCDC_LAYER_INV			BIT(1)
+#define ATMEL_HLCDC_LAYER_ITER2BL		BIT(2)
+#define ATMEL_HLCDC_LAYER_ITER			BIT(3)
+#define ATMEL_HLCDC_LAYER_REVALPHA		BIT(4)
+#define ATMEL_HLCDC_LAYER_GAEN			BIT(5)
+#define ATMEL_HLCDC_LAYER_LAEN			BIT(6)
+#define ATMEL_HLCDC_LAYER_OVR			BIT(7)
+#define ATMEL_HLCDC_LAYER_DMA			BIT(8)
+#define ATMEL_HLCDC_LAYER_REP			BIT(9)
+#define ATMEL_HLCDC_LAYER_DSTKEY		BIT(10)
+#define ATMEL_HLCDC_LAYER_DISCEN		BIT(11)
+#define ATMEL_HLCDC_LAYER_GA_MASK		GENMASK(23, 16)
+#define ATMEL_HLCDC_LAYER_GA_SHIFT		16
+
+#define ATMEL_HLCDC_LAYER_CSC_CFG(p, o)		ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.csc + o)
+
+#define ATMEL_HLCDC_LAYER_DISC_POS_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.disc_pos)
+
+#define ATMEL_HLCDC_LAYER_DISC_SIZE_CFG(p)	ATMEL_HLCDC_LAYER_CFG(p, (p)->desc->layout.disc_size)
+
+#define ATMEL_HLCDC_MAX_PLANES			3
+
+#define ATMEL_HLCDC_DMA_CHANNEL_DSCR_RESERVED	BIT(0)
+#define ATMEL_HLCDC_DMA_CHANNEL_DSCR_LOADED	BIT(1)
+#define ATMEL_HLCDC_DMA_CHANNEL_DSCR_DONE	BIT(2)
+#define ATMEL_HLCDC_DMA_CHANNEL_DSCR_OVERRUN	BIT(3)
+
+/**
+ * Atmel HLCDC Layer registers layout structure
+ *
+ * Each HLCDC layer has its own register organization and a given register
+ * by be placed differently on 2 different layers depending on its
+ * capabilities.
+ * This structure stores common registers layout for a given layer and is
+ * used by HLCDC layer code to chose the appropriate register to write to
+ * or to read from.
+ *
+ * For all fields, a value of zero means "unsupported".
+ *
+ * See Atmel's datasheet for a detailled description of these registers.
+ *
+ * @xstride: xstride registers
+ * @pstride: pstride registers
+ * @pos: position register
+ * @size: displayed size register
+ * @memsize: memory size register
+ * @default_color: default color register
+ * @chroma_key: chroma key register
+ * @chroma_key_mask: chroma key mask register
+ * @general_config: general layer config register
+ * @disc_pos: discard area position register
+ * @disc_size: discard area size register
+ * @csc: color space conversion register
+ */
+struct atmel_hlcdc_layer_cfg_layout {
+	int xstride[ATMEL_HLCDC_MAX_PLANES];
+	int pstride[ATMEL_HLCDC_MAX_PLANES];
+	int pos;
+	int size;
+	int memsize;
+	int default_color;
+	int chroma_key;
+	int chroma_key_mask;
+	int general_config;
+	int disc_pos;
+	int disc_size;
+	int csc;
+};
+
+/**
+ * Atmel HLCDC framebuffer flip structure
+ *
+ * This structure is allocated when someone asked for a layer update (most
+ * likely a DRM plane update, either primary, overlay or cursor plane) and
+ * released when the layer do not need to reference the framebuffer object
+ * anymore (i.e. the layer was disabled or updated).
+ *
+ * @fb: the referenced framebuffer object.
+ * @refcnt: the number of GEM object still referenced by the layer.
+ *	    When no more objects are referenced the fb flip structure is
+ *	    added to the garbage collector.
+ * @ngems: number of GEM objects referenced by the fb element.
+ */
+struct atmel_hlcdc_layer_fb_flip {
+	struct atmel_hlcdc_dma_channel_dscr *dscrs[ATMEL_HLCDC_MAX_PLANES];
+	struct drm_flip_task *task;
+	struct drm_framebuffer *fb;
+	int ngems;
+	u32 status;
+};
+
+/**
+ * Atmel HLCDC DMA descriptor structure
+ *
+ * This structure is used by the HLCDC DMA engine to schedule a DMA transfer.
+ *
+ * The structure fields must remain in this specific order, because they're
+ * used by the HLCDC DMA engine, which expect them in this order.
+ *
+ * @addr: buffer DMA address
+ * @ctrl: DMA transfer options
+ * @next: next DMA descriptor to fetch
+ * @gem_flip: the attached gem_flip operation
+ */
+struct atmel_hlcdc_dma_channel_dscr {
+	dma_addr_t addr;
+	u32 ctrl;
+	dma_addr_t next;
+	u32 status;
+} __aligned(sizeof(u64));
+
+/**
+ * Atmel HLCDC layer types
+ */
+enum atmel_hlcdc_layer_type {
+	ATMEL_HLCDC_BASE_LAYER,
+	ATMEL_HLCDC_OVERLAY_LAYER,
+	ATMEL_HLCDC_CURSOR_LAYER,
+	ATMEL_HLCDC_PP_LAYER,
+};
+
+/**
+ * Atmel HLCDC Supported formats structure
+ *
+ * This structure list all the formats supported by a given layer.
+ *
+ * @nformats: number of supported formats
+ * @formats: supported formats
+ */
+struct atmel_hlcdc_formats {
+	int nformats;
+	uint32_t *formats;
+};
+
+/**
+ * Atmel HLCDC Layer description structure
+ *
+ * This structure describe the capabilities provided by a given layer.
+ *
+ * @name: layer name
+ * @type: layer type
+ * @id: layer id
+ * @regs_offset: offset of the layer registers from the HLCDC registers base
+ * @nconfigs: number of config registers provided by this layer
+ * @layout: config registers layout
+ * @max_width: maximum width supported by this layer (0 means unlimited)
+ * @max_height: maximum height supported by this layer (0 means unlimited)
+ */
+struct atmel_hlcdc_layer_desc {
+	const char *name;
+	enum atmel_hlcdc_layer_type type;
+	int id;
+	int regs_offset;
+	int nconfigs;
+	struct atmel_hlcdc_formats *formats;
+	struct atmel_hlcdc_layer_cfg_layout layout;
+	int max_width;
+	int max_height;
+};
+
+/**
+ * Atmel HLCDC Layer Update Slot structure
+ *
+ * This structure stores layer update requests to be applied on next frame.
+ * This is the base structure behind the atomic layer update infrastructure.
+ *
+ * Atomic layer update provides a way to update all layer's parameters
+ * simultaneously. This is needed to avoid incompatible sequential updates
+ * like this one:
+ * 1) update layer format from RGB888 (1 plane/buffer) to YUV422
+ *    (2 planes/buffers)
+ * 2) the format update is applied but the DMA channel for the second
+ *    plane/buffer is not enabled
+ * 3) enable the DMA channel for the second plane
+ *
+ * @dscrs: DMA channel descriptors
+ * @fb_flip: fb_flip object
+ * @updated_configs: bitmask used to record modified configs
+ * @configs: new config values
+ */
+struct atmel_hlcdc_layer_update_slot {
+	struct atmel_hlcdc_layer_fb_flip *fb_flip;
+	unsigned long *updated_configs;
+	u32 *configs;
+};
+
+/**
+ * Atmel HLCDC Layer Update structure
+ *
+ * This structure provides a way to queue layer update requests.
+ *
+ * At a given time there is at most:
+ *  - one pending update request, which means the update request has been
+ *    commited (or validated) and is waiting for the DMA channel(s) to be
+ *    available
+ *  - one request being prepared, which means someone started a layer update
+ *    but has not commited it yet. There cannot be more than one started
+ *    request, because the update lock is taken when starting a layer update
+ *    and release when commiting or rolling back the request.
+ *
+ * @slots: update slots. One is used for pending request and the other one
+ *	   for started update request
+ * @pending: the pending slot index or -1 if no request is pending
+ * @next: the started update slot index or -1 no update has been started
+ */
+struct atmel_hlcdc_layer_update {
+	struct atmel_hlcdc_layer_update_slot slots[2];
+	int pending;
+	int next;
+};
+
+enum atmel_hlcdc_layer_dma_channel_status {
+	ATMEL_HLCDC_LAYER_DISABLED,
+	ATMEL_HLCDC_LAYER_ENABLED,
+	ATMEL_HLCDC_LAYER_DISABLING,
+};
+
+/**
+ * Atmel HLCDC Layer DMA channel structure
+ *
+ * This structure stores informations on the DMA channel associated to a
+ * given layer.
+ *
+ * @status: DMA channel status
+ * @cur: current framebuffer
+ * @queue: next framebuffer
+ * @dscrs: allocated DMA descriptors
+ */
+struct atmel_hlcdc_layer_dma_channel {
+	enum atmel_hlcdc_layer_dma_channel_status status;
+	struct atmel_hlcdc_layer_fb_flip *cur;
+	struct atmel_hlcdc_layer_fb_flip *queue;
+	struct atmel_hlcdc_dma_channel_dscr *dscrs;
+};
+
+/**
+ * Atmel HLCDC Layer structure
+ *
+ * This structure stores information on the layer instance.
+ *
+ * @desc: layer description
+ * @max_planes: maximum planes/buffers that can be associated with this layer.
+ *	       This depends on the supported formats.
+ * @hlcdc: pointer to the atmel_hlcdc structure provided by the MFD device
+ * @dma: dma channel
+ * @gc: fb flip garbage collector
+ * @update: update handler
+ * @lock: layer lock
+ */
+struct atmel_hlcdc_layer {
+	const struct atmel_hlcdc_layer_desc *desc;
+	int max_planes;
+	struct atmel_hlcdc *hlcdc;
+	struct workqueue_struct *wq;
+	struct drm_flip_work gc;
+	struct atmel_hlcdc_layer_dma_channel dma;
+	struct atmel_hlcdc_layer_update update;
+	spinlock_t lock;
+};
+
+void atmel_hlcdc_layer_irq(struct atmel_hlcdc_layer *layer);
+
+int atmel_hlcdc_layer_init(struct drm_device *dev,
+			   struct atmel_hlcdc_layer *layer,
+			   const struct atmel_hlcdc_layer_desc *desc);
+
+void atmel_hlcdc_layer_cleanup(struct drm_device *dev,
+			       struct atmel_hlcdc_layer *layer);
+
+int atmel_hlcdc_layer_disable(struct atmel_hlcdc_layer *layer);
+
+int atmel_hlcdc_layer_update_start(struct atmel_hlcdc_layer *layer);
+
+void atmel_hlcdc_layer_update_cfg(struct atmel_hlcdc_layer *layer, int cfg,
+				  u32 mask, u32 val);
+
+void atmel_hlcdc_layer_update_set_fb(struct atmel_hlcdc_layer *layer,
+				     struct drm_framebuffer *fb,
+				     unsigned int *offsets);
+
+void atmel_hlcdc_layer_update_set_finished(struct atmel_hlcdc_layer *layer,
+					   void (*finished)(void *data),
+					   void *finished_data);
+
+void atmel_hlcdc_layer_update_rollback(struct atmel_hlcdc_layer *layer);
+
+void atmel_hlcdc_layer_update_commit(struct atmel_hlcdc_layer *layer);
+
+#endif /* DRM_ATMEL_HLCDC_LAYER_H */
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
new file mode 100644
index 0000000..8d3a5cb
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_output.c
@@ -0,0 +1,443 @@
+/*
+ * Copyright (C) 2014 Traphandler
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/of_graph.h>
+
+#include <drm/drmP.h>
+#include <drm/drm_panel.h>
+
+#include "atmel_hlcdc_dc.h"
+
+/**
+ * Atmel HLCDC RGB output mode
+ */
+enum atmel_hlcdc_connector_rgb_mode {
+	ATMEL_HLCDC_CONNECTOR_RGB444,
+	ATMEL_HLCDC_CONNECTOR_RGB565,
+	ATMEL_HLCDC_CONNECTOR_RGB666,
+	ATMEL_HLCDC_CONNECTOR_RGB888,
+};
+
+struct atmel_hlcdc_slave;
+
+/**
+ * Atmel HLCDC Slave device operations structure
+ *
+ * This structure defines an abstraction to be implemented by each slave
+ * device type (panel, convertors, ...).
+ *
+ * @enable: Enable the slave device
+ * @disable: Disable the slave device
+ * @get_modes: retrieve modes supported by the slave device
+ * @destroy: detroy the slave device and all associated data
+ */
+struct atmel_hlcdc_slave_ops {
+	int (*enable)(struct atmel_hlcdc_slave *slave);
+	int (*disable)(struct atmel_hlcdc_slave *slave);
+	int (*get_modes)(struct atmel_hlcdc_slave *slave);
+	int (*mode_valid)(struct atmel_hlcdc_slave *slave,
+			  struct drm_display_mode *mode);
+	void (*destroy)(struct atmel_hlcdc_slave *slave);
+};
+
+/**
+ * Atmel HLCDC Slave device structure
+ *
+ * This structure is the base slave device structure to be overloaded by
+ * each slave device implementation.
+ *
+ * @ops: slave device operations
+ */
+struct atmel_hlcdc_slave {
+	const struct atmel_hlcdc_slave_ops *ops;
+};
+
+/**
+ * Atmel HLCDC Panel device structure
+ *
+ * This structure is specialization of the slave device structure to
+ * interface with drm panels.
+ *
+ * @slave: base slave device fields
+ * @panel: drm panel attached to this slave device
+ */
+struct atmel_hlcdc_panel {
+	struct atmel_hlcdc_slave slave;
+	struct drm_panel *panel;
+};
+
+static inline struct atmel_hlcdc_panel *
+atmel_hlcdc_slave_to_panel(struct atmel_hlcdc_slave *slave)
+{
+	return container_of(slave, struct atmel_hlcdc_panel, slave);
+}
+
+/**
+ * Atmel HLCDC RGB connector structure
+ *
+ * This structure stores informations about an DRM panel connected through
+ * the RGB connector.
+ *
+ * @connector: DRM connector
+ * @encoder: DRM encoder
+ * @hlcdc: pointer to the atmel_hlcdc structure provided by the MFD device
+ * @slave: slave device connected to this output
+ * @endpoint: DT endpoint representing this output
+ * @dpms: current DPMS mode
+ */
+struct atmel_hlcdc_rgb_output {
+	struct drm_connector connector;
+	struct drm_encoder encoder;
+	struct atmel_hlcdc_dc *dc;
+	struct atmel_hlcdc_slave *slave;
+	struct of_endpoint endpoint;
+	int dpms;
+};
+
+static inline struct atmel_hlcdc_rgb_output *
+drm_connector_to_atmel_hlcdc_rgb_output(struct drm_connector *connector)
+{
+	return container_of(connector, struct atmel_hlcdc_rgb_output,
+			    connector);
+}
+
+static inline struct atmel_hlcdc_rgb_output *
+drm_encoder_to_atmel_hlcdc_rgb_output(struct drm_encoder *encoder)
+{
+	return container_of(encoder, struct atmel_hlcdc_rgb_output, encoder);
+}
+
+static int atmel_hlcdc_panel_enable(struct atmel_hlcdc_slave *slave)
+{
+	struct atmel_hlcdc_panel *panel = atmel_hlcdc_slave_to_panel(slave);
+
+	return drm_panel_enable(panel->panel);
+}
+
+static int atmel_hlcdc_panel_disable(struct atmel_hlcdc_slave *slave)
+{
+	struct atmel_hlcdc_panel *panel = atmel_hlcdc_slave_to_panel(slave);
+
+	return drm_panel_disable(panel->panel);
+}
+
+static int atmel_hlcdc_panel_get_modes(struct atmel_hlcdc_slave *slave)
+{
+	struct atmel_hlcdc_panel *panel = atmel_hlcdc_slave_to_panel(slave);
+
+	return panel->panel->funcs->get_modes(panel->panel);
+}
+
+static int atmel_hlcdc_panel_mode_valid(struct atmel_hlcdc_slave *slave,
+					struct drm_display_mode *mode)
+{
+	return MODE_OK;
+}
+
+static void atmel_hlcdc_panel_destroy(struct atmel_hlcdc_slave *slave)
+{
+	struct atmel_hlcdc_panel *panel = atmel_hlcdc_slave_to_panel(slave);
+
+	drm_panel_detach(panel->panel);
+	kfree(panel);
+}
+
+static const struct atmel_hlcdc_slave_ops atmel_hlcdc_panel_ops = {
+	.enable = atmel_hlcdc_panel_enable,
+	.disable = atmel_hlcdc_panel_disable,
+	.get_modes = atmel_hlcdc_panel_get_modes,
+	.mode_valid = atmel_hlcdc_panel_mode_valid,
+	.destroy = atmel_hlcdc_panel_destroy,
+};
+
+static struct atmel_hlcdc_slave *
+atmel_hlcdc_panel_detect(struct atmel_hlcdc_rgb_output *rgb)
+{
+	struct device_node *np;
+	struct drm_panel *p = NULL;
+	struct atmel_hlcdc_panel *panel;
+
+	np = of_graph_get_remote_port_parent(rgb->endpoint.local_node);
+	if (!np)
+		return NULL;
+
+	p = of_drm_find_panel(np);
+	of_node_put(np);
+
+	if (p) {
+		panel = kzalloc(sizeof(*panel), GFP_KERNEL);
+		if (!panel)
+			return NULL;
+
+		drm_panel_attach(p, &rgb->connector);
+		panel->panel = p;
+		panel->slave.ops = &atmel_hlcdc_panel_ops;
+		return &panel->slave;
+	}
+
+	return NULL;
+}
+
+static void atmel_hlcdc_rgb_encoder_dpms(struct drm_encoder *encoder,
+					 int mode)
+{
+	struct atmel_hlcdc_rgb_output *rgb =
+			drm_encoder_to_atmel_hlcdc_rgb_output(encoder);
+
+	if (mode != DRM_MODE_DPMS_ON)
+		mode = DRM_MODE_DPMS_OFF;
+
+	if (mode == rgb->dpms)
+		return;
+
+	if (mode != DRM_MODE_DPMS_ON)
+		rgb->slave->ops->disable(rgb->slave);
+	else
+		rgb->slave->ops->enable(rgb->slave);
+
+	rgb->dpms = mode;
+}
+
+static bool
+atmel_hlcdc_rgb_encoder_mode_fixup(struct drm_encoder *encoder,
+				   const struct drm_display_mode *mode,
+				   struct drm_display_mode *adjusted)
+{
+	return true;
+}
+
+static void atmel_hlcdc_rgb_encoder_prepare(struct drm_encoder *encoder)
+{
+	atmel_hlcdc_rgb_encoder_dpms(encoder, DRM_MODE_DPMS_OFF);
+}
+
+static void atmel_hlcdc_rgb_encoder_commit(struct drm_encoder *encoder)
+{
+	atmel_hlcdc_rgb_encoder_dpms(encoder, DRM_MODE_DPMS_ON);
+}
+
+static void
+atmel_hlcdc_rgb_encoder_mode_set(struct drm_encoder *encoder,
+				 struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted)
+{
+	struct atmel_hlcdc_rgb_output *rgb =
+			drm_encoder_to_atmel_hlcdc_rgb_output(encoder);
+	struct drm_display_info *info = &rgb->connector.display_info;
+	unsigned int cfg;
+
+	cfg = 0;
+
+	if (info->num_bus_formats) {
+		switch (info->bus_formats[0]) {
+		case VIDEO_BUS_FMT_RGB565_1X16:
+			cfg |= ATMEL_HLCDC_CONNECTOR_RGB565 << 8;
+			break;
+		case VIDEO_BUS_FMT_RGB666_1X18:
+			cfg |= ATMEL_HLCDC_CONNECTOR_RGB666 << 8;
+			break;
+		case VIDEO_BUS_FMT_RGB888_1X24:
+			cfg |= ATMEL_HLCDC_CONNECTOR_RGB888 << 8;
+			break;
+		case VIDEO_BUS_FMT_RGB444_1X12:
+		default:
+			break;
+		}
+	}
+
+	regmap_update_bits(rgb->dc->hlcdc->regmap, ATMEL_HLCDC_CFG(5),
+			   ATMEL_HLCDC_MODE_MASK,
+			   cfg);
+}
+
+static struct drm_encoder_helper_funcs atmel_hlcdc_rgb_encoder_helper_funcs = {
+	.dpms = atmel_hlcdc_rgb_encoder_dpms,
+	.mode_fixup = atmel_hlcdc_rgb_encoder_mode_fixup,
+	.prepare = atmel_hlcdc_rgb_encoder_prepare,
+	.commit = atmel_hlcdc_rgb_encoder_commit,
+	.mode_set = atmel_hlcdc_rgb_encoder_mode_set,
+};
+
+static void atmel_hlcdc_rgb_encoder_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+	memset(encoder, 0, sizeof(*encoder));
+}
+
+static const struct drm_encoder_funcs atmel_hlcdc_rgb_encoder_funcs = {
+	.destroy = atmel_hlcdc_rgb_encoder_destroy,
+};
+
+static int atmel_hlcdc_rgb_get_modes(struct drm_connector *connector)
+{
+	struct atmel_hlcdc_rgb_output *rgb =
+			drm_connector_to_atmel_hlcdc_rgb_output(connector);
+
+	return rgb->slave->ops->get_modes(rgb->slave);
+}
+
+static int atmel_hlcdc_rgb_mode_valid(struct drm_connector *connector,
+				      struct drm_display_mode *mode)
+{
+	struct atmel_hlcdc_rgb_output *rgb =
+			drm_connector_to_atmel_hlcdc_rgb_output(connector);
+	int ret;
+
+	ret = atmel_hlcdc_dc_mode_valid(rgb->dc, mode);
+	if (ret != MODE_OK)
+		return ret;
+
+	return rgb->slave->ops->mode_valid(rgb->slave, mode);
+}
+
+static struct drm_encoder *
+atmel_hlcdc_rgb_best_encoder(struct drm_connector *connector)
+{
+	struct atmel_hlcdc_rgb_output *rgb =
+			drm_connector_to_atmel_hlcdc_rgb_output(connector);
+
+	return &rgb->encoder;
+}
+
+static struct drm_connector_helper_funcs atmel_hlcdc_rgb_connector_helper_funcs = {
+	.get_modes = atmel_hlcdc_rgb_get_modes,
+	.mode_valid = atmel_hlcdc_rgb_mode_valid,
+	.best_encoder = atmel_hlcdc_rgb_best_encoder,
+};
+
+static enum drm_connector_status
+atmel_hlcdc_rgb_connector_detect(struct drm_connector *connector, bool force)
+{
+	struct atmel_hlcdc_rgb_output *rgb =
+			drm_connector_to_atmel_hlcdc_rgb_output(connector);
+
+	if (!rgb->slave) {
+		/* At the moment we only support panel devices */
+		rgb->slave = atmel_hlcdc_panel_detect(rgb);
+	}
+
+	if (rgb->slave)
+		return connector_status_connected;
+
+	return connector_status_unknown;
+}
+
+static void
+atmel_hlcdc_rgb_connector_destroy(struct drm_connector *connector)
+{
+	struct atmel_hlcdc_rgb_output *rgb =
+			drm_connector_to_atmel_hlcdc_rgb_output(connector);
+
+	if (rgb->slave && rgb->slave->ops->destroy)
+		rgb->slave->ops->destroy(rgb->slave);
+
+	drm_connector_unregister(&rgb->connector);
+	drm_connector_cleanup(connector);
+}
+
+static const struct drm_connector_funcs atmel_hlcdc_rgb_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.detect = atmel_hlcdc_rgb_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = atmel_hlcdc_rgb_connector_destroy,
+};
+
+static int atmel_hlcdc_create_output(struct drm_device *dev,
+				     struct of_endpoint *ep)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	struct atmel_hlcdc_rgb_output *rgb;
+	int ret;
+
+	rgb = devm_kzalloc(dev->dev, sizeof(*rgb), GFP_KERNEL);
+	if (!rgb)
+		return -ENOMEM;
+
+	rgb->endpoint = *ep;
+
+	rgb->dpms = DRM_MODE_DPMS_OFF;
+
+	rgb->dc = dc;
+
+	drm_encoder_helper_add(&rgb->encoder,
+			       &atmel_hlcdc_rgb_encoder_helper_funcs);
+	ret = drm_encoder_init(dev, &rgb->encoder,
+			       &atmel_hlcdc_rgb_encoder_funcs,
+			       DRM_MODE_ENCODER_LVDS);
+	if (ret)
+		return ret;
+
+	rgb->connector.dpms = DRM_MODE_DPMS_OFF;
+	rgb->connector.polled = DRM_CONNECTOR_POLL_CONNECT;
+	drm_connector_helper_add(&rgb->connector,
+				 &atmel_hlcdc_rgb_connector_helper_funcs);
+	ret = drm_connector_init(dev, &rgb->connector,
+				 &atmel_hlcdc_rgb_connector_funcs,
+				 DRM_MODE_CONNECTOR_LVDS);
+	if (ret)
+		goto err_encoder_cleanup;
+
+	drm_mode_connector_attach_encoder(&rgb->connector, &rgb->encoder);
+
+	ret = drm_connector_register(&rgb->connector);
+	if (ret)
+		goto err_connector_cleanup;
+
+	rgb->encoder.possible_crtcs = 0x1;
+
+	return 0;
+
+err_connector_cleanup:
+	drm_connector_cleanup(&rgb->connector);
+err_encoder_cleanup:
+	drm_encoder_cleanup(&rgb->encoder);
+
+	return ret;
+}
+
+int atmel_hlcdc_create_outputs(struct drm_device *dev)
+{
+	struct device_node *port_np, *np;
+	struct of_endpoint ep;
+	int ret;
+
+	port_np = of_get_child_by_name(dev->dev->of_node, "port");
+	if (!port_np)
+		return -EINVAL;
+
+	np = of_get_child_by_name(port_np, "endpoint");
+	of_node_put(port_np);
+
+	if (!np)
+		return -EINVAL;
+
+	ret = of_graph_parse_endpoint(np, &ep);
+	of_node_put(port_np);
+
+	if (ret)
+		return ret;
+
+	ret = atmel_hlcdc_create_output(dev, &ep);
+	if (ret)
+		return ret;
+
+	return 0;
+}
diff --git a/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
new file mode 100644
index 0000000..82bbf93
--- /dev/null
+++ b/drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_plane.c
@@ -0,0 +1,831 @@
+/*
+ * Copyright (C) 2014 Free Electrons
+ * Copyright (C) 2014 Atmel
+ *
+ * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "atmel_hlcdc_dc.h"
+
+#define SUBPIXEL_MASK			0xffff
+
+static uint32_t rgb_formats[] = {
+	DRM_FORMAT_XRGB4444,
+	DRM_FORMAT_ARGB4444,
+	DRM_FORMAT_RGBA4444,
+	DRM_FORMAT_ARGB1555,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_RGB888,
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_RGBA8888,
+};
+
+struct atmel_hlcdc_formats atmel_hlcdc_plane_rgb_formats = {
+	.formats = rgb_formats,
+	.nformats = ARRAY_SIZE(rgb_formats),
+};
+
+static uint32_t rgb_and_yuv_formats[] = {
+	DRM_FORMAT_XRGB4444,
+	DRM_FORMAT_ARGB4444,
+	DRM_FORMAT_RGBA4444,
+	DRM_FORMAT_ARGB1555,
+	DRM_FORMAT_RGB565,
+	DRM_FORMAT_RGB888,
+	DRM_FORMAT_XRGB8888,
+	DRM_FORMAT_ARGB8888,
+	DRM_FORMAT_RGBA8888,
+	DRM_FORMAT_AYUV,
+	DRM_FORMAT_YUYV,
+	DRM_FORMAT_UYVY,
+	DRM_FORMAT_YVYU,
+	DRM_FORMAT_VYUY,
+	DRM_FORMAT_NV21,
+	DRM_FORMAT_NV61,
+	DRM_FORMAT_YUV422,
+	DRM_FORMAT_YUV420,
+};
+
+struct atmel_hlcdc_formats atmel_hlcdc_plane_rgb_and_yuv_formats = {
+	.formats = rgb_and_yuv_formats,
+	.nformats = ARRAY_SIZE(rgb_and_yuv_formats),
+};
+
+static int atmel_hlcdc_format_to_plane_mode(u32 format, u32 *mode)
+{
+	switch (format) {
+	case DRM_FORMAT_XRGB4444:
+		*mode = ATMEL_HLCDC_XRGB4444_MODE;
+		break;
+	case DRM_FORMAT_ARGB4444:
+		*mode = ATMEL_HLCDC_ARGB4444_MODE;
+		break;
+	case DRM_FORMAT_RGBA4444:
+		*mode = ATMEL_HLCDC_RGBA4444_MODE;
+		break;
+	case DRM_FORMAT_RGB565:
+		*mode = ATMEL_HLCDC_RGB565_MODE;
+		break;
+	case DRM_FORMAT_RGB888:
+		*mode = ATMEL_HLCDC_RGB888_MODE;
+		break;
+	case DRM_FORMAT_ARGB1555:
+		*mode = ATMEL_HLCDC_ARGB1555_MODE;
+		break;
+	case DRM_FORMAT_XRGB8888:
+		*mode = ATMEL_HLCDC_XRGB8888_MODE;
+		break;
+	case DRM_FORMAT_ARGB8888:
+		*mode = ATMEL_HLCDC_ARGB8888_MODE;
+		break;
+	case DRM_FORMAT_RGBA8888:
+		*mode = ATMEL_HLCDC_RGBA8888_MODE;
+		break;
+	case DRM_FORMAT_AYUV:
+		*mode = ATMEL_HLCDC_AYUV_MODE;
+		break;
+	case DRM_FORMAT_YUYV:
+		*mode = ATMEL_HLCDC_YUYV_MODE;
+		break;
+	case DRM_FORMAT_UYVY:
+		*mode = ATMEL_HLCDC_UYVY_MODE;
+		break;
+	case DRM_FORMAT_YVYU:
+		*mode = ATMEL_HLCDC_YVYU_MODE;
+		break;
+	case DRM_FORMAT_VYUY:
+		*mode = ATMEL_HLCDC_VYUY_MODE;
+		break;
+	case DRM_FORMAT_NV21:
+		*mode = ATMEL_HLCDC_NV21_MODE;
+		break;
+	case DRM_FORMAT_NV61:
+		*mode = ATMEL_HLCDC_NV61_MODE;
+		break;
+	case DRM_FORMAT_YUV420:
+		*mode = ATMEL_HLCDC_YUV420_MODE;
+		break;
+	case DRM_FORMAT_YUV422:
+		*mode = ATMEL_HLCDC_YUV422_MODE;
+		break;
+	default:
+		return -ENOTSUPP;
+	}
+
+	return 0;
+}
+
+static bool atmel_hlcdc_format_embedds_alpha(u32 format)
+{
+	int i;
+
+	for (i = 0; i < sizeof(format); i++) {
+		char tmp = (format >> (8 * i)) & 0xff;
+
+		if (tmp == 'A')
+			return true;
+	}
+
+	return false;
+}
+
+static u32 heo_downscaling_xcoef[] = {
+	0x11343311,
+	0x000000f7,
+	0x1635300c,
+	0x000000f9,
+	0x1b362c08,
+	0x000000fb,
+	0x1f372804,
+	0x000000fe,
+	0x24382400,
+	0x00000000,
+	0x28371ffe,
+	0x00000004,
+	0x2c361bfb,
+	0x00000008,
+	0x303516f9,
+	0x0000000c,
+};
+
+static u32 heo_downscaling_ycoef[] = {
+	0x00123737,
+	0x00173732,
+	0x001b382d,
+	0x001f3928,
+	0x00243824,
+	0x0028391f,
+	0x002d381b,
+	0x00323717,
+};
+
+static u32 heo_upscaling_xcoef[] = {
+	0xf74949f7,
+	0x00000000,
+	0xf55f33fb,
+	0x000000fe,
+	0xf5701efe,
+	0x000000ff,
+	0xf87c0dff,
+	0x00000000,
+	0x00800000,
+	0x00000000,
+	0x0d7cf800,
+	0x000000ff,
+	0x1e70f5ff,
+	0x000000fe,
+	0x335ff5fe,
+	0x000000fb,
+};
+
+static u32 heo_upscaling_ycoef[] = {
+	0x00004040,
+	0x00075920,
+	0x00056f0c,
+	0x00027b03,
+	0x00008000,
+	0x00037b02,
+	0x000c6f05,
+	0x00205907,
+};
+
+static void
+atmel_hlcdc_plane_update_pos_and_size(struct atmel_hlcdc_plane *plane,
+				struct atmel_hlcdc_plane_update_req *req)
+{
+	const struct atmel_hlcdc_layer_cfg_layout *layout =
+						&plane->layer.desc->layout;
+
+	if (layout->size)
+		atmel_hlcdc_layer_update_cfg(&plane->layer,
+					     layout->size,
+					     0xffffffff,
+					     (req->crtc_w - 1) |
+					     ((req->crtc_h - 1) << 16));
+
+	if (layout->memsize)
+		atmel_hlcdc_layer_update_cfg(&plane->layer,
+					     layout->memsize,
+					     0xffffffff,
+					     (req->src_w - 1) |
+					     ((req->src_h - 1) << 16));
+
+	if (layout->pos)
+		atmel_hlcdc_layer_update_cfg(&plane->layer,
+					     layout->pos,
+					     0xffffffff,
+					     req->crtc_x |
+					     (req->crtc_y  << 16));
+
+	/* TODO: rework the rescaling part */
+	if (req->crtc_w != req->src_w || req->crtc_h != req->src_h) {
+		u32 factor_reg = 0;
+
+		if (req->crtc_w != req->src_w) {
+			int i;
+			u32 factor;
+			u32 *coeff_tab = heo_upscaling_xcoef;
+			u32 max_memsize;
+
+			if (req->crtc_w < req->src_w)
+				coeff_tab = heo_downscaling_xcoef;
+			for (i = 0; i < ARRAY_SIZE(heo_upscaling_xcoef); i++)
+				atmel_hlcdc_layer_update_cfg(&plane->layer,
+							     17 + i,
+							     0xffffffff,
+							     coeff_tab[i]);
+			factor = ((8 * 256 * req->src_w) - (256 * 4)) /
+				 req->crtc_w;
+			factor++;
+			max_memsize = ((factor * req->crtc_w) + (256 * 4)) /
+				      2048;
+			if (max_memsize > req->src_w)
+				factor--;
+			factor_reg |= factor | 0x80000000;
+		}
+
+		if (req->crtc_h != req->src_h) {
+			int i;
+			u32 factor;
+			u32 *coeff_tab = heo_upscaling_ycoef;
+			u32 max_memsize;
+
+			if (req->crtc_w < req->src_w)
+				coeff_tab = heo_downscaling_ycoef;
+			for (i = 0; i < ARRAY_SIZE(heo_upscaling_ycoef); i++)
+				atmel_hlcdc_layer_update_cfg(&plane->layer,
+							     33 + i,
+							     0xffffffff,
+							     coeff_tab[i]);
+			factor = ((8 * 256 * req->src_w) - (256 * 4)) /
+				 req->crtc_w;
+			factor++;
+			max_memsize = ((factor * req->crtc_w) + (256 * 4)) /
+				      2048;
+			if (max_memsize > req->src_w)
+				factor--;
+			factor_reg |= (factor << 16) | 0x80000000;
+		}
+
+		atmel_hlcdc_layer_update_cfg(&plane->layer, 13, 0xffffffff,
+					     factor_reg);
+	}
+}
+
+static void
+atmel_hlcdc_plane_update_general_settings(struct atmel_hlcdc_plane *plane,
+				struct atmel_hlcdc_plane_update_req *req)
+{
+	const struct atmel_hlcdc_layer_cfg_layout *layout =
+						&plane->layer.desc->layout;
+	unsigned int cfg = ATMEL_HLCDC_LAYER_DMA;
+
+	if (plane->base.type != DRM_PLANE_TYPE_PRIMARY) {
+		cfg |= ATMEL_HLCDC_LAYER_OVR | ATMEL_HLCDC_LAYER_ITER2BL |
+		       ATMEL_HLCDC_LAYER_ITER;
+
+		if (atmel_hlcdc_format_embedds_alpha(req->fb->pixel_format))
+			cfg |= ATMEL_HLCDC_LAYER_LAEN;
+		else
+			cfg |= ATMEL_HLCDC_LAYER_GAEN;
+	}
+
+	atmel_hlcdc_layer_update_cfg(&plane->layer, layout->general_config,
+				     ATMEL_HLCDC_LAYER_ITER2BL |
+				     ATMEL_HLCDC_LAYER_ITER |
+				     ATMEL_HLCDC_LAYER_GAEN |
+				     ATMEL_HLCDC_LAYER_LAEN |
+				     ATMEL_HLCDC_LAYER_OVR |
+				     ATMEL_HLCDC_LAYER_DMA, cfg);
+}
+
+static void atmel_hlcdc_plane_update_format(struct atmel_hlcdc_plane *plane,
+				struct atmel_hlcdc_plane_update_req *req)
+{
+	u32 cfg;
+	int ret;
+
+	ret = atmel_hlcdc_format_to_plane_mode(req->fb->pixel_format, &cfg);
+	if (ret)
+		return;
+
+	if ((req->fb->pixel_format == DRM_FORMAT_YUV422 ||
+	     req->fb->pixel_format == DRM_FORMAT_NV61) &&
+	    (plane->rotation & (BIT(DRM_ROTATE_90) | BIT(DRM_ROTATE_270))))
+		cfg |= ATMEL_HLCDC_YUV422ROT;
+
+	atmel_hlcdc_layer_update_cfg(&plane->layer,
+				     ATMEL_HLCDC_LAYER_FORMAT_CFG_ID,
+				     0xffffffff,
+				     cfg);
+
+	if (req->fb->pixel_format == DRM_FORMAT_RGB888)
+		cfg = ATMEL_HLCDC_LAYER_DMA_ROTDIS;
+	else
+		cfg = 0;
+
+	atmel_hlcdc_layer_update_cfg(&plane->layer,
+				     ATMEL_HLCDC_LAYER_DMA_CFG_ID,
+				     ATMEL_HLCDC_LAYER_DMA_ROTDIS, cfg);
+}
+
+static void atmel_hlcdc_plane_update_buffers(struct atmel_hlcdc_plane *plane,
+				struct atmel_hlcdc_plane_update_req *req)
+{
+	struct atmel_hlcdc_layer *layer = &plane->layer;
+	const struct atmel_hlcdc_layer_cfg_layout *layout =
+							&layer->desc->layout;
+	int i;
+
+	atmel_hlcdc_layer_update_set_fb(&plane->layer, req->fb, req->offsets);
+
+	for (i = 0; i < req->nplanes; i++) {
+		if (layout->xstride[i]) {
+			atmel_hlcdc_layer_update_cfg(&plane->layer,
+						layout->xstride[i],
+						0xffffffff,
+						req->xstride[i]);
+		}
+
+		if (layout->pstride[i]) {
+			atmel_hlcdc_layer_update_cfg(&plane->layer,
+						layout->pstride[i],
+						0xffffffff,
+						req->pstride[i]);
+		}
+	}
+}
+
+static int atmel_hlcdc_plane_check_update_req(struct drm_plane *p,
+				struct atmel_hlcdc_plane_update_req *req)
+{
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+	const struct atmel_hlcdc_layer_cfg_layout *layout =
+						&plane->layer.desc->layout;
+
+	if (!layout->size &&
+	    (req->crtc->mode.crtc_hdisplay != req->crtc_w ||
+	     req->crtc->mode.crtc_vdisplay != req->crtc_h))
+		return -EINVAL;
+
+	if (plane->layer.desc->max_height &&
+	    req->crtc_h > plane->layer.desc->max_height)
+		return -EINVAL;
+
+	if (plane->layer.desc->max_width &&
+	    req->crtc_w > plane->layer.desc->max_width)
+		return -EINVAL;
+
+	if ((req->crtc_h != req->src_h || req->crtc_w != req->src_w) &&
+	    (!layout->memsize ||
+	     atmel_hlcdc_format_embedds_alpha(req->fb->pixel_format)))
+		return -EINVAL;
+
+	if (req->crtc_x < 0 || req->crtc_y < 0)
+		return -EINVAL;
+
+	if (req->crtc_w + req->crtc_x > req->crtc->mode.crtc_hdisplay ||
+	    req->crtc_h + req->crtc_y > req->crtc->mode.crtc_vdisplay)
+		return -EINVAL;
+
+	return 0;
+}
+
+int atmel_hlcdc_plane_prepare_update_req(struct drm_plane *p,
+				struct atmel_hlcdc_plane_update_req *req)
+{
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+	unsigned int patched_crtc_w;
+	unsigned int patched_crtc_h;
+	unsigned int patched_src_w;
+	unsigned int patched_src_h;
+	unsigned int tmp;
+	int x_offset = 0;
+	int y_offset = 0;
+	int hsub = 1;
+	int vsub = 1;
+	int i;
+
+	if ((req->src_x | req->src_y | req->src_w | req->src_h) &
+	    SUBPIXEL_MASK)
+		return -EINVAL;
+
+	req->src_x >>= 16;
+	req->src_y >>= 16;
+	req->src_w >>= 16;
+	req->src_h >>= 16;
+
+	req->nplanes = drm_format_num_planes(req->fb->pixel_format);
+	if (req->nplanes > ATMEL_HLCDC_MAX_PLANES)
+		return -EINVAL;
+
+	/*
+	 * Swap width and size in case of 90 or 270 degrees rotation
+	 */
+	if (plane->rotation & (BIT(DRM_ROTATE_90) | BIT(DRM_ROTATE_270))) {
+		tmp = req->crtc_w;
+		req->crtc_w = req->crtc_h;
+		req->crtc_h = tmp;
+		tmp = req->src_w;
+		req->src_w = req->src_h;
+		req->src_h = tmp;
+	}
+
+	if (req->crtc_x + req->crtc_w > req->crtc->mode.hdisplay)
+		patched_crtc_w = req->crtc->mode.hdisplay - req->crtc_x;
+	else
+		patched_crtc_w = req->crtc_w;
+
+	if (req->crtc_x < 0) {
+		patched_crtc_w += req->crtc_x;
+		x_offset = -req->crtc_x;
+		req->crtc_x = 0;
+	}
+
+	if (req->crtc_y + req->crtc_h > req->crtc->mode.vdisplay)
+		patched_crtc_h = req->crtc->mode.vdisplay - req->crtc_y;
+	else
+		patched_crtc_h = req->crtc_h;
+
+	if (req->crtc_y < 0) {
+		patched_crtc_h += req->crtc_y;
+		y_offset = -req->crtc_y;
+		req->crtc_y = 0;
+	}
+
+	patched_src_w = DIV_ROUND_CLOSEST(patched_crtc_w * req->src_w,
+					  req->crtc_w);
+	patched_src_h = DIV_ROUND_CLOSEST(patched_crtc_h * req->src_h,
+					  req->crtc_h);
+
+	hsub = drm_format_horz_chroma_subsampling(req->fb->pixel_format);
+	vsub = drm_format_vert_chroma_subsampling(req->fb->pixel_format);
+
+	for (i = 0; i < req->nplanes; i++) {
+		unsigned int offset = 0;
+		int xdiv = i ? hsub : 1;
+		int ydiv = i ? vsub : 1;
+
+		req->bpp[i] = drm_format_plane_cpp(req->fb->pixel_format, i);
+		if (!req->bpp[i])
+			return -EINVAL;
+
+		switch (plane->rotation & 0xf) {
+		case BIT(DRM_ROTATE_90):
+			offset = ((y_offset + req->src_y + patched_src_w - 1) /
+				  ydiv) * req->fb->pitches[i];
+			offset += ((x_offset + req->src_x) / xdiv) *
+				  req->bpp[i];
+			req->xstride[i] = ((patched_src_w - 1) / ydiv) *
+					  req->fb->pitches[i];
+			req->pstride[i] = -req->fb->pitches[i] - req->bpp[i];
+			break;
+		case BIT(DRM_ROTATE_180):
+			offset = ((y_offset + req->src_y + patched_src_h - 1) /
+				  ydiv) * req->fb->pitches[i];
+			offset += ((x_offset + req->src_x + patched_src_w - 1) /
+				   xdiv) * req->bpp[i];
+			req->xstride[i] = ((((patched_src_w - 1) / xdiv) - 1) *
+					   req->bpp[i]) - req->fb->pitches[i];
+			req->pstride[i] = -2 * req->bpp[i];
+			break;
+		case BIT(DRM_ROTATE_270):
+			offset = ((y_offset + req->src_y) / ydiv) *
+				 req->fb->pitches[i];
+			offset += ((x_offset + req->src_x + patched_src_h - 1) /
+				   xdiv) * req->bpp[i];
+			req->xstride[i] = -(((patched_src_w - 1) / ydiv) *
+					    req->fb->pitches[i]) -
+					  (2 * req->bpp[i]);
+			req->pstride[i] = req->fb->pitches[i] - req->bpp[i];
+			break;
+		case BIT(DRM_ROTATE_0):
+		default:
+			offset = ((y_offset + req->src_y) / ydiv) *
+				 req->fb->pitches[i];
+			offset += ((x_offset + req->src_x) / xdiv) *
+				  req->bpp[i];
+			req->xstride[i] = req->fb->pitches[i] -
+					  ((patched_src_w / xdiv) *
+					   req->bpp[i]);
+			req->pstride[i] = 0;
+			break;
+		}
+
+		req->offsets[i] = offset + req->fb->offsets[i];
+	}
+
+	req->src_w = patched_src_w;
+	req->src_h = patched_src_h;
+	req->crtc_w = patched_crtc_w;
+	req->crtc_h = patched_crtc_h;
+
+	return atmel_hlcdc_plane_check_update_req(p, req);
+}
+
+int atmel_hlcdc_plane_apply_update_req(struct drm_plane *p,
+				struct atmel_hlcdc_plane_update_req *req)
+{
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+	int ret;
+
+	ret = atmel_hlcdc_layer_update_start(&plane->layer);
+	if (ret)
+		return ret;
+
+	atmel_hlcdc_plane_update_pos_and_size(plane, req);
+	atmel_hlcdc_plane_update_general_settings(plane, req);
+	atmel_hlcdc_plane_update_format(plane, req);
+	atmel_hlcdc_plane_update_buffers(plane, req);
+
+	atmel_hlcdc_layer_update_commit(&plane->layer);
+
+	return 0;
+}
+
+static int atmel_hlcdc_plane_update(struct drm_plane *p,
+				    struct drm_crtc *crtc,
+				    struct drm_framebuffer *fb,
+				    int crtc_x, int crtc_y,
+				    unsigned int crtc_w, unsigned int crtc_h,
+				    uint32_t src_x, uint32_t src_y,
+				    uint32_t src_w, uint32_t src_h)
+{
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+	struct atmel_hlcdc_plane_update_req req;
+	int ret = 0;
+
+	memset(&req, 0, sizeof(req));
+	req.crtc_x = crtc_x;
+	req.crtc_y = crtc_y;
+	req.crtc_w = crtc_w;
+	req.crtc_h = crtc_h;
+	req.src_x = src_x;
+	req.src_y = src_y;
+	req.src_w = src_w;
+	req.src_h = src_h;
+	req.fb = fb;
+	req.crtc = crtc;
+
+	ret = atmel_hlcdc_plane_prepare_update_req(&plane->base, &req);
+	if (ret)
+		return ret;
+
+	if (!req.crtc_h || !req.crtc_w)
+		return atmel_hlcdc_layer_disable(&plane->layer);
+
+	return atmel_hlcdc_plane_apply_update_req(&plane->base, &req);
+}
+
+static int atmel_hlcdc_plane_disable(struct drm_plane *p)
+{
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+
+	return atmel_hlcdc_layer_disable(&plane->layer);
+}
+
+static void atmel_hlcdc_plane_destroy(struct drm_plane *p)
+{
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+
+	if (plane->base.fb)
+		drm_framebuffer_unreference(plane->base.fb);
+
+	atmel_hlcdc_layer_cleanup(p->dev, &plane->layer);
+
+	drm_plane_cleanup(p);
+	devm_kfree(p->dev->dev, plane);
+}
+
+static int atmel_hlcdc_plane_set_alpha(struct atmel_hlcdc_plane *plane,
+				       u8 alpha)
+{
+	atmel_hlcdc_layer_update_start(&plane->layer);
+	atmel_hlcdc_layer_update_cfg(&plane->layer,
+				     plane->layer.desc->layout.general_config,
+				     ATMEL_HLCDC_LAYER_GA_MASK,
+				     alpha << ATMEL_HLCDC_LAYER_GA_SHIFT);
+	atmel_hlcdc_layer_update_commit(&plane->layer);
+
+	return 0;
+}
+
+static int atmel_hlcdc_plane_set_rotation(struct atmel_hlcdc_plane *plane,
+					  unsigned int rotation)
+{
+	plane->rotation = rotation;
+
+	return 0;
+}
+
+static int atmel_hlcdc_plane_set_property(struct drm_plane *p,
+					  struct drm_property *property,
+					  uint64_t value)
+{
+	struct atmel_hlcdc_plane *plane = drm_plane_to_atmel_hlcdc_plane(p);
+	struct atmel_hlcdc_plane_properties *props = plane->properties;
+
+	if (property == props->alpha)
+		atmel_hlcdc_plane_set_alpha(plane, value);
+	else if (property == props->rotation)
+		atmel_hlcdc_plane_set_rotation(plane, value);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+static void atmel_hlcdc_plane_init_properties(struct atmel_hlcdc_plane *plane,
+				const struct atmel_hlcdc_layer_desc *desc,
+				struct atmel_hlcdc_plane_properties *props)
+{
+	struct regmap *regmap = plane->layer.hlcdc->regmap;
+
+	if (desc->type == ATMEL_HLCDC_OVERLAY_LAYER ||
+	    desc->type == ATMEL_HLCDC_CURSOR_LAYER) {
+		drm_object_attach_property(&plane->base.base,
+					   props->alpha, 255);
+
+		/* Set default alpha value */
+		regmap_update_bits(regmap,
+				desc->regs_offset +
+				ATMEL_HLCDC_LAYER_GENERAL_CFG(&plane->layer),
+				ATMEL_HLCDC_LAYER_GA_MASK,
+				ATMEL_HLCDC_LAYER_GA_MASK);
+	}
+
+	if (desc->layout.xstride && desc->layout.pstride)
+		drm_object_attach_property(&plane->base.base,
+					   props->rotation,
+					   BIT(DRM_ROTATE_0));
+
+	if (desc->layout.csc) {
+		/*
+		 * TODO: decare a "yuv-to-rgb-conv-factors" property to let
+		 * userspace modify these factors (using a BLOB property ?).
+		 */
+		regmap_write(regmap,
+			     desc->regs_offset +
+			     ATMEL_HLCDC_LAYER_CSC_CFG(&plane->layer, 0),
+			     0x4c900091);
+		regmap_write(regmap,
+			     desc->regs_offset +
+			     ATMEL_HLCDC_LAYER_CSC_CFG(&plane->layer, 1),
+			     0x7a5f5090);
+		regmap_write(regmap,
+			     desc->regs_offset +
+			     ATMEL_HLCDC_LAYER_CSC_CFG(&plane->layer, 2),
+			     0x40040890);
+	}
+}
+
+static struct drm_plane_funcs layer_plane_funcs = {
+	.update_plane = atmel_hlcdc_plane_update,
+	.disable_plane = atmel_hlcdc_plane_disable,
+	.set_property = atmel_hlcdc_plane_set_property,
+	.destroy = atmel_hlcdc_plane_destroy,
+};
+
+static struct atmel_hlcdc_plane *
+atmel_hlcdc_plane_create(struct drm_device *dev,
+			 const struct atmel_hlcdc_layer_desc *desc,
+			 struct atmel_hlcdc_plane_properties *props)
+{
+	struct atmel_hlcdc_plane *plane;
+	enum drm_plane_type type;
+	int ret;
+
+	plane = devm_kzalloc(dev->dev, sizeof(*plane), GFP_KERNEL);
+	if (!plane)
+		return ERR_PTR(-ENOMEM);
+
+	ret = atmel_hlcdc_layer_init(dev, &plane->layer, desc);
+	if (ret)
+		return ERR_PTR(ret);
+
+	if (desc->type == ATMEL_HLCDC_BASE_LAYER)
+		type = DRM_PLANE_TYPE_PRIMARY;
+	else if (desc->type == ATMEL_HLCDC_CURSOR_LAYER)
+		type = DRM_PLANE_TYPE_CURSOR;
+	else
+		type = DRM_PLANE_TYPE_OVERLAY;
+
+	ret = drm_universal_plane_init(dev, &plane->base, 0,
+				       &layer_plane_funcs,
+				       desc->formats->formats,
+				       desc->formats->nformats, type);
+	if (ret)
+		return ERR_PTR(ret);
+
+	/* Set default property values*/
+	atmel_hlcdc_plane_init_properties(plane, desc, props);
+
+	return plane;
+}
+
+static struct atmel_hlcdc_plane_properties *
+atmel_hlcdc_plane_create_properties(struct drm_device *dev)
+{
+	struct atmel_hlcdc_plane_properties *props;
+
+	props = devm_kzalloc(dev->dev, sizeof(*props), GFP_KERNEL);
+	if (!props)
+		return ERR_PTR(-ENOMEM);
+
+	props->alpha = drm_property_create_range(dev, 0, "alpha", 0, 255);
+	if (!props->alpha)
+		return ERR_PTR(-ENOMEM);
+
+	props->rotation = drm_mode_create_rotation_property(dev,
+						BIT(DRM_ROTATE_0) |
+						BIT(DRM_ROTATE_90) |
+						BIT(DRM_ROTATE_180) |
+						BIT(DRM_ROTATE_270));
+	if (!props->rotation)
+		return ERR_PTR(-ENOMEM);
+
+	return props;
+}
+
+struct atmel_hlcdc_planes *
+atmel_hlcdc_create_planes(struct drm_device *dev)
+{
+	struct atmel_hlcdc_dc *dc = dev->dev_private;
+	struct atmel_hlcdc_plane_properties *props;
+	struct atmel_hlcdc_planes *planes;
+	const struct atmel_hlcdc_layer_desc *descs = dc->desc->layers;
+	int nlayers = dc->desc->nlayers;
+	int i;
+
+	planes = devm_kzalloc(dev->dev, sizeof(*planes), GFP_KERNEL);
+	if (!planes)
+		return ERR_PTR(-ENOMEM);
+
+	for (i = 0; i < nlayers; i++) {
+		if (descs[i].type == ATMEL_HLCDC_OVERLAY_LAYER)
+			planes->noverlays++;
+	}
+
+	if (planes->noverlays) {
+		planes->overlays = devm_kzalloc(dev->dev,
+						planes->noverlays *
+						sizeof(*planes->overlays),
+						GFP_KERNEL);
+		if (!planes->overlays)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	props = atmel_hlcdc_plane_create_properties(dev);
+	if (IS_ERR(props))
+		return ERR_CAST(props);
+
+	planes->noverlays = 0;
+	for (i = 0; i < nlayers; i++) {
+		struct atmel_hlcdc_plane *plane;
+
+		if (descs[i].type == ATMEL_HLCDC_PP_LAYER)
+			continue;
+
+		plane = atmel_hlcdc_plane_create(dev, &descs[i], props);
+		if (IS_ERR(plane))
+			return ERR_CAST(plane);
+
+		plane->properties = props;
+
+		switch (descs[i].type) {
+		case ATMEL_HLCDC_BASE_LAYER:
+			if (planes->primary)
+				return ERR_PTR(-EINVAL);
+			planes->primary = plane;
+			break;
+
+		case ATMEL_HLCDC_OVERLAY_LAYER:
+			planes->overlays[planes->noverlays++] = plane;
+			break;
+
+		case ATMEL_HLCDC_CURSOR_LAYER:
+			if (planes->cursor)
+				return ERR_PTR(-EINVAL);
+			planes->cursor = plane;
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	return planes;
+}
-- 
1.9.1

