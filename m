Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbaHSQmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 12:42:11 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37137 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbaHSQmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 12:42:08 -0400
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Takashi Iwai <tiwai@suse.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/2] SOUND: kill gameport bits
Date: Tue, 19 Aug 2014 09:41:36 -0700
Message-Id: <1408466497-25640-1-git-send-email-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gameport support hasn't been working well ever since cpufreq became
mainstream and it becomes increasingly hard to find hardware and software
that would run on such old hardware.

This patch deletes support of gamecon interfaces from sound cards in
preparation of gamecon subsystem removal.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

Takashi,

If you are OK with the patch I'd like to queue it in my queue for 3.18 together
with the patch that removes gameport completely.

Thanks!

 include/sound/core.h             |   7 --
 sound/isa/cmi8328.c              |  49 +-------
 sound/isa/sc6000.c               |   9 +-
 sound/isa/sscape.c               |   6 -
 sound/pci/als4000.c              |  89 ---------------
 sound/pci/au88x0/au8810.c        |   1 -
 sound/pci/au88x0/au88x0.c        |   5 -
 sound/pci/au88x0/au88x0.h        |   5 -
 sound/pci/au88x0/au88x0_game.c   | 133 ----------------------
 sound/pci/azt3328.c              | 238 +--------------------------------------
 sound/pci/cmipci.c               |  84 +-------------
 sound/pci/cs4281.c               | 114 -------------------
 sound/pci/cs46xx/cs46xx.c        |   2 -
 sound/pci/cs46xx/cs46xx.h        |   4 -
 sound/pci/cs46xx/cs46xx_lib.c    | 105 -----------------
 sound/pci/ens1370.c              | 129 ---------------------
 sound/pci/es1938.c               |  46 --------
 sound/pci/es1968.c               |  72 ------------
 sound/pci/riptide/riptide.c      | 109 +-----------------
 sound/pci/sonicvibes.c           |  55 ---------
 sound/pci/trident/trident.c      |   2 -
 sound/pci/trident/trident.h      |   3 -
 sound/pci/trident/trident_main.c | 103 -----------------
 sound/pci/via82xx.c              |  77 -------------
 sound/pci/ymfpci/ymfpci.c        |  99 ----------------
 sound/pci/ymfpci/ymfpci.h        |   9 --
 sound/pci/ymfpci/ymfpci_main.c   |   1 -
 27 files changed, 8 insertions(+), 1548 deletions(-)
 delete mode 100644 sound/pci/au88x0/au88x0_game.c

diff --git a/include/sound/core.h b/include/sound/core.h
index 1df3f2f..3f087e1 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -421,13 +421,6 @@ static inline void snd_printdd(const char *format, ...) {}
 
 #define SNDRV_OSS_VERSION         ((3<<16)|(8<<8)|(1<<4)|(0))	/* 3.8.1a */
 
