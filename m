Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaKLLiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:38:46 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51061 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaKLLio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:38:44 -0500
From: Daniel Thompson <daniel.thompson@linaro.org>
To: David Airlie <airlied@linux.ie>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 v3.18-rc4 3/4] drm: msm: Allow exported dma-bufs to be mapped
Date: Wed, 12 Nov 2014 11:38:14 +0000
Message-Id: <1415792295-2466-4-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
 <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently msm does not implement gem_prime_mmap. Without this it is not
possible to draw onto a dma-buf from userspace (making its very hard to
implement the Android rendering model).

Fixing this is just a matter of adding a little boilerplate.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
---
 drivers/gpu/drm/msm/msm_drv.c       |  1 +
 drivers/gpu/drm/msm/msm_drv.h       |  3 +++
 drivers/gpu/drm/msm/msm_gem_prime.c | 13 +++++++++++++
 3 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index b67ef5985125..5717d4ec1a2c 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -832,6 +832,7 @@ static struct drm_driver msm_driver = {
 	.gem_prime_import_sg_table = msm_gem_prime_import_sg_table,
 	.gem_prime_vmap     = msm_gem_prime_vmap,
 	.gem_prime_vunmap   = msm_gem_prime_vunmap,
+	.gem_prime_mmap     = msm_gem_prime_mmap,
 #ifdef CONFIG_DEBUG_FS
 	.debugfs_init       = msm_debugfs_init,
 	.debugfs_cleanup    = msm_debugfs_cleanup,
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 67f9d0a2332c..1a7344066154 100644
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
@@ -170,6 +172,7 @@ int msm_gem_dumb_map_offset(struct drm_file *file, struct drm_device *dev,
 struct sg_table *msm_gem_prime_get_sg_table(struct drm_gem_object *obj);
 void *msm_gem_prime_vmap(struct drm_gem_object *obj);
 void msm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr);
+int msm_gem_prime_mmap(struct drm_gem_object *obj, struct vm_area_struct *vma);
 struct drm_gem_object *msm_gem_prime_import_sg_table(struct drm_device *dev,
 		struct dma_buf_attachment *attach, struct sg_table *sg);
 int msm_gem_prime_pin(struct drm_gem_object *obj);
diff --git a/drivers/gpu/drm/msm/msm_gem_prime.c b/drivers/gpu/drm/msm/msm_gem_prime.c
index ad772fe36115..dd7a7ab603e2 100644
--- a/drivers/gpu/drm/msm/msm_gem_prime.c
+++ b/drivers/gpu/drm/msm/msm_gem_prime.c
@@ -37,6 +37,19 @@ void msm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr)
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

