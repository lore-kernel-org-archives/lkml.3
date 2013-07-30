Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab3G3JyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:54:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53058 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689Ab3G3Jcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 032/106] [media] saa7134: Fix unlocked snd_pcm_stop() call
Date: Tue, 30 Jul 2013 10:30:51 +0100
Message-Id: <1375176725-5825-33-git-send-email-luis.henriques@canonical.com>
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

commit e6355ad7b1c6f70e2f48ae159f5658b441ccff95 upstream.

snd_pcm_stop() must be called in the PCM substream lock context.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ luis: backported to 3.5:
  - drivers/media/pci/saa7134/saa7134-alsa.c -> drivers/media/video/saa7134/saa7134-alsa.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/video/saa7134/saa7134-alsa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/video/saa7134/saa7134-alsa.c b/drivers/media/video/saa7134/saa7134-alsa.c
index 10460fd..dbcdfbf 100644
--- a/drivers/media/video/saa7134/saa7134-alsa.c
+++ b/drivers/media/video/saa7134/saa7134-alsa.c
@@ -172,7 +172,9 @@ static void saa7134_irq_alsa_done(struct saa7134_dev *dev,
 		dprintk("irq: overrun [full=%d/%d] - Blocks in %d\n",dev->dmasound.read_count,
 			dev->dmasound.bufsize, dev->dmasound.blocks);
 		spin_unlock(&dev->slock);
+		snd_pcm_stream_lock(dev->dmasound.substream);
 		snd_pcm_stop(dev->dmasound.substream,SNDRV_PCM_STATE_XRUN);
+		snd_pcm_stream_unlock(dev->dmasound.substream);
 		return;
 	}
 
-- 
1.8.3.2

