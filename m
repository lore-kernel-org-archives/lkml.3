Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaICJ4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:00 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57310 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753530AbaICJz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:55:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 25/56] ALSA: hda - restore the gpio led after resume
Date: Wed,  3 Sep 2014 11:26:44 +0200
Message-Id: <b65606263bd633e9440cda96f2369b2782180cda.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f475371aa65de84fa483a998ab7594531026b9d9 upstream.

On some HP laptops, the mute led is controlled by codec gpio.

When some machine resume from s3/s4, the codec gpio data will be
cleared to 0 by BIOS:
Before suspend:
  IO[3]: enable=1, dir=1, wake=0, sticky=0, data=1, unsol=0
After resume:
  IO[3]: enable=1, dir=1, wake=0, sticky=0, data=0, unsol=0

To skip the AFG node to enter D3 can't fix this problem.

A workaround is to restore the gpio data when the system resume
back from s3/s4. It is safe even on the machines without this
problem.

BugLink: https://bugs.launchpad.net/bugs/1358116
Tested-by: Franz Hsieh <franz.hsieh@canonical.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index b8a5f1d02b18..a718b9939e17 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -2902,6 +2902,15 @@ static int alc269_resume(struct hda_codec *codec)
 	snd_hda_codec_resume_cache(codec);
 	alc_inv_dmic_sync(codec, true);
 	hda_call_check_power_status(codec, 0x01);
+
+	/* on some machine, the BIOS will clear the codec gpio data when enter
+	 * suspend, and won't restore the data after resume, so we restore it
+	 * in the driver.
+	 */
+	if (spec->gpio_led)
+		snd_hda_codec_write(codec, codec->afg, 0, AC_VERB_SET_GPIO_DATA,
+			    spec->gpio_led);
+
 	if (spec->has_alc5505_dsp)
 		alc5505_dsp_resume(codec);
 
-- 
2.1.0

