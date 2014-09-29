Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaI2JEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:04:06 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:38119 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaI2JEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:04:00 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 6/6] ALSA: ctxfi: pr_* replaced with dev_*
Date: Mon, 29 Sep 2014 14:33:26 +0530
Message-Id: <1411981406-10611-6-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1411981406-10611-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_* macros replaced with dev_* as they are more preffered over pr_*.
each file which had pr_* was reviewed manually and replaced with dev_*.
here we have actually used the various snd_card which was added to some
structures of ctxfi via a previous patch of this series.

in the ctvmem.c file we have passed a reference of ct_atc as an
argument to get_vm_block function so that it can be used from
dev_*.

since dev_* will print the device information , so the prefix of
"ctxfi" from the various pr_* were also removed.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctamixer.c   |  6 ++++--
 sound/pci/ctxfi/ctatc.c      | 27 ++++++++++++++++-----------
 sound/pci/ctxfi/ctdaio.c     |  3 ++-
 sound/pci/ctxfi/cthw20k1.c   | 15 +++++++++------
 sound/pci/ctxfi/cthw20k2.c   | 24 +++++++++++++++---------
 sound/pci/ctxfi/ctmixer.c    |  6 ++++--
 sound/pci/ctxfi/ctpcm.c      |  9 ++++++---
 sound/pci/ctxfi/ctresource.c | 18 ++++++++++++------
 sound/pci/ctxfi/ctsrc.c      |  6 ++++--
 sound/pci/ctxfi/ctvmem.c     | 12 ++++++++----
 sound/pci/ctxfi/xfi.c        | 15 +++++++++------
 11 files changed, 89 insertions(+), 52 deletions(-)

diff --git a/sound/pci/ctxfi/ctamixer.c b/sound/pci/ctxfi/ctamixer.c
index 4d389c3..c7dc38d 100644
--- a/sound/pci/ctxfi/ctamixer.c
+++ b/sound/pci/ctxfi/ctamixer.c
@@ -258,7 +258,8 @@ static int get_amixer_rsc(struct amixer_mgr *mgr,
 	}
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet AMIXER resource request!\n");
+		dev_err(mgr->card->dev,
+			"Can't meet AMIXER resource request!\n");
 		goto error;
 	}
 
@@ -412,7 +413,8 @@ static int get_sum_rsc(struct sum_mgr *mgr,
 	}
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet SUM resource request!\n");
+		dev_err(mgr->card->dev,
+			"Can't meet SUM resource request!\n");
 		goto error;
 	}
 
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index d62aa9e..4546590 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -186,7 +186,7 @@ static unsigned int convert_format(snd_pcm_format_t snd_format,
 	case SNDRV_PCM_FORMAT_FLOAT_LE:
 		return SRC_SF_F32;
 	default:
-		pr_err("ctxfi: not recognized snd format is %d\n",
+		dev_err(card->dev, "not recognized snd format is %d\n",
 			snd_format);
 		return SRC_SF_S16;
 	}
@@ -1286,8 +1286,9 @@ static int atc_identify_card(struct ct_atc *atc, unsigned int ssid)
 	p = snd_pci_quirk_lookup_id(vendor_id, device_id, list);
 	if (p) {
 		if (p->value < 0) {
-			pr_err("ctxfi: Device %04x:%04x is black-listed\n",
-			       vendor_id, device_id);
+			dev_err(atc->card->dev,
+				"Device %04x:%04x is black-listed\n",
+				vendor_id, device_id);
 			return -ENOENT;
 		}
 		atc->model = p->value;
@@ -1318,7 +1319,8 @@ int ct_atc_create_alsa_devs(struct ct_atc *atc)
 		err = alsa_dev_funcs[i].create(atc, i,
 				alsa_dev_funcs[i].public_name);
 		if (err) {
-			pr_err("ctxfi: Creating alsa device %d failed!\n", i);
+			dev_err(atc->card->dev,
+				"Creating alsa device %d failed!\n", i);
 			return err;
 		}
 	}
@@ -1334,7 +1336,7 @@ static int atc_create_hw_devs(struct ct_atc *atc)
 
 	err = create_hw_obj(atc->pci, atc->chip_type, atc->model, &hw);
 	if (err) {
-		pr_err("Failed to create hw obj!!!\n");
+		dev_err(atc->card->dev, "Failed to create hw obj!!!\n");
 		return err;
 	}
 	hw->card = atc->card;
@@ -1354,7 +1356,8 @@ static int atc_create_hw_devs(struct ct_atc *atc)
 
 		err = rsc_mgr_funcs[i].create(atc->hw, &atc->rsc_mgrs[i]);
 		if (err) {
-			pr_err("ctxfi: Failed to create rsc_mgr %d!!!\n", i);
+			dev_err(atc->card->dev,
+				"Failed to create rsc_mgr %d!!!\n", i);
 			return err;
 		}
 	}
