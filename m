Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab3I2Tzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:55:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59333 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab3I2T2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 21/49] drm: fix DRM_IOCTL_MODE_GETFB handle-leak
Date: Sun, 29 Sep 2013 12:26:55 -0700
Message-Id: <20130929191604.441673742@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_crtc.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -2501,10 +2501,22 @@ int drm_mode_getfb(struct drm_device *de
 	r->depth = fb->depth;
 	r->bpp = fb->bits_per_pixel;
 	r->pitch = fb->pitches[0];
-	if (fb->funcs->create_handle)
-		ret = fb->funcs->create_handle(fb, file_priv, &r->handle);
-	else
+	if (fb->funcs->create_handle) {
+		if (file_priv->is_master || capable(CAP_SYS_ADMIN)) {
+			ret = fb->funcs->create_handle(fb, file_priv,
+						       &r->handle);
+		} else {
+			/* GET_FB() is an unprivileged ioctl so we must not
+			 * return a buffer-handle to non-master processes! For
+			 * backwards-compatibility reasons, we cannot make
+			 * GET_FB() privileged, so just return an invalid handle
+			 * for non-masters. */
+			r->handle = 0;
+			ret = 0;
+		}
+	} else {
 		ret = -ENODEV;
+	}
 
 	drm_framebuffer_unreference(fb);
 


