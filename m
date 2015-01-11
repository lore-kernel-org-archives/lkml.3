Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbbAKOU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 09:20:59 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57639 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbAKOU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 09:20:57 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ALSA: lola: lola_mixer: Remove some unused functions
Date: Sun, 11 Jan 2015 15:24:02 +0100
Message-Id: <1420986242-18502-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
lola_restore_mixer() lola_save_mixer()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 sound/pci/lola/lola.h       |    2 --
 sound/pci/lola/lola_mixer.c |   43 -------------------------------------------
 2 files changed, 45 deletions(-)

diff --git a/sound/pci/lola/lola.h b/sound/pci/lola/lola.h
index f0b1000..9125916 100644
--- a/sound/pci/lola/lola.h
+++ b/sound/pci/lola/lola.h
@@ -513,8 +513,6 @@ int lola_init_mixer_widget(struct lola *chip, int nid);
 void lola_free_mixer(struct lola *chip);
 int lola_create_mixer(struct lola *chip);
 int lola_setup_all_analog_gains(struct lola *chip, int dir, bool mute);
-void lola_save_mixer(struct lola *chip);
-void lola_restore_mixer(struct lola *chip);
 int lola_set_src_config(struct lola *chip, unsigned int src_mask, bool update);
 
 /* proc */
diff --git a/sound/pci/lola/lola_mixer.c b/sound/pci/lola/lola_mixer.c
index 782f4d8..47ac93a 100644
--- a/sound/pci/lola/lola_mixer.c
+++ b/sound/pci/lola/lola_mixer.c
@@ -348,49 +348,6 @@ int lola_setup_all_analog_gains(struct lola *chip, int dir, bool mute)
 	return lola_codec_flush(chip);
 }
 
-void lola_save_mixer(struct lola *chip)
-{
-	/* mute analog output */
-	if (chip->mixer.array_saved) {
-		/* store contents of mixer array */
-		memcpy_fromio(chip->mixer.array_saved, chip->mixer.array,
-			      sizeof(*chip->mixer.array));
-	}
-	lola_setup_all_analog_gains(chip, PLAY, true); /* output mute */
-}
-
-void lola_restore_mixer(struct lola *chip)
-{
-	int i;
-
-	/*lola_reset_setups(chip);*/
-	if (chip->mixer.array_saved) {
-		/* restore contents of mixer array */
-		memcpy_toio(chip->mixer.array, chip->mixer.array_saved,
-			    sizeof(*chip->mixer.array));
-		/* inform micro-controller about all restored values
-		 * and ignore return values
-		 */
-		for (i = 0; i < chip->mixer.src_phys_ins; i++)
-			lola_codec_write(chip, chip->mixer.nid,
-					 LOLA_VERB_SET_SOURCE_GAIN,
-					 i, 0);
-		for (i = 0; i < chip->mixer.src_stream_outs; i++)
-			lola_codec_write(chip, chip->mixer.nid,
-					 LOLA_VERB_SET_SOURCE_GAIN,
-					 chip->mixer.src_stream_out_ofs + i, 0);
-		for (i = 0; i < chip->mixer.dest_stream_ins; i++)
-			lola_codec_write(chip, chip->mixer.nid,
-					 LOLA_VERB_SET_DESTINATION_GAIN,
-					 i, 0);
-		for (i = 0; i < chip->mixer.dest_phys_outs; i++)
-			lola_codec_write(chip, chip->mixer.nid,
-					 LOLA_VERB_SET_DESTINATION_GAIN,
-					 chip->mixer.dest_phys_out_ofs + i, 0);
-		lola_codec_flush(chip);
-	}
-}
-
 /*
  */
 
-- 
1.7.10.4