@@ -1401,7 +1404,8 @@ static int atc_get_resources(struct ct_atc *atc)
 		err = daio_mgr->get_daio(daio_mgr, &da_desc,
 					(struct daio **)&atc->daios[i]);
 		if (err) {
-			pr_err("ctxfi: Failed to get DAIO resource %d!!!\n",
+			dev_err(atc->card->dev,
+				"Failed to get DAIO resource %d!!!\n",
 				i);
 			return err;
 		}
@@ -1605,7 +1609,8 @@ static int atc_resume(struct ct_atc *atc)
 	/* Do hardware resume. */
 	err = atc_hw_resume(atc);
 	if (err < 0) {
-		pr_err("ctxfi: pci_enable_device failed, disabling device\n");
+		dev_err(atc->card->dev,
+			"pci_enable_device failed, disabling device\n");
 		snd_card_disconnect(atc->card);
 		return err;
 	}
@@ -1702,7 +1707,7 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 	/* Find card model */
 	err = atc_identify_card(atc, ssid);
 	if (err < 0) {
-		pr_err("ctatc: Card not recognised\n");
+		dev_err(card->dev, "ctatc: Card not recognised\n");
 		goto error1;
 	}
 
@@ -1718,7 +1723,7 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 
 	err = ct_mixer_create(atc, (struct ct_mixer **)&atc->mixer);
 	if (err) {
-		pr_err("ctxfi: Failed to create mixer obj!!!\n");
+		dev_err(card->dev, "Failed to create mixer obj!!!\n");
 		goto error1;
 	}
 
@@ -1745,6 +1750,6 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 
 error1:
 	ct_atc_destroy(atc);
-	pr_err("ctxfi: Something wrong!!!\n");
+	dev_err(card->dev, "Something wrong!!!\n");
 	return err;
 }
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 9486ae2..feecbe5 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -539,7 +539,8 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 	err = daio_mgr_get_rsc(&mgr->mgr, desc->type);
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("Can't meet DAIO resource request!\n");
+		dev_err(mgr->card->dev,
+			"Can't meet DAIO resource request!\n");
 		return err;
 	}
 
diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index 8fc524f..b425aa8 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -1268,7 +1268,8 @@ static int hw_trn_init(struct hw *hw, const struct trn_conf *info)
 
 	/* Set up device page table */
 	if ((~0UL) == info->vm_pgt_phys) {
-		pr_err("Wrong device page table page address!\n");
+		dev_err(hw->card->dev,
+			"Wrong device page table page address!\n");
 		return -1;
 	}
 
