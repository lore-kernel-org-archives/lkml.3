Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965019AbaFXQvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:51:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60811 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbaFXPvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:51:46 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.4 23/26] ALSA: control: Make sure that id->index does not overflow
Date: Tue, 24 Jun 2014 11:50:46 -0400
Message-Id: <20140624154620.597923994@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154619.499002156@linuxfoundation.org>
References: <20140624154619.499002156@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/control.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -341,6 +341,9 @@ int snd_ctl_add(struct snd_card *card, s
 	if (snd_BUG_ON(!card || !kcontrol->info))
 		goto error;
 	id = kcontrol->id;
+	if (id.index > UINT_MAX - kcontrol->count)
+		goto error;
+
 	down_write(&card->controls_rwsem);
 	if (snd_ctl_find_id(card, &id)) {
 		up_write(&card->controls_rwsem);


