Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab3L2CLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:11:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55504 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063Ab3L2CKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:53 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>,
        "Jerome Glisse" <jglisse@redhat.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.419692957@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 069/185] radeon: workaround pinning failure on low ram gpu
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Glisse <jglisse@redhat.com>

commit 97b6ff6be9da7675aab339334fda996d6c5077d9 upstream.

GPU with low amount of ram can fails at pinning new framebuffer before
unpinning old one. On such failure, retry with unpinning old one before
pinning new one allowing to work around the issue. This is somewhat
ugly but only affect those old GPU we care about.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -416,12 +416,40 @@ int radeon_crtc_do_set_base(struct drm_c
 	/* Pin framebuffer & get tilling informations */
 	obj = radeon_fb->obj;
 	rbo = gem_to_radeon_bo(obj);
+retry:
 	r = radeon_bo_reserve(rbo, false);
 	if (unlikely(r != 0))
 		return r;
 	r = radeon_bo_pin(rbo, RADEON_GEM_DOMAIN_VRAM, &base);
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

