Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab3JJPuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:50:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53060 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab3JJPub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:50:31 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Ivanov <gnidorah@p0n4ik.tk>, Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 059/104] drm/radeon: Make r100_cp_ring_info() and radeon_ring_gfx() safe (v2)
Date: Thu, 10 Oct 2013 08:41:47 -0700
Message-Id: <1381419752-29733-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Ivanov <gnidorah@p0n4ik.tk>

commit 0eb3448aa6b31fbf24c31756aba7940cac5ad6b8 upstream.

Prevent NULL pointer dereference in case when radeon_ring_fini() did it's job.

Reading of r100_cp_ring_info and radeon_ring_gfx debugfs entries will lead to a KP if ring buffer was deallocated, e.g. on failed ring test.
Seen on PA-RISC machine having "radeon: ring test failed (scratch(0x8504)=0xCAFEDEAD)" issue.

v2: agd5f: add some parens around ring->ready check

Signed-off-by: Alex Ivanov <gnidorah@p0n4ik.tk>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/r100.c        | 8 +++++---
 drivers/gpu/drm/radeon/radeon_ring.c | 8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index b833fbe..1ef003a 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3045,9 +3045,11 @@ static int r100_debugfs_cp_ring_info(struct seq_file *m, void *data)
 	seq_printf(m, "CP_RB_RPTR 0x%08x\n", rdp);
 	seq_printf(m, "%u free dwords in ring\n", ring->ring_free_dw);
 	seq_printf(m, "%u dwords in ring\n", count);
-	for (j = 0; j <= count; j++) {
-		i = (rdp + j) & ring->ptr_mask;
-		seq_printf(m, "r[%04d]=0x%08x\n", i, ring->ring[i]);
+	if (ring->ready) {
+		for (j = 0; j <= count; j++) {
+			i = (rdp + j) & ring->ptr_mask;
+			seq_printf(m, "r[%04d]=0x%08x\n", i, ring->ring[i]);
+		}
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index cac9f20..37d870b 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -804,9 +804,11 @@ static int radeon_debugfs_ring_info(struct seq_file *m, void *data)
 	 * packet that is the root issue
 	 */
 	i = (ring->rptr + ring->ptr_mask + 1 - 32) & ring->ptr_mask;
-	for (j = 0; j <= (count + 32); j++) {
-		seq_printf(m, "r[%5d]=0x%08x\n", i, ring->ring[i]);
-		i = (i + 1) & ring->ptr_mask;
+	if (ring->ready) {
+		for (j = 0; j <= (count + 32); j++) {
+			seq_printf(m, "r[%5d]=0x%08x\n", i, ring->ring[i]);
+			i = (i + 1) & ring->ptr_mask;
+		}
 	}
 	return 0;
 }
-- 
1.8.1.2

