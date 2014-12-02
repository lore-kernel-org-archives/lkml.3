Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbaLBTXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:23:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46698 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932659AbaLBTXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:23:42 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 072/121] ALSA: usb-audio: Fix memory leak in FTU quirk
Date: Tue,  2 Dec 2014 11:19:11 -0800
Message-Id: <1417548000-1794-73-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1a290581ded60e87276741f8ca97b161d2b226fc upstream.

M-audio FastTrack Ultra quirk doesn't release the kzalloc'ed memory.
This patch adds the private_free callback to release it properly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/usb/mixer_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index f4b12c2..5a723df 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -885,6 +885,11 @@ static int snd_ftu_eff_switch_put(struct snd_kcontrol *kctl,
 	return changed;
 }
 
+static void kctl_private_value_free(struct snd_kcontrol *kctl)
+{
+	kfree((void *)kctl->private_value);
+}
+
 static int snd_ftu_create_effect_switch(struct usb_mixer_interface *mixer,
 	int validx, int bUnitID)
 {
@@ -919,6 +924,7 @@ static int snd_ftu_create_effect_switch(struct usb_mixer_interface *mixer,
 		return -ENOMEM;
 	}
 
+	kctl->private_free = kctl_private_value_free;
 	err = snd_ctl_add(mixer->chip->card, kctl);
 	if (err < 0)
 		return err;
-- 
1.9.1

