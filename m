Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbaFEABr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:01:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaFDXXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Ben Widawsky <ben@bwidawsk.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 3.14 183/228] drm/i915: Fix unsafe loop iteration over vma whilst unbinding them
Date: Wed,  4 Jun 2014 16:23:32 -0700
Message-Id: <20140604232353.912436003@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Chris Wilson <chris@chris-wilson.co.uk>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_gem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3529,7 +3529,7 @@ int i915_gem_object_set_cache_level(stru
 {
 	struct drm_device *dev = obj->base.dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct i915_vma *vma;
+	struct i915_vma *vma, *next;
 	int ret;
 
 	if (obj->cache_level == cache_level)
@@ -3540,7 +3540,7 @@ int i915_gem_object_set_cache_level(stru
 		return -EBUSY;
 	}
 
-	list_for_each_entry(vma, &obj->vma_list, vma_link) {
+	list_for_each_entry_safe(vma, next, &obj->vma_list, vma_link) {
 		if (!i915_gem_valid_gtt_space(dev, &vma->node, cache_level)) {
 			ret = i915_vma_unbind(vma);
 			if (ret)


