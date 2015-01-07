Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbbAGC5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 21:57:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46242 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939AbbAGBwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:52:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 3.18 33/84] drm/tegra: gem: dumb: pitch and size are outputs
Date: Tue,  6 Jan 2015 17:49:36 -0800
Message-Id: <20150107014030.107585982@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <treding@nvidia.com>

commit dc6057ecb39edb34b0461ca55382094410bd257a upstream.

When creating a dumb buffer object using the DRM_IOCTL_MODE_CREATE_DUMB
IOCTL, only the width, height, bpp and flags parameters are inputs. The
caller is not guaranteed to zero out or set handle, pitch and size, so
the driver must not treat these values as possible inputs.

Fixes a bug where running the Weston compositor on Tegra DRM would cause
an attempt to allocate a 3 GiB framebuffer to be allocated.

Fixes: de2ba664c30f ("gpu: host1x: drm: Add memory manager and fb")
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tegra/gem.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -259,16 +259,12 @@ void tegra_bo_free_object(struct drm_gem
 int tegra_bo_dumb_create(struct drm_file *file, struct drm_device *drm,
 			 struct drm_mode_create_dumb *args)
 {
-	int min_pitch = DIV_ROUND_UP(args->width * args->bpp, 8);
+	unsigned int min_pitch = DIV_ROUND_UP(args->width * args->bpp, 8);
 	struct tegra_drm *tegra = drm->dev_private;
 	struct tegra_bo *bo;
 
-	min_pitch = round_up(min_pitch, tegra->pitch_align);
-	if (args->pitch < min_pitch)
-		args->pitch = min_pitch;
-
-	if (args->size < args->pitch * args->height)
-		args->size = args->pitch * args->height;
+	args->pitch = round_up(min_pitch, tegra->pitch_align);
+	args->size = args->pitch * args->height;
 
 	bo = tegra_bo_create_with_handle(file, drm, args->size, 0,
 					 &args->handle);


