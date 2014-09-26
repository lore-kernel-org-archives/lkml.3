Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaIZSXj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 14:23:39 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:35016 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbaIZSXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 14:23:37 -0400
X-Greylist: delayed 1311 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Sep 2014 14:23:36 EDT
From: Ondrej Zary <linux@rainbow-software.org>
To: alsa-devel@alsa-project.org
Cc: Andreas Mohr <andi@lisas.de>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] ES938 support for ES18xx driver
Date: Fri, 26 Sep 2014 20:23:25 +0200
Message-Id: <1411755805-8165-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ES938 3-D Audio Effects Processor found on some ES18xx
(and possibly other) sound cards, doing bass/treble and 3D control.

ES938 is controlled by MIDI SysEx commands sent through card's MPU401 port.

The code opens/closes the MIDI device everytime a mixer control value is
changed so userspace apps can still use the MIDI port. Changing the mixer
controls will fail when the MIDI port is open by an application.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 sound/isa/Kconfig  |    4 ++
 sound/isa/Makefile |    2 +
 sound/isa/es18xx.c |   11 ++-
 sound/isa/es938.c  |  203 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 sound/isa/es938.h  |   29 ++++++++
 5 files changed, 248 insertions(+), 1 deletion(-)
 create mode 100644 sound/isa/es938.c
 create mode 100644 sound/isa/es938.h

diff --git a/sound/isa/Kconfig b/sound/isa/Kconfig
index 0216475..db0b678 100644
--- a/sound/isa/Kconfig
+++ b/sound/isa/Kconfig
@@ -17,6 +17,9 @@ config SND_SB16_DSP
         select SND_PCM
         select SND_SB_COMMON
 
+config SND_ES938
+	tristate
+
 menuconfig SND_ISA
 	bool "ISA sound devices"
 	depends on ISA && ISA_DMA_API
@@ -183,6 +186,7 @@ config SND_ES18XX
 	select SND_OPL3_LIB
 	select SND_MPU401_UART
 	select SND_PCM
+	select SND_ES938
 	help
 	  Say Y here to include support for ESS AudioDrive ES18xx chips.
 
diff --git a/sound/isa/Makefile b/sound/isa/Makefile
index 9a15f14..d59e0bf 100644
--- a/sound/isa/Makefile
+++ b/sound/isa/Makefile
@@ -8,6 +8,7 @@ snd-als100-objs := als100.o
 snd-azt2320-objs := azt2320.o
 snd-cmi8328-objs := cmi8328.o
 snd-cmi8330-objs := cmi8330.o
+snd-es938-objs := es938.o
 snd-es18xx-objs := es18xx.o
 snd-opl3sa2-objs := opl3sa2.o
 snd-sc6000-objs := sc6000.o
@@ -19,6 +20,7 @@ obj-$(CONFIG_SND_ALS100) += snd-als100.o
 obj-$(CONFIG_SND_AZT2320) += snd-azt2320.o
 obj-$(CONFIG_SND_CMI8328) += snd-cmi8328.o
 obj-$(CONFIG_SND_CMI8330) += snd-cmi8330.o
+obj-$(CONFIG_SND_ES938) += snd-es938.o
 obj-$(CONFIG_SND_ES18XX) += snd-es18xx.o
 obj-$(CONFIG_SND_OPL3SA2) += snd-opl3sa2.o
 obj-$(CONFIG_SND_SC6000) += snd-sc6000.o
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index 6faaac6..139cd3b 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -96,6 +96,7 @@
 #define SNDRV_LEGACY_FIND_FREE_IRQ
 #define SNDRV_LEGACY_FIND_FREE_DMA
 #include <sound/initval.h>
+#include "es938.h"
 
 #define PFX "es18xx: "
 
@@ -122,6 +123,7 @@ struct snd_es18xx {
 	struct snd_pcm_substream *playback_b_substream;
 
 	struct snd_rawmidi *rmidi;
+	struct snd_es938 es938;
 
 	struct snd_kcontrol *hw_volume;
 	struct snd_kcontrol *hw_switch;
@@ -2167,7 +2169,14 @@ static int snd_audiodrive_probe(struct snd_card *card, int dev)
 			return err;
 	}
 
-	return snd_card_register(card);
+	err = snd_card_register(card);
+	if (err < 0)
+		return err;
+
+	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT)
+		snd_es938_init(&chip->es938, card, 0, 0);
+
+	return 0;
 }
 
 static int snd_es18xx_isa_match(struct device *pdev, unsigned int dev)
