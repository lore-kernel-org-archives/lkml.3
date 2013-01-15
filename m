Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab3APAXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:23:38 -0500
Received: from mail.kernel.org ([198.145.19.201]:41980 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758230Ab3AOWaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:30:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 087/221] drm/i915; Only increment the user-pin-count after successfully pinning the bo
Date: Tue, 15 Jan 2013 10:50:14 -0800
Message-Id: <20130115185004.318924317@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 93be8788e648817d62fda33e2998eb6ca6ebf3a3 upstream.

As along the error path we do not correct the user pin-count for the
failure, we may end up with userspace believing that it has a pinned
object at offset 0 (when interrupted by a signal for example).

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3511,14 +3511,15 @@ i915_gem_pin_ioctl(struct drm_device *de
 		goto out;
 	}
 
-	obj->user_pin_count++;
-	obj->pin_filp = file;
-	if (obj->user_pin_count == 1) {
+	if (obj->user_pin_count == 0) {
 		ret = i915_gem_object_pin(obj, args->alignment, true, false);
 		if (ret)
 			goto out;
 	}
 
+	obj->user_pin_count++;
+	obj->pin_filp = file;
+
 	/* XXX - flush the CPU caches for pinned objects
 	 * as the X server doesn't manage domains yet
 	 */


