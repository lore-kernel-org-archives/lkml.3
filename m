Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604AbaICXRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:17:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228AbaICWQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:16:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Franz Hsieh <franz.hsieh@canonical.com>,
        Hui Wang <hui.wang@canonical.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.16 022/125] ALSA: hda - restore the gpio led after resume
Date: Wed,  3 Sep 2014 15:06:19 -0700
Message-Id: <20140903220624.327291219@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/patch_realtek.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3242,6 +3242,15 @@ static int alc269_resume(struct hda_code
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
 


