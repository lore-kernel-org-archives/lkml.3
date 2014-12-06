Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaLFRzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:55:07 -0500
Received: from 1wt.eu ([62.212.114.60]:40712 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752454AbaLFRy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:56 -0500
Message-Id: <20141206174149.148190571@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:42:05 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [ 17/25] ALSA: control: Dont access controls outside of
 protected regions
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

(commit fd9f26e4eca5d08a27d12c0933fceef76ed9663d upstream)

A control that is visible on the card->controls list can be freed at any time.
This means we must not access any of its memory while not holding the
controls_rw_lock. Otherwise we risk a use after free access.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[wt: fixes CVE-2014-4653]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/core/control.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 8bf3a6d..e91d79a 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -325,6 +325,7 @@ int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
 {
 	struct snd_ctl_elem_id id;
 	unsigned int idx;
+	unsigned int count;
 	int err = -EINVAL;
 
 	if (! kcontrol)
@@ -356,8 +357,9 @@ int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
 	card->controls_count += kcontrol->count;
 	kcontrol->id.numid = card->last_numid + 1;
 	card->last_numid += kcontrol->count;
+	count = kcontrol->count;
 	up_write(&card->controls_rwsem);
-	for (idx = 0; idx < kcontrol->count; idx++, id.index++, id.numid++)
+	for (idx = 0; idx < count; idx++, id.index++, id.numid++)
 		snd_ctl_notify(card, SNDRV_CTL_EVENT_MASK_ADD, &id);
 	return 0;
 
@@ -784,9 +786,9 @@ static int snd_ctl_elem_write(struct snd_card *card, struct snd_ctl_file *file,
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
-- 
1.7.12.2.21.g234cd45.dirty



