Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbaKPWAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:00:30 -0500
Received: from 1wt.eu ([62.212.114.60]:47852 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaKPWA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:00:27 -0500
Message-Id: <20141116215328.938477028@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:35 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [ 07/48] ALSA: control: Make sure that id->index does not
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 overflow

From: Lars-Peter Clausen <lars@metafoo.de>

The ALSA control code expects that the range of assigned indices to a control is
continuous and does not overflow. Currently there are no checks to enforce this.
If a control with a overflowing index range is created that control becomes
effectively inaccessible and unremovable since snd_ctl_find_id() will not be
able to find it. This patch adds a check that makes sure that controls with a
overflowing index range can not be created.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
(cherry picked from commit 883a1d49f0d77d30012f114b2e19fc141beb3e8e)
[wt: part 1 of CVE-2014-4656 fix]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 sound/core/control.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index 7834a54..80bb3ed 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -328,6 +328,9 @@ int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
 	if (snd_BUG_ON(!card || !kcontrol->info))
 		goto error;
 	id = kcontrol->id;
+	if (id.index > UINT_MAX - kcontrol->count)
+		goto error;
+
 	down_write(&card->controls_rwsem);
 	if (snd_ctl_find_id(card, &id)) {
 		up_write(&card->controls_rwsem);
-- 
1.7.12.2.21.g234cd45.dirty



