Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaL2BRv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:17:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33124 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659AbaL2BMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:13 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "David Herrmann" <dh.herrmann@gmail.com>,
        "Dave Airlie" <airlied@redhat.com>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.715332536@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 17/27] drm: fix DRM_IOCTL_MODE_GETFB handle-leak
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@gmail.com>

commit 101b96f32956ee99bf1468afaf572b88cda9f88b upstream.

DRM_IOCTL_MODE_GETFB is used to retrieve information about a given
framebuffer ID. It is a read-only helper and was thus declassified for
unprivileged access in:

  commit a14b1b42477c5ef089fcda88cbaae50d979eb8f9
  Author: Mandeep Singh Baines <mandeep.baines@gmail.com>
  Date:   Fri Jan 20 12:11:16 2012 -0800

      drm: remove master fd restriction on mode setting getters

However, alongside width, height and stride information,
DRM_IOCTL_MODE_GETFB also passes back a handle to the underlying buffer of
the framebuffer. This handle allows users to mmap() it and read or write
into it. Obviously, this should be restricted to DRM-Master.

With the current setup, *any* process with access to /dev/dri/card0 (which
means any process with access to hardware-accelerated rendering) can
access the current screen framebuffer and modify it ad libitum.

For backwards-compatibility reasons we want to keep the
DRM_IOCTL_MODE_GETFB call unprivileged. Besides, it provides quite useful
information regarding screen setup. So we simply test whether the caller
is the current DRM-Master and if not, we return 0 as handle, which is
always invalid. A following DRM_IOCTL_GEM_CLOSE on this handle will fail
with EINVAL, but we accept this. Users shouldn't test for errors during
GEM_CLOSE, anyway. And it is still better as a failing MODE_GETFB call.

v2: add capable(CAP_SYS_ADMIN) check for compatibility with i-g-t

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
[bwh: Backported to 3.2:
 - drm_framebuffer_funcs::create_handle must be non-null
 - Adjust context, indentation]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -1815,7 +1815,17 @@ int drm_mode_getfb(struct drm_device *de
 	r->depth = fb->depth;
 	r->bpp = fb->bits_per_pixel;
 	r->pitch = fb->pitch;
-	fb->funcs->create_handle(fb, file_priv, &r->handle);
+	if (file_priv->is_master || capable(CAP_SYS_ADMIN)) {
+		ret = fb->funcs->create_handle(fb, file_priv, &r->handle);
+	} else {
+		/* GET_FB() is an unprivileged ioctl so we must not
+		 * return a buffer-handle to non-master processes! For
+		 * backwards-compatibility reasons, we cannot make
+		 * GET_FB() privileged, so just return an invalid handle
+		 * for non-masters. */
+		r->handle = 0;
+		ret = 0;
+	}
 
 out:
 	mutex_unlock(&dev->mode_config.mutex);

