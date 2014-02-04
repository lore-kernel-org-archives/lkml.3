Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934258AbaBDVJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:09:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56911 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaBDVJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 121/133] ALSA: hda - Dont set indep_hp flag for old AD codecs
Date: Tue,  4 Feb 2014 13:08:42 -0800
Message-Id: <20140204210740.446397681@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit cbd209f41ea5f39394de5c1fe2dd9aa54a9c5744 upstream.

Some old AD codecs don't like the independent HP handling, either it
contains a single DAC (AD1981) or it mandates the mixer routing
(AD1986A).  This patch removes the indep_hp flag for such codecs.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=68081
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -171,7 +171,7 @@ static const struct hda_codec_ops ad198x
 };
 
 
-static int ad198x_parse_auto_config(struct hda_codec *codec)
+static int ad198x_parse_auto_config(struct hda_codec *codec, bool indep_hp)
 {
 	struct ad198x_spec *spec = codec->spec;
 	struct auto_pin_cfg *cfg = &spec->gen.autocfg;
@@ -181,7 +181,7 @@ static int ad198x_parse_auto_config(stru
 	codec->no_trigger_sense = 1;
 	codec->no_sticky_stream = 1;
 
-	spec->gen.indep_hp = 1;
+	spec->gen.indep_hp = indep_hp;
 
 	err = snd_hda_parse_pin_defcfg(codec, cfg, NULL, 0);
 	if (err < 0)
@@ -362,7 +362,7 @@ static int patch_ad1986a(struct hda_code
 			   ad1986a_fixups);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
 
-	err = ad198x_parse_auto_config(codec);
+	err = ad198x_parse_auto_config(codec, false);
 	if (err < 0) {
 		snd_hda_gen_free(codec);
 		return err;
@@ -464,7 +464,7 @@ static int patch_ad1983(struct hda_codec
 
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
-	err = ad198x_parse_auto_config(codec);
+	err = ad198x_parse_auto_config(codec, false);
 	if (err < 0)
 		goto error;
 	err = ad1983_add_spdif_mux_ctl(codec);
@@ -564,7 +564,7 @@ static int patch_ad1981(struct hda_codec
 	snd_hda_pick_fixup(codec, NULL, ad1981_fixup_tbl, ad1981_fixups);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
 
-	err = ad198x_parse_auto_config(codec);
+	err = ad198x_parse_auto_config(codec, false);
 	if (err < 0)
 		goto error;
 	err = ad1983_add_spdif_mux_ctl(codec);
@@ -890,7 +890,7 @@ static int patch_ad1988(struct hda_codec
 	snd_hda_pick_fixup(codec, ad1988_fixup_models, NULL, ad1988_fixups);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
 
-	err = ad198x_parse_auto_config(codec);
+	err = ad198x_parse_auto_config(codec, true);
 	if (err < 0)
 		goto error;
 	err = ad1988_add_spdif_mux_ctl(codec);
@@ -1064,7 +1064,7 @@ static int patch_ad1884(struct hda_codec
 	snd_hda_pick_fixup(codec, NULL, ad1884_fixup_tbl, ad1884_fixups);
 	snd_hda_apply_fixup(codec, HDA_FIXUP_ACT_PRE_PROBE);
 
-	err = ad198x_parse_auto_config(codec);
+	err = ad198x_parse_auto_config(codec, true);
 	if (err < 0)
 		goto error;
 	err = ad1983_add_spdif_mux_ctl(codec);
@@ -1106,7 +1106,7 @@ static int patch_ad1882(struct hda_codec
 	spec->gen.mixer_merge_nid = 0x21;
 	spec->gen.beep_nid = 0x10;
 	set_beep_amp(spec, 0x10, 0, HDA_OUTPUT);
-	err = ad198x_parse_auto_config(codec);
+	err = ad198x_parse_auto_config(codec, true);
 	if (err < 0)
 		goto error;
 	err = ad1988_add_spdif_mux_ctl(codec);


