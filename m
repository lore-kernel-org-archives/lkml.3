Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaKPWNF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:13:05 -0500
Received: from 1wt.eu ([62.212.114.60]:47873 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaKPWAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:34 -0500
Message-Id: <20141116215328.979301376@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:36 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [ 08/48] ALSA: control: Handle numid overflow
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

Each control gets automatically assigned its numids when the control is created.
The allocation is done by incrementing the numid by the amount of allocated
numids per allocation. This means that excessive creation and destruction of
controls (e.g. via SNDRV_CTL_IOCTL_ELEM_ADD/REMOVE) can cause the id to
eventually overflow. Currently when this happens for the control that caused the
overflow kctl->id.numid + kctl->count will also over flow causing it to be
smaller than kctl->id.numid. Most of the code assumes that this is something
that can not happen, so we need to make sure that it won't happen

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
(cherry picked from commit ac902c112d90a89e59916f751c2745f4dbdbb4bd)
[wt: part 2 of CVE-2014-4656]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/core/control.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index 80bb3ed..d7f4644 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -278,6 +278,10 @@ static unsigned int snd_ctl_hole_check(struct snd_card *card,
 {
 	struct snd_kcontrol *kctl;
 
+	/* Make sure that the ids assigned to the control do not wrap around */
+	if (card->last_numid >= UINT_MAX - count)
+		card->last_numid = 0;
+
 	list_for_each_entry(kctl, &card->controls, list) {
 		if ((kctl->id.numid <= card->last_numid &&
 		     kctl->id.numid + kctl->count > card->last_numid) ||
-- 
1.7.12.2.21.g234cd45.dirty



