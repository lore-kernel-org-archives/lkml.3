Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbaCHBK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:10:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46694 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbaCHBIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:08:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>,
        Weng Meiling <wengmeiling.weng@huawei.com>
Subject: [PATCH 3.4 88/99] ALSA: asihpi: Fix unlocked snd_pcm_stop() call
Date: Fri,  7 Mar 2014 17:08:24 -0800
Message-Id: <20140308010614.398873070@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 60478295d6876619f8f47f6d1a5c25eaade69ee3 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>
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


