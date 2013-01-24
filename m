Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab3AXDfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:35:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab3AXDbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:31:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilija Hadzic <ihadzic@research.bell-labs.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 66/74] drm/radeon: fix NULL pointer dereference in UMS mode
Date: Thu, 24 Jan 2013 01:27:18 -0200
Message-Id: <1358998046-613-67-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilija Hadzic <ihadzic@research.bell-labs.com>

commit ff4bd0827764e10a428a9d39e6814c5478863f94 upstream.

In UMS mode parser->rdev is NULL, so dereferencing
will cause an oops.

Signed-off-by: Ilija Hadzic <ihadzic@research.bell-labs.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index c84eb1a..66d81ae 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -274,7 +274,7 @@ int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data)
 				  p->chunks[p->chunk_ib_idx].length_dw);
 			return -EINVAL;
 		}
-		if ((p->rdev->flags & RADEON_IS_AGP)) {
+		if (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) {
 			p->chunks[p->chunk_ib_idx].kpage[0] = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			p->chunks[p->chunk_ib_idx].kpage[1] = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (p->chunks[p->chunk_ib_idx].kpage[0] == NULL ||
@@ -613,7 +613,8 @@ static int radeon_cs_update_pages(struct radeon_cs_parser *p, int pg_idx)
 	struct radeon_cs_chunk *ibc = &p->chunks[p->chunk_ib_idx];
 	int i;
 	int size = PAGE_SIZE;
-	bool copy1 = (p->rdev->flags & RADEON_IS_AGP) ? false : true;
+	bool copy1 = (p->rdev && (p->rdev->flags & RADEON_IS_AGP)) ?
+		false : true;
 
 	for (i = ibc->last_copied_page + 1; i < pg_idx; i++) {
 		if (DRM_COPY_FROM_USER(p->ib.ptr + (i * (PAGE_SIZE/4)),
-- 
1.7.9.5

