Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaGOVi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54933 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933995AbaGOViq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:46 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 160/198] ALSA: control: Don't access controls outside of protected regions
Date: Tue, 15 Jul 2014 14:30:30 -0700
Message-Id: <1405459868-15089-161-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit fd9f26e4eca5d08a27d12c0933fceef76ed9663d upstream.

A control that is visible on the card->controls list can be freed at any time.
This means we must not access any of its memory while not holding the
controls_rw_lock. Otherwise we risk a use after free access.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/control.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 15bc844..d4a597f 100644
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
1.9.1

