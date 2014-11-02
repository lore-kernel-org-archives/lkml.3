Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329AbaKBWTA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 17:19:00 -0500
Received: from ns.gsystem.sk ([62.176.172.50]:35689 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaKBWS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 17:18:59 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] [RESEND] snd-es18xx: Add GPO controls
Date: Sun,  2 Nov 2014 23:18:49 +0100
Message-Id: <1414966729-4978-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add GPO0 and GPO1 (General Purpose Outputs) controls to mixer.
These can be used on some cards to control amplifier mute (seen in ES1868
datasheet) or additional onboard chips such as QX2130 QXpander processor.

These GPOs are present on ES1868, ES1869, ES1887 and ES1888 chips.

Tested on ES1868 with QX2130.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/isa/es18xx.c |   49 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 10 deletions(-)

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 6faaac6..8966ed2 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -156,6 +156,7 @@ struct snd_es18xx {
 #define ES18XX_I2S	0x0200	/* I2S mixer control */
 #define ES18XX_MUTEREC	0x0400	/* Record source can be muted */
 #define ES18XX_CONTROL	0x0800	/* Has control ports */
+#define ES18XX_GPO_2BIT	0x1000	/* GPO0,1 controlled by PM port */
 
 /* Power Management */
 #define ES18XX_PM	0x07
@@ -1136,11 +1137,14 @@ static int snd_es18xx_reg_read(struct snd_es18xx *chip, unsigned char reg)
 		return snd_es18xx_read(chip, reg);
 }
 
