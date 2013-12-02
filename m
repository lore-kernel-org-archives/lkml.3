Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3LBTne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:43:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39581 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3LBTSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 161/212] ALSA: hda - Create Headhpone Mic Jack Mode when really needed
Date: Mon,  2 Dec 2013 11:15:52 -0800
Message-Id: <20131202191305.733998340@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -2506,12 +2506,8 @@ static int create_out_jack_modes(struct
 
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
@@ -2784,9 +2780,6 @@ static int create_hp_mic_jack_mode(struc
 	struct hda_gen_spec *spec = codec->spec;
 	struct snd_kcontrol_new *knew;
 
-	if (get_out_jack_num_items(codec, pin) <= 1 &&
-	    get_in_jack_num_items(codec, pin) <= 1)
-		return 0; /* no need */
 	knew = snd_hda_gen_add_kctl(spec, "Headphone Mic Jack Mode",
 				    &hp_mic_jack_mode_enum);
 	if (!knew)
@@ -4383,6 +4376,17 @@ int snd_hda_gen_parse_auto_config(struct
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


