Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaAOV6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:58:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41122 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbaAOV6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:58:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 060/166] drm/i915: Hold mutex across i915_gem_release
Date: Wed, 15 Jan 2014 13:51:14 -0800
Message-Id: <1389822780-4729-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 0d1430a3f4b7cfd8779b78740a4182321f3ca7f3 upstream.

Inorder to serialise the closing of the file descriptor and its
subsequent release of client requests with i915_gem_free_request(), we
need to hold the struct_mutex in i915_gem_release(). Failing to do so
has the potential to trigger an OOPS, later with a use-after-free.

Testcase: igt/gem_close_race
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=70874
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=71029
Reported-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_dma.c         | 2 ++
 drivers/gpu/drm/i915/i915_gem_context.c | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index ef781e7..92896bf 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1794,8 +1794,10 @@ void i915_driver_lastclose(struct drm_device * dev)
 
 void i915_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
 {
+	mutex_lock(&dev->struct_mutex);
 	i915_gem_context_close(dev, file_priv);
 	i915_gem_release(dev, file_priv);
+	mutex_unlock(&dev->struct_mutex);
 }
 
 void i915_driver_postclose(struct drm_device *dev, struct drm_file *file)
diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index a80bba9..e75cac6 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -310,10 +310,8 @@ void i915_gem_context_close(struct drm_device *dev, struct drm_file *file)
 {
 	struct drm_i915_file_private *file_priv = file->driver_priv;
 
-	mutex_lock(&dev->struct_mutex);
 	idr_for_each(&file_priv->context_idr, context_idr_cleanup, NULL);
 	idr_destroy(&file_priv->context_idr);
-	mutex_unlock(&dev->struct_mutex);
 }
 
 static struct i915_hw_context *
-- 
1.8.3.2

