Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbaDJEK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:10:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41091 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934628AbaDJDWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>, Ben Hutchings <ben@decadent.org.uk>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 051/134] ALSA: aloop: Fix Oops while PM resume
Date: Wed,  9 Apr 2014 20:22:47 -0700
Message-Id: <20140410032306.664214845@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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


