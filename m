Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab3HMRnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:43:24 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33574 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022Ab3HMRnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:43:20 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>,
        Rob Clark <robdclark@gmail.com>
Subject: [PATCH v2 4/4] drm/omap: remove useless if() in evict_entry()
Date: Tue, 13 Aug 2013 19:42:19 +0200
Message-Id: <1376415739-11685-5-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376415739-11685-1-git-send-email-dh.herrmann@gmail.com>
References: <1373499930-5055-1-git-send-email-dh.herrmann@gmail.com>
 <1376415739-11685-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anon_inode->i_mapping is always set. This was needed before we introduced
anon_inodes. We can safely remove it now.

Cc: Rob Clark <robdclark@gmail.com>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/gpu/drm/omapdrm/omap_gem.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/omapdrm/omap_gem.c b/drivers/gpu/drm/omapdrm/omap_gem.c
index 8219940..0f714a8 100644
--- a/drivers/gpu/drm/omapdrm/omap_gem.c
+++ b/drivers/gpu/drm/omapdrm/omap_gem.c
@@ -153,25 +153,23 @@ static struct {
 static void evict_entry(struct drm_gem_object *obj,
 		enum tiler_fmt fmt, struct usergart_entry *entry)
 {
-	if (obj->dev->anon_inode->i_mapping) {
-		struct omap_gem_object *omap_obj = to_omap_bo(obj);
-		int n = usergart[fmt].height;
-		size_t size = PAGE_SIZE * n;
-		loff_t off = mmap_offset(obj) +
-				(entry->obj_pgoff << PAGE_SHIFT);
-		const int m = 1 + ((omap_obj->width << fmt) / PAGE_SIZE);
-		if (m > 1) {
-			int i;
-			/* if stride > than PAGE_SIZE then sparse mapping: */
-			for (i = n; i > 0; i--) {
-				unmap_mapping_range(obj->dev->anon_inode->i_mapping,
-						off, PAGE_SIZE, 1);
-				off += PAGE_SIZE * m;
-			}
-		} else {
+	struct omap_gem_object *omap_obj = to_omap_bo(obj);
+	int n = usergart[fmt].height;
+	size_t size = PAGE_SIZE * n;
+	loff_t off = mmap_offset(obj) + (entry->obj_pgoff << PAGE_SHIFT);
+	const int m = 1 + ((omap_obj->width << fmt) / PAGE_SIZE);
+
+	if (m > 1) {
+		int i;
+		/* if stride > than PAGE_SIZE then sparse mapping: */
+		for (i = n; i > 0; i--) {
 			unmap_mapping_range(obj->dev->anon_inode->i_mapping,
-					    off, size, 1);
+					    off, PAGE_SIZE, 1);
+			off += PAGE_SIZE * m;
 		}
+	} else {
+		unmap_mapping_range(obj->dev->anon_inode->i_mapping,
+				    off, size, 1);
 	}
 
 	entry->obj = NULL;
-- 
1.8.3.4

