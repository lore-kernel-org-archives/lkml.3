Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933954Ab3D3X1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:27:41 -0400
Received: from mail-yh0-f68.google.com ([209.85.213.68]:51485 "EHLO
	mail-yh0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933705Ab3D3X1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:27:38 -0400
X-Greylist: delayed 3138 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Apr 2013 19:27:38 EDT
Message-ID: <51804394.a36cec0a.2c7d.291b@mx.google.com>
Date: Tue, 30 Apr 2013 15:20:04 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============7657009074290278901=="
MIME-Version: 1.0
From: good1.2guy@gmail.com
To: linux-kernel@vger.kernel.org
Subject: add support for syba 7.1 surround sound card
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============7657009074290278901==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

Summary: add support for syba 7.1 surround sound card
Keywords: syba via VT1723 Tremor
Kernel: 3.8.8-203.fc18.x86_64

add support for syba 7.1 surround sound card
actually the card only has 6 dmas, so it is really only 5.1
added code to force_rate setting to not fail EBUSY when the dmas are running.
suggest using force_rate with pulseaudio to avoid loops with error logging.

diff -ur a/sound/pci/ice1712/ice1724.c b/sound/pci/ice1712/ice1724.c
add support for syba 7.1 surround sound card
actually the card only has 6 dmas, so it is really only 5.1
added code to force_rate setting to not fail EBUSY when the dmas are running.
suggest using force_rate with pulseaudio to avoid loops with error logging.
Signed-off-by: psmith2004@yahoo.com
--- a/sound/pci/ice1712/ice1724.c	2013-04-24 14:19:10.225007602 -0600
+++ b/sound/pci/ice1712/ice1724.c	2013-04-29 08:49:26.739934818 -0600
@@ -72,6 +72,7 @@
 	       WTM_DEVICE_DESC
 	       SE_DEVICE_DESC
 	       QTET_DEVICE_DESC
+		"{Syba 7.1 Surround Sound},"
 		"{VIA,VT1720},"
 		"{VIA,VT1724},"
 		"{ICEnsemble,Generic ICE1724},"
@@ -82,6 +83,7 @@
 static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static bool enable[SNDRV_CARDS] = SNDRV_DEFAULT_ENABLE_PNP;		/* Enable this card */
 static char *model[SNDRV_CARDS];
+static bool force_rate;
 
 module_param_array(index, int, NULL, 0444);
 MODULE_PARM_DESC(index, "Index value for ICE1724 soundcard.");
@@ -91,7 +93,8 @@
 MODULE_PARM_DESC(enable, "Enable ICE1724 soundcard.");
 module_param_array(model, charp, NULL, 0444);
 MODULE_PARM_DESC(model, "Use the given board model.");
-
+module_param(force_rate, bool, 0644);
+MODULE_PARM_DESC(force_rate, "suppress err when setting rate while dma running");
 
 /* Both VT1720 and VT1724 have the same PCI IDs */
 static DEFINE_PCI_DEVICE_TABLE(snd_vt1724_ids) = {
@@ -570,18 +573,6 @@
 	}
 
 	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		spin_lock(&ice->reg_lock);
-		old = inb(ICEMT1724(ice, DMA_PAUSE));
-		if (cmd == SNDRV_PCM_TRIGGER_PAUSE_PUSH)
-			old |= what;
-		else
-			old &= ~what;
-		outb(old, ICEMT1724(ice, DMA_PAUSE));
-		spin_unlock(&ice->reg_lock);
-		break;
-
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
@@ -593,6 +584,19 @@
 			old &= ~what;
 		outb(old, ICEMT1724(ice, DMA_CONTROL));
 		spin_unlock(&ice->reg_lock);
+		if (cmd == SNDRV_PCM_TRIGGER_START)
+			break;
+		/* fall through */
+	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+		spin_lock(&ice->reg_lock);
+		old = inb(ICEMT1724(ice, DMA_PAUSE));
+		if (cmd == SNDRV_PCM_TRIGGER_PAUSE_PUSH)
+			old |= what;
+		else
+			old &= ~what;
+		outb(old, ICEMT1724(ice, DMA_PAUSE));
+		spin_unlock(&ice->reg_lock);
 		break;
 
 	case SNDRV_PCM_TRIGGER_RESUME:
@@ -663,17 +667,27 @@
 	unsigned long flags;
 	unsigned char mclk_change;
 	unsigned int i, old_rate;
+	unsigned char dma_control, dma_pause;
 
 	if (rate > ice->hw_rates->list[ice->hw_rates->count - 1])
 		return -EINVAL;
 
 	spin_lock_irqsave(&ice->reg_lock, flags);
-	if ((inb(ICEMT1724(ice, DMA_CONTROL)) & DMA_STARTS) ||
-	    (inb(ICEMT1724(ice, DMA_PAUSE)) & DMA_PAUSES)) {
+	dma_control = inb(ICEMT1724(ice, DMA_CONTROL));
+	dma_pause = inb(ICEMT1724(ice, DMA_PAUSE));
+	if ((dma_control & DMA_STARTS) || (dma_pause & DMA_PAUSES)) {
+		int ret = 0;
 		/* running? we cannot change the rate now... */
+		if ((rate != ice->cur_rate) && force >= 0) {
+			snd_printd("ice1724: dma busy %02x/%02x, rate reset\n",
+				dma_control, dma_pause);
+				ret = -EBUSY;
+		}
 		spin_unlock_irqrestore(&ice->reg_lock, flags);
-		return ((rate == ice->cur_rate) && !force) ? 0 : -EBUSY;
+		return ret;
 	}
+	if (force < 0)
+		force = 0;
 	if (!force && is_pro_rate_locked(ice)) {
 		/* comparing required and current rate - makes sense for
 		 * internal clock only */
@@ -720,7 +734,7 @@
 				    struct snd_pcm_hw_params *hw_params)
 {
 	struct snd_ice1712 *ice = snd_pcm_substream_chip(substream);
-	int i, chs, err;
+	int i, chs, err, force;
 
 	chs = params_channels(hw_params);
 	mutex_lock(&ice->open_mutex);
@@ -756,7 +770,8 @@
 	}
 	mutex_unlock(&ice->open_mutex);
 
-	err = snd_vt1724_set_pro_rate(ice, params_rate(hw_params), 0);
+	force = force_rate ? -1 : 0;
+	err = snd_vt1724_set_pro_rate(ice, params_rate(hw_params), force);
 	if (err < 0)
 		return err;
 
@@ -768,6 +783,7 @@
 	struct snd_ice1712 *ice = snd_pcm_substream_chip(substream);
 	int i;
 
+	snd_vt1724_pcm_trigger(substream, SNDRV_PCM_TRIGGER_STOP);
 	mutex_lock(&ice->open_mutex);
 	/* unmark surround channels */
 	for (i = 0; i < 3; i++)
@@ -1068,6 +1084,8 @@
 	constrain_rate_if_locked(substream);
 	if (ice->pro_open)
 		ice->pro_open(ice, substream);
+	if (ice->quirk_open)
+		ice->quirk_open(ice);
 	return 0;
 }
 
@@ -1089,6 +1107,8 @@
 	constrain_rate_if_locked(substream);
 	if (ice->pro_open)
 		ice->pro_open(ice, substream);
+	if (ice->quirk_open)
+		ice->quirk_open(ice);
 	return 0;
 }
 
