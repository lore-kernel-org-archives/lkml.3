Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3CNNhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:37:38 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:54991 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757770Ab3CNNhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:37:37 -0400
X-Greylist: delayed 2243 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Mar 2013 09:37:36 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Tommi Rantala <tt.rantala@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915: Sanity check incoming ioctl data for a NULL pointer
Date: Thu, 14 Mar 2013 12:59:57 +0000
Message-Id: <1363265997-29023-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
References: <CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com>
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to prevent a potential NULL deference with hostile userspace,
we need to check whether the ioctl was passed an invalid args pointer.

Reported-by: Tommi Rantala <tt.rantala@gmail.com>
Link: http://lkml.kernel.org/r/CA+ydwtpuBvbwxbt-tdgPUvj1EU7itmCHo_2B3w13HkD5+jWKow@mail.gmail.com
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index 365e41a..9f5602e 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1103,7 +1103,11 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 	struct drm_i915_gem_exec_object2 *exec2_list = NULL;
 	int ret, i;
 
-	if (args->buffer_count < 1) {
+	if (args == NULL)
+		return -EINVAL;
+
+	if (args->buffer_count < 1 ||
+	    args->buffer_count > INT_MAX / sizeof(*exec2_list)) {
 		DRM_DEBUG("execbuf with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
@@ -1182,8 +1186,11 @@ i915_gem_execbuffer2(struct drm_device *dev, void *data,
 	struct drm_i915_gem_exec_object2 *exec2_list = NULL;
 	int ret;
 
+	if (args == NULL)
+		return -EINVAL;
+
 	if (args->buffer_count < 1 ||
-	    args->buffer_count > UINT_MAX / sizeof(*exec2_list)) {
+	    args->buffer_count > INT_MAX / sizeof(*exec2_list)) {
 		DRM_DEBUG("execbuf2 with %d buffers\n", args->buffer_count);
 		return -EINVAL;
 	}
-- 
1.7.10.4

