Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab3K0B2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:28:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758643Ab3K0A6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.12 045/116] ALSA: hda - Introduce the bitmask for excluding output volume
Date: Tue, 26 Nov 2013 16:56:58 -0800
Message-Id: <20131127005740.067975349@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit a1114a8c681b0724d6ad905f53ff06aa756f5fb8 upstream.

Add a bitmask to hda_gen_spec indicating NIDs to exclude from the
possible volume controls.  That is, when the bit is set, the NID
corresponding to the bit won't be picked as an output volume control
any longer.

Basically this is just a band-aid for working around the issue found
with CS4208 codec, where only the headphone pin has a volume AMP with
different dB steps.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60811
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_generic.c  |    8 ++++++--
 sound/pci/hda/hda_generic.h  |    3 +++
 sound/pci/hda/patch_cirrus.c |    2 ++
 3 files changed, 11 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/hda_generic.c
+++ b/sound/pci/hda/hda_generic.c
@@ -549,11 +549,15 @@ static hda_nid_t look_for_out_mute_nid(s
 static hda_nid_t look_for_out_vol_nid(struct hda_codec *codec,
 				      struct nid_path *path)
 {
+	struct hda_gen_spec *spec = codec->spec;
 	int i;
 
 	for (i = path->depth - 1; i >= 0; i--) {
-		if (nid_has_volume(codec, path->path[i], HDA_OUTPUT))
-			return path->path[i];
+		hda_nid_t nid = path->path[i];
+		if ((spec->out_vol_mask >> nid) & 1)
+			continue;
+		if (nid_has_volume(codec, nid, HDA_OUTPUT))
+			return nid;
 	}
 	return 0;
 }
--- a/sound/pci/hda/hda_generic.h
+++ b/sound/pci/hda/hda_generic.h
@@ -242,6 +242,9 @@ struct hda_gen_spec {
 	/* additional mute flags (only effective with auto_mute_via_amp=1) */
 	u64 mute_bits;
 
+	/* bitmask for skipping volume controls */
+	u64 out_vol_mask;
+
 	/* badness tables for output path evaluations */
 	const struct badness_table *main_out_badness;
 	const struct badness_table *extra_out_badness;
--- a/sound/pci/hda/patch_cirrus.c
+++ b/sound/pci/hda/patch_cirrus.c
@@ -684,6 +684,8 @@ static int patch_cs4208(struct hda_codec
 		return -ENOMEM;
 
 	spec->gen.automute_hook = cs_automute;
+	/* exclude NID 0x10 (HP) from output volumes due to different steps */
+	spec->gen.out_vol_mask = 1ULL << 0x10;
 
 	snd_hda_pick_fixup(codec, cs4208_models, cs4208_fixup_tbl,
 			   cs4208_fixups);


