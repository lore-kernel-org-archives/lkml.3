Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934699Ab3GWWq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:46:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41619 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934119Ab3GWW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:27 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
Subject: [ 037/103] ALSA: asihpi: Fix unlocked snd_pcm_stop() call
Date: Tue, 23 Jul 2013 15:25:48 -0700
Message-Id: <20130723220422.715950080@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 60478295d6876619f8f47f6d1a5c25eaade69ee3 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/pci/asihpi/asihpi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/asihpi/asihpi.c
+++ b/sound/pci/asihpi/asihpi.c
@@ -769,7 +769,10 @@ static void snd_card_asihpi_timer_functi
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