-/* for easier backward-porting */
-#if defined(CONFIG_GAMEPORT) || defined(CONFIG_GAMEPORT_MODULE)
-#define gameport_set_dev_parent(gp,xdev) ((gp)->dev.parent = (xdev))
-#define gameport_set_port_data(gp,r) ((gp)->port_data = (r))
-#define gameport_get_port_data(gp) (gp)->port_data
-#endif
-
 /* PCI quirk list helper */
 struct snd_pci_quirk {
 	unsigned short subvendor;	/* PCI subvendor ID */
diff --git a/sound/isa/cmi8328.c b/sound/isa/cmi8328.c
index 4778852..ac60f04 100644
--- a/sound/isa/cmi8328.c
+++ b/sound/isa/cmi8328.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/isa.h>
 #include <linux/module.h>
-#include <linux/gameport.h>
 #include <asm/dma.h>
 #include <sound/core.h>
 #include <sound/wss.h>
@@ -26,10 +25,6 @@ MODULE_AUTHOR("Ondrej Zary <linux@rainbow-software.org>");
 MODULE_DESCRIPTION("C-Media CMI8328");
 MODULE_LICENSE("GPL");
 
-#if defined(CONFIG_GAMEPORT) || defined(CONFIG_GAMEPORT_MODULE)
-#define SUPPORT_JOYSTICK 1
-#endif
-
 /* I/O port is configured by jumpers on the card to one of these */
 static int cmi8328_ports[] = { 0x530, 0xe80, 0xf40, 0x604 };
 #define CMI8328_MAX	ARRAY_SIZE(cmi8328_ports)
@@ -42,9 +37,6 @@ static int dma1[CMI8328_MAX] =      {[0 ... (CMI8328_MAX-1)] = SNDRV_AUTO_DMA};
 static int dma2[CMI8328_MAX] =      {[0 ... (CMI8328_MAX-1)] = SNDRV_AUTO_DMA};
 static long mpuport[CMI8328_MAX] =  {[0 ... (CMI8328_MAX-1)] = SNDRV_AUTO_PORT};
 static int mpuirq[CMI8328_MAX] =    {[0 ... (CMI8328_MAX-1)] = SNDRV_AUTO_IRQ};
-#ifdef SUPPORT_JOYSTICK
-static bool gameport[CMI8328_MAX] = {[0 ... (CMI8328_MAX-1)] = true};
-#endif
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for CMI8328 soundcard.");
@@ -64,10 +56,6 @@ module_param_array(mpuport, long, NULL, 0444);
 MODULE_PARM_DESC(mpuport, "MPU-401 port # for CMI8328 driver.");
 module_param_array(mpuirq, int, NULL, 0444);
 MODULE_PARM_DESC(mpuirq, "IRQ # for CMI8328 MPU-401 port.");
-#ifdef SUPPORT_JOYSTICK
-module_param_array(gameport, bool, NULL, 0444);
-MODULE_PARM_DESC(gameport, "Enable gameport.");
-#endif
 
 struct snd_cmi8328 {
 	u16 port;
@@ -75,9 +63,6 @@ struct snd_cmi8328 {
 	u8 wss_cfg;
 	struct snd_card *card;
 	struct snd_wss *wss;
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
 };
 
 /* CMI8328 configuration registers */
@@ -371,34 +356,11 @@ static int snd_cmi8328_probe(struct device *pdev, unsigned int ndev)
 	err = snd_card_register(card);
 	if (err < 0)
 		goto error;
-#ifdef SUPPORT_JOYSTICK
-	if (!gameport[ndev])
-		return 0;
-	/* gameport is hardwired to 0x200 */
-	res = request_region(0x200, 8, "CMI8328 gameport");
-	if (!res)
-		snd_printk(KERN_WARNING "unable to allocate gameport I/O port\n");
-	else {
-		struct gameport *gp = cmi->gameport = gameport_allocate_port();
-		if (!cmi->gameport)
-			release_and_free_resource(res);
-		else {
-			gameport_set_name(gp, "CMI8328 Gameport");
-			gameport_set_phys(gp, "%s/gameport0", dev_name(pdev));
-			gameport_set_dev_parent(gp, pdev);
-			gp->io = 0x200;
-			gameport_set_port_data(gp, res);
-			/* Enable gameport */
-			snd_cmi8328_cfg_write(port, CFG1,
-					CFG1_SB_DISABLE | CFG1_GAMEPORT);
-			gameport_register_port(gp);
-		}
-	}
-#endif
+
 	return 0;
+
 error:
 	snd_card_free(card);
-
 	return err;
 }
 
@@ -407,13 +369,6 @@ static int snd_cmi8328_remove(struct device *pdev, unsigned int dev)
 	struct snd_card *card = dev_get_drvdata(pdev);
 	struct snd_cmi8328 *cmi = card->private_data;
 
-#ifdef SUPPORT_JOYSTICK
-	if (cmi->gameport) {
-		struct resource *res = gameport_get_port_data(cmi->gameport);
-		gameport_unregister_port(cmi->gameport);
-		release_and_free_resource(res);
-	}
-#endif
 	/* disable everything */
 	snd_cmi8328_cfg_write(cmi->port, CFG1, CFG1_SB_DISABLE);
 	snd_cmi8328_cfg_write(cmi->port, CFG2, 0);
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 15a152e..05d3e81 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -56,7 +56,6 @@ static long mpu_port[SNDRV_CARDS] = SNDRV_DEFAULT_PORT;
 						/* 0x300, 0x310, 0x320, 0x330 */
 static int mpu_irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;	/* 5, 7, 9, 10, 0 */
 static int dma[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;	/* 0, 1, 3 */
-static bool joystick[SNDRV_CARDS] = { [0 ... (SNDRV_CARDS-1)] = false };
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for sc-6000 based soundcard.");
@@ -76,8 +75,6 @@ module_param_array(mpu_irq, int, NULL, 0444);
 MODULE_PARM_DESC(mpu_irq, "MPU-401 IRQ # for sc-6000 driver.");
 module_param_array(dma, int, NULL, 0444);
 MODULE_PARM_DESC(dma, "DMA # for sc-6000 driver.");
-module_param_array(joystick, bool, NULL, 0444);
-MODULE_PARM_DESC(joystick, "Enable gameport.");
 
 /*
  * Commands of SC6000's DSP (SBPRO+special).
@@ -366,7 +363,7 @@ static int sc6000_init_mss(char __iomem *vport, int config,
 
 static void sc6000_hw_cfg_encode(char __iomem *vport, int *cfg,
 				 long xport, long xmpu,
-				 long xmss_port, int joystick)
+				 long xmss_port)
 {
 	cfg[0] = 0;
 	cfg[1] = 0;
@@ -379,8 +376,6 @@ static void sc6000_hw_cfg_encode(char __iomem *vport, int *cfg,
 	if (xmss_port == 0xe80)
 		cfg[0] |= 0x10;
 	cfg[0] |= 0x40;		/* always set */
-	if (!joystick)
-		cfg[0] |= 0x02;
 	cfg[1] |= 0x80;		/* enable WSS system */
 	cfg[1] &= ~0x40;	/* disable IDE */
 	snd_printd("hw cfg %x, %x\n", cfg[0], cfg[1]);
@@ -432,7 +427,7 @@ static int sc6000_init_board(char __iomem *vport,
 	if (!old) {
 		int cfg[2];
 		sc6000_hw_cfg_encode(vport, &cfg[0], port[dev], mpu_port[dev],
-				     mss_port[dev], joystick[dev]);
+				     mss_port[dev]);
 		if (sc6000_hw_cfg_write(vport, cfg) < 0) {
 			snd_printk(KERN_ERR "sc6000_hw_cfg_write: failed!\n");
 			return -EIO;
diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index 44405df..dd21079 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -54,7 +54,6 @@ static int irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;
 static int mpu_irq[SNDRV_CARDS] = SNDRV_DEFAULT_IRQ;
 static int dma[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;
 static int dma2[SNDRV_CARDS] = SNDRV_DEFAULT_DMA;
-static bool joystick[SNDRV_CARDS];
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index number for SoundScape soundcard");
@@ -80,9 +79,6 @@ MODULE_PARM_DESC(dma, "DMA # for SoundScape driver.");
 module_param_array(dma2, int, NULL, 0444);
 MODULE_PARM_DESC(dma2, "DMA2 # for SoundScape driver.");
 
-module_param_array(joystick, bool, NULL, 0444);
-MODULE_PARM_DESC(joystick, "Enable gameport.");
-
 #ifdef CONFIG_PNP
 static int isa_registered;
 static int pnp_registered;
@@ -1049,8 +1045,6 @@ static int create_sscape(int dev, struct snd_card *card)
 
 	mpu_irq_cfg |= mpu_irq_cfg << 2;
 	val = sscape_read_unsafe(sscape->io_base, GA_HMCTL_REG) & 0xF7;
-	if (joystick[dev])
-		val |= 8;
 	sscape_write_unsafe(sscape->io_base, GA_HMCTL_REG, val | 0x10);
 	sscape_write_unsafe(sscape->io_base, GA_INTCFG_REG, 0xf0 | mpu_irq_cfg);
 	sscape_write_unsafe(sscape->io_base,
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index b751c38..567fbf9 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -68,7 +68,6 @@
 #include <asm/io.h>
 #include <linux/init.h>
 #include <linux/pci.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <sound/core.h>
@@ -84,16 +83,9 @@ MODULE_DESCRIPTION("Avance Logic ALS4000");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Avance Logic,ALS4000}}");
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK 1
-#endif
-
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
-#ifdef SUPPORT_JOYSTICK
-static int joystick_port[SNDRV_CARDS];
-#endif
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for ALS4000 soundcard.");
@@ -101,19 +93,12 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for ALS4000 soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable ALS4000 soundcard.");
-#ifdef SUPPORT_JOYSTICK
-module_param_array(joystick_port, int, NULL, 0444);
-MODULE_PARM_DESC(joystick_port, "Joystick port address for ALS4000 soundcard. (0 = disabled)");
-#endif
 
 struct snd_card_als4000 {
 	/* most frequent access first */
 	unsigned long iobase;
 	struct pci_dev *pci;
 	struct snd_sb *chip;
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
 };
 
 static DEFINE_PCI_DEVICE_TABLE(snd_als4000_ids) = {
@@ -769,72 +754,6 @@ static void snd_als4000_configure(struct snd_sb *chip)
 	spin_unlock_irq(&chip->reg_lock);
 }
 
-#ifdef SUPPORT_JOYSTICK
-static int snd_als4000_create_gameport(struct snd_card_als4000 *acard, int dev)
-{
-	struct gameport *gp;
-	struct resource *r;
-	int io_port;
-
-	if (joystick_port[dev] == 0)
-		return -ENODEV;
-
-	if (joystick_port[dev] == 1) { /* auto-detect */
-		for (io_port = 0x200; io_port <= 0x218; io_port += 8) {
-			r = request_region(io_port, 8, "ALS4000 gameport");
-			if (r)
-				break;
-		}
-	} else {
-		io_port = joystick_port[dev];
-		r = request_region(io_port, 8, "ALS4000 gameport");
-	}
-
-	if (!r) {
-		dev_warn(&acard->pci->dev, "cannot reserve joystick ports\n");
-		return -EBUSY;
-	}
-
-	acard->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(&acard->pci->dev, "cannot allocate memory for gameport\n");
-		release_and_free_resource(r);
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "ALS4000 Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(acard->pci));
-	gameport_set_dev_parent(gp, &acard->pci->dev);
-	gp->io = io_port;
-	gameport_set_port_data(gp, r);
-
-	/* Enable legacy joystick port */
-	snd_als4000_set_addr(acard->iobase, 0, 0, 0, 1);
-
-	gameport_register_port(acard->gameport);
-
-	return 0;
-}
-
-static void snd_als4000_free_gameport(struct snd_card_als4000 *acard)
-{
-	if (acard->gameport) {
-		struct resource *r = gameport_get_port_data(acard->gameport);
-
-		gameport_unregister_port(acard->gameport);
-		acard->gameport = NULL;
-
-		/* disable joystick */
-		snd_als4000_set_addr(acard->iobase, 0, 0, 0, 0);
-
-		release_and_free_resource(r);
-	}
-}
-#else
-static inline int snd_als4000_create_gameport(struct snd_card_als4000 *acard, int dev) { return -ENOSYS; }
-static inline void snd_als4000_free_gameport(struct snd_card_als4000 *acard) { }
-#endif
-
 static void snd_card_als4000_free( struct snd_card *card )
 {
 	struct snd_card_als4000 *acard = card->private_data;
@@ -842,7 +761,6 @@ static void snd_card_als4000_free( struct snd_card *card )
 	/* make sure that interrupts are disabled */
 	snd_als4k_gcr_write_addr(acard->iobase, ALS4K_GCR8C_MISC_CTRL, 0);
 	/* free resources */
-	snd_als4000_free_gameport(acard);
 	pci_release_regions(acard->pci);
 	pci_disable_device(acard->pci);
 }
@@ -963,8 +881,6 @@ static int snd_card_als4000_probe(struct pci_dev *pci,
 		}
 	}
 
-	snd_als4000_create_gameport(acard, dev);
-
 	if ((err = snd_card_register(card)) < 0) {
 		goto out_err;
 	}
@@ -1024,11 +940,6 @@ static int snd_als4000_resume(struct device *dev)
 	snd_sbdsp_reset(chip);
 	snd_sbmixer_resume(chip);
 
-#ifdef SUPPORT_JOYSTICK
-	if (acard->gameport)
-		snd_als4000_set_addr(acard->iobase, 0, 0, 0, 1);
-#endif
-
 	snd_power_change_state(card, SNDRV_CTL_POWER_D0);
 	return 0;
 }
diff --git a/sound/pci/au88x0/au8810.c b/sound/pci/au88x0/au8810.c
index aa51cc7..394c847 100644
--- a/sound/pci/au88x0/au8810.c
+++ b/sound/pci/au88x0/au8810.c
@@ -9,7 +9,6 @@ static DEFINE_PCI_DEVICE_TABLE(snd_vortex_ids) = {
 #include "au88x0_pcm.c"
 #include "au88x0_mixer.c"
 #include "au88x0_mpu401.c"
-#include "au88x0_game.c"
 #include "au88x0_eq.c"
 #include "au88x0_a3d.c"
 #include "au88x0_xtalk.c"
diff --git a/sound/pci/au88x0/au88x0.c b/sound/pci/au88x0/au88x0.c
index afb1b44..208ead1 100644
--- a/sound/pci/au88x0/au88x0.c
+++ b/sound/pci/au88x0/au88x0.c
@@ -123,7 +123,6 @@ static int snd_vortex_dev_free(struct snd_device *device)
 {
 	vortex_t *vortex = device->device_data;
 
-	vortex_gameport_unregister(vortex);
 	vortex_core_shutdown(vortex);
 	// Take down PCI interface.
 	free_irq(vortex->irq, vortex);
@@ -225,8 +224,6 @@ snd_vortex_create(struct snd_card *card, struct pci_dev *pci, vortex_t ** rchip)
 	pci_release_regions(chip->pci_dev);
       regions_out:
 	pci_disable_device(chip->pci_dev);
-	//FIXME: this not the right place to unregister the gameport
-	vortex_gameport_unregister(chip);
 	kfree(chip);
 	return err;
 }
@@ -309,8 +306,6 @@ snd_vortex_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 		return err;
 	}
 
-	vortex_gameport_register(chip);
-
 #if 0
 	if (snd_seq_device_new(card, 1, SNDRV_SEQ_DEV_ID_VORTEX_SYNTH,
 			       sizeof(snd_vortex_synth_arg_t), &wave) < 0
diff --git a/sound/pci/au88x0/au88x0.h b/sound/pci/au88x0/au88x0.h
index 466a5c8..69cd47e 100644
--- a/sound/pci/au88x0/au88x0.h
+++ b/sound/pci/au88x0/au88x0.h
@@ -180,9 +180,6 @@ struct snd_vortex {
 
 	int isquad;		/* cache of extended ID codec flag. */
 
-	/* Gameport stuff. */
-	struct gameport *gameport;
-
 	/* PCI hardware resources */
 	unsigned long io;
 	void __iomem *mmio;
@@ -282,8 +279,6 @@ static void vortex_Vort3D_InitializeSource(a3dsrc_t * a, int en);
 #endif
 
 /* Driver stuff. */
-static int vortex_gameport_register(vortex_t * card);
-static void vortex_gameport_unregister(vortex_t * card);
 #ifndef CHIP_AU8820
 static int vortex_eq_init(vortex_t * vortex);
 static int vortex_eq_free(vortex_t * vortex);
diff --git a/sound/pci/au88x0/au88x0_game.c b/sound/pci/au88x0/au88x0_game.c
deleted file mode 100644
index 280f86d..0000000
--- a/sound/pci/au88x0/au88x0_game.c
+++ /dev/null
@@ -1,133 +0,0 @@
-/*
- *  Manuel Jander.
- *
- *  Based on the work of:
- *  Vojtech Pavlik
- *  Raymond Ingles
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
- *
- * Should you need to contact me, the author, you can do so either by
- * e-mail - mail your message to <vojtech@suse.cz>, or by paper mail:
- * Vojtech Pavlik, Ucitelska 1576, Prague 8, 182 00 Czech Republic
- *
- * Based 90% on Vojtech Pavlik pcigame driver.
- * Merged and modified by Manuel Jander, for the OpenVortex
- * driver. (email: mjander@embedded.cl).
- */
-
-#include <linux/time.h>
-#include <linux/delay.h>
-#include <linux/init.h>
-#include <sound/core.h>
-#include "au88x0.h"
-#include <linux/gameport.h>
-#include <linux/export.h>
-
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-
-#define VORTEX_GAME_DWAIT	20	/* 20 ms */
-
-static unsigned char vortex_game_read(struct gameport *gameport)
-{
-	vortex_t *vortex = gameport_get_port_data(gameport);
-	return hwread(vortex->mmio, VORTEX_GAME_LEGACY);
-}
-
-static void vortex_game_trigger(struct gameport *gameport)
-{
-	vortex_t *vortex = gameport_get_port_data(gameport);
-	hwwrite(vortex->mmio, VORTEX_GAME_LEGACY, 0xff);
-}
-
-static int
-vortex_game_cooked_read(struct gameport *gameport, int *axes, int *buttons)
-{
-	vortex_t *vortex = gameport_get_port_data(gameport);
-	int i;
-
-	*buttons = (~hwread(vortex->mmio, VORTEX_GAME_LEGACY) >> 4) & 0xf;
-
-	for (i = 0; i < 4; i++) {
-		axes[i] =
-		    hwread(vortex->mmio, VORTEX_GAME_AXIS + (i * AXIS_SIZE));
-		if (axes[i] == AXIS_RANGE)
-			axes[i] = -1;
-	}
-	return 0;
-}
-
-static int vortex_game_open(struct gameport *gameport, int mode)
-{
-	vortex_t *vortex = gameport_get_port_data(gameport);
-
-	switch (mode) {
-	case GAMEPORT_MODE_COOKED:
-		hwwrite(vortex->mmio, VORTEX_CTRL2,
-			hwread(vortex->mmio,
-			       VORTEX_CTRL2) | CTRL2_GAME_ADCMODE);
-		msleep(VORTEX_GAME_DWAIT);
-		return 0;
-	case GAMEPORT_MODE_RAW:
-		hwwrite(vortex->mmio, VORTEX_CTRL2,
-			hwread(vortex->mmio,
-			       VORTEX_CTRL2) & ~CTRL2_GAME_ADCMODE);
-		return 0;
-	default:
-		return -1;
-	}
-
-	return 0;
-}
-
-static int vortex_gameport_register(vortex_t *vortex)
-{
-	struct gameport *gp;
-
-	vortex->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		printk(KERN_ERR "vortex: cannot allocate memory for gameport\n");
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "AU88x0 Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(vortex->pci_dev));
-	gameport_set_dev_parent(gp, &vortex->pci_dev->dev);
-
-	gp->read = vortex_game_read;
-	gp->trigger = vortex_game_trigger;
-	gp->cooked_read = vortex_game_cooked_read;
-	gp->open = vortex_game_open;
-
-	gameport_set_port_data(gp, vortex);
-	gp->fuzz = 64;
-
-	gameport_register_port(gp);
-
-	return 0;
-}
-
-static void vortex_gameport_unregister(vortex_t * vortex)
-{
-	if (vortex->gameport) {
-		gameport_unregister_port(vortex->gameport);
-		vortex->gameport = NULL;
-	}
-}
-
-#else
-static inline int vortex_gameport_register(vortex_t * vortex) { return -ENOSYS; }
-static inline void vortex_gameport_unregister(vortex_t * vortex) { }
-#endif
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index c9216c0..0fee67e 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -156,9 +156,6 @@
  *    (e.g. kmix, gamix) - unfortunately several are!!
  *  - locking is not entirely clean, especially the audio stream activity
  *    ints --> may be racy
- *  - an _unconnected_ secondary joystick at the gameport will be reported
- *    to be "active" (floating values, not precisely -1) due to the way we need
- *    to read the Digital Enhanced Game Port. Not sure whether it is fixable.
  *
  * TODO
  *  - use PCI_VDEVICE
@@ -185,7 +182,6 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 #include <sound/core.h>
@@ -212,10 +208,6 @@ MODULE_DESCRIPTION("Aztech AZF3328 (PCI168)");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Aztech,AZF3328}}");
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_GAMEPORT 1
-#endif
-
 /* === Debug settings ===
   Further diagnostic functionality than the settings below
   does not need to be provided, since one can easily write a POSIX shell script
@@ -296,11 +288,6 @@ struct snd_azf3328 {
 	struct snd_card *card;
 	struct snd_rawmidi *rmidi;
 
-#ifdef SUPPORT_GAMEPORT
-	struct gameport *gameport;
-	u16 axes[4];
-#endif
-
 	struct pci_dev *pci;
 	int irq;
 
@@ -1661,226 +1648,6 @@ snd_azf3328_pcm_pointer(struct snd_pcm_substream *substream
 
 /******************************************************************/
 
-#ifdef SUPPORT_GAMEPORT
-static inline void
-snd_azf3328_gameport_irq_enable(struct snd_azf3328 *chip,
-				bool enable
-)
-{
-	snd_azf3328_io_reg_setb(
-		chip->game_io+IDX_GAME_HWCONFIG,
-		GAME_HWCFG_IRQ_ENABLE,
-		enable
-	);
-}
-
-static inline void
-snd_azf3328_gameport_legacy_address_enable(struct snd_azf3328 *chip,
-					   bool enable
-)
-{
-	snd_azf3328_io_reg_setb(
-		chip->game_io+IDX_GAME_HWCONFIG,
-		GAME_HWCFG_LEGACY_ADDRESS_ENABLE,
-		enable
-	);
-}
-
-static void
-snd_azf3328_gameport_set_counter_frequency(struct snd_azf3328 *chip,
-					   unsigned int freq_cfg
-)
-{
-	snd_azf3328_io_reg_setb(
-		chip->game_io+IDX_GAME_HWCONFIG,
-		0x02,
-		(freq_cfg & 1) != 0
-	);
-	snd_azf3328_io_reg_setb(
-		chip->game_io+IDX_GAME_HWCONFIG,
-		0x04,
-		(freq_cfg & 2) != 0
-	);
-}
-
-static inline void
-snd_azf3328_gameport_axis_circuit_enable(struct snd_azf3328 *chip, bool enable)
-{
-	snd_azf3328_ctrl_reg_6AH_update(
-		chip, IO_6A_SOMETHING2_GAMEPORT, enable
-	);
-}
-
-static inline void
-snd_azf3328_gameport_interrupt(struct snd_azf3328 *chip)
-{
-	/*
-	 * skeleton handler only
-	 * (we do not want axis reading in interrupt handler - too much load!)
-	 */
-	dev_dbg(chip->card->dev, "gameport irq\n");
-
-	 /* this should ACK the gameport IRQ properly, hopefully. */
-	snd_azf3328_game_inw(chip, IDX_GAME_AXIS_VALUE);
-}
-
-static int
-snd_azf3328_gameport_open(struct gameport *gameport, int mode)
-{
-	struct snd_azf3328 *chip = gameport_get_port_data(gameport);
-	int res;
-
-	dev_dbg(chip->card->dev, "gameport_open, mode %d\n", mode);
-	switch (mode) {
-	case GAMEPORT_MODE_COOKED:
-	case GAMEPORT_MODE_RAW:
-		res = 0;
-		break;
-	default:
-		res = -1;
-		break;
-	}
-
-	snd_azf3328_gameport_set_counter_frequency(chip,
-				GAME_HWCFG_ADC_COUNTER_FREQ_STD);
-	snd_azf3328_gameport_axis_circuit_enable(chip, (res == 0));
-
-	return res;
-}
-
-static void
-snd_azf3328_gameport_close(struct gameport *gameport)
-{
-	struct snd_azf3328 *chip = gameport_get_port_data(gameport);
-
-	dev_dbg(chip->card->dev, "gameport_close\n");
-	snd_azf3328_gameport_set_counter_frequency(chip,
-				GAME_HWCFG_ADC_COUNTER_FREQ_1_200);
-	snd_azf3328_gameport_axis_circuit_enable(chip, 0);
-}
-
-static int
-snd_azf3328_gameport_cooked_read(struct gameport *gameport,
-				 int *axes,
-				 int *buttons
-)
-{
-	struct snd_azf3328 *chip = gameport_get_port_data(gameport);
-	int i;
-	u8 val;
-	unsigned long flags;
-
-	if (snd_BUG_ON(!chip))
-		return 0;
-
-	spin_lock_irqsave(&chip->reg_lock, flags);
-	val = snd_azf3328_game_inb(chip, IDX_GAME_LEGACY_COMPATIBLE);
-	*buttons = (~(val) >> 4) & 0xf;
-
-	/* ok, this one is a bit dirty: cooked_read is being polled by a timer,
-	 * thus we're atomic and cannot actively wait in here
-	 * (which would be useful for us since it probably would be better
-	 * to trigger a measurement in here, then wait a short amount of
-	 * time until it's finished, then read values of _this_ measurement).
-	 *
-	 * Thus we simply resort to reading values if they're available already
-	 * and trigger the next measurement.
-	 */
-
-	val = snd_azf3328_game_inb(chip, IDX_GAME_AXES_CONFIG);
-	if (val & GAME_AXES_SAMPLING_READY) {
-		for (i = 0; i < ARRAY_SIZE(chip->axes); ++i) {
-			/* configure the axis to read */
-			val = (i << 4) | 0x0f;
-			snd_azf3328_game_outb(chip, IDX_GAME_AXES_CONFIG, val);
-
-			chip->axes[i] = snd_azf3328_game_inw(
-						chip, IDX_GAME_AXIS_VALUE
-					);
-		}
-	}
-
-	/* trigger next sampling of axes, to be evaluated the next time we
-	 * enter this function */
-
-	/* for some very, very strange reason we cannot enable
-	 * Measurement Ready monitoring for all axes here,
-	 * at least not when only one joystick connected */
-	val = 0x03; /* we're able to monitor axes 1 and 2 only */
-	snd_azf3328_game_outb(chip, IDX_GAME_AXES_CONFIG, val);
-
-	snd_azf3328_game_outw(chip, IDX_GAME_AXIS_VALUE, 0xffff);
-	spin_unlock_irqrestore(&chip->reg_lock, flags);
-
-	for (i = 0; i < ARRAY_SIZE(chip->axes); i++) {
-		axes[i] = chip->axes[i];
-		if (axes[i] == 0xffff)
-			axes[i] = -1;
-	}
-
-	dev_dbg(chip->card->dev, "cooked_read: axes %d %d %d %d buttons %d\n",
-		axes[0], axes[1], axes[2], axes[3], *buttons);
-
-	return 0;
-}
-
-static int
-snd_azf3328_gameport(struct snd_azf3328 *chip, int dev)
-{
-	struct gameport *gp;
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev, "cannot alloc memory for gameport\n");
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "AZF3328 Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-	gp->io = chip->game_io;
-	gameport_set_port_data(gp, chip);
-
-	gp->open = snd_azf3328_gameport_open;
-	gp->close = snd_azf3328_gameport_close;
-	gp->fuzz = 16; /* seems ok */
-	gp->cooked_read = snd_azf3328_gameport_cooked_read;
-
-	/* DISABLE legacy address: we don't need it! */
-	snd_azf3328_gameport_legacy_address_enable(chip, 0);
-
-	snd_azf3328_gameport_set_counter_frequency(chip,
-				GAME_HWCFG_ADC_COUNTER_FREQ_1_200);
-	snd_azf3328_gameport_axis_circuit_enable(chip, 0);
-
-	gameport_register_port(chip->gameport);
-
-	return 0;
-}
-
-static void
-snd_azf3328_gameport_free(struct snd_azf3328 *chip)
-{
-	if (chip->gameport) {
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-	}
-	snd_azf3328_gameport_irq_enable(chip, 0);
-}
-#else
-static inline int
-snd_azf3328_gameport(struct snd_azf3328 *chip, int dev) { return -ENOSYS; }
-static inline void
-snd_azf3328_gameport_free(struct snd_azf3328 *chip) { }
-static inline void
-snd_azf3328_gameport_interrupt(struct snd_azf3328 *chip)
-{
-	dev_warn(chip->card->dev, "huh, game port IRQ occurred!?\n");
-}
-#endif /* SUPPORT_GAMEPORT */
-
-/******************************************************************/
-
 static inline void
 snd_azf3328_irq_log_unknown_type(struct snd_azf3328 *chip, u8 which)
 {
@@ -1966,7 +1733,7 @@ snd_azf3328_interrupt(int irq, void *dev_id)
 		snd_azf3328_pcm_interrupt(chip, chip->codecs, status);
 
 	if (status & IRQ_GAMEPORT)
-		snd_azf3328_gameport_interrupt(chip);
+		dev_warn(chip->card->dev, "huh, game port IRQ occurred!?\n");
 
 	/* MPU401 has less critical IRQ requirements
 	 * than timer and playback/recording, right? */
@@ -2296,7 +2063,6 @@ snd_azf3328_free(struct snd_azf3328 *chip)
 	snd_azf3328_mixer_reset(chip);
 
 	snd_azf3328_timer_stop(chip->timer);
-	snd_azf3328_gameport_free(chip);
 
 	if (chip->irq >= 0)
 		synchronize_irq(chip->irq);
@@ -2607,8 +2373,6 @@ snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 		 1024000 / seqtimer_scaling, seqtimer_scaling);
 #endif
 
-	snd_azf3328_gameport(chip, dev);
-
 	pci_set_drvdata(pci, card);
 	dev++;
 
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 12c318e..023a9d2 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <sound/core.h>
@@ -48,19 +47,12 @@ MODULE_SUPPORTED_DEVICE("{{C-Media,CMI8738},"
 		"{C-Media,CMI8338A},"
 		"{C-Media,CMI8338B}}");
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK 1
-#endif
-
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
 static long mpu_port[SNDRV_CARDS];
 static long fm_port[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)]=1};
 static bool soft_ac3[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS-1)]=1};
