Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbaCZADJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 20:03:09 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:17149 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaCZADH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 20:03:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 25 Mar 2014 16:59:00 -0700
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: <lgirdwood@gmail.com>, <broonie@kernel.org>, <swarren@wwwdotorg.org>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Arun Shamanna Lakshmi <aruns@nvidia.com>,
        Songhee Baek <sbaek@nvidia.com>
Subject: [PATCH] ASoC: Add support for multi register mux
Date: Tue, 25 Mar 2014 17:02:35 -0700
Message-ID: <1395792156-4178-1-git-send-email-aruns@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the mux uses 1 bit position per input, and requires to set one
single bit at a time, then an N bit register can support up to N
inputs. In more recent Tegra chips, we have at least greater than
64 inputs which requires at least 2 .reg fields in struct soc_enum.

Signed-off-by: Arun Shamanna Lakshmi <aruns@nvidia.com>
Signed-off-by: Songhee Baek <sbaek@nvidia.com>
---
 include/sound/soc-dapm.h |   20 +++++-
 include/sound/soc.h      |   44 ++++++++++---
 sound/soc/soc-core.c     |  118 +++++++++++++++++++++++++++++++++--
 sound/soc/soc-dapm.c     |  155 +++++++++++++++++++++++++++++++++++++++-------
 4 files changed, 300 insertions(+), 37 deletions(-)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index ef78f56..324de75 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -315,6 +315,12 @@ struct device;
 	.private_value = (unsigned long)&xenum }
 #define SOC_DAPM_VALUE_ENUM(xname, xenum) \
 	SOC_DAPM_ENUM(xname, xenum)
+#define SOC_DAPM_VALUE_ENUM_WIDE(xname, xenum) \
+{	.iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, \
+	.info = snd_soc_info_enum_wide, \
+	.get = snd_soc_dapm_get_value_enum_wide, \
+	.put = snd_soc_dapm_put_value_enum_wide, \
+	.private_value = (unsigned long)&xenum }
 #define SOC_DAPM_PIN_SWITCH(xname) \
 {	.iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname " Switch", \
 	.info = snd_soc_dapm_info_pin_switch, \
@@ -352,6 +358,9 @@ struct device;
 /* regulator widget flags */
 #define SND_SOC_DAPM_REGULATOR_BYPASS     0x1     /* bypass when disabled */
 
+/* maximum number of registers to update */
+#define SOC_DAPM_UPDATE_MAX_REGS 3
+
 struct snd_soc_dapm_widget;
 enum snd_soc_dapm_type;
 struct snd_soc_dapm_path;
@@ -378,6 +387,10 @@ int snd_soc_dapm_get_enum_double(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
 int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
+int snd_soc_dapm_get_value_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol);
+int snd_soc_dapm_put_value_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol);
 int snd_soc_dapm_info_pin_switch(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_info *uinfo);
 int snd_soc_dapm_get_pin_switch(struct snd_kcontrol *kcontrol,
@@ -590,9 +603,10 @@ struct snd_soc_dapm_widget {
 
 struct snd_soc_dapm_update {
 	struct snd_kcontrol *kcontrol;
-	int reg;
-	int mask;
-	int val;
+	int reg[SOC_DAPM_UPDATE_MAX_REGS];
+	int mask[SOC_DAPM_UPDATE_MAX_REGS];
+	int val[SOC_DAPM_UPDATE_MAX_REGS];
+	int num_regs;
 };
 
 /* DAPM context */
diff --git a/include/sound/soc.h b/include/sound/soc.h
index 0b83168..67097c6 100644
--- a/include/sound/soc.h
+++ b/include/sound/soc.h
@@ -177,16 +177,22 @@
 		{.reg = xreg, .min = xmin, .max = xmax, \
 		 .platform_max = xmax} }
 #define SOC_ENUM_DOUBLE(xreg, xshift_l, xshift_r, xitems, xtexts) \
-{	.reg = xreg, .shift_l = xshift_l, .shift_r = xshift_r, \
+{	.reg[0] = xreg, .shift_l = xshift_l, .shift_r = xshift_r, \
 	.items = xitems, .texts = xtexts, \
-	.mask = xitems ? roundup_pow_of_two(xitems) - 1 : 0}
+	.mask[0] = xitems ? roundup_pow_of_two(xitems) - 1 : 0, .num_regs = 1 }
 #define SOC_ENUM_SINGLE(xreg, xshift, xitems, xtexts) \
 	SOC_ENUM_DOUBLE(xreg, xshift, xshift, xitems, xtexts)
 #define SOC_ENUM_SINGLE_EXT(xitems, xtexts) \
 {	.items = xitems, .texts = xtexts }
+#define SOC_VALUE_ENUM_TRIPLE(reg1, reg2, reg3, mask1, mask2, mask3, \
+				nreg, nmax, xtexts, xvalues) \
+{	.reg[0] = reg1, .reg[1] = reg2, .reg[2] = reg3, \
+	.mask[0] = mask1, .mask[1] = mask2, .mask[2] = mask3, \
+	.num_regs = nreg, .items = nmax, .texts = xtexts, .values = xvalues }
 #define SOC_VALUE_ENUM_DOUBLE(xreg, xshift_l, xshift_r, xmask, xitems, xtexts, xvalues) \
