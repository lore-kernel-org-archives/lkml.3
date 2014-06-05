Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaFEEbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:31:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaFEEWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:22:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jon Bloomfield <jon.bloomfield@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 179/214] drm/i915: Workaround incoherence between fences and LLC across multiple CPUs
Date: Wed,  4 Jun 2014 21:19:02 -0700
Message-Id: <20140605041703.540564481@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2468,6 +2468,11 @@ i915_find_fence_reg(struct drm_device *d
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
@@ -2589,6 +2594,17 @@ update:
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


