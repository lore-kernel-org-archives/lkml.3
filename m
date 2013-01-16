Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3APQLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:11:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:36968 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933007Ab3APQLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:11:44 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seung-Woo Kim <sw0312.kim@samsung.com>,
        "Kyungmin.park" <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <rob.clark@linaro.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 218/222] drm/prime: drop reference on imported dma-buf come from gem
Date: Wed, 16 Jan 2013 13:56:58 -0200
Message-Id: <1358351822-7675-219-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seung-Woo Kim <sw0312.kim@samsung.com>

commit be8a42ae60addd8b6092535c11b42d099d6470ec upstream.

Increasing ref counts of both dma-buf and gem for imported dma-buf come from gem
makes memory leak. release function of dma-buf cannot be called because f_count
of dma-buf increased by importing gem and gem ref count cannot be decrease
because of exported dma-buf.

So I add dma_buf_put() for imported gem come from its own gem into each drivers
having prime_import and prime_export capabilities. With this, only gem ref
count is increased if importing gem exported from gem of same driver.

Signed-off-by: Seung-Woo Kim <sw0312.kim@samsung.com>
Signed-off-by: Kyungmin.park <kyungmin.park@samsung.com>
Cc: Inki Dae <inki.dae@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <rob.clark@linaro.org>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    5 +++++
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    5 +++++
 drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
 drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
 drivers/staging/omapdrm/omap_gem_dmabuf.c  |    5 +++++
 5 files changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
index 2749092..e678be1 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -199,7 +199,12 @@ struct drm_gem_object *exynos_dmabuf_prime_import(struct drm_device *drm_dev,
 
 		/* is it from our device? */
 		if (obj->dev == drm_dev) {
+			/*
+			 * Importing dmabuf exported from out own gem increases
+			 * refcount on gem itself instead of f_count of dmabuf.
+			 */
 			drm_gem_object_reference(obj);
+			dma_buf_put(dma_buf);
 			return obj;
 		}
 	}
diff --git a/drivers/gpu/drm/i915/i915_gem_dmabuf.c b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
index 5d5493e..a233816 100644
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -187,7 +187,12 @@ struct drm_gem_object *i915_gem_prime_import(struct drm_device *dev,
 		obj = dma_buf->priv;
 		/* is it from our device? */
 		if (obj->base.dev == dev) {
+			/*
+			 * Importing dmabuf exported from out own gem increases
+			 * refcount on gem itself instead of f_count of dmabuf.
+			 */
 			drm_gem_object_reference(&obj->base);
+			dma_buf_put(dma_buf);
 			return &obj->base;
 		}
 	}
diff --git a/drivers/gpu/drm/nouveau/nouveau_prime.c b/drivers/gpu/drm/nouveau/nouveau_prime.c
index a25cf2c..bb653c6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -199,6 +199,7 @@ struct drm_gem_object *nouveau_gem_prime_import(struct drm_device *dev,
 		if (nvbo->gem) {
 			if (nvbo->gem->dev == dev) {
 				drm_gem_object_reference(nvbo->gem);
+				dma_buf_put(dma_buf);
 				return nvbo->gem;
 			}
 		}
diff --git a/drivers/gpu/drm/radeon/radeon_prime.c b/drivers/gpu/drm/radeon/radeon_prime.c
index 6bef46a..d344a3be 100644
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -195,6 +195,7 @@ struct drm_gem_object *radeon_gem_prime_import(struct drm_device *dev,
 		bo = dma_buf->priv;
 		if (bo->gem_base.dev == dev) {
 			drm_gem_object_reference(&bo->gem_base);
+			dma_buf_put(dma_buf);
 			return &bo->gem_base;
 		}
 	}
diff --git a/drivers/staging/omapdrm/omap_gem_dmabuf.c b/drivers/staging/omapdrm/omap_gem_dmabuf.c
index 42728e0..5b50eb6 100644
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -207,7 +207,12 @@ struct drm_gem_object * omap_gem_prime_import(struct drm_device *dev,
 		obj = buffer->priv;
 		/* is it from our device? */
 		if (obj->dev == dev) {
+			/*
+			 * Importing dmabuf exported from out own gem increases
+			 * refcount on gem itself instead of f_count of dmabuf.
+			 */
 			drm_gem_object_reference(obj);
+			dma_buf_put(buffer);
 			return obj;
 		}
 	}
-- 
1.7.9.5