-#ifdef SUPPORT_JOYSTICK
-static int joystick_port[SNDRV_CARDS];
-#endif
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for C-Media PCI soundcard.");
@@ -74,10 +66,6 @@ module_param_array(fm_port, long, NULL, 0444);
 MODULE_PARM_DESC(fm_port, "FM port.");
 module_param_array(soft_ac3, bool, NULL, 0444);
 MODULE_PARM_DESC(soft_ac3, "Software-conversion of raw SPDIF packets (model 033 only).");
-#ifdef SUPPORT_JOYSTICK
-module_param_array(joystick_port, int, NULL, 0444);
-MODULE_PARM_DESC(joystick_port, "Joystick port address.");
-#endif
 
 /*
  * CM8x38 registers definition
@@ -498,10 +486,6 @@ struct cmipci {
 	/* external MIDI */
 	struct snd_rawmidi *rmidi;
 
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
-
 	spinlock_t reg_lock;
 
 #ifdef CONFIG_PM_SLEEP
@@ -2865,70 +2849,6 @@ static void query_chip(struct cmipci *cm)
 	}
 }
 
-#ifdef SUPPORT_JOYSTICK
-static int snd_cmipci_create_gameport(struct cmipci *cm, int dev)
-{
-	static int ports[] = { 0x201, 0x200, 0 }; /* FIXME: majority is 0x201? */
-	struct gameport *gp;
-	struct resource *r = NULL;
-	int i, io_port = 0;
-
-	if (joystick_port[dev] == 0)
-		return -ENODEV;
-
-	if (joystick_port[dev] == 1) { /* auto-detect */
-		for (i = 0; ports[i]; i++) {
-			io_port = ports[i];
-			r = request_region(io_port, 1, "CMIPCI gameport");
-			if (r)
-				break;
-		}
-	} else {
-		io_port = joystick_port[dev];
-		r = request_region(io_port, 1, "CMIPCI gameport");
-	}
-
-	if (!r) {
-		dev_warn(cm->card->dev, "cannot reserve joystick ports\n");
-		return -EBUSY;
-	}
-
-	cm->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(cm->card->dev, "cannot allocate memory for gameport\n");
-		release_and_free_resource(r);
-		return -ENOMEM;
-	}
-	gameport_set_name(gp, "C-Media Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(cm->pci));
-	gameport_set_dev_parent(gp, &cm->pci->dev);
-	gp->io = io_port;
-	gameport_set_port_data(gp, r);
-
-	snd_cmipci_set_bit(cm, CM_REG_FUNCTRL1, CM_JYSTK_EN);
-
-	gameport_register_port(cm->gameport);
-
-	return 0;
-}
-
-static void snd_cmipci_free_gameport(struct cmipci *cm)
-{
-	if (cm->gameport) {
-		struct resource *r = gameport_get_port_data(cm->gameport);
-
-		gameport_unregister_port(cm->gameport);
-		cm->gameport = NULL;
-
-		snd_cmipci_clear_bit(cm, CM_REG_FUNCTRL1, CM_JYSTK_EN);
-		release_and_free_resource(r);
-	}
-}
-#else
-static inline int snd_cmipci_create_gameport(struct cmipci *cm, int dev) { return -ENOSYS; }
-static inline void snd_cmipci_free_gameport(struct cmipci *cm) { }
-#endif
-
 static int snd_cmipci_free(struct cmipci *cm)
 {
 	if (cm->irq >= 0) {
@@ -2946,7 +2866,6 @@ static int snd_cmipci_free(struct cmipci *cm)
 		free_irq(cm->irq, cm);
 	}
 
-	snd_cmipci_free_gameport(cm);
 	pci_release_regions(cm->pci);
 	pci_disable_device(cm->pci);
 	kfree(cm);
@@ -3254,8 +3173,7 @@ static int snd_cmipci_create(struct snd_card *card, struct pci_dev *pci,
 	snd_cmipci_set_bit(cm, CM_REG_MISC_CTRL, CM_SPDIF48K|CM_SPDF_AC97);
 #endif /* USE_VAR48KRATE */
 
-	if (snd_cmipci_create_gameport(cm, dev) < 0)
-		snd_cmipci_clear_bit(cm, CM_REG_FUNCTRL1, CM_JYSTK_EN);
+	snd_cmipci_clear_bit(cm, CM_REG_FUNCTRL1, CM_JYSTK_EN);
 
 	*rcmipci = cm;
 	return 0;
diff --git a/sound/pci/cs4281.c b/sound/pci/cs4281.c
index 43d1f91..4639250 100644
--- a/sound/pci/cs4281.c
+++ b/sound/pci/cs4281.c
@@ -25,7 +25,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/control.h>
@@ -484,8 +483,6 @@ struct cs4281 {
 	unsigned int midcr;
 	unsigned int uartm;
 
-	struct gameport *gameport;
-
 #ifdef CONFIG_PM_SLEEP
 	u32 suspend_regs[SUSPEND_REGISTERS];
 #endif
@@ -1195,118 +1192,8 @@ static void snd_cs4281_proc_init(struct cs4281 *chip)
 	}
 }
 
-/*
- * joystick support
- */
-
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-
-static void snd_cs4281_gameport_trigger(struct gameport *gameport)
-{
-	struct cs4281 *chip = gameport_get_port_data(gameport);
-
-	if (snd_BUG_ON(!chip))
-		return;
-	snd_cs4281_pokeBA0(chip, BA0_JSPT, 0xff);
-}
-
-static unsigned char snd_cs4281_gameport_read(struct gameport *gameport)
-{
-	struct cs4281 *chip = gameport_get_port_data(gameport);
-
-	if (snd_BUG_ON(!chip))
-		return 0;
-	return snd_cs4281_peekBA0(chip, BA0_JSPT);
-}
-
-#ifdef COOKED_MODE
-static int snd_cs4281_gameport_cooked_read(struct gameport *gameport,
-					   int *axes, int *buttons)
-{
-	struct cs4281 *chip = gameport_get_port_data(gameport);
-	unsigned js1, js2, jst;
-	
-	if (snd_BUG_ON(!chip))
-		return 0;
-
-	js1 = snd_cs4281_peekBA0(chip, BA0_JSC1);
-	js2 = snd_cs4281_peekBA0(chip, BA0_JSC2);
-	jst = snd_cs4281_peekBA0(chip, BA0_JSPT);
-	
-	*buttons = (~jst >> 4) & 0x0F; 
-	
-	axes[0] = ((js1 & JSC1_Y1V_MASK) >> JSC1_Y1V_SHIFT) & 0xFFFF;
-	axes[1] = ((js1 & JSC1_X1V_MASK) >> JSC1_X1V_SHIFT) & 0xFFFF;
-	axes[2] = ((js2 & JSC2_Y2V_MASK) >> JSC2_Y2V_SHIFT) & 0xFFFF;
-	axes[3] = ((js2 & JSC2_X2V_MASK) >> JSC2_X2V_SHIFT) & 0xFFFF;
-
-	for (jst = 0; jst < 4; ++jst)
-		if (axes[jst] == 0xFFFF) axes[jst] = -1;
-	return 0;
-}
-#else
-#define snd_cs4281_gameport_cooked_read	NULL
-#endif
-
-static int snd_cs4281_gameport_open(struct gameport *gameport, int mode)
-{
-	switch (mode) {
-#ifdef COOKED_MODE
-	case GAMEPORT_MODE_COOKED:
-		return 0;
-#endif
-	case GAMEPORT_MODE_RAW:
-		return 0;
-	default:
-		return -1;
-	}
-	return 0;
-}
-
-static int snd_cs4281_create_gameport(struct cs4281 *chip)
-{
-	struct gameport *gp;
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev,
-			"cannot allocate memory for gameport\n");
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "CS4281 Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-	gp->open = snd_cs4281_gameport_open;
-	gp->read = snd_cs4281_gameport_read;
-	gp->trigger = snd_cs4281_gameport_trigger;
-	gp->cooked_read = snd_cs4281_gameport_cooked_read;
-	gameport_set_port_data(gp, chip);
-
-	snd_cs4281_pokeBA0(chip, BA0_JSIO, 0xFF); // ?
-	snd_cs4281_pokeBA0(chip, BA0_JSCTL, JSCTL_SP_MEDIUM_SLOW);
-
-	gameport_register_port(gp);
-
-	return 0;
-}
-
-static void snd_cs4281_free_gameport(struct cs4281 *chip)
-{
-	if (chip->gameport) {
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-	}
-}
-#else
-static inline int snd_cs4281_create_gameport(struct cs4281 *chip) { return -ENOSYS; }
-static inline void snd_cs4281_free_gameport(struct cs4281 *chip) { }
-#endif /* CONFIG_GAMEPORT || (MODULE && CONFIG_GAMEPORT_MODULE) */
-
 static int snd_cs4281_free(struct cs4281 *chip)
 {
-	snd_cs4281_free_gameport(chip);
-
 	if (chip->irq >= 0)
 		synchronize_irq(chip->irq);
 
@@ -1960,7 +1847,6 @@ static int snd_cs4281_probe(struct pci_dev *pci,
 		snd_card_free(card);
 		return err;
 	}
-	snd_cs4281_create_gameport(chip);
 	strcpy(card->driver, "CS4281");
 	strcpy(card->shortname, "Cirrus Logic CS4281");
 	sprintf(card->longname, "%s at 0x%lx, irq %d",
diff --git a/sound/pci/cs46xx/cs46xx.c b/sound/pci/cs46xx/cs46xx.c
index af0eacb..05d8ae2 100644
--- a/sound/pci/cs46xx/cs46xx.c
+++ b/sound/pci/cs46xx/cs46xx.c
@@ -136,8 +136,6 @@ static int snd_card_cs46xx_probe(struct pci_dev *pci,
 	}
 
 
-	snd_cs46xx_gameport(chip);
-
 	strcpy(card->driver, "CS46xx");
 	strcpy(card->shortname, "Sound Fusion CS46xx");
 	sprintf(card->longname, "%s at 0x%lx/0x%lx, irq %i",
diff --git a/sound/pci/cs46xx/cs46xx.h b/sound/pci/cs46xx/cs46xx.h
index c49a082..1b09df8 100644
--- a/sound/pci/cs46xx/cs46xx.h
+++ b/sound/pci/cs46xx/cs46xx.h
@@ -1706,8 +1706,6 @@ struct snd_cs46xx {
 	int accept_valid;	/* accept mmap valid (for OSS) */
 	int in_suspend;
 
-	struct gameport *gameport;
-
 #ifdef CONFIG_SND_CS46XX_NEW_DSP
 	struct mutex spos_mutex;
 
@@ -1744,6 +1742,4 @@ int snd_cs46xx_pcm_center_lfe(struct snd_cs46xx *chip, int device, struct snd_pc
 int snd_cs46xx_mixer(struct snd_cs46xx *chip, int spdif_device);
 int snd_cs46xx_midi(struct snd_cs46xx *chip, int device, struct snd_rawmidi **rmidi);
 int snd_cs46xx_start_dsp(struct snd_cs46xx *chip);
-int snd_cs46xx_gameport(struct snd_cs46xx *chip);
-
 #endif /* __SOUND_CS46XX_H */
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index 32b44f2..9f87155 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -51,7 +51,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/mutex.h>
 #include <linux/export.h>
 #include <linux/module.h>
@@ -2745,108 +2744,6 @@ int snd_cs46xx_midi(struct snd_cs46xx *chip, int device, struct snd_rawmidi **rr
 }
 
 
-/*
- * gameport interface
- */
-
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-
-static void snd_cs46xx_gameport_trigger(struct gameport *gameport)
-{
-	struct snd_cs46xx *chip = gameport_get_port_data(gameport);
-
-	if (snd_BUG_ON(!chip))
-		return;
-	snd_cs46xx_pokeBA0(chip, BA0_JSPT, 0xFF);  //outb(gameport->io, 0xFF);
-}
-
-static unsigned char snd_cs46xx_gameport_read(struct gameport *gameport)
-{
-	struct snd_cs46xx *chip = gameport_get_port_data(gameport);
-
-	if (snd_BUG_ON(!chip))
-		return 0;
-	return snd_cs46xx_peekBA0(chip, BA0_JSPT); //inb(gameport->io);
-}
-
-static int snd_cs46xx_gameport_cooked_read(struct gameport *gameport, int *axes, int *buttons)
-{
-	struct snd_cs46xx *chip = gameport_get_port_data(gameport);
-	unsigned js1, js2, jst;
-
-	if (snd_BUG_ON(!chip))
-		return 0;
-
-	js1 = snd_cs46xx_peekBA0(chip, BA0_JSC1);
-	js2 = snd_cs46xx_peekBA0(chip, BA0_JSC2);
-	jst = snd_cs46xx_peekBA0(chip, BA0_JSPT);
-	
-	*buttons = (~jst >> 4) & 0x0F; 
-	
-	axes[0] = ((js1 & JSC1_Y1V_MASK) >> JSC1_Y1V_SHIFT) & 0xFFFF;
-	axes[1] = ((js1 & JSC1_X1V_MASK) >> JSC1_X1V_SHIFT) & 0xFFFF;
-	axes[2] = ((js2 & JSC2_Y2V_MASK) >> JSC2_Y2V_SHIFT) & 0xFFFF;
-	axes[3] = ((js2 & JSC2_X2V_MASK) >> JSC2_X2V_SHIFT) & 0xFFFF;
-
-	for(jst=0;jst<4;++jst)
-		if(axes[jst]==0xFFFF) axes[jst] = -1;
-	return 0;
-}
-
-static int snd_cs46xx_gameport_open(struct gameport *gameport, int mode)
-{
-	switch (mode) {
-	case GAMEPORT_MODE_COOKED:
-		return 0;
-	case GAMEPORT_MODE_RAW:
-		return 0;
-	default:
-		return -1;
-	}
-	return 0;
-}
-
-int snd_cs46xx_gameport(struct snd_cs46xx *chip)
-{
-	struct gameport *gp;
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev,
-			"cannot allocate memory for gameport\n");
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "CS46xx Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-	gameport_set_port_data(gp, chip);
-
-	gp->open = snd_cs46xx_gameport_open;
-	gp->read = snd_cs46xx_gameport_read;
-	gp->trigger = snd_cs46xx_gameport_trigger;
-	gp->cooked_read = snd_cs46xx_gameport_cooked_read;
-
-	snd_cs46xx_pokeBA0(chip, BA0_JSIO, 0xFF); // ?
-	snd_cs46xx_pokeBA0(chip, BA0_JSCTL, JSCTL_SP_MEDIUM_SLOW);
-
-	gameport_register_port(gp);
-
-	return 0;
-}
-
-static inline void snd_cs46xx_remove_gameport(struct snd_cs46xx *chip)
-{
-	if (chip->gameport) {
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-	}
-}
-#else
-int snd_cs46xx_gameport(struct snd_cs46xx *chip) { return -ENOSYS; }
-static inline void snd_cs46xx_remove_gameport(struct snd_cs46xx *chip) { }
-#endif /* CONFIG_GAMEPORT */
-
 #ifdef CONFIG_PROC_FS
 /*
  *  proc interface
@@ -2961,8 +2858,6 @@ static int snd_cs46xx_free(struct snd_cs46xx *chip)
 	if (chip->active_ctrl)
 		chip->active_ctrl(chip, 1);
 
-	snd_cs46xx_remove_gameport(chip);
-
 	if (chip->amplifier_ctrl)
 		chip->amplifier_ctrl(chip, -chip->amplifier); /* force to off */
 	
diff --git a/sound/pci/ens1370.c b/sound/pci/ens1370.c
index 29cd339..a4fe6d8 100644
--- a/sound/pci/ens1370.c
+++ b/sound/pci/ens1370.c
@@ -32,7 +32,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 
@@ -79,20 +78,9 @@ MODULE_SUPPORTED_DEVICE("{{Ensoniq,AudioPCI ES1371/73},"
 		"{Ectiva,EV1938}}");
 #endif
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK
-#endif
-
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable switches */
-#ifdef SUPPORT_JOYSTICK
-#ifdef CHIP1371
-static int joystick_port[SNDRV_CARDS];
-#else
-static bool joystick[SNDRV_CARDS];
-#endif
-#endif
 #ifdef CHIP1371
 static int spdif[SNDRV_CARDS];
 static int lineio[SNDRV_CARDS];
@@ -104,15 +92,6 @@ module_param_array(id, charp, NULL, 0444);
 MODULE_PARM_DESC(id, "ID string for Ensoniq AudioPCI soundcard.");
 module_param_array(enable, bool, NULL, 0444);
 MODULE_PARM_DESC(enable, "Enable Ensoniq AudioPCI soundcard.");
-#ifdef SUPPORT_JOYSTICK
-#ifdef CHIP1371
-module_param_array(joystick_port, int, NULL, 0444);
-MODULE_PARM_DESC(joystick_port, "Joystick port address.");
-#else
-module_param_array(joystick, bool, NULL, 0444);
-MODULE_PARM_DESC(joystick, "Enable joystick.");
-#endif
-#endif /* SUPPORT_JOYSTICK */
 #ifdef CHIP1371
 module_param_array(spdif, int, NULL, 0444);
 MODULE_PARM_DESC(spdif, "S/PDIF output (-1 = none, 0 = auto, 1 = force).");
@@ -438,10 +417,6 @@ struct ensoniq {
 #ifdef CHIP1370
 	struct snd_dma_buffer dma_bug;
 #endif
-
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
 };
 
 static irqreturn_t snd_audiopci_interrupt(int irq, void *dev_id);
@@ -1793,107 +1768,6 @@ static int snd_ensoniq_1370_mixer(struct ensoniq *ensoniq)
 
 #endif /* CHIP1370 */
 
-#ifdef SUPPORT_JOYSTICK
-
-#ifdef CHIP1371
-static int snd_ensoniq_get_joystick_port(struct ensoniq *ensoniq, int dev)
-{
-	switch (joystick_port[dev]) {
-	case 0: /* disabled */
-	case 1: /* auto-detect */
-	case 0x200:
-	case 0x208:
-	case 0x210:
-	case 0x218:
-		return joystick_port[dev];
-
-	default:
-		dev_err(ensoniq->card->dev,
-			"invalid joystick port %#x", joystick_port[dev]);
-		return 0;
-	}
-}
-#else
-static int snd_ensoniq_get_joystick_port(struct ensoniq *ensoniq, int dev)
-{
-	return joystick[dev] ? 0x200 : 0;
-}
-#endif
-
-static int snd_ensoniq_create_gameport(struct ensoniq *ensoniq, int dev)
-{
-	struct gameport *gp;
-	int io_port;
-
-	io_port = snd_ensoniq_get_joystick_port(ensoniq, dev);
-
-	switch (io_port) {
-	case 0:
-		return -ENOSYS;
-
-	case 1: /* auto_detect */
-		for (io_port = 0x200; io_port <= 0x218; io_port += 8)
-			if (request_region(io_port, 8, "ens137x: gameport"))
-				break;
-		if (io_port > 0x218) {
-			dev_warn(ensoniq->card->dev,
-				 "no gameport ports available\n");
-			return -EBUSY;
-		}
-		break;
-
-	default:
-		if (!request_region(io_port, 8, "ens137x: gameport")) {
-			dev_warn(ensoniq->card->dev,
-				 "gameport io port %#x in use\n",
-			       io_port);
-			return -EBUSY;
-		}
-		break;
-	}
-
-	ensoniq->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(ensoniq->card->dev,
-			"cannot allocate memory for gameport\n");
-		release_region(io_port, 8);
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "ES137x");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(ensoniq->pci));
-	gameport_set_dev_parent(gp, &ensoniq->pci->dev);
-	gp->io = io_port;
-
-	ensoniq->ctrl |= ES_JYSTK_EN;
-#ifdef CHIP1371
-	ensoniq->ctrl &= ~ES_1371_JOY_ASELM;
-	ensoniq->ctrl |= ES_1371_JOY_ASEL((io_port - 0x200) / 8);
-#endif
-	outl(ensoniq->ctrl, ES_REG(ensoniq, CONTROL));
-
-	gameport_register_port(ensoniq->gameport);
-
-	return 0;
-}
-
-static void snd_ensoniq_free_gameport(struct ensoniq *ensoniq)
-{
-	if (ensoniq->gameport) {
-		int port = ensoniq->gameport->io;
-
-		gameport_unregister_port(ensoniq->gameport);
-		ensoniq->gameport = NULL;
-		ensoniq->ctrl &= ~ES_JYSTK_EN;
-		outl(ensoniq->ctrl, ES_REG(ensoniq, CONTROL));
-		release_region(port, 8);
-	}
-}
-#else
-static inline int snd_ensoniq_create_gameport(struct ensoniq *ensoniq, long port) { return -ENOSYS; }
-static inline void snd_ensoniq_free_gameport(struct ensoniq *ensoniq) { }
-#endif /* SUPPORT_JOYSTICK */
-
 /*
 
  */
@@ -1931,7 +1805,6 @@ static void snd_ensoniq_proc_init(struct ensoniq *ensoniq)
 
 static int snd_ensoniq_free(struct ensoniq *ensoniq)
 {
-	snd_ensoniq_free_gameport(ensoniq);
 	if (ensoniq->irq < 0)
 		goto __hw_end;
 #ifdef CHIP1370
@@ -2475,8 +2348,6 @@ static int snd_audiopci_probe(struct pci_dev *pci,
 		return err;
 	}
 
-	snd_ensoniq_create_gameport(ensoniq, dev);
-
 	strcpy(card->driver, DRIVER_NAME);
 
 	strcpy(card->shortname, "Ensoniq AudioPCI");
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 34d95bf..7b39573 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -51,7 +51,6 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <linux/delay.h>
 #include <linux/dma-mapping.h>
@@ -73,10 +72,6 @@ MODULE_SUPPORTED_DEVICE("{{ESS,ES1938},"
                 "{ESS,ES1969},"
 		"{TerraTec,128i PCI}}");
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK 1
-#endif
-
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
@@ -233,9 +228,6 @@ struct es1938 {
 	spinlock_t mixer_lock;
         struct snd_info_entry *proc_entry;
 
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
 #ifdef CONFIG_PM_SLEEP
 	unsigned char saved_regs[SAVED_REG_SIZE];
 #endif
@@ -1526,40 +1518,6 @@ static SIMPLE_DEV_PM_OPS(es1938_pm, es1938_suspend, es1938_resume);
 #define ES1938_PM_OPS	NULL
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef SUPPORT_JOYSTICK
-static int snd_es1938_create_gameport(struct es1938 *chip)
-{
-	struct gameport *gp;
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev,
-			"cannot allocate memory for gameport\n");
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "ES1938");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-	gp->io = chip->game_port;
-
-	gameport_register_port(gp);
-
-	return 0;
-}
-
-static void snd_es1938_free_gameport(struct es1938 *chip)
-{
-	if (chip->gameport) {
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-	}
-}
-#else
-static inline int snd_es1938_create_gameport(struct es1938 *chip) { return -ENOSYS; }
-static inline void snd_es1938_free_gameport(struct es1938 *chip) { }
-#endif /* SUPPORT_JOYSTICK */
-
 static int snd_es1938_free(struct es1938 *chip)
 {
 	/* disable irqs */
@@ -1567,8 +1525,6 @@ static int snd_es1938_free(struct es1938 *chip)
 	if (chip->rmidi)
 		snd_es1938_mixer_bits(chip, ESSSB_IREG_MPU401CONTROL, 0x40, 0);
 
-	snd_es1938_free_gameport(chip);
-
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
 	pci_release_regions(chip->pci);
@@ -1855,8 +1811,6 @@ static int snd_es1938_probe(struct pci_dev *pci,
 		snd_es1938_mixer_bits(chip, ESSSB_IREG_MPU401CONTROL, 0x40, 0x40);
 	}
 
-	snd_es1938_create_gameport(chip);
-
 	if ((err = snd_card_register(card)) < 0) {
 		snd_card_free(card);
 		return err;
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 5bb1cf6..2cc324f 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -101,7 +101,6 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/input.h>
@@ -126,10 +125,6 @@ MODULE_SUPPORTED_DEVICE("{{ESS,Maestro 2e},"
 		"{ESS,Maestro 1},"
 		"{TerraTec,DMX}}");
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK 1
-#endif
-
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 1-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
@@ -139,9 +134,6 @@ static int pcm_substreams_c[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 1 };
 static int clock[SNDRV_CARDS];
 static int use_pm[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
 static int enable_mpu[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = 2};
-#ifdef SUPPORT_JOYSTICK
-static bool joystick[SNDRV_CARDS];
-#endif
 static int radio_nr[SNDRV_CARDS] = {[0 ... (SNDRV_CARDS - 1)] = -1};
 
 module_param_array(index, int, NULL, 0444);
@@ -162,10 +154,6 @@ module_param_array(use_pm, int, NULL, 0444);
 MODULE_PARM_DESC(use_pm, "Toggle power-management.  (0 = off, 1 = on, 2 = auto)");
 module_param_array(enable_mpu, int, NULL, 0444);
 MODULE_PARM_DESC(enable_mpu, "Enable MPU401.  (0 = off, 1 = on, 2 = auto)");
-#ifdef SUPPORT_JOYSTICK
-module_param_array(joystick, bool, NULL, 0444);
-MODULE_PARM_DESC(joystick, "Enable joystick.");
-#endif
 module_param_array(radio_nr, int, NULL, 0444);
 MODULE_PARM_DESC(radio_nr, "Radio device numbers");
 
@@ -548,10 +536,6 @@ struct es1968 {
 	u16 apu_map[NR_APUS][NR_APU_REGS];
 #endif
 
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
-
 #ifdef CONFIG_SND_ES1968_INPUT
 	struct input_dev *input_dev;
 	char phys[64];			/* physical device path */
@@ -2465,59 +2449,6 @@ static SIMPLE_DEV_PM_OPS(es1968_pm, es1968_suspend, es1968_resume);
 #define ES1968_PM_OPS	NULL
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef SUPPORT_JOYSTICK
-#define JOYSTICK_ADDR	0x200
-static int snd_es1968_create_gameport(struct es1968 *chip, int dev)
-{
-	struct gameport *gp;
-	struct resource *r;
-	u16 val;
-
-	if (!joystick[dev])
-		return -ENODEV;
-
-	r = request_region(JOYSTICK_ADDR, 8, "ES1968 gameport");
-	if (!r)
-		return -EBUSY;
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev,
-			"cannot allocate memory for gameport\n");
-		release_and_free_resource(r);
-		return -ENOMEM;
-	}
-
-	pci_read_config_word(chip->pci, ESM_LEGACY_AUDIO_CONTROL, &val);
-	pci_write_config_word(chip->pci, ESM_LEGACY_AUDIO_CONTROL, val | 0x04);
-
-	gameport_set_name(gp, "ES1968 Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-	gp->io = JOYSTICK_ADDR;
-	gameport_set_port_data(gp, r);
-
-	gameport_register_port(gp);
-
-	return 0;
-}
-
-static void snd_es1968_free_gameport(struct es1968 *chip)
-{
-	if (chip->gameport) {
-		struct resource *r = gameport_get_port_data(chip->gameport);
-
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-
-		release_and_free_resource(r);
-	}
-}
-#else
-static inline int snd_es1968_create_gameport(struct es1968 *chip, int dev) { return -ENOSYS; }
-static inline void snd_es1968_free_gameport(struct es1968 *chip) { }
-#endif
-
 #ifdef CONFIG_SND_ES1968_INPUT
 static int snd_es1968_input_register(struct es1968 *chip)
 {
@@ -2653,7 +2584,6 @@ static int snd_es1968_free(struct es1968 *chip)
 
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
-	snd_es1968_free_gameport(chip);
 	pci_release_regions(chip->pci);
 	pci_disable_device(chip->pci);
 	kfree(chip);
@@ -2908,8 +2838,6 @@ static int snd_es1968_probe(struct pci_dev *pci,
 		}
 	}
 
-	snd_es1968_create_gameport(chip, dev);
-
 #ifdef CONFIG_SND_ES1968_INPUT
 	err = snd_es1968_input_register(chip);
 	if (err)
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index b4a8278..8ee3267 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -94,7 +94,6 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
-#include <linux/gameport.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/kernel.h>
@@ -110,10 +109,6 @@
 #include <sound/opl3.h>
 #include <sound/initval.h>
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK 1
-#endif
-
 MODULE_AUTHOR("Peter Gruber <nokos@gmx.net>");
 MODULE_DESCRIPTION("riptide");
 MODULE_LICENSE("GPL");
@@ -449,9 +444,6 @@ struct snd_riptide {
 	unsigned long port;
 	unsigned short mpuaddr;
 	unsigned short opladdr;
-#ifdef SUPPORT_JOYSTICK
-	unsigned short gameaddr;
-#endif
 	struct resource *res_port;
 
 	unsigned short device_id;
@@ -2023,51 +2015,6 @@ static int snd_riptide_mixer(struct snd_riptide *chip)
 	return err;
 }
 
-#ifdef SUPPORT_JOYSTICK
-
-static int
-snd_riptide_joystick_probe(struct pci_dev *pci, const struct pci_device_id *id)
-{
-	static int dev;
-	struct gameport *gameport;
-
-	if (dev >= SNDRV_CARDS)
-		return -ENODEV;
-	if (!enable[dev]) {
-		dev++;
-		return -ENOENT;
-	}
-
-	if (!joystick_port[dev++])
-		return 0;
-
-	gameport = gameport_allocate_port();
-	if (!gameport)
-		return -ENOMEM;
-	if (!request_region(joystick_port[dev], 8, "Riptide gameport")) {
-		snd_printk(KERN_WARNING
-			   "Riptide: cannot grab gameport 0x%x\n",
-			   joystick_port[dev]);
-		gameport_free_port(gameport);
-		return -EBUSY;
-	}
-
-	gameport->io = joystick_port[dev];
-	gameport_register_port(gameport);
-	pci_set_drvdata(pci, gameport);
-	return 0;
-}
-
-static void snd_riptide_joystick_remove(struct pci_dev *pci)
-{
-	struct gameport *gameport = pci_get_drvdata(pci);
-	if (gameport) {
-		release_region(gameport->io, 8);
-		gameport_unregister_port(gameport);
-	}
-}
-#endif
-
 static int
 snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 {
@@ -2102,10 +2049,6 @@ snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	val = LEGACY_ENABLE_ALL;
 	if (opl3_port[dev])
 		val |= LEGACY_ENABLE_FM;
-#ifdef SUPPORT_JOYSTICK
-	if (joystick_port[dev])
-		val |= LEGACY_ENABLE_GAMEPORT;
-#endif
 	if (mpu_port[dev])
 		val |= LEGACY_ENABLE_MPU_INT | LEGACY_ENABLE_MPU;
 	val |= (chip->irq << 4) & 0xf0;
@@ -2140,27 +2083,13 @@ snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 					   "Riptide: Can't Allocate OPL3-HWDEP\n");
 		}
 	}
-#ifdef SUPPORT_JOYSTICK
-	if (joystick_port[dev]) {
-		val = joystick_port[dev];
-		pci_write_config_word(chip->pci, PCI_EXT_Game_Base, val);
-		chip->gameaddr = val;
-	}
-#endif
 
 	strcpy(card->driver, "RIPTIDE");
 	strcpy(card->shortname, "Riptide");
-#ifdef SUPPORT_JOYSTICK
-	snprintf(card->longname, sizeof(card->longname),
-		 "%s at 0x%lx, irq %i mpu 0x%x opl3 0x%x gameport 0x%x",
-		 card->shortname, chip->port, chip->irq, chip->mpuaddr,
-		 chip->opladdr, chip->gameaddr);
-#else
 	snprintf(card->longname, sizeof(card->longname),
 		 "%s at 0x%lx, irq %i mpu 0x%x opl3 0x%x",
 		 card->shortname, chip->port, chip->irq, chip->mpuaddr,
 		 chip->opladdr);
-#endif
 	snd_riptide_proc_init(chip);
 	err = snd_card_register(card);
 	if (err < 0)
@@ -2179,7 +2108,7 @@ static void snd_card_riptide_remove(struct pci_dev *pci)
 	snd_card_free(pci_get_drvdata(pci));
 }
 
-static struct pci_driver driver = {
+static struct pci_driver riptide_driver = {
 	.name = KBUILD_MODNAME,
 	.id_table = snd_riptide_ids,
 	.probe = snd_card_riptide_probe,
@@ -2188,38 +2117,4 @@ static struct pci_driver driver = {
 		.pm = RIPTIDE_PM_OPS,
 	},
 };
-
-#ifdef SUPPORT_JOYSTICK
-static struct pci_driver joystick_driver = {
-	.name = KBUILD_MODNAME "-joystick",
-	.id_table = snd_riptide_joystick_ids,
-	.probe = snd_riptide_joystick_probe,
-	.remove = snd_riptide_joystick_remove,
-};
-#endif
-
-static int __init alsa_card_riptide_init(void)
-{
-	int err;
-	err = pci_register_driver(&driver);
-	if (err < 0)
-		return err;
-#if defined(SUPPORT_JOYSTICK)
-	err = pci_register_driver(&joystick_driver);
-	/* On failure unregister formerly registered audio driver */
-	if (err < 0)
-		pci_unregister_driver(&driver);
-#endif
-	return err;
-}
-
-static void __exit alsa_card_riptide_exit(void)
-{
-	pci_unregister_driver(&driver);
-#if defined(SUPPORT_JOYSTICK)
-	pci_unregister_driver(&joystick_driver);
-#endif
-}
-
-module_init(alsa_card_riptide_init);
-module_exit(alsa_card_riptide_exit);
+module_pci_driver(riptide_driver);
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 2044dc7..6d23df6 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -27,7 +27,6 @@
 #include <linux/interrupt.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <linux/dma-mapping.h>
 
@@ -46,10 +45,6 @@ MODULE_DESCRIPTION("S3 SonicVibes PCI");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{S3,SonicVibes PCI}}");
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK 1
-#endif
-
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;	/* Enable this card */
@@ -236,10 +231,6 @@ struct sonicvibes {
 
 	struct snd_kcontrol *master_mute;
 	struct snd_kcontrol *master_volume;
-
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
 };
 
 static DEFINE_PCI_DEVICE_TABLE(snd_sonic_ids) = {
@@ -1187,52 +1178,8 @@ static void snd_sonicvibes_proc_init(struct sonicvibes *sonic)
 		snd_info_set_text_ops(entry, sonic, snd_sonicvibes_proc_read);
 }
 
-/*
-
- */
-
-#ifdef SUPPORT_JOYSTICK
-static struct snd_kcontrol_new snd_sonicvibes_game_control =
-SONICVIBES_SINGLE("Joystick Speed", 0, SV_IREG_GAME_PORT, 1, 15, 0);
-
-static int snd_sonicvibes_create_gameport(struct sonicvibes *sonic)
-{
-	struct gameport *gp;
-
-	sonic->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(sonic->card->dev,
-			"sonicvibes: cannot allocate memory for gameport\n");
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "SonicVibes Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(sonic->pci));
-	gameport_set_dev_parent(gp, &sonic->pci->dev);
-	gp->io = sonic->game_port;
-
-	gameport_register_port(gp);
-
-	snd_ctl_add(sonic->card, snd_ctl_new1(&snd_sonicvibes_game_control, sonic));
-
-	return 0;
-}
-
-static void snd_sonicvibes_free_gameport(struct sonicvibes *sonic)
-{
-	if (sonic->gameport) {
-		gameport_unregister_port(sonic->gameport);
-		sonic->gameport = NULL;
-	}
-}
-#else
-static inline int snd_sonicvibes_create_gameport(struct sonicvibes *sonic) { return -ENOSYS; }
-static inline void snd_sonicvibes_free_gameport(struct sonicvibes *sonic) { }
-#endif
-
 static int snd_sonicvibes_free(struct sonicvibes *sonic)
 {
-	snd_sonicvibes_free_gameport(sonic);
 	pci_write_config_dword(sonic->pci, 0x40, sonic->dmaa_port);
 	pci_write_config_dword(sonic->pci, 0x48, sonic->dmac_port);
 	if (sonic->irq >= 0)
@@ -1525,8 +1472,6 @@ static int snd_sonic_probe(struct pci_dev *pci,
 		return err;
 	}
 
-	snd_sonicvibes_create_gameport(sonic);
-
 	if ((err = snd_card_register(card)) < 0) {
 		snd_card_free(card);
 		return err;
diff --git a/sound/pci/trident/trident.c b/sound/pci/trident/trident.c
index d852458..927d386 100644
--- a/sound/pci/trident/trident.c
+++ b/sound/pci/trident/trident.c
@@ -156,8 +156,6 @@ static int snd_trident_probe(struct pci_dev *pci,
 		return err;
 	}
 
-	snd_trident_create_gameport(trident);
-
 	if ((err = snd_card_register(card)) < 0) {
 		snd_card_free(card);
 		return err;
diff --git a/sound/pci/trident/trident.h b/sound/pci/trident/trident.h
index 5f110eb..251455a 100644
--- a/sound/pci/trident/trident.h
+++ b/sound/pci/trident/trident.h
@@ -408,8 +408,6 @@ struct snd_trident {
 	struct snd_kcontrol *ctl_cvol;	/* center volume */
 
 	spinlock_t reg_lock;
-
-	struct gameport *gameport;
 };
 
 int snd_trident_create(struct snd_card *card,
@@ -418,7 +416,6 @@ int snd_trident_create(struct snd_card *card,
 		       int pcm_spdif_device,
 		       int max_wavetable_size,
 		       struct snd_trident ** rtrident);
-int snd_trident_create_gameport(struct snd_trident *trident);
 
 int snd_trident_pcm(struct snd_trident * trident, int device, struct snd_pcm **rpcm);
 int snd_trident_foldback_pcm(struct snd_trident * trident, int device, struct snd_pcm **rpcm);
diff --git a/sound/pci/trident/trident_main.c b/sound/pci/trident/trident_main.c
index 1272c18..ff4ec6c 100644
--- a/sound/pci/trident/trident_main.c
+++ b/sound/pci/trident/trident_main.c
@@ -33,7 +33,6 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
-#include <linux/gameport.h>
 #include <linux/dma-mapping.h>
 #include <linux/export.h>
 
@@ -3133,107 +3132,6 @@ static int snd_trident_mixer(struct snd_trident *trident, int pcm_spdif_device)
 }
 
 /*
- * gameport interface
- */
-
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-
-static unsigned char snd_trident_gameport_read(struct gameport *gameport)
-{
-	struct snd_trident *chip = gameport_get_port_data(gameport);
-
-	if (snd_BUG_ON(!chip))
-		return 0;
-	return inb(TRID_REG(chip, GAMEPORT_LEGACY));
-}
-
-static void snd_trident_gameport_trigger(struct gameport *gameport)
-{
-	struct snd_trident *chip = gameport_get_port_data(gameport);
-
-	if (snd_BUG_ON(!chip))
-		return;
-	outb(0xff, TRID_REG(chip, GAMEPORT_LEGACY));
-}
-
-static int snd_trident_gameport_cooked_read(struct gameport *gameport, int *axes, int *buttons)
-{
-	struct snd_trident *chip = gameport_get_port_data(gameport);
-	int i;
-
-	if (snd_BUG_ON(!chip))
-		return 0;
-
-	*buttons = (~inb(TRID_REG(chip, GAMEPORT_LEGACY)) >> 4) & 0xf;
-
-	for (i = 0; i < 4; i++) {
-		axes[i] = inw(TRID_REG(chip, GAMEPORT_AXES + i * 2));
-		if (axes[i] == 0xffff) axes[i] = -1;
-	}
-        
-        return 0;
-}
-
-static int snd_trident_gameport_open(struct gameport *gameport, int mode)
-{
-	struct snd_trident *chip = gameport_get_port_data(gameport);
-
-	if (snd_BUG_ON(!chip))
-		return 0;
-
-	switch (mode) {
-		case GAMEPORT_MODE_COOKED:
-			outb(GAMEPORT_MODE_ADC, TRID_REG(chip, GAMEPORT_GCR));
-			msleep(20);
-			return 0;
-		case GAMEPORT_MODE_RAW:
-			outb(0, TRID_REG(chip, GAMEPORT_GCR));
-			return 0;
-		default:
-			return -1;
-	}
-}
-
-int snd_trident_create_gameport(struct snd_trident *chip)
-{
-	struct gameport *gp;
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev,
-			"cannot allocate memory for gameport\n");
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "Trident 4DWave");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-
-	gameport_set_port_data(gp, chip);
-	gp->fuzz = 64;
-	gp->read = snd_trident_gameport_read;
-	gp->trigger = snd_trident_gameport_trigger;
-	gp->cooked_read = snd_trident_gameport_cooked_read;
-	gp->open = snd_trident_gameport_open;
-
-	gameport_register_port(gp);
-
-	return 0;
-}
-
-static inline void snd_trident_free_gameport(struct snd_trident *chip)
-{
-	if (chip->gameport) {
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-	}
-}
-#else
-int snd_trident_create_gameport(struct snd_trident *chip) { return -ENOSYS; }
-static inline void snd_trident_free_gameport(struct snd_trident *chip) { }
-#endif /* CONFIG_GAMEPORT */
-
-/*
  * delay for 1 tick
  */
 static inline void do_delay(struct snd_trident *chip)
@@ -3690,7 +3588,6 @@ int snd_trident_create(struct snd_card *card,
 
 static int snd_trident_free(struct snd_trident *trident)
 {
-	snd_trident_free_gameport(trident);
 	snd_trident_disable_eso(trident);
 	// Disable S/PDIF out
 	if (trident->device == TRIDENT_DEVICE_ID_NX)
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 95b98f5..ee90b1a 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -52,7 +52,6 @@
 #include <linux/init.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
-#include <linux/gameport.h>
 #include <linux/module.h>
 #include <sound/core.h>
 #include <sound/pcm.h>
@@ -72,16 +71,9 @@ MODULE_DESCRIPTION("VIA VT82xx audio");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{VIA,VT82C686A/B/C,pci},{VIA,VT8233A/C,8235}}");
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK 1
-#endif
-
 static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
 static long mpu_port;
-#ifdef SUPPORT_JOYSTICK
-static bool joystick;
-#endif
 static int ac97_clock = 48000;
 static char *ac97_quirk;
 static int dxs_support;
@@ -94,10 +86,6 @@ module_param(id, charp, 0444);
 MODULE_PARM_DESC(id, "ID string for VIA 82xx bridge.");
 module_param(mpu_port, long, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 port. (VT82C686x only)");
-#ifdef SUPPORT_JOYSTICK
-module_param(joystick, bool, 0444);
-MODULE_PARM_DESC(joystick, "Enable joystick. (VT82C686x only)");
-#endif
 module_param(ac97_clock, int, 0444);
 MODULE_PARM_DESC(ac97_clock, "AC'97 codec clock (default 48000Hz).");
 module_param(ac97_quirk, charp, 0444);
@@ -398,10 +386,6 @@ struct via82xx {
 
 	spinlock_t reg_lock;
 	struct snd_info_entry *proc_entry;
-
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
 };
 
 static DEFINE_PCI_DEVICE_TABLE(snd_via82xx_ids) = {
@@ -1934,64 +1918,6 @@ static int snd_via82xx_mixer_new(struct via82xx *chip, const char *quirk_overrid
 	return 0;
 }
 
-#ifdef SUPPORT_JOYSTICK
-#define JOYSTICK_ADDR	0x200
-static int snd_via686_create_gameport(struct via82xx *chip, unsigned char *legacy)
-{
-	struct gameport *gp;
-	struct resource *r;
-
-	if (!joystick)
-		return -ENODEV;
-
-	r = request_region(JOYSTICK_ADDR, 8, "VIA686 gameport");
-	if (!r) {
-		dev_warn(chip->card->dev, "cannot reserve joystick port %#x\n",
-		       JOYSTICK_ADDR);
-		return -EBUSY;
-	}
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev,
-			"cannot allocate memory for gameport\n");
-		release_and_free_resource(r);
-		return -ENOMEM;
-	}
-
-	gameport_set_name(gp, "VIA686 Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-	gp->io = JOYSTICK_ADDR;
-	gameport_set_port_data(gp, r);
-
-	/* Enable legacy joystick port */
-	*legacy |= VIA_FUNC_ENABLE_GAME;
-	pci_write_config_byte(chip->pci, VIA_FUNC_ENABLE, *legacy);
-
-	gameport_register_port(chip->gameport);
-
-	return 0;
-}
-
-static void snd_via686_free_gameport(struct via82xx *chip)
-{
-	if (chip->gameport) {
-		struct resource *r = gameport_get_port_data(chip->gameport);
-
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-		release_and_free_resource(r);
-	}
-}
-#else
-static inline int snd_via686_create_gameport(struct via82xx *chip, unsigned char *legacy)
-{
-	return -ENOSYS;
-}
-static inline void snd_via686_free_gameport(struct via82xx *chip) { }
-#endif
-
 
 /*
  *
@@ -2120,8 +2046,6 @@ static int snd_via686_init_misc(struct via82xx *chip)
 		pci_write_config_byte(chip->pci, VIA_FUNC_ENABLE, legacy);
 	}
 
-	snd_via686_create_gameport(chip, &legacy);
-
 #ifdef CONFIG_PM_SLEEP
 	chip->legacy_saved = legacy;
 	chip->legacy_cfg_saved = legacy_cfg;
@@ -2364,7 +2288,6 @@ static int snd_via82xx_free(struct via82xx *chip)
 	pci_release_regions(chip->pci);
 
 	if (chip->chip_type == TYPE_VIA686) {
-		snd_via686_free_gameport(chip);
 		pci_write_config_byte(chip->pci, VIA_FUNC_ENABLE, chip->old_legacy);
 		pci_write_config_byte(chip->pci, VIA_PNP_CONTROL, chip->old_legacy_cfg);
 	}
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 82eed16..7c62d76 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -59,10 +59,6 @@ module_param_array(mpu_port, long, NULL, 0444);
 MODULE_PARM_DESC(mpu_port, "MPU-401 Port.");
 module_param_array(fm_port, long, NULL, 0444);
 MODULE_PARM_DESC(fm_port, "FM OPL-3 Port.");
-#ifdef SUPPORT_JOYSTICK
-module_param_array(joystick_port, long, NULL, 0444);
-MODULE_PARM_DESC(joystick_port, "Joystick port address");
-#endif
 module_param_array(rear_switch, bool, NULL, 0444);
 MODULE_PARM_DESC(rear_switch, "Enable shared rear/line-in switch");
 
@@ -78,99 +74,6 @@ static DEFINE_PCI_DEVICE_TABLE(snd_ymfpci_ids) = {
 
 MODULE_DEVICE_TABLE(pci, snd_ymfpci_ids);
 
-#ifdef SUPPORT_JOYSTICK
-static int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev,
-				      int legacy_ctrl, int legacy_ctrl2)
-{
-	struct gameport *gp;
-	struct resource *r = NULL;
-	int io_port = joystick_port[dev];
-
-	if (!io_port)
-		return -ENODEV;
-
-	if (chip->pci->device >= 0x0010) { /* YMF 744/754 */
-
-		if (io_port == 1) {
-			/* auto-detect */
-			if (!(io_port = pci_resource_start(chip->pci, 2)))
-				return -ENODEV;
-		}
-	} else {
-		if (io_port == 1) {
-			/* auto-detect */
-			for (io_port = 0x201; io_port <= 0x205; io_port++) {
-				if (io_port == 0x203)
-					continue;
-				if ((r = request_region(io_port, 1, "YMFPCI gameport")) != NULL)
-					break;
-			}
-			if (!r) {
-				dev_err(chip->card->dev,
-					"no gameport ports available\n");
-				return -EBUSY;
-			}
-		}
-		switch (io_port) {
-		case 0x201: legacy_ctrl2 |= 0 << 6; break;
-		case 0x202: legacy_ctrl2 |= 1 << 6; break;
-		case 0x204: legacy_ctrl2 |= 2 << 6; break;
-		case 0x205: legacy_ctrl2 |= 3 << 6; break;
-		default:
-			dev_err(chip->card->dev,
-				"invalid joystick port %#x", io_port);
-			return -EINVAL;
-		}
-	}
-
-	if (!r && !(r = request_region(io_port, 1, "YMFPCI gameport"))) {
-		dev_err(chip->card->dev,
-			"joystick port %#x is in use.\n", io_port);
-		return -EBUSY;
-	}
-
-	chip->gameport = gp = gameport_allocate_port();
-	if (!gp) {
-		dev_err(chip->card->dev,
-			"cannot allocate memory for gameport\n");
-		release_and_free_resource(r);
-		return -ENOMEM;
-	}
-
-
-	gameport_set_name(gp, "Yamaha YMF Gameport");
-	gameport_set_phys(gp, "pci%s/gameport0", pci_name(chip->pci));
-	gameport_set_dev_parent(gp, &chip->pci->dev);
-	gp->io = io_port;
-	gameport_set_port_data(gp, r);
-
-	if (chip->pci->device >= 0x0010) /* YMF 744/754 */
-		pci_write_config_word(chip->pci, PCIR_DSXG_JOYBASE, io_port);
-
-	pci_write_config_word(chip->pci, PCIR_DSXG_LEGACY, legacy_ctrl | YMFPCI_LEGACY_JPEN);
-	pci_write_config_word(chip->pci, PCIR_DSXG_ELEGACY, legacy_ctrl2);
-
-	gameport_register_port(chip->gameport);
-
-	return 0;
-}
-
-void snd_ymfpci_free_gameport(struct snd_ymfpci *chip)
-{
-	if (chip->gameport) {
-		struct resource *r = gameport_get_port_data(chip->gameport);
-
-		gameport_unregister_port(chip->gameport);
-		chip->gameport = NULL;
-
-		release_and_free_resource(r);
-	}
-}
-#else
-static inline int snd_ymfpci_create_gameport(struct snd_ymfpci *chip, int dev, int l, int l2) { return -ENOSYS; }
-void snd_ymfpci_free_gameport(struct snd_ymfpci *chip) { }
-#endif /* SUPPORT_JOYSTICK */
-
 static int snd_card_ymfpci_probe(struct pci_dev *pci,
 				 const struct pci_device_id *pci_id)
 {
@@ -342,8 +245,6 @@ static int snd_card_ymfpci_probe(struct pci_dev *pci,
 		}
 	}
 
-	snd_ymfpci_create_gameport(chip, dev, legacy_ctrl, legacy_ctrl2);
-
 	if ((err = snd_card_register(card)) < 0) {
 		snd_card_free(card);
 		return err;
diff --git a/sound/pci/ymfpci/ymfpci.h b/sound/pci/ymfpci/ymfpci.h
index 4631a23..a3d469a 100644
--- a/sound/pci/ymfpci/ymfpci.h
+++ b/sound/pci/ymfpci/ymfpci.h
@@ -26,7 +26,6 @@
 #include <sound/rawmidi.h>
 #include <sound/ac97_codec.h>
 #include <sound/timer.h>
-#include <linux/gameport.h>
 
 /*
  *  Direct registers
@@ -176,10 +175,6 @@
 #define YMFPCI_LEGACY2_IMOD	(1 << 15)	/* legacy IRQ mode */
 /* SIEN:IMOD 0:0 = legacy irq, 0:1 = INTA, 1:0 = serialized IRQ */
 
-#if defined(CONFIG_GAMEPORT) || (defined(MODULE) && defined(CONFIG_GAMEPORT_MODULE))
-#define SUPPORT_JOYSTICK
-#endif
-
 /*
  *
  */
@@ -295,9 +290,6 @@ struct snd_ymfpci {
 	struct resource *mpu_res;
 
 	unsigned short old_legacy_ctrl;
-#ifdef SUPPORT_JOYSTICK
-	struct gameport *gameport;
-#endif
 
 	struct snd_dma_buffer work_ptr;
 
@@ -375,7 +367,6 @@ int snd_ymfpci_create(struct snd_card *card,
 		      struct pci_dev *pci,
 		      unsigned short old_legacy_ctrl,
 		      struct snd_ymfpci ** rcodec);
-void snd_ymfpci_free_gameport(struct snd_ymfpci *chip);
 
 extern const struct dev_pm_ops snd_ymfpci_pm;
 
diff --git a/sound/pci/ymfpci/ymfpci_main.c b/sound/pci/ymfpci/ymfpci_main.c
index 81c916a..2ade07e 100644
--- a/sound/pci/ymfpci/ymfpci_main.c
+++ b/sound/pci/ymfpci/ymfpci_main.c
@@ -2271,7 +2271,6 @@ static int snd_ymfpci_free(struct snd_ymfpci *chip)
 		free_irq(chip->irq, chip);
 	release_and_free_resource(chip->mpu_res);
 	release_and_free_resource(chip->fm_res);
-	snd_ymfpci_free_gameport(chip);
 	if (chip->reg_area_virt)
 		iounmap(chip->reg_area_virt);
 	if (chip->work_ptr.area)
-- 
2.1.0.rc2.206.gedb03e5

