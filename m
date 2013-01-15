Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307Ab3AOWaj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:30:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:42060 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890Ab3AOWae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:30:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        "Kyungmin.park" <kyungmin.park@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <rob.clark@linaro.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 085/221] drm/prime: drop reference on imported dma-buf come from gem
Date: Tue, 15 Jan 2013 10:50:12 -0800
Message-Id: <20130115185004.180526592@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    5 +++++
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    5 +++++
 drivers/gpu/drm/nouveau/nouveau_prime.c    |    1 +
 drivers/gpu/drm/radeon/radeon_prime.c      |    1 +
 drivers/staging/omapdrm/omap_gem_dmabuf.c  |    5 +++++
 5 files changed, 17 insertions(+)

--- a/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dmabuf.c
@@ -210,7 +210,12 @@ struct drm_gem_object *exynos_dmabuf_pri
 
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
--- a/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+++ b/drivers/gpu/drm/i915/i915_gem_dmabuf.c
@@ -266,7 +266,12 @@ struct drm_gem_object *i915_gem_prime_im
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
--- a/drivers/gpu/drm/nouveau/nouveau_prime.c
+++ b/drivers/gpu/drm/nouveau/nouveau_prime.c
@@ -197,6 +197,7 @@ struct drm_gem_object *nouveau_gem_prime
 		if (nvbo->gem) {
 			if (nvbo->gem->dev == dev) {
 				drm_gem_object_reference(nvbo->gem);
+				dma_buf_put(dma_buf);
 				return nvbo->gem;
 			}
 		}
--- a/drivers/gpu/drm/radeon/radeon_prime.c
+++ b/drivers/gpu/drm/radeon/radeon_prime.c
@@ -194,6 +194,7 @@ struct drm_gem_object *radeon_gem_prime_
 		bo = dma_buf->priv;
 		if (bo->gem_base.dev == dev) {
 			drm_gem_object_reference(&bo->gem_base);
+			dma_buf_put(dma_buf);
 			return &bo->gem_base;
 		}
 	}
--- a/drivers/staging/omapdrm/omap_gem_dmabuf.c
+++ b/drivers/staging/omapdrm/omap_gem_dmabuf.c
@@ -207,7 +207,12 @@ struct drm_gem_object * omap_gem_prime_i
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