@@ -1327,7 +1328,7 @@ static int hw_pll_init(struct hw *hw, unsigned int rsr)
 		mdelay(40);
 	}
 	if (i >= 3) {
-		pr_alert("PLL initialization failed!!!\n");
+		dev_alert(hw->card->dev, "PLL initialization failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1351,7 +1352,7 @@ static int hw_auto_init(struct hw *hw)
 			break;
 	}
 	if (!get_field(gctl, GCTL_AID)) {
-		pr_alert("Card Auto-init failed!!!\n");
+		dev_alert(hw->card->dev, "Card Auto-init failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1911,8 +1912,9 @@ static int hw_card_start(struct hw *hw)
 	/* Set DMA transfer mask */
 	if (pci_set_dma_mask(pci, CT_XFI_DMA_MASK) < 0 ||
 	    pci_set_consistent_dma_mask(pci, CT_XFI_DMA_MASK) < 0) {
-		pr_err("architecture does not support PCI busmaster DMA with mask 0x%llx\n",
-		       CT_XFI_DMA_MASK);
+		dev_err(hw->card->dev,
+			"architecture does not support PCI busmaster DMA with mask 0x%llx\n",
+			CT_XFI_DMA_MASK);
 		err = -ENXIO;
 		goto error1;
 	}
@@ -1941,7 +1943,8 @@ static int hw_card_start(struct hw *hw)
 		err = request_irq(pci->irq, ct_20k1_interrupt, IRQF_SHARED,
 				  KBUILD_MODNAME, hw);
 		if (err < 0) {
-			pr_err("XFi: Cannot get irq %d\n", pci->irq);
+			dev_err(hw->card->dev,
+				"XFi: Cannot get irq %d\n", pci->irq);
 			goto error2;
 		}
 		hw->irq = pci->irq;
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index b2c5d5a..253899d 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -1187,7 +1187,8 @@ static int hw_daio_init(struct hw *hw, const struct daio_conf *info)
 		hw_write_20kx(hw, AUDIO_IO_TX_BLRCLK, 0x21212121);
 		hw_write_20kx(hw, AUDIO_IO_RX_BLRCLK, 0);
 	} else {
-		pr_alert("ctxfi: ERROR!!! Invalid sampling rate!!!\n");
+		dev_alert(hw->card->dev,
+			  "ERROR!!! Invalid sampling rate!!!\n");
 		return -EINVAL;
 	}
 
@@ -1246,7 +1247,8 @@ static int hw_trn_init(struct hw *hw, const struct trn_conf *info)
 
 	/* Set up device page table */
 	if ((~0UL) == info->vm_pgt_phys) {
-		pr_alert("ctxfi: Wrong device page table page address!!!\n");
+		dev_alert(hw->card->dev,
+			  "Wrong device page table page address!!!\n");
 		return -1;
 	}
 
@@ -1351,7 +1353,8 @@ static int hw_pll_init(struct hw *hw, unsigned int rsr)
 		break;
 	}
 	if (i >= 1000) {
-		pr_alert("ctxfi: PLL initialization failed!!!\n");
+		dev_alert(hw->card->dev,
+			  "PLL initialization failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1375,7 +1378,7 @@ static int hw_auto_init(struct hw *hw)
 			break;
 	}
 	if (!get_field(gctl, GCTL_AID)) {
-		pr_alert("ctxfi: Card Auto-init failed!!!\n");
+		dev_alert(hw->card->dev, "Card Auto-init failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1846,7 +1849,7 @@ static int hw_adc_init(struct hw *hw, const struct adc_conf *info)
 	/* Initialize I2C */
 	err = hw20k2_i2c_init(hw, 0x1A, 1, 1);
 	if (err < 0) {
-		pr_alert("ctxfi: Failure to acquire I2C!!!\n");
+		dev_alert(hw->card->dev, "Failure to acquire I2C!!!\n");
 		goto error;
 	}
 
@@ -1889,8 +1892,9 @@ static int hw_adc_init(struct hw *hw, const struct adc_conf *info)
 		hw20k2_i2c_write(hw, MAKE_WM8775_ADDR(WM8775_MMC, 0x0A),
 						MAKE_WM8775_DATA(0x0A));
 	} else {
-		pr_alert("ctxfi: Invalid master sampling rate (msr %d)!!!\n",
-			info->msr);
+		dev_alert(hw->card->dev,
+			  "Invalid master sampling rate (msr %d)!!!\n",
+			  info->msr);
 		err = -EINVAL;
 		goto error;
 	}
@@ -2033,7 +2037,8 @@ static int hw_card_start(struct hw *hw)
 	/* Set DMA transfer mask */
 	if (pci_set_dma_mask(pci, CT_XFI_DMA_MASK) < 0 ||
 	    pci_set_consistent_dma_mask(pci, CT_XFI_DMA_MASK) < 0) {
-		pr_err("ctxfi: architecture does not support PCI busmaster DMA with mask 0x%llx\n",
+		dev_err(hw->card->dev,
+			"architecture does not support PCI busmaster DMA with mask 0x%llx\n",
 			CT_XFI_DMA_MASK);
 		err = -ENXIO;
 		goto error1;
@@ -2062,7 +2067,8 @@ static int hw_card_start(struct hw *hw)
 		err = request_irq(pci->irq, ct_20k2_interrupt, IRQF_SHARED,
 				  KBUILD_MODNAME, hw);
 		if (err < 0) {
-			pr_err("XFi: Cannot get irq %d\n", pci->irq);
+			dev_err(hw->card->dev,
+				"XFi: Cannot get irq %d\n", pci->irq);
 			goto error2;
 		}
 		hw->irq = pci->irq;
diff --git a/sound/pci/ctxfi/ctmixer.c b/sound/pci/ctxfi/ctmixer.c
index 017fa91..4f4a2a5 100644
--- a/sound/pci/ctxfi/ctmixer.c
+++ b/sound/pci/ctxfi/ctmixer.c
@@ -854,7 +854,8 @@ static int ct_mixer_get_resources(struct ct_mixer *mixer)
 	for (i = 0; i < (NUM_CT_SUMS * CHN_NUM); i++) {
 		err = sum_mgr->get_sum(sum_mgr, &sum_desc, &sum);
 		if (err) {
-			pr_err("ctxfi:Failed to get sum resources for front output!\n");
+			dev_err(mixer->atc->card->dev,
+				"Failed to get sum resources for front output!\n");
 			break;
 		}
 		mixer->sums[i] = sum;
@@ -868,7 +869,8 @@ static int ct_mixer_get_resources(struct ct_mixer *mixer)
 	for (i = 0; i < (NUM_CT_AMIXERS * CHN_NUM); i++) {
 		err = amixer_mgr->get_amixer(amixer_mgr, &am_desc, &amixer);
 		if (err) {
-			pr_err("ctxfi:Failed to get amixer resources for mixer obj!\n");
+			dev_err(mixer->atc->card->dev,
+				"Failed to get amixer resources for mixer obj!\n");
 			break;
 		}
 		mixer->amixers[i] = amixer;
diff --git a/sound/pci/ctxfi/ctpcm.c b/sound/pci/ctxfi/ctpcm.c
index 6826c2c..d86c474 100644
--- a/sound/pci/ctxfi/ctpcm.c
+++ b/sound/pci/ctxfi/ctpcm.c
@@ -217,7 +217,8 @@ static int ct_pcm_playback_prepare(struct snd_pcm_substream *substream)
 		err = atc->pcm_playback_prepare(atc, apcm);
 
 	if (err < 0) {
-		pr_err("ctxfi: Preparing pcm playback failed!!!\n");
+		dev_err(atc->card->dev,
+			"Preparing pcm playback failed!!!\n");
 		return err;
 	}
 
@@ -324,7 +325,8 @@ static int ct_pcm_capture_prepare(struct snd_pcm_substream *substream)
 
 	err = atc->pcm_capture_prepare(atc, apcm);
 	if (err < 0) {
-		pr_err("ctxfi: Preparing pcm capture failed!!!\n");
+		dev_err(atc->card->dev,
+			"Preparing pcm capture failed!!!\n");
 		return err;
 	}
 
@@ -435,7 +437,8 @@ int ct_alsa_pcm_create(struct ct_atc *atc,
 	err = snd_pcm_new(atc->card, "ctxfi", device,
 			  playback_count, capture_count, &pcm);
 	if (err < 0) {
-		pr_err("ctxfi: snd_pcm_new failed!! Err=%d\n", err);
+		dev_err(atc->card->dev, "snd_pcm_new failed!! Err=%d\n",
+			err);
 		return err;
 	}
 
diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
index 5aac63f..1a97e40 100644
--- a/sound/pci/ctxfi/ctresource.c
+++ b/sound/pci/ctxfi/ctresource.c
@@ -162,12 +162,14 @@ rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, struct hw *hw)
 	case DAIO:
 		break;
 	default:
-		pr_err("ctxfi: Invalid resource type value %d!\n", type);
+		dev_err(((struct hw *)hw)->card->dev,
+			"Invalid resource type value %d!\n", type);
 		return -EINVAL;
 	}
 
 	if (err) {
-		pr_err("ctxfi: Failed to get resource control block!\n");
+		dev_err(((struct hw *)hw)->card->dev,
+			"Failed to get resource control block!\n");
 		return err;
 	}
 
@@ -188,7 +190,8 @@ int rsc_uninit(struct rsc *rsc)
 		case DAIO:
 			break;
 		default:
-			pr_err("ctxfi: Invalid resource type value %d!\n",
+			dev_err(((struct hw *)rsc->hw)->card->dev,
+				"Invalid resource type value %d!\n",
 				rsc->type);
 			break;
 		}
@@ -230,13 +233,15 @@ int rsc_mgr_init(struct rsc_mgr *mgr, enum RSCTYP type,
 	case SUM:
 		break;
 	default:
-		pr_err("ctxfi: Invalid resource type value %d!\n", type);
+		dev_err(hw->card->dev,
+			"Invalid resource type value %d!\n", type);
 		err = -EINVAL;
 		goto error;
 	}
 
 	if (err) {
-		pr_err("ctxfi: Failed to get manager control block!\n");
+		dev_err(hw->card->dev,
+			"Failed to get manager control block!\n");
 		goto error;
 	}
 
@@ -275,7 +280,8 @@ int rsc_mgr_uninit(struct rsc_mgr *mgr)
 		case SUM:
 			break;
 		default:
-			pr_err("ctxfi: Invalid resource type value %d!\n",
+			dev_err(((struct hw *)mgr->hw)->card->dev,
+				"Invalid resource type value %d!\n",
 				mgr->type);
 			break;
 		}
diff --git a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
index 50fa35b..ec1f084 100644
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -431,7 +431,8 @@ get_src_rsc(struct src_mgr *mgr, const struct src_desc *desc, struct src **rsrc)
 
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet SRC resource request!\n");
+		dev_err(mgr->card->dev,
+			"Can't meet SRC resource request!\n");
 		return err;
 	}
 
@@ -740,7 +741,8 @@ static int get_srcimp_rsc(struct srcimp_mgr *mgr,
 	}
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet SRCIMP resource request!\n");
+		dev_err(mgr->card->dev,
+			"Can't meet SRCIMP resource request!\n");
 		goto error1;
 	}
 
diff --git a/sound/pci/ctxfi/ctvmem.c b/sound/pci/ctxfi/ctvmem.c
index 38163f5..419306e 100644
--- a/sound/pci/ctxfi/ctvmem.c
+++ b/sound/pci/ctxfi/ctvmem.c
@@ -16,6 +16,7 @@
  */
 
 #include "ctvmem.h"
+#include "ctatc.h"
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/io.h>
@@ -29,14 +30,15 @@
  * @size must be page aligned.
  * */
 static struct ct_vm_block *
-get_vm_block(struct ct_vm *vm, unsigned int size)
+get_vm_block(struct ct_vm *vm, unsigned int size, struct ct_atc *atc)
 {
 	struct ct_vm_block *block = NULL, *entry;
 	struct list_head *pos;
 
 	size = CT_PAGE_ALIGN(size);
 	if (size > vm->size) {
-		pr_err("ctxfi: Fail! No sufficient device virtual memory space available!\n");
+		dev_err(atc->card->dev,
+			"Fail! No sufficient device virtual memory space available!\n");
 		return NULL;
 	}
 
@@ -128,10 +130,12 @@ ct_vm_map(struct ct_vm *vm, struct snd_pcm_substream *substream, int size)
 	unsigned int pte_start;
 	unsigned i, pages;
 	unsigned long *ptp;
+	struct ct_atc *atc = snd_pcm_substream_chip(substream);
 
-	block = get_vm_block(vm, size);
+	block = get_vm_block(vm, size, atc);
 	if (block == NULL) {
-		pr_err("ctxfi: No virtual memory block that is big enough to allocate!\n");
+		dev_err(atc->card->dev,
+			"No virtual memory block that is big enough to allocate!\n");
 		return NULL;
 	}
 
diff --git a/sound/pci/ctxfi/xfi.c b/sound/pci/ctxfi/xfi.c
index 35e85ba..f2f3277 100644
--- a/sound/pci/ctxfi/xfi.c
+++ b/sound/pci/ctxfi/xfi.c
@@ -76,15 +76,18 @@ ct_card_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	if (err)
 		return err;
 	if ((reference_rate != 48000) && (reference_rate != 44100)) {
-		pr_err("ctxfi: Invalid reference_rate value %u!!!\n",
-		       reference_rate);
-		pr_err("ctxfi: The valid values for reference_rate are 48000 and 44100, Value 48000 is assumed.\n");
+		dev_err(card->dev,
+			"Invalid reference_rate value %u!!!\n",
+			reference_rate);
+		dev_err(card->dev,
+			"The valid values for reference_rate are 48000 and 44100, Value 48000 is assumed.\n");
 		reference_rate = 48000;
 	}
 	if ((multiple != 1) && (multiple != 2) && (multiple != 4)) {
-		pr_err("ctxfi: Invalid multiple value %u!!!\n",
-		       multiple);
-		pr_err("ctxfi: The valid values for multiple are 1, 2 and 4, Value 2 is assumed.\n");
+		dev_err(card->dev, "Invalid multiple value %u!!!\n",
+			multiple);
+		dev_err(card->dev,
+			"The valid values for multiple are 1, 2 and 4, Value 2 is assumed.\n");
 		multiple = 2;
 	}
 	err = ct_atc_create(card, pci, reference_rate, multiple,
-- 
1.8.1.2

