Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbaILKqD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:46:03 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43152 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbaILKp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:45:59 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sound: pci: ctxfi: pr_* replaced with dev_*
Date: Fri, 12 Sep 2014 16:15:45 +0530
Message-Id: <1410518745-29983-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_* macros replaced with dev_* as they are more preffered over pr_*.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 sound/pci/ctxfi/ctamixer.c   |  6 ++++--
 sound/pci/ctxfi/ctatc.c      | 23 ++++++++++++++---------
 sound/pci/ctxfi/ctdaio.c     |  3 ++-
 sound/pci/ctxfi/cthw20k1.c   | 13 ++++++++-----
 sound/pci/ctxfi/cthw20k2.c   | 22 ++++++++++++++--------
 sound/pci/ctxfi/ctmixer.c    |  6 ++++--
 sound/pci/ctxfi/ctpcm.c      |  3 ++-
 sound/pci/ctxfi/ctresource.c | 20 +++++++++++++-------
 sound/pci/ctxfi/ctsrc.c      |  6 ++++--
 sound/pci/ctxfi/xfi.c        | 15 +++++++++------
 10 files changed, 74 insertions(+), 43 deletions(-)

diff --git a/sound/pci/ctxfi/ctamixer.c b/sound/pci/ctxfi/ctamixer.c
index fed6e6a..d08b8b6 100644
--- a/sound/pci/ctxfi/ctamixer.c
+++ b/sound/pci/ctxfi/ctamixer.c
@@ -258,7 +258,8 @@ static int get_amixer_rsc(struct amixer_mgr *mgr,
 	}
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet AMIXER resource request!\n");
+		dev_err(&(((struct hw *)(mgr->mgr.hw))->pci->dev),
+			"ctxfi: Can't meet AMIXER resource request!\n");
 		goto error;
 	}
 
@@ -411,7 +412,8 @@ static int get_sum_rsc(struct sum_mgr *mgr,
 	}
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet SUM resource request!\n");
+		dev_err(&(((struct hw *)(mgr->mgr.hw))->pci->dev),
+			"ctxfi: Can't meet SUM resource request!\n");
 		goto error;
 	}
 
diff --git a/sound/pci/ctxfi/ctatc.c b/sound/pci/ctxfi/ctatc.c
index d92a08c..131b8d4 100644
--- a/sound/pci/ctxfi/ctatc.c
+++ b/sound/pci/ctxfi/ctatc.c
@@ -1282,7 +1282,8 @@ static int atc_identify_card(struct ct_atc *atc, unsigned int ssid)
 	p = snd_pci_quirk_lookup_id(vendor_id, device_id, list);
 	if (p) {
 		if (p->value < 0) {
-			pr_err("ctxfi: Device %04x:%04x is black-listed\n",
+			dev_err(&atc->pci->dev,
+				"ctxfi: Device %04x:%04x is black-listed\n",
 			       vendor_id, device_id);
 			return -ENOENT;
 		}
@@ -1314,7 +1315,8 @@ int ct_atc_create_alsa_devs(struct ct_atc *atc)
 		err = alsa_dev_funcs[i].create(atc, i,
 				alsa_dev_funcs[i].public_name);
 		if (err) {
-			pr_err("ctxfi: Creating alsa device %d failed!\n", i);
+			dev_err(&atc->pci->dev,
+				"ctxfi: Creating alsa device %d failed!\n", i);
 			return err;
 		}
 	}
@@ -1330,7 +1332,7 @@ static int atc_create_hw_devs(struct ct_atc *atc)
 
 	err = create_hw_obj(atc->pci, atc->chip_type, atc->model, &hw);
 	if (err) {
-		pr_err("Failed to create hw obj!!!\n");
+		dev_err(&atc->pci->dev, "Failed to create hw obj!!!\n");
 		return err;
 	}
 	atc->hw = hw;
@@ -1349,7 +1351,8 @@ static int atc_create_hw_devs(struct ct_atc *atc)
 
 		err = rsc_mgr_funcs[i].create(atc->hw, &atc->rsc_mgrs[i]);
 		if (err) {
-			pr_err("ctxfi: Failed to create rsc_mgr %d!!!\n", i);
+			dev_err(&atc->pci->dev,
+				"ctxfi: Failed to create rsc_mgr %d!!!\n", i);
 			return err;
 		}
 	}
@@ -1396,7 +1399,8 @@ static int atc_get_resources(struct ct_atc *atc)
 		err = daio_mgr->get_daio(daio_mgr, &da_desc,
 					(struct daio **)&atc->daios[i]);
 		if (err) {
-			pr_err("ctxfi: Failed to get DAIO resource %d!!!\n",
+			dev_err(&atc->pci->dev,
+				"ctxfi: Failed to get DAIO resource %d!!!\n",
 				i);
 			return err;
 		}
@@ -1600,7 +1604,8 @@ static int atc_resume(struct ct_atc *atc)
 	/* Do hardware resume. */
 	err = atc_hw_resume(atc);
 	if (err < 0) {
-		pr_err("ctxfi: pci_enable_device failed, disabling device\n");
+		dev_err(&atc->pci->dev,
+			"ctxfi: pci_enable_device failed, disabling device\n");
 		snd_card_disconnect(atc->card);
 		return err;
 	}
@@ -1697,7 +1702,7 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 	/* Find card model */
 	err = atc_identify_card(atc, ssid);
 	if (err < 0) {
-		pr_err("ctatc: Card not recognised\n");
+		dev_err(&pci->dev, "ctatc: Card not recognised\n");
 		goto error1;
 	}
 
@@ -1713,7 +1718,7 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 
 	err = ct_mixer_create(atc, (struct ct_mixer **)&atc->mixer);
 	if (err) {
-		pr_err("ctxfi: Failed to create mixer obj!!!\n");
+		dev_err(&pci->dev, "ctxfi: Failed to create mixer obj!!!\n");
 		goto error1;
 	}
 
@@ -1740,6 +1745,6 @@ int ct_atc_create(struct snd_card *card, struct pci_dev *pci,
 
 error1:
 	ct_atc_destroy(atc);
-	pr_err("ctxfi: Something wrong!!!\n");
+	dev_err(&pci->dev, "ctxfi: Something wrong!!!\n");
 	return err;
 }
diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index 6f0654e..fd64c95 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -541,7 +541,8 @@ static int get_daio_rsc(struct daio_mgr *mgr,
 	err = daio_mgr_get_rsc(&mgr->mgr, desc->type);
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("Can't meet DAIO resource request!\n");
+		dev_err(&(((struct hw *)(mgr->mgr.hw))->pci->dev),
+			"Can't meet DAIO resource request!\n");
 		return err;
 	}
 
diff --git a/sound/pci/ctxfi/cthw20k1.c b/sound/pci/ctxfi/cthw20k1.c
index 71d496f..a3d1dda 100644
--- a/sound/pci/ctxfi/cthw20k1.c
+++ b/sound/pci/ctxfi/cthw20k1.c
@@ -1268,7 +1268,8 @@ static int hw_trn_init(struct hw *hw, const struct trn_conf *info)
 
 	/* Set up device page table */
 	if ((~0UL) == info->vm_pgt_phys) {
-		pr_err("Wrong device page table page address!\n");
+		dev_err(&hw->pci->dev,
+			"Wrong device page table page address!\n");
 		return -1;
 	}
 
@@ -1327,7 +1328,7 @@ static int hw_pll_init(struct hw *hw, unsigned int rsr)
 		mdelay(40);
 	}
 	if (i >= 3) {
-		pr_alert("PLL initialization failed!!!\n");
+		dev_alert(&hw->pci->dev, "PLL initialization failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1351,7 +1352,7 @@ static int hw_auto_init(struct hw *hw)
 			break;
 	}
 	if (!get_field(gctl, GCTL_AID)) {
-		pr_alert("Card Auto-init failed!!!\n");
+		dev_alert(&hw->pci->dev, "Card Auto-init failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1911,7 +1912,8 @@ static int hw_card_start(struct hw *hw)
 	/* Set DMA transfer mask */
 	if (pci_set_dma_mask(pci, CT_XFI_DMA_MASK) < 0 ||
 	    pci_set_consistent_dma_mask(pci, CT_XFI_DMA_MASK) < 0) {
-		pr_err("architecture does not support PCI busmaster DMA with mask 0x%llx\n",
+		dev_err(&pci->dev,
+			"architecture does not support PCI busmaster DMA with mask 0x%llx\n",
 		       CT_XFI_DMA_MASK);
 		err = -ENXIO;
 		goto error1;
@@ -1941,7 +1943,8 @@ static int hw_card_start(struct hw *hw)
 		err = request_irq(pci->irq, ct_20k1_interrupt, IRQF_SHARED,
 				  KBUILD_MODNAME, hw);
 		if (err < 0) {
-			pr_err("XFi: Cannot get irq %d\n", pci->irq);
+			dev_err(&pci->dev, "XFi: Cannot get irq %d\n",
+				pci->irq);
 			goto error2;
 		}
 		hw->irq = pci->irq;
diff --git a/sound/pci/ctxfi/cthw20k2.c b/sound/pci/ctxfi/cthw20k2.c
index df2d8c5..a65f3bb 100644
--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -1187,7 +1187,8 @@ static int hw_daio_init(struct hw *hw, const struct daio_conf *info)
 		hw_write_20kx(hw, AUDIO_IO_TX_BLRCLK, 0x21212121);
 		hw_write_20kx(hw, AUDIO_IO_RX_BLRCLK, 0);
 	} else {
-		pr_alert("ctxfi: ERROR!!! Invalid sampling rate!!!\n");
+		dev_alert(&hw->pci->dev,
+			  "ctxfi: ERROR!!! Invalid sampling rate!!!\n");
 		return -EINVAL;
 	}
 
@@ -1246,7 +1247,8 @@ static int hw_trn_init(struct hw *hw, const struct trn_conf *info)
 
 	/* Set up device page table */
 	if ((~0UL) == info->vm_pgt_phys) {
-		pr_alert("ctxfi: Wrong device page table page address!!!\n");
+		dev_alert(&hw->pci->dev,
+			  "ctxfi: Wrong device page table page address!!!\n");
 		return -1;
 	}
 
@@ -1351,7 +1353,8 @@ static int hw_pll_init(struct hw *hw, unsigned int rsr)
 		break;
 	}
 	if (i >= 1000) {
-		pr_alert("ctxfi: PLL initialization failed!!!\n");
+		dev_alert(&hw->pci->dev,
+			  "ctxfi: PLL initialization failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1375,7 +1378,7 @@ static int hw_auto_init(struct hw *hw)
 			break;
 	}
 	if (!get_field(gctl, GCTL_AID)) {
-		pr_alert("ctxfi: Card Auto-init failed!!!\n");
+		dev_alert(&hw->pci->dev, "ctxfi: Card Auto-init failed!!!\n");
 		return -EBUSY;
 	}
 
@@ -1846,7 +1849,7 @@ static int hw_adc_init(struct hw *hw, const struct adc_conf *info)
 	/* Initialize I2C */
 	err = hw20k2_i2c_init(hw, 0x1A, 1, 1);
 	if (err < 0) {
-		pr_alert("ctxfi: Failure to acquire I2C!!!\n");
+		dev_alert(&hw->pci->dev, "ctxfi: Failure to acquire I2C!!!\n");
 		goto error;
 	}
 
@@ -1889,7 +1892,8 @@ static int hw_adc_init(struct hw *hw, const struct adc_conf *info)
 		hw20k2_i2c_write(hw, MAKE_WM8775_ADDR(WM8775_MMC, 0x0A),
 						MAKE_WM8775_DATA(0x0A));
 	} else {
-		pr_alert("ctxfi: Invalid master sampling rate (msr %d)!!!\n",
+		dev_alert(&hw->pci->dev,
+			  "ctxfi: Invalid master sampling rate (msr %d)!!!\n",
 			info->msr);
 		err = -EINVAL;
 		goto error;
@@ -2033,7 +2037,8 @@ static int hw_card_start(struct hw *hw)
 	/* Set DMA transfer mask */
 	if (pci_set_dma_mask(pci, CT_XFI_DMA_MASK) < 0 ||
 	    pci_set_consistent_dma_mask(pci, CT_XFI_DMA_MASK) < 0) {
-		pr_err("ctxfi: architecture does not support PCI busmaster DMA with mask 0x%llx\n",
+		dev_err(&pci->dev,
+			"ctxfi: architecture does not support PCI busmaster DMA with mask 0x%llx\n",
 			CT_XFI_DMA_MASK);
 		err = -ENXIO;
 		goto error1;
@@ -2062,7 +2067,8 @@ static int hw_card_start(struct hw *hw)
 		err = request_irq(pci->irq, ct_20k2_interrupt, IRQF_SHARED,
 				  KBUILD_MODNAME, hw);
 		if (err < 0) {
-			pr_err("XFi: Cannot get irq %d\n", pci->irq);
+			dev_err(&pci->dev, "XFi: Cannot get irq %d\n",
+				pci->irq);
 			goto error2;
 		}
 		hw->irq = pci->irq;
diff --git a/sound/pci/ctxfi/ctmixer.c b/sound/pci/ctxfi/ctmixer.c
index 017fa91..6807ff1fc 100644
--- a/sound/pci/ctxfi/ctmixer.c
+++ b/sound/pci/ctxfi/ctmixer.c
@@ -854,7 +854,8 @@ static int ct_mixer_get_resources(struct ct_mixer *mixer)
 	for (i = 0; i < (NUM_CT_SUMS * CHN_NUM); i++) {
 		err = sum_mgr->get_sum(sum_mgr, &sum_desc, &sum);
 		if (err) {
-			pr_err("ctxfi:Failed to get sum resources for front output!\n");
+			dev_err(&mixer->atc->pci->dev,
+				"ctxfi:Failed to get sum resources for front output!\n");
 			break;
 		}
 		mixer->sums[i] = sum;
@@ -868,7 +869,8 @@ static int ct_mixer_get_resources(struct ct_mixer *mixer)
 	for (i = 0; i < (NUM_CT_AMIXERS * CHN_NUM); i++) {
 		err = amixer_mgr->get_amixer(amixer_mgr, &am_desc, &amixer);
 		if (err) {
-			pr_err("ctxfi:Failed to get amixer resources for mixer obj!\n");
+			dev_err(&mixer->atc->pci->dev,
+				"ctxfi:Failed to get amixer resources for mixer obj!\n");
 			break;
 		}
 		mixer->amixers[i] = amixer;
diff --git a/sound/pci/ctxfi/ctpcm.c b/sound/pci/ctxfi/ctpcm.c
index 6826c2c..48f58a5 100644
--- a/sound/pci/ctxfi/ctpcm.c
+++ b/sound/pci/ctxfi/ctpcm.c
@@ -435,7 +435,8 @@ int ct_alsa_pcm_create(struct ct_atc *atc,
 	err = snd_pcm_new(atc->card, "ctxfi", device,
 			  playback_count, capture_count, &pcm);
 	if (err < 0) {
-		pr_err("ctxfi: snd_pcm_new failed!! Err=%d\n", err);
+		dev_err(&atc->pci->dev, "ctxfi: snd_pcm_new failed!! Err=%d\n",
+			err);
 		return err;
 	}
 
diff --git a/sound/pci/ctxfi/ctresource.c b/sound/pci/ctxfi/ctresource.c
index e49d2be..80beecb 100644
--- a/sound/pci/ctxfi/ctresource.c
+++ b/sound/pci/ctxfi/ctresource.c
@@ -162,12 +162,14 @@ int rsc_init(struct rsc *rsc, u32 idx, enum RSCTYP type, u32 msr, void *hw)
 	case DAIO:
 		break;
 	default:
-		pr_err("ctxfi: Invalid resource type value %d!\n", type);
+		dev_err(&(((struct hw *)hw)->pci->dev),
+			"ctxfi: Invalid resource type value %d!\n", type);
 		return -EINVAL;
 	}
 
 	if (err) {
-		pr_err("ctxfi: Failed to get resource control block!\n");
+		dev_err(&(((struct hw *)hw)->pci->dev),
+			"ctxfi: Failed to get resource control block!\n");
 		return err;
 	}
 
@@ -190,7 +192,8 @@ int rsc_uninit(struct rsc *rsc)
 		case DAIO:
 			break;
 		default:
-			pr_err("ctxfi: Invalid resource type value %d!\n",
+			dev_err(&(((struct hw *)rsc->hw)->pci->dev),
+				"ctxfi: Invalid resource type value %d!\n",
 				rsc->type);
 			break;
 		}
@@ -233,13 +236,15 @@ int rsc_mgr_init(struct rsc_mgr *mgr, enum RSCTYP type,
 	case SUM:
 		break;
 	default:
-		pr_err("ctxfi: Invalid resource type value %d!\n", type);
+		dev_err(&hw->pci->dev,
+			"ctxfi: Invalid resource type value %d!\n", type);
 		err = -EINVAL;
 		goto error;
 	}
 
 	if (err) {
-		pr_err("ctxfi: Failed to get manager control block!\n");
+		dev_err(&hw->pci->dev,
+			"ctxfi: Failed to get manager control block!\n");
 		goto error;
 	}
 
@@ -282,8 +287,9 @@ int rsc_mgr_uninit(struct rsc_mgr *mgr)
 		case SUM:
 			break;
 		default:
-			pr_err("ctxfi: Invalid resource type value %d!\n",
-				mgr->type);
+			dev_err(&(((struct hw *)mgr->hw)->pci->dev),
+				"ctxfi: Invalid resource type value %d!\n",
+				 mgr->type);
 			break;
 		}
 
diff --git a/sound/pci/ctxfi/ctsrc.c b/sound/pci/ctxfi/ctsrc.c
index 19df9b4..3a6e398 100644
--- a/sound/pci/ctxfi/ctsrc.c
+++ b/sound/pci/ctxfi/ctsrc.c
@@ -431,7 +431,8 @@ get_src_rsc(struct src_mgr *mgr, const struct src_desc *desc, struct src **rsrc)
 
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet SRC resource request!\n");
+		dev_err(&(((struct hw *)(mgr->mgr.hw))->pci->dev),
+			"ctxfi: Can't meet SRC resource request!\n");
 		return err;
 	}
 
@@ -739,7 +740,8 @@ static int get_srcimp_rsc(struct srcimp_mgr *mgr,
 	}
 	spin_unlock_irqrestore(&mgr->mgr_lock, flags);
 	if (err) {
-		pr_err("ctxfi: Can't meet SRCIMP resource request!\n");
+		dev_err(&(((struct hw *)(mgr->mgr.hw))->pci->dev),
+			"ctxfi: Can't meet SRCIMP resource request!\n");
 		goto error1;
 	}
 
diff --git a/sound/pci/ctxfi/xfi.c b/sound/pci/ctxfi/xfi.c
index 35e85ba..10c7896 100644
--- a/sound/pci/ctxfi/xfi.c
+++ b/sound/pci/ctxfi/xfi.c
@@ -76,15 +76,18 @@ ct_card_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	if (err)
 		return err;
 	if ((reference_rate != 48000) && (reference_rate != 44100)) {
-		pr_err("ctxfi: Invalid reference_rate value %u!!!\n",
-		       reference_rate);
-		pr_err("ctxfi: The valid values for reference_rate are 48000 and 44100, Value 48000 is assumed.\n");
+		dev_err(&pci->dev,
+			"ctxfi: Invalid reference_rate value %u!!\n",
+			reference_rate);
+		dev_err(&pci->dev,
+			"ctxfi: The valid values for reference_rate are 48000 and 44100, Value 48000 is assumed.\n");
 		reference_rate = 48000;
 	}
 	if ((multiple != 1) && (multiple != 2) && (multiple != 4)) {
-		pr_err("ctxfi: Invalid multiple value %u!!!\n",
-		       multiple);
-		pr_err("ctxfi: The valid values for multiple are 1, 2 and 4, Value 2 is assumed.\n");
+		dev_err(&pci->dev, "ctxfi: Invalid multiple value %u!!!\n",
+			multiple);
+		dev_err(&pci->dev,
+			"ctxfi: The valid values for multiple are 1, 2 and 4, Value 2 is assumed.\n");
 		multiple = 2;
 	}
 	err = ct_atc_create(card, pci, reference_rate, multiple,
-- 
1.8.1.2

