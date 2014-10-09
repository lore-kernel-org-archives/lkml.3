Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaJIVH0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:07:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59097 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaJIVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:07:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 032/163] drm/i915: Fix EIO/wedged handling in gem fault handler
Date: Thu,  9 Oct 2014 14:00:57 -0700
Message-Id: <1412888588-26755-33-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 2232f0315c6688f5ff6b2067ea88d97542034873 upstream.

In

commit 1f83fee08d625f8d0130f9fe5ef7b17c2e022f3c
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Thu Nov 15 17:17:22 2012 +0100

    drm/i915: clear up wedged transitions

I've accidentally inverted the EIO/wedged handling in the fault
handler: We want to return the EIO as a SIGBUS only if it's not
because of the gpu having died, to prevent userspace from unduly
dying.

In my defence the comment right above is completely misleading, so fix
both.

v2: Drop the WARN_ON, it's not actually a bug to e.g. receive an -EIO
when swap-in fails.

v3: Don't remove too much ... oops.

Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index e716cd0..f264654 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1424,10 +1424,13 @@ unlock:
 out:
 	switch (ret) {
 	case -EIO:
-		/* If this -EIO is due to a gpu hang, give the reset code a
-		 * chance to clean up the mess. Otherwise return the proper
-		 * SIGBUS. */
-		if (i915_terminally_wedged(&dev_priv->gpu_error))
+		/*
+		 * We eat errors when the gpu is terminally wedged to avoid
+		 * userspace unduly crashing (gl has no provisions for mmaps to
+		 * fail). But any other -EIO isn't ours (e.g. swap in failure)
+		 * and so needs to be reported.
+		 */
+		if (!i915_terminally_wedged(&dev_priv->gpu_error))
 			return VM_FAULT_SIGBUS;
 	case -EAGAIN:
 		/*
-- 
1.9.1

