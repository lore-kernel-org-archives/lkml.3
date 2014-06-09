Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936294AbaFIJ1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:27:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932780AbaFIJ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 121/146] drm/i915: Fix unsafe loop iteration over vma whilst unbinding them
Date: Mon,  9 Jun 2014 10:50:56 +0200
Message-Id: <431b636f4cb9a5592f607ee68bf2e83612cbf182.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

This is commit df6f783a4ef6790780a67c491897ac upstream.

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/i915/i915_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index b00b32c992b0..35066a9b535f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3419,7 +3419,7 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
 {
 	struct drm_device *dev = obj->base.dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct i915_vma *vma;
+	struct i915_vma *vma, *next;
 	int ret;
 
 	if (obj->cache_level == cache_level)
@@ -3430,7 +3430,7 @@ int i915_gem_object_set_cache_level(struct drm_i915_gem_object *obj,
 		return -EBUSY;
 	}
 
-	list_for_each_entry(vma, &obj->vma_list, vma_link) {
+	list_for_each_entry_safe(vma, next, &obj->vma_list, vma_link) {
 		if (!i915_gem_valid_gtt_space(dev, &vma->node, cache_level)) {
 			ret = i915_vma_unbind(vma);
 			if (ret)
-- 
1.9.3

