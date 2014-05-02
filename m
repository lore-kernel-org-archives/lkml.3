Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaEBPpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:45:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44171 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaEBPpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:45:10 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 086/151] drm/i915: Fix unsafe loop iteration over vma whilst unbinding them
Date: Fri,  2 May 2014 08:37:54 -0700
Message-Id: <1399045139-4531-87-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit df6f783a4ef6790780a67c491897ac45c4618735 upstream.

On non-LLC platforms, when changing the cache level of an object, we may
need to unbind it so that prefetching across page boundaries does not
cross into a different memory domain. This requires us to unbind
conflicting vma, but we did so iterating over the objects vma in an
unsafe manner (as the list was being modified as we iterated).

The regression was introduced in
commit 3089c6f239d7d2c4cb2dd5c353e8984cf79af1d7
Author: Ben Widawsky <ben@bwidawsk.net>
Date:   Wed Jul 31 17:00:03 2013 -0700

    drm/i915: make caching operate on all address spaces
apparently as far back as v3.12-rc1, but it has only just begun to
trigger real world bug reports.

Reported-and-tested-by: Nikolay Martynov <mar.kolya@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=76384
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Ben Widawsky <ben@bwidawsk.net>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 76d3d1a..e716cd0 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3486,7 +3486,7 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
 {
 	struct drm_device *dev = obj->base.dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct i915_vma *vma;
+	struct i915_vma *vma, *next;
 	int ret;
 
 	if (obj->cache_level == cache_level)
@@ -3497,7 +3497,7 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
 		return -EBUSY;
 	}
 
-	list_for_each_entry(vma, &obj->vma_list, vma_link) {
+	list_for_each_entry_safe(vma, next, &obj->vma_list, vma_link) {
 		if (!i915_gem_valid_gtt_space(dev, &vma->node, cache_level)) {
 			ret = i915_vma_unbind(vma);
 			if (ret)
-- 
1.9.1

