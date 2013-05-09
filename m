Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3EIW0c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:26:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3EIW01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Imre Deak <imre.deak@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 29/73] drm: prime: fix refcounting on the dmabuf import error path
Date: Thu,  9 May 2013 15:25:19 -0700
Message-Id: <20130509222529.429805155@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 011c2282c74db120f01a8414edc66c3f217f5511 upstream.

In commit be8a42ae60 we inroduced a refcount problem, where on the
drm_gem_prime_fd_to_handle() error path we'll call dma_buf_put() for
self imported dma buffers.

Fix this by taking a reference on the dma buffer in the .gem_import
hook instead of assuming the caller had taken one. Besides fixing the
bug this is also more logical.

Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_prime.c                |    8 +++++++-
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    4 +++-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    5 ++++-
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c  |    1 -
 drivers/gpu/drm/udl/udl_gem.c              |    4 ++++
 5 files changed, 18 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/drm_prime.c
+++ b/drivers/gpu/drm/drm_prime.c
@@ -268,7 +268,6 @@ struct drm_gem_object *drm_gem_prime_imp
 			 * refcount on gem itself instead of f_count of dmabuf.
 			 */
 			drm_gem_object_reference(obj);
-			dma_buf_put(dma_buf);
 			return obj;
 		}
 	}
@@ -277,6 +276,8 @@ struct drm_gem_object *drm_gem_prime_imp
 	if (IS_ERR(attach))
 		return ERR_PTR(PTR_ERR(attach));
 
+	get_dma_buf(dma_buf);
+
 	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR_OR_NULL(sgt)) {
 		ret = PTR_ERR(sgt);
@@ -297,6 +298,8 @@ fail_unmap:
 	dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
+	dma_buf_put(dma_buf);
+
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(drm_gem_prime_import);
@@ -339,6 +342,9 @@ int drm_gem_prime_fd_to_handle(struct dr
 		goto fail;
 
 	mutex_unlock(&file_priv->prime.lock);
+
+	dma_buf_put(dma_buf);
+
 	return 0;
 
 fail:
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -235,7 +235,6 @@ struct drm_gem_object *exynos_dmabuf_pri
 			 * refcount on gem itself instead of f_count of dmabuf.
 			 */
 			drm_gem_object_reference(obj);
-			dma_buf_put(dma_buf);
 			return obj;
 		}
 	}
@@ -244,6 +243,7 @@ struct drm_gem_object *exynos_dmabuf_pri
 	if (IS_ERR(attach))
 		return ERR_PTR(-EINVAL);
 
+	get_dma_buf(dma_buf);
 
 	sgt = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR_OR_NULL(sgt)) {
@@ -298,6 +298,8 @@ err_unmap_attach:
 	dma_buf_unmap_attachment(attach, sgt, DMA_BIDIRECTIONAL);
 err_buf_detach:
 	dma_buf_detach(dma_buf, attach);
+	dma_buf_put(dma_buf);
+
 	return ERR_PTR(ret);
 }
 
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -271,7 +271,6 @@ struct drm_gem_object *i915_gem_prime_im
 			 * refcount on gem itself instead of f_count of dmabuf.
 			 */
 			drm_gem_object_reference(&obj->base);
-			dma_buf_put(dma_buf);
 			return &obj->base;
 		}
 	}
@@ -281,6 +280,8 @@ struct drm_gem_object *i915_gem_prime_im
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
+	get_dma_buf(dma_buf);
+
 	obj = i915_gem_object_alloc(dev);
 	if (obj == NULL) {
 		ret = -ENOMEM;
@@ -300,5 +301,7 @@ struct drm_gem_object *i915_gem_prime_im
 
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
+	dma_buf_put(dma_buf);
+
 	return ERR_PTR(ret);
 }
--- a/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c
@@ -212,7 +212,6 @@ struct drm_gem_object *omap_gem_prime_im
 			 * refcount on gem itself instead of f_count of dmabuf.
 			 */
 			drm_gem_object_reference(obj);
-			dma_buf_put(buffer);
 			return obj;
 		}
 	}
--- a/drivers/gpu/drm/udl/udl_gem.c
+++ b/drivers/gpu/drm/udl/udl_gem.c
@@ -303,6 +303,8 @@ struct drm_gem_object *udl_gem_prime_imp
 	if (IS_ERR(attach))
 		return ERR_CAST(attach);
 
+	get_dma_buf(dma_buf);
+
 	sg = dma_buf_map_attachment(attach, DMA_BIDIRECTIONAL);
 	if (IS_ERR(sg)) {
 		ret = PTR_ERR(sg);
@@ -322,5 +324,7 @@ fail_unmap:
 	dma_buf_unmap_attachment(attach, sg, DMA_BIDIRECTIONAL);
 fail_detach:
 	dma_buf_detach(dma_buf, attach);
+	dma_buf_put(dma_buf);
+
 	return ERR_PTR(ret);
 }


