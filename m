Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbbA2KjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:39:18 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755068AbbA2JAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:13 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 146/176] drm/radeon: add si dpm quirk list
Date: Wed, 28 Jan 2015 15:29:36 +0100
Message-Id: <ac9107f8c5594808433b0a2469bbe2364b1fa30e.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5615f890bc6babdc2998dec62f3552326d06eb7b upstream.

This adds a quirks list to fix stability problems with
certain SI boards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=76490

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/si_dpm.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/gpu/drm/radeon/si_dpm.c b/drivers/gpu/drm/radeon/si_dpm.c
index f5cdc865752a..51588d30d675 100644
--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2901,6 +2901,22 @@ static int si_init_smc_spll_table(struct radeon_device *rdev)
 	return ret;
 }
 
+struct si_dpm_quirk {
+	u32 chip_vendor;
+	u32 chip_device;
+	u32 subsys_vendor;
+	u32 subsys_device;
+	u32 max_sclk;
+	u32 max_mclk;
+};
+
+/* cards with dpm stability problems */
+static struct si_dpm_quirk si_dpm_quirk_list[] = {
+	/* PITCAIRN - https://bugs.freedesktop.org/show_bug.cgi?id=76490 */
+	{ PCI_VENDOR_ID_ATI, 0x6810, 0x1462, 0x3036, 0, 120000 },
+	{ 0, 0, 0, 0 },
+};
+
 static void si_apply_state_adjust_rules(struct radeon_device *rdev,
 					struct radeon_ps *rps)
 {
@@ -2911,7 +2927,22 @@ static void si_apply_state_adjust_rules(struct radeon_device *rdev,
 	u32 mclk, sclk;
 	u16 vddc, vddci;
 	u32 max_sclk_vddc, max_mclk_vddci, max_mclk_vddc;
+	u32 max_sclk = 0, max_mclk = 0;
 	int i;
+	struct si_dpm_quirk *p = si_dpm_quirk_list;
+
+	/* Apply dpm quirks */
+	while (p && p->chip_device != 0) {
+		if (rdev->pdev->vendor == p->chip_vendor &&
+		    rdev->pdev->device == p->chip_device &&
+		    rdev->pdev->subsystem_vendor == p->subsys_vendor &&
+		    rdev->pdev->subsystem_device == p->subsys_device) {
+			max_sclk = p->max_sclk;
+			max_mclk = p->max_mclk;
+			break;
+		}
+		++p;
+	}
 
 	if ((rdev->pm.dpm.new_active_crtc_count > 1) ||
 	    ni_dpm_vblank_too_short(rdev))
@@ -2965,6 +2996,14 @@ static void si_apply_state_adjust_rules(struct radeon_device *rdev,
 			if (ps->performance_levels[i].mclk > max_mclk_vddc)
 				ps->performance_levels[i].mclk = max_mclk_vddc;
 		}
+		if (max_mclk) {
+			if (ps->performance_levels[i].mclk > max_mclk)
+				ps->performance_levels[i].mclk = max_mclk;
+		}
+		if (max_sclk) {
+			if (ps->performance_levels[i].sclk > max_sclk)
+				ps->performance_levels[i].sclk = max_sclk;
+		}
 	}
 
 	/* XXX validate the min clocks required for display */
-- 
2.2.2

