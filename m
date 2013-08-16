Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab3HPWkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:40:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51758 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3HPWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 108/133] drm: Don't pass negative delta to ktime_sub_ns()
Date: Fri, 16 Aug 2013 15:34:10 -0700
Message-Id: <1376692475-28413-109-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>

commit e91abf80a0998f326107874c88d549f94839f13c upstream.

It takes an unsigned value. This happens not to blow up on 64-bit
architectures, but it does on 32-bit, causing
drm_calc_vbltimestamp_from_scanoutpos() to calculate totally bogus
timestamps for vblank events. Which in turn causes e.g. gnome-shell to
hang after a DPMS off cycle with current xf86-video-ati Git.

[airlied: regression introduced in drm: use monotonic time in drm_calc_vbltimestamp_from_scanoutpos]

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59339
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=59836
Tested-by: shui yangwei <yangweix.shui@intel.com>
Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
Reviewed-by: Imre Deak <imre.deak@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/drm_irq.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 570dac6..0f3cdda 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -704,7 +704,10 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 	/* Subtract time delta from raw timestamp to get final
 	 * vblank_time timestamp for end of vblank.
 	 */
-	etime = ktime_sub_ns(etime, delta_ns);
+	if (delta_ns < 0)
+		etime = ktime_add_ns(etime, -delta_ns);
+	else
+		etime = ktime_sub_ns(etime, delta_ns);
 	*vblank_time = ktime_to_timeval(etime);
 
 	DRM_DEBUG("crtc %d : v %d p(%d,%d)@ %ld.%ld -> %ld.%ld [e %d us, %d rep]\n",
-- 
1.8.1.2

