Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaKCKeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:34:31 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46639 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbaKCKe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:34:27 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ALSA: echoaudio: add reference of struct echoaudio
Date: Mon,  3 Nov 2014 16:04:12 +0530
Message-Id: <1415010853-4334-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

added reference of struct echoaudio to free_firmware function.
this structure will be later used to get a reference of the card
when converting snd_printk to dev_* in the next patch of the series.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---

same as v1.

 sound/pci/echoaudio/echoaudio.c     |  3 ++-
 sound/pci/echoaudio/echoaudio.h     |  3 ++-
 sound/pci/echoaudio/echoaudio_dsp.c | 10 +++++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/sound/pci/echoaudio/echoaudio.c b/sound/pci/echoaudio/echoaudio.c
index d82321f..db1b247 100644
--- a/sound/pci/echoaudio/echoaudio.c
+++ b/sound/pci/echoaudio/echoaudio.c
@@ -69,7 +69,8 @@ static int get_firmware(const struct firmware **fw_entry,
 
 
 
-static void free_firmware(const struct firmware *fw_entry)
+static void free_firmware(const struct firmware *fw_entry,
+			  struct echoaudio *chip)
 {
 #ifdef CONFIG_PM_SLEEP
 	DE_ACT(("firmware not released (kept in cache)\n"));
diff --git a/sound/pci/echoaudio/echoaudio.h b/sound/pci/echoaudio/echoaudio.h
index b86b88d..a4f112a 100644
--- a/sound/pci/echoaudio/echoaudio.h
+++ b/sound/pci/echoaudio/echoaudio.h
@@ -468,7 +468,8 @@ static int wait_handshake(struct echoaudio *chip);
 static int send_vector(struct echoaudio *chip, u32 command);
 static int get_firmware(const struct firmware **fw_entry,
 			struct echoaudio *chip, const short fw_index);
-static void free_firmware(const struct firmware *fw_entry);
+static void free_firmware(const struct firmware *fw_entry,
+			  struct echoaudio *chip);
 
 #ifdef ECHOCARD_HAS_MIDI
 static int enable_midi_input(struct echoaudio *chip, char enable);
diff --git a/sound/pci/echoaudio/echoaudio_dsp.c b/sound/pci/echoaudio/echoaudio_dsp.c
index 5a6a217..977b2bd 100644
--- a/sound/pci/echoaudio/echoaudio_dsp.c
+++ b/sound/pci/echoaudio/echoaudio_dsp.c
@@ -206,12 +206,12 @@ static int load_asic_generic(struct echoaudio *chip, u32 cmd, short asic)
 	}
 
 	DE_INIT(("ASIC loaded\n"));
-	free_firmware(fw);
+	free_firmware(fw, chip);
 	return 0;
 
 la_error:
 	DE_INIT(("failed on write_dsp\n"));
-	free_firmware(fw);
+	free_firmware(fw, chip);
 	return -EIO;
 }
 
@@ -317,11 +317,11 @@ static int install_resident_loader(struct echoaudio *chip)
 	}
 
 	DE_INIT(("Resident loader successfully installed\n"));
-	free_firmware(fw);
+	free_firmware(fw, chip);
 	return 0;
 
 irl_error:
-	free_firmware(fw);
+	free_firmware(fw, chip);
 	return -EIO;
 }
 
@@ -491,7 +491,7 @@ static int load_firmware(struct echoaudio *chip)
 	if (err < 0)
 		return err;
 	err = load_dsp(chip, (u16 *)fw->data);
-	free_firmware(fw);
+	free_firmware(fw, chip);
 	if (err < 0)
 		return err;
 
-- 
1.8.1.2

