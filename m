Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbaLCL1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaLCL1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:10 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/101] ALSA: usb-audio: Fix memory leak in FTU quirk
Date: Wed,  3 Dec 2014 12:25:48 +0100
Message-Id: <9e7e0e10a13b7754b9a98fbdae557614b05e8875.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1a290581ded60e87276741f8ca97b161d2b226fc upstream.

M-audio FastTrack Ultra quirk doesn't release the kzalloc'ed memory.
This patch adds the private_free callback to release it properly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/usb/mixer_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/usb/mixer_quirks.c b/sound/usb/mixer_quirks.c
index d42a584cf829..ea4b9a8a90bd 100644
--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -802,6 +802,11 @@ static int snd_ftu_eff_switch_put(struct snd_kcontrol *kctl,
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
@@ -836,6 +841,7 @@ static int snd_ftu_create_effect_switch(struct usb_mixer_interface *mixer,
 		return -ENOMEM;
 	}
 
+	kctl->private_free = kctl_private_value_free;
 	err = snd_ctl_add(mixer->chip->card, kctl);
 	if (err < 0)
 		return err;
-- 
2.1.3

