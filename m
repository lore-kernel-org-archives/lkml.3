Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaEDQbm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:31:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbaEDPl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 116/158] media: em28xx-audio: fix user counting in snd_em28xx_capture_open()
Date: Sun,  4 May 2014 11:40:25 -0400
Message-Id: <20140504154045.770910920@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Schaefer <fschaefer.oss@googlemail.com>

commit 01ae3b51af7144ea29eb28ba718b65ad59ab9493 upstream.

dev->adev.users always needs to be increased when snd_em28xx_capture_open() is
called and succeeds.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/em28xx/em28xx-audio.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -252,7 +252,7 @@ static int snd_em28xx_capture_open(struc
 {
 	struct em28xx *dev = snd_pcm_substream_chip(substream);
 	struct snd_pcm_runtime *runtime = substream->runtime;
-	int ret = 0;
+	int nonblock, ret = 0;
 
 	if (!dev) {
 		em28xx_err("BUG: em28xx can't find device struct."
@@ -265,15 +265,15 @@ static int snd_em28xx_capture_open(struc
 
 	dprintk("opening device and trying to acquire exclusive lock\n");
 
+	nonblock = !!(substream->f_flags & O_NONBLOCK);
+	if (nonblock) {
+		if (!mutex_trylock(&dev->lock))
+		return -EAGAIN;
+	} else
+		mutex_lock(&dev->lock);
+
 	runtime->hw = snd_em28xx_hw_capture;
 	if ((dev->alt == 0 || dev->is_audio_only) && dev->adev.users == 0) {
-		int nonblock = !!(substream->f_flags & O_NONBLOCK);
-
-		if (nonblock) {
-			if (!mutex_trylock(&dev->lock))
-				return -EAGAIN;
-		} else
-			mutex_lock(&dev->lock);
 		if (dev->is_audio_only)
 			/* vendor audio is on a separate interface */
 			dev->alt = 1;
@@ -299,11 +299,11 @@ static int snd_em28xx_capture_open(struc
 		ret = em28xx_audio_analog_set(dev);
 		if (ret < 0)
 			goto err;
-
-		dev->adev.users++;
-		mutex_unlock(&dev->lock);
 	}
 
+	dev->adev.users++;
+	mutex_unlock(&dev->lock);
+
 	/* Dynamically adjust the period size */
 	snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
 	snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_PERIOD_BYTES,


