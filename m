Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbaLEXkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:40:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaLEWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.17 065/122] ALSA: hda - Limit 40bit DMA for AMD HDMI controllers
Date: Fri,  5 Dec 2014 14:43:59 -0800
Message-Id: <20141205223315.458362654@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

commit 413cbf469a19e7662ba5025695bf5a573927105a upstream.

AMD/ATI HDMI controller chip models, we already have a filter to lower
to 32bit DMA, but the rest are supposed to be working with 64bit
although the hardware doesn't really work with 63bit but only with 40
or 48bit DMA.  In this patch, we take 40bit DMA for safety for the
AMD/ATI controllers as the graphics drivers does.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1484,6 +1484,7 @@ static int azx_first_init(struct azx *ch
 	struct snd_card *card = chip->card;
 	int err;
 	unsigned short gcap;
+	unsigned int dma_bits = 64;
 
 #if BITS_PER_LONG != 64
 	/* Fix up base address on ULI M5461 */
@@ -1520,9 +1521,14 @@ static int azx_first_init(struct azx *ch
 	gcap = azx_readw(chip, GCAP);
 	dev_dbg(card->dev, "chipset global capabilities = 0x%x\n", gcap);
 
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
@@ -1552,9 +1558,11 @@ static int azx_first_init(struct azx *ch
 	}
 
 	/* allow 64bit DMA address if supported by H/W */
-	if ((gcap & AZX_GCAP_64OK) && !pci_set_dma_mask(pci, DMA_BIT_MASK(64)))
-		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(64));
-	else {
+	if (!(gcap & AZX_GCAP_64OK))
+		dma_bits = 32;
+	if (!pci_set_dma_mask(pci, DMA_BIT_MASK(dma_bits))) {
+		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(dma_bits));
+	} else {
 		pci_set_dma_mask(pci, DMA_BIT_MASK(32));
 		pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32));
 	}


