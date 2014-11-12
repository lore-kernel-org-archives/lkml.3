Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaKLB02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:26:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaKLB0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:26:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        "Barbalho, Rafael" <rafael.barbalho@intel.com>,
        Daniel Vetter <daniel.vetter@intel.com>
Subject: [PATCH 3.17 107/319] drm/i915: Do not leak pages when freeing userptr objects
Date: Wed, 12 Nov 2014 10:14:05 +0900
Message-Id: <20141112011010.253530932@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem_userptr.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -689,16 +689,15 @@ i915_gem_userptr_get_pages(struct drm_i9
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


