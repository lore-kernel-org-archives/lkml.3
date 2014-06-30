Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbaF3MFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:05:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52014 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753618AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 079/181] ALSA: control: Don't access controls outside of protected regions
Date: Mon, 30 Jun 2014 13:51:40 +0200
Message-Id: <3d6a96f651026c5e46266c7857b7322608f764ae.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit fd9f26e4eca5d08a27d12c0933fceef76ed9663d upstream.

A control that is visible on the card->controls list can be freed at any time.
This means we must not access any of its memory while not holding the
controls_rw_lock. Otherwise we risk a use after free access.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/core/control.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 15bc84492746..d4a597fe86e4 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -331,6 +331,7 @@ int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
 {
 	struct snd_ctl_elem_id id;
 	unsigned int idx;
+	unsigned int count;
 	int err = -EINVAL;
 
 	if (! kcontrol)
@@ -359,8 +360,9 @@ int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
 	card->controls_count += kcontrol->count;
 	kcontrol->id.numid = card->last_numid + 1;
 	card->last_numid += kcontrol->count;
+	count = kcontrol->count;
 	up_write(&card->controls_rwsem);
-	for (idx = 0; idx < kcontrol->count; idx++, id.index++, id.numid++)
+	for (idx = 0; idx < count; idx++, id.index++, id.numid++)
 		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_ADD, &id);
 	return 0;
 
@@ -389,6 +391,7 @@ int snd_ctl_replace(struct snd_card *card, struct snd_kcontrol *kcontrol,
 		    bool add_on_replace)
 {
 	struct snd_ctl_elem_id id;
+	unsigned int count;
 	unsigned int idx;
 	struct snd_kcontrol *old;
 	int ret;
@@ -424,8 +427,9 @@ add:
 	card->controls_count += kcontrol->count;
 	kcontrol->id.numid = card->last_numid + 1;
 	card->last_numid += kcontrol->count;
+	count = kcontrol->count;
 	up_write(&card->controls_rwsem);
-	for (idx = 0; idx < kcontrol->count; idx++, id.index++, id.numid++)
+	for (idx = 0; idx < count; idx++, id.index++, id.numid++)
 		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_ADD, &id);
 	return 0;
 
@@ -898,9 +902,9 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
 			result = kctl->put(kctl, control);
 		}
 		if (result > 0) {
+			struct snd_ctl_elem_id id = control->id;
 			up_read(&card->controls_rwsem);
-			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE,
-				       &control->id);
+			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_VALUE, &id);
 			return 0;
 		}
 	}
@@ -1334,8 +1338,9 @@ static int snd_ctl_tlv_ioctl(struct snd_ctl_file *file,
 		}
 		err = kctl->tlv.c(kctl, op_flag, tlv.length, _tlv->tlv);
 		if (err > 0) {
+			struct snd_ctl_elem_id id = kctl->id;
 			up_read(&card->controls_rwsem);
-			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_TLV, &kctl->id);
+			snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_TLV, &id);
 			return 0;
 		}
 	} else {
-- 
2.0.0

