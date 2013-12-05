Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab3LERtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:49:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38321 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab3LERhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 58/90] radeon: workaround pinning failure on low ram gpu
Date: Thu,  5 Dec 2013 17:35:40 +0000
Message-Id: <1386264972-5399-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 97b6ff6be9da7675aab339334fda996d6c5077d9 upstream.

GPU with low amount of ram can fails at pinning new framebuffer before
unpinning old one. On such failure, retry with unpinning old one before
pinning new one allowing to work around the issue. This is somewhat
ugly but only affect those old GPU we care about.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 9760e5a..b44bbf5 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -416,6 +416,7 @@ int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
 	rbo = gem_to_radeon_bo(obj);
+retry:
 	r = radeon_bo_reserve(rbo, false);
 	if (unlikely(r != 0))
 		return r;
@@ -424,6 +425,33 @@ int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 				     &base);
 	if (unlikely(r != 0)) {
 		radeon_bo_unreserve(rbo);
+
+		/* On old GPU like RN50 with little vram pining can fails because
+		 * current fb is taking all space needed. So instead of unpining
+		 * the old buffer after pining the new one, first unpin old one
+		 * and then retry pining new one.
+		 *
+		 * As only master can set mode only master can pin and it is
+		 * unlikely the master client will race with itself especialy
+		 * on those old gpu with single crtc.
+		 *
+		 * We don't shutdown the display controller because new buffer
+		 * will end up in same spot.
+		 */
+		if (!atomic && fb && fb != crtc->fb) {
+			struct radeon_bo *old_rbo;
+			unsigned long nsize, osize;
+
+			old_rbo = gem_to_radeon_bo(to_radeon_framebuffer(fb)->obj);
+			osize = radeon_bo_size(old_rbo);
+			nsize = radeon_bo_size(rbo);
+			if (nsize <= osize && !radeon_bo_reserve(old_rbo, false)) {
+				radeon_bo_unpin(old_rbo);
+				radeon_bo_unreserve(old_rbo);
+				fb = NULL;
+				goto retry;
+			}
+		}
 		return -EINVAL;
 	}
 	radeon_bo_get_tiling_flags(rbo, &tiling_flags, NULL);
-- 
1.8.3.2

