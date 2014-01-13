Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaAMRFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:05:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52948 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbaAMQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:40 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Lister <ian.lister@intel.com>,
        Ben Widawsky <benjamin.widawsky@intel.com>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        "Bloomfield, Jon" <jon.bloomfield@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 032/208] drm/i915: Fix use-after-free in do_switch
Date: Mon, 13 Jan 2014 15:57:53 +0000
Message-Id: <1389628849-1614-33-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit acc240d41ea1ab9c488a79219fb313b5b46265ae upstream.

So apparently under ridiculous amounts of memory pressure we can get
into trouble in do_switch when we try to move the old hw context
backing storage object onto the active lists.

With list debugging enabled that usually results in us chasing a
poisoned pointer - which means we've hit upon a vma that has been
removed from all lrus with list_del (and then deallocated, so it's a
real use-after free).

Ian Lister has done some great callchain chasing and noticed that we
can reenter do_switch:

i915_gem_do_execbuffer()

i915_switch_context()

do_switch()
   from = ring->last_context;
   i915_gem_object_pin()

      i915_gem_object_bind_to_gtt()
         ret = drm_mm_insert_node_in_range_generic();
         // If the above call fails then it will try i915_gem_evict_something()
         // If that fails it will call i915_gem_evict_everything() ...
	 i915_gem_evict_everything()
	    i915_gpu_idle()
	       i915_switch_context(DEFAULT_CONTEXT)

Like with everything else where the shrinker or eviction code can
invalidate pointers we need to reload relevant state.

Note that there's no need to recheck whether a context switch is still
required because:

- Doing a switch to the same context is harmless (besides wasting a
  bit of energy).

- This can only happen with the default context. But since that one's
  pinned we'll never call down into evict_everything under normal
  circumstances. Note that there's a little driver bringup fun
  involved namely that we could recourse into do_switch for the
  initial switch. Atm we're fine since we assign the context pointer
  only after the call to do_switch at driver load or resume time. And
  in the gpu reset case we skip the entire setup sequence (which might
  be a bug on its own, but definitely not this one here).

Cc'ing stable since apparently ChromeOS guys are seeing this in the
wild (and not just on artificial stress tests), see the reference.

Note that in upstream code doesn't calle evict_everything directly
from evict_something, that's an extension in this product branch. But
we can still hit upon this bug (and apparently we do, see the linked
backtraces). I've noticed this while trying to construct a testcase
for this bug and utterly failed to provoke it. It looks like we need
to driver the system squarly into the lowmem wall and provoke the
shrinker to evict the context object by doing the last-ditch
evict_everything call.

Aside: There's currently no means to get a badly-fragmenting hw
context object away from a bad spot in the upstream code. We should
fix this by at least adding some code to evict_something to handle hw
contexts.

References: https://code.google.com/p/chromium/issues/detail?id=248191
Reported-by: Ian Lister <ian.lister@intel.com>
Cc: Ian Lister <ian.lister@intel.com>
Cc: Ben Widawsky <benjamin.widawsky@intel.com>
Cc: Stéphane Marchesin <marcheu@chromium.org>
Cc: Bloomfield, Jon <jon.bloomfield@intel.com>
Tested-by: Rafael Barbalho <rafael.barbalho@intel.com>
Reviewed-by: Ian Lister <ian.lister@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_context.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_context.c b/drivers/gpu/drm/i915/i915_gem_context.c
index 90b0491..5b3087f 100644
--- a/drivers/gpu/drm/i915/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/i915_gem_context.c
@@ -409,11 +409,21 @@ static int do_switch(struct i915_hw_context *to)
 	if (ret)
 		return ret;
 
-	/* Clear this page out of any CPU caches for coherent swap-in/out. Note
+	/*
+	 * Pin can switch back to the default context if we end up calling into
+	 * evict_everything - as a last ditch gtt defrag effort that also
+	 * switches to the default context. Hence we need to reload from here.
+	 */
+	from = ring->last_context;
+
+	/*
+	 * Clear this page out of any CPU caches for coherent swap-in/out. Note
 	 * that thanks to write = false in this call and us not setting any gpu
 	 * write domains when putting a context object onto the active list
 	 * (when switching away from it), this won't block.
-	 * XXX: We need a real interface to do this instead of trickery. */
+	 *
+	 * XXX: We need a real interface to do this instead of trickery.
+	 */
 	ret = i915_gem_object_set_to_gtt_domain(to->obj, false);
 	if (ret) {
 		i915_gem_object_unpin(to->obj);
-- 
1.8.3.2

