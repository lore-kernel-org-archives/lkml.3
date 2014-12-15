Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbaLOOef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:34:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38981 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbaLOO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 151/168] drm/radeon: sync all BOs involved in a CS v2
Date: Mon, 15 Dec 2014 14:26:45 +0000
Message-Id: <1418653622-21105-152-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit 86b276385c6a986872e4cd144f5940b156053c3f upstream.

Not just the userspace relocs, otherwise we won't wait
for a swapped out page tables to be swapped in again.

v2: rebased on Alex current drm-fixes-3.18

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.16: used Christian's backport to 3.17 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_cs.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_cs.c b/drivers/gpu/drm/radeon/radeon_cs.c
index c50a1da6c12a..4aa1ede7b7b5 100644
--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -226,14 +226,11 @@ static int radeon_cs_get_ring(struct radeon_cs_parser *p, u32 ring, s32 priority
 
 static void radeon_cs_sync_rings(struct radeon_cs_parser *p)
 {
-	int i;
-
-	for (i = 0; i < p->nrelocs; i++) {
-		if (!p->relocs[i].robj)
-			continue;
+	struct radeon_cs_reloc *reloc;
 
+	list_for_each_entry(reloc, &p->validated, tv.head) {
 		radeon_semaphore_sync_to(p->ib.semaphore,
-					 p->relocs[i].robj->tbo.sync_obj);
+					 reloc->robj->tbo.sync_obj);
 	}
 }
 
-- 
2.1.3

