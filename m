Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084Ab3GWWxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:53:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab3GWW1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 026/103] ALSA: hda - Fix EAPD vmaster hook for AD1884 & co
Date: Tue, 23 Jul 2013 15:25:37 -0700
Message-Id: <20130723220421.500459958@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 8f0b3b7e222383a21f7d58bd97d5552b3a5dbced upstream.

ad1884_fixup_hp_eapd() tries to set the NID for controlling the
speaker EAPD from the pin configuration.  But the current code can't
work expectedly since it sets spec->eapd_nid before calling the
generic parser where the autocfg pins are set up.

This patch changes the function to set spec->eapd_nid after the
generic parser call while it sets vmaster hook unconditionally.  The
spec->eapd_nid check is moved in the hook function itself instead.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_analog.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/sound/pci/hda/patch_analog.c
+++ b/sound/pci/hda/patch_analog.c
@@ -2112,6 +2112,9 @@ static void ad_vmaster_eapd_hook(void *p
 {
 	struct hda_codec *codec = private_data;
 	struct ad198x_spec *spec = codec->spec;
+
+	if (!spec->eapd_nid)
+		return;
 	snd_hda_codec_update_cache(codec, spec->eapd_nid, 0,
 				   AC_VERB_SET_EAPD_BTLENABLE,
 				   enabled ? 0x02 : 0x00);
@@ -3601,13 +3604,16 @@ static void ad1884_fixup_hp_eapd(struct
 {
 	struct ad198x_spec *spec = codec->spec;
 
-	if (action == HDA_FIXUP_ACT_PRE_PROBE) {
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		spec->gen.vmaster_mute.hook = ad_vmaster_eapd_hook;
+		break;
+	case HDA_FIXUP_ACT_PROBE:
 		if (spec->gen.autocfg.line_out_type == AUTO_PIN_SPEAKER_OUT)
 			spec->eapd_nid = spec->gen.autocfg.line_out_pins[0];
 		else
 			spec->eapd_nid = spec->gen.autocfg.speaker_pins[0];
-		if (spec->eapd_nid)
-			spec->gen.vmaster_mute.hook = ad_vmaster_eapd_hook;
+		break;
 	}
 }
 


