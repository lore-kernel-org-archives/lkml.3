Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833Ab3HMGtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:49:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60601 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756963Ab3HMGdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:36 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        shui yangwei <yangweix.shui@intel.com>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>,
        Imre Deak <imre.deak@intel.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 42/60] drm: Dont pass negative delta to ktime_sub_ns()
Date: Mon, 12 Aug 2013 23:34:09 -0700
Message-Id: <20130813063337.711590647@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <michel.daenzer@amd.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_irq.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -708,7 +708,10 @@ int drm_calc_vbltimestamp_from_scanoutpo
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


