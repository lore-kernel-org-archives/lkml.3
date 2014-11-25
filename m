Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaKYL2P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:28:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58605 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440AbaKYKl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "Barbalho, Rafael" <rafael.barbalho@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 121/254] drm/i915: Do not leak pages when freeing userptr objects
Date: Tue, 25 Nov 2014 10:37:51 +0000
Message-Id: <1416912004-5928-122-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit c479f4383ea8940dd6f88da61798ad31feb33e51 upstream.

sg_alloc_table_from_pages() can build us a table with coalesced ranges which
means we need to iterate over pages and not sg table entries when releasing
page references.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: "Barbalho, Rafael" <rafael.barbalho@intel.com>
Tested-by: Rafael Barbalho <rafael.barbalho@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
[danvet: Remove unused local variable sg.]
Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/i915/i915_gem_userptr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915/i915_gem_userptr.c
index 21ea92886a56..7b7a35d71c08 100644
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -554,16 +554,15 @@ i915_gem_userptr_get_pages(struct drm_i915_gem_object *obj)
 static void
 i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj)
 {
-	struct scatterlist *sg;
-	int i;
+	struct sg_page_iter sg_iter;
 
 	BUG_ON(obj->userptr.work != NULL);
 
 	if (obj->madv != I915_MADV_WILLNEED)
 		obj->dirty = 0;
 
-	for_each_sg(obj->pages->sgl, sg, obj->pages->nents, i) {
-		struct page *page = sg_page(sg);
+	for_each_sg_page(obj->pages->sgl, &sg_iter, obj->pages->nents, 0) {
+		struct page *page = sg_page_iter_page(&sg_iter);
 
 		if (obj->dirty)
 			set_page_dirty(page);
-- 
2.1.0

