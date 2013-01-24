Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3AXDnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:43:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44196 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab3AXD2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:28:54 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 20/74] drm/i915; Only increment the user-pin-count after successfully pinning the bo
Date: Thu, 24 Jan 2013 01:26:32 -0200
Message-Id: <1358998046-613-21-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 93be8788e648817d62fda33e2998eb6ca6ebf3a3 upstream.

As along the error path we do not correct the user pin-count for the
failure, we may end up with userspace believing that it has a pinned
object at offset 0 (when interrupted by a signal for example).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[ herton: adjust context ]
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 4dc8a9b..7605f40 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3125,14 +3125,15 @@ i915_gem_pin_ioctl(struct drm_device *dev, void *data,
 		goto out;
 	}
 
-	obj->user_pin_count++;
-	obj->pin_filp = file;
-	if (obj->user_pin_count == 1) {
+	if (obj->user_pin_count == 0) {
 		ret = i915_gem_object_pin(obj, args->alignment, true);
 		if (ret)
 			goto out;
 	}
 
+	obj->user_pin_count++;
+	obj->pin_filp = file;
+
 	/* XXX - flush the CPU caches for pinned objects
 	 * as the X server doesn't manage domains yet
 	 */
-- 
1.7.9.5

