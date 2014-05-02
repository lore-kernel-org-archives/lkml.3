Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169AbaEBPmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:42:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43835 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaEBPmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:42:00 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Kailang Yang <kailang@realtek.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 060/151] ALSA: hda/realtek - Restore default value for ALC283
Date: Fri,  2 May 2014 08:37:28 -0700
Message-Id: <1399045139-4531-61-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

commit 6bd55b04fe05cb26094b0fe494c7a207e6c0c36e upstream.

Restore the registers to prevent the abnormal digital power supply
rising ratio/sequence to the codec and causing the incorrect default
codec register restoration during initialization.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=71861
Signed-off-by: Kailang Yang <kailang@realtek.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 85 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 8a7eeac..4afa7a0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2731,6 +2731,89 @@ static void alc269_shutup(struct hda_codec *codec)
 	snd_hda_shutup_pins(codec);
 }
 
+static void alc283_restore_default_value(struct hda_codec *codec)
+{
+	int val;
+
+	/* Power Down Control */
+	alc_write_coef_idx(codec, 0x03, 0x0002);
+	/* FIFO and filter clock */
+	alc_write_coef_idx(codec, 0x05, 0x0700);
+	/* DMIC control */
+	alc_write_coef_idx(codec, 0x07, 0x0200);
+	/* Analog clock */
+	val = alc_read_coef_idx(codec, 0x06);
+	alc_write_coef_idx(codec, 0x06, (val & ~0x00f0) | 0x0);
+	/* JD */
+	val = alc_read_coef_idx(codec, 0x08);
+	alc_write_coef_idx(codec, 0x08, (val & ~0xfffc) | 0x0c2c);
+	/* JD offset1 */
+	alc_write_coef_idx(codec, 0x0a, 0xcccc);
+	/* JD offset2 */
+	alc_write_coef_idx(codec, 0x0b, 0xcccc);
+	/* LDO1/2/3, DAC/ADC */
+	alc_write_coef_idx(codec, 0x0e, 0x6fc0);
+	/* JD */
+	val = alc_read_coef_idx(codec, 0x0f);
+	alc_write_coef_idx(codec, 0x0f, (val & ~0xf800) | 0x1000);
+	/* Capless */
+	val = alc_read_coef_idx(codec, 0x10);
+	alc_write_coef_idx(codec, 0x10, (val & ~0xfc00) | 0x0c00);
+	/* Class D test 4 */
+	alc_write_coef_idx(codec, 0x3a, 0x0);
+	/* IO power down directly */
+	val = alc_read_coef_idx(codec, 0x0c);
+	alc_write_coef_idx(codec, 0x0c, (val & ~0xfe00) | 0x0);
+	/* ANC */
+	alc_write_coef_idx(codec, 0x22, 0xa0c0);
+	/* AGC MUX */
+	val = alc_read_coefex_idx(codec, 0x53, 0x01);
+	alc_write_coefex_idx(codec, 0x53, 0x01, (val & ~0x000f) | 0x0008);
+	/* DAC simple content protection */
+	val = alc_read_coef_idx(codec, 0x1d);
+	alc_write_coef_idx(codec, 0x1d, (val & ~0x00e0) | 0x0);
+	/* ADC simple content protection */
+	val = alc_read_coef_idx(codec, 0x1f);
+	alc_write_coef_idx(codec, 0x1f, (val & ~0x00e0) | 0x0);
+	/* DAC ADC Zero Detection */
+	alc_write_coef_idx(codec, 0x21, 0x8804);
+	/* PLL */
+	alc_write_coef_idx(codec, 0x2e, 0x2902);
+	/* capless control 2 */
+	alc_write_coef_idx(codec, 0x33, 0xa080);
+	/* capless control 3 */
+	alc_write_coef_idx(codec, 0x34, 0x3400);
+	/* capless control 4 */
+	alc_write_coef_idx(codec, 0x35, 0x2f3e);
+	/* capless control 5 */
+	alc_write_coef_idx(codec, 0x36, 0x0);
+	/* class D test 2 */
+	val = alc_read_coef_idx(codec, 0x38);
+	alc_write_coef_idx(codec, 0x38, (val & ~0x0fff) | 0x0900);
+	/* class D test 3 */
+	alc_write_coef_idx(codec, 0x39, 0x110a);
+	/* class D test 5 */
+	val = alc_read_coef_idx(codec, 0x3b);
+	alc_write_coef_idx(codec, 0x3b, (val & ~0x00f8) | 0x00d8);
+	/* class D test 6 */
+	alc_write_coef_idx(codec, 0x3c, 0x0014);
+	/* classD OCP */
+	alc_write_coef_idx(codec, 0x3d, 0xc2ba);
+	/* classD pure DC test */
+	val = alc_read_coef_idx(codec, 0x42);
+	alc_write_coef_idx(codec, 0x42, (val & ~0x0f80) | 0x0);
+	/* test mode */
+	alc_write_coef_idx(codec, 0x49, 0x0);
+	/* Class D DC enable */
+	val = alc_read_coef_idx(codec, 0x40);
+	alc_write_coef_idx(codec, 0x40, (val & ~0xf800) | 0x9800);
+	/* DC offset */
+	val = alc_read_coef_idx(codec, 0x42);
+	alc_write_coef_idx(codec, 0x42, (val & ~0xf000) | 0x2000);
+	/* Class D amp control */
+	alc_write_coef_idx(codec, 0x37, 0xfc06);
+}
+
 static void alc283_init(struct hda_codec *codec)
 {
 	struct alc_spec *spec = codec->spec;
@@ -2738,6 +2821,8 @@ static void alc283_init(struct hda_codec *codec)
 	bool hp_pin_sense;
 	int val;
 
+	alc283_restore_default_value(codec);
+
 	if (!hp_pin)
 		return;
 	hp_pin_sense = snd_hda_jack_detect(codec, hp_pin);
-- 
1.9.1

