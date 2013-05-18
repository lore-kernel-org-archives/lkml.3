Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323Ab3ERDO4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:14:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23572 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758673Ab3ERDAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:14 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=9POAVWnSHSgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FL1KdviKnJ8A:10 a=zd2uoN0lAAAA:8 a=e5mUnYsNAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=wu_e27o_rKQA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021700.265508105@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Alex Deucher <alexander.deucher@amd.com>
Subject: [ 116/136 ] drm/radeon: dont use get_engine_clock() on APUs
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0116-drm-radeon-don-t-use-get_engine_clock-on-APUs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit bf05d9985111f85ed6922c134567b96eb789283b ]

It doesn't work reliably.  Just report back the currently
selected engine clock.

Partially fixes:
https://bugs.freedesktop.org/show_bug.cgi?id=62493

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/radeon/radeon_pm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_pm.c b/drivers/gpu/drm/radeon/radeon_pm.c
index 395d7e0..8c89481 100644
--- a/drivers/gpu/drm/radeon/radeon_pm.c
+++ b/drivers/gpu/drm/radeon/radeon_pm.c
@@ -856,7 +856,11 @@ static int radeon_debugfs_pm_info(struct seq_file *m, void *data)
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
1.7.10.4


