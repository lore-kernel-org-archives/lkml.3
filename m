Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618Ab3EQW1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:27:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756464Ab3EQVhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 011/102] ALSA: hda - Fix 3.9 regression of EAPD init on Conexant codecs
Date: Fri, 17 May 2013 14:35:26 -0700
Message-Id: <20130517213245.502120713@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ff359b14919c379a365233aa2e1dd469efac8ce8 upstream.

The older Conexant codecs have up to two EAPDs and these are supposed
to be rather statically turned on.  The new generic parser code
assumes the dynamic on/off per path usage, thus it resulted in the
silent output on some machines.

This patch fixes the problem by simply assuming the static EAPD on for
such old Conexant codecs as we did until 3.8 kernel.

Reported-and-tested-by: Christopher K. <c.krooss@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_conexant.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -64,6 +64,7 @@ struct conexant_spec {
 	/* extra EAPD pins */
 	unsigned int num_eapds;
 	hda_nid_t eapds[4];
+	bool dynamic_eapd;
 
 #ifdef ENABLE_CXT_STATIC_QUIRKS
 	const struct snd_kcontrol_new *mixers[5];
@@ -3152,7 +3153,7 @@ static void cx_auto_parse_eapd(struct hd
 	 * thus it might control over all pins.
 	 */
 	if (spec->num_eapds > 2)
-		spec->gen.own_eapd_ctl = 1;
+		spec->dynamic_eapd = 1;
 }
 
 static void cx_auto_turn_eapd(struct hda_codec *codec, int num_pins,
@@ -3191,6 +3192,15 @@ static int cx_auto_build_controls(struct
 	return 0;
 }
 
+static int cx_auto_init(struct hda_codec *codec)
+{
+	struct conexant_spec *spec = codec->spec;
+	snd_hda_gen_init(codec);
+	if (!spec->dynamic_eapd)
+		cx_auto_turn_eapd(codec, spec->num_eapds, spec->eapds, true);
+	return 0;
+}
+
 static void cx_auto_free(struct hda_codec *codec)
 {
 	snd_hda_detach_beep_device(codec);
@@ -3200,7 +3210,7 @@ static void cx_auto_free(struct hda_code
 static const struct hda_codec_ops cx_auto_patch_ops = {
 	.build_controls = cx_auto_build_controls,
 	.build_pcms = snd_hda_gen_build_pcms,
-	.init = snd_hda_gen_init,
+	.init = cx_auto_init,
 	.free = cx_auto_free,
 	.unsol_event = snd_hda_jack_unsol_event,
 #ifdef CONFIG_PM
@@ -3350,7 +3360,8 @@ static int patch_conexant_auto(struct hd
 
 	cx_auto_parse_beep(codec);
 	cx_auto_parse_eapd(codec);
-	if (spec->gen.own_eapd_ctl)
+	spec->gen.own_eapd_ctl = 1;
+	if (spec->dynamic_eapd)
 		spec->gen.vmaster_mute.hook = cx_auto_vmaster_hook;
 
 	switch (codec->vendor_id) {


