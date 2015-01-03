Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbbACI2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 03:28:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbbACI16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 03:27:58 -0500
From: Takashi Iwai <tiwai@suse.de>
To: David Airlie <airlied@linux.ie>
Cc: Alex Deucher <alexander.deucher@amd.com>, christian.koenig@amd.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/radeon: Fix kernel panic when plugging a HDMI w/o SAD
Date: Sat,  3 Jan 2015 09:27:52 +0100
Message-Id: <1420273672-32496-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A BUG_ON() call in dce3_2_afmt_write_sad_regs() is triggered when a
HDMI monitor without SAD is plugged as the case sad_count = 0 is
overlooked in the code:

 kernel BUG at ../drivers/gpu/drm/radeon/dce3_1_afmt.c:110!
 invalid opcode: 0000 [#1] PREEMPT SMP
 CPU: 2 PID: 967 Comm: Xorg Tainted: PO  3.16.7-7-desktop #1
 Hardware name: System manufacturer System Product Name/M4A77T, BIOS 2401    05/18/2011
 task: ffff8800cea86350 ti: ffff8800c1880000 task.ti: ffff8800c1880000
 RIP: 0010:[<ffffffffa0126c50>] dce3_1_hdmi_setmode+0x570/0x5a0 [radeon]
 Call Trace:
  [<ffffffffa00a6936>] drm_crtc_helper_set_mode+0x346/0x520 [drm_kms_helper]
  [<ffffffffa00a7678>] drm_crtc_helper_set_config+0x8a8/0xad0 [drm_kms_helper]
  [<ffffffffa00ede3f>] radeon_crtc_set_config+0x3f/0x110 [radeon]
  [<ffffffffa001edc1>] drm_mode_set_config_internal+0x61/0xe0 [drm]
  [<ffffffffa00a9a6b>] restore_fbdev_mode+0xab/0xd0 [drm_kms_helper]
  [<ffffffffa00a9aae>] drm_fb_helper_restore_fbdev_mode_unlocked+0x1e/0x30 [drm_kms_helper]
  [<ffffffffa00ab642>] drm_fb_helper_set_par+0x22/0x60 [drm_kms_helper]
  [<ffffffffa00ab5cb>] drm_fb_helper_hotplug_event+0x8b/0xe0 [drm_kms_helper]
  [<ffffffffa00ab65a>] drm_fb_helper_set_par+0x3a/0x60 [drm_kms_helper]
  [<ffffffff813818ce>] fb_set_var+0x15e/0x3b0
  [<ffffffff81378d0b>] fbcon_blank+0x1cb/0x2b0
  [<ffffffff813f2a31>] do_unblank_screen+0xa1/0x1b0
  [<ffffffff813e8fd3>] complete_change_console+0x53/0xe0
  [<ffffffff813e9fa9>] vt_ioctl+0xf49/0x10d0
  [<ffffffff813ddfdc>] tty_ioctl+0x26c/0xb70
  [<ffffffff811cad17>] do_vfs_ioctl+0x2e7/0x4c0
  [<ffffffff811caf71>] SyS_ioctl+0x81/0xa0
  [<ffffffff81622a2d>] system_call_fastpath+0x1a/0x1f
  [<00007f2fae8c6397>] 0x7f2fae8c6396

This patch fixes it by covering sad_count = 0 in the error check
properly, too.

Bugzilla: https://bugzilla.opensuse.org/show_bug.cgi?id=911356
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

IMO, BUG_ON() call itself is exaggerated there, but we may change it later
independently from this fix.

 drivers/gpu/drm/radeon/dce3_1_afmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/dce3_1_afmt.c b/drivers/gpu/drm/radeon/dce3_1_afmt.c
index 2fe8cfc966d9..bafdf92a5732 100644
--- a/drivers/gpu/drm/radeon/dce3_1_afmt.c
+++ b/drivers/gpu/drm/radeon/dce3_1_afmt.c
@@ -103,7 +103,7 @@ static void dce3_2_afmt_write_sad_regs(struct drm_encoder *encoder)
 	}
 
 	sad_count = drm_edid_to_sad(radeon_connector->edid, &sads);
-	if (sad_count < 0) {
+	if (sad_count <= 0) {
 		DRM_ERROR("Couldn't read SADs: %d\n", sad_count);
 		return;
 	}
-- 
2.2.0

