Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab3EJOxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:53:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56839 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753610Ab3EJOTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:19:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Deucher" <alexander.deucher@amd.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.964571319@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [011/118] drm/radeon: don't use get_engine_clock() on APUs
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit bf05d9985111f85ed6922c134567b96eb789283b upstream.

It doesn't work reliably.  Just report back the currently
selected engine clock.

Partially fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62493

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_pm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -863,7 +863,11 @@ static int radeon_debugfs_pm_info(struct
 	struct radeon_device *rdev = dev->dev_private;
 
 	seq_printf(m, "default engine clock: %u0 kHz\n", rdev->pm.default_sclk);
-	seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
+	/* radeon_get_engine_clock is not reliable on APUs so just print the current clock */
+	if ((rdev->family >= CHIP_PALM) && (rdev->flags & RADEON_IS_IGP))
+		seq_printf(m, "current engine clock: %u0 kHz\n", rdev->pm.current_sclk);
+	else
+		seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
 	seq_printf(m, "default memory clock: %u0 kHz\n", rdev->pm.default_mclk);
 	if (rdev->asic->get_memory_clock)
 		seq_printf(m, "current memory clock: %u0 kHz\n", radeon_get_memory_clock(rdev));