-{	.reg = xreg, .shift_l = xshift_l, .shift_r = xshift_r, \
-	.mask = xmask, .items = xitems, .texts = xtexts, .values = xvalues}
+{	.reg[0] = xreg, .shift_l = xshift_l, .shift_r = xshift_r, \
+	.mask[0] = xmask, .items = xitems, .texts = xtexts, .values = xvalues,\
+	.num_regs = 1 }
 #define SOC_VALUE_ENUM_SINGLE(xreg, xshift, xmask, xnitmes, xtexts, xvalues) \
 	SOC_VALUE_ENUM_DOUBLE(xreg, xshift, xshift, xmask, xnitmes, xtexts, xvalues)
 #define SOC_ENUM_SINGLE_VIRT(xitems, xtexts) \
@@ -198,6 +204,12 @@
 	.private_value = (unsigned long)&xenum }
 #define SOC_VALUE_ENUM(xname, xenum) \
 	SOC_ENUM(xname, xenum)
+#define SOC_VALUE_ENUM_WIDE(xname, xenum) \
+{	.iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname,\
+	.info = snd_soc_info_enum_wide, \
+	.get = snd_soc_get_value_enum_wide, \
+	.put = snd_soc_put_value_enum_wide, \
+	.private_value = (unsigned long)&xenum }
 #define SOC_SINGLE_EXT(xname, xreg, xshift, xmax, xinvert,\
 	 xhandler_get, xhandler_put) \
 {	.iface = SNDRV_CTL_ELEM_IFACE_MIXER, .name = xname, \
@@ -297,7 +309,13 @@
 	SOC_VALUE_ENUM_DOUBLE_DECL(name, xreg, xshift, xshift, xmask, xtexts, xvalues)
 #define SOC_ENUM_SINGLE_VIRT_DECL(name, xtexts) \
 	const struct soc_enum name = SOC_ENUM_SINGLE_VIRT(ARRAY_SIZE(xtexts), xtexts)
-
+#define SOC_VALUE_ENUM_TRIPLE_DECL(name, reg1, reg2, reg3, \
+				mask1, mask2, mask3, \
+				xtexts, xvalues) \
+	const struct soc_enum name = SOC_VALUE_ENUM_TRIPLE(reg1, reg2, reg3, \
+						mask1, mask2, mask3, 3, \
+						ARRAY_SIZE(xtexts), \
+						xtexts, xvalues)
 /*
  * Component probe and remove ordering levels for components with runtime
  * dependencies.
@@ -309,6 +327,11 @@
 #define SND_SOC_COMP_ORDER_LAST		2
 
 /*
+ * The maximum number of registers in soc_enum
+ */
+#define SOC_ENUM_MAX_REGS	3
+
+/*
  * Bias levels
  *
  * @ON:      Bias is fully on for audio playback and capture operations.
@@ -507,6 +530,12 @@ int snd_soc_get_enum_double(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
 int snd_soc_put_enum_double(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol);
+int snd_soc_info_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_info *uinfo);
+int snd_soc_get_value_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol);
+int snd_soc_put_value_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol);
 int snd_soc_info_volsw(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_info *uinfo);
 #define snd_soc_info_bool_ext		snd_ctl_boolean_mono_info
@@ -1098,13 +1127,14 @@ struct soc_mreg_control {
 
 /* enumerated kcontrol */
 struct soc_enum {
-	int reg;
+	int reg[SOC_ENUM_MAX_REGS];
 	unsigned char shift_l;
 	unsigned char shift_r;
 	unsigned int items;
-	unsigned int mask;
+	unsigned int mask[SOC_ENUM_MAX_REGS];
 	const char * const *texts;
 	const unsigned int *values;
+	unsigned int num_regs;
 };
 
 /**
diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index caebd63..e47479d 100644
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
@@ -2636,19 +2636,125 @@ int snd_soc_put_enum_double(struct snd_kcontrol *kcontrol,
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
 
 /**
+ * snd_soc_info_enum_wide - enumerated mulitple register mixer info callback
+ * @kcontrol: mixer control
+ * @uinfo: control element information
+ *
+ * Callback to provide information about a enumerated multiple register
+ * mixer control.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_info_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_info *uinfo)
+{
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+
+	uinfo->type = SNDRV_CTL_ELEM_TYPE_ENUMERATED;
+	uinfo->count = 1;
+	uinfo->value.enumerated.items = e->items;
+
+	if (uinfo->value.enumerated.item > e->items - 1)
+		uinfo->value.enumerated.item = e->items - 1;
+	strcpy(uinfo->value.enumerated.name,
+		e->texts[uinfo->value.enumerated.item]);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_info_enum_wide);
+
+/**
+ * snd_soc_get_value_enum_wide - semi enumerated multiple registers mixer
+ *				get callback
+ * @kcontrol: mixer control
+ * @ucontrol: control element information
+ *
+ * Callback to get the value of a semi enumerated mutiple registers mixer.
+ *
+ * Mutiple semi enumerated mixer: the mixer has multiple registers to set the
+ * values. The enumerated items are referred as values. Can be
+ * used for handling bitfield coded enumeration for example.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_get_value_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+	unsigned int val, i, reg_idx;
+	bool match = true;
+
+	for (i = 0; i < e->items; i++) {
+		match = true;
+		for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
+			val = snd_soc_read(codec, e->reg[reg_idx]);
+			if (val !=  e->values[i * e->num_regs + reg_idx]) {
+				match = false;
+				break;
+			}
+		}
+		if (match)
+			break;
+	}
+	if (!match) {
+		dev_err(codec->dev, "ASoC: Failed to find matched enum value\n");
+		return -EINVAL;
+	} else
+		ucontrol->value.enumerated.item[0] = i;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_get_value_enum_wide);
+
+/**
+ * snd_soc_get_value_enum_wide - semi enumerated multiple mixer put callback
+ * @kcontrol: mixer control
+ * @ucontrol: control element information
+ *
+ * Callback to put the value of a multiple semi enumerated mixer.
+ *
+ * Mutiple semi enumerated mixer: the mixer has multiple registers to set the
+ * values. The enumerated items are referred as values. Can be
+ * used for handling bitfield coded enumeration for example.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_put_value_enum_wide(struct snd_kcontrol *kcontrol,
+	struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_kcontrol_chip(kcontrol);
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+	unsigned int val, reg_idx, item;
+	int ret;
+
+	if (ucontrol->value.enumerated.item[0] > e->items - 1)
+		return -EINVAL;
+	item = ucontrol->value.enumerated.item[0];
+	for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
+		val = e->values[item * e->num_regs + reg_idx];
+		ret = snd_soc_update_bits_locked(codec, e->reg[reg_idx],
+						e->mask[reg_idx], val);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_put_value_enum_wide);
+
+/**
  * snd_soc_read_signed - Read a codec register and interprete as signed value
  * @codec: codec
  * @reg: Register to read
diff --git a/sound/soc/soc-dapm.c b/sound/soc/soc-dapm.c
index c8a780d..22ca178 100644
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
@@ -1553,7 +1553,7 @@ static void dapm_widget_update(struct snd_soc_card *card)
 	struct snd_soc_dapm_update *update = card->update;
 	struct snd_soc_dapm_widget_list *wlist;
 	struct snd_soc_dapm_widget *w = NULL;
-	unsigned int wi;
+	unsigned int wi, update_idx;
 	int ret;
 
 	if (!update || !dapm_kcontrol_is_powered(update->kcontrol))
@@ -1575,8 +1575,10 @@ static void dapm_widget_update(struct snd_soc_card *card)
 	if (!w)
 		return;
 
-	ret = soc_widget_update_bits_locked(w, update->reg, update->mask,
-				  update->val);
+	for (update_idx = 0; update_idx < update->num_regs; update_idx++)
+		ret = soc_widget_update_bits_locked(w, update->reg[update_idx],
+						update->mask[update_idx],
+						update->val[update_idx]);
 	if (ret < 0)
 		dev_err(w->dapm->dev, "ASoC: %s DAPM update failed: %d\n",
 			w->name, ret);
@@ -2866,9 +2868,10 @@ int snd_soc_dapm_put_volsw(struct snd_kcontrol *kcontrol,
 	if (change) {
 		if (reg != SND_SOC_NOPM) {
 			update.kcontrol = kcontrol;
-			update.reg = reg;
-			update.mask = mask;
-			update.val = val;
+			update.reg[0] = reg;
+			update.mask[0] = mask;
+			update.val[0] = val;
+			update.num_regs = 1;
 
 			card->update = &update;
 		}
@@ -2903,15 +2906,15 @@ int snd_soc_dapm_get_enum_double(struct snd_kcontrol *kcontrol,
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
@@ -2945,27 +2948,28 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
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
-			update.mask = mask;
-			update.val = val;
+			update.reg[0] = e->reg[0];
+			update.mask[0] = mask;
+			update.val[0] = val;
+			update.num_regs = 1;
 			card->update = &update;
 		}
 
@@ -2984,6 +2988,115 @@ int snd_soc_dapm_put_enum_double(struct snd_kcontrol *kcontrol,
 EXPORT_SYMBOL_GPL(snd_soc_dapm_put_enum_double);
 
 /**
+ * snd_soc_dapm_get_value_enum_wide - dapm semi enumerated multiple registers
+ *					mixer get callback
+ * @kcontrol: mixer control
+ * @ucontrol: control element information
+ *
+ * Callback to get the value of a dapm semi enumerated multiple register mixer
+ * control.
+ *
+ * semi enumerated multiple registers mixer:
+ *  the mixer has multiple regsters to set the enumerated items. The enumerated
+ *  iteams are referred as values.
+ *  Can be used for handling bitfield coded enumeration for example.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_dapm_get_value_enum_wide(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+	unsigned int reg_val, i, reg_idx;
+	bool match = true;
+
+	for (i = 0; i < e->items; i++) {
+		match = true;
+		for (reg_idx = 0; reg_idx < e->num_regs; reg_idx++) {
+			reg_val = snd_soc_read(codec, e->reg[reg_idx]);
+			if (reg_val !=  e->values[i * e->num_regs + reg_idx]) {
+				match = false;
+				break;
+			}
+		}
+		if (match)
+			break;
+	}
+	if (!match) {
+		dev_err(codec->dev, "ASoC: Failed to find matched enum value\n");
+		return -EINVAL;
+	} else
+		ucontrol->value.enumerated.item[0] = i;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_get_value_enum_wide);
+
+/**
+ * snd_soc_dapm_put_value_enum_wide - dapm semi enumerated multiple registers
+ *					mixer put callback
+ * @kcontrol: mixer control
+ * @ucontrol: control element information
+ *
+ * Callback to put the value of a dapm semi enumerated multiple register mixer
+ * control.
+ *
+ * semi enumerated multiple registers mixer:
+ *  the mixer has multiple regsters to set the enumerated items. The enumerated
+ *  iteams are referred as values.
+ *  Can be used for handling bitfield coded enumeration for example.
+ *
+ * Returns 0 for success.
+ */
+int snd_soc_dapm_put_value_enum_wide(struct snd_kcontrol *kcontrol,
+			struct snd_ctl_elem_value *ucontrol)
+{
+	struct snd_soc_codec *codec = snd_soc_dapm_kcontrol_codec(kcontrol);
+	struct snd_soc_card *card = codec->card;
+	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
+	unsigned int value, item, old, reg_idx;
+	struct snd_soc_dapm_update update;
+	int wi, update_idx;
+	int ret = 0;
+
+	if (ucontrol->value.enumerated.item[0] > e->items - 1)
+		return -EINVAL;
+
+	item = ucontrol->value.enumerated.item[0];
+
+	mutex_lock_nested(&card->dapm_mutex, SND_SOC_DAPM_CLASS_RUNTIME);
+
+	for (reg_idx = 0, update_idx = 0; reg_idx < e->num_regs; reg_idx++) {
+		value = e->values[item * e->num_regs + reg_idx];
+		old = snd_soc_read(codec, e->reg[reg_idx]);
+		if (value != old) {
+			update.reg[update_idx] = e->reg[reg_idx];
+			update.mask[update_idx] = e->mask[reg_idx];
+			update.val[update_idx] = value;
+			update.num_regs = ++update_idx;
+		}
+	}
+
+	if (update_idx) {
+		update.kcontrol = kcontrol;
+		card->update = &update;
+
+		ret = soc_dapm_mux_update_power(card, kcontrol, item, e);
+
+		card->update = NULL;
+	}
+
+	mutex_unlock(&card->dapm_mutex);
+
+	if (ret > 0)
+		soc_dpcm_runtime_update(card);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snd_soc_dapm_put_value_enum_wide);
+
+/**
  * snd_soc_dapm_info_pin_switch - Info for a pin switch
  *
  * @kcontrol: mixer control
-- 
1.7.9.5

