Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbaIOWQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:16:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50927 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757027AbaIOWQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:16:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 153/187] drm/radeon: set VM base addr using the PFP v2
Date: Mon, 15 Sep 2014 15:09:23 -0700
Message-Id: <1410818997-9432-154-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit f1d2a26b506e9dc7bbe94fae40da0a0d8dcfacd0 upstream.

Seems to make VM flushes more stable on SI and CIK.

v2: only use the PFP on the GFX ring on CIK

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/cik.c | 5 +++--
 drivers/gpu/drm/radeon/si.c  | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 17649ac..f605f6e 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -5332,12 +5332,13 @@ static void cik_vm_decode_fault(struct radeon_device *rdev,
 void cik_vm_flush(struct radeon_device *rdev, int ridx, struct radeon_vm *vm)
 {
 	struct radeon_ring *ring = &rdev->ring[ridx];
+	int usepfp = (ridx == RADEON_RING_TYPE_GFX_INDEX);
 
 	if (vm == NULL)
 		return;
 
 	radeon_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
-	radeon_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |
+	radeon_ring_write(ring, (WRITE_DATA_ENGINE_SEL(usepfp) |
 				 WRITE_DATA_DST_SEL(0)));
 	if (vm->id < 8) {
 		radeon_ring_write(ring,
@@ -5396,7 +5397,7 @@ void cik_vm_flush(struct radeon_device *rdev, int ridx, struct radeon_vm *vm)
 	radeon_ring_write(ring, 1 << vm->id);
 
 	/* compute doesn't have PFP */
-	if (ridx == RADEON_RING_TYPE_GFX_INDEX) {
+	if (usepfp) {
 		/* sync PFP to ME, otherwise we might get invalid PFP reads */
 		radeon_ring_write(ring, PACKET3(PACKET3_PFP_SYNC_ME, 0));
 		radeon_ring_write(ring, 0x0);
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index d5c8438..18c197f 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -4697,7 +4697,7 @@ void si_vm_flush(struct radeon_device *rdev, int ridx, struct radeon_vm *vm)
 
 	/* write new base address */
 	radeon_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
-	radeon_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |
+	radeon_ring_write(ring, (WRITE_DATA_ENGINE_SEL(1) |
 				 WRITE_DATA_DST_SEL(0)));
 
 	if (vm->id < 8) {
-- 
1.9.1

