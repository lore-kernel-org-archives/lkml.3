Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab3G3J4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:56:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53027 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab3G3Jci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 025/106] ALSA: asihpi: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 10:30:44 +0100
Message-Id: <1375176725-5825-26-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 60478295d6876619f8f47f6d1a5c25eaade69ee3 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/pci/asihpi/asihpi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/asihpi/asihpi.c b/sound/pci/asihpi/asihpi.c
index e8de831..05093bd 100644
--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -769,7 +769,10 @@ static void snd_card_asihpi_timer_function(unsigned long data)
 						s->number);
 				ds->drained_count++;
 				if (ds->drained_count > 20) {
+					unsigned long flags;
+					snd_pcm_stream_lock_irqsave(s, flags);
 					snd_pcm_stop(s, SNDRV_PCM_STATE_XRUN);
+					snd_pcm_stream_unlock_irqrestore(s, flags);
 					continue;
 				}
 			} else {
-- 
1.8.3.2

