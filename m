Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab3LQRTW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 12:19:22 -0500
Received: from home.keithp.com ([63.227.221.253]:50885 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab3LQRTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 12:19:21 -0500
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 12:19:21 EST
From: Keith Packard <keithp@keithp.com>
To: intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/intel: Only smash VGA SR01 register if intel is default VGA device
Date: Tue, 17 Dec 2013 09:12:10 -0800
Message-Id: <1387300330-8844-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.8.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to disable the (unused) VGA plane on the intel hardware, which
should be a simple matter of writing the vga control register. However,
in 2009 (commit 24f119c769bacac5729297b682fec7811a983cc6), that simple
code was changed to also smash the SR01 VGA register to fix "random
crash and lockups".

When running efifb on an nVidia card, executing this store to SR01
ends up causing the screen to go black.

I'm not sure if this store is still required; this patch limits it to
when the intel card is primary.

Signed-off-by: Keith Packard <keithp@keithp.com>
---

 drivers/gpu/drm/i915/intel_display.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index c714d4d..545b271 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -9038,12 +9038,14 @@ static void i915_disable_vga(struct drm_device *dev)
 	u8 sr1;
 	u32 vga_reg = i915_vgacntrl_reg(dev);
 
-	vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
-	outb(SR01, VGA_SR_INDEX);
-	sr1 = inb(VGA_SR_DATA);
-	outb(sr1 | 1<<5, VGA_SR_DATA);
-	vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
-	udelay(300);
+	if (dev->pdev == vga_default_device()) {
+		vga_get_uninterruptible(dev->pdev, VGA_RSRC_LEGACY_IO);
+		outb(SR01, VGA_SR_INDEX);
+		sr1 = inb(VGA_SR_DATA);
+		outb(sr1 | 1<<5, VGA_SR_DATA);
+		vga_put(dev->pdev, VGA_RSRC_LEGACY_IO);
+		udelay(300);
+	}
 
 	I915_WRITE(vga_reg, VGA_DISP_DISABLE);
 	POSTING_READ(vga_reg);
-- 
1.8.5.1

