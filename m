Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934464Ab3GQWzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 18:55:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56582 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab3GQWzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:55:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 108/145] drm/i915: Only clear write-domains after a successful wait-seqno
Date: Wed, 17 Jul 2013 15:47:20 -0700
Message-Id: <1374101277-7915-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit daa13e1ca587bc773c1aae415ed1af6554117bd4 upstream.

In the introduction of the non-blocking wait, I cut'n'pasted the wait
completion code from normal locked path. Unfortunately, this neglected
that the normal path returned early if the wait returned early. The
result is that read-only waits may return whilst the GPU is still
writing to the bo.

Fixes regression from
commit 3236f57a0162391f84b93f39fc1882c49a8998c7 [v3.7]
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Fri Aug 24 09:35:09 2012 +0100

    drm/i915: Use a non-blocking wait for set-to-domain ioctl

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=66163
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 3b9d18b..80bc298 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1164,7 +1164,8 @@ i915_gem_object_wait_rendering__nonblocking(struct drm_i915_gem_object *obj,
 	/* Manually manage the write flush as we may have not yet
 	 * retired the buffer.
 	 */
-	if (obj->last_write_seqno &&
+	if (ret == 0 &&
+	    obj->last_write_seqno &&
 	    i915_seqno_passed(seqno, obj->last_write_seqno)) {
 		obj->last_write_seqno = 0;
 		obj->base.write_domain &= ~I915_GEM_GPU_DOMAINS;
-- 
1.8.1.2

