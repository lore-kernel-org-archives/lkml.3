Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3E1VVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:21:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756838Ab3E1VVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christopher Harvey <charvey@matrox.com>, Dave Airlie <airlied@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 09/78] drm/mm: fix dump table BUG
Date: Tue, 28 May 2013 14:19:18 -0700
Message-Id: <1369776027-17859-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 3a359f0b21ab218c1bf7a6a1b638b6fd143d0b99 upstream.

In

commit 9e8944ab564f2e3dde90a518cd32048c58918608
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Nov 15 11:32:17 2012 +0000

    drm: Introduce an iterator over holes in the drm_mm range manager

helpers and iterators for hole handling have been introduced with some
debug BUG_ONs sprinkled over. Unfortunately this broke the mm dumper
which unconditionally tried to compute the size of the very first
hole.

While at it unify the code a bit with the hole dumping in the loop.

v2: Extract a hole dump helper.

Reported-by: Christopher Harvey <charvey@matrox.com>
Cc: Christopher Harvey <charvey@matrox.com>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Acked-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/drm_mm.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index 2aa3314..193e24e 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -725,33 +725,35 @@ void drm_mm_debug_table(struct drm_mm *mm, const char *prefix)
 EXPORT_SYMBOL(drm_mm_debug_table);
 
 #if defined(CONFIG_DEBUG_FS)
-int drm_mm_dump_table(struct seq_file *m, struct drm_mm *mm)
+static unsigned long drm_mm_dump_hole(struct seq_file *m, struct drm_mm_node *entry)
 {
-	struct drm_mm_node *entry;
-	unsigned long total_used = 0, total_free = 0, total = 0;
 	unsigned long hole_start, hole_end, hole_size;
 
-	hole_start = drm_mm_hole_node_start(&mm->head_node);
-	hole_end = drm_mm_hole_node_end(&mm->head_node);
-	hole_size = hole_end - hole_start;
-	if (hole_size)
+	if (entry->hole_follows) {
+		hole_start = drm_mm_hole_node_start(entry);
+		hole_end = drm_mm_hole_node_end(entry);
+		hole_size = hole_end - hole_start;
 		seq_printf(m, "0x%08lx-0x%08lx: 0x%08lx: free\n",
 				hole_start, hole_end, hole_size);
-	total_free += hole_size;
+		return hole_size;
+	}
+
+	return 0;
+}
+
+int drm_mm_dump_table(struct seq_file *m, struct drm_mm *mm)
+{
+	struct drm_mm_node *entry;
+	unsigned long total_used = 0, total_free = 0, total = 0;
+
+	total_free += drm_mm_dump_hole(m, &mm->head_node);
 
 	drm_mm_for_each_node(entry, mm) {
 		seq_printf(m, "0x%08lx-0x%08lx: 0x%08lx: used\n",
 				entry->start, entry->start + entry->size,
 				entry->size);
 		total_used += entry->size;
-		if (entry->hole_follows) {
-			hole_start = drm_mm_hole_node_start(entry);
-			hole_end = drm_mm_hole_node_end(entry);
-			hole_size = hole_end - hole_start;
-			seq_printf(m, "0x%08lx-0x%08lx: 0x%08lx: free\n",
-					hole_start, hole_end, hole_size);
-			total_free += hole_size;
-		}
+		total_free += drm_mm_dump_hole(m, entry);
 	}
 	total = total_free + total_used;
 
-- 
1.8.1.2

