Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaLOTay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:30:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40812 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLOTau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:30:50 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 53/96] ALSA: hda - Limit 40bit DMA for AMD HDMI controllers
Date: Mon, 15 Dec 2014 11:26:13 -0800
Message-Id: <1418671616-25482-54-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 413cbf469a19e7662ba5025695bf5a573927105a upstream.

AMD/ATI HDMI controller chip models, we already have a filter to lower
to 32bit DMA, but the rest are supposed to be working with 64bit
although the hardware doesn't really work with 63bit but only with 40
or 48bit DMA.  In this patch, we take 40bit DMA for safety for the
AMD/ATI controllers as the graphics drivers does.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
[ kamal: backport to 3.13-stable: s/AZX/ICH6/ ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index a045023..c3f7839 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -3657,6 +3657,7 @@ static int azx_first_init(struct azx *chip)
 	struct snd_card *card = chip->card;
 	int i, err;
 	unsigned short gcap;
+	unsigned int dma_bits = 64;
 
 #if BITS_PER_LONG != 64
 	/* Fix up base address on ULI M5461 */
@@ -3693,9 +3694,14 @@ static int azx_first_init(struct azx *chip)
 	gcap = azx_readw(chip, GCAP);
 	snd_printdd(SFX "%s: chipset global capabilities = 0x%x\n", pci_name(chip->pci), gcap);
 
+	/* AMD devices support 40 or 48bit DMA, take the safe one */
+	if (chip->pci->vendor == PCI_VENDOR_ID_AMD)
+		dma_bits = 40;
+
 	/* disable SB600 64bit support for safety */
 	if (chip->pci->vendor == PCI_VENDOR_ID_ATI) {
 		struct pci_dev *p_smbus;
+		dma_bits = 40;
 		p_smbus = pci_get_device(PCI_VENDOR_ID_ATI,
 					 PCI_DEVICE_ID_ATI_SBX00_SMBUS,
 					 NULL);
@@ -3725,9 +3731,11 @@ static int azx_first_init(struct azx *chip)
 	}
 
 	/* allow 64bit DMA address if supported by H/W */
-	if ((gcap & ICH6_GCAP_64OK) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
-		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
-	else {
+	if (!(gcap & ICH6_GCAP_64OK))
+		dma_bits = 32;
+	if (!pci_set_dma_mask(pci, DMA_BIT_MASK(dma_bits))) {
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(dma_bits));
+	} else {
 		pci_set_dma_mask(pci, DMA_BIT_MASK(32));
 		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32));
 	}
-- 
1.9.1

