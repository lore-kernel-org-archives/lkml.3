Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbaF3MIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:08:40 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52017 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753603AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 081/181] ALSA: control: Make sure that id->index does not overflow
Date: Mon, 30 Jun 2014 13:51:42 +0200
Message-Id: <588359949fc0bd01b65fb86469016650f95f4cc6.1404128998.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 sound/core/control.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index 93215b4bec6b..98a29b26c5f4 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -343,6 +343,9 @@ int snd_ctl_add(struct snd_card *card, struct snd_kcontrol *kcontrol)
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
2.0.0

