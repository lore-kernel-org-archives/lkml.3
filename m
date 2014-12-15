Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaLOOrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:47:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38716 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaLOO2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:32 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 104/168] sound/radeon: Move 64-bit MSI quirk from arch to driver
Date: Mon, 15 Dec 2014 14:25:58 +0000
Message-Id: <1418653622-21105-105-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit db79afa1e57925ba96ab18514c0ebe42a28e393e upstream.

A number of radeon cards have a HW limitation causing them to be
unable to generate the full 64-bit of address bits for MSIs. This
breaks MSIs on some platforms such as POWER machines.

We used to have a powerpc specific quirk to address that on a
single card, but this doesn't scale very well, this is better
put under control of the drivers who know precisely what a given
HW revision can do.

We now have a generic quirk in the PCI code. We should set it
appropriately for all radeon's from the audio driver.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_intel.c | 10 ++++++++--
 sound/pci/hda/hda_priv.h  |  1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index ba0266f7cf03..6383971dcd15 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -252,7 +252,8 @@ enum {
 
 /* quirks for ATI/AMD HDMI */
 #define AZX_DCAPS_PRESET_ATI_HDMI \
-	(AZX_DCAPS_NO_TCSEL | AZX_DCAPS_SYNC_WRITE | AZX_DCAPS_POSFIX_LPIB)
+	(AZX_DCAPS_NO_TCSEL | AZX_DCAPS_SYNC_WRITE | AZX_DCAPS_POSFIX_LPIB|\
+	 AZX_DCAPS_NO_MSI64)
 
 /* quirks for Nvidia */
 #define AZX_DCAPS_PRESET_NVIDIA \
@@ -1297,9 +1298,14 @@ static int azx_first_init(struct azx *chip)
 		return -ENXIO;
 	}
 
-	if (chip->msi)
+	if (chip->msi) {
+		if (chip->driver_caps & AZX_DCAPS_NO_MSI64) {
+			dev_dbg(card->dev, "Disabling 64bit MSI\n");
+			pci->no_64bit_msi = true;
+		}
 		if (pci_enable_msi(pci) < 0)
 			chip->msi = 0;
+	}
 
 	if (azx_acquire_irq(chip, 0) < 0)
 		return -EBUSY;
diff --git a/sound/pci/hda/hda_priv.h b/sound/pci/hda/hda_priv.h
index e9d1a5762a55..526bc876f0a1 100644
--- a/sound/pci/hda/hda_priv.h
+++ b/sound/pci/hda/hda_priv.h
@@ -191,6 +191,7 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO1, SDO2, SDO3 };
 #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
 #define AZX_DCAPS_I915_POWERWELL (1 << 27)	/* HSW i915 powerwell support */
 #define AZX_DCAPS_CORBRP_SELF_CLEAR (1 << 28)	/* CORBRP clears itself after reset */
+#define AZX_DCAPS_NO_MSI64      (1 << 29)	/* Stick to 32-bit MSIs */
 
 /* position fix mode */
 enum {
-- 
2.1.3

