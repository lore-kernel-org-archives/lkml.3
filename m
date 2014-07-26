Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaGZTzs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:55:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34067 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbaGZTKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:10:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 04/87] ALSA: hda - Fix broken PM due to incomplete i915 initialization
Date: Sat, 26 Jul 2014 12:01:38 -0700
Message-Id: <20140726190214.672175574@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190214.530473925@linuxfoundation.org>
References: <20140726190214.530473925@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 4da63c6fc426023d1a20e45508c47d7d68c6a53d upstream.

When the initialization of Intel HDMI controller fails due to missing
i915 kernel symbols (e.g. HD-audio is built in while i915 is module),
the driver discontinues the probe.  However, since the probe was done
asynchronously, the driver object still remains, thus the relevant PM
ops are still called at suspend/resume. This results in the bad access
to the incomplete audio card object, eventually leads to Oops or stall
at PM.

This patch adds the missing checks of chip->init_failed flag at each
PM callback in order to fix the problem above.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=79561
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/hda/hda_intel.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2930,7 +2930,7 @@ static int azx_suspend(struct device *de
 	struct azx *chip = card->private_data;
 	struct azx_pcm *p;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
@@ -2961,7 +2961,7 @@ static int azx_resume(struct device *dev
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
@@ -2996,7 +2996,7 @@ static int azx_runtime_suspend(struct de
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -3022,7 +3022,7 @@ static int azx_runtime_resume(struct dev
 	struct hda_codec *codec;
 	int status;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -3057,7 +3057,7 @@ static int azx_runtime_idle(struct devic
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!power_save_controller ||


