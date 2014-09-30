Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaI3Vgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:36:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60849 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbaI3Vge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:36:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 025/103] ALSA: hda - restore the gpio led after resume
Date: Tue, 30 Sep 2014 14:30:30 -0700
Message-Id: <1412112708-27356-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Wang <hui.wang@canonical.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/patch_realtek.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 515c4d9..6b1f38a 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3013,6 +3013,15 @@ static int alc269_resume(struct hda_codec *codec)
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
1.9.1

