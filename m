Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaDAGV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 02:21:59 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13367 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaDAGV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 02:21:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 31 Mar 2014 23:15:26 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: <lars@metafoo.de>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <swarren@wwwdotorg.org>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Arun Shamanna Lakshmi <aruns@nvidia.com>,
        Songhee Baek <sbaek@nvidia.com>
Subject: [PATCH] ASoC: DAPM: Add support for multi register mux
Date: Mon, 31 Mar 2014 23:21:28 -0700
Message-ID: <1396333288-19113-1-git-send-email-aruns@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify soc_enum struct to handle pointers for reg and mask. Add
dapm get and put APIs for multi register mux with one hot encoding.

Signed-off-by: Arun Shamanna Lakshmi <aruns@nvidia.com>
Signed-off-by: Songhee Baek <sbaek@nvidia.com>
---
 include/sound/soc-dapm.h |   10 ++++
 include/sound/soc.h      |   22 +++++--
 sound/soc/soc-core.c     |   12 ++--
 sound/soc/soc-dapm.c     |  143 +++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 162 insertions(+), 25 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index ef78f56..983b0ab 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -305,6 +305,12 @@ struct device;
  	.get = snd_soc_dapm_get_enum_double, \
  	.put = snd_soc_dapm_put_enum_double, \
   	.private_value = (unsigned long)&xenum }
+#define SOC_DAPM_ENUM_WIDE(xname, xenum) \
+{	.iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, \
+	.info = snd_soc_info_enum_double, \
+	.get = snd_soc_dapm_get_enum_wide, \
+	.put = snd_soc_dapm_put_enum_wide, \
+	.private_value = (unsigned long)&xenum }
 #define SOC_DAPM_ENUM_VIRT(xname, xenum) \
 	SOC_DAPM_ENUM(xname, xenum)
 #define SOC_DAPM_ENUM_EXT(xname, xenum, xget, xput) \
@@ -378,6 +384,10 @@ int snd_soc_dapm_get_enum_double(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
 int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
+int snd_soc_dapm_get_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol);
+int snd_soc_dapm_put_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol);
 int snd_soc_dapm_info_pin_switch(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_info *uinfo);
 int snd_soc_dapm_get_pin_switch(struct snd_kcontrol *kcontrol,
diff --git a/include/sound/soc.h b/include/sound/soc.h
index 5878410..5c274c4 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -177,18 +177,23 @@
 		{.reg = xreg, .min = xmin, .max = xmax, \
 		 .platform_max = xmax} }
 #define SOC_ENUM_DOUBLE(xreg, xshift_l, xshift_r, xitems, xtexts) \
-{	.reg = xreg, .shift_l = xshift_l, .shift_r = xshift_r, \
+{	.reg = &(int){(xreg)}, .shift_l = xshift_l, .shift_r = xshift_r, \
 	.items = xitems, .texts = xtexts, \
-	.mask = xitems ? roundup_pow_of_two(xitems) - 1 : 0}
+	.mask = &(unsigned int){(xitems ? roundup_pow_of_two(xitems) - 1 : 0)}, \
+	.num_regs = 1 }
 #define SOC_ENUM_SINGLE(xreg, xshift, xitems, xtexts) \
 	SOC_ENUM_DOUBLE(xreg, xshift, xshift, xitems, xtexts)
 #define SOC_ENUM_SINGLE_EXT(xitems, xtexts) \
 {	.items = xitems, .texts = xtexts }
 #define SOC_VALUE_ENUM_DOUBLE(xreg, xshift_l, xshift_r, xmask, xitems, xtexts, xvalues) \
-{	.reg = xreg, .shift_l = xshift_l, .shift_r = xshift_r, \
-	.mask = xmask, .items = xitems, .texts = xtexts, .values = xvalues}
+{	.reg = &(int){(xreg)}, .shift_l = xshift_l, .shift_r = xshift_r, \
+	.mask = &(unsigned int){(xmask)}, .items = xitems, .texts = xtexts, \
+	.values = xvalues, .num_regs = 1 }
 #define SOC_VALUE_ENUM_SINGLE(xreg, xshift, xmask, xnitmes, xtexts, xvalues) \
 	SOC_VALUE_ENUM_DOUBLE(xreg, xshift, xshift, xmask, xnitmes, xtexts, xvalues)
+#define SOC_VALUE_ENUM_WIDE(xregs, xmasks, xnum_regs, xitems, xtexts, xvalues) \
+{	.reg = xregs, .mask = xmasks, .num_regs = xnum_regs, \
+	.items = xitems, .texts = xtexts, .values = xvalues, .reg_width = 32 }
 #define SOC_ENUM_SINGLE_VIRT(xitems, xtexts) \
 	SOC_ENUM_SINGLE(SND_SOC_NOPM, 0, xitems, xtexts)
 #define SOC_ENUM(xname, xenum) \
