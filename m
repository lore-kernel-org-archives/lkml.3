Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBKTGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 14:06:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39730 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbaBKTFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 14:05:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.13 085/120] drm/radeon/dce8: workaround for atom BlankCrtc table
Date: Tue, 11 Feb 2014 11:05:26 -0800
Message-Id: <20140211184826.037584472@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140211184823.492407127@linuxfoundation.org>
References: <20140211184823.492407127@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 78fe9e545ce6d510b979dc2d8e14096a279fc519 upstream.

Some DCE8 boards have a funky BlankCrtc table that results
in a timeout when trying to blank the display.  The
timeout is harmless (all operations needed from the table
are complete), but wastes time and is confusing to users so
work around it.

bug:
https://bugs.freedesktop.org/show_bug.cgi?id=73420

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -209,6 +209,16 @@ static void atombios_enable_crtc_memreq(
 	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
 }
 
+static const u32 vga_control_regs[6] =
+{
+	AVIVO_D1VGA_CONTROL,
+	AVIVO_D2VGA_CONTROL,
+	EVERGREEN_D3VGA_CONTROL,
+	EVERGREEN_D4VGA_CONTROL,
+	EVERGREEN_D5VGA_CONTROL,
+	EVERGREEN_D6VGA_CONTROL,
+};
+
 static void atombios_blank_crtc(struct drm_crtc *crtc, int state)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
@@ -216,13 +226,23 @@ static void atombios_blank_crtc(struct d
 	struct radeon_device *rdev = dev->dev_private;
 	int index = GetIndexIntoMasterTable(COMMAND, BlankCRTC);
 	BLANK_CRTC_PS_ALLOCATION args;
+	u32 vga_control = 0;
 
 	memset(&args, 0, sizeof(args));
 
+	if (ASIC_IS_DCE8(rdev)) {
+		vga_control = RREG32(vga_control_regs[radeon_crtc->crtc_id]);
+		WREG32(vga_control_regs[radeon_crtc->crtc_id], vga_control | 1);
+	}
+
 	args.ucCRTC = radeon_crtc->crtc_id;
 	args.ucBlanking = state;
 
 	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+
+	if (ASIC_IS_DCE8(rdev)) {
+		WREG32(vga_control_regs[radeon_crtc->crtc_id], vga_control);
+	}
 }
 
 static void atombios_powergate_crtc(struct drm_crtc *crtc, int state)


