Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbaG3Mou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:44:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36631 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbaG3MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 14/94] ALSA: hda - Fix broken PM due to incomplete i915 initialization
Date: Wed, 30 Jul 2014 14:14:03 +0200
Message-Id: <02c9a938ac9e5253cf603fa2fbc20b419ae90ec7.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/pci/hda/hda_intel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index ee1a6ff120a2..37806a97c878 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2917,7 +2917,7 @@ static int azx_suspend(struct device *dev)
 	struct azx *chip = card->private_data;
 	struct azx_pcm *p;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
@@ -2948,7 +2948,7 @@ static int azx_resume(struct device *dev)
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
@@ -2983,7 +2983,7 @@ static int azx_runtime_suspend(struct device *dev)
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -3009,7 +3009,7 @@ static int azx_runtime_resume(struct device *dev)
 	struct hda_codec *codec;
 	int status;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -3044,7 +3044,7 @@ static int azx_runtime_idle(struct device *dev)
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!power_save_controller ||
-- 
2.0.1

