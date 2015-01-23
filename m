Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbbAWHe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:34:59 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52609 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017AbbAWHe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:34:56 -0500
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, rmk+kernel@arm.linux.org.uk,
        airlied@linux.ie, kgene@kernel.org, daniel.vetter@intel.com,
        thierry.reding@gmail.com, pawel@osciak.com, m.szyprowski@samsung.com,
        mchehab@osg.samsung.com, gregkh@linuxfoundation.org
Cc: linaro-kernel@lists.linaro.org, robdclark@gmail.com, daniel@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        inki.dae@samsung.com, Sumit Semwal <sumit.semwal@linaro.org>
Subject: [RFC] dma-buf: cleanup dma_buf_export() to make it easily extensible
Date: Fri, 23 Jan 2015 13:04:12 +0530
Message-Id: <1421998452-18752-1-git-send-email-sumit.semwal@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, dma_buf_export() takes a series of parameters, which
makes it difficult to add any new parameters for exporters, if required.

Make it simpler by moving all these parameters into a struct, and pass
the struct * as parameter to dma_buf_export().

While at it, unite dma_buf_export_named() with dma_buf_export(), and
change all callers accordingly.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 drivers/dma-buf/dma-buf.c                      | 47 +++++++++++++-------------
 drivers/gpu/drm/armada/armada_gem.c            | 12 +++++--
 drivers/gpu/drm/drm_prime.c                    | 14 +++++---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     | 13 +++++--
 drivers/gpu/drm/i915/i915_gem_dmabuf.c         | 12 +++++--
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      | 11 +++++-
 drivers/gpu/drm/tegra/gem.c                    | 12 +++++--
 drivers/gpu/drm/ttm/ttm_object.c               | 11 ++++--
 drivers/gpu/drm/udl/udl_dmabuf.c               | 10 +++++-
 drivers/media/v4l2-core/videobuf2-dma-contig.c | 10 +++++-
 drivers/media/v4l2-core/videobuf2-dma-sg.c     | 10 +++++-
 drivers/media/v4l2-core/videobuf2-vmalloc.c    | 10 +++++-
 drivers/staging/android/ion/ion.c              | 11 ++++--
 include/linux/dma-buf.h                        | 28 +++++++++++----
 14 files changed, 160 insertions(+), 51 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 5be225c2ba98..6d3df3dd9310 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -265,7 +265,7 @@ static inline int is_dma_buf_file(struct file *file)
 }
 
 /**
- * dma_buf_export_named - Creates a new dma_buf, and associates an anon file
+ * dma_buf_export - Creates a new dma_buf, and associates an anon file
  * with this buffer, so it can be exported.
  * Also connect the allocator specific data and ops to the buffer.
  * Additionally, provide a name string for exporter; useful in debugging.
@@ -277,31 +277,32 @@ static inline int is_dma_buf_file(struct file *file)
  * @exp_name:	[in]	name of the exporting module - useful for debugging.
  * @resv:	[in]	reservation-object, NULL to allocate default one.
  *
+ * All the above info comes from struct dma_buf_export_info.
+ *
  * Returns, on success, a newly created dma_buf object, which wraps the
  * supplied private data and operations for dma_buf_ops. On either missing
  * ops, or error in allocating struct dma_buf, will return negative error.
  *
  */
-struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
-				size_t size, int flags, const char *exp_name,
-				struct reservation_object *resv)
+struct dma_buf *dma_buf_export(struct dma_buf_export_info *exp_info)
 {
 	struct dma_buf *dmabuf;
 	struct file *file;
 	size_t alloc_size = sizeof(struct dma_buf);
-	if (!resv)
+	if (!exp_info->resv)
 		alloc_size += sizeof(struct reservation_object);
 	else
 		/* prevent &dma_buf[1] == dma_buf->resv */
 		alloc_size += 1;
 
-	if (WARN_ON(!priv || !ops
-			  || !ops->map_dma_buf
-			  || !ops->unmap_dma_buf
-			  || !ops->release
-			  || !ops->kmap_atomic
-			  || !ops->kmap
-			  || !ops->mmap)) {
+	if (WARN_ON(!exp_info->priv
+			  || !exp_info->ops
+			  || !exp_info->ops->map_dma_buf
+			  || !exp_info->ops->unmap_dma_buf
+			  || !exp_info->ops->release
+			  || !exp_info->ops->kmap_atomic
+			  || !exp_info->ops->kmap
+			  || !exp_info->ops->mmap)) {
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -309,21 +310,22 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 	if (dmabuf == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	dmabuf->priv = priv;
-	dmabuf->ops = ops;
-	dmabuf->size = size;
-	dmabuf->exp_name = exp_name;
+	dmabuf->priv = exp_info->priv;
+	dmabuf->ops = exp_info->ops;
+	dmabuf->size = exp_info->size;
+	dmabuf->exp_name = exp_info->exp_name;
 	init_waitqueue_head(&dmabuf->poll);
 	dmabuf->cb_excl.poll = dmabuf->cb_shared.poll = &dmabuf->poll;
 	dmabuf->cb_excl.active = dmabuf->cb_shared.active = 0;
 
-	if (!resv) {
-		resv = (struct reservation_object *)&dmabuf[1];
-		reservation_object_init(resv);
+	if (!exp_info->resv) {
+		exp_info->resv = (struct reservation_object *)&dmabuf[1];
+		reservation_object_init(exp_info->resv);
 	}
-	dmabuf->resv = resv;
+	dmabuf->resv = exp_info->resv;
 
-	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf, flags);
+	file = anon_inode_getfile("dmabuf", &dma_buf_fops, dmabuf,
+					exp_info->flags);
 	if (IS_ERR(file)) {
 		kfree(dmabuf);
 		return ERR_CAST(file);
@@ -341,8 +343,7 @@ struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
 
 	return dmabuf;
 }
-EXPORT_SYMBOL_GPL(dma_buf_export_named);
-
+EXPORT_SYMBOL_GPL(dma_buf_export);
 
 /**
  * dma_buf_fd - returns a file descriptor for the given dma_buf
diff --git a/drivers/gpu/drm/armada/armada_gem.c b/drivers/gpu/drm/armada/armada_gem.c
index ef5feeecec84..5d109c3dd326 100644
--- a/drivers/gpu/drm/armada/armada_gem.c
+++ b/drivers/gpu/drm/armada/armada_gem.c
@@ -538,8 +538,16 @@ struct dma_buf *
 armada_gem_prime_export(struct drm_device *dev, struct drm_gem_object *obj,
 	int flags)
 {
-	return dma_buf_export(obj, &armada_gem_prime_dmabuf_ops, obj->size,
-			      O_RDWR, NULL);
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &armada_gem_prime_dmabuf_ops,
+		.size = obj->size,
+		.flags = O_RDWR,
+		.resv = NULL,
+		.priv = obj,
+	};
+
+	return dma_buf_export(&exp_info);
 }
 
 struct drm_gem_object *
diff --git a/drivers/gpu/drm/drm_prime.c b/drivers/gpu/drm/drm_prime.c
index 7482b06cd08f..20ae77455c04 100644
--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -339,13 +339,19 @@ static const struct dma_buf_ops drm_gem_prime_dmabuf_ops =  {
 struct dma_buf *drm_gem_prime_export(struct drm_device *dev,
 				     struct drm_gem_object *obj, int flags)
 {
-	struct reservation_object *robj = NULL;
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &drm_gem_prime_dmabuf_ops,
+		.size = obj->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = obj,
+	};
 
 	if (dev->driver->gem_prime_res_obj)
-		robj = dev->driver->gem_prime_res_obj(obj);
+		exp_info.resv = dev->driver->gem_prime_res_obj(obj);
 
-	return dma_buf_export(obj, &drm_gem_prime_dmabuf_ops, obj->size,
-			      flags, robj);
+	return dma_buf_export(&exp_info);
 }
 EXPORT_SYMBOL(drm_gem_prime_export);
 
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index 60192ed544f0..abc65a02dffa 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -185,9 +185,16 @@ struct dma_buf *exynos_dmabuf_prime_export(struct drm_device *drm_dev,
 				struct drm_gem_object *obj, int flags)
 {
 	struct exynos_drm_gem_obj *exynos_gem_obj = to_exynos_gem_obj(obj);
-
-	return dma_buf_export(obj, &exynos_dmabuf_ops,
-				exynos_gem_obj->base.size, flags, NULL);
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &exynos_dmabuf_ops,
+		.size = exynos_gem_obj->base.size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = obj,
+	};
+
+	return dma_buf_export(&exp_info);
 }
 
 struct drm_gem_object *exynos_dmabuf_prime_import(struct drm_device *drm_dev,
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 82a1f4b57778..15fa1523aefc 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -229,6 +229,15 @@ static const struct dma_buf_ops i915_dmabuf_ops =  {
 struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
 				      struct drm_gem_object *gem_obj, int flags)
 {
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &i915_dmabuf_ops,
+		.size = gem_obj->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = gem_obj,
+	};
+
 	struct drm_i915_gem_object *obj = to_intel_bo(gem_obj);
 
 	if (obj->ops->dmabuf_export) {
@@ -237,8 +246,7 @@ struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
 			return ERR_PTR(ret);
 	}
 
-	return dma_buf_export(gem_obj, &i915_dmabuf_ops, gem_obj->size, flags,
-			      NULL);
+	return dma_buf_export(&exp_info);
 }
 
 static int i915_gem_object_get_pages_dmabuf(struct drm_i915_gem_object *obj)
diff --git a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
index a2dbfb1737b4..534718416f5e 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -171,7 +171,16 @@ static struct dma_buf_ops omap_dmabuf_ops = {
 struct dma_buf *omap_gem_prime_export(struct drm_device *dev,
 		struct drm_gem_object *obj, int flags)
 {
-	return dma_buf_export(obj, &omap_dmabuf_ops, obj->size, flags, NULL);
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &omap_dmabuf_ops,
+		.size = obj->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = obj,
+	};
+
+	return dma_buf_export(&exp_info);
 }
 
 struct drm_gem_object *omap_gem_prime_import(struct drm_device *dev,
diff --git a/drivers/gpu/drm/tegra/gem.c b/drivers/gpu/drm/tegra/gem.c
index 8777b7f75791..79a0fbc32ad4 100644
--- a/drivers/gpu/drm/tegra/gem.c
+++ b/drivers/gpu/drm/tegra/gem.c
@@ -658,8 +658,16 @@ struct dma_buf *tegra_gem_prime_export(struct drm_device *drm,
 				       struct drm_gem_object *gem,
 				       int flags)
 {
-	return dma_buf_export(gem, &tegra_gem_prime_dmabuf_ops, gem->size,
-			      flags, NULL);
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &tegra_gem_prime_dmabuf_ops,
+		.size = gem->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = gem,
+	};
+
+	return dma_buf_export(&exp_info);
 }
 
 struct drm_gem_object *tegra_gem_prime_import(struct drm_device *drm,
diff --git a/drivers/gpu/drm/ttm/ttm_object.c b/drivers/gpu/drm/ttm/ttm_object.c
index 12c87110db3a..2274f1637b89 100644
--- a/drivers/gpu/drm/ttm/ttm_object.c
+++ b/drivers/gpu/drm/ttm/ttm_object.c
@@ -683,6 +683,14 @@ int ttm_prime_handle_to_fd(struct ttm_object_file *tfile,
 
 	dma_buf = prime->dma_buf;
 	if (!dma_buf || !get_dma_buf_unless_doomed(dma_buf)) {
+		struct dma_buf_export_info exp_info = {
+			.exp_name = KBUILD_MODNAME,
+			.ops = &tdev->ops,
+			.size = prime->size,
+			.flags = flags,
+			.resv = NULL,
+			.priv = prime,
+		};
 
 		/*
 		 * Need to create a new dma_buf, with memory accounting.
@@ -694,8 +702,7 @@ int ttm_prime_handle_to_fd(struct ttm_object_file *tfile,
 			goto out_unref;
 		}
 
-		dma_buf = dma_buf_export(prime, &tdev->ops,
-					 prime->size, flags, NULL);
+		dma_buf = dma_buf_export(&exp_info);
 		if (IS_ERR(dma_buf)) {
 			ret = PTR_ERR(dma_buf);
 			ttm_mem_global_free(tdev->mem_glob,
diff --git a/drivers/gpu/drm/udl/udl_dmabuf.c b/drivers/gpu/drm/udl/udl_dmabuf.c
index ac8a66b4dfc2..0e200009bae7 100644
--- a/drivers/gpu/drm/udl/udl_dmabuf.c
+++ b/drivers/gpu/drm/udl/udl_dmabuf.c
@@ -202,7 +202,15 @@ static struct dma_buf_ops udl_dmabuf_ops = {
 struct dma_buf *udl_gem_prime_export(struct drm_device *dev,
 				     struct drm_gem_object *obj, int flags)
 {
-	return dma_buf_export(obj, &udl_dmabuf_ops, obj->size, flags, NULL);
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &udl_dmabuf_ops,
+		.size = obj->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = obj,
+	};
+	return dma_buf_export(&exp_info);
 }
 
 static int udl_prime_create(struct drm_device *dev,
diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
index b481d20c8372..2b3c494e18c9 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
@@ -402,6 +402,14 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 {
 	struct vb2_dc_buf *buf = buf_priv;
 	struct dma_buf *dbuf;
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &vb2_dc_dmabuf_ops,
+		.size = buf->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = buf,
+	};
 
 	if (!buf->sgt_base)
 		buf->sgt_base = vb2_dc_get_base_sgt(buf);
@@ -409,7 +417,7 @@ static struct dma_buf *vb2_dc_get_dmabuf(void *buf_priv, unsigned long flags)
 	if (WARN_ON(!buf->sgt_base))
 		return NULL;
 
-	dbuf = dma_buf_export(buf, &vb2_dc_dmabuf_ops, buf->size, flags, NULL);
+	dbuf = dma_buf_export(&exp_info);
 	if (IS_ERR(dbuf))
 		return NULL;
 
diff --git a/drivers/media/v4l2-core/videobuf2-dma-sg.c b/drivers/media/v4l2-core/videobuf2-dma-sg.c
index b1838abb6d00..5a9835655146 100644
--- a/drivers/media/v4l2-core/videobuf2-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf2-dma-sg.c
@@ -583,11 +583,19 @@ static struct dma_buf *vb2_dma_sg_get_dmabuf(void *buf_priv, unsigned long flags
 {
 	struct vb2_dma_sg_buf *buf = buf_priv;
 	struct dma_buf *dbuf;
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &vb2_dma_sg_dmabuf_ops,
+		.size = buf->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = buf,
+	};
 
 	if (WARN_ON(!buf->dma_sgt))
 		return NULL;
 
-	dbuf = dma_buf_export(buf, &vb2_dma_sg_dmabuf_ops, buf->size, flags, NULL);
+	dbuf = dma_buf_export(&exp_info);
 	if (IS_ERR(dbuf))
 		return NULL;
 
diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
index fba944e50227..fb61090f43c6 100644
--- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
+++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
@@ -367,11 +367,19 @@ static struct dma_buf *vb2_vmalloc_get_dmabuf(void *buf_priv, unsigned long flag
 {
 	struct vb2_vmalloc_buf *buf = buf_priv;
 	struct dma_buf *dbuf;
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &vb2_vmalloc_dmabuf_ops,
+		.size = buf->size,
+		.flags = flags,
+		.resv = NULL,
+		.priv = buf,
+	};
 
 	if (WARN_ON(!buf->vaddr))
 		return NULL;
 
-	dbuf = dma_buf_export(buf, &vb2_vmalloc_dmabuf_ops, buf->size, flags, NULL);
+	dbuf = dma_buf_export(&exp_info);
 	if (IS_ERR(dbuf))
 		return NULL;
 
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 296d347660fc..8eff2607f370 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -1106,6 +1106,14 @@ struct dma_buf *ion_share_dma_buf(struct ion_client *client,
 	struct ion_buffer *buffer;
 	struct dma_buf *dmabuf;
 	bool valid_handle;
+	struct dma_buf_export_info exp_info = {
+		.exp_name = KBUILD_MODNAME,
+		.ops = &dma_buf_ops,
+		.size = buffer->size,
+		.flags = O_RDWR,
+		.resv = NULL,
+		.priv = buffer,
+	};
 
 	mutex_lock(&client->lock);
 	valid_handle = ion_handle_validate(client, handle);
@@ -1118,8 +1126,7 @@ struct dma_buf *ion_share_dma_buf(struct ion_client *client,
 	ion_buffer_get(buffer);
 	mutex_unlock(&client->lock);
 
-	dmabuf = dma_buf_export(buffer, &dma_buf_ops, buffer->size, O_RDWR,
-				NULL);
+	dmabuf = dma_buf_export(&exp_info);
 	if (IS_ERR(dmabuf)) {
 		ion_buffer_put(buffer);
 		return dmabuf;
diff --git a/include/linux/dma-buf.h b/include/linux/dma-buf.h
index 694e1fe1c4b4..c5f3c9510368 100644
--- a/include/linux/dma-buf.h
+++ b/include/linux/dma-buf.h
@@ -163,6 +163,27 @@ struct dma_buf_attachment {
 };
 
 /**
+ * struct dma_buf_export_info - holds information needed to export a dma_buf
+ * @exp_name:	name of the exporting module - useful for debugging.
+ * @ops:	Attach allocator-defined dma buf ops to the new buffer
+ * @size:	Size of the buffer
+ * @flags:	mode flags for the file
+ * @resv:	reservation-object, NULL to allocate default one
+ * @priv:	Attach private data of allocator to this buffer
+ *
+ * This structure holds the information required to export the buffer. Used
+ * with dma_buf_export() only.
+ */
+struct dma_buf_export_info {
+	const char *exp_name;
+	const struct dma_buf_ops *ops;
+	size_t size;
+	int flags;
+	struct reservation_object *resv;
+	void *priv;
+};
+
+/**
  * get_dma_buf - convenience wrapper for get_file.
  * @dmabuf:	[in]	pointer to dma_buf
  *
@@ -181,12 +202,7 @@ struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
 void dma_buf_detach(struct dma_buf *dmabuf,
 				struct dma_buf_attachment *dmabuf_attach);
 
-struct dma_buf *dma_buf_export_named(void *priv, const struct dma_buf_ops *ops,
-			       size_t size, int flags, const char *,
-			       struct reservation_object *);
-
-#define dma_buf_export(priv, ops, size, flags, resv)	\
-	dma_buf_export_named(priv, ops, size, flags, KBUILD_MODNAME, resv)
+struct dma_buf *dma_buf_export(struct dma_buf_export_info *exp_info);
 
 int dma_buf_fd(struct dma_buf *dmabuf, int flags);
 struct dma_buf *dma_buf_get(int fd);
-- 
1.9.1

