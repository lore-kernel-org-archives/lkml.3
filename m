Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab3CDDpy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:45:54 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33202 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757465Ab3CDDo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:56 -0500
Message-Id: <20130304033709.938916745@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:31 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Takashi Iwai <tiwai@suse.de>
Subject: [ 024/153] ALSA: aloop: Fix Oops while PM resume
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit edac894389f9c9de2a1368c78809c824b343f3a5 upstream.

snd-aloop driver has no proper PM implementation, thus the PM resume
may trigger Oops due to leftover timer instance.  This patch adds the
missing suspend/resume implementation.

Reported-and-tested-by: El boulangero <elboulangero@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/drivers/aloop.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/sound/drivers/aloop.c
+++ b/sound/drivers/aloop.c
@@ -287,12 +287,14 @@ static int loopback_trigger(struct snd_p
 			loopback_active_notify(dpcm);
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
+	case SNDRV_PCM_TRIGGER_SUSPEND:
 		spin_lock(&cable->lock);	
 		cable->pause |= stream;
 		spin_unlock(&cable->lock);
 		loopback_timer_stop(dpcm);
 		break;
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
+	case SNDRV_PCM_TRIGGER_RESUME:
 		spin_lock(&cable->lock);
 		dpcm->last_jiffies = jiffies;
 		cable->pause &= ~stream;
@@ -552,7 +554,8 @@ static snd_pcm_uframes_t loopback_pointe
 static struct snd_pcm_hardware loopback_pcm_hardware =
 {
 	.info =		(SNDRV_PCM_INFO_INTERLEAVED | SNDRV_PCM_INFO_MMAP |
-			 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_PAUSE),
+			 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_PAUSE |
+			 SNDRV_PCM_INFO_RESUME),
 	.formats =	(SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S16_BE |
 			 SNDRV_PCM_FMTBIT_S32_LE | SNDRV_PCM_FMTBIT_S32_BE |
 			 SNDRV_PCM_FMTBIT_FLOAT_LE | SNDRV_PCM_FMTBIT_FLOAT_BE),


