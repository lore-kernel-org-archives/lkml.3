Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902AbaFJUJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:09:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35409 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaFJTwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 137/160] drm/radeon/uvd: use lower clocks on old UVD to boot v2
Date: Tue, 10 Jun 2014 12:46:17 -0700
Message-Id: <1402429600-20477-138-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>

commit e45187620f9fc103edf68fa5ea78e73033e1668c upstream.

Some RV7xx generation hardware crashes after you
raise the UVD clocks for the first time. Try to
avoid this by using the lower clocks to boot these.

Workaround for: https://bugzilla.kernel.org/show_bug.cgi?id=71891

v2: lower clocks on IB test as well

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/uvd_v1_0.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/uvd_v1_0.c b/drivers/gpu/drm/radeon/uvd_v1_0.c
index d4a68af..c310a0a 100644
--- a/drivers/gpu/drm/radeon/uvd_v1_0.c
+++ b/drivers/gpu/drm/radeon/uvd_v1_0.c
@@ -83,7 +83,10 @@ int uvd_v1_0_init(struct radeon_device *rdev)
 	int r;
 
 	/* raise clocks while booting up the VCPU */
-	radeon_set_uvd_clocks(rdev, 53300, 40000);
+	if (rdev->family < CHIP_RV740)
+		radeon_set_uvd_clocks(rdev, 10000, 10000);
+	else
+		radeon_set_uvd_clocks(rdev, 53300, 40000);
 
 	r = uvd_v1_0_start(rdev);
 	if (r)
@@ -407,7 +410,10 @@ int uvd_v1_0_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
 	struct radeon_fence *fence = NULL;
 	int r;
 
-	r = radeon_set_uvd_clocks(rdev, 53300, 40000);
+	if (rdev->family < CHIP_RV740)
+		r = radeon_set_uvd_clocks(rdev, 10000, 10000);
+	else
+		r = radeon_set_uvd_clocks(rdev, 53300, 40000);
 	if (r) {
 		DRM_ERROR("radeon: failed to raise UVD clocks (%d).\n", r);
 		return r;
-- 
1.9.1

