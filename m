Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759551Ab3LFXSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:18:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48781 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758904Ab3LFXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:18:40 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 132/152] radeon: workaround pinning failure on low ram gpu
Date: Fri,  6 Dec 2013 15:10:56 -0800
Message-Id: <1386371476-2477-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 97b6ff6be9da7675aab339334fda996d6c5077d9 upstream.

GPU with low amount of ram can fails at pinning new framebuffer before
unpinning old one. On such failure, retry with unpinning old one before
pinning new one allowing to work around the issue. This is somewhat
ugly but only affect those old GPU we care about.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 6857cb4..ebd36ac 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -422,6 +422,7 @@ int radeon_crtc_do_set_base(struct drm_crtc *crtc,
 	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
 	rbo = gem_to_radeon_bo(obj);
+retry:
 	r = radeon_bo_reserve(rbo, false);
 	if (unlikely(r != 0))
 		return r;
@@ -430,6 +431,33 @@ int radeon_crtc_do_set_base(struct drm_crtc *crtc,
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

