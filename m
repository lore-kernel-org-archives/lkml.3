Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933888AbaGVWwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:52:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44430 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbaGVWWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:49 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 095/116] ALSA: control: Make sure that id->index does not overflow
Date: Tue, 22 Jul 2014 15:21:46 -0700
Message-Id: <1406067727-19683-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 883a1d49f0d77d30012f114b2e19fc141beb3e8e upstream.

The ALSA control code expects that the range of assigned indices to a control is
continuous and does not overflow. Currently there are no checks to enforce this.
If a control with a overflowing index range is created that control becomes
effectively inaccessible and unremovable since snd_ctl_find_id() will not be
able to find it. This patch adds a check that makes sure that controls with a
overflowing index range can not be created.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/control.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index f92ca31..6919da7 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -342,6 +342,9 @@ int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
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
1.9.1

