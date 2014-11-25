Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaKYKnE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:43:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbaKYKnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:00 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 191/254] ALSA: usb-audio: Fix memory leak in FTU quirk
Date: Tue, 25 Nov 2014 10:39:01 +0000
Message-Id: <1416912004-5928-192-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1a290581ded60e87276741f8ca97b161d2b226fc upstream.

M-audio FastTrack Ultra quirk doesn't release the kzalloc'ed memory.
This patch adds the private_free callback to release it properly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/usb/mixer_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index f119a41ed9a9..7c83bab69dee 100644
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
2.1.0

