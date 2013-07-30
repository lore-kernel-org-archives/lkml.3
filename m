Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844Ab3G3Jxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:53:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53062 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695Ab3G3Jcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 033/106] staging: line6: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 10:30:52 +0100
Message-Id: <1375176725-5825-34-git-send-email-luis.henriques@canonical.com>
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

commit 86f0b5b86d142b9323432fef078a6cf0fb5dda74 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/staging/line6/pcm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
index 5e319e3..01f00fd 100644
--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -378,8 +378,11 @@ static int snd_line6_pcm_free(struct snd_device *device)
 */
 static void pcm_disconnect_substream(struct snd_pcm_substream *substream)
 {
-	if (substream->runtime && snd_pcm_running(substream))
+	if (substream->runtime && snd_pcm_running(substream)) {
+		snd_pcm_stream_lock_irq(substream);
 		snd_pcm_stop(substream, SNDRV_PCM_STATE_DISCONNECTED);
+		snd_pcm_stream_unlock_irq(substream);
+	}
 }
 
 /*
-- 
1.8.3.2

