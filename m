Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaICJ56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:57:58 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57435 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932327AbaICJ5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 23/56] ALSA: hda/ca0132 - Don't try loading firmware at resume when already failed
Date: Wed,  3 Sep 2014 11:26:42 +0200
Message-Id: <654f508d5c6a707eabc01f06d34003c05d4221b7.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_ca0132.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index a91ad743fca4..8458b6e50efc 100644
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
2.1.0

