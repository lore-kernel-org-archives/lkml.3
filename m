Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161388Ab3LFNBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:01:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161334Ab3LFNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:00:49 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 060/272] ALSA: hda - Create Headhpone Mic Jack Mode when really needed
Date: Fri,  6 Dec 2013 12:55:49 +0000
Message-Id: <1386334761-25517-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ced4cefc75fdb8be95eaee325ad0f6b2fc0a484b upstream.

When a headphone jack is configurable as input, the generic parser
tries to make it retaskable as Headphone Mic.  The switching can be
done smoothly if Capture Source control exists (i.e. there is another
input source).  Or when user explicitly enables the creation of jack
mode controls, "Headhpone Mic Jack Mode" will be created accordingly.

However, if the headphone mic is the only input source, we have to
create "Headphone Mic Jack Mode" control because there is no capture
source selection.  Otherwise, the generic parser assumes that the
input is constantly enabled, thus the headphone is permanently set
as input.  This situation happens on the old MacBook Airs where no
input is supported properly, for example.

This patch fixes the problem: now "Headphone Mic Jack Mode" is created
when such an input selection isn't possible.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=65681
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_generic.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index 9e44e4a..c443451 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -2476,12 +2476,8 @@ static int create_out_jack_modes(struct hda_codec *codec, int num_pins,
 
 	for (i = 0; i < num_pins; i++) {
 		hda_nid_t pin = pins[i];
-		if (pin == spec->hp_mic_pin) {
-			int ret = create_hp_mic_jack_mode(codec, pin);
-			if (ret < 0)
-				return ret;
+		if (pin == spec->hp_mic_pin)
 			continue;
-		}
 		if (get_out_jack_num_items(codec, pin) > 1) {
 			struct snd_kcontrol_new *knew;
 			char name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
@@ -2754,9 +2750,6 @@ static int create_hp_mic_jack_mode(struct hda_codec *codec, hda_nid_t pin)
 	struct hda_gen_spec *spec = codec->spec;
 	struct snd_kcontrol_new *knew;
 
-	if (get_out_jack_num_items(codec, pin) <= 1 &&
-	    get_in_jack_num_items(codec, pin) <= 1)
-		return 0; /* no need */
 	knew = snd_hda_gen_add_kctl(spec, "Headphone Mic Jack Mode",
 				    &hp_mic_jack_mode_enum);
 	if (!knew)
@@ -4332,6 +4325,17 @@ int snd_hda_gen_parse_auto_config(struct hda_codec *codec,
 	if (err < 0)
 		return err;
 
+	/* create "Headphone Mic Jack Mode" if no input selection is
+	 * available (or user specifies add_jack_modes hint)
+	 */
+	if (spec->hp_mic_pin &&
+	    (spec->auto_mic || spec->input_mux.num_items == 1 ||
+	     spec->add_jack_modes)) {
+		err = create_hp_mic_jack_mode(codec, spec->hp_mic_pin);
+		if (err < 0)
+			return err;
+	}
+
 	if (spec->add_jack_modes) {
 		if (cfg->line_out_type != AUTO_PIN_SPEAKER_OUT) {
 			err = create_out_jack_modes(codec, cfg->line_outs,
-- 
1.8.3.2

