Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233Ab3LBTs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:48:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab3LBTSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jerome Glisse <jglisse@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.12 140/212] radeon: workaround pinning failure on low ram gpu
Date: Mon,  2 Dec 2013 11:15:31 -0800
Message-Id: <20131202191302.701562682@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 97b6ff6be9da7675aab339334fda996d6c5077d9 upstream.

GPU with low amount of ram can fails at pinning new framebuffer before
unpinning old one. On such failure, retry with unpinning old one before
pinning new one allowing to work around the issue. This is somewhat
ugly but only affect those old GPU we care about.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -422,6 +422,7 @@ int radeon_crtc_do_set_base(struct drm_c
 	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
 	rbo = gem_to_radeon_bo(obj);
+retry:
 	r = radeon_bo_reserve(rbo, false);
 	if (unlikely(r != 0))
 		return r;
@@ -430,6 +431,33 @@ int radeon_crtc_do_set_base(struct drm_c
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


