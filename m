Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965856AbaLLGps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:45:48 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51812 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758931AbaLLGQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:55 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.120064723@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 154/164] ALSA: hda - Limit 40bit DMA for AMD HDMI
 controllers
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - s/AZX_GCAP_64OK/ICH6_GCAP_64OK/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/hda/hda_intel.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2667,6 +2667,7 @@ static int __devinit azx_create(struct s
 	struct azx *chip;
 	int i, err;
 	unsigned short gcap;
+	unsigned int dma_bits = 64;
 	static struct snd_device_ops ops = {
 		.dev_free = azx_dev_free,
 	};
@@ -2754,9 +2755,14 @@ static int __devinit azx_create(struct s
 	gcap = azx_readw(chip, GCAP);
 	snd_printdd(SFX "chipset global capabilities = 0x%x\n", gcap);
 
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
@@ -2779,9 +2785,11 @@ static int __devinit azx_create(struct s
 		chip->align_buffer_size = 0;
 
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

