Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbaIOWTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:19:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51178 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbaIOWT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:28 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 175/187] ALSA: hda/ca0132 - Don't try loading firmware at resume when already failed
Date: Mon, 15 Sep 2014 15:09:45 -0700
Message-Id: <1410818997-9432-176-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e24aa0a4c5ac92a171d9dd74a8d3dbf652990d36 upstream.

CA0132 driver tries to reload the firmware at resume.  Usually this
works since the firmware loader core caches the firmware contents by
itself.  However, if the driver failed to load the firmwares
(e.g. missing files), reloading the firmware at resume goes through
the actual file loading code path, and triggers a kernel WARNING like:

 WARNING: CPU: 10 PID:11371 at drivers/base/firmware_class.c:1105 _request_firmware+0x9ab/0x9d0()

For avoiding this situation, this patch makes CA0132 skipping the f/w
loading at resume when it failed at probe time.

Reported-and-tested-by: Janek Kozicki <cosurgi@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_ca0132.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 46ecdbb..d5843da 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4379,6 +4379,9 @@ static void ca0132_download_dsp(struct hda_codec *codec)
 	return; /* NOP */
 #endif
 
+	if (spec->dsp_state == DSP_DOWNLOAD_FAILED)
+		return; /* don't retry failures */
+
 	chipio_enable_clocks(codec);
 	spec->dsp_state = DSP_DOWNLOADING;
 	if (!ca0132_download_dsp_images(codec))
@@ -4555,7 +4558,8 @@ static int ca0132_init(struct hda_codec *codec)
 	struct auto_pin_cfg *cfg = &spec->autocfg;
 	int i;
 
-	spec->dsp_state = DSP_DOWNLOAD_INIT;
+	if (spec->dsp_state != DSP_DOWNLOAD_FAILED)
+		spec->dsp_state = DSP_DOWNLOAD_INIT;
 	spec->curr_chip_addx = INVALID_CHIP_ADDRESS;
 
 	snd_hda_power_up(codec);
@@ -4666,6 +4670,7 @@ static int patch_ca0132(struct hda_codec *codec)
 	codec->spec = spec;
 	spec->codec = codec;
 
+	spec->dsp_state = DSP_DOWNLOAD_INIT;
 	spec->num_mixers = 1;
 	spec->mixers[0] = ca0132_mixer;
 
-- 
1.9.1

