Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269AbaGCJaH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:30:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52609 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbaGCJZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 182/198] ALSA: control: Handle numid overflow
Date: Thu,  3 Jul 2014 10:20:25 +0100
Message-Id: <1404379241-8590-183-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/control.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/sound/core/control.c b/sound/core/control.c
index d4a597fe86e4..93215b4bec6b 100644
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

