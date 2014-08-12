Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbaHLDOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 23:14:03 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:49099
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754207AbaHLDOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 23:14:00 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, ttmesterr@gmail.com, dheitmueller@kernellabs.com,
        cb.xiong@samsung.com, yongjun_wei@trendmicro.com.cn
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: fix au0828 dvb suspend/resume to call dvb_frontend_suspend/resume
Date: Mon, 11 Aug 2014 21:13:55 -0600
Message-Id: <1407813235-30435-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au0828 doesn't resume correctly and TV tuning fails with
xc_set_signal_source(0) failed message. Change au0828 dvb
suspend and resume interfaces to suspend and resume frontend
during suspend and resume respectively. au0828_dvb_suspend()
calls dvb_frontend_suspend() which in turn invokes tuner ops
sleep followed by fe ops sleep. au0828_dvb_resume() calls
dvb_frontend_resume() which in turn calls fe ops ini follwed
by tuner ops ini before waking up the frontend. With this change
HVR950Q suspend and resume work when system gets suspended when
digital function is tuned to a channel and with active TV stream,
and after resume it went right back to active TV stream.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c |   37 ++++++++++++++-------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 821f86e..50e7c82 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -619,35 +619,30 @@ int au0828_dvb_register(struct au0828_dev *dev)
 
 void au0828_dvb_suspend(struct au0828_dev *dev)
 {
-	struct au0828_dvb *dvb = &dev->dvb;
-
-	if (dvb->frontend && dev->urb_streaming) {
-		pr_info("stopping DVB\n");
+	struct au0828_dvb *dvb;
+	int rc;
 
-		cancel_work_sync(&dev->restart_streaming);
+	if (dev == NULL)
+		return;
 
-		/* Stop transport */
-		mutex_lock(&dvb->lock);
-		stop_urb_transfer(dev);
-		au0828_stop_transport(dev, 1);
-		mutex_unlock(&dvb->lock);
-		dev->need_urb_start = 1;
+	dvb = &dev->dvb;
+	if (dvb->frontend) {
+		rc = dvb_frontend_suspend(dvb->frontend);
+		pr_info("au0828_dvb_suspend(): Suspending DVB fe %d\n", rc);
 	}
 }
 
 void au0828_dvb_resume(struct au0828_dev *dev)
 {
-	struct au0828_dvb *dvb = &dev->dvb;
-
-	if (dvb->frontend && dev->need_urb_start) {
-		pr_info("resuming DVB\n");
+	struct au0828_dvb *dvb;
+	int rc;
 
-		au0828_set_frontend(dvb->frontend);
+	if (dev == NULL)
+		return;
 
-		/* Start transport */
-		mutex_lock(&dvb->lock);
-		au0828_start_transport(dev);
-		start_urb_transfer(dev);
-		mutex_unlock(&dvb->lock);
+	dvb = &dev->dvb;
+	if (dvb->frontend) {
+		rc = dvb_frontend_resume(dvb->frontend);
+		pr_info("au0828_dvb_resume(): Resuming DVB fe %d\n", rc);
 	}
 }
-- 
1.7.10.4

