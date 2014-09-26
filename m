Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaIZJzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:55:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755118AbaIZJqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:47 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 132/142] drm/radeon: set VM base addr using the PFP v2
Date: Fri, 26 Sep 2014 11:45:43 +0200
Message-Id: <c030871d73f59332154e3ebb79b986ae97bacd4a.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f1d2a26b506e9dc7bbe94fae40da0a0d8dcfacd0 upstream.

Seems to make VM flushes more stable on SI and CIK.

v2: only use the PFP on the GFX ring on CIK

Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/cik.c | 5 +++--
 drivers/gpu/drm/radeon/si.c  | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/cik.c b/drivers/gpu/drm/radeon/cik.c
index 85ef9ff42aa6..9d9770d201ae 100644
--- a/drivers/gpu/drm/radeon/cik.c
+++ b/drivers/gpu/drm/radeon/cik.c
@@ -4769,12 +4769,13 @@ static void cik_vm_decode_fault(struct radeon_device *rdev,
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
@@ -4833,7 +4834,7 @@ void cik_vm_flush(struct radeon_device *rdev, int ridx, struct radeon_vm *vm)
 	radeon_ring_write(ring, 1 << vm->id);
 
 	/* compute doesn't have PFP */
-	if (ridx == RADEON_RING_TYPE_GFX_INDEX) {
+	if (usepfp) {
 		/* sync PFP to ME, otherwise we might get invalid PFP reads */
 		radeon_ring_write(ring, PACKET3(PACKET3_PFP_SYNC_ME, 0));
 		radeon_ring_write(ring, 0x0);
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 4d41a0dc1796..53769e9cf595 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -4757,7 +4757,7 @@ void si_vm_flush(struct radeon_device *rdev, int ridx, struct radeon_vm *vm)
 
 	/* write new base address */
 	radeon_ring_write(ring, PACKET3(PACKET3_WRITE_DATA, 3));
-	radeon_ring_write(ring, (WRITE_DATA_ENGINE_SEL(0) |
+	radeon_ring_write(ring, (WRITE_DATA_ENGINE_SEL(1) |
 				 WRITE_DATA_DST_SEL(0)));
 
 	if (vm->id < 8) {
-- 
2.1.0

