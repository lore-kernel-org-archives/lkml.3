Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760139Ab3GaNin (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:38:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47005 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759782Ab3GaNZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:57 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.902818046@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [49/84] staging: line6: Fix unlocked snd_pcm_stop() call
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

commit 86f0b5b86d142b9323432fef078a6cf0fb5dda74 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/line6/pcm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/staging/line6/pcm.c
+++ b/drivers/staging/line6/pcm.c
@@ -360,8 +360,11 @@ static int snd_line6_pcm_free(struct snd
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