diff --git a/sound/isa/es938.c b/sound/isa/es938.c
new file mode 100644
index 0000000..ea1b25c
--- /dev/null
+++ b/sound/isa/es938.c
@@ -0,0 +1,203 @@
+/*
+ *  Driver for ESS ES938 3-D Audio Effects Processor
+ *  Copyright (c) 2014 Ondrej Zary
+ *
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ */
+
+#include <linux/module.h>
+#include <sound/asoundef.h>
+#include <sound/control.h>
+#include <sound/core.h>
+#include <sound/rawmidi.h>
+#include "es938.h"
+
+MODULE_AUTHOR("Ondrej Zary");
+MODULE_DESCRIPTION("ESS ES938");
+MODULE_LICENSE("GPL");
+
+static int snd_es938_read_reg(struct snd_es938 *chip, u8 reg, u8 *out)
+{
+	u8 buf[8];
+	int i = 0, res;
+	u8 sysex[] = { MIDI_CMD_COMMON_SYSEX, 0x00, 0x00, ES938_ID,
+		       ES938_CMD_REG_R, reg, MIDI_CMD_COMMON_SYSEX_END };
+	unsigned long end_time;
+
+	snd_rawmidi_kernel_write(chip->rfile.output, sysex, sizeof(sysex));
+
+	memset(buf, 0, sizeof(buf));
+	end_time = jiffies + msecs_to_jiffies(100);
+	while (i < sizeof(buf)) {
+		res = snd_rawmidi_kernel_read(chip->rfile.input, buf + i,
+					      sizeof(buf) - i);
+		if (res > 0)
+			i += res;
+		if (time_after(jiffies, end_time))
+			return -1;
+	}
+
+	/* check reply */
+	if (memcmp(buf, sysex, 6) || buf[7] != MIDI_CMD_COMMON_SYSEX_END)
+		return -1;
+
+	if (out)
+		*out = buf[6];
+
+	return 0;
+}
+
+static void snd_es938_write_reg(struct snd_es938 *chip, u8 reg, u8 val)
+{
+	u8 sysex[] = { MIDI_CMD_COMMON_SYSEX, 0x00, 0x00, ES938_ID,
+		       ES938_CMD_REG_W, reg, val, MIDI_CMD_COMMON_SYSEX_END };
+
+	snd_rawmidi_kernel_write(chip->rfile.output, sysex, sizeof(sysex));
+	chip->regs[reg] = val;
+}
+
+#define ES938_MIXER(xname, xindex, reg, shift, mask) \
+{ .iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, .index = xindex, \
+.info = snd_es938_info_mixer, \
+.get = snd_es938_get_mixer, .put = snd_es938_put_mixer, \
+.private_value = reg | (shift << 8) | (mask << 16) }
+
+#define ES938_MIXER_TLV(xname, xindex, reg, shift, mask, xtlv) \
+{ .iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, .index = xindex, \
+.access = SNDRV_CTL_ELEM_ACCESS_READWRITE | SNDRV_CTL_ELEM_ACCESS_TLV_READ, \
+.info = snd_es938_info_mixer, \
+.get = snd_es938_get_mixer, .put = snd_es938_put_mixer, \
+.private_value = reg | (shift << 8) | (mask << 16), \
+.tlv = { .p = (xtlv) } }
+
+static const DECLARE_TLV_DB_SCALE(db_scale_tone, -900, 300, 0);
+
+static struct snd_kcontrol_new snd_es938_controls[] = {
+ES938_MIXER_TLV("Tone Control - Bass", 0, ES938_REG_TONE, 0, 7, db_scale_tone),
+ES938_MIXER_TLV("Tone Control - Treble", 0, ES938_REG_TONE, 4, 7, db_scale_tone),
+ES938_MIXER("3D Control - Level", 0, ES938_REG_SPATIAL, 1, 63),
+ES938_MIXER("3D Control - Switch", 0, ES938_REG_SPATIAL_EN, 0, 1),
+};
+
+int snd_es938_init(struct snd_es938 *chip, struct snd_card *card, int device,
+		   int subdevice)
+{
+	int ret, i;
+
+	ret = snd_rawmidi_kernel_open(card, device, subdevice,
+			SNDRV_RAWMIDI_LFLG_OPEN | SNDRV_RAWMIDI_LFLG_APPEND,
+			&chip->rfile);
+	if (ret < 0) {
+		snd_printk(KERN_WARNING "es938: unable to open MIDI device\n");
+		return ret;
+	}
+
+	/* try to read a register to detect chip presence */
+	if (snd_es938_read_reg(chip, ES938_REG_MISC, NULL) < 0) {
+		ret = -ENODEV;
+		goto err;
+	}
+
+	/* write default values (there's no reset) */
+	snd_es938_write_reg(chip, ES938_REG_MISC, 0x49);
+	snd_es938_write_reg(chip, ES938_REG_TONE, 0x33);
+	/* reserved bit 0 must be set for 3D to work */
+	snd_es938_write_reg(chip, ES938_REG_SPATIAL, 0x01);
+	/* datasheet specifies invalid value 0x00 as default */
+	snd_es938_write_reg(chip, ES938_REG_SPATIAL_EN, 0x02);
+	snd_es938_write_reg(chip, ES938_REG_POWER, 0x0e);
+
+	strlcat(card->mixername, " + ES938", sizeof(card->mixername));
+	for (i = 0; i < ARRAY_SIZE(snd_es938_controls); i++) {
+		ret = snd_ctl_add(card,
+				  snd_ctl_new1(&snd_es938_controls[i], chip));
+		if (ret < 0)
+			goto err;
+	}
+
+	chip->card = card;
+	chip->device = device;
+	chip->subdevice = subdevice;
+err:
+	snd_rawmidi_kernel_release(&chip->rfile);
+
+	return ret;
+}
+EXPORT_SYMBOL(snd_es938_init);
+
+int snd_es938_info_mixer(struct snd_kcontrol *kcontrol,
+			 struct snd_ctl_elem_info *uinfo)
+{
+	int mask = (kcontrol->private_value >> 16) & 0xff;
+
+	uinfo->type = mask == 1 ? SNDRV_CTL_ELEM_TYPE_BOOLEAN :
+				  SNDRV_CTL_ELEM_TYPE_INTEGER;
+	uinfo->count = 1;
+	uinfo->value.integer.min = 0;
+	uinfo->value.integer.max = mask;
+	return 0;
+}
+EXPORT_SYMBOL(snd_es938_info_mixer);
+
+int snd_es938_get_mixer(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_es938 *chip = snd_kcontrol_chip(kcontrol);
+	int reg = kcontrol->private_value & 0xff;
+	int shift = (kcontrol->private_value >> 8) & 0xff;
+	int mask = (kcontrol->private_value >> 16) & 0xff;
+	u8 val = chip->regs[reg];
+
+	ucontrol->value.integer.value[0] = (val >> shift) & mask;
+	return 0;
+}
+EXPORT_SYMBOL(snd_es938_get_mixer);
+
+int snd_es938_put_mixer(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_es938 *chip = snd_kcontrol_chip(kcontrol);
+	int reg = kcontrol->private_value & 0xff;
+	int shift = (kcontrol->private_value >> 8) & 0xff;
+	int mask = (kcontrol->private_value >> 16) & 0xff;
+	u8 val = ucontrol->value.integer.value[0] & mask;
+	u8 oldval = chip->regs[reg];
+	u8 newval;
+	int err;
+
+	mask <<= shift;
+	val <<= shift;
+
+	newval = (oldval & ~mask) | val;
+	if (newval == oldval)
+		return 0;
+
+	/* this will fail if the MIDI port is used by an application */
+	err = snd_rawmidi_kernel_open(chip->card, chip->device,
+			chip->subdevice,
+			SNDRV_RAWMIDI_LFLG_OPEN | SNDRV_RAWMIDI_LFLG_APPEND,
+			&chip->rfile);
+	if (err < 0)
+		return err;
+
+	snd_es938_write_reg(chip, reg, newval);
+
+	snd_rawmidi_kernel_release(&chip->rfile);
+
+	return 1;
+}
+EXPORT_SYMBOL(snd_es938_put_mixer);
diff --git a/sound/isa/es938.h b/sound/isa/es938.h
new file mode 100644
index 0000000..b67dfc7
--- /dev/null
+++ b/sound/isa/es938.h
@@ -0,0 +1,29 @@
+#include <sound/tlv.h>
+
+#define ES938_ID		0x7b
+
+#define ES938_CMD_REG_R		0x7e
+#define ES938_CMD_REG_W		0x7f
+
+#define ES938_REG_MISC		0
+#define ES938_REG_TONE		1
+#define ES938_REG_SPATIAL	5
+#define ES938_REG_SPATIAL_EN	6
+#define ES938_REG_POWER		7
+
+struct snd_es938 {
+	u8 regs[8];
+	struct snd_card *card;
+	int device;
+	int subdevice;
+	struct snd_rawmidi_file rfile;
+};
+
+int snd_es938_init(struct snd_es938 *chip, struct snd_card *card, int device,
+		   int subdevice);
+int snd_es938_info_mixer(struct snd_kcontrol *kcontrol,
+			 struct snd_ctl_elem_info *uinfo);
+int snd_es938_get_mixer(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol);
+int snd_es938_put_mixer(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol);
-- 
Ondrej Zary