@@ -1422,6 +1442,8 @@
 	snd_pcm_set_sync(substream);
 	snd_pcm_hw_constraint_msbits(runtime, 0, 32, 24);
 	set_rate_constraints(ice, substream);
+	if (ice->quirk_open)
+		ice->quirk_open(ice);
 	return 0;
 }
 
@@ -2242,6 +2264,46 @@
 	{ } /* terminator */
 };
 
+
+#define VT1724_SUBDEVICE_SYBA_71_SS 0x12140324
+
+static void syba_quirk_open(struct snd_ice1712 *ice)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&ice->reg_lock, flags);
+	outb(0xff, ICEREG1724(ice, AC97_CFG));
+	udelay(500);
+	outb(ice->eeprom.data[ICE_EEP2_ACLINK], ICEREG1724(ice, AC97_CFG));
+	spin_unlock_irqrestore(&ice->reg_lock, flags);
+}
+
+static int syba_init(struct snd_ice1712 *ice)
+{
+	/* determine I2C, DACs and ADCs */
+	switch (ice->eeprom.subvendor) {
+	case VT1724_SUBDEVICE_SYBA_71_SS:
+		ice->num_total_dacs = 8;
+		ice->num_total_adcs = 2;
+		ice->quirk_open = syba_quirk_open;
+		break;
+	default:
+		snd_BUG();
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct snd_ice1712_card_info snd_vt1724_syba_cards[] = {
+	{
+		.subvendor = VT1724_SUBDEVICE_SYBA_71_SS,
+		.name = "Syba 7.1 Surround Sound",
+		.model = "syba71ss",
+		.chip_init = syba_init,
+	},
+	{ } /* terminator */
+};
+
+
 static struct snd_ice1712_card_info *card_tables[] = {
 	snd_vt1724_revo_cards,
 	snd_vt1724_amp_cards,
@@ -2258,6 +2320,7 @@
 	snd_vt1724_qtet_cards,
 	snd_vt1724_ooaoo_cards,
 	snd_vt1724_psc724_cards,
+	snd_vt1724_syba_cards,
 	NULL,
 };
 

--===============7657009074290278901==--
