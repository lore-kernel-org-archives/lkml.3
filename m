Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030546Ab3HBKL6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:11:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030385Ab3HBKLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:11:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [ 70/99] drm/radeon: Another card with wrong primary dac adj
Date: Fri,  2 Aug 2013 18:08:23 +0800
Message-Id: <20130802100235.769272392@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_combios.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -971,10 +971,14 @@ struct radeon_encoder_primary_dac *radeo
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


