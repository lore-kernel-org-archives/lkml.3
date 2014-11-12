Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaKLLje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:39:34 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58800 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaKLLil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:38:41 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 v3.18-rc4 1/4] drm: prime: Honour O_RDWR during prime-handle-to-fd
Date: Wed, 12 Nov 2014 11:38:12 +0000
Message-Id: <1415792295-2466-2-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
 <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently DRM_IOCTL_PRIME_HANDLE_TO_FD rejects all flags except
(DRM|O)_CLOEXEC making it hard for the userspace to generate a file
descriptor that can be used by mmap().

It is easy to relax the restriction and allow read/write permissions.
This should be safe because the flags are seldom touched by drm; mostly
they are passed verbatim to dma_buf calls.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/gpu/drm/drm_prime.c | 9 +++------
 include/uapi/drm/drm.h      | 1 +
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 78ca30808422..8467b17c8053 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -331,7 +331,7 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
  * drm_gem_prime_export - helper library implemention of the export callback
  * @dev: drm_device to export from
  * @obj: GEM object to export
- * @flags: flags like DRM_CLOEXEC
+ * @flags: flags like DRM_CLOEXEC and DRM_RDWR
  *
  * This is the implementation of the gem_prime_export functions for GEM drivers
  * using the PRIME helpers.
@@ -635,14 +635,11 @@ int drm_prime_handle_to_fd_ioctl(struct drm_device *dev, void *data,
 		return -ENOSYS;
 
 	/* check flags are valid */
-	if (args->flags & ~DRM_CLOEXEC)
+	if (args->flags & ~(DRM_CLOEXEC | DRM_RDWR))
 		return -EINVAL;
 
-	/* we only want to pass DRM_CLOEXEC which is == O_CLOEXEC */
-	flags = args->flags & DRM_CLOEXEC;
-
 	return dev->driver->prime_handle_to_fd(dev, file_priv,
-			args->handle, flags, &args->fd);
+			args->handle, args->flags, &args->fd);
 }
 
 int drm_prime_fd_to_handle_ioctl(struct drm_device *dev, void *data,
diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index b0b855613641..89c2b68ddc51 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -660,6 +660,7 @@ struct drm_set_client_cap {
 	__u64 value;
 };
 
+#define DRM_RDWR O_RDWR
 #define DRM_CLOEXEC O_CLOEXEC
 struct drm_prime_handle {
 	__u32 handle;
-- 
1.9.3

