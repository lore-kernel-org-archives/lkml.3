Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab3GaN0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:26:07 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46921 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759689Ab3GaNZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:58 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ondrej Zary" <linux@rainbow-software.org>,
        "Alex Deucher" <alexander.deucher@amd.com>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.821675692@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [63/84] drm/radeon: Another card with wrong primary dac adj
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/radeon/radeon_combios.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -959,10 +959,14 @@ struct radeon_encoder_primary_dac *radeo
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

