Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaHMSwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:52:46 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:34844
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751590AbaHMSwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:52:45 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, ttmesterr@gmail.com, dheitmueller@kernellabs.com,
        cb.xiong@samsung.com, yongjun_wei@trendmicro.com.cn
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: fix au0828 dvb suspend/resume to call dvb_frontend_suspend/resume
Date: Wed, 13 Aug 2014 12:52:39 -0600
Message-Id: <1407955959-7901-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

au0828 doesn't resume correctly and TV tuning fails with
xc_set_signal_source(0) failed message. Change au0828 dvb
suspend and resume interfaces to suspend and resume frontend
during suspend and resume respectively. dvb_frontend_suspend()
suspends tuner and fe using tuner and fe ops. dvb_frontend_resume()
resumes fe and tuner using fe and tuner ops ini before waking up
the frontend. With this change HVR950Q suspend and resume work
when system gets suspended when digital function is tuned to a
channel and with active TV stream, and after resume it went right
back to active TV stream.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/au0828/au0828-dvb.c |   47 ++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
index 821f86e..4bd9d68 100644
--- a/drivers/media/usb/au0828/au0828-dvb.c
+++ b/drivers/media/usb/au0828/au0828-dvb.c
@@ -620,34 +620,39 @@ int au0828_dvb_register(struct au0828_dev *dev)
 void au0828_dvb_suspend(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
+	int rc;
 
-	if (dvb->frontend && dev->urb_streaming) {
-		pr_info("stopping DVB\n");
-
-		cancel_work_sync(&dev->restart_streaming);
-
-		/* Stop transport */
-		mutex_lock(&dvb->lock);
-		stop_urb_transfer(dev);
-		au0828_stop_transport(dev, 1);
-		mutex_unlock(&dvb->lock);
-		dev->need_urb_start = 1;
+	if (dvb->frontend) {
+		if (dev->urb_streaming) {
+			cancel_work_sync(&dev->restart_streaming);
+			/* Stop transport */
+			mutex_lock(&dvb->lock);
+			stop_urb_transfer(dev);
+			au0828_stop_transport(dev, 1);
+			mutex_unlock(&dvb->lock);
+			dev->need_urb_start = 1;
+		}
+		/* suspend frontend - does tuner and fe to sleep */
+		rc = dvb_frontend_suspend(dvb->frontend);
+		pr_info("au0828_dvb_suspend(): Suspending DVB fe %d\n", rc);
 	}
 }
 
 void au0828_dvb_resume(struct au0828_dev *dev)
 {
 	struct au0828_dvb *dvb = &dev->dvb;
+	int rc;
 
-	if (dvb->frontend && dev->need_urb_start) {
-		pr_info("resuming DVB\n");
-
-		au0828_set_frontend(dvb->frontend);
-
-		/* Start transport */
-		mutex_lock(&dvb->lock);
-		au0828_start_transport(dev);
-		start_urb_transfer(dev);
-		mutex_unlock(&dvb->lock);
+	if (dvb->frontend) {
+		/* resume frontend - does fe and tuner init */
+		rc = dvb_frontend_resume(dvb->frontend);
+		pr_info("au0828_dvb_resume(): Resuming DVB fe %d\n", rc);
+		if (dev->need_urb_start) {
+			/* Start transport */
+			mutex_lock(&dvb->lock);
+			au0828_start_transport(dev);
+			start_urb_transfer(dev);
+			mutex_unlock(&dvb->lock);
+		}
 	}
 }
-- 
1.7.10.4

