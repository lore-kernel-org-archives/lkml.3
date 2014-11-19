Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934112AbaKSWEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:04:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933400AbaKSVEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.14 029/122] ALSA: usb-audio: Fix memory leak in FTU quirk
Date: Wed, 19 Nov 2014 12:51:19 -0800
Message-Id: <20141119205209.751249876@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 1a290581ded60e87276741f8ca97b161d2b226fc upstream.

M-audio FastTrack Ultra quirk doesn't release the kzalloc'ed memory.
This patch adds the private_free callback to release it properly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/usb/mixer_quirks.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -885,6 +885,11 @@ static int snd_ftu_eff_switch_put(struct
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
@@ -919,6 +924,7 @@ static int snd_ftu_create_effect_switch(
 		return -ENOMEM;
 	}
 
+	kctl->private_free = kctl_private_value_free;
 	err = snd_ctl_add(mixer->chip->card, kctl);
 	if (err < 0)
 		return err;


