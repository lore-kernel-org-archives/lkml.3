Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3EJO3J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:29:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57266 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755937Ab3EJOV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        "Jon Bloomfield" <jon.bloomfield@intel.com>,
        Jon Bloomfield <jon.bloomfield@intel.com> (v2),
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Daniel Vetter" <daniel.vetter@ffwll.ch>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.977725362@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [040/118] drm/i915: Workaround incoherence between fences and LLC
 across multiple CPUs
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 25ff1195f8a0b3724541ae7bbe331b4296de9c06 upstream.

In order to fully serialize access to the fenced region and the update
to the fence register we need to take extreme measures on SNB+, and
manually flush writes to memory prior to writing the fence register in
conjunction with the memory barriers placed around the register write.

Fixes i-g-t/gem_fence_thrash

v2: Bring a bigger gun
v3: Switch the bigger gun for heavier bullets (Arjan van de Ven)
v4: Remove changes for working generations.
v5: Reduce to a per-cpu wbinvd() call prior to updating the fences.
v6: Rewrite comments to ellide forgotten history.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=62191
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jon Bloomfield <jon.bloomfield@intel.com>
Tested-by: Jon Bloomfield <jon.bloomfield@intel.com> (v2)
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
[bwh: Backported to 3.2: insert the cache flush in i915_gem_object_get_fence()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2520,6 +2520,11 @@ i915_find_fence_reg(struct drm_device *d
 	return avail;
 }
 
+static void i915_gem_write_fence__ipi(void *data)
+{
+	wbinvd();
+}
+
 /**
  * i915_gem_object_get_fence - set up a fence reg for an object
  * @obj: object to map through a fence reg
@@ -2640,6 +2645,17 @@ update:
 	switch (INTEL_INFO(dev)->gen) {
 	case 7:
 	case 6:
+		/* In order to fully serialize access to the fenced region and
+		 * the update to the fence register we need to take extreme
+		 * measures on SNB+. In theory, the write to the fence register
+		 * flushes all memory transactions before, and coupled with the
+		 * mb() placed around the register write we serialise all memory
+		 * operations with respect to the changes in the tiler. Yet, on
+		 * SNB+ we need to take a step further and emit an explicit wbinvd()
+		 * on each processor in order to manually flush all memory
+		 * transactions before updating the fence register.
+		 */
+		on_each_cpu(i915_gem_write_fence__ipi, NULL, 1);
 		ret = sandybridge_write_fence_reg(obj, pipelined);
 		break;
 	case 5:

