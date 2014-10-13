Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753105AbaJMGHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 02:07:39 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33244 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaJMGHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 02:07:33 -0400
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Raymond Yau <superquad.vortex2@gmail.com>
Subject: [PATCH v3 2/2] ALSA: au88x0: pr_* replaced with dev_*
Date: Mon, 13 Oct 2014 11:37:19 +0530
Message-Id: <1413180439-4491-2-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1413180439-4491-1-git-send-email-sudipm.mukherjee@gmail.com>
References: <1413180439-4491-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pr_* macros replaced with dev_* as they are more preffered over pr_*.
each file which had pr_* was reviewed manually and replaced with dev_*.
here we have actually used the reference of the vortex which was added
to some functions in the previous patch of this series.

The prefix of the CARD_NAME and prefix of "vortex:" was also
removed as the dev_* will print the device name.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

change from v1: removed CARD_NAME and "vortex:"
change for v2: added newline to init and shutdown while printing

in the probe function there is a email address : openvortex-dev@nongnu.org
is it still working ? the archieve shows the last message was in 2006.

 sound/pci/au88x0/au88x0.c        | 33 +++++++-------
 sound/pci/au88x0/au88x0_a3d.c    | 15 ++++---
 sound/pci/au88x0/au88x0_core.c   | 97 +++++++++++++++++++++-------------------
 sound/pci/au88x0/au88x0_eq.c     |  3 +-
 sound/pci/au88x0/au88x0_game.c   |  3 +-
 sound/pci/au88x0/au88x0_mpu401.c |  2 +-
 sound/pci/au88x0/au88x0_pcm.c    |  6 +--
 sound/pci/au88x0/au88x0_synth.c  | 17 ++++---
 8 files changed, 94 insertions(+), 82 deletions(-)

diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index 21ce31f..e9c3833 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -48,11 +48,10 @@ static void vortex_fix_latency(struct pci_dev *vortex)
 {
 	int rc;
 	if (!(rc = pci_write_config_byte(vortex, 0x40, 0xff))) {
-			pr_info( CARD_NAME
-			       ": vortex latency is 0xff\n");
+			dev_info(&vortex->dev, "vortex latency is 0xff\n");
 	} else {
-		pr_warn( CARD_NAME
-				": could not set vortex latency: pci error 0x%x\n", rc);
+		dev_warn(&vortex->dev,
+			 "could not set vortex latency: pci error 0x%x\n", rc);
 	}
 }
 
@@ -70,11 +69,10 @@ static void vortex_fix_agp_bridge(struct pci_dev *via)
 	if (!(rc = pci_read_config_byte(via, 0x42, &value))
 			&& ((value & 0x10)
 				|| !(rc = pci_write_config_byte(via, 0x42, value | 0x10)))) {
-		pr_info( CARD_NAME
-				": bridge config is 0x%x\n", value | 0x10);
+		dev_info(&via->dev, "bridge config is 0x%x\n", value | 0x10);
 	} else {
-		pr_warn( CARD_NAME
-				": could not set vortex latency: pci error 0x%x\n", rc);
+		dev_warn(&via->dev,
+			 "could not set vortex latency: pci error 0x%x\n", rc);
 	}
 }
 
@@ -97,7 +95,8 @@ static void snd_vortex_workaround(struct pci_dev *vortex, int fix)
 					PCI_DEVICE_ID_AMD_FE_GATE_7007, NULL);
 		}
 		if (via) {
-			pr_info( CARD_NAME ": Activating latency workaround...\n");
+			dev_info(&vortex->dev,
+				 "Activating latency workaround...\n");
 			vortex_fix_latency(vortex);
 			vortex_fix_agp_bridge(via);
 		}
@@ -153,7 +152,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
 		return err;
 	if (pci_set_dma_mask(pci, DMA_BIT_MASK(32)) < 0 ||
 	    pci_set_consistent_dma_mask(pci, DMA_BIT_MASK(32)) < 0) {
-		pr_err( "error to set DMA mask\n");
+		dev_err(card->dev, "error to set DMA mask\n");
 		pci_disable_device(pci);
 		return -ENXIO;
 	}
@@ -182,7 +181,7 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
 
 	chip->mmio = pci_ioremap_bar(pci, 0);
 	if (!chip->mmio) {
-		pr_err( "MMIO area remap failed.\n");
+		dev_err(card->dev, "MMIO area remap failed.\n");
 		err = -ENOMEM;
 		goto ioremap_out;
 	}
@@ -191,14 +190,14 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
 	 * This must be done before we do request_irq otherwise we can get spurious
 	 * interrupts that we do not handle properly and make a mess of things */
 	if ((err = vortex_core_init(chip)) != 0) {
-		pr_err( "hw core init failed\n");
+		dev_err(card->dev, "hw core init failed\n");
 		goto core_out;
 	}
 
 	if ((err = request_irq(pci->irq, vortex_interrupt,
 			       IRQF_SHARED, KBUILD_MODNAME,
 	                       chip)) != 0) {
-		pr_err( "cannot grab irq\n");
+		dev_err(card->dev, "cannot grab irq\n");
 		goto irq_out;
 	}
 	chip->irq = pci->irq;
@@ -342,11 +341,11 @@ snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	chip->rev = pci->revision;
 #ifdef CHIP_AU8830
 	if ((chip->rev) != 0xfe && (chip->rev) != 0xfa) {
-		pr_alert(
-		       "vortex: The revision (%x) of your card has not been seen before.\n",
+		dev_alert(card->dev,
+			  "The revision (%x) of your card has not been seen before.\n",
 		       chip->rev);
-		pr_alert(
-		       "vortex: Please email the results of 'lspci -vv' to openvortex-dev@nongnu.org.\n");
+		dev_alert(card->dev,
+			  "Please email the results of 'lspci -vv' to openvortex-dev@nongnu.org.\n");
 		snd_card_free(card);
 		err = -ENODEV;
 		return err;
diff --git a/sound/pci/au88x0/au88x0_a3d.c b/sound/pci/au88x0/au88x0_a3d.c
index bc9cda3a..ab0f873 100644
--- a/sound/pci/au88x0/au88x0_a3d.c
+++ b/sound/pci/au88x0/au88x0_a3d.c
@@ -489,7 +489,8 @@ static void a3dsrc_ZeroStateA3D(a3dsrc_t *a, vortex_t *v)
 	int i, var, var2;
 
 	if ((a->vortex) == NULL) {
-		pr_err( "vortex: ZeroStateA3D: ERROR: a->vortex is NULL\n");
+		dev_err(v->card->dev,
+			"ZeroStateA3D: ERROR: a->vortex is NULL\n");
 		return;
 	}
 
@@ -628,15 +629,15 @@ static void vortex_Vort3D_connect(vortex_t * v, int en)
 	v->mixxtlk[0] =
 	    vortex_adb_checkinout(v, v->fixed_res, en, VORTEX_RESOURCE_MIXIN);
 	if (v->mixxtlk[0] < 0) {
-		pr_warn
-		    ("vortex: vortex_Vort3D: ERROR: not enough free mixer resources.\n");
+		dev_warn(v->card->dev,
+			 "vortex_Vort3D: ERROR: not enough free mixer resources.\n");
 		return;
 	}
 	v->mixxtlk[1] =
 	    vortex_adb_checkinout(v, v->fixed_res, en, VORTEX_RESOURCE_MIXIN);
 	if (v->mixxtlk[1] < 0) {
-		pr_warn
-		    ("vortex: vortex_Vort3D: ERROR: not enough free mixer resources.\n");
+		dev_warn(v->card->dev,
+			 "vortex_Vort3D: ERROR: not enough free mixer resources.\n");
 		return;
 	}
 #endif
@@ -679,8 +680,8 @@ static void vortex_Vort3D_connect(vortex_t * v, int en)
 static void vortex_Vort3D_InitializeSource(a3dsrc_t *a, int en, vortex_t *v)
 {
 	if (a->vortex == NULL) {
-		pr_warn
-		    ("vortex: Vort3D_InitializeSource: A3D source not initialized\n");
+		dev_warn(v->card->dev,
+			 "Vort3D_InitializeSource: A3D source not initialized\n");
 		return;
 	}
 	if (en) {
diff --git a/sound/pci/au88x0/au88x0_core.c b/sound/pci/au88x0/au88x0_core.c
index 00e2096..d7de51c 100644
--- a/sound/pci/au88x0/au88x0_core.c
+++ b/sound/pci/au88x0/au88x0_core.c
@@ -285,8 +285,8 @@ vortex_mixer_addWTD(vortex_t * vortex, unsigned char mix, unsigned char ch)
 		temp = hwread(vortex->mmio, prev);
 		//printk(KERN_INFO "vortex: mixAddWTD: while addr=%x, val=%x\n", prev, temp);
 		if ((++lifeboat) > 0xf) {
-			pr_err(
-			       "vortex_mixer_addWTD: lifeboat overflow\n");
+			dev_err(vortex->card->dev,
+				"vortex_mixer_addWTD: lifeboat overflow\n");
 			return 0;
 		}
 	}
@@ -303,7 +303,7 @@ vortex_mixer_delWTD(vortex_t * vortex, unsigned char mix, unsigned char ch)
 
 	eax = hwread(vortex->mmio, VORTEX_MIXER_SR);
 	if (((1 << ch) & eax) == 0) {
-		pr_err( "mix ALARM %x\n", eax);
+		dev_err(vortex->card->dev, "mix ALARM %x\n", eax);
 		return 0;
 	}
 	ebp = VORTEX_MIXER_CHNBASE + (ch << 2);
@@ -324,8 +324,8 @@ vortex_mixer_delWTD(vortex_t * vortex, unsigned char mix, unsigned char ch)
 			//printk(KERN_INFO "vortex: mixdelWTD: 1 addr=%x, val=%x, src=%x\n", ebx, edx, src);
 			while ((edx & 0xf) != mix) {
 				if ((esi) > 0xf) {
-					pr_err(
-					       "vortex: mixdelWTD: error lifeboat overflow\n");
+					dev_err(vortex->card->dev,
+						"mixdelWTD: error lifeboat overflow\n");
 					return 0;
 				}
 				esp14 = ebx;
@@ -492,7 +492,7 @@ vortex_src_persist_convratio(vortex_t * vortex, unsigned char src, int ratio)
 		hwwrite(vortex->mmio, VORTEX_SRC_CONVRATIO + (src << 2), ratio);
 		temp = hwread(vortex->mmio, VORTEX_SRC_CONVRATIO + (src << 2));
 		if ((++lifeboat) > 0x9) {
-			pr_err( "Vortex: Src cvr fail\n");
+			dev_err(vortex->card->dev, "Src cvr fail\n");
 			break;
 		}
 	}
@@ -684,8 +684,8 @@ vortex_src_addWTD(vortex_t * vortex, unsigned char src, unsigned char ch)
 		temp = hwread(vortex->mmio, prev);
 		//printk(KERN_INFO "vortex: srcAddWTD: while addr=%x, val=%x\n", prev, temp);
 		if ((++lifeboat) > 0xf) {
-			pr_err(
-			       "vortex_src_addWTD: lifeboat overflow\n");
+			dev_err(vortex->card->dev,
+				"vortex_src_addWTD: lifeboat overflow\n");
 			return 0;
 		}
 	}
@@ -703,7 +703,7 @@ vortex_src_delWTD(vortex_t * vortex, unsigned char src, unsigned char ch)
 
 	eax = hwread(vortex->mmio, VORTEX_SRCBLOCK_SR);
 	if (((1 << ch) & eax) == 0) {
-		pr_err( "src alarm\n");
+		dev_err(vortex->card->dev, "src alarm\n");
 		return 0;
 	}
 	ebp = VORTEX_SRC_CHNBASE + (ch << 2);
@@ -724,8 +724,8 @@ vortex_src_delWTD(vortex_t * vortex, unsigned char src, unsigned char ch)
 			//printk(KERN_INFO "vortex: srcdelWTD: 1 addr=%x, val=%x, src=%x\n", ebx, edx, src);
 			while ((edx & 0xf) != src) {
 				if ((esi) > 0xf) {
-					pr_warn
-					    ("vortex: srcdelWTD: error, lifeboat overflow\n");
+					dev_warn(vortex->card->dev,
+						 "srcdelWTD: error, lifeboat overflow\n");
 					return 0;
 				}
 				esp14 = ebx;
@@ -819,8 +819,8 @@ vortex_fifo_setadbctrl(vortex_t * vortex, int fifo, int stereo, int priority,
 	do {
 		temp = hwread(vortex->mmio, VORTEX_FIFO_ADBCTRL + (fifo << 2));
 		if (lifeboat++ > 0xbb8) {
-			pr_err(
-			       "Vortex: vortex_fifo_setadbctrl fail\n");
+			dev_err(vortex->card->dev,
+				"vortex_fifo_setadbctrl fail\n");
 			break;
 		}
 	}
@@ -915,7 +915,8 @@ vortex_fifo_setwtctrl(vortex_t * vortex, int fifo, int ctrl, int priority,
 	do {
 		temp = hwread(vortex->mmio, VORTEX_FIFO_WTCTRL + (fifo << 2));
 		if (lifeboat++ > 0xbb8) {
-			pr_err( "Vortex: vortex_fifo_setwtctrl fail\n");
+			dev_err(vortex->card->dev,
+				"vortex_fifo_setwtctrl fail\n");
 			break;
 		}
 	}
@@ -1042,7 +1043,7 @@ static void vortex_fifo_init(vortex_t * vortex)
 	for (x = NR_ADB - 1; x >= 0; x--) {
 		hwwrite(vortex->mmio, addr, (FIFO_U0 | FIFO_U1));
 		if (hwread(vortex->mmio, addr) != (FIFO_U0 | FIFO_U1))
-			pr_err( "bad adb fifo reset!");
+			dev_err(vortex->card->dev, "bad adb fifo reset!");
 		vortex_fifo_clearadbdata(vortex, x, FIFO_SIZE);
 		addr -= 4;
 	}
@@ -1053,9 +1054,9 @@ static void vortex_fifo_init(vortex_t * vortex)
 	for (x = NR_WT - 1; x >= 0; x--) {
 		hwwrite(vortex->mmio, addr, FIFO_U0);
 		if (hwread(vortex->mmio, addr) != FIFO_U0)
-			pr_err(
-			       "bad wt fifo reset (0x%08x, 0x%08x)!\n",
-			       addr, hwread(vortex->mmio, addr));
+			dev_err(vortex->card->dev,
+				"bad wt fifo reset (0x%08x, 0x%08x)!\n",
+				addr, hwread(vortex->mmio, addr));
 		vortex_fifo_clearwtdata(vortex, x, FIFO_SIZE);
 		addr -= 4;
 	}
@@ -1213,8 +1214,9 @@ static int vortex_adbdma_bufshift(vortex_t * vortex, int adbdma)
 	if (dma->period_virt >= dma->nr_periods)
 		dma->period_virt -= dma->nr_periods;
 	if (delta != 1)
-		pr_info( "vortex: %d virt=%d, real=%d, delta=%d\n",
-		       adbdma, dma->period_virt, dma->period_real, delta);
+		dev_info(vortex->card->dev,
+			 "%d virt=%d, real=%d, delta=%d\n",
+			 adbdma, dma->period_virt, dma->period_real, delta);
 
 	return delta;
 }
@@ -1482,8 +1484,8 @@ static int vortex_wtdma_bufshift(vortex_t * vortex, int wtdma)
 	dma->period_real = page;
 
 	if (delta != 1)
-		pr_warn( "vortex: wt virt = %d, delta = %d\n",
-		       dma->period_virt, delta);
+		dev_warn(vortex->card->dev, "wt virt = %d, delta = %d\n",
+			 dma->period_virt, delta);
 
 	return delta;
 }
@@ -1667,9 +1669,9 @@ vortex_adb_addroutes(vortex_t * vortex, unsigned char channel,
 		    hwread(vortex->mmio,
 			   VORTEX_ADB_RTBASE + (temp << 2)) & ADB_MASK;
 		if ((lifeboat++) > ADB_MASK) {
-			pr_err(
-			       "vortex_adb_addroutes: unending route! 0x%x\n",
-			       *route);
+			dev_err(vortex->card->dev,
+				"vortex_adb_addroutes: unending route! 0x%x\n",
+				*route);
 			return;
 		}
 	}
@@ -1703,9 +1705,9 @@ vortex_adb_delroutes(vortex_t * vortex, unsigned char channel,
 		    hwread(vortex->mmio,
 			   VORTEX_ADB_RTBASE + (prev << 2)) & ADB_MASK;
 		if (((lifeboat++) > ADB_MASK) || (temp == ADB_MASK)) {
-			pr_err(
-			       "vortex_adb_delroutes: route not found! 0x%x\n",
-			       route0);
+			dev_err(vortex->card->dev,
+				"vortex_adb_delroutes: route not found! 0x%x\n",
+				route0);
 			return;
 		}
 	}
@@ -2045,7 +2047,9 @@ vortex_adb_checkinout(vortex_t * vortex, int resmap[], int out, int restype)
 			}
 		}
 	}
-	pr_err( "vortex: FATAL: ResManager: resource type %d exhausted.\n", restype);
+	dev_err(vortex->card->dev,
+		"FATAL: ResManager: resource type %d exhausted.\n",
+		restype);
 	return -ENOMEM;
 }
 
@@ -2173,7 +2177,8 @@ vortex_adb_allocroute(vortex_t *vortex, int dma, int nr_ch, int dir,
 				memset(stream->resources, 0,
 				       sizeof(unsigned char) *
 				       VORTEX_RESOURCE_LAST);
-				pr_err( "vortex: out of A3D sources. Sorry\n");
+				dev_err(vortex->card->dev,
+					"out of A3D sources. Sorry\n");
 				return -EBUSY;
 			}
 			/* (De)Initialize A3D hardware source. */
@@ -2422,7 +2427,7 @@ static irqreturn_t vortex_interrupt(int irq, void *dev_id)
 	hwread(vortex->mmio, VORTEX_IRQ_SOURCE);
 	// Is at least one IRQ flag set?
 	if (source == 0) {
-		pr_err( "vortex: missing irq source\n");
+		dev_err(vortex->card->dev, "missing irq source\n");
 		return IRQ_NONE;
 	}
 
@@ -2430,19 +2435,19 @@ static irqreturn_t vortex_interrupt(int irq, void *dev_id)
 	// Attend every interrupt source.
 	if (unlikely(source & IRQ_ERR_MASK)) {
 		if (source & IRQ_FATAL) {
-			pr_err( "vortex: IRQ fatal error\n");
+			dev_err(vortex->card->dev, "IRQ fatal error\n");
 		}
 		if (source & IRQ_PARITY) {
-			pr_err( "vortex: IRQ parity error\n");
+			dev_err(vortex->card->dev, "IRQ parity error\n");
 		}
 		if (source & IRQ_REG) {
-			pr_err( "vortex: IRQ reg error\n");
+			dev_err(vortex->card->dev, "IRQ reg error\n");
 		}
 		if (source & IRQ_FIFO) {
-			pr_err( "vortex: IRQ fifo error\n");
+			dev_err(vortex->card->dev, "IRQ fifo error\n");
 		}
 		if (source & IRQ_DMA) {
-			pr_err( "vortex: IRQ dma error\n");
+			dev_err(vortex->card->dev, "IRQ dma error\n");
 		}
 		handled = 1;
 	}
@@ -2490,7 +2495,7 @@ static irqreturn_t vortex_interrupt(int irq, void *dev_id)
 	}
 
 	if (!handled) {
-		pr_err( "vortex: unknown irq source %x\n", source);
+		dev_err(vortex->card->dev, "unknown irq source %x\n", source);
 	}
 	return IRQ_RETVAL(handled);
 }
@@ -2547,7 +2552,7 @@ vortex_codec_write(struct snd_ac97 * codec, unsigned short addr, unsigned short
 	while (!(hwread(card->mmio, VORTEX_CODEC_CTRL) & 0x100)) {
 		udelay(100);
 		if (lifeboat++ > POLL_COUNT) {
-			pr_err( "vortex: ac97 codec stuck busy\n");
+			dev_err(card->card->dev, "ac97 codec stuck busy\n");
 			return;
 		}
 	}
@@ -2573,7 +2578,7 @@ static unsigned short vortex_codec_read(struct snd_ac97 * codec, unsigned short
 	while (!(hwread(card->mmio, VORTEX_CODEC_CTRL) & 0x100)) {
 		udelay(100);
 		if (lifeboat++ > POLL_COUNT) {
-			pr_err( "vortex: ac97 codec stuck busy\n");
+			dev_err(card->card->dev, "ac97 codec stuck busy\n");
 			return 0xffff;
 		}
 	}
@@ -2587,7 +2592,8 @@ static unsigned short vortex_codec_read(struct snd_ac97 * codec, unsigned short
 		udelay(100);
 		data = hwread(card->mmio, VORTEX_CODEC_IO);
 		if (lifeboat++ > POLL_COUNT) {
-			pr_err( "vortex: ac97 address never arrived\n");
+			dev_err(card->card->dev,
+				"ac97 address never arrived\n");
 			return 0xffff;
 		}
 	} while ((data & VORTEX_CODEC_ADDMASK) !=
@@ -2684,7 +2690,7 @@ static void vortex_spdif_init(vortex_t * vortex, int spdif_sr, int spdif_mode)
 static int vortex_core_init(vortex_t *vortex)
 {
 
-	pr_info( "Vortex: init.... ");
+	dev_info(vortex->card->dev, "init started\n");
 	/* Hardware Init. */
 	hwwrite(vortex->mmio, VORTEX_CTRL, 0xffffffff);
 	msleep(5);
@@ -2729,7 +2735,7 @@ static int vortex_core_init(vortex_t *vortex)
 	//vortex_enable_timer_int(vortex);
 	//vortex_disable_timer_int(vortex);
 
-	pr_info( "done.\n");
+	dev_info(vortex->card->dev, "init.... done.\n");
 	spin_lock_init(&vortex->lock);
 
 	return 0;
@@ -2738,7 +2744,7 @@ static int vortex_core_init(vortex_t *vortex)
 static int vortex_core_shutdown(vortex_t * vortex)
 {
 
-	pr_info( "Vortex: shutdown...");
+	dev_info(vortex->card->dev, "shutdown started\n");
 #ifndef CHIP_AU8820
 	vortex_eq_free(vortex);
 	vortex_Vort3D_disable(vortex);
@@ -2760,7 +2766,7 @@ static int vortex_core_shutdown(vortex_t * vortex)
 	msleep(5);
 	hwwrite(vortex->mmio, VORTEX_IRQ_SOURCE, 0xffff);
 
-	pr_info( "done.\n");
+	dev_info(vortex->card->dev, "shutdown.... done.\n");
 	return 0;
 }
 
@@ -2794,7 +2800,8 @@ static int vortex_alsafmt_aspfmt(int alsafmt, vortex_t *v)
 		break;
 	default:
 		fmt = 0x8;
-		pr_err( "vortex: format unsupported %d\n", alsafmt);
+		dev_err(v->card->dev,
+			"format unsupported %d\n", alsafmt);
 		break;
 	}
 	return fmt;
diff --git a/sound/pci/au88x0/au88x0_eq.c b/sound/pci/au88x0/au88x0_eq.c
index 9404ba7..9585c5c 100644
--- a/sound/pci/au88x0/au88x0_eq.c
+++ b/sound/pci/au88x0/au88x0_eq.c
@@ -845,7 +845,8 @@ snd_vortex_peaks_get(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *u
 
 	vortex_Eqlzr_GetAllPeaks(vortex, peaks, &count);
 	if (count != 20) {
-		pr_err( "vortex: peak count error 20 != %d \n", count);
+		dev_err(vortex->card->dev,
+			"peak count error 20 != %d\n", count);
 		return -1;
 	}
 	for (i = 0; i < 20; i++)
diff --git a/sound/pci/au88x0/au88x0_game.c b/sound/pci/au88x0/au88x0_game.c
index 72daf6c..151815b 100644
--- a/sound/pci/au88x0/au88x0_game.c
+++ b/sound/pci/au88x0/au88x0_game.c
@@ -98,7 +98,8 @@ static int vortex_gameport_register(vortex_t *vortex)
 
 	vortex->gameport = gp = gameport_allocate_port();
 	if (!gp) {
-		pr_err( "vortex: cannot allocate memory for gameport\n");
+		dev_err(vortex->card->dev,
+			"cannot allocate memory for gameport\n");
 		return -ENOMEM;
 	}
 
diff --git a/sound/pci/au88x0/au88x0_mpu401.c b/sound/pci/au88x0/au88x0_mpu401.c
index 328c194..1025e55 100644
--- a/sound/pci/au88x0/au88x0_mpu401.c
+++ b/sound/pci/au88x0/au88x0_mpu401.c
@@ -73,7 +73,7 @@ static int snd_vortex_midi(vortex_t *vortex)
 	/* Check if anything is OK. */
 	temp = hwread(vortex->mmio, VORTEX_MIDI_DATA);
 	if (temp != MPU401_ACK /*0xfe */ ) {
-		pr_err( "midi port doesn't acknowledge!\n");
+		dev_err(vortex->card->dev, "midi port doesn't acknowledge!\n");
 		return -ENODEV;
 	}
 	/* Enable MPU401 interrupts. */
diff --git a/sound/pci/au88x0/au88x0_pcm.c b/sound/pci/au88x0/au88x0_pcm.c
index bdde182..a6d6d8d 100644
--- a/sound/pci/au88x0/au88x0_pcm.c
+++ b/sound/pci/au88x0/au88x0_pcm.c
@@ -227,7 +227,7 @@ snd_vortex_pcm_hw_params(struct snd_pcm_substream *substream,
 	err =
 	    snd_pcm_lib_malloc_pages(substream, params_buffer_bytes(hw_params));
 	if (err < 0) {
-		pr_err( "Vortex: pcm page alloc failed!\n");
+		dev_err(chip->card->dev, "Vortex: pcm page alloc failed!\n");
 		return err;
 	}
 	/*
@@ -371,7 +371,7 @@ static int snd_vortex_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 		}
 #ifndef CHIP_AU8810
 		else {
-			pr_info( "vortex: wt start %d\n", dma);
+			dev_info(chip->card->dev, "wt start %d\n", dma);
 			vortex_wtdma_startfifo(chip, dma);
 		}
 #endif
@@ -384,7 +384,7 @@ static int snd_vortex_pcm_trigger(struct snd_pcm_substream *substream, int cmd)
 			vortex_adbdma_stopfifo(chip, dma);
 #ifndef CHIP_AU8810
 		else {
-			pr_info( "vortex: wt stop %d\n", dma);
+			dev_info(chip->card->dev, "wt stop %d\n", dma);
 			vortex_wtdma_stopfifo(chip, dma);
 		}
 #endif
diff --git a/sound/pci/au88x0/au88x0_synth.c b/sound/pci/au88x0/au88x0_synth.c
index f094bac..78e12f4 100644
--- a/sound/pci/au88x0/au88x0_synth.c
+++ b/sound/pci/au88x0/au88x0_synth.c
@@ -90,7 +90,7 @@ static int vortex_wt_allocroute(vortex_t * vortex, int wt, int nr_ch)
 	hwwrite(vortex->mmio, WT_PARM(wt, 2), 0);
 
 	temp = hwread(vortex->mmio, WT_PARM(wt, 3));
-	pr_debug( "vortex: WT PARM3: %x\n", temp);
+	dev_dbg(vortex->card->dev, "WT PARM3: %x\n", temp);
 	//hwwrite(vortex->mmio, WT_PARM(wt, 3), temp);
 
 	hwwrite(vortex->mmio, WT_DELAY(wt, 0), 0);
@@ -98,7 +98,8 @@ static int vortex_wt_allocroute(vortex_t * vortex, int wt, int nr_ch)
 	hwwrite(vortex->mmio, WT_DELAY(wt, 2), 0);
 	hwwrite(vortex->mmio, WT_DELAY(wt, 3), 0);
 
-	pr_debug( "vortex: WT GMODE: %x\n", hwread(vortex->mmio, WT_GMODE(wt)));
+	dev_dbg(vortex->card->dev, "WT GMODE: %x\n",
+		hwread(vortex->mmio, WT_GMODE(wt)));
 
 	hwwrite(vortex->mmio, WT_PARM(wt, 2), 0xffffffff);
 	hwwrite(vortex->mmio, WT_PARM(wt, 3), 0xcff1c810);
@@ -106,7 +107,8 @@ static int vortex_wt_allocroute(vortex_t * vortex, int wt, int nr_ch)
 	voice->parm0 = voice->parm1 = 0xcfb23e2f;
 	hwwrite(vortex->mmio, WT_PARM(wt, 0), voice->parm0);
 	hwwrite(vortex->mmio, WT_PARM(wt, 1), voice->parm1);
-	pr_debug( "vortex: WT GMODE 2 : %x\n", hwread(vortex->mmio, WT_GMODE(wt)));
+	dev_dbg(vortex->card->dev, "WT GMODE 2 : %x\n",
+		hwread(vortex->mmio, WT_GMODE(wt)));
 	return 0;
 }
 
@@ -196,14 +198,15 @@ vortex_wt_SetReg(vortex_t * vortex, unsigned char reg, int wt,
 
 	if ((reg == 5) || ((reg >= 7) && (reg <= 10)) || (reg == 0xc)) {
 		if (wt >= (NR_WT / NR_WT_PB)) {
-			pr_warn
-			    ("vortex: WT SetReg: bank out of range. reg=0x%x, wt=%d\n",
-			     reg, wt);
+			dev_warn(vortex->card->dev,
+				 "WT SetReg: bank out of range. reg=0x%x, wt=%d\n",
+				 reg, wt);
 			return 0;
 		}
 	} else {
 		if (wt >= NR_WT) {
-			pr_err( "vortex: WT SetReg: voice out of range\n");
+			dev_err(vortex->card->dev,
+				"WT SetReg: voice out of range\n");
 			return 0;
 		}
 	}
-- 
1.8.1.2

