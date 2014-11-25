Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbaKYLnd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:43:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58317 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaKYKlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 069/254] drm/ttm: Don't evict BOs outside of the requested placement range
Date: Tue, 25 Nov 2014 10:36:59 +0000
Message-Id: <1416912004-5928-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>

commit e300180f71037fd9ed1ca967006fd9f3ee466bcd upstream.

The radeon driver uses placement range restrictions for several reasons,
in particular to make sure BOs in VRAM can be accessed by the CPU, e.g.
during a page fault.

Without this change, TTM could evict other BOs while trying to satisfy
the requested placement, even if the evicted BOs were outside of the
requested placement range. Doing so didn't free up any space in the
requested placement range, so the (potentially high) eviction cost was
incurred for no benefit.

Nominating for stable because radeon driver changes in 3.17 made this
much more noticeable than before.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=84662
Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ luis: backported to 3.16: based on Michel's backport ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index a13a10025ec7..f7befc4c0c49 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -716,6 +716,7 @@ out:
 
 static int ttm_mem_evict_first(struct ttm_bo_device *bdev,
 				uint32_t mem_type,
+				const struct ttm_placement *placement,
 				bool interruptible,
 				bool no_wait_gpu)
 {
@@ -727,8 +728,22 @@ static int ttm_mem_evict_first(struct ttm_bo_device *bdev,
 	spin_lock(&glob->lru_lock);
 	list_for_each_entry(bo, &man->lru, lru) {
 		ret = __ttm_bo_reserve(bo, false, true, false, 0);
-		if (!ret)
+		if (!ret) {
+			if (placement && (placement->fpfn || placement->lpfn)) {
+				/* Don't evict this BO if it's outside of the
+				 * requested placement range
+				 */
+				if (placement->fpfn >= (bo->mem.start + bo->mem.size) ||
+				    (placement->lpfn &&
+				     placement->lpfn <= bo->mem.start)) {
+					__ttm_bo_unreserve(bo);
+					ret = -EBUSY;
+					continue;
+				}
+			}
+
 			break;
+		}
 	}
 
 	if (ret) {
@@ -789,7 +804,7 @@ static int ttm_bo_mem_force_space(struct ttm_buffer_object *bo,
 			return ret;
 		if (mem->mm_node)
 			break;
-		ret = ttm_mem_evict_first(bdev, mem_type,
+		ret = ttm_mem_evict_first(bdev, mem_type, placement,
 					  interruptible, no_wait_gpu);
 		if (unlikely(ret != 0))
 			return ret;
@@ -1245,7 +1260,7 @@ static int ttm_bo_force_list_clean(struct ttm_bo_device *bdev,
 	spin_lock(&glob->lru_lock);
 	while (!list_empty(&man->lru)) {
 		spin_unlock(&glob->lru_lock);
-		ret = ttm_mem_evict_first(bdev, mem_type, false, false);
+		ret = ttm_mem_evict_first(bdev, mem_type, NULL, false, false);
 		if (ret) {
 			if (allow_errors) {
 				return ret;
-- 
2.1.0

