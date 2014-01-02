Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaABMJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:09:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:50069 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbaABMIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH, RFC 25/30] oss: vwsnd: avoid interruptible_sleep_on
Date: Thu,  2 Jan 2014 13:07:49 +0100
Message-Id: <1388664474-1710039-26-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:LZhp4SKezyYY+53agrp94u8y8fqvkxLEVbfPuKnXSGY
 zulqsrMABpde+Itd/xPbDFXwEORBJixVT32NjelyCDVmPrx+Pn
 N1T5ryDqyUF+rNDKaXRfKBWnPSs3juAsM4NheWdgYB/VssX9xe
 9EgFn8IoIRKdQ7vIGmNdljcuPCfAyLROmrUhjlhcm5iHL3NvhT
 rdS39kCtQc8HW+Yktou6sDyPKVFfBFTJt/fu9WC60ieZ9m3TrS
 MGlpQhHo+snbMgTY1iQ4pvaTM0/0C/VoNa1JVWzkVjOru4rnrj
 Ty3zT+NNto6B9gqbflkjHoyu/wRFEl/wy0LrIL4B9vAzdSi080
 IsYQAgZptKIcXOCsFtqQD+qzV9lQyMga8vCVXH7vo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Interruptible_sleep_on is racy and we want to remove it. This replaces
the use in the vwsnd driver with an open-coded prepare_to_wait
loop that fixes the race between concurrent open() and close() calls,
and also drops the global mutex while waiting here, which restores
the original behavior that was changed during the BKL removal.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
 sound/oss/vwsnd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 4bbcc0f..a077e9c 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -2921,6 +2921,7 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 	vwsnd_dev_t *devc;
 	int minor = iminor(inode);
 	int sw_samplefmt;
+	DEFINE_WAIT(wait);
 
 	DBGE("(inode=0x%p, file=0x%p)\n", inode, file);
 
@@ -2937,21 +2938,26 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 	}
 
 	mutex_lock(&devc->open_mutex);
-	while (devc->open_mode & file->f_mode) {
+	while (1) {
+		prepare_to_wait(&devc->open_wait, &wait, TASK_INTERRUPTIBLE);
+		if (!(devc->open_mode & file->f_mode))
+			break;
+
 		mutex_unlock(&devc->open_mutex);
+		mutex_unlock(&vwsnd_mutex);
 		if (file->f_flags & O_NONBLOCK) {
 			DEC_USE_COUNT;
-			mutex_unlock(&vwsnd_mutex);
 			return -EBUSY;
 		}
-		interruptible_sleep_on(&devc->open_wait);
+		schedule();
 		if (signal_pending(current)) {
 			DEC_USE_COUNT;
-			mutex_unlock(&vwsnd_mutex);
 			return -ERESTARTSYS;
 		}
+		mutex_lock(&vwsnd_mutex);
 		mutex_lock(&devc->open_mutex);
 	}
+	finish_wait(&devc->open_wait, &wait);
 	devc->open_mode |= file->f_mode & (FMODE_READ | FMODE_WRITE);
 	mutex_unlock(&devc->open_mutex);
 
-- 
1.8.3.2

