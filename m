Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055AbaGOVjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:39:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55012 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934025AbaGOVjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:39:01 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 161/198] ALSA: control: Handle numid overflow
Date: Tue, 15 Jul 2014 14:30:31 -0700
Message-Id: <1405459868-15089-162-git-send-email-kamal@canonical.com>
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

commit ac902c112d90a89e59916f751c2745f4dbdbb4bd upstream.

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
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/control.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index d4a597f..93215b4 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -289,6 +289,10 @@ static bool snd_ctl_remove_numid_conflict(struct snd_card *card,
 {
 	struct snd_kcontrol *kctl;
 
+	/* Make sure that the ids assigned to the control do not wrap around */
+	if (card->last_numid >= UINT_MAX - count)
+		card->last_numid = 0;
+
 	list_for_each_entry(kctl, &card->controls, list) {
 		if (kctl->id.numid < card->last_numid + 1 + count &&
 		    kctl->id.numid + kctl->count > card->last_numid + 1) {
-- 
1.9.1

