Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3JCEbD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:31:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab3JCEVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:21:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Ivanov <gnidorah@p0n4ik.tk>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 50/57] drm/radeon: Make r100_cp_ring_info() and radeon_ring_gfx() safe (v2)
Date: Wed,  2 Oct 2013 21:09:16 -0700
Message-Id: <20131003040640.016832573@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Ivanov <gnidorah@p0n4ik.tk>

commit 0eb3448aa6b31fbf24c31756aba7940cac5ad6b8 upstream.

Prevent NULL pointer dereference in case when radeon_ring_fini() did it's job.

Reading of r100_cp_ring_info and radeon_ring_gfx debugfs entries will lead to a KP if ring buffer was deallocated, e.g. on failed ring test.
Seen on PA-RISC machine having "radeon: ring test failed (scratch(0x8504)=0xCAFEDEAD)" issue.

v2: agd5f: add some parens around ring->ready check

Signed-off-by: Alex Ivanov <gnidorah@p0n4ik.tk>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/r100.c        |    8 +++++---
 drivers/gpu/drm/radeon/radeon_ring.c |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2926,9 +2926,11 @@ static int r100_debugfs_cp_ring_info(str
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
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -846,9 +846,11 @@ static int radeon_debugfs_ring_info(stru
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


