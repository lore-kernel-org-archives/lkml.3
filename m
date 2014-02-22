Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaBVAvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:51:50 -0500
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:47390 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754850AbaBVAur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:50:47 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC] [PATCH 3/6] media: em28xx-dvb - implement em28xx_ops: suspend/resume hooks
Date: Fri, 21 Feb 2014 17:50:15 -0700
Message-Id: <74266fe7e75a22f009fbf0b1e58df359f19cfee4.1393027856.git.shuah.kh@samsung.com>
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
 drivers/media/usb/em28xx/em28xx-dvb.c | 57 +++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a0a669e..736b674 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1492,11 +1492,68 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	return 0;
 }
 
+static int em28xx_dvb_suspend(struct em28xx *dev)
+{
+	int ret = 0;
+
+	if (dev->is_audio_only)
+		return 0;
+
+	if (!dev->board.has_dvb)
+		return 0;
+
+	em28xx_info("Suspending DVB extension");
+	if (dev->dvb) {
+		struct em28xx_dvb *dvb = dev->dvb;
+
+		if (dvb->fe[0]) {
+			ret = dvb_frontend_suspend(dvb->fe[0]);
+			em28xx_info("fe0 suspend %d", ret);
+		}
+		if (dvb->fe[1]) {
+			dvb_frontend_suspend(dvb->fe[1]);
+			em28xx_info("fe1 suspend %d", ret);
+		}
+	}
+
+	return 0;
+}
+
+static int em28xx_dvb_resume(struct em28xx *dev)
+{
+	int ret = 0;
+
+	if (dev->is_audio_only)
+		return 0;
+
+	if (!dev->board.has_dvb)
+		return 0;
+
+	em28xx_info("Resuming DVB extension");
+	if (dev->dvb) {
+		struct em28xx_dvb *dvb = dev->dvb;
+
+		if (dvb->fe[0]) {
+			ret = dvb_frontend_resume(dvb->fe[0]);
+			em28xx_info("fe0 resume %d", ret);
+		}
+
+		if (dvb->fe[1]) {
+			ret = dvb_frontend_resume(dvb->fe[1]);
+			em28xx_info("fe1 resume %d", ret);
+		}
+	}
+
+	return 0;
+}
+
 static struct em28xx_ops dvb_ops = {
 	.id   = EM28XX_DVB,
 	.name = "Em28xx dvb Extension",
 	.init = em28xx_dvb_init,
 	.fini = em28xx_dvb_fini,
+	.suspend = em28xx_dvb_suspend,
+	.resume = em28xx_dvb_resume,
 };
 
 static int __init em28xx_dvb_register(void)
-- 
1.8.3.2

