Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaBVAus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:50:48 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:52517 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754517AbaBVAup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:50:45 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC] [PATCH 2/6] media: em28xx-audio - implement em28xx_ops: suspend/resume hooks
Date: Fri, 21 Feb 2014 17:50:14 -0700
Message-Id: <38a429856e5ef8a93a4e2b29066f3f36cceeec8a.1393027856.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1393027856.git.shuah.kh@samsung.com>
References: <cover.1393027856.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement em28xx_ops: suspend/resume hooks. em28xx usb driver will
invoke em28xx_ops: suspend and resume hooks for all its extensions
from its suspend() and resume() interfaces.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-audio.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 05e9bd1..a4d159d 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -989,11 +989,41 @@ static int em28xx_audio_fini(struct em28xx *dev)
 	return 0;
 }
 
+static int em28xx_audio_suspend(struct em28xx *dev)
+{
+	if (dev == NULL)
+		return 0;
+
+	if (!dev->has_alsa_audio)
+		return 0;
+
+	em28xx_info("Suspending audio extension");
+	em28xx_deinit_isoc_audio(dev);
+	atomic_set(&dev->stream_started, 0);
+	return 0;
+}
+
+static int em28xx_audio_resume(struct em28xx *dev)
+{
+	if (dev == NULL)
+		return 0;
+
+	if (!dev->has_alsa_audio)
+		return 0;
+
+	em28xx_info("Resuming audio extension");
+	/* Nothing to do other than schedule_work() ?? */
+	schedule_work(&dev->wq_trigger);
+	return 0;
+}
+
 static struct em28xx_ops audio_ops = {
 	.id   = EM28XX_AUDIO,
 	.name = "Em28xx Audio Extension",
 	.init = em28xx_audio_init,
 	.fini = em28xx_audio_fini,
+	.suspend = em28xx_audio_suspend,
+	.resume = em28xx_audio_resume,
 };
 
 static int __init em28xx_alsa_register(void)
-- 
1.8.3.2

