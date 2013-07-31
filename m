Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760080Ab3GaNdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:33:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47114 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759743Ab3GaN0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:26:03 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.520884826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [41/84] ALSA: asihpi: Fix unlocked snd_pcm_stop() call
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 60478295d6876619f8f47f6d1a5c25eaade69ee3 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/pci/asihpi/asihpi.c | 3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -768,7 +768,10 @@ static void snd_card_asihpi_timer_functi
 						s->number);
 				ds->drained_count++;
 				if (ds->drained_count > 2) {
+					unsigned long flags;
+					snd_pcm_stream_lock_irqsave(s, flags);
 					snd_pcm_stop(s, SNDRV_PCM_STATE_XRUN);
+					snd_pcm_stream_unlock_irqrestore(s, flags);
 					continue;
 				}
 			} else {

