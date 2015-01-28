Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbbA1B20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:28:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41108 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759779AbbA1B2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.18 16/61] drm/radeon: add si dpm quirk list
Date: Tue, 27 Jan 2015 17:26:28 -0800
Message-Id: <20150128012638.840299112@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 5615f890bc6babdc2998dec62f3552326d06eb7b upstream.

This adds a quirks list to fix stability problems with
certain SI boards.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=76490

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/si_dpm.c |   39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

--- a/drivers/gpu/drm/radeon/si_dpm.c
+++ b/drivers/gpu/drm/radeon/si_dpm.c
@@ -2908,6 +2908,22 @@ static int si_init_smc_spll_table(struct
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
@@ -2918,7 +2934,22 @@ static void si_apply_state_adjust_rules(
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
@@ -2972,6 +3003,14 @@ static void si_apply_state_adjust_rules(
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


