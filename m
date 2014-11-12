Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaKLLi4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:38:56 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:41948 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaKLLip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:38:45 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 v3.18-rc4 4/4] drm: sti: Honour O_RDWR during prime-handle-to-fd
Date: Wed, 12 Nov 2014 11:38:15 +0000
Message-Id: <1415792295-2466-5-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
 <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the sti drm driver forcible applies O_RDWR when it exports
a prime handle. This is because it was not previously possible for
user requests to create the fd with O_RDWR passed into drivers.

This is a cleanup to remove this code. This change has obvious impact
upon the userspace which must change the flags passed to
DRM_IOCTL_PRIME_HANDLE_TO_FD. However at present only a tiny handful of
developers run this userspace and, if they don't complain, nobody else
will.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/gpu/drm/sti/sti_drm_drv.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/sti/sti_drm_drv.c b/drivers/gpu/drm/sti/sti_drm_drv.c
index 223d93c3a05d..320167e1520a 100644
--- a/drivers/gpu/drm/sti/sti_drm_drv.c
+++ b/drivers/gpu/drm/sti/sti_drm_drv.c
@@ -93,15 +93,6 @@ static const struct file_operations sti_drm_driver_fops = {
 	.release = drm_release,
 };
 
-static struct dma_buf *sti_drm_gem_prime_export(struct drm_device *dev,
-						struct drm_gem_object *obj,
-						int flags)
-{
-	/* we want to be able to write in mmapped buffer */
-	flags |= O_RDWR;
-	return drm_gem_prime_export(dev, obj, flags);
-}
-
 static struct drm_driver sti_drm_driver = {
 	.driver_features = DRIVER_HAVE_IRQ | DRIVER_MODESET |
 	    DRIVER_GEM | DRIVER_PRIME,
@@ -119,7 +110,7 @@ static struct drm_driver sti_drm_driver = {
 
 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
-	.gem_prime_export = sti_drm_gem_prime_export,
+	.gem_prime_export = drm_gem_prime_export,
 	.gem_prime_import = drm_gem_prime_import,
 	.gem_prime_get_sg_table = drm_gem_cma_prime_get_sg_table,
 	.gem_prime_import_sg_table = drm_gem_cma_prime_import_sg_table,
-- 
1.9.3

