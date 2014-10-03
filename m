Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759060AbaJCXwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:52:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaJCVxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 3.14 052/238] drm/i915: Fix EIO/wedged handling in gem fault handler
Date: Fri,  3 Oct 2014 14:29:27 -0700
Message-Id: <20141003212915.340533693@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1426,10 +1426,13 @@ unlock:
 out:
 	switch (ret) {
 	case -EIO:
-		/* If this -EIO is due to a gpu hang, give the reset code a
-		 * chance to clean up the mess. Otherwise return the proper
-		 * SIGBUS. */
-		if (i915_terminally_wedged(&dev_priv->gpu_error)) {
+		/*
+		 * We eat errors when the gpu is terminally wedged to avoid
+		 * userspace unduly crashing (gl has no provisions for mmaps to
+		 * fail). But any other -EIO isn't ours (e.g. swap in failure)
+		 * and so needs to be reported.
+		 */
+		if (!i915_terminally_wedged(&dev_priv->gpu_error)) {
 			ret = VM_FAULT_SIGBUS;
 			break;
 		}


