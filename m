Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585AbaKJRRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 12:17:13 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60187 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbaKJRRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 12:17:11 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v3.18-rc3] drm: msm: Allow exported dma-bufs to be mapped
Date: Mon, 10 Nov 2014 17:16:45 +0000
Message-Id: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently msm does not implement gem_prime_mmap. Without this it is not
possible to draw onto a dma-buf from another process (making its very hard
to implement the Android rendering model).

Implementing this mostly just providing some boilerplate code. However in
addition to providing the implementation of mmap itself we must also
interfere with the flags during the export. Without this the mmap() will
fail the permission checks early in the syscall handling and
msm_gem_prime_mmap() will never be called.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---

Notes:
    I've tested this both with a rather hacked about Android userspace
    and with a fairly small test case run from debian. Both currently use
    dumb buffers.
    
    Thanks to Benjamin for his help in finding this bit of code.
    

 drivers/gpu/drm/msm/msm_drv.c       |  3 ++-
 drivers/gpu/drm/msm/msm_drv.h       |  5 +++++
 drivers/gpu/drm/msm/msm_gem_prime.c | 21 +++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index b67ef5985125..f0d77ee482a5 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -824,7 +824,7 @@ static struct drm_driver msm_driver = {
 	.dumb_destroy       = drm_gem_dumb_destroy,
 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
-	.gem_prime_export   = drm_gem_prime_export,
+	.gem_prime_export   = msm_gem_prime_export,
 	.gem_prime_import   = drm_gem_prime_import,
 	.gem_prime_pin      = msm_gem_prime_pin,
 	.gem_prime_unpin    = msm_gem_prime_unpin,
@@ -832,6 +832,7 @@ static struct drm_driver msm_driver = {
 	.gem_prime_import_sg_table = msm_gem_prime_import_sg_table,
 	.gem_prime_vmap     = msm_gem_prime_vmap,
 	.gem_prime_vunmap   = msm_gem_prime_vunmap,
+	.gem_prime_mmap     = msm_gem_prime_mmap,
 #ifdef CONFIG_DEBUG_FS
 	.debugfs_init       = msm_debugfs_init,
 	.debugfs_cleanup    = msm_debugfs_cleanup,
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 67f9d0a2332c..3a1c85f7f241 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -154,6 +154,8 @@ void msm_update_fence(struct drm_device *dev, uint32_t fence);
 int msm_ioctl_gem_submit(struct drm_device *dev, void *data,
 		struct drm_file *file);

+int msm_gem_mmap_obj(struct drm_gem_object *obj,
+			struct vm_area_struct *vma);
 int msm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
 int msm_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 uint64_t msm_gem_mmap_offset(struct drm_gem_object *obj);
@@ -167,9 +169,12 @@ int msm_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
 		struct drm_mode_create_dumb *args);
 int msm_gem_dumb_map_offset(struct drm_file *file, struct drm_device *dev,
 		uint32_t handle, uint64_t *offset);
+struct dma_buf *msm_gem_prime_export(struct drm_device *dev,
+				     struct drm_gem_object *obj, int flags);
 struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj);
 void *msm_gem_prime_vmap(struct drm_gem_object *obj);
 void msm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr);
+int msm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma);
 struct drm_gem_object *msm_gem_prime_import_sg_table(struct drm_device *dev,
 		struct dma_buf_attachment *attach, struct sg_table *sg);
 int msm_gem_prime_pin(struct drm_gem_object *obj);
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index ad772fe36115..4e4fa5828d5d 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -20,6 +20,14 @@

 #include <linux/dma-buf.h>

+struct dma_buf *msm_gem_prime_export(struct drm_device *dev,
+				     struct drm_gem_object *obj, int flags)
+{
+	/* we want to be able to write in mmapped buffer */
+	flags |= O_RDWR;
+	return drm_gem_prime_export(dev, obj, flags);
+}
+
 struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj)
 {
 	struct msm_gem_object *msm_obj = to_msm_bo(obj);
@@ -37,6 +45,19 @@ void msm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr)
 	/* TODO msm_gem_vunmap() */
 }

+int msm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma)
+{
+	int ret;
+
+	mutex_lock(&obj->dev->struct_mutex);
+	ret = drm_gem_mmap_obj(obj, obj->size, vma);
+	mutex_unlock(&obj->dev->struct_mutex);
+	if (ret < 0)
+		return ret;
+
+	return msm_gem_mmap_obj(vma->vm_private_data, vma);
+}
+
 struct drm_gem_object *msm_gem_prime_import_sg_table(struct drm_device *dev,
 		struct dma_buf_attachment *attach, struct sg_table *sg)
 {
--
1.9.3

