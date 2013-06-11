Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab3FKUOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:14:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665Ab3FKUD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Riesen <raa.lkml@gmail.com>, Takashi Iwai <tiwai@suse.de>
Subject: [ 37/79] ALSA: hda - Add keep_eapd_on flag to generic parser
Date: Tue, 11 Jun 2013 13:03:03 -0700
Message-Id: <20130611195320.824673198@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 05909d5c679cf7c9a8a5bc663677c066a546894f upstream.

VT1802 codec seems to reset EAPD of other pins in the hardware level,
and this was another reason of the silent headphone output on some
machines.  As a workaround, introduce a new flag indicating to keep
the EPAD on to the generic parser, and set it in patch_via.c.

Reported-by: Alex Riesen <raa.lkml@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |    2 ++
 sound/pci/hda/hda_generic.h |    1 +
 sound/pci/hda/patch_via.c   |    1 +
 3 files changed, 4 insertions(+)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -772,6 +772,8 @@ static void set_pin_eapd(struct hda_code
 		return;
 	if (codec->inv_eapd)
 		enable = !enable;
+	if (spec->keep_eapd_on && !enable)
+		return;
 	snd_hda_codec_update_cache(codec, pin, 0,
 				   AC_VERB_SET_EAPD_BTLENABLE,
 				   enable ? 0x02 : 0x00);
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -205,6 +205,7 @@ struct hda_gen_spec {
 	unsigned int multi_cap_vol:1; /* allow multiple capture xxx volumes */
 	unsigned int inv_dmic_split:1; /* inverted dmic w/a for conexant */
 	unsigned int own_eapd_ctl:1; /* set EAPD by own function */
+	unsigned int keep_eapd_on:1; /* don't turn off EAPD automatically */
 	unsigned int vmaster_mute_enum:1; /* add vmaster mute mode enum */
 	unsigned int indep_hp:1; /* independent HP supported */
 	unsigned int prefer_hp_amp:1; /* enable HP amp for speaker if any */
--- a/sound/pci/hda/patch_via.c
+++ b/sound/pci/hda/patch_via.c
@@ -136,6 +136,7 @@ static struct via_spec *via_new_spec(str
 		spec->codec_type = VT1708S;
 	spec->no_pin_power_ctl = 1;
 	spec->gen.indep_hp = 1;
+	spec->gen.keep_eapd_on = 1;
 	spec->gen.pcm_playback_hook = via_playback_pcm_hook;
 	return spec;
 }


