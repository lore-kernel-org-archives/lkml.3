Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3LRVN2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:13:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab3LRVNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 006/118] ALSA: hda - Mute all aamix inputs as default
Date: Wed, 18 Dec 2013 13:10:43 -0800
Message-Id: <20131218211219.645822332@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ebb93c057dda376414fbc499ad6ace9b527dff5a upstream.

Not all channels have been initialized, so far, especially when aamix
NID itself doesn't have amps but its leaves have.  This patch fixes
these holes.  Otherwise you might get unexpected loopback inputs,
e.g. from surround channels.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -4318,6 +4318,26 @@ static unsigned int snd_hda_gen_path_pow
 	return AC_PWRST_D3;
 }
 
+/* mute all aamix inputs initially; parse up to the first leaves */
+static void mute_all_mixer_nid(struct hda_codec *codec, hda_nid_t mix)
+{
+	int i, nums;
+	const hda_nid_t *conn;
+	bool has_amp;
+
+	nums = snd_hda_get_conn_list(codec, mix, &conn);
+	has_amp = nid_has_mute(codec, mix, HDA_INPUT);
+	for (i = 0; i < nums; i++) {
+		if (has_amp)
+			snd_hda_codec_amp_stereo(codec, mix,
+						 HDA_INPUT, i,
+						 0xff, HDA_AMP_MUTE);
+		else if (nid_has_volume(codec, conn[i], HDA_OUTPUT))
+			snd_hda_codec_amp_stereo(codec, conn[i],
+						 HDA_OUTPUT, 0,
+						 0xff, HDA_AMP_MUTE);
+	}
+}
 
 /*
  * Parse the given BIOS configuration and set up the hda_gen_spec
@@ -4456,6 +4476,10 @@ int snd_hda_gen_parse_auto_config(struct
 		}
 	}
 
+	/* mute all aamix input initially */
+	if (spec->mixer_nid)
+		mute_all_mixer_nid(codec, spec->mixer_nid);
+
  dig_only:
 	parse_digital(codec);
 


