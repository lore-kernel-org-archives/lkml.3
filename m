Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756431Ab3LSMMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:12:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45260 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab3LSL7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:59:23 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 171/208] ALSA: hda - Mute all aamix inputs as default
Date: Thu, 19 Dec 2013 11:54:29 +0000
Message-Id: <1387454106-19326-172-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit ebb93c057dda376414fbc499ad6ace9b527dff5a upstream.

Not all channels have been initialized, so far, especially when aamix
NID itself doesn't have amps but its leaves have.  This patch fixes
these holes.  Otherwise you might get unexpected loopback inputs,
e.g. from surround channels.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/hda/hda_generic.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/sound/pci/hda/hda_generic.c b/sound/pci/hda/hda_generic.c
index c6cb67b..bd7efe8 100644
--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -4246,6 +4246,26 @@ static unsigned int snd_hda_gen_path_power_filter(struct hda_codec *codec,
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
@@ -4384,6 +4404,10 @@ int snd_hda_gen_parse_auto_config(struct hda_codec *codec,
 		}
 	}
 
+	/* mute all aamix input initially */
+	if (spec->mixer_nid)
+		mute_all_mixer_nid(codec, spec->mixer_nid);
+
  dig_only:
 	parse_digital(codec);
 
-- 
1.8.3.2