-#define ES18XX_SINGLE(xname, xindex, reg, shift, mask, invert) \
+#define ES18XX_SINGLE(xname, xindex, reg, shift, mask, flags) \
 { .iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, .index = xindex, \
   .info = snd_es18xx_info_single, \
   .get = snd_es18xx_get_single, .put = snd_es18xx_put_single, \
-  .private_value = reg | (shift << 8) | (mask << 16) | (invert << 24) }
+  .private_value = reg | (shift << 8) | (mask << 16) | (flags << 24) }
+
+#define ES18XX_FL_INVERT	(1 << 0)
+#define ES18XX_FL_PMPORT	(1 << 1)
 
 static int snd_es18xx_info_single(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_info *uinfo)
 {
@@ -1159,10 +1163,14 @@ static int snd_es18xx_get_single(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 	int reg = kcontrol->private_value & 0xff;
 	int shift = (kcontrol->private_value >> 8) & 0xff;
 	int mask = (kcontrol->private_value >> 16) & 0xff;
-	int invert = (kcontrol->private_value >> 24) & 0xff;
+	int invert = (kcontrol->private_value >> 24) & ES18XX_FL_INVERT;
+	int pm_port = (kcontrol->private_value >> 24) & ES18XX_FL_PMPORT;
 	int val;
-	
-	val = snd_es18xx_reg_read(chip, reg);
+
+	if (pm_port)
+		val = inb(chip->port + ES18XX_PM);
+	else
+		val = snd_es18xx_reg_read(chip, reg);
 	ucontrol->value.integer.value[0] = (val >> shift) & mask;
 	if (invert)
 		ucontrol->value.integer.value[0] = mask - ucontrol->value.integer.value[0];
@@ -1175,7 +1183,8 @@ static int snd_es18xx_put_single(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 	int reg = kcontrol->private_value & 0xff;
 	int shift = (kcontrol->private_value >> 8) & 0xff;
 	int mask = (kcontrol->private_value >> 16) & 0xff;
-	int invert = (kcontrol->private_value >> 24) & 0xff;
+	int invert = (kcontrol->private_value >> 24) & ES18XX_FL_INVERT;
+	int pm_port = (kcontrol->private_value >> 24) & ES18XX_FL_PMPORT;
 	unsigned char val;
 	
 	val = (ucontrol->value.integer.value[0] & mask);
@@ -1183,6 +1192,12 @@ static int snd_es18xx_put_single(struct snd_kcontrol *kcontrol, struct snd_ctl_e
 		val = mask - val;
 	mask <<= shift;
 	val <<= shift;
+	if (pm_port) {
+		val = (inb(chip->port + ES18XX_PM) & ~mask) | val;
+		outb(val, chip->port + ES18XX_PM);
+		return 0;
+	}
+
 	return snd_es18xx_reg_bits(chip, reg, mask, val) != val;
 }
 
@@ -1304,7 +1319,7 @@ static struct snd_kcontrol_new snd_es18xx_opt_speaker =
 	ES18XX_SINGLE("Beep Playback Volume", 0, 0x3c, 0, 7, 0);
 
 static struct snd_kcontrol_new snd_es18xx_opt_1869[] = {
-ES18XX_SINGLE("Capture Switch", 0, 0x1c, 4, 1, 1),
+ES18XX_SINGLE("Capture Switch", 0, 0x1c, 4, 1, ES18XX_FL_INVERT),
 ES18XX_SINGLE("Video Playback Switch", 0, 0x7f, 0, 1, 0),
 ES18XX_DOUBLE("Mono Playback Volume", 0, 0x6d, 0x6d, 4, 0, 15, 0),
 ES18XX_DOUBLE("Mono Capture Volume", 0, 0x6f, 0x6f, 4, 0, 15, 0)
@@ -1363,6 +1378,11 @@ static struct snd_kcontrol_new snd_es18xx_hw_volume_controls[] = {
 ES18XX_SINGLE("Hardware Master Volume Split", 0, 0x64, 7, 1, 0),
 };
 
+static struct snd_kcontrol_new snd_es18xx_opt_gpo_2bit[] = {
+ES18XX_SINGLE("GPO0 Switch", 0, ES18XX_PM, 0, 1, ES18XX_FL_PMPORT),
+ES18XX_SINGLE("GPO1 Switch", 0, ES18XX_PM, 1, 1, ES18XX_FL_PMPORT),
+};
+
 static int snd_es18xx_config_read(struct snd_es18xx *chip, unsigned char reg)
 {
 	int data;
@@ -1629,10 +1649,10 @@ static int snd_es18xx_probe(struct snd_es18xx *chip,
 
 	switch (chip->version) {
 	case 0x1868:
-		chip->caps = ES18XX_DUPLEX_MONO | ES18XX_DUPLEX_SAME | ES18XX_CONTROL;
+		chip->caps = ES18XX_DUPLEX_MONO | ES18XX_DUPLEX_SAME | ES18XX_CONTROL | ES18XX_GPO_2BIT;
 		break;
 	case 0x1869:
-		chip->caps = ES18XX_PCM2 | ES18XX_SPATIALIZER | ES18XX_RECMIX | ES18XX_NEW_RATE | ES18XX_AUXB | ES18XX_MONO | ES18XX_MUTEREC | ES18XX_CONTROL | ES18XX_HWV;
+		chip->caps = ES18XX_PCM2 | ES18XX_SPATIALIZER | ES18XX_RECMIX | ES18XX_NEW_RATE | ES18XX_AUXB | ES18XX_MONO | ES18XX_MUTEREC | ES18XX_CONTROL | ES18XX_HWV | ES18XX_GPO_2BIT;
 		break;
 	case 0x1878:
 		chip->caps = ES18XX_DUPLEX_MONO | ES18XX_DUPLEX_SAME | ES18XX_I2S | ES18XX_CONTROL;
@@ -1642,7 +1662,7 @@ static int snd_es18xx_probe(struct snd_es18xx *chip,
 		break;
 	case 0x1887:
 	case 0x1888:
-		chip->caps = ES18XX_PCM2 | ES18XX_RECMIX | ES18XX_AUXB | ES18XX_DUPLEX_SAME;
+		chip->caps = ES18XX_PCM2 | ES18XX_RECMIX | ES18XX_AUXB | ES18XX_DUPLEX_SAME | ES18XX_GPO_2BIT;
 		break;
 	default:
 		snd_printk(KERN_ERR "[0x%lx] unsupported chip ES%x\n",
@@ -1944,6 +1964,15 @@ static int snd_es18xx_mixer(struct snd_card *card)
 				return err;
 		}
 	}
+	if (chip->caps & ES18XX_GPO_2BIT) {
+		for (idx = 0; idx < ARRAY_SIZE(snd_es18xx_opt_gpo_2bit); idx++) {
+			err = snd_ctl_add(card,
+					  snd_ctl_new1(&snd_es18xx_opt_gpo_2bit[idx],
+						       chip));
+			if (err < 0)
+				return err;
+		}
+	}
 	return 0;
 }
        
-- 
Ondrej Zary

