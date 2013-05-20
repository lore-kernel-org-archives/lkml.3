Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab3ETKwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 06:52:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3ETKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:52:10 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 003/115] drm/radeon: don't use get_engine_clock() on APUs
Date: Mon, 20 May 2013 11:50:03 +0100
Message-Id: <1369047116-9378-4-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit bf05d9985111f85ed6922c134567b96eb789283b upstream.

It doesn't work reliably.  Just report back the currently
selected engine clock.

Partially fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62493

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_pm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 0c4ca48..c7f3d6c 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -864,7 +864,11 @@ static int radeon_debugfs_pm_info(struct seq_file *m, void *data)
 	struct radeon_device *rdev = dev->dev_private;
 
 	seq_printf(m, "default engine clock: %u0 kHz\n", rdev->pm.default_sclk);
-	seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
+	/* radeon_get_engine_clock is not reliable on APUs so just print the current clock */
+	if ((rdev->family >= CHIP_PALM) && (rdev->flags & RADEON_IS_IGP))
+		seq_printf(m, "current engine clock: %u0 kHz\n", rdev->pm.current_sclk);
+	else
+		seq_printf(m, "current engine clock: %u0 kHz\n", radeon_get_engine_clock(rdev));
 	seq_printf(m, "default memory clock: %u0 kHz\n", rdev->pm.default_mclk);
 	if (rdev->asic->pm.get_memory_clock)
 		seq_printf(m, "current memory clock: %u0 kHz\n", radeon_get_memory_clock(rdev));
-- 
1.8.1.2

