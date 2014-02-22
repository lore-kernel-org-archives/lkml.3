Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbaBVAuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 19:50:54 -0500
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:55272 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932085AbaBVAus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 19:50:48 -0500
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: [RFC] [PATCH 4/6] media: em28xx-input - implement em28xx_ops: suspend/resume hooks
Date: Fri, 21 Feb 2014 17:50:16 -0700
Message-Id: <5dc00d657718dfefedb35b055abd13997afd6979.1393027856.git.shuah.kh@samsung.com>
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
 drivers/media/usb/em28xx/em28xx-input.c | 35 +++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 18f65d8..1227309 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -827,11 +827,46 @@ static int em28xx_ir_fini(struct em28xx *dev)
 	return 0;
 }
 
+static int em28xx_ir_suspend(struct em28xx *dev)
+{
+	struct em28xx_IR *ir = dev->ir;
+
+	if (dev->is_audio_only)
+		return 0;
+
+	em28xx_info("Suspending input extension");
+	cancel_delayed_work_sync(&ir->work);
+	cancel_delayed_work_sync(&dev->buttons_query_work);
+	/* is canceling delayed work sufficient or does the rc event
+	   kthread needs stopping? kthread is stopped in
+	   ir_raw_event_unregister() */
+	return 0;
+}
+
+static int em28xx_ir_resume(struct em28xx *dev)
+{
+	struct em28xx_IR *ir = dev->ir;
+
+	if (dev->is_audio_only)
+		return 0;
+
+	em28xx_info("Resuming input extension");
+	/* if suspend calls ir_raw_event_unregister(), the should call
+	   ir_raw_event_register() */
+	schedule_delayed_work_sync(&ir->work);
+	if (dev->num_button_polling_addresses)
+		schedule_delayed_work(&dev->buttons_query_work,
+			       msecs_to_jiffies(dev->button_polling_interval));
+	return 0;
+}
+
 static struct em28xx_ops rc_ops = {
 	.id   = EM28XX_RC,
 	.name = "Em28xx Input Extension",
 	.init = em28xx_ir_init,
 	.fini = em28xx_ir_fini,
+	.suspend = em28xx_ir_suspend,
+	.resume = em28xx_ir_resume,
 };
 
 static int __init em28xx_rc_register(void)
-- 
1.8.3.2