@@ -293,6 +298,9 @@
 #define SOC_VALUE_ENUM_DOUBLE_DECL(name, xreg, xshift_l, xshift_r, xmask, xtexts, xvalues) \
 	const struct soc_enum name = SOC_VALUE_ENUM_DOUBLE(xreg, xshift_l, xshift_r, xmask, \
 							ARRAY_SIZE(xtexts), xtexts, xvalues)
+#define SOC_VALUE_ENUM_WIDE_DECL(name, xregs, xmasks, xnum_regs, xtexts, xvalues) \
+	const struct soc_enum name = SOC_VALUE_ENUM_WIDE(xregs, xmasks, xnum_regs, \
+							ARRAY_SIZE(xtexts), xtexts, xvalues)
 #define SOC_VALUE_ENUM_SINGLE_DECL(name, xreg, xshift, xmask, xtexts, xvalues) \
 	SOC_VALUE_ENUM_DOUBLE_DECL(name, xreg, xshift, xshift, xmask, xtexts, xvalues)
 #define SOC_ENUM_SINGLE_VIRT_DECL(name, xtexts) \
@@ -1098,13 +1106,15 @@ struct soc_mreg_control {
 
 /* enumerated kcontrol */
 struct soc_enum {
-	int reg;
+	int *reg;
 	unsigned char shift_l;
 	unsigned char shift_r;
 	unsigned int items;
-	unsigned int mask;
+	unsigned int *mask;
 	const char * const *texts;
 	const unsigned int *values;
+	unsigned int reg_width;
+	unsigned int num_regs;
 };
 
 /**
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index cd52d52..aba0094 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -2601,12 +2601,12 @@ int snd_soc_get_enum_double(struct snd_kcontrol *kcontrol,
 	unsigned int val, item;
 	unsigned int reg_val;
 
-	reg_val = snd_soc_read(codec, e->reg);
-	val = (reg_val >> e->shift_l) & e->mask;
+	reg_val = snd_soc_read(codec, e->reg[0]);
+	val = (reg_val >> e->shift_l) & e->mask[0];
 	item = snd_soc_enum_val_to_item(e, val);
 	ucontrol->value.enumerated.item[0] = item;
 	if (e->shift_l != e->shift_r) {
-		val = (reg_val >> e->shift_l) & e->mask;
+		val = (reg_val >> e->shift_l) & e->mask[0];
 		item = snd_soc_enum_val_to_item(e, val);
 		ucontrol->value.enumerated.item[1] = item;
 	}
@@ -2636,15 +2636,15 @@ int snd_soc_put_enum_double(struct snd_kcontrol *kcontrol,
 	if (item[0] >= e->items)
 		return -EINVAL;
 	val = snd_soc_enum_item_to_val(e, item[0]) << e->shift_l;
-	mask = e->mask << e->shift_l;
+	mask = e->mask[0] << e->shift_l;
 	if (e->shift_l != e->shift_r) {
 		if (item[1] >= e->items)
 			return -EINVAL;
 		val |= snd_soc_enum_item_to_val(e, item[1]) << e->shift_r;
-		mask |= e->mask << e->shift_r;
+		mask |= e->mask[0] << e->shift_r;
 	}
 
-	return snd_soc_update_bits_locked(codec, e->reg, mask, val);
+	return snd_soc_update_bits_locked(codec, e->reg[0], mask, val);
 }
 EXPORT_SYMBOL_GPL(snd_soc_put_enum_double);
 
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index c8a780d..4d2b35c 100644
--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -514,9 +514,9 @@ static int dapm_connect_mux(struct snd_soc_dapm_context *dapm,
 	unsigned int val, item;
 	int i;
 
-	if (e->reg != SND_SOC_NOPM) {
-		soc_widget_read(dest, e->reg, &val);
-		val = (val >> e->shift_l) & e->mask;
+	if (e->reg[0] != SND_SOC_NOPM) {
+		soc_widget_read(dest, e->reg[0], &val);
+		val = (val >> e->shift_l) & e->mask[0];
 		item = snd_soc_enum_val_to_item(e, val);
 	} else {
 		/* since a virtual mux has no backing registers to
@@ -2903,15 +2903,15 @@ int snd_soc_dapm_get_enum_double(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int reg_val, val;
 
-	if (e->reg != SND_SOC_NOPM)
-		reg_val = snd_soc_read(codec, e->reg);
+	if (e->reg[0] != SND_SOC_NOPM)
+		reg_val = snd_soc_read(codec, e->reg[0]);
 	else
 		reg_val = dapm_kcontrol_get_value(kcontrol);
 
-	val = (reg_val >> e->shift_l) & e->mask;
+	val = (reg_val >> e->shift_l) & e->mask[0];
 	ucontrol->value.enumerated.item[0] = snd_soc_enum_val_to_item(e, val);
 	if (e->shift_l != e->shift_r) {
-		val = (reg_val >> e->shift_r) & e->mask;
+		val = (reg_val >> e->shift_r) & e->mask[0];
 		val = snd_soc_enum_val_to_item(e, val);
 		ucontrol->value.enumerated.item[1] = val;
 	}
@@ -2945,25 +2945,25 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 		return -EINVAL;
 
 	val = snd_soc_enum_item_to_val(e, item[0]) << e->shift_l;
-	mask = e->mask << e->shift_l;
+	mask = e->mask[0] << e->shift_l;
 	if (e->shift_l != e->shift_r) {
 		if (item[1] > e->items)
 			return -EINVAL;
 		val |= snd_soc_enum_item_to_val(e, item[1]) << e->shift_l;
-		mask |= e->mask << e->shift_r;
+		mask |= e->mask[0] << e->shift_r;
 	}
 
 	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
 
-	if (e->reg != SND_SOC_NOPM)
-		change = snd_soc_test_bits(codec, e->reg, mask, val);
+	if (e->reg[0] != SND_SOC_NOPM)
+		change = snd_soc_test_bits(codec, e->reg[0], mask, val);
 	else
 		change = dapm_kcontrol_set_value(kcontrol, val);
 
 	if (change) {
-		if (e->reg != SND_SOC_NOPM) {
+		if (e->reg[0] != SND_SOC_NOPM) {
 			update.kcontrol = kcontrol;
-			update.reg = e->reg;
+			update.reg = e->reg[0];
 			update.mask = mask;
 			update.val = val;
 			card->update = &update;
@@ -2984,6 +2984,123 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 EXPORT_SYMBOL_GPL(snd_soc_dapm_put_enum_double);
 
 /**
+ * snd_soc_dapm_get_enum_wide - dapm semi enumerated multiple registers
+ *					mixer get callback
+ * @kcontrol: mixer control
+ * @ucontrol: control element information
+ *
+ * Callback to get the value of a dapm semi enumerated multiple register mixer
+ * control.
+ *
+ * semi enumerated multiple registers mixer:
+ * the mixer has multiple registers to set the enumerated items. The enumerated
+ * items are referred as values.
+ * Can be used for handling bit field coded enumeration for example.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_dapm_get_enum_wide(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+	unsigned int reg_val, val, bit_pos = 0, reg_idx;
+
+	for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
+		reg_val = snd_soc_read(codec, e->reg[reg_idx]);
+		val = reg_val & e->mask[reg_idx];
+		if (val != 0) {
+			bit_pos = ffs(val) + (e->reg_width * reg_idx);
+			break;
+		}
+	}
+
+	ucontrol->value.enumerated.item[0] =
+			snd_soc_enum_val_to_item(e, bit_pos);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_get_enum_wide);
+
+/**
+ * snd_soc_dapm_put_enum_wide - dapm semi enumerated multiple registers
+ *					mixer put callback
+ * @kcontrol: mixer control
+ * @ucontrol: control element information
+ *
+ * Callback to put the value of a dapm semi enumerated multiple register mixer
+ * control.
+ *
+ * semi enumerated multiple registers mixer:
+ * the mixer has multiple registers to set the enumerated items. The enumerated
+ * items are referred as values.
+ * Can be used for handling bit field coded enumeration for example.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_dapm_put_enum_wide(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
+	struct snd_soc_card *card = codec->card;
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+	unsigned int *item = ucontrol->value.enumerated.item;
+	unsigned int change = 0, reg_idx = 0, value, bit_pos;
+	struct snd_soc_dapm_update update;
+	int ret = 0, reg_val = 0, i;
+
+	if (item[0] >= e->items)
+		return -EINVAL;
+
+	value = snd_soc_enum_item_to_val(e, item[0]);
+
+	if (value) {
+		/* get the register index and value to set */
+		reg_idx = (value - 1) / e->reg_width;
+		bit_pos = (value - 1) % e->reg_width;
+		reg_val = BIT(bit_pos);
+	}
+
+	for (i = 0; i < e->num_regs; i++) {
+		if (i == reg_idx) {
+			change = snd_soc_test_bits(codec, e->reg[i],
+							e->mask[i], reg_val);
+
+		} else {
+			/* accumulate the change to update the DAPM path
+			    when none is selected */
+			change += snd_soc_test_bits(codec, e->reg[i],
+							e->mask[i], 0);
+
+			/* clear the register when not selected */
+			snd_soc_write(codec, e->reg[i], 0);
+		}
+	}
+
+	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+
+	if (change) {
+		update.kcontrol = kcontrol;
+		update.reg = e->reg[reg_idx];
+		update.mask = e->mask[reg_idx];
+		update.val = reg_val;
+		card->update = &update;
+
+		ret = soc_dapm_mux_update_power(card, kcontrol, item[0], e);
+
+		card->update = NULL;
+	}
+
+	mutex_unlock(&card->dapm_mutex);
+
+	if (ret > 0)
+		soc_dpcm_runtime_update(card);
+
+	return change;
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_put_enum_wide);
+
+/**
  * snd_soc_dapm_info_pin_switch - Info for a pin switch
  *
  * @kcontrol: mixer control
-- 
1.7.9.5

