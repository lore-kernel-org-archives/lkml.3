Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbaHHUmE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:42:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40131 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbaHHUls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 136/259] ALSA: hda - Fix broken PM due to incomplete i915 initialization
Date: Fri,  8 Aug 2014 13:39:19 -0700
Message-Id: <1407530482-4483-137-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_intel.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index eab13e2..e8de8a3 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2949,7 +2949,7 @@ static int azx_suspend(struct device *dev)
 	struct azx *chip = card->private_data;
 	struct azx_pcm *p;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
@@ -2987,7 +2987,7 @@ static int azx_resume(struct device *dev)
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL) {
@@ -3024,7 +3024,7 @@ static int azx_runtime_suspend(struct device *dev)
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -3052,7 +3052,7 @@ static int azx_runtime_resume(struct device *dev)
 	struct hda_codec *codec;
 	int status;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
@@ -3089,7 +3089,7 @@ static int azx_runtime_idle(struct device *dev)
 	struct snd_card *card = dev_get_drvdata(dev);
 	struct azx *chip = card->private_data;
 
-	if (chip->disabled)
+	if (chip->disabled || chip->init_failed)
 		return 0;
 
 	if (!power_save_controller ||
-- 
1.9.1

