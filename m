Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935206Ab3GWWgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:36:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41819 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934811Ab3GWW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 080/103] drm/i915: Only clear write-domains after a successful wait-seqno
Date: Tue, 23 Jul 2013 15:26:31 -0700
Message-Id: <20130723220429.196416052@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1160,7 +1160,8 @@ i915_gem_object_wait_rendering__nonblock
 	/* Manually manage the write flush as we may have not yet
 	 * retired the buffer.
 	 */
-	if (obj->last_write_seqno &&
+	if (ret == 0 &&
+	    obj->last_write_seqno &&
 	    i915_seqno_passed(seqno, obj->last_write_seqno)) {
 		obj->last_write_seqno = 0;
 		obj->base.write_domain &= ~I915_GEM_GPU_DOMAINS;


