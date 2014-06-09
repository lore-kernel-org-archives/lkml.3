Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963AbaFIIwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:52:25 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58458 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/146] drm/radeon/uvd: use lower clocks on old UVD to boot v2
Date: Mon,  9 Jun 2014 10:49:44 +0200
Message-Id: <afa83e4942997a92e5c763754bf6dde907bf20cc.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e45187620f9fc103edf68fa5ea78e73033e1668c upstream.

Some RV7xx generation hardware crashes after you
raise the UVD clocks for the first time. Try to
avoid this by using the lower clocks to boot these.

Workaround for: https://bugzilla.kernel.org/show_bug.cgi?id=71891

v2: lower clocks on IB test as well

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/uvd_v1_0.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/uvd_v1_0.c b/drivers/gpu/drm/radeon/uvd_v1_0.c
index 7266805d9786..f680f5ffbdeb 100644
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
@@ -405,7 +408,10 @@ int uvd_v1_0_ib_test(struct radeon_device *rdev, struct radeon_ring *ring)
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
1.9.3

