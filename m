Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936332AbaICXt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:49:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45234 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933291AbaICWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:05:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.10 12/55] ALSA: hda/ca0132 - Dont try loading firmware at resume when already failed
Date: Wed,  3 Sep 2014 15:05:02 -0700
Message-Id: <20140903220455.863869995@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220453.653576908@linuxfoundation.org>
References: <20140903220453.653576908@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_ca0132.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -4379,6 +4379,9 @@ static void ca0132_download_dsp(struct h
 	return; /* NOP */
 #endif
 
+	if (spec->dsp_state == DSP_DOWNLOAD_FAILED)
+		return; /* don't retry failures */
+
 	chipio_enable_clocks(codec);
 	spec->dsp_state = DSP_DOWNLOADING;
 	if (!ca0132_download_dsp_images(codec))
@@ -4555,7 +4558,8 @@ static int ca0132_init(struct hda_codec
 	struct auto_pin_cfg *cfg = &spec->autocfg;
 	int i;
 
-	spec->dsp_state = DSP_DOWNLOAD_INIT;
+	if (spec->dsp_state != DSP_DOWNLOAD_FAILED)
+		spec->dsp_state = DSP_DOWNLOAD_INIT;
 	spec->curr_chip_addx = INVALID_CHIP_ADDRESS;
 
 	snd_hda_power_up(codec);
@@ -4666,6 +4670,7 @@ static int patch_ca0132(struct hda_codec
 	codec->spec = spec;
 	spec->codec = codec;
 
+	spec->dsp_state = DSP_DOWNLOAD_INIT;
 	spec->num_mixers = 1;
 	spec->mixers[0] = ca0132_mixer;
 


