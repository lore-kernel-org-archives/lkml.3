Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaBLI0a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:26:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50221 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752098AbaBLIOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:05 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.738987943@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 39/79] drm/radeon: Fix sideport problems on certain
 RS690 boards
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 8333f0fe133be420ce3fcddfd568c3a559ab274e upstream.

Some RS690 boards with 64MB of sideport memory show up as
having 128MB sideport + 256MB of UMA.  In this case,
just skip the sideport memory and use UMA.  This fixes
rendering corruption and should improve performance.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=35457

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/rs690.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -160,6 +160,16 @@ void rs690_mc_init(struct radeon_device
 	base = RREG32_MC(R_000100_MCCFG_FB_LOCATION);
 	base = G_000100_MC_FB_START(base) << 16;
 	rdev->mc.igp_sideport_enabled = radeon_atombios_sideport_present(rdev);
+	/* Some boards seem to be configured for 128MB of sideport memory,
+	 * but really only have 64MB.  Just skip the sideport and use
+	 * UMA memory.
+	 */
+	if (rdev->mc.igp_sideport_enabled &&
+	    (rdev->mc.real_vram_size == (384 * 1024 * 1024))) {
+		base += 128 * 1024 * 1024;
+		rdev->mc.real_vram_size -= 128 * 1024 * 1024;
+		rdev->mc.mc_vram_size = rdev->mc.real_vram_size;
+	}
 	rs690_pm_info(rdev);
 	radeon_vram_location(rdev, &rdev->mc, base);
 	rdev->mc.gtt_base_align = rdev->mc.gtt_size - 1;

