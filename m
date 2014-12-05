Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaLEWsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:48:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaLEWqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Takashi Iwai <tiwai@suse.de>, Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 3.17 098/122] sound/radeon: Move 64-bit MSI quirk from arch to driver
Date: Fri,  5 Dec 2014 14:44:32 -0800
Message-Id: <20141205223320.678313884@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   10 ++++++++--
 sound/pci/hda/hda_priv.h  |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -296,7 +296,8 @@ enum {
 
 /* quirks for ATI/AMD HDMI */
 #define AZX_DCAPS_PRESET_ATI_HDMI \
-	(AZX_DCAPS_NO_TCSEL | AZX_DCAPS_SYNC_WRITE | AZX_DCAPS_POSFIX_LPIB)
+	(AZX_DCAPS_NO_TCSEL | AZX_DCAPS_SYNC_WRITE | AZX_DCAPS_POSFIX_LPIB|\
+	 AZX_DCAPS_NO_MSI64)
 
 /* quirks for Nvidia */
 #define AZX_DCAPS_PRESET_NVIDIA \
@@ -1508,9 +1509,14 @@ static int azx_first_init(struct azx *ch
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
--- a/sound/pci/hda/hda_priv.h
+++ b/sound/pci/hda/hda_priv.h
@@ -171,6 +171,7 @@ enum { SDI0, SDI1, SDI2, SDI3, SDO0, SDO
 #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
 #define AZX_DCAPS_I915_POWERWELL (1 << 27)	/* HSW i915 powerwell support */
 #define AZX_DCAPS_CORBRP_SELF_CLEAR (1 << 28)	/* CORBRP clears itself after reset */
+#define AZX_DCAPS_NO_MSI64      (1 << 29)	/* Stick to 32-bit MSIs */
 
 /* HD Audio class code */
 #define PCI_CLASS_MULTIMEDIA_HD_AUDIO	0x0403


