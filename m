Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760Ab3G3Jkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:40:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932589Ab3G3Jdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ondrej Zary <linux@rainbow-software.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 082/106] drm/radeon: Another card with wrong primary dac adj
Date: Tue, 30 Jul 2013 10:31:41 +0100
Message-Id: <1375176725-5825-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Zary <linux@rainbow-software.org>

commit f7929f34fa0e0bb6736a2484fdc07d77a1653081 upstream.

Hello,
got another card with "too bright" problem:
Sapphire Radeon VE 7000 DDR (VGA+S-Video)

lspci -vnn:
01:00.0 VGA compatible controller [0300]: Advanced Micro Devices [AMD] nee ATI RV100 QY [Radeon 7000/VE] [1002:5159] (prog-if 00 [VGA controller])
        Subsystem: PC Partner Limited Sapphire Radeon VE 7000 DDR [174b:7c28]

The patch below fixes the problem for this card.
But I don't like the blacklist, couldn't some heuristic be used instead?
The interesting thing is that the manufacturer is the same as the other card
needing the same quirk. I wonder how many different types are broken this way.

The "wrong" ps2_pdac_adj value that comes from BIOS on this card is 0x300.

====================
drm/radeon: Add primary dac adj quirk for Sapphire Radeon VE 7000 DDR

Values from BIOS are wrong, causing too bright colors.
Use default values instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_combios.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/radeon/radeon_combios.c
index 77c50cc..f44dc93 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -959,10 +959,14 @@ struct radeon_encoder_primary_dac *radeon_combios_get_primary_dac_info(struct
 	}
 
 	/* quirks */
+	/* Radeon 7000 (RV100) */
+	if (((dev->pdev->device == 0x5159) &&
+	    (dev->pdev->subsystem_vendor == 0x174B) &&
+	    (dev->pdev->subsystem_device == 0x7c28)) ||
 	/* Radeon 9100 (R200) */
-	if ((dev->pdev->device == 0x514D) &&
+	   ((dev->pdev->device == 0x514D) &&
 	    (dev->pdev->subsystem_vendor == 0x174B) &&
-	    (dev->pdev->subsystem_device == 0x7149)) {
+	    (dev->pdev->subsystem_device == 0x7149))) {
 		/* vbios value is bad, use the default */
 		found = 0;
 	}
-- 
1.8.3.2

