Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3IVSpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:45:21 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:52704 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3IVSo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:44:57 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: perex@perex.cz
Cc: tiwai@suse.de, wfp5p@virginia.edu, zonque@gmail.com, eldad@fogrefinery.com,
        david.henningsson@canonical.com, hegge@resisty.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        alsa-devel@alsa-project.org
Subject: [PATCH 4/5] ALSA: Fix assignment of 0/1 to bool variables
Date: Sun, 22 Sep 2013 20:44:12 +0200
Message-Id: <1379875453-20083-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
References: <1379875453-20083-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert 0 to false and 1 to true when assigning values to bool
variables. Inspired by commit 3db1cd5c05f35fb43eb134df6f321de4e63141f2.

The simplified semantic patch that find this problem is as
follows (http://coccinelle.lip6.fr/):

@@
bool b;
@@
(
-b = 0
+b = false
|
-b = 1
+b = true
)

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 sound/pci/azt3328.c |   14 +++++++-------
 sound/usb/mixer.c   |    4 ++--
 2 files changed, 9 insertions(+), 9 deletions(-)

diff -u -p a/sound/usb/mixer.c b/sound/usb/mixer.c
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -1151,14 +1151,14 @@ static void check_no_speaker_on_headset(
 	const char *names_to_check[] = {
 		"Headset", "headset", "Headphone", "headphone", NULL};
 	const char **s;
-	bool found = 0;
+	bool found = false;
 
 	if (strcmp("Speaker", kctl->id.name))
 		return;
 
 	for (s = names_to_check; *s; s++)
 		if (strstr(card->shortname, *s)) {
-			found = 1;
+			found = true;
 			break;
 		}
 
diff -u -p a/sound/pci/azt3328.c b/sound/pci/azt3328.c
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -715,14 +715,14 @@ snd_azf3328_mixer_ac97_read(struct snd_a
 	const struct snd_azf3328 *chip = ac97->private_data;
 	unsigned short reg_azf = snd_azf3328_mixer_ac97_map_reg_idx(reg_ac97);
 	unsigned short reg_val = 0;
-	bool unsupported = 0;
+	bool unsupported = false;
 
 	snd_azf3328_dbgmixer(
 		"snd_azf3328_mixer_ac97_read reg_ac97 %u\n",
 			reg_ac97
 	);
 	if (reg_azf & AZF_AC97_REG_UNSUPPORTED)
-		unsupported = 1;
+		unsupported = true;
 	else {
 		if (reg_azf & AZF_AC97_REG_REAL_IO_READ)
 			reg_val = snd_azf3328_mixer_inw(chip,
@@ -759,7 +759,7 @@ snd_azf3328_mixer_ac97_read(struct snd_a
 				reg_val = azf_emulated_ac97_vendor_id & 0xffff;
 				break;
 			default:
-				unsupported = 1;
+				unsupported = true;
 				break;
 			}
 		}
@@ -776,14 +776,14 @@ snd_azf3328_mixer_ac97_write(struct snd_
 {
 	const struct snd_azf3328 *chip = ac97->private_data;
 	unsigned short reg_azf = snd_azf3328_mixer_ac97_map_reg_idx(reg_ac97);
-	bool unsupported = 0;
+	bool unsupported = false;
 
 	snd_azf3328_dbgmixer(
 		"snd_azf3328_mixer_ac97_write reg_ac97 %u val %u\n",
 			reg_ac97, val
 	);
 	if (reg_azf & AZF_AC97_REG_UNSUPPORTED)
-		unsupported = 1;
+		unsupported = true;
 	else {
 		if (reg_azf & AZF_AC97_REG_REAL_IO_WRITE)
 			snd_azf3328_mixer_outw(
@@ -808,7 +808,7 @@ snd_azf3328_mixer_ac97_write(struct snd_
 				 */
 				break;
 			default:
-				unsupported = 1;
+				unsupported = true;
 				break;
 			}
 		}
@@ -1559,7 +1559,7 @@ snd_azf3328_pcm_trigger(struct snd_pcm_s
 	struct snd_azf3328_codec_data *codec = runtime->private_data;
 	int result = 0;
 	u16 flags1;
-	bool previously_muted = 0;
+	bool previously_muted = false;
 	bool is_main_mixer_playback_codec = (AZF_CODEC_PLAYBACK == codec->type);
 
 	snd_azf3328_dbgcalls("snd_azf3328_pcm_trigger cmd %d\n", cmd);

